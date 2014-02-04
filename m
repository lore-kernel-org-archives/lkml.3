Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaBDQAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:00:08 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59352 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaBDP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:54 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 13/17] i2c: nomadik: Leave probe with the device in active state
Date: Tue,  4 Feb 2014 16:58:54 +0100
Message-Id: <1391529538-21685-14-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the runtime PM state is expected to be active according to the
amba bus, we must align our behaviour while probing to it.

Moreover, this is needed to be able to have the driver fully functional
without depending on CONFIG_RUNTIME_PM.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 42c9e51..0caa8ea 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -1026,11 +1026,6 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	dev->adev = adev;
 	amba_set_drvdata(adev, dev);
 
-	/* Select default pin state */
-	pinctrl_pm_select_default_state(&adev->dev);
-	/* If possible, let's go to idle until the first transfer */
-	pinctrl_pm_select_idle_state(&adev->dev);
-
 	dev->virtbase = devm_ioremap(&adev->dev, adev->res.start,
 				resource_size(&adev->res));
 	if (!dev->virtbase) {
@@ -1055,6 +1050,14 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_no_mem;
 	}
 
+	ret = clk_prepare_enable(dev->clk);
+	if (ret) {
+		dev_err(&adev->dev, "can't prepare_enable clock\n");
+		goto err_no_mem;
+	}
+
+	init_hw(dev);
+
 	adap = &dev->adap;
 	adap->dev.of_node = np;
 	adap->dev.parent = &adev->dev;
@@ -1080,13 +1083,15 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	ret = i2c_add_adapter(adap);
 	if (ret) {
 		dev_err(&adev->dev, "failed to add adapter\n");
-		goto err_no_mem;
+		goto err_no_adap;
 	}
 
 	pm_runtime_put(&adev->dev);
 
 	return 0;
 
+ err_no_adap:
+	clk_disable_unprepare(dev->clk);
  err_no_mem:
 
 	return ret;
@@ -1103,6 +1108,7 @@ static int nmk_i2c_remove(struct amba_device *adev)
 	clear_all_interrupts(dev);
 	/* disable the controller */
 	i2c_clr_bit(dev->virtbase + I2C_CR, I2C_CR_PE);
+	clk_disable_unprepare(dev->clk);
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 
-- 
1.7.9.5

