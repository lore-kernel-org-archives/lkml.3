Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab3GRAVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:21:41 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62993 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab3GRAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:21:27 -0400
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: adurbin@chromium.org, olofj@chromium.org, axel.lin@ingics.com,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 2/2] Platform: x86: chromeos_laptop - Use deferred probing
Date: Wed, 17 Jul 2013 17:21:01 -0700
Message-Id: <1374106861-3549-3-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1374106861-3549-1-git-send-email-bleung@chromium.org>
References: <1374106861-3549-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further refactor chromeos_laptop, adding a probe function.
Init will call dmi_check_system, but will only use the match to select
a chromeos_laptop structure of the current board.

Probe will add the devices, and on errors return -EPROBE_DEFER.
If i2c adapters are loaded after chromeos_laptop inits, the deferred
probe will instantiate the peripherals when the bus appears.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 139 +++++++++++++++++++++++----------
 1 file changed, 98 insertions(+), 41 deletions(-)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 086f347..fc64f65 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -27,6 +27,7 @@
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 
 #define ATMEL_TP_I2C_ADDR	0x4b
 #define ATMEL_TP_I2C_BL_ADDR	0x25
@@ -54,7 +55,7 @@ enum i2c_adapter_type {
 };
 
 struct i2c_peripheral {
-	void (*add)(enum i2c_adapter_type type);
+	int (*add)(enum i2c_adapter_type type);
 	enum i2c_adapter_type type;
 };
 
@@ -64,20 +65,22 @@ struct chromeos_laptop {
 	struct i2c_peripheral i2c_peripherals[MAX_I2C_PERIPHERALS];
 };
 
