Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab3GRAV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:21:28 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50037 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab3GRAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:21:24 -0400
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: adurbin@chromium.org, olofj@chromium.org, axel.lin@ingics.com,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 1/2] Platform: x86: chromeos_laptop - Restructure device associations
Date: Wed, 17 Jul 2013 17:21:00 -0700
Message-Id: <1374106861-3549-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1374106861-3549-1-git-send-email-bleung@chromium.org>
References: <1374106861-3549-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Durbin <adurbin@chromium.org>

The previous code had a single DMI matching entry
for each device on a board. Instead provide a single
DMI entry for each board which references a structure
about each board that lists the associated peripherals.
This allows for a lower number of DMI matching sequences
as well making it easier to add new boards.

Signed-off-by: Aaron Durbin <adurbin@chromium.org>
Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 197 +++++++++++++++++++++------------
 1 file changed, 126 insertions(+), 71 deletions(-)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 3e5b4497..086f347 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -53,6 +53,17 @@ enum i2c_adapter_type {
 	I2C_ADAPTER_PANEL,
 };
 
+struct i2c_peripheral {
+	void (*add)(enum i2c_adapter_type type);
+	enum i2c_adapter_type type;
+};
+
+#define MAX_I2C_PERIPHERALS 3
+
+struct chromeos_laptop {
+	struct i2c_peripheral i2c_peripherals[MAX_I2C_PERIPHERALS];
+};
+
 static struct i2c_board_info __initdata cyapa_device = {
 	I2C_BOARD_INFO("cyapa", CYAPA_TP_I2C_ADDR),
 	.flags		= I2C_CLIENT_WAKE,
@@ -233,149 +244,193 @@ static __init struct i2c_client *add_i2c_device(const char *name,
 				       addr_list);
 }
 
-
-static struct i2c_client __init *add_smbus_device(const char *name,
-						  struct i2c_board_info *info)
-{
-	return add_i2c_device(name, I2C_ADAPTER_SMBUS, info);
-}
-
-static int __init setup_cyapa_smbus_tp(const struct dmi_system_id *id)
+static int __init setup_cyapa_tp(enum i2c_adapter_type type)
 {
-	/* add cyapa touchpad on smbus */
-	tp = add_smbus_device("trackpad", &cyapa_device);
+	/* add cyapa touchpad */
+	tp = add_i2c_device("trackpad", type, &cyapa_device);
 	return 0;
 }
 
