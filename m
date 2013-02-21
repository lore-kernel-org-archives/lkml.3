Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3BUUPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:15:25 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:38846 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3BUUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:15:20 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, miletus@chromium.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 5/6] Platform: x86: chromeos_laptop - Add Pixel Trackpad
Date: Thu, 21 Feb 2013 12:14:59 -0800
Message-Id: <1361477700-26342-6-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361477700-26342-1-git-send-email-bleung@chromium.org>
References: <1361477700-26342-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instantiate the atmel mxt224s trackpad on this system.
The trackpad may appear at two possible addresses:
0x4b in operational mode.
0x25 in bootloader mode.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index f3a292b..febedc0 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -25,6 +25,8 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 
+#define ATMEL_TP_I2C_ADDR	0x4b
+#define ATMEL_TP_I2C_BL_ADDR	0x25
 #define CYAPA_TP_I2C_ADDR	0x67
 #define ISL_ALS_I2C_ADDR	0x44
 #define TAOS_ALS_I2C_ADDR	0x29
@@ -62,6 +64,12 @@ static struct i2c_board_info __initdata tsl2563_als_device = {
 	I2C_BOARD_INFO("tsl2563", TAOS_ALS_I2C_ADDR),
 };
 
+static struct i2c_board_info __initdata atmel_224s_tp_device = {
+	I2C_BOARD_INFO("atmel_mxt_tp", ATMEL_TP_I2C_ADDR),
+	.platform_data = NULL,
+	.flags		= I2C_CLIENT_WAKE,
+};
+
 static struct i2c_client __init *__add_probed_i2c_device(
 		const char *name,
 		int bus,
@@ -193,6 +201,19 @@ static int __init setup_cyapa_smbus_tp(const struct dmi_system_id *id)
 	return 0;
 }
 
+static int __init setup_atmel_224s_tp(const struct dmi_system_id *id)
+{
+	const unsigned short addr_list[] = { ATMEL_TP_I2C_BL_ADDR,
+					     ATMEL_TP_I2C_ADDR,
+					     I2C_CLIENT_END };
+
+	/* add atmel mxt touchpad on VGA DDC GMBus */
+	tp = add_probed_i2c_device("trackpad", I2C_ADAPTER_VGADDC,
+				   &atmel_224s_tp_device, addr_list);
+	return 0;
+}
+
+
 static int __init setup_isl29018_als(const struct dmi_system_id *id)
 {
 	/* add isl29018 light sensor */
@@ -232,6 +253,14 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 		.callback = setup_cyapa_smbus_tp,
 	},
 	{
+		.ident = "Chromebook Pixel - Touchpad",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
+		},
+		.callback = setup_atmel_224s_tp,
+	},
+	{
 		.ident = "Samsung Series 5 550 - Light Sensor",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
-- 
1.8.1.3

