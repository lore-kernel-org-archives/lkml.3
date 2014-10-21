Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaJUPHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:07:44 -0400
Received: from ring0.de ([5.45.105.125]:53962 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbaJUPHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:07:41 -0400
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
Subject: [RFCv2 1/8] [media] si4713: switch to devm regulator API
Date: Tue, 21 Oct 2014 17:07:00 +0200
Message-Id: <1413904027-16767-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413904027-16767-1-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches back to the normal regulator API (but use
managed variant) in preparation for device tree support.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/media/radio/si4713/si4713.c | 80 ++++++++++++++++++++++++++-----------
 drivers/media/radio/si4713/si4713.h |  6 +--
 2 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index b576555..b335093 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -23,6 +23,7 @@
 
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
@@ -366,13 +367,22 @@ static int si4713_powerup(struct si4713_device *sdev)
 	if (sdev->power_state)
 		return 0;
 
-	if (sdev->supplies) {
-		err = regulator_bulk_enable(sdev->supplies, sdev->supply_data);
+	if (sdev->vdd) {
+		err = regulator_enable(sdev->vdd);
 		if (err) {
-			v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
+			v4l2_err(&sdev->sd, "Failed to enable vdd: %d\n", err);
 			return err;
 		}
 	}
+
+	if (sdev->vio) {
+		err = regulator_enable(sdev->vio);
+		if (err) {
+			v4l2_err(&sdev->sd, "Failed to enable vio: %d\n", err);
+			return err;
+		}
+	}
+
 	if (gpio_is_valid(sdev->gpio_reset)) {
 		udelay(50);
 		gpio_set_value(sdev->gpio_reset, 1);
@@ -399,11 +409,18 @@ static int si4713_powerup(struct si4713_device *sdev)
 	}
 	if (gpio_is_valid(sdev->gpio_reset))
 		gpio_set_value(sdev->gpio_reset, 0);
-	if (sdev->supplies) {
-		err = regulator_bulk_disable(sdev->supplies, sdev->supply_data);
+
+
+	if (sdev->vdd) {
+		err = regulator_disable(sdev->vdd);
 		if (err)
-			v4l2_err(&sdev->sd,
-				 "Failed to disable supplies: %d\n", err);
+			v4l2_err(&sdev->sd, "Failed to disable vdd: %d\n", err);
+	}
+
+	if (sdev->vio) {
+		err = regulator_disable(sdev->vio);
+		if (err)
+			v4l2_err(&sdev->sd, "Failed to disable vio: %d\n", err);
 	}
 
 	return err;
@@ -432,12 +449,21 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
 		if (gpio_is_valid(sdev->gpio_reset))
 			gpio_set_value(sdev->gpio_reset, 0);
-		if (sdev->supplies) {
-			err = regulator_bulk_disable(sdev->supplies,
-						     sdev->supply_data);
-			if (err)
+
+		if (sdev->vdd) {
+			err = regulator_disable(sdev->vdd);
+			if (err) {
+				v4l2_err(&sdev->sd,
+					"Failed to disable vdd: %d\n", err);
+			}
+		}
+
+		if (sdev->vio) {
+			err = regulator_disable(sdev->vio);
+			if (err) {
 				v4l2_err(&sdev->sd,
-					 "Failed to disable supplies: %d\n", err);
+					"Failed to disable vio: %d\n", err);
+			}
 		}
 		sdev->power_state = POWER_OFF;
 	}
@@ -1441,17 +1467,26 @@ static int si4713_probe(struct i2c_client *client,
 		}
 		sdev->gpio_reset = pdata->gpio_reset;
 		gpio_direction_output(sdev->gpio_reset, 0);
-		sdev->supplies = pdata->supplies;
 	}
 
-	for (i = 0; i < sdev->supplies; i++)
-		sdev->supply_data[i].supply = pdata->supply_names[i];
+	sdev->vdd = devm_regulator_get_optional(&client->dev, "vdd");
+	if (IS_ERR(sdev->vdd)) {
+		rval = PTR_ERR(sdev->vdd);
+		if (rval == -EPROBE_DEFER)
+			goto exit;
+
+		dev_dbg(&client->dev, "no vdd regulator found: %d\n", rval);
+		sdev->vdd = NULL;
+	}
+
+	sdev->vio = devm_regulator_get_optional(&client->dev, "vio");
+	if (IS_ERR(sdev->vio)) {
+		rval = PTR_ERR(sdev->vio);
+		if (rval == -EPROBE_DEFER)
+			goto exit;
 
-	rval = regulator_bulk_get(&client->dev, sdev->supplies,
-				  sdev->supply_data);
-	if (rval) {
-		dev_err(&client->dev, "Cannot get regulators: %d\n", rval);
-		goto free_gpio;
+		dev_dbg(&client->dev, "no vio regulator found: %d\n", rval);
+		sdev->vio = NULL;
 	}
 
 	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
@@ -1559,7 +1594,7 @@ static int si4713_probe(struct i2c_client *client,
 			client->name, sdev);
 		if (rval < 0) {
 			v4l2_err(&sdev->sd, "Could not request IRQ\n");
-			goto put_reg;
+			goto free_ctrls;
 		}
 		v4l2_dbg(1, debug, &sdev->sd, "IRQ requested.\n");
 	} else {
@@ -1579,8 +1614,6 @@ free_irq:
 		free_irq(client->irq, sdev);
 free_ctrls:
 	v4l2_ctrl_handler_free(hdl);
-put_reg:
-	regulator_bulk_free(sdev->supplies, sdev->supply_data);
 free_gpio:
 	if (gpio_is_valid(sdev->gpio_reset))
 		gpio_free(sdev->gpio_reset);
@@ -1604,7 +1637,6 @@ static int si4713_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	regulator_bulk_free(sdev->supplies, sdev->supply_data);
 	if (gpio_is_valid(sdev->gpio_reset))
 		gpio_free(sdev->gpio_reset);
 	kfree(sdev);
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index ed700e3..ed28ed2 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -190,8 +190,6 @@
 #define MIN_ACOMP_THRESHOLD		(-40)
 #define MAX_ACOMP_GAIN			20
 
-#define SI4713_NUM_SUPPLIES		2
-
 /*
  * si4713_device - private data
  */
@@ -236,8 +234,8 @@ struct si4713_device {
 		struct v4l2_ctrl *tune_ant_cap;
 	};
 	struct completion work;
-	unsigned supplies;
-	struct regulator_bulk_data supply_data[SI4713_NUM_SUPPLIES];
+	struct regulator *vdd;
+	struct regulator *vio;
 	int gpio_reset;
 	u32 power_state;
 	u32 rds_enabled;
-- 
2.1.1

