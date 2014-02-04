Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaBDQAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:00:05 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:50756 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaBDP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:56 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 14/17] i2c: nomadik: Fixup deployment of runtime PM
Date: Tue,  4 Feb 2014 16:58:55 +0100
Message-Id: <1391529538-21685-15-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the device is active while a successful probe has been completed,
the reference counting for the clock will be screwed up and never reach
zero.

The issue is resolved by implementing runtime PM callbacks and let them
handle the resources accordingly, including the clock.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   47 ++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 0caa8ea..2d7dbc9 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -674,7 +674,7 @@ static int nmk_i2c_xfer_one(struct nmk_i2c_dev *dev, u16 flags)
 static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 		struct i2c_msg msgs[], int num_msgs)
 {
-	int status;
+	int status = 0;
 	int i;
 	struct nmk_i2c_dev *dev = i2c_get_adapdata(i2c_adap);
 	int j;
@@ -683,19 +683,6 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 
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
@@ -716,12 +703,6 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
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
@@ -938,6 +919,29 @@ static int nmk_i2c_resume(struct device *dev)
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
+
+	clk_prepare_enable(nmk_i2c->clk);
+	pinctrl_pm_select_default_state(dev);
+	init_hw(nmk_i2c);
+	return 0;
+}
+#endif
+
 /*
  * We use noirq so that we suspend late and resume before the wakeup interrupt
  * to ensure that we do the !pm_runtime_suspended() check in resume before
@@ -946,6 +950,9 @@ static int nmk_i2c_resume(struct device *dev)
 static const struct dev_pm_ops nmk_i2c_pm = {
 	.suspend_noirq	= nmk_i2c_suspend,
 	.resume_noirq	= nmk_i2c_resume,
+	SET_PM_RUNTIME_PM_OPS(nmk_i2c_runtime_suspend,
+			nmk_i2c_runtime_resume,
+			NULL)
 };
 
 static unsigned int nmk_i2c_functionality(struct i2c_adapter *adap)
-- 
1.7.9.5