-static struct i2c_board_info __initdata cyapa_device = {
+static struct chromeos_laptop *cros_laptop;
+
+static struct i2c_board_info cyapa_device = {
 	I2C_BOARD_INFO("cyapa", CYAPA_TP_I2C_ADDR),
 	.flags		= I2C_CLIENT_WAKE,
 };
 
-static struct i2c_board_info __initdata isl_als_device = {
+static struct i2c_board_info isl_als_device = {
 	I2C_BOARD_INFO("isl29018", ISL_ALS_I2C_ADDR),
 };
 
-static struct i2c_board_info __initdata tsl2583_als_device = {
+static struct i2c_board_info tsl2583_als_device = {
 	I2C_BOARD_INFO("tsl2583", TAOS_ALS_I2C_ADDR),
 };
 
-static struct i2c_board_info __initdata tsl2563_als_device = {
+static struct i2c_board_info tsl2563_als_device = {
 	I2C_BOARD_INFO("tsl2563", TAOS_ALS_I2C_ADDR),
 };
 
@@ -100,7 +103,7 @@ static struct mxt_platform_data atmel_224s_tp_platform_data = {
 	.config_length		= 0,
 };
 
-static struct i2c_board_info __initdata atmel_224s_tp_device = {
+static struct i2c_board_info atmel_224s_tp_device = {
 	I2C_BOARD_INFO("atmel_mxt_tp", ATMEL_TP_I2C_ADDR),
 	.platform_data = &atmel_224s_tp_platform_data,
 	.flags		= I2C_CLIENT_WAKE,
@@ -121,13 +124,13 @@ static struct mxt_platform_data atmel_1664s_platform_data = {
 	.config_length		= 0,
 };
 
-static struct i2c_board_info __initdata atmel_1664s_device = {
+static struct i2c_board_info atmel_1664s_device = {
 	I2C_BOARD_INFO("atmel_mxt_ts", ATMEL_TS_I2C_ADDR),
 	.platform_data = &atmel_1664s_platform_data,
 	.flags		= I2C_CLIENT_WAKE,
 };
 
-static struct i2c_client __init *__add_probed_i2c_device(
+static struct i2c_client *__add_probed_i2c_device(
 		const char *name,
 		int bus,
 		struct i2c_board_info *info,
@@ -180,7 +183,7 @@ static struct i2c_client __init *__add_probed_i2c_device(
 	return client;
 }
 
-static int __init __find_i2c_adap(struct device *dev, void *data)
+static int __find_i2c_adap(struct device *dev, void *data)
 {
 	const char *name = data;
 	static const char *prefix = "i2c-";
@@ -191,7 +194,7 @@ static int __init __find_i2c_adap(struct device *dev, void *data)
 	return (strncmp(adapter->name, name, strlen(name)) == 0);
 }
 
-static int __init find_i2c_adapter_num(enum i2c_adapter_type type)
+static int find_i2c_adapter_num(enum i2c_adapter_type type)
 {
 	struct device *dev = NULL;
 	struct i2c_adapter *adapter;
@@ -216,7 +219,7 @@ static int __init find_i2c_adapter_num(enum i2c_adapter_type type)
  * Returns NULL if no devices found.
  * See Documentation/i2c/instantiating-devices for more information.
  */
-static __init struct i2c_client *add_probed_i2c_device(
+static struct i2c_client *add_probed_i2c_device(
 		const char *name,
 		enum i2c_adapter_type type,
 		struct i2c_board_info *info,
@@ -233,7 +236,7 @@ static __init struct i2c_client *add_probed_i2c_device(
  * info->addr.
  * Returns NULL if no device found.
  */
-static __init struct i2c_client *add_i2c_device(const char *name,
+static struct i2c_client *add_i2c_device(const char *name,
 						enum i2c_adapter_type type,
 						struct i2c_board_info *info)
 {
@@ -244,65 +247,87 @@ static __init struct i2c_client *add_i2c_device(const char *name,
 				       addr_list);
 }
 
-static int __init setup_cyapa_tp(enum i2c_adapter_type type)
+static int setup_cyapa_tp(enum i2c_adapter_type type)
 {
+	if (tp)
+		return 0;
+
 	/* add cyapa touchpad */
 	tp = add_i2c_device("trackpad", type, &cyapa_device);
-	return 0;
+	return (!tp) ? -EAGAIN : 0;
 }
 
-static int __init setup_atmel_224s_tp(enum i2c_adapter_type type)
+static int setup_atmel_224s_tp(enum i2c_adapter_type type)
 {
 	const unsigned short addr_list[] = { ATMEL_TP_I2C_BL_ADDR,
 					     ATMEL_TP_I2C_ADDR,
 					     I2C_CLIENT_END };
+	if (tp)
+		return 0;
 
 	/* add atmel mxt touchpad */
 	tp = add_probed_i2c_device("trackpad", type,
 				   &atmel_224s_tp_device, addr_list);
-	return 0;
+	return (!tp) ? -EAGAIN : 0;
 }
 
-static int __init setup_atmel_1664s_ts(enum i2c_adapter_type type)
+static int setup_atmel_1664s_ts(enum i2c_adapter_type type)
 {
 	const unsigned short addr_list[] = { ATMEL_TS_I2C_BL_ADDR,
 					     ATMEL_TS_I2C_ADDR,
 					     I2C_CLIENT_END };
+	if (ts)
+		return 0;
 
 	/* add atmel mxt touch device */
 	ts = add_probed_i2c_device("touchscreen", type,
 				   &atmel_1664s_device, addr_list);
-	return 0;
+	return (!ts) ? -EAGAIN : 0;
 }
 
-static int __init setup_isl29018_als(enum i2c_adapter_type type)
+static int setup_isl29018_als(enum i2c_adapter_type type)
 {
+	if (als)
+		return 0;
+
 	/* add isl29018 light sensor */
 	als = add_i2c_device("lightsensor", type, &isl_als_device);
-	return 0;
+	return (!als) ? -EAGAIN : 0;
 }
 
-static int __init setup_tsl2583_als(enum i2c_adapter_type type)
+static int setup_tsl2583_als(enum i2c_adapter_type type)
 {
+	if (als)
+		return 0;
+
 	/* add tsl2583 light sensor */
 	als = add_i2c_device(NULL, type, &tsl2583_als_device);
-	return 0;
+	return (!als) ? -EAGAIN : 0;
 }
 
-static int __init setup_tsl2563_als(enum i2c_adapter_type type)
+static int setup_tsl2563_als(enum i2c_adapter_type type)
 {
+	if (als)
+		return 0;
+
 	/* add tsl2563 light sensor */
 	als = add_i2c_device(NULL, type, &tsl2563_als_device);
-	return 0;
+	return (!als) ? -EAGAIN : 0;
 }
 
-static int __init
-chromeos_laptop_add_peripherals(const struct dmi_system_id *id)
+static int __init chromeos_laptop_dmi_matched(const struct dmi_system_id *id)
 {
-	int i;
-	struct chromeos_laptop *cros_laptop = (void *)id->driver_data;
+	cros_laptop = (void *)id->driver_data;
+	pr_debug("DMI Matched %s.\n", id->ident);
 
-	pr_debug("Adding peripherals for %s.\n", id->ident);
+	/* Indicate to dmi_scan that processing is done. */
+	return 1;
+}
+
+static int chromeos_laptop_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret = 0;
 
 	for (i = 0; i < MAX_I2C_PERIPHERALS; i++) {
 		struct i2c_peripheral *i2c_dev;
@@ -313,15 +338,15 @@ chromeos_laptop_add_peripherals(const struct dmi_system_id *id)
 		if (i2c_dev->add == NULL)
 			break;
 
-		/* Add the device. */
-		i2c_dev->add(i2c_dev->type);
+		/* Add the device. Set -EPROBE_DEFER on any failure */
+		if (i2c_dev->add(i2c_dev->type))
+			ret = -EPROBE_DEFER;
 	}
 
-	/* Indicate to dmi_scan that processing is done. */
-	return 1;
+	return ret;
 }
 
-static struct chromeos_laptop __initdata samsung_series_5_550 = {
+static struct chromeos_laptop samsung_series_5_550 = {
 	.i2c_peripherals = {
 		/* Touchpad. */
 		{ .add = setup_cyapa_tp, I2C_ADAPTER_SMBUS },
@@ -330,14 +355,14 @@ static struct chromeos_laptop __initdata samsung_series_5_550 = {
 	},
 };
 
-static struct chromeos_laptop __initdata samsung_series_5 = {
+static struct chromeos_laptop samsung_series_5 = {
 	.i2c_peripherals = {
 		/* Light Sensor. */
 		{ .add = setup_tsl2583_als, I2C_ADAPTER_SMBUS },
 	},
 };
 
-static struct chromeos_laptop __initdata chromebook_pixel = {
+static struct chromeos_laptop chromebook_pixel = {
 	.i2c_peripherals = {
 		/* Touch Screen. */
 		{ .add = setup_atmel_1664s_ts, I2C_ADAPTER_PANEL },
@@ -348,28 +373,28 @@ static struct chromeos_laptop __initdata chromebook_pixel = {
 	},
 };
 
-static struct chromeos_laptop __initdata acer_c7_chromebook = {
+static struct chromeos_laptop acer_c7_chromebook = {
 	.i2c_peripherals = {
 		/* Touchpad. */
 		{ .add = setup_cyapa_tp, I2C_ADAPTER_SMBUS },
 	},
 };
 
-static struct chromeos_laptop __initdata acer_ac700 = {
+static struct chromeos_laptop acer_ac700 = {
 	.i2c_peripherals = {
 		/* Light Sensor. */
 		{ .add = setup_tsl2563_als, I2C_ADAPTER_SMBUS },
 	},
 };
 
-static struct chromeos_laptop __initdata hp_pavilion_14_chromebook = {
+static struct chromeos_laptop hp_pavilion_14_chromebook = {
 	.i2c_peripherals = {
 		/* Touchpad. */
 		{ .add = setup_cyapa_tp, I2C_ADAPTER_SMBUS },
 	},
 };
 
-static struct chromeos_laptop __initdata cr48 = {
+static struct chromeos_laptop cr48 = {
 	.i2c_peripherals = {
 		/* Light Sensor. */
 		{ .add = setup_tsl2563_als, I2C_ADAPTER_SMBUS },
@@ -377,7 +402,7 @@ static struct chromeos_laptop __initdata cr48 = {
 };
 
 #define _CBDD(board_) \
-	.callback = &chromeos_laptop_add_peripherals, \
+	.callback = chromeos_laptop_dmi_matched, \
 	.driver_data = (void *)&board_
 
 static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
@@ -436,13 +461,45 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 };
 MODULE_DEVICE_TABLE(dmi, chromeos_laptop_dmi_table);
 
+static struct platform_device *cros_platform_device;
+
+static struct platform_driver cros_platform_driver = {
+	.driver = {
+		.name = "chromeos_laptop",
+		.owner = THIS_MODULE,
+	},
+	.probe = chromeos_laptop_probe,
+};
+
 static int __init chromeos_laptop_init(void)
 {
+	int ret;
 	if (!dmi_check_system(chromeos_laptop_dmi_table)) {
 		pr_debug("%s unsupported system.\n", __func__);
 		return -ENODEV;
 	}
+
+	ret = platform_driver_register(&cros_platform_driver);
+	if (ret)
+		return ret;
+
+	cros_platform_device = platform_device_alloc("chromeos_laptop", -1);
+	if (!cros_platform_device) {
+		ret = -ENOMEM;
+		goto fail_platform_device1;
+	}
+
+	ret = platform_device_add(cros_platform_device);
+	if (ret)
+		goto fail_platform_device2;
+
 	return 0;
+
+fail_platform_device2:
+	platform_device_put(cros_platform_device);
+fail_platform_device1:
+	platform_driver_unregister(&cros_platform_driver);
+	return ret;
 }
 
 static void __exit chromeos_laptop_exit(void)
-- 
1.8.3

