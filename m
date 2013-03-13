Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab3CMXvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:51:18 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:40682 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440Ab3CMXvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:51:10 -0400
From: Benson Leung <bleung@chromium.org>
To: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: bleung@chromium.org, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: [PATCH 1/4] Input: cyapa - Move common initialization to cyapa_detect
Date: Wed, 13 Mar 2013 16:50:48 -0700
Message-Id: <1363218651-22457-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363218651-22457-1-git-send-email-bleung@chromium.org>
References: <1363218651-22457-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cyapa_check_is_operational and cyapa_create_input_dev are common to
the probe and firmware update paths. Pull those out into
cyapa_detect.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/mouse/cyapa.c | 57 +++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index b409c3d..a631aca 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -823,6 +823,40 @@ err_free_device:
 	return ret;
 }
 
+static void cyapa_detect(struct cyapa *cyapa)
+{
+	struct device *dev = &cyapa->client->dev;
+	int ret;
+
+	ret = cyapa_check_is_operational(cyapa);
+	if (ret == -ETIMEDOUT)
+		dev_err(dev, "no device detected, %d\n", ret);
+	else if (ret)
+		dev_err(dev, "device detected, but not operational, %d\n", ret);
+
+	if (!cyapa->input) {
+		ret = cyapa_create_input_dev(cyapa);
+		if (ret)
+			dev_err(dev, "create input_dev instance failed, %d\n",
+				ret);
+
+		enable_irq(cyapa->irq);
+		/*
+		 * On some systems, a system crash / warm boot does not reset
+		 * the device's current power mode to FULL_ACTIVE.
+		 * If such an event happens during suspend, after the device
+		 * has been put in a low power mode, the device will still be
+		 * in low power mode on a subsequent boot, since there was
+		 * never a matching resume().
+		 * Handle this by always forcing full power here, when a
+		 * device is first detected to be in operational mode.
+		 */
+		ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
+		if (ret)
+			dev_warn(dev, "set active power failed, %d\n", ret);
+	}
+}
+
 static int cyapa_probe(struct i2c_client *client,
 		       const struct i2c_device_id *dev_id)
 {
@@ -853,23 +887,8 @@ static int cyapa_probe(struct i2c_client *client,
 	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
 		cyapa->smbus = true;
 	cyapa->state = CYAPA_STATE_NO_DEVICE;
-	ret = cyapa_check_is_operational(cyapa);
-	if (ret) {
-		dev_err(dev, "device not operational, %d\n", ret);
-		goto err_mem_free;
-	}
 
-	ret = cyapa_create_input_dev(cyapa);
-	if (ret) {
-		dev_err(dev, "create input_dev instance failed, %d\n", ret);
-		goto err_mem_free;
-	}
-
-	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
-	if (ret) {
-		dev_err(dev, "set active power failed, %d\n", ret);
-		goto err_unregister_device;
-	}
+	cyapa_detect(cyapa);
 
 	cyapa->irq = client->irq;
 	ret = request_threaded_irq(cyapa->irq,
@@ -886,8 +905,8 @@ static int cyapa_probe(struct i2c_client *client,
 	return 0;
 
 err_unregister_device:
-	input_unregister_device(cyapa->input);
-err_mem_free:
+	if (cyapa->input)
+		input_unregister_device(cyapa->input);
 	kfree(cyapa);
 
 	return ret;
@@ -937,6 +956,8 @@ static int cyapa_resume(struct device *dev)
 	if (device_may_wakeup(dev) && cyapa->irq_wake)
 		disable_irq_wake(cyapa->irq);
 
+	cyapa_detect(cyapa);
+
 	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
 	if (ret)
 		dev_warn(dev, "resume active power failed, %d\n", ret);
-- 
1.8.1.3

