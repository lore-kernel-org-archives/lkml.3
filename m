Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3IAUA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:00:27 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47240 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IAUAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:00:25 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] mfd: add STw481x driver
Date: Sun,  1 Sep 2013 22:00:14 +0200
Message-Id: <1378065614-18094-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the STw481x PMICs found in the Nomadik
family of platforms. This one uses pure device tree probing.
Print some of the OTP registers on boot and register a regulator
MFD child.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Sam, I'm seeking an ACK for this driver to take it through
the ARM SoC tree with the enablement patches.
---
 drivers/mfd/Kconfig         |  10 ++
 drivers/mfd/Makefile        |   1 +
 drivers/mfd/stw481x.c       | 250 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/stw481x.h |  67 ++++++++++++
 4 files changed, 328 insertions(+)
 create mode 100644 drivers/mfd/stw481x.c
 create mode 100644 include/linux/mfd/stw481x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index aecd6dd..bd6b521 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1145,6 +1145,16 @@ config MFD_WM8994
 	  core support for the WM8994, in order to use the actual
 	  functionaltiy of the device other drivers must be enabled.
 
+config MFD_STW481X
+	bool "Support for ST Microelectronics STw481x"
+	depends on I2C && ARCH_NOMADIK
+	select REGMAP_I2C
+	select MFD_CORE
+	help
+	  Select this option to enable the STw481x chip driver used
+	  in various ST Microelectronics and ST-Ericsson embedded
+	  Nomadik series.
+
 endmenu
 endif
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3c90051..1e1242c 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -159,3 +159,4 @@ obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
 obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
+obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
diff --git a/drivers/mfd/stw481x.c b/drivers/mfd/stw481x.c
new file mode 100644
index 0000000..b77f504
--- /dev/null
+++ b/drivers/mfd/stw481x.c
@@ -0,0 +1,250 @@
+/*
+ * Core driver for STw4810/STw4811
+ *
+ * Copyright (C) 2013 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/stw481x.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+
+/*
+ * This driver can only access the non-USB portions of STw4811, the register
+ * range 0x00-0x10 dealing with USB is bound to the two special I2C pins used
+ * for USB control.
+ */
+
+static int stw481x_get_pctl_reg(struct stw481x *stw481x, u8 reg)
+{
+	u8 msb = (reg >> 3) & 0x03;
+	u8 lsb = (reg << 5) & 0xe0;
+	unsigned int val;
+	u8 vrfy;
+	int ret;
+
+	ret = regmap_write(stw481x->map, 0x1f, msb);
+	if (ret)
+		return ret;
+	ret = regmap_write(stw481x->map, 0x1e, lsb);
+	if (ret)
+		return ret;
+	ret = regmap_read(stw481x->map, 0x1f, &val);
+	if (ret)
+		return ret;
+	vrfy = (val & 0x03) << 3;
+	ret = regmap_read(stw481x->map, 0x1e, &val);
+	if (ret)
+		return ret;
+	vrfy |= ((val >> 5) & 0x07);
+	if (vrfy != reg)
+		return -EIO;
+	return (val >> 1) & 0x0f;
+}
+
+static int stw481x_startup(struct stw481x *stw481x)
+{
+	u8 vcore_val[] = { 100, 105, 110, 115, 120, 122, 124, 126, 128,
+			   130, 132, 134, 136, 138, 140, 145 };
+	u8 vpll_val[] = { 105, 120, 130, 180 };
+	u8 vaux_val[] = { 15, 18, 25, 28 };
+	u8 vcore;
+	u8 vcore_slp;
+	u8 vpll;
+	u8 vaux;
+	bool vaux_en;
+	bool it_warn;
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(stw481x->map, STW_CONF1, &val);
+	if (ret)
+		return ret;
+	vaux_en = !!(val & STW_CONF1_PDN_VAUX);
+	it_warn = !!(val & STW_CONF1_IT_WARN);
+
+	dev_info(&stw481x->client->dev, "voltages %s\n",
+		(val & STW_CONF1_V_MONITORING) ? "OK" : "LOW");
+	dev_info(&stw481x->client->dev, "MMC level shifter %s\n",
+		(val & STW_CONF1_MMC_LS_STATUS) ? "high impedance" : "ON");
+	dev_info(&stw481x->client->dev, "VMMC: %s\n",
+		(val & STW_CONF1_PDN_VMMC) ? "ON" : "disabled");
+
+	dev_info(&stw481x->client->dev, "STw481x power control registers:\n");
+
+	ret = stw481x_get_pctl_reg(stw481x, STW_PC_VCORE_SEL);
+	if (ret < 0)
+		return ret;
+	vcore = ret & 0x0f;
+
+	ret = stw481x_get_pctl_reg(stw481x, STW_PC_VAUX_SEL);
+	if (ret < 0)
+		return ret;
+	vaux = (ret >> 2) & 3;
+	vpll = (ret >> 4) & 1; /* Save bit 4 */
+
+	ret = stw481x_get_pctl_reg(stw481x, STW_PC_VPLL_SEL);
+	if (ret < 0)
+		return ret;
+	vpll |= (ret >> 1) & 2;
+
+	dev_info(&stw481x->client->dev, "VCORE: %u.%uV %s\n",
+		vcore_val[vcore] / 100, vcore_val[vcore] % 100,
+		(ret & 4) ? "ON" : "OFF");
+
+	dev_info(&stw481x->client->dev, "VPLL:  %u.%uV %s\n",
+		vpll_val[vpll] / 100, vpll_val[vpll] % 100,
+		(ret & 0x10) ? "ON" : "OFF");
+
+	dev_info(&stw481x->client->dev, "VAUX:  %u.%uV %s\n",
+		vaux_val[vaux] / 10, vaux_val[vaux] % 10,
+		vaux_en ? "ON" : "OFF");
+
+	ret = regmap_read(stw481x->map, STW_CONF2, &val);
+	if (ret)
+		return ret;
+
+	dev_info(&stw481x->client->dev, "TWARN: %s threshold, %s\n",
+		it_warn ? "below" : "above",
+		(val & STW_CONF2_MASK_TWARN) ? "enabled" : "mask through VDDOK");
+	dev_info(&stw481x->client->dev, "VMMC: %s\n",
+		(val & STW_CONF2_VMMC_EXT) ? "internal" : "external");
+	dev_info(&stw481x->client->dev, "IT WAKE UP: %s\n",
+		(val & STW_CONF2_MASK_IT_WAKE_UP) ? "enabled" : "masked");
+	dev_info(&stw481x->client->dev, "GPO1: %s\n",
+		(val & STW_CONF2_GPO1) ? "low" : "high impedance");
+	dev_info(&stw481x->client->dev, "GPO2: %s\n",
+		(val & STW_CONF2_GPO2) ? "low" : "high impedance");
+
+	ret = regmap_read(stw481x->map, STW_VCORE_SLEEP, &val);
+	if (ret)
+		return ret;
+	vcore_slp = val & 0x0f;
+	dev_info(&stw481x->client->dev, "VCORE SLEEP: %u.%uV\n",
+		vcore_val[vcore_slp] / 100, vcore_val[vcore_slp] % 100);
+
+	return 0;
+}
+
+/*
+ * MFD cells - we have one cell which is selected operation
+ * mode, and we always have a GPIO cell.
+ */
+static struct mfd_cell stw481x_cells[] = {
+	{
+		.of_compatible = "st,stw481x-vmmc",
+		.name = "stw481x-vmmc-regulator",
+		.id = -1,
+	},
+};
+
+const struct regmap_config stw481x_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int stw481x_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct stw481x			*stw481x;
+	struct stw481x_platform_data	*pdata = client->dev.platform_data;
+	int ret;
+	int i;
+
+	stw481x = devm_kzalloc(&client->dev, sizeof(*stw481x), GFP_KERNEL);
+	if (!stw481x)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, stw481x);
+	stw481x->client = client;
+	stw481x->pdata = pdata;
+	stw481x->map = devm_regmap_init_i2c(client, &stw481x_regmap_config);
+
+	ret = stw481x_startup(stw481x);
+	if (ret) {
+		dev_err(&client->dev, "chip initialization failed\n");
+		goto fail;
+	}
+
+	/* Set up and register the platform devices. */
+	for (i = 0; i < ARRAY_SIZE(stw481x_cells); i++) {
+		/* One state holder for all drivers, this is simple */
+		stw481x_cells[i].platform_data = stw481x;
+		stw481x_cells[i].pdata_size = sizeof(*stw481x);
+	}
+
+	ret = mfd_add_devices(&client->dev, 0, stw481x_cells,
+			ARRAY_SIZE(stw481x_cells), NULL, 0, NULL);
+	if (ret)
+		goto fail;
+
+	dev_info(&client->dev, "initialized STw481x device\n");
+
+	return 0;
+
+fail:
+	devm_kfree(&client->dev, stw481x);
+	return ret;
+}
+
+static int stw481x_remove(struct i2c_client *client)
+{
+	struct stw481x *stw481x = i2c_get_clientdata(client);
+
+	mfd_remove_devices(&client->dev);
+	devm_kfree(&client->dev, stw481x);
+	return 0;
+}
+
+/*
+ * This ID table is completely unused, as this is a pure
+ * device-tree probed driver, but it has to be here due to
+ * the structure of the I2C core.
+ */
+static const struct i2c_device_id dummy_id[] = {
+	{ "dummy", 0 },
+	{ }
+};
+
+static const struct of_device_id stw481x_match[] = {
+	{ .compatible = "st,stw4810", },
+	{ .compatible = "st,stw4811", },
+        {},
+};
+MODULE_DEVICE_TABLE(of, stw481x_match);
+
+static struct i2c_driver stw481x_driver = {
+	.driver = {
+		.name	= "stw481x",
+		.of_match_table = stw481x_match,
+	},
+	.probe		= stw481x_probe,
+	.remove		= stw481x_remove,
+	.id_table	= dummy_id,
+};
+
+static int __init stw481x_init(void)
+{
+	return i2c_add_driver(&stw481x_driver);
+}
+module_init(stw481x_init);
+
+static void __exit stw481x_exit(void)
+{
+	i2c_del_driver(&stw481x_driver);
+}
+module_exit(stw481x_exit);
+
+MODULE_AUTHOR("Linus Walleij");
+MODULE_DESCRIPTION("STw481x PMIC driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/stw481x.h b/include/linux/mfd/stw481x.h
new file mode 100644
index 0000000..dd4d9f8
--- /dev/null
+++ b/include/linux/mfd/stw481x.h
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2011 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#ifndef MFD_STW481X_H
+#define MFD_STW481X_H
+
+#include <linux/i2c.h>
+#include <linux/regulator/machine.h>
+#include <linux/regmap.h>
+#include <linux/bitops.h>
+
+/* These registers are accessed from more than one driver */
+#define STW_CONF1			0x11U
+#define STW_CONF1_PDN_VMMC		0x01U
+#define STW_CONF1_VMMC_MASK		0x0eU
+#define STW_CONF1_VMMC_1_8V		0x02U
+#define STW_CONF1_VMMC_2_85V		0x04U
+#define STW_CONF1_VMMC_3V		0x06U
+#define STW_CONF1_VMMC_1_85V		0x08U
+#define STW_CONF1_VMMC_2_6V		0x0aU
+#define STW_CONF1_VMMC_2_7V		0x0cU
+#define STW_CONF1_VMMC_3_3V		0x0eU
+#define STW_CONF1_MMC_LS_STATUS		0x10U
+#define STW_CONF1_V_MONITORING		0x20U
+#define STW_CONF1_IT_WARN		0x40U
+#define STW_CONF1_PDN_VAUX		0x80U
+#define STW_PC_VCORE_SEL		0x05U
+#define STW_PC_VAUX_SEL			0x06U
+#define STW_PC_VPLL_SEL			0x07U
+#define STW_CONF2			0x20U
+#define STW_CONF2_MASK_TWARN		0x01U
+#define STW_CONF2_VMMC_EXT		0x02U
+#define STW_CONF2_MASK_IT_WAKE_UP	0x04U
+#define STW_CONF2_GPO1			0x08U
+#define STW_CONF2_GPO2			0x10U
+#define STW_VCORE_SLEEP			0x21U
+
+/**
+ * struct stw481x_platform_data - TPS61905x platform data
+ * @regulator_data: initialization data for the voltage
+ *	regulator if used as a voltage source
+ */
+struct stw481x_platform_data {
+	struct regulator_init_data *regulator_data;
+};
+
+/**
+ * struct stw481x - state holder for the Stw481x drivers
+ * @mutex: mutex to serialize I2C accesses
+ * @i2c_client: corresponding I2C client
+ * @regulator: regulator device for regulator children
+ * @map: regmap handle to access device registers
+ */
+struct stw481x {
+	struct stw481x_platform_data *pdata;
+	struct mutex		lock;
+	struct i2c_client	*client;
+	struct regulator_dev	*vmmc_regulator;
+	struct regmap		*map;
+};
+
+#endif
-- 
1.8.1.4

