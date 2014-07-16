Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbaGPAnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:43:21 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37396 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaGPAnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:43:18 -0400
From: Benson Leung <bleung@chromium.org>
To: olof@lixom.net, linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCH] platform/chrome: chromeos_laptop - Add a limit for deferred retries
Date: Tue, 15 Jul 2014 17:43:11 -0700
Message-Id: <1405471391-27073-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of times we allow deferred probing to attempt to add
i2c devices. This will help with some device flakiness at probe time.
For example, some touchpads and touchscreens may be in transition between
bootloader and operational mode and may appear at neither address briefly.

Adapters, however, have no limit as it depends on when the i2c adapter driver
module is loaded. The module may even be loaded manually by the user using
modprobe or insmod.

By default, set MAX_I2C_DEVICE_DEFERALS to 5.

Based on this patch from the chromeos-kernel :
https://chromium-review.googlesource.com/168130

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/chrome/chromeos_laptop.c | 45 ++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index a53fe76..cc76426 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -37,6 +37,8 @@
 #define ISL_ALS_I2C_ADDR	0x44
 #define TAOS_ALS_I2C_ADDR	0x29
 
+#define MAX_I2C_DEVICE_DEFERRALS	5
+
 static struct i2c_client *als;
 static struct i2c_client *tp;
 static struct i2c_client *ts;
@@ -58,9 +60,17 @@ enum i2c_adapter_type {
 	I2C_ADAPTER_DESIGNWARE_1,
 };
 
+enum i2c_peripheral_state {
+	UNPROBED = 0,
+	PROBED,
+	TIMEDOUT,
+};
+
 struct i2c_peripheral {
 	int (*add)(enum i2c_adapter_type type);
 	enum i2c_adapter_type type;
+	enum i2c_peripheral_state state;
+	int tries;
 };
 
 #define MAX_I2C_PERIPHERALS 3
@@ -166,8 +176,8 @@ static struct i2c_client *__add_probed_i2c_device(
 	/* add the i2c device */
 	client = i2c_new_probed_device(adapter, info, addrs, NULL);
 	if (!client)
-		pr_err("%s failed to register device %d-%02x\n",
-		       __func__, bus, info->addr);
+		pr_notice("%s failed to register device %d-%02x\n",
+			  __func__, bus, info->addr);
 	else
 		pr_debug("%s added i2c device %d-%02x\n",
 			 __func__, bus, info->addr);
@@ -347,9 +357,36 @@ static int chromeos_laptop_probe(struct platform_device *pdev)
 		if (i2c_dev->add == NULL)
 			break;
 
-		/* Add the device. Set -EPROBE_DEFER on any failure */
-		if (i2c_dev->add(i2c_dev->type))
+		if (i2c_dev->state == TIMEDOUT || i2c_dev->state == PROBED)
+			continue;
+
+		/*
+		 * Check that the i2c adapter is present.
+		 * -EPROBE_DEFER if missing as the adapter may appear much
+		 * later.
+		 */
+		if (find_i2c_adapter_num(i2c_dev->type) == -ENODEV) {
 			ret = -EPROBE_DEFER;
+			continue;
+		}
+
+		/* Add the device. */
+		if (i2c_dev->add(i2c_dev->type) == -EAGAIN) {
+			/*
+			 * Set -EPROBE_DEFER a limited num of times
+			 * if device is not successfully added.
+			 */
+			if (++i2c_dev->tries < MAX_I2C_DEVICE_DEFERRALS) {
+				ret = -EPROBE_DEFER;
+			} else {
+				/* Ran out of tries. */
+				pr_notice("%s: Ran out of tries for device.\n",
+					  __func__);
+				i2c_dev->state = TIMEDOUT;
+			}
+		} else {
+			i2c_dev->state = PROBED;
+		}
 	}
 
 	return ret;
-- 
2.0.0.526.g5318336

