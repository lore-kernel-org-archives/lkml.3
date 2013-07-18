Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab3GRP63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:58:29 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56922 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3GRP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:58:27 -0400
From: enselic@gmail.com
To: matthew.garrett@nebula.com, bleung@chromium.org, olof@lixom.net
Cc: miletus@chromium.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Nordholts <enselic@gmail.com>
Subject: [PATCH 1/1] Platform: x86: chromeos_laptop - convert to i2c_driver to handle i915 race
Date: Thu, 18 Jul 2013 17:58:11 +0200
Message-Id: <1374163091-4750-2-git-send-email-enselic@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374163091-4750-1-git-send-email-enselic@gmail.com>
References: <1374163091-4750-1-git-send-email-enselic@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Nordholts <enselic@gmail.com>

On the Chromebook Pixel, if chromeos_laptop is loaded before the i915
module, the necessary i2c_adapters will not be avaible when
chromeos_laptop probes for them, and you will get this dmesg output:

  [...] find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
  [...] find_i2c_adapter_num: i2c adapter i915 gmbus vga not found on system.
  [...] find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.

Instead of manually adding code to listen for the additions of the
i2c_adapters we want, convert chromeos_laptop into an i2c_driver with
a .detect-function. Our detect-function will be called for all
i2c_adapters added before our driver is loaded, as well as for any
adapters added after our driver is loaded. This way, we don't need any
custom i2c probing code at all.

Signed-off-by: Martin Nordholts <enselic@gmail.com>
---
 drivers/platform/x86/chromeos_laptop.c |  426 +++++++++++++++-----------------
 1 file changed, 194 insertions(+), 232 deletions(-)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 3e5b4497..b9a5e81 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -2,8 +2,10 @@
  *  chromeos_laptop.c - Driver to instantiate Chromebook i2c/smbus devices.
  *
  *  Author : Benson Leung <bleung@chromium.org>
+ *  Author : Martin Nordholts <enselic@gmail.com>
  *
  *  Copyright (C) 2012 Google, Inc.
+ *  Copyright (C) 2012 Martin Nordholts
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -28,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 
+/* Keep chromeos_laptop_driver.address_list up to date with this list  */
 #define ATMEL_TP_I2C_ADDR	0x4b
 #define ATMEL_TP_I2C_BL_ADDR	0x25
 #define ATMEL_TS_I2C_ADDR	0x4a
@@ -36,37 +39,46 @@
 #define ISL_ALS_I2C_ADDR	0x44
 #define TAOS_ALS_I2C_ADDR	0x29
 
