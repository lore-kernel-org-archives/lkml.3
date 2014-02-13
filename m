Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaBMOJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:09:22 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:46459 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaBMOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:09:18 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 14/17] i2c: nomadik: Fixup deployment of runtime PM
Date: Thu, 13 Feb 2014 15:09:04 +0100
Message-Id: <1392300547-23365-3-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
References: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the runtime PM state is expected to be active according to the
amba bus, we must align our behaviour while probing to it.

Moreover, this is needed to be able to have the driver fully functional
without depending on CONFIG_RUNTIME_PM.

Since the device is active while a successful probe has been completed,
the reference counting for the clock will be screwed up and never reach
zero. We resolve this by implementing runtime PM callbacks and let them
handle the resources accordingly, including the clock.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---

Changes in v2:
	Rebased on top of latest i2c-nomadik branch.
	Squashed with PATCH 13/17 from previous version.
	Add error handling to align to previous behavior.

---
 drivers/i2c/busses/i2c-nomadik.c |   77 +++++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index d800d0f..01b78df 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -666,7 +666,7 @@ static int nmk_i2c_xfer_one(struct nmk_i2c_dev *dev, u16 flags)
 static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 		struct i2c_msg msgs[], int num_msgs)
 {
-	int status;
+	int status = 0;
 	int i;
 	struct nmk_i2c_dev *dev = i2c_get_adapdata(i2c_adap);
 	int j;
@@ -675,19 +675,6 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 	pm_runtime_get_sync(&dev->adev->dev);
 
-	status = clk_prepare_enable(dev->clk);
-	if (status) {
-		dev_err(&dev->adev->dev, "can't prepare_enable clock\n");
-		goto out_clk;
-	}
-
-	/* Optionaly enable pins to be muxed in and configured */
-	pinctrl_pm_select_default_state(&dev->adev->dev);
-
-	status = init_hw(dev);
-	if (status)
-		goto out;
-
 	/* Attempt three times to send the message queue */
 	for (j = 0; j < 3; j++) {
 		/* setup the i2c controller */
@@ -708,12 +695,6 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 			break;
 	}
 
-out:
-	clk_disable_unprepare(dev->clk);
-out_clk:
-	/* Optionally let pins go into idle state */
-	pinctrl_pm_select_idle_state(&dev->adev->dev);
-
 	pm_runtime_put_sync(&dev->adev->dev);
 
 	dev->busy = false;
@@ -930,6 +911,41 @@ static int nmk_i2c_resume(struct device *dev)
 #define nmk_i2c_resume	NULL
 #endif
 
+#if CONFIG_PM
+static int nmk_i2c_runtime_suspend(struct device *dev)
+{
+	struct amba_device *adev = to_amba_device(dev);
+	struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
+
+	clk_disable_unprepare(nmk_i2c->clk);
+	pinctrl_pm_select_idle_state(dev);
+	return 0;
+}
+
+static int nmk_i2c_runtime_resume(struct device *dev)
+{
+	struct amba_device *adev = to_amba_device(dev);
+	struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
+	int ret;
+
+	ret = clk_prepare_enable(nmk_i2c->clk);
+	if (ret) {
+		dev_err(dev, "can't prepare_enable clock\n");
+		return ret;
+	}
+
+	pinctrl_pm_select_default_state(dev);
+
+	ret = init_hw(nmk_i2c);
+	if (ret) {
+		clk_disable_unprepare(nmk_i2c->clk);
+		pinctrl_pm_select_idle_state(dev);
+	}
+
+	return ret;
+}
+#endif
+
 /*
  * We use noirq so that we suspend late and resume before the wakeup interrupt
  * to ensure that we do the !pm_runtime_suspended() check in resume before
@@ -938,6 +954,9 @@ static int nmk_i2c_resume(struct device *dev)
 static const struct dev_pm_ops nmk_i2c_pm = {
 	.suspend_noirq	= nmk_i2c_suspend,
 	.resume_noirq	= nmk_i2c_resume,
+	SET_PM_RUNTIME_PM_OPS(nmk_i2c_runtime_suspend,
+			nmk_i2c_runtime_resume,
+			NULL)
 };
 
 static unsigned int nmk_i2c_functionality(struct i2c_adapter *adap)
@@ -1006,11 +1025,6 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 
 	amba_set_drvdata(adev, dev);
 
-	/* Select default pin state */
-	pinctrl_pm_select_default_state(&adev->dev);
-	/* If possible, let's go to idle until the first transfer */
-	pinctrl_pm_select_idle_state(&adev->dev);
-
 	dev->virtbase = devm_ioremap(&adev->dev, adev->res.start,
 				resource_size(&adev->res));
 	if (!dev->virtbase) {
@@ -1035,6 +1049,14 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
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
@@ -1054,13 +1076,15 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
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
@@ -1077,6 +1101,7 @@ static int nmk_i2c_remove(struct amba_device *adev)
 	clear_all_interrupts(dev);
 	/* disable the controller */
 	i2c_clr_bit(dev->virtbase + I2C_CR, I2C_CR_PE);
+	clk_disable_unprepare(dev->clk);
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 
-- 
1.7.9.5