-static int __init setup_atmel_224s_tp(const struct dmi_system_id *id)
+static int __init setup_atmel_224s_tp(enum i2c_adapter_type type)
 {
 	const unsigned short addr_list[] = { ATMEL_TP_I2C_BL_ADDR,
 					     ATMEL_TP_I2C_ADDR,
 					     I2C_CLIENT_END };
 
-	/* add atmel mxt touchpad on VGA DDC GMBus */
-	tp = add_probed_i2c_device("trackpad", I2C_ADAPTER_VGADDC,
+	/* add atmel mxt touchpad */
+	tp = add_probed_i2c_device("trackpad", type,
 				   &atmel_224s_tp_device, addr_list);
 	return 0;
 }
 
-static int __init setup_atmel_1664s_ts(const struct dmi_system_id *id)
+static int __init setup_atmel_1664s_ts(enum i2c_adapter_type type)
 {
 	const unsigned short addr_list[] = { ATMEL_TS_I2C_BL_ADDR,
 					     ATMEL_TS_I2C_ADDR,
 					     I2C_CLIENT_END };
 
-	/* add atmel mxt touch device on PANEL GMBus */
-	ts = add_probed_i2c_device("touchscreen", I2C_ADAPTER_PANEL,
+	/* add atmel mxt touch device */
+	ts = add_probed_i2c_device("touchscreen", type,
 				   &atmel_1664s_device, addr_list);
 	return 0;
 }
 
-
-static int __init setup_isl29018_als(const struct dmi_system_id *id)
+static int __init setup_isl29018_als(enum i2c_adapter_type type)
 {
 	/* add isl29018 light sensor */
-	als = add_smbus_device("lightsensor", &isl_als_device);
+	als = add_i2c_device("lightsensor", type, &isl_als_device);
 	return 0;
 }
 
-static int __init setup_isl29023_als(const struct dmi_system_id *id)
+static int __init setup_tsl2583_als(enum i2c_adapter_type type)
 {
-	/* add isl29023 light sensor on Panel GMBus */
-	als = add_i2c_device("lightsensor", I2C_ADAPTER_PANEL,
-			     &isl_als_device);
+	/* add tsl2583 light sensor */
+	als = add_i2c_device(NULL, type, &tsl2583_als_device);
 	return 0;
 }
 
-static int __init setup_tsl2583_als(const struct dmi_system_id *id)
+static int __init setup_tsl2563_als(enum i2c_adapter_type type)
 {
-	/* add tsl2583 light sensor on smbus */
-	als = add_smbus_device(NULL, &tsl2583_als_device);
+	/* add tsl2563 light sensor */
+	als = add_i2c_device(NULL, type, &tsl2563_als_device);
 	return 0;
 }
 
-static int __init setup_tsl2563_als(const struct dmi_system_id *id)
+static int __init
+chromeos_laptop_add_peripherals(const struct dmi_system_id *id)
 {
-	/* add tsl2563 light sensor on smbus */
-	als = add_smbus_device(NULL, &tsl2563_als_device);
-	return 0;
+	int i;
+	struct chromeos_laptop *cros_laptop = (void *)id->driver_data;
+
+	pr_debug("Adding peripherals for %s.\n", id->ident);
+
+	for (i = 0; i < MAX_I2C_PERIPHERALS; i++) {
+		struct i2c_peripheral *i2c_dev;
+
+		i2c_dev = &cros_laptop->i2c_peripherals[i];
+
+		/* No more peripherals. */
+		if (i2c_dev->add == NULL)
+			break;
+
+		/* Add the device. */
+		i2c_dev->add(i2c_dev->type);
+	}
+
+	/* Indicate to dmi_scan that processing is done. */
+	return 1;
 }
 
+static struct chromeos_laptop __initdata samsung_series_5_550 = {
+	.i2c_peripherals = {
+		/* Touchpad. */
+		{ .add = setup_cyapa_tp, I2C_ADAPTER_SMBUS },
+		/* Light Sensor. */
+		{ .add = setup_isl29018_als, I2C_ADAPTER_SMBUS },
+	},
+};
+
+static struct chromeos_laptop __initdata samsung_series_5 = {
+	.i2c_peripherals = {
+		/* Light Sensor. */
+		{ .add = setup_tsl2583_als, I2C_ADAPTER_SMBUS },
+	},
+};
+
+static struct chromeos_laptop __initdata chromebook_pixel = {
+	.i2c_peripherals = {
+		/* Touch Screen. */
+		{ .add = setup_atmel_1664s_ts, I2C_ADAPTER_PANEL },
+		/* Touchpad. */
+		{ .add = setup_atmel_224s_tp, I2C_ADAPTER_VGADDC },
+		/* Light Sensor. */
+		{ .add = setup_isl29018_als, I2C_ADAPTER_PANEL },
+	},
+};
+
+static struct chromeos_laptop __initdata acer_c7_chromebook = {
+	.i2c_peripherals = {
+		/* Touchpad. */
+		{ .add = setup_cyapa_tp, I2C_ADAPTER_SMBUS },
+	},
+};
+
+static struct chromeos_laptop __initdata acer_ac700 = {
+	.i2c_peripherals = {
+		/* Light Sensor. */
+		{ .add = setup_tsl2563_als, I2C_ADAPTER_SMBUS },
+	},
+};
+
+static struct chromeos_laptop __initdata hp_pavilion_14_chromebook = {
+	.i2c_peripherals = {
+		/* Touchpad. */
+		{ .add = setup_cyapa_tp, I2C_ADAPTER_SMBUS },
+	},
+};
+
+static struct chromeos_laptop __initdata cr48 = {
+	.i2c_peripherals = {
+		/* Light Sensor. */
+		{ .add = setup_tsl2563_als, I2C_ADAPTER_SMBUS },
+	},
+};
+
+#define _CBDD(board_) \
+	.callback = &chromeos_laptop_add_peripherals, \
+	.driver_data = (void *)&board_
+
 static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 	{
-		.ident = "Samsung Series 5 550 - Touchpad",
+		.ident = "Samsung Series 5 550",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Lumpy"),
 		},
-		.callback = setup_cyapa_smbus_tp,
-	},
-	{
-		.ident = "Chromebook Pixel - Touchscreen",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
-		},
-		.callback = setup_atmel_1664s_ts,
-	},
-	{
-		.ident = "Chromebook Pixel - Touchpad",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
-		},
-		.callback = setup_atmel_224s_tp,
+		_CBDD(samsung_series_5_550),
 	},
 	{
-		.ident = "Samsung Series 5 550 - Light Sensor",
+		.ident = "Samsung Series 5",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lumpy"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alex"),
 		},
-		.callback = setup_isl29018_als,
+		_CBDD(samsung_series_5),
 	},
 	{
-		.ident = "Chromebook Pixel - Light Sensor",
+		.ident = "Chromebook Pixel",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
 		},
-		.callback = setup_isl29023_als,
+		_CBDD(chromebook_pixel),
 	},
 	{
-		.ident = "Acer C7 Chromebook - Touchpad",
+		.ident = "Acer C7 Chromebook",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Parrot"),
 		},
-		.callback = setup_cyapa_smbus_tp,
+		_CBDD(acer_c7_chromebook),
 	},
 	{
-		.ident = "HP Pavilion 14 Chromebook - Touchpad",
+		.ident = "Acer AC700",
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Butterfly"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
 		},
-		.callback = setup_cyapa_smbus_tp,
+		_CBDD(acer_ac700),
 	},
 	{
-		.ident = "Samsung Series 5 - Light Sensor",
+		.ident = "HP Pavilion 14 Chromebook",
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alex"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Butterfly"),
 		},
-		.callback = setup_tsl2583_als,
+		_CBDD(hp_pavilion_14_chromebook),
 	},
 	{
-		.ident = "Cr-48 - Light Sensor",
+		.ident = "Cr-48",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
 		},
-		.callback = setup_tsl2563_als,
-	},
-	{
-		.ident = "Acer AC700 - Light Sensor",
-		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
-		},
-		.callback = setup_tsl2563_als,
+		_CBDD(cr48),
 	},
 	{ }
 };
-- 
1.8.3