-static struct i2c_client *als;
-static struct i2c_client *tp;
-static struct i2c_client *ts;
+/* Information about an i2c_adapter that we handle in this driver */
+struct handled_adapter {
 
-const char *i2c_adapter_names[] = {
-	"SMBus I801 adapter",
-	"i915 gmbus vga",
-	"i915 gmbus panel",
+	/* i2c_adapter name */
+	const char *adapter_name;
+
+	/* Terminate with .board_info = NULL */
+	struct client_entry *client_entries;
 };
 
-/* Keep this enum consistent with i2c_adapter_names */
-enum i2c_adapter_type {
-	I2C_ADAPTER_SMBUS = 0,
-	I2C_ADAPTER_VGADDC,
-	I2C_ADAPTER_PANEL,
+/* Information about an i2c_client we support for a given handled_adapter */
+struct client_entry {
+
+	/* DMI name used to obtain e.g. IRQ information */
+	const char *dmi_name;
+
+	/* i2c_board_info for this client */
+	const struct i2c_board_info *board_info;
+
+	/*
+	 * List of addresses this i2c device can appear of. If not
+	 * set, board_info->addr must be set
+	 */
+	const unsigned short *address_list;
 };
 
-static struct i2c_board_info __initdata cyapa_device = {
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
 
@@ -89,7 +101,7 @@ static struct mxt_platform_data atmel_224s_tp_platform_data = {
 	.config_length		= 0,
 };
 
-static struct i2c_board_info __initdata atmel_224s_tp_device = {
+static struct i2c_board_info atmel_224s_tp_device = {
 	I2C_BOARD_INFO("atmel_mxt_tp", ATMEL_TP_I2C_ADDR),
 	.platform_data = &atmel_224s_tp_platform_data,
 	.flags		= I2C_CLIENT_WAKE,
@@ -110,25 +122,17 @@ static struct mxt_platform_data atmel_1664s_platform_data = {
 	.config_length		= 0,
 };
 
-static struct i2c_board_info __initdata atmel_1664s_device = {
+static struct i2c_board_info atmel_1664s_device = {
 	I2C_BOARD_INFO("atmel_mxt_ts", ATMEL_TS_I2C_ADDR),
 	.platform_data = &atmel_1664s_platform_data,
 	.flags		= I2C_CLIENT_WAKE,
 };
 
-static struct i2c_client __init *__add_probed_i2c_device(
-		const char *name,
-		int bus,
-		struct i2c_board_info *info,
-		const unsigned short *addrs)
+static int get_irq_for_dmi_name(const char *name)
 {
 	const struct dmi_device *dmi_dev;
 	const struct dmi_dev_onboard *dev_data;
-	struct i2c_adapter *adapter;
-	struct i2c_client *client;
 
-	if (bus < 0)
-		return NULL;
 	/*
 	 * If a name is specified, look for irq platform information stashed
 	 * in DMI_DEV_TYPE_DEV_ONBOARD by the Chrome OS custom system firmware.
@@ -139,270 +143,228 @@ static struct i2c_client __init *__add_probed_i2c_device(
 			pr_err("%s failed to dmi find device %s.\n",
 			       __func__,
 			       name);
-			return NULL;
+			return 0;
+
 		}
 		dev_data = (struct dmi_dev_onboard *)dmi_dev->device_data;
 		if (!dev_data) {
 			pr_err("%s failed to get data from dmi for %s.\n",
 			       __func__, name);
-			return NULL;
+			return 0;
 		}
-		info->irq = dev_data->instance;
-	}
-
-	adapter = i2c_get_adapter(bus);
-	if (!adapter) {
-		pr_err("%s failed to get i2c adapter %d.\n", __func__, bus);
-		return NULL;
+		return dev_data->instance;
 	}
 
-	/* add the i2c device */
-	client = i2c_new_probed_device(adapter, info, addrs, NULL);
-	if (!client)
-		pr_err("%s failed to register device %d-%02x\n",
-		       __func__, bus, info->addr);
-	else
-		pr_debug("%s added i2c device %d-%02x\n",
-			 __func__, bus, info->addr);
-
-	i2c_put_adapter(adapter);
-	return client;
-}
-
-static int __init __find_i2c_adap(struct device *dev, void *data)
-{
-	const char *name = data;
-	static const char *prefix = "i2c-";
-	struct i2c_adapter *adapter;
-	if (strncmp(dev_name(dev), prefix, strlen(prefix)) != 0)
-		return 0;
-	adapter = to_i2c_adapter(dev);
-	return (strncmp(adapter->name, name, strlen(name)) == 0);
-}
-
-static int __init find_i2c_adapter_num(enum i2c_adapter_type type)
-{
-	struct device *dev = NULL;
-	struct i2c_adapter *adapter;
-	const char *name = i2c_adapter_names[type];
-	/* find the adapter by name */
-	dev = bus_find_device(&i2c_bus_type, NULL, (void *)name,
-			      __find_i2c_adap);
-	if (!dev) {
-		pr_err("%s: i2c adapter %s not found on system.\n", __func__,
-		       name);
-		return -ENODEV;
-	}
-	adapter = to_i2c_adapter(dev);
-	return adapter->nr;
-}
-
-/*
- * Takes a list of addresses in addrs as such :
- * { addr1, ... , addrn, I2C_CLIENT_END };
- * add_probed_i2c_device will use i2c_new_probed_device
- * and probe for devices at all of the addresses listed.
- * Returns NULL if no devices found.
- * See Documentation/i2c/instantiating-devices for more information.
- */
-static __init struct i2c_client *add_probed_i2c_device(
-		const char *name,
-		enum i2c_adapter_type type,
-		struct i2c_board_info *info,
-		const unsigned short *addrs)
-{
-	return __add_probed_i2c_device(name,
-				       find_i2c_adapter_num(type),
-				       info,
-				       addrs);
-}
-
-/*
- * Probes for a device at a single address, the one provided by
- * info->addr.
- * Returns NULL if no device found.
- */
-static __init struct i2c_client *add_i2c_device(const char *name,
-						enum i2c_adapter_type type,
-						struct i2c_board_info *info)
-{
-	const unsigned short addr_list[] = { info->addr, I2C_CLIENT_END };
-	return __add_probed_i2c_device(name,
-				       find_i2c_adapter_num(type),
-				       info,
-				       addr_list);
-}
-
-
-static struct i2c_client __init *add_smbus_device(const char *name,
-						  struct i2c_board_info *info)
-{
-	return add_i2c_device(name, I2C_ADAPTER_SMBUS, info);
-}
-
-static int __init setup_cyapa_smbus_tp(const struct dmi_system_id *id)
-{
-	/* add cyapa touchpad on smbus */
-	tp = add_smbus_device("trackpad", &cyapa_device);
-	return 0;
-}
-
-static int __init setup_atmel_224s_tp(const struct dmi_system_id *id)
-{
-	const unsigned short addr_list[] = { ATMEL_TP_I2C_BL_ADDR,
-					     ATMEL_TP_I2C_ADDR,
-					     I2C_CLIENT_END };
-
-	/* add atmel mxt touchpad on VGA DDC GMBus */
-	tp = add_probed_i2c_device("trackpad", I2C_ADAPTER_VGADDC,
-				   &atmel_224s_tp_device, addr_list);
-	return 0;
-}
-
-static int __init setup_atmel_1664s_ts(const struct dmi_system_id *id)
-{
-	const unsigned short addr_list[] = { ATMEL_TS_I2C_BL_ADDR,
-					     ATMEL_TS_I2C_ADDR,
-					     I2C_CLIENT_END };
-
-	/* add atmel mxt touch device on PANEL GMBus */
-	ts = add_probed_i2c_device("touchscreen", I2C_ADAPTER_PANEL,
-				   &atmel_1664s_device, addr_list);
-	return 0;
-}
-
-
-static int __init setup_isl29018_als(const struct dmi_system_id *id)
-{
-	/* add isl29018 light sensor */
-	als = add_smbus_device("lightsensor", &isl_als_device);
-	return 0;
-}
-
-static int __init setup_isl29023_als(const struct dmi_system_id *id)
-{
-	/* add isl29023 light sensor on Panel GMBus */
-	als = add_i2c_device("lightsensor", I2C_ADAPTER_PANEL,
-			     &isl_als_device);
 	return 0;
 }
 
-static int __init setup_tsl2583_als(const struct dmi_system_id *id)
-{
-	/* add tsl2583 light sensor on smbus */
-	als = add_smbus_device(NULL, &tsl2583_als_device);
-	return 0;
-}
-
-static int __init setup_tsl2563_als(const struct dmi_system_id *id)
-{
-	/* add tsl2563 light sensor on smbus */
-	als = add_smbus_device(NULL, &tsl2563_als_device);
-	return 0;
-}
-
-static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
+#ifdef MODULE
+static struct dmi_system_id chromeos_laptop_dmi_table[] = {
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
 	},
 	{
-		.ident = "Chromebook Pixel - Touchpad",
+		.ident = "Chromebook Pixel",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
 		},
-		.callback = setup_atmel_224s_tp,
 	},
 	{
-		.ident = "Samsung Series 5 550 - Light Sensor",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lumpy"),
-		},
-		.callback = setup_isl29018_als,
-	},
-	{
-		.ident = "Chromebook Pixel - Light Sensor",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Link"),
-		},
-		.callback = setup_isl29023_als,
-	},
-	{
-		.ident = "Acer C7 Chromebook - Touchpad",
+		.ident = "Acer C7 Chromebook",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Parrot"),
 		},
-		.callback = setup_cyapa_smbus_tp,
 	},
 	{
-		.ident = "HP Pavilion 14 Chromebook - Touchpad",
+		.ident = "HP Pavilion 14 Chromebook",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Butterfly"),
 		},
-		.callback = setup_cyapa_smbus_tp,
 	},
 	{
-		.ident = "Samsung Series 5 - Light Sensor",
+		.ident = "Samsung Series 5",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alex"),
 		},
-		.callback = setup_tsl2583_als,
 	},
 	{
-		.ident = "Cr-48 - Light Sensor",
+		.ident = "Cr-48",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
 		},
