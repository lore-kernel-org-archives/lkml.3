Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbaGQOtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:49:18 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:41757 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488AbaGQOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:49:14 -0400
From: Bastian Hecht <hechtb@gmail.com>
To: linux-i2c@vger.kernel.org
Cc: Linux-SH <linux-sh@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        Bastian Hecht <hechtb@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/5] i2c: exynos5: Remove suspension check
Date: Thu, 17 Jul 2014 16:48:38 +0200
Message-Id: <1405608520-5644-3-git-send-email-hechtb@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now take care of suspension in the i2c core code. So we can remove this
check here.

Signed-off-by: Bastian Hecht <hechtb@gmail.com>
---
same as v1

 drivers/i2c/busses/i2c-exynos5.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 63d2292..a80cf28 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -145,7 +145,6 @@
 
 struct exynos5_i2c {
 	struct i2c_adapter	adap;
-	unsigned int		suspended:1;
 
 	struct i2c_msg		*msg;
 	struct completion	msg_complete;
@@ -610,11 +609,6 @@ static int exynos5_i2c_xfer(struct i2c_adapter *adap,
 	struct exynos5_i2c *i2c = adap->algo_data;
 	int i = 0, ret = 0, stop = 0;
 
-	if (i2c->suspended) {
-		dev_err(i2c->dev, "HS-I2C is not initialized.\n");
-		return -EIO;
-	}
-
 	clk_prepare_enable(i2c->clk);
 
 	for (i = 0; i < num; i++, msgs++) {
@@ -757,16 +751,6 @@ static int exynos5_i2c_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int exynos5_i2c_suspend_noirq(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
-
-	i2c->suspended = 1;
-
-	return 0;
-}
-
 static int exynos5_i2c_resume_noirq(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -783,14 +767,12 @@ static int exynos5_i2c_resume_noirq(struct device *dev)
 
 	exynos5_i2c_init(i2c);
 	clk_disable_unprepare(i2c->clk);
-	i2c->suspended = 0;
 
 	return 0;
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(exynos5_i2c_dev_pm_ops, exynos5_i2c_suspend_noirq,
-			 exynos5_i2c_resume_noirq);
+static SIMPLE_DEV_PM_OPS(exynos5_i2c_dev_pm_ops, exynos5_i2c_resume_noirq);
 
 static struct platform_driver exynos5_i2c_driver = {
 	.probe		= exynos5_i2c_probe,
-- 
1.9.1

