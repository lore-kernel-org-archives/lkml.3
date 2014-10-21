Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbaJUPHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:07:50 -0400
Received: from ring0.de ([5.45.105.125]:53991 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbaJUPHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:07:45 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [RFCv2 2/8] [media] si4713: switch reset gpio to devm_gpiod API
Date: Tue, 21 Oct 2014 17:07:01 +0200
Message-Id: <1413904027-16767-3-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413904027-16767-1-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the driver to use the managed gpiod interface
instead of the unmanged old GPIO API. This is a preperation
for the introduction of device tree support.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/media/radio/si4713/si4713.c | 38 +++++++++++++++++--------------------
 drivers/media/radio/si4713/si4713.h |  3 ++-
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index b335093..e560a7e 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -383,9 +383,9 @@ static int si4713_powerup(struct si4713_device *sdev)
 		}
 	}
 
-	if (gpio_is_valid(sdev->gpio_reset)) {
+	if (!IS_ERR(sdev->gpio_reset)) {
 		udelay(50);
-		gpio_set_value(sdev->gpio_reset, 1);
+		gpiod_set_value(sdev->gpio_reset, 1);
 	}
 
 	if (client->irq)
@@ -407,8 +407,8 @@ static int si4713_powerup(struct si4713_device *sdev)
 						SI4713_STC_INT | SI4713_CTS);
 		return err;
 	}
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_set_value(sdev->gpio_reset, 0);
+	if (!IS_ERR(sdev->gpio_reset))
+		gpiod_set_value(sdev->gpio_reset, 0);
 
 
 	if (sdev->vdd) {
@@ -447,8 +447,8 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
 				resp[0]);
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
-		if (gpio_is_valid(sdev->gpio_reset))
-			gpio_set_value(sdev->gpio_reset, 0);
+		if (!IS_ERR(sdev->gpio_reset))
+			gpiod_set_value(sdev->gpio_reset, 0);
 
 		if (sdev->vdd) {
 			err = regulator_disable(sdev->vdd);
@@ -1457,16 +1457,17 @@ static int si4713_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	sdev->gpio_reset = -1;
-	if (pdata && gpio_is_valid(pdata->gpio_reset)) {
-		rval = gpio_request(pdata->gpio_reset, "si4713 reset");
-		if (rval) {
-			dev_err(&client->dev,
-				"Failed to request gpio: %d\n", rval);
-			goto free_sdev;
-		}
-		sdev->gpio_reset = pdata->gpio_reset;
-		gpio_direction_output(sdev->gpio_reset, 0);
+	sdev->gpio_reset = devm_gpiod_get(&client->dev, "reset");
+	if (!IS_ERR(sdev->gpio_reset)) {
+		gpiod_direction_output(sdev->gpio_reset, 0);
+	} else if (PTR_ERR(sdev->gpio_reset) == -ENOENT) {
+		dev_dbg(&client->dev, "No reset GPIO assigned\n");
+	} else if (PTR_ERR(sdev->gpio_reset) == -ENOSYS) {
+		dev_dbg(&client->dev, "No reset GPIO support\n");
+	} else {
+		rval = PTR_ERR(sdev->gpio_reset);
+		dev_err(&client->dev, "Failed to request gpio: %d\n", rval);
+		goto free_sdev;
 	}
 
 	sdev->vdd = devm_regulator_get_optional(&client->dev, "vdd");
@@ -1614,9 +1615,6 @@ free_irq:
 		free_irq(client->irq, sdev);
 free_ctrls:
 	v4l2_ctrl_handler_free(hdl);
-free_gpio:
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_free(sdev->gpio_reset);
 free_sdev:
 	kfree(sdev);
 exit:
@@ -1637,8 +1635,6 @@ static int si4713_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_free(sdev->gpio_reset);
 	kfree(sdev);
 
 	return 0;
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index ed28ed2..7c2479f 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -16,6 +16,7 @@
 #define SI4713_I2C_H
 
 #include <linux/regulator/consumer.h>
+#include <linux/gpio/consumer.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/si4713.h>
@@ -236,7 +237,7 @@ struct si4713_device {
 	struct completion work;
 	struct regulator *vdd;
 	struct regulator *vio;
-	int gpio_reset;
+	struct gpio_desc *gpio_reset;
 	u32 power_state;
 	u32 rds_enabled;
 	u32 frequency;
-- 
2.1.1

