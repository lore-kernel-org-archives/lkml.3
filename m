Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbbASQDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:03:47 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8294 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbbASQDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:03:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e5-54bd2adf8138
From: Paul Osmialowski <p.osmialowsk@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [PATCH] i2c: s3c2410: fix ABBA deadlock by keeping clock prepared
Date: Mon, 19 Jan 2015 17:03:33 +0100
Message-id: <1421683413-27075-1-git-send-email-p.osmialowsk@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xa7r3tfaGGNxpZbbYOGM9q8XUh0/Y
	LPofv2a26Pj7hdHi8q45bBYzzu9jspjw5gCzxaS1UxktVu36w2ix8sQsZgcuj52z7rJ7bFrV
	yebR2/yOzaNvyypGj5OnnrB4fN4kF8AWxWWTkpqTWZZapG+XwJWxufcGY8EWtYr2gy4NjMvl
	uxg5OSQETCRWNyxggbDFJC7cW8/WxcjFISSwlFFi0YHljBBOL5NEx8c5TCBVbAKGEjf/HwZL
	iAjMZpL4teYGexcjBwezQLrEl1NmIDXCAl4SP57sYQaxWQRUJRYfvwRm8wp4SPw83MAMsU1O
	4uSxyawTGLkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJpi87GBcfszrEKMDBqMTD
	q5GzJ0SINbGsuDL3EKMEB7OSCG/AF6AQb0piZVVqUX58UWlOavEhRiYOTqkGxqZ3FhmlJ7Pn
	5dbPnSDhsK+4fPFe0Y1XcxZ8K9Rz3/W0htH0RwSL8tZtqzmM5H3/aovG7FN1XtsRV3SBJcFQ
	qFGd6Yf49fNyadL9byLuXz/16Mfzxb3aZums6/J8M//Oj/9rP2XdkoL9d4/zvV59V3axh1ja
	9BMxjzo9uWbPzP7ptumTu8YNKSWW4oxEQy3mouJEABRVHn4EAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves deadlock between clock prepare mutex and regmap mutex reported
by Tomasz Figa in [1] by implementing solution from [2]: "always leave the clock
of the i2c controller in a prepared state".

[1] https://lkml.org/lkml/2014/7/2/171
[2] https://lkml.org/lkml/2014/7/2/207

On each i2c transfer handled by s3c24xx_i2c_xfer(), clk_prepare_enable() was
called, which calls clk_prepare() then clk_enable(). clk_prepare() takes
prepare_lock mutex before proceeding. Note that i2c transfer functions are
invoked from many places in kernel, typically with some other additional lock
held.

It may happen that function on CPU1 (e.g. regmap_update_bits()) has taken a
mutex (i.e. regmap lock mutex) then it attempts i2c communication in order to
proceed (so it needs to obtain clock related prepare_lock mutex during transfer
preparation stage due to clk_prepare() call). At the same time other task on
CPU0 wants to operate on clock (e.g. to (un)prepare clock for some other reason)
so it has taken prepare_lock mutex.

CPU0:                        CPU1:
clk_disable_unused()         regulator_disable()
  clk_prepare_lock()           map->lock(map->lock_arg)
  regmap_read()                s3c24xx_i2c_xfer()
    map->lock(map->lock_arg)     clk_prepare_lock()

Implemented solution from [2] leaves i2c clock prepared. Preparation is done in
s3c24xx_i2c_probe() function. Without this patch, it is immediately unprepared
by clk_disable_unprepare() call. I've replaced this call with clk_disable() and
I've added clk_unprepare() call in s3c24xx_i2c_remove().

The s3c24xx_i2c_xfer() function now uses clk_enable() instead of
clk_prepare_enable() (and clk_disable() instead of clk_unprepare_disable()).

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bff20a5..958c8db 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -785,14 +785,16 @@ static int s3c24xx_i2c_xfer(struct i2c_adapter *adap,
 	int ret;
 
 	pm_runtime_get_sync(&adap->dev);
-	clk_prepare_enable(i2c->clk);
+	ret = clk_enable(i2c->clk);
+	if (ret)
+		return ret;
 
 	for (retry = 0; retry < adap->retries; retry++) {
 
 		ret = s3c24xx_i2c_doxfer(i2c, msgs, num);
 
 		if (ret != -EAGAIN) {
-			clk_disable_unprepare(i2c->clk);
+			clk_disable(i2c->clk);
 			pm_runtime_put(&adap->dev);
 			return ret;
 		}
@@ -802,7 +804,7 @@ static int s3c24xx_i2c_xfer(struct i2c_adapter *adap,
 		udelay(100);
 	}
 
-	clk_disable_unprepare(i2c->clk);
+	clk_disable(i2c->clk);
 	pm_runtime_put(&adap->dev);
 	return -EREMOTEIO;
 }
@@ -1197,7 +1199,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	clk_prepare_enable(i2c->clk);
 	ret = s3c24xx_i2c_init(i2c);
-	clk_disable_unprepare(i2c->clk);
+	clk_disable(i2c->clk);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "I2C controller init failed\n");
 		return ret;
@@ -1210,6 +1212,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		i2c->irq = ret = platform_get_irq(pdev, 0);
 		if (ret <= 0) {
 			dev_err(&pdev->dev, "cannot find IRQ\n");
+			clk_unprepare(i2c->clk);
 			return ret;
 		}
 
@@ -1218,6 +1221,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 		if (ret != 0) {
 			dev_err(&pdev->dev, "cannot claim IRQ %d\n", i2c->irq);
+			clk_unprepare(i2c->clk);
 			return ret;
 		}
 	}
@@ -1225,6 +1229,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	ret = s3c24xx_i2c_register_cpufreq(i2c);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register cpufreq notifier\n");
+		clk_unprepare(i2c->clk);
 		return ret;
 	}
 
@@ -1241,6 +1246,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
 		s3c24xx_i2c_deregister_cpufreq(i2c);
+		clk_unprepare(i2c->clk);
 		return ret;
 	}
 
@@ -1262,6 +1268,8 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 {
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
+	clk_unprepare(i2c->clk);
+
 	pm_runtime_disable(&i2c->adap.dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -1293,13 +1301,16 @@ static int s3c24xx_i2c_resume_noirq(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
+	int ret;
 
 	if (!IS_ERR(i2c->sysreg))
 		regmap_write(i2c->sysreg, EXYNOS5_SYS_I2C_CFG, i2c->sys_i2c_cfg);
 
-	clk_prepare_enable(i2c->clk);
+	ret = clk_enable(i2c->clk);
+	if (ret)
+		return ret;
 	s3c24xx_i2c_init(i2c);
-	clk_disable_unprepare(i2c->clk);
+	clk_disable(i2c->clk);
 	i2c->suspended = 0;
 
 	return 0;
-- 
1.9.1

