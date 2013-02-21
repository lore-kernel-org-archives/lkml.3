Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3BUUP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:15:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37894 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3BUUPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:15:22 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, miletus@chromium.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 6/6] Platform: x86: chromeos_laptop - Add Pixel Touchscreen
Date: Thu, 21 Feb 2013 12:15:00 -0800
Message-Id: <1361477700-26342-7-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361477700-26342-1-git-send-email-bleung@chromium.org>
References: <1361477700-26342-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yufeng Shen <miletus@chromium.org>

Instantiate the atmel mxt1664s touchscreen on this system.
The touchscreen may appear at two possible addresses:
0x4a in operational mode.
0x26 in bootloader mode.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index febedc0..93d6680 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -27,12 +27,15 @@
 
 #define ATMEL_TP_I2C_ADDR	0x4b
 #define ATMEL_TP_I2C_BL_ADDR	0x25
+#define ATMEL_TS_I2C_ADDR	0x4a
+#define ATMEL_TS_I2C_BL_ADDR	0x26
 #define CYAPA_TP_I2C_ADDR	0x67
 #define ISL_ALS_I2C_ADDR	0x44
 #define TAOS_ALS_I2C_ADDR	0x29
 
 static struct i2c_client *als;
 static struct i2c_client *tp;
+static struct i2c_client *ts;
 
 const char *i2c_adapter_names[] = {
 	"SMBus I801 adapter",
@@ -70,6 +73,12 @@ static struct i2c_board_info __initdata atmel_224s_tp_device = {
 	.flags		= I2C_CLIENT_WAKE,
 };
 
+static struct i2c_board_info __initdata atmel_1664s_device = {
+	I2C_BOARD_INFO("atmel_mxt_ts", ATMEL_TS_I2C_ADDR),
+	.platform_data = NULL,
+	.flags		= I2C_CLIENT_WAKE,
+};
+
 static struct i2c_client __init *__add_probed_i2c_device(
 		const char *name,
 		int bus,
@@ -213,6 +222,18 @@ static int __init setup_atmel_224s_tp(const struct dmi_system_id *id)
 	return 0;
 }
 
+static int __init setup_atmel_1664s_ts(const struct dmi_system_id *id)
+{
+	const unsigned short addr_list[] = { ATMEL_TS_I2C_BL_ADDR,
+					     ATMEL_TS_I2C_ADDR,
+					     I2C_CLIENT_END };
+
+	/* add atmel mxt touch device on PANEL GMBus */
+	ts = add_probed_i2c_device("touchscreen", I2C_ADAPTER_PANEL,
+				   &atmel_1664s_device, addr_list);
+	return 0;
+}
+
 
 static int __init setup_isl29018_als(const struct dmi_system_id *id)
 {
@@ -253,6 +274,14 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 		.callback = setup_cyapa_smbus_tp,
 	},
 	{
+		.ident = "Chromebook Pixel - Touchscreen",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
+		},
+		.callback = setup_atmel_1664s_ts,
+	},
+	{
 		.ident = "Chromebook Pixel - Touchpad",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
@@ -330,6 +359,8 @@ static void __exit chromeos_laptop_exit(void)
 		i2c_unregister_device(als);
 	if (tp)
 		i2c_unregister_device(tp);
+	if (ts)
+		i2c_unregister_device(ts);
 }
 
 module_init(chromeos_laptop_init);
-- 
1.8.1.3