-		.callback = setup_tsl2563_als,
 	},
 	{
-		.ident = "Acer AC700 - Light Sensor",
+		.ident = "Acer AC700",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
 		},
-		.callback = setup_tsl2563_als,
 	},
-	{ }
+	{ 0 }
 };
+#endif
 MODULE_DEVICE_TABLE(dmi, chromeos_laptop_dmi_table);
 
-static int __init chromeos_laptop_init(void)
+static struct client_entry smbus_i801_adapter_client_entries[] = {
+	{
+		.dmi_name = "trackpad",
+		.board_info = &cyapa_device,
+	},
+	{
+		.dmi_name = "lightsensor",
+		.board_info = &isl_als_device,
+	},
+	{
+		.dmi_name = NULL,
+		.board_info = &tsl2583_als_device,
+	},
+	{
+		.dmi_name = NULL,
+		.board_info = &tsl2563_als_device,
+	},
+	{ 0 },
+};
+
+static struct client_entry i915_gmbus_vga_client_entries[] = {
+	{
+		.dmi_name = "trackpad",
+		.board_info = &atmel_224s_tp_device,
+		.address_list = I2C_ADDRS(
+			ATMEL_TP_I2C_BL_ADDR,
+			ATMEL_TP_I2C_ADDR),
+	},
+	{ 0 },
+};
+
+static struct client_entry i915_gmbus_panel_client_entries[] = {
+	{
+		.dmi_name = "touchscreen",
+		.board_info = &atmel_1664s_device,
+		.address_list = I2C_ADDRS(
+			ATMEL_TS_I2C_BL_ADDR,
+			ATMEL_TS_I2C_ADDR),
+	},
+	{
+		.dmi_name = "lightsensor",
+		.board_info = &isl_als_device,
+	},
+	{ 0 },
+};
+
+static struct handled_adapter handled_adapters[] = {
+	{
+		.adapter_name = "SMBus I801 adapter", /* I2C_CLASS_HWMON */
+		.client_entries = smbus_i801_adapter_client_entries,
+	},
+	{
+		.adapter_name = "i915 gmbus vga", /* I2C_CLASS_DDC */
+		.client_entries = i915_gmbus_vga_client_entries,
+	},
+	{
+		.adapter_name = "i915 gmbus panel", /* I2C_CLASS_DDC */
+		.client_entries = i915_gmbus_panel_client_entries,
+	},
+	{ 0 },
+};
+
+static struct handled_adapter *to_handled_adapter(struct i2c_adapter *adap)
 {
-	if (!dmi_check_system(chromeos_laptop_dmi_table)) {
-		pr_debug("%s unsupported system.\n", __func__);
-		return -ENODEV;
+	struct handled_adapter *ha = handled_adapters;
+
+	while (ha->adapter_name) {
+		if (strcmp(adap->name, ha->adapter_name) == 0)
+			return ha;
+		ha++;
 	}
+
+	return NULL;
+}
+
+static int contains_addr(const unsigned short *address_list,
+			 unsigned short addr) {
+	int i;
+
+	for (i = 0; address_list[i] != I2C_CLIENT_END; i++) {
+		if (address_list[i] == addr)
+			return 1;
+	}
+
 	return 0;
 }
 
-static void __exit chromeos_laptop_exit(void)
+static int client_supports_address(struct client_entry *client_entry,
+				   unsigned short addr) {
+	if (!client_entry->address_list)
+		return client_entry->board_info->addr == addr;
+	else
+		return contains_addr(client_entry->address_list, addr);
+}
+
+static struct client_entry *to_client_entry(struct handled_adapter *ha,
+					    unsigned short addr) {
+	struct client_entry *ce = ha->client_entries;
+
+	while (ce->board_info) {
+		if (client_supports_address(ce, addr))
+			return ce;
+		ce++;
+	}
+
+	return NULL;
+}
+
+static void copy_client_entry_to_board_info(struct client_entry *client_entry,
+					    struct i2c_board_info *info) {
+	const struct i2c_board_info *source_info = client_entry->board_info;
+
+	strncpy(info->type, source_info->type, strlen(source_info->type));
+	info->flags = source_info->flags;
+	info->addr = source_info->addr;
+	info->platform_data = source_info->platform_data;
+	info->archdata = source_info->archdata;
+	info->of_node = source_info->of_node;
+	info->acpi_node = source_info->acpi_node;
+	info->irq = get_irq_for_dmi_name(client_entry->dmi_name);
+}
+
+static int chromeos_laptop_detect(struct i2c_client *client,
+				  struct i2c_board_info *info)
 {
-	if (als)
-		i2c_unregister_device(als);
-	if (tp)
-		i2c_unregister_device(tp);
-	if (ts)
-		i2c_unregister_device(ts);
+	struct i2c_adapter *adapter = client->adapter;
+	struct handled_adapter *ha;
+	struct client_entry *ce;
+
+	ha = to_handled_adapter(adapter);
+	if (!ha)
+		return -ENODEV;
+
+	ce = to_client_entry(ha, info->addr);
+	if (!ce)
+		return -ENODEV;
+
+	copy_client_entry_to_board_info(ce, info);
+	return 0;
 }
 
-module_init(chromeos_laptop_init);
-module_exit(chromeos_laptop_exit);
+
+static struct i2c_driver chromeos_laptop_driver = {
+	.driver = {
+		.name = "chromeos_laptop",
+	},
+	.address_list   = I2C_ADDRS(ATMEL_TP_I2C_ADDR, ATMEL_TP_I2C_BL_ADDR,
+				    ATMEL_TS_I2C_ADDR, ATMEL_TS_I2C_BL_ADDR,
+				    CYAPA_TP_I2C_ADDR, ISL_ALS_I2C_ADDR,
+				    TAOS_ALS_I2C_ADDR),
+	.detect         = chromeos_laptop_detect,
+	.class          = I2C_CLASS_DDC | I2C_CLASS_HWMON,
+};
+
+module_i2c_driver(chromeos_laptop_driver);
 
 MODULE_DESCRIPTION("Chrome OS Laptop driver");
-MODULE_AUTHOR("Benson Leung <bleung@chromium.org>");
+MODULE_AUTHOR("Benson Leung <bleung@chromium.org>, Martin Nordholts <enselic@gmail.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.10.4

