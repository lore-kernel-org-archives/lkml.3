Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3FEOTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:19:16 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:41228 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875Ab3FEOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:19:14 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3/3] i2c: nomadik: use pinctrl PM helpers
Date: Wed, 5 Jun 2013 15:44:33 +0200
Message-ID: <1370439873-30053-3-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This utilize the new pinctrl core PM helpers to transition
the driver to "sleep" and "idle" states, cutting away some
boilerplate code.

Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
I'm seeking Wolfram's ACK on this to take it through the
pinctrl tree in the end.
---
 drivers/i2c/busses/i2c-nomadik.c | 90 +++++-----------------------------------
 1 file changed, 10 insertions(+), 80 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 650293f..c7e3b0c 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -148,10 +148,6 @@ struct i2c_nmk_client {
  * @stop: stop condition.
  * @xfer_complete: acknowledge completion for a I2C message.
  * @result: controller propogated result.
- * @pinctrl: pinctrl handle.
- * @pins_default: default state for the pins.
- * @pins_idle: idle state for the pins.
- * @pins_sleep: sleep state for the pins.
  * @busy: Busy doing transfer.
  */
 struct nmk_i2c_dev {
@@ -165,11 +161,6 @@ struct nmk_i2c_dev {
 	int				stop;
 	struct completion		xfer_complete;
 	int				result;
-	/* Three pin states - default, idle & sleep */
-	struct pinctrl			*pinctrl;
-	struct pinctrl_state		*pins_default;
-	struct pinctrl_state		*pins_idle;
-	struct pinctrl_state		*pins_sleep;
 	bool				busy;
 };
 
@@ -645,13 +636,7 @@ static int nmk_i2c_xfer(struct i2c_adapter *i2c_adap,
 	}
 
 	/* Optionaly enable pins to be muxed in and configured */
-	if (!IS_ERR(dev->pins_default)) {
-		status = pinctrl_select_state(dev->pinctrl,
-				dev->pins_default);
-		if (status)
-			dev_err(&dev->adev->dev,
-				"could not set default pins\n");
-	}
+	pinctrl_pm_select_default_state(&dev->adev->dev);
 
 	status = init_hw(dev);
 	if (status)
@@ -681,13 +666,7 @@ out:
 	clk_disable_unprepare(dev->clk);
 out_clk:
 	/* Optionally let pins go into idle state */
-	if (!IS_ERR(dev->pins_idle)) {
-		status = pinctrl_select_state(dev->pinctrl,
-				dev->pins_idle);
-		if (status)
-			dev_err(&dev->adev->dev,
-				"could not set pins to idle state\n");
-	}
+	pinctrl_pm_select_idle_state(&dev->adev->dev);
 
 	pm_runtime_put_sync(&dev->adev->dev);
 
@@ -882,41 +861,22 @@ static int nmk_i2c_suspend(struct device *dev)
 {
 	struct amba_device *adev = to_amba_device(dev);
 	struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
-	int ret;
 
 	if (nmk_i2c->busy)
 		return -EBUSY;
 
-	if (!IS_ERR(nmk_i2c->pins_sleep)) {
-		ret = pinctrl_select_state(nmk_i2c->pinctrl,
-				nmk_i2c->pins_sleep);
-		if (ret)
-			dev_err(dev, "could not set pins to sleep state\n");
-	}
+	pinctrl_pm_select_sleep_state(dev);
 
 	return 0;
 }
 
 static int nmk_i2c_resume(struct device *dev)
 {
-	struct amba_device *adev = to_amba_device(dev);
-	struct nmk_i2c_dev *nmk_i2c = amba_get_drvdata(adev);
-	int ret;
-
 	/* First go to the default state */
-	if (!IS_ERR(nmk_i2c->pins_default)) {
-		ret = pinctrl_select_state(nmk_i2c->pinctrl,
-				nmk_i2c->pins_default);
-		if (ret)
-			dev_err(dev, "could not set pins to default state\n");
-	}
+	pinctrl_pm_select_default_state(dev);
 	/* Then let's idle the pins until the next transfer happens */
-	if (!IS_ERR(nmk_i2c->pins_idle)) {
-		ret = pinctrl_select_state(nmk_i2c->pinctrl,
-				nmk_i2c->pins_idle);
-		if (ret)
-			dev_err(dev, "could not set pins to idle state\n");
-	}
+	pinctrl_pm_select_idle_state(dev);
+
 	return 0;
 }
 #else
@@ -1004,39 +964,10 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	dev->adev = adev;
 	amba_set_drvdata(adev, dev);
 
-	dev->pinctrl = devm_pinctrl_get(&adev->dev);
-	if (IS_ERR(dev->pinctrl)) {
-		ret = PTR_ERR(dev->pinctrl);
-		goto err_pinctrl;
-	}
-
-	dev->pins_default = pinctrl_lookup_state(dev->pinctrl,
-						 PINCTRL_STATE_DEFAULT);
-	if (IS_ERR(dev->pins_default)) {
-		dev_err(&adev->dev, "could not get default pinstate\n");
-	} else {
-		ret = pinctrl_select_state(dev->pinctrl,
-					   dev->pins_default);
-		if (ret)
-			dev_dbg(&adev->dev, "could not set default pinstate\n");
-	}
-
-	dev->pins_idle = pinctrl_lookup_state(dev->pinctrl,
-					      PINCTRL_STATE_IDLE);
-	if (IS_ERR(dev->pins_idle)) {
-		dev_dbg(&adev->dev, "could not get idle pinstate\n");
-	} else {
-		/* If possible, let's go to idle until the first transfer */
-		ret = pinctrl_select_state(dev->pinctrl,
-					   dev->pins_idle);
-		if (ret)
-			dev_dbg(&adev->dev, "could not set idle pinstate\n");
-	}
-
-	dev->pins_sleep = pinctrl_lookup_state(dev->pinctrl,
-					       PINCTRL_STATE_SLEEP);
-	if (IS_ERR(dev->pins_sleep))
-		dev_dbg(&adev->dev, "could not get sleep pinstate\n");
+	/* Select default pin state */
+	pinctrl_pm_select_default_state(&adev->dev);
+	/* If possible, let's go to idle until the first transfer */
+	pinctrl_pm_select_idle_state(&adev->dev);
 
 	dev->virtbase = ioremap(adev->res.start, resource_size(&adev->res));
 	if (!dev->virtbase) {
@@ -1106,7 +1037,6 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	iounmap(dev->virtbase);
  err_no_ioremap:
 	kfree(dev);
- err_pinctrl:
  err_no_mem:
 
 	return ret;
-- 
1.7.11.3

