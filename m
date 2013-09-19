Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3ISQTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:19:03 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11947 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3ISQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:19:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Sep 2013 09:18:59 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [Patch V2] drivers: power: Add support for bq24735 charger
Date: Thu, 19 Sep 2013 12:18:33 -0400
Message-ID: <1379607514-11200-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darbha Sriharsha <dsriharsha@nvidia.com>

Adding driver support for bq24735 charger chipset.

Signed-off-by: Darbha Sriharsha <dsriharsha@nvidia.com>
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---

v2:
 - gpio_request -> devm_gpio_request

 .../bindings/power_supply/ti,bq24735.txt           |   56 +++
 drivers/power/Kconfig                              |    8 +
 drivers/power/Makefile                             |    1 +
 drivers/power/bq24735-charger.c                    |  384 ++++++++++++++++++++
 include/linux/power/bq24735-charger.h              |   68 ++++
 5 files changed, 517 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
 create mode 100644 drivers/power/bq24735-charger.c
 create mode 100644 include/linux/power/bq24735-charger.h

diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
new file mode 100644
index 0000000..19ea5a2
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
@@ -0,0 +1,56 @@
+TI BQ24735 Charge Controller
+~~~~~~~~~~
+
+Required properties :
+ - compatible : "ti,bq24735"
+
+Optional properties :
+ - ti,ac-detect: This gpio is optionally used to read the ac adapter
+   presence.
+ - ti,charge-current : Used to control and set the charging current. This value
+   must follow the below guidelines:
+	bit 0 - 5:	Not used
+	bit 6:		1 = Adds 64mA of charger current
+	bit 7:		1 = Adds 128mA of charger current
+	bit 8:		1 = Adds 256mA of charger current
+	bit 9:		1 = Adds 512mA of charger current
+	bit 10:		1 = Adds 1024mA of charger current
+	bit 11:		1 = Adds 2048mA of charger current
+	bit 12:		1 = Adds 4096mA of charger current
+	bit 13 - 15:	Not used
+   Setting the value to < 128mA or > 8.128A terminates charging.
+ - ti,charge-voltage : Used to control and set the charging voltage. This value
+   must follow the below guidelines:
+	bit 0 - 3:	Not used
+	bit 4:		1 = Adds 16mV of charger voltage
+	bit 5:		1 = Adds 32mV of charger voltage
+	bit 6:		1 = Adds 64mV of charger voltage
+	bit 7:		1 = Adds 128mV of charger voltage
+	bit 8:		1 = Adds 256mV of charger voltage
+	bit 9:		1 = Adds 512mV of charger voltage
+	bit 10:		1 = Adds 1024mV of charger voltage
+	bit 11:		1 = Adds 2048mV of charger voltage
+	bit 12:		1 = Adds 4096mV of charger voltage
+	bit 13:		1 = Adds 8192mV of charger voltage
+	bit 14:		1 = Adds 16384mV of charger voltage
+	bit 15:		Not used
+   Setting the value to < 1.024V or > 19.2V terminates charging.
+ - ti,input-current:	Used to control and set the charger input current. This
+   value must follow the below guidelines:
+	bit 0 - 6:	Not used
+	bit 7:		1 = Adds 128mA of input current
+	bit 8:		1 = Adds 256mA of input current
+	bit 9:		1 = Adds 512mA of input current
+	bit 10:		1 = Adds 1024mA of input current
+	bit 11:		1 = Adds 2048mA of input current
+	bit 12:		1 = Adds 4086mA of input current
+	bit 13 - 15:	Not used
+   Setting the value to < 128mA or > 8.064A terminates charging.
+
+Example:
+
+	bq24735@9 {
+		compatible = "ti,bq24735";
+		reg = < 0x9 >;
+		ti,ac-detect = <&gpio 72 0x1>;
+	}
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e8970a6..380968d 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -340,6 +340,14 @@ config CHARGER_BQ24190
 	help
 	  Say Y to enable support for the TI BQ24190 battery charger.
 
+config CHARGER_BQ24735
+	tristate "BQ24735 battery charger support"
+	depends on I2C && GPIOLIB
+	help
+	  bq24735 is the battery charger chipset.
+	  Say Y here to enable battery charging driver support for
+	  bq24735
+
 config CHARGER_SMB347
 	tristate "Summit Microelectronics SMB347 Battery Charger"
 	depends on I2C
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 4ae4533..e65487b 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
 obj-$(CONFIG_CHARGER_BQ24190)	+= bq24190_charger.o
+obj-$(CONFIG_CHARGER_BQ24735)	+= bq24735-charger.o
 obj-$(CONFIG_POWER_AVS)		+= avs/
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
 obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
diff --git a/drivers/power/bq24735-charger.c b/drivers/power/bq24735-charger.c
new file mode 100644
index 0000000..8271558
--- /dev/null
+++ b/drivers/power/bq24735-charger.c
@@ -0,0 +1,384 @@
+/*
+ * drivers/power/bq24735-charger.c
+ *
+ * Battery charger driver for bq24735 from TI
+ *
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/power_supply.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+
+#include <linux/power/bq24735-charger.h>
+
+struct bq24735_charger {
+	struct power_supply	charger;
+	struct device		*dev;
+	struct i2c_client	*client;
+	struct bq24735_platform	*pdata;
+	int			irq;
+};
+
+static enum power_supply_property bq24735_charger_properties[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static int bq24735_write_word(struct i2c_client *client, int reg, u16 value)
+{
+	s32 ret;
+
+	ret = i2c_smbus_write_word_data(client, reg, le16_to_cpu(value));
+	if (ret < 0)
+		dev_err(&client->dev, "Failed in writing to 0x%x\n", reg);
+	return ret;
+}
+
+static int bq24735_read_word(struct i2c_client *client, int reg)
+{
+	s32 ret;
+
+	ret = i2c_smbus_read_word_data(client, reg);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed in reading from 0x%x\n", reg);
+		return ret;
+	}
+
+	return le16_to_cpu(ret);
+}
+
+static int bq24735_update_word(struct i2c_client *client, int reg,
+			       u16 mask, u16 value)
+{
+	unsigned int tmp;
+	int ret;
+
+	ret = bq24735_read_word(client, reg);
+	if (ret < 0)
+		return ret;
+
+	tmp = ret & ~mask;
+	tmp |= value & mask;
+
+	ret = bq24735_write_word(client, reg, tmp);
+
+	return ret;
+}
+
+static int bq24735_config_charger(struct bq24735_charger *charger)
+{
+	int ret = 0;
+	u16 value = 0;
+	struct bq24735_platform *pdata = charger->pdata;
+
+	if (pdata->charge_current) {
+		value = pdata->charge_current & BQ24735_CHARGE_CURRENT_MASK;
+
+		ret = bq24735_write_word(charger->client,
+					 BQ24735_CHARGE_CURRENT_REG, value);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (pdata->charge_voltage) {
+		value = pdata->charge_voltage & BQ24735_CHARGE_VOLTAGE_MASK;
+
+		ret = bq24735_write_word(charger->client,
+					 BQ24735_CHARGE_VOLTAGE_REG, value);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (pdata->input_current) {
+		value = pdata->input_current & BQ24735_INPUT_CURRENT_MASK;
+
+		ret = bq24735_write_word(charger->client,
+					 BQ24735_INPUT_CURRENT_REG, value);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+
+static irqreturn_t bq24735_charger_isr(int irq, void *devid)
+{
+	struct power_supply *charger = devid;
+
+	power_supply_changed(charger);
+
+	return IRQ_HANDLED;
+}
+
+static int bq24735_charger_get_property(struct power_supply *psy,
+	enum power_supply_property psp, union power_supply_propval *val)
+{
+	struct bq24735_charger *bq24735_charger;
+	struct bq24735_platform *pdata;
+
+	bq24735_charger = container_of(psy, struct bq24735_charger, charger);
+	pdata = bq24735_charger->pdata;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		if (pdata->status_gpio) {
+			val->intval = gpio_get_value_cansleep(
+							pdata->status_gpio);
+			val->intval ^=  pdata->gpio_active_low;
+		} else {
+			int ac = 0;
+
+			ac = bq24735_read_word(bq24735_charger->client,
+						BQ24735_CHG_OPT_REG);
+			val->intval = (ac & BQ24735_CHG_OPT_AC_PRESENT) ? 1 : 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int bq24735_enable_charging(struct bq24735_charger *charger)
+{
+	int ret = 0;
+
+	ret = bq24735_update_word(charger->client, BQ24735_CHG_OPT_REG,
+				  BQ24735_CHG_OPT_CHARGE_ENABLE,
+				  BQ24735_ENABLE_CHARGING);
+	return ret;
+}
+
+#ifdef CONFIG_OF
+static struct bq24735_platform *bq24735_parse_dt_data(
+		struct i2c_client *client)
+{
+	struct bq24735_platform *pdata;
+	struct device_node *np = client->dev.of_node;
+	u32 val;
+	int ret;
+	enum of_gpio_flags flags;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&client->dev,
+			"Memory alloc for bq24735 pdata failed\n");
+		return NULL;
+	}
+
+	pdata->status_gpio = of_get_named_gpio_flags(np, "ti,ac-detect",
+						     0, &flags);
+
+	if (flags & OF_GPIO_ACTIVE_LOW)
+		pdata->gpio_active_low = 1;
+
+	ret = of_property_read_u32(np, "ti,charge-current", &val);
+	if (!ret)
+		pdata->charge_current = val;
+
+	ret = of_property_read_u32(np, "ti,charge-voltage", &val);
+	if (!ret)
+		pdata->charge_voltage = val;
+
+	ret = of_property_read_u32(np, "ti,input-current", &val);
+	if (!ret)
+		pdata->input_current = val;
+
+	return pdata;
+}
+#else
+static inline struct bq24735_platform *bq24735_parse_dt_data(
+		struct i2c_client *client)
+{
+	return NULL;
+}
+#endif
+
+static int bq24735_charger_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int ret = 0;
+	struct bq24735_charger *charger_device;
+	struct power_supply *charger;
+	char *name;
+
+	charger_device = devm_kzalloc(&client->dev, sizeof(*charger_device),
+		GFP_KERNEL);
+	if (!charger_device) {
+		dev_err(&client->dev, "failed to allocate memory status\n");
+		return -ENOMEM;
+	}
+
+	charger_device->pdata = client->dev.platform_data;
+
+	if (!charger_device->pdata && client->dev.of_node)
+		charger_device->pdata = bq24735_parse_dt_data(client);
+
+	if (!charger_device->pdata) {
+		dev_err(&client->dev, "no platform data provided\n");
+		return -EINVAL;
+	}
+
+	name = charger_device->pdata->name;
+	if (!name) {
+		name = kasprintf(GFP_KERNEL, "bq24735-%s",
+				 dev_name(&client->dev));
+		if (!name) {
+			dev_err(&client->dev, "Failed to alloc device name\n");
+			return -ENOMEM;
+		}
+	}
+
+	charger_device->dev = &client->dev;
+	charger_device->client = client;
+
+	charger = &charger_device->charger;
+
+	charger->name = name;
+	charger->type = POWER_SUPPLY_TYPE_MAINS;
+	charger->properties = bq24735_charger_properties;
+	charger->num_properties = ARRAY_SIZE(bq24735_charger_properties);
+	charger->get_property = bq24735_charger_get_property;
+	charger->supplied_to = charger_device->pdata->supplied_to;
+	charger->num_supplicants = charger_device->pdata->num_supplicants;
+	charger->of_node = client->dev.of_node;
+
+	i2c_set_clientdata(client, charger_device);
+
+	ret = bq24735_read_word(charger_device->client,
+				BQ24735_MANUFACTURER_ID_REG);
+	if (ret != BQ24735_MANUFACTURER_ID) {
+		dev_err(charger_device->dev,
+		"manufacturer id mismatch..exiting driver..\n");
+		ret = -ENODEV;
+		goto err_free_name;
+	}
+
+	if (client->irq) {
+		ret = devm_request_threaded_irq(&client->dev, client->irq,
+			NULL, bq24735_charger_isr,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+			IRQF_ONESHOT,
+			charger->name, charger);
+		if (ret) {
+			dev_err(&client->dev,
+				"Unable to register irq %d err %d\n",
+				client->irq, ret);
+			goto err_free_name;
+		}
+		charger_device->irq = client->irq;
+	}
+
+	if (charger_device->pdata->status_gpio) {
+		if (!gpio_is_valid(charger_device->pdata->status_gpio)) {
+			dev_err(&client->dev, "Invalid gpio pin\n");
+			ret = -EINVAL;
+			goto err_free_name;
+		}
+
+		ret = devm_gpio_request(&client->dev,
+					charger_device->pdata->status_gpio,
+					name);
+		if (ret) {
+			dev_err(&client->dev, "Failed gpio request: %d\n", ret);
+			goto err_free_name;
+		}
+	}
+
+	ret = bq24735_config_charger(charger_device);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed in configuring charger");
+		goto err_free_name;
+	}
+
+	/* check for AC adapter presence */
+	ret = bq24735_read_word(charger_device->client, BQ24735_CHG_OPT_REG);
+	if (ret < 0)
+		goto err_free_name;
+	else if (ret & BQ24735_CHG_OPT_AC_PRESENT) {
+		/* enable charging */
+		ret = bq24735_enable_charging(charger_device);
+		if (ret < 0)
+			goto err_free_name;
+	}
+
+	ret = power_supply_register(&client->dev, charger);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to register power supply: %d\n",
+				ret);
+		goto err_free_name;
+	}
+
+	return 0;
+
+err_free_name:
+	if (name && name != charger_device->pdata->name)
+		kfree(name);
+
+	return ret;
+}
+
+static int bq24735_charger_remove(struct i2c_client *client)
+{
+	struct bq24735_charger *charger_device = i2c_get_clientdata(client);
+
+	if (charger_device->irq)
+		devm_free_irq(charger_device->dev, charger_device->irq,
+				&charger_device->charger);
+
+	power_supply_unregister(&charger_device->charger);
+
+	if (charger_device->charger.name != charger_device->pdata->name)
+		kfree(charger_device->charger.name);
+
+	return 0;
+}
+
+static const struct i2c_device_id bq24735_charger_id[] = {
+	{ "bq24735-charger", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, bq24735_charger_id);
+
+static const struct of_device_id bq24735_match_ids[] = {
+	{ .compatible = "ti,bq24735", },
+	{ /* end */ }
+};
+MODULE_DEVICE_TABLE(of, bq24735_match_ids);
+
+static struct i2c_driver bq24735_charger_driver = {
+	.driver = {
+		.name = "bq24735-charger",
+		.owner = THIS_MODULE,
+		.of_match_table = bq24735_match_ids,
+	},
+	.probe = bq24735_charger_probe,
+	.remove = bq24735_charger_remove,
+	.id_table = bq24735_charger_id,
+};
+
+module_i2c_driver(bq24735_charger_driver);
+
+MODULE_DESCRIPTION("bq24735 battery charging driver");
+MODULE_AUTHOR("Darbha Sriharsha <dsriharsha@nvidia.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/power/bq24735-charger.h b/include/linux/power/bq24735-charger.h
new file mode 100644
index 0000000..9663c57
--- /dev/null
+++ b/include/linux/power/bq24735-charger.h
@@ -0,0 +1,68 @@
+/*
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __CHARGER_BQ24735_H_
+#define __CHARGER_BQ24735_H_
+
+#include <linux/types.h>
+#include <linux/power_supply.h>
+
+#define BQ24735_CHG_OPT_REG		0x12
+#define BQ24735_CHG_OPT_CHARGE_ENABLE	(1 << 0)
+#define BQ24735_ENABLE_CHARGING		0
+#define BQ24735_DISABLE_CHARGING	1
+#define BQ24735_CHG_OPT_ACOC_THRESHOLD	(1 << 1)
+#define BQ24735_CHG_OPT_BOOST_MODE	(1 << 2)
+#define BQ24735_CHG_OPT_BOOST_ENABLE	(1 << 3)
+#define BQ24735_CHG_OPT_AC_PRESENT	(1 << 4)
+#define BQ24735_CHG_OPT_IOUT_SELECTION	(1 << 5)
+#define BQ24735_CHG_OPT_LEARN_ENABLE	(1 << 6)
+#define BQ24735_CHG_OPT_IFAULT_LOW	(1 << 7)
+#define BQ24735_CHG_OPT_IFAULT_HIGH	(1 << 8)
+#define BQ24735_CHG_OPT_EMI_SW_FREQ_EN	(1 << 9)
+#define BQ24735_CHG_OPT_EMI_SW_FREQ_ADJ	(1 << 10)
+#define BQ24735_CHG_OPT_BAT_DEPLETION	(3 << 11)
+#define BQ24735_CHG_OPT_WATCHDOG_TIMER	(3 << 13)
+#define BQ24735_CHG_OPT_ACOK_DEGLITCH	(1 << 15)
+#define BQ24735_CHARGE_CURRENT_REG	0x14
+#define BQ24735_CHARGE_CURRENT_MASK	0x1fc0
+#define BQ24735_CHARGE_VOLTAGE_REG	0x15
+#define BQ24735_CHARGE_VOLTAGE_MASK	0x7ff0
+#define BQ24735_INPUT_CURRENT_REG	0x3f
+#define BQ24735_INPUT_CURRENT_MASK	0x1f80
+#define BQ24735_MANUFACTURER_ID_REG	0xfe
+#define BQ24735_DEVICE_ID_REG		0xff
+
+#define BQ24735_MANUFACTURER_ID		0x0040
+#define BQ24735_DEVICE_ID		0x000B
+
+
+struct bq24735_platform {
+	uint32_t charge_current;
+	uint32_t charge_voltage;
+	uint32_t input_current;
+
+	const char *name;
+
+	int status_gpio;
+	int gpio_active_low;
+
+	char **supplied_to;
+	size_t num_supplicants;
+};
+
+#endif /* __CHARGER_BQ24735_H_ */
-- 
1.7.9.5

