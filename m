Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3IXVjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:39:41 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18410 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab3IXVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:39:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Sep 2013 14:39:38 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [Patch V3] drivers: power: Add support for bq24735 charger
Date: Tue, 24 Sep 2013 17:39:45 -0400
Message-ID: <1380058785-18748-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darbha Sriharsha <dsriharsha@nvidia.com>

Adds support for the bq24735 charger chipset. The bq24735 is a
high-efficiency, synchronous battery charger.

It allows control of the charging current, input current, and the charger
voltage DAC's through SMBus.

Signed-off-by: Darbha Sriharsha <dsriharsha@nvidia.com>
Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
*Note: I decided to maintain non-DT support, but tried to do it in the most
clean manner using the suggestions from Thierry Reding.

v3:
 - Simplified devicetree bindings for charger current/voltage and input current
 - added optional interrupts property for setting client->irq
 - renamed ti,ac-detect to ti,ac-detect-gpios
 - modeled Kconfig entry after TI BQ24190 entry
 - cleaned up whitespace/sorting review comments
 - moved register/bit definitions to .c file
 - renamed gpio_active_low to status_gpio_active_low
 - added status_gpio_valid to handle gpio = 0 as valid
 - simplified the struct bq24735_charger -> struct bq24735 and removed
   dev and irq fields
 - made bq24735[write/read]_word inline functions with error checking at
   caller sites
 - fixed support for enable/disable and added calls into isr as appropriate
 - moved charger present logic into separate function
 - moved devm_request_threaded_irq after power_supply_register so we can't
   get into the isr with an unregistered power_supply
 - removed ifdeffery around CONFIG_OF, using IS_ENABLED() instead

v2:
 - gpio_request -> devm_gpio_request

 .../bindings/power_supply/ti,bq24735.txt           |   28 ++
 drivers/power/Kconfig                              |    6 +
 drivers/power/Makefile                             |    1 +
 drivers/power/bq24735-charger.c                    |  416 ++++++++++++++++++++
 include/linux/power/bq24735-charger.h              |   39 ++
 5 files changed, 490 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
 create mode 100644 drivers/power/bq24735-charger.c
 create mode 100644 include/linux/power/bq24735-charger.h

diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
new file mode 100644
index 0000000..67ff4a0
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt
@@ -0,0 +1,28 @@
+TI BQ24735 Charge Controller
+~~~~~~~~~~
+
+Required properties :
+ - compatible : "ti,bq24735"
+
+Optional properties :
+ - interrupts : Specify the interrupt to be used to trigger when the AC
+   adapter is either plugged in or removed.
+ - ti,ac-detect-gpios : This GPIO is optionally used to read the AC adapter
+   presence.
+ - ti,charge-current : Used to control and set the charging current. This value
+   must be between 128mA and 8.128A with a 64mA step resolution. The POR value
+   is 0x0000h. See spec for more details.
+ - ti,charge-voltage : Used to control and set the charging voltage. This value
+   must be between 1.024V and 19.2V with a 16mV step resolution. The POR value
+   is 0x0000h. See spec for more details.
+ - ti,input-current : Used to control and set the charger input current. This
+   value must be between 128mA and 8.064A with a 128mA step resolution. The
+   POR value is 0x1000h. See spec for more details.
+
+Example:
+
+	bq24735@9 {
+		compatible = "ti,bq24735";
+		reg = <0x9>;
+		ti,ac-detect-gpios = <&gpio 72 0x1>;
+	}
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e8970a6..655e8bf 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -340,6 +340,12 @@ config CHARGER_BQ24190
 	help
 	  Say Y to enable support for the TI BQ24190 battery charger.
 
+config CHARGER_BQ24735
+	tristate "TI BQ24735 battery charger support"
+	depends on I2C && GPIOLIB
+	help
+	  Say Y to enable support for the TI BQ24735 battery charger.
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
index 0000000..5ed5543
--- /dev/null
+++ b/drivers/power/bq24735-charger.c
@@ -0,0 +1,416 @@
+/*
+ * Battery charger driver for TI BQ24735
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
+
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/power_supply.h>
+#include <linux/slab.h>
+
+#include <linux/power/bq24735-charger.h>
+
+#define BQ24735_CHG_OPT			0x12
+#define BQ24735_CHG_OPT_CHARGE_DISABLE	(1 << 0)
+#define BQ24735_CHG_OPT_AC_PRESENT	(1 << 4)
+#define BQ24735_CHARGE_CURRENT		0x14
+#define BQ24735_CHARGE_CURRENT_MASK	0x1fc0
+#define BQ24735_CHARGE_VOLTAGE		0x15
+#define BQ24735_CHARGE_VOLTAGE_MASK	0x7ff0
+#define BQ24735_INPUT_CURRENT		0x3f
+#define BQ24735_INPUT_CURRENT_MASK	0x1f80
+#define BQ24735_MANUFACTURER_ID		0xfe
+#define BQ24735_DEVICE_ID		0xff
+
+struct bq24735 {
+	struct power_supply	charger;
+	struct i2c_client	*client;
+	struct bq24735_platform	*pdata;
+};
+
+static inline struct bq24735 *to_bq24735(struct power_supply *psy)
+{
+	return container_of(psy, struct bq24735, charger);
+}
+
+static enum power_supply_property bq24735_charger_properties[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static inline int bq24735_write_word(struct i2c_client *client, u8 reg,
+				     u16 value)
+{
+	return i2c_smbus_write_word_data(client, reg, le16_to_cpu(value));
+}
+
+static inline int bq24735_read_word(struct i2c_client *client, u8 reg)
+{
+	s32 ret = i2c_smbus_read_word_data(client, reg);
+
+	return ret < 0 ? ret : le16_to_cpu(ret);
+}
+
+static int bq24735_update_word(struct i2c_client *client, u8 reg,
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
+	return bq24735_write_word(client, reg, tmp);
+}
+
+static inline int bq24735_enable_charging(struct bq24735 *charger)
+{
+	return bq24735_update_word(charger->client, BQ24735_CHG_OPT,
+				   BQ24735_CHG_OPT_CHARGE_DISABLE,
+				   ~BQ24735_CHG_OPT_CHARGE_DISABLE);
+}
+
+static inline int bq24735_disable_charging(struct bq24735 *charger)
+{
+	return bq24735_update_word(charger->client, BQ24735_CHG_OPT,
+				   BQ24735_CHG_OPT_CHARGE_DISABLE,
+				   BQ24735_CHG_OPT_CHARGE_DISABLE);
+}
+
+static int bq24735_config_charger(struct bq24735 *charger)
+{
+	struct bq24735_platform *pdata = charger->pdata;
+	int ret;
+	u16 value;
+
+	if (pdata->charge_current) {
+		value = pdata->charge_current & BQ24735_CHARGE_CURRENT_MASK;
+
+		ret = bq24735_write_word(charger->client,
+					 BQ24735_CHARGE_CURRENT, value);
+		if (ret < 0) {
+			dev_err(&charger->client->dev,
+				"Failed to write charger current : %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	if (pdata->charge_voltage) {
+		value = pdata->charge_voltage & BQ24735_CHARGE_VOLTAGE_MASK;
+
+		ret = bq24735_write_word(charger->client,
+					 BQ24735_CHARGE_VOLTAGE, value);
+		if (ret < 0) {
+			dev_err(&charger->client->dev,
+				"Failed to write charger voltage : %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	if (pdata->input_current) {
+		value = pdata->input_current & BQ24735_INPUT_CURRENT_MASK;
+
+		ret = bq24735_write_word(charger->client,
+					 BQ24735_INPUT_CURRENT, value);
+		if (ret < 0) {
+			dev_err(&charger->client->dev,
+				"Failed to write input current : %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static bool bq24735_charger_is_present(struct bq24735 *charger)
+{
+	struct bq24735_platform *pdata = charger->pdata;
+	int ret;
+
+	if (pdata->status_gpio_valid) {
+		ret = gpio_get_value_cansleep(pdata->status_gpio);
+		return ret ^= pdata->status_gpio_active_low == 0;
+	} else {
+		int ac = 0;
+
+		ac = bq24735_read_word(charger->client, BQ24735_CHG_OPT);
+		if (ac < 0) {
+			dev_err(&charger->client->dev,
+				"Failed to read charger options : %d\n",
+				ac);
+			return false;
+		}
+		return (ac & BQ24735_CHG_OPT_AC_PRESENT) ? true : false;
+	}
+
+	return false;
+}
+
+static irqreturn_t bq24735_charger_isr(int irq, void *devid)
+{
+	struct power_supply *psy = devid;
+	struct bq24735 *charger = to_bq24735(psy);
+
+	if (bq24735_charger_is_present(charger))
+		bq24735_enable_charging(charger);
+	else
+		bq24735_disable_charging(charger);
+
+	power_supply_changed(psy);
+
+	return IRQ_HANDLED;
+}
+
+static int bq24735_charger_get_property(struct power_supply *psy,
+					enum power_supply_property psp,
+					union power_supply_propval *val)
+{
+	struct bq24735 *charger;
+
+	charger = container_of(psy, struct bq24735, charger);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = bq24735_charger_is_present(charger) ? 1 : 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct bq24735_platform *bq24735_parse_dt_data(struct i2c_client *client)
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
+	pdata->status_gpio = of_get_named_gpio_flags(np, "ti,ac-detect-gpios",
+						     0, &flags);
+
+	if (flags & OF_GPIO_ACTIVE_LOW)
+		pdata->status_gpio_active_low = 1;
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
+
+static int bq24735_charger_probe(struct i2c_client *client,
+				 const struct i2c_device_id *id)
+{
+	int ret;
+	struct bq24735 *charger;
+	struct power_supply *supply;
+	char *name;
+
+	charger = devm_kzalloc(&client->dev, sizeof(*charger), GFP_KERNEL);
+	if (!charger)
+		return -ENOMEM;
+
+	charger->pdata = client->dev.platform_data;
+
+	if (IS_ENABLED(CONFIG_OF) && !charger->pdata && client->dev.of_node)
+		charger->pdata = bq24735_parse_dt_data(client);
+
+	if (!charger->pdata) {
+		dev_err(&client->dev, "no platform data provided\n");
+		return -EINVAL;
+	}
+
+	name = (char *)charger->pdata->name;
+	if (!name) {
+		name = kasprintf(GFP_KERNEL, "bq24735@%s",
+				 dev_name(&client->dev));
+		if (!name) {
+			dev_err(&client->dev, "Failed to alloc device name\n");
+			return -ENOMEM;
+		}
+	}
+
+	charger->client = client;
+
+	supply = &charger->charger;
+
+	supply->name = name;
+	supply->type = POWER_SUPPLY_TYPE_MAINS;
+	supply->properties = bq24735_charger_properties;
+	supply->num_properties = ARRAY_SIZE(bq24735_charger_properties);
+	supply->get_property = bq24735_charger_get_property;
+	supply->supplied_to = charger->pdata->supplied_to;
+	supply->num_supplicants = charger->pdata->num_supplicants;
+	supply->of_node = client->dev.of_node;
+
+	i2c_set_clientdata(client, charger);
+
+	ret = bq24735_read_word(client, BQ24735_MANUFACTURER_ID);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to read manufacturer id : %d\n",
+			ret);
+		goto err_free_name;
+	} else if (ret != 0x0040) {
+		dev_err(&client->dev,
+			"manufacturer id mismatch. 0x0040 != 0x%04x\n", ret);
+		ret = -ENODEV;
+		goto err_free_name;
+	}
+
+	ret = bq24735_read_word(client, BQ24735_DEVICE_ID);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to read device id : %d\n", ret);
+		goto err_free_name;
+	} else if (ret != 0x000B) {
+		dev_err(&client->dev,
+			"device id mismatch. 0x000b != 0x%04x\n", ret);
+		ret = -ENODEV;
+		goto err_free_name;
+	}
+
+	if (gpio_is_valid(charger->pdata->status_gpio)) {
+		ret = devm_gpio_request(&client->dev,
+					charger->pdata->status_gpio,
+					name);
+		if (ret)
+			dev_err(&client->dev, "Failed GPIO request: %d\n", ret);
+
+		charger->pdata->status_gpio_valid = !ret;
+	}
+
+	ret = bq24735_config_charger(charger);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed in configuring charger");
+		goto err_free_name;
+	}
+
+	/* check for AC adapter presence */
+	if (bq24735_charger_is_present(charger)) {
+		ret = bq24735_enable_charging(charger);
+		if (ret < 0) {
+			dev_err(&client->dev, "Failed to enable charging\n");
+			goto err_free_name;
+		}
+	}
+
+	ret = power_supply_register(&client->dev, supply);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to register power supply: %d\n",
+			ret);
+		goto err_free_name;
+	}
+
+	if (client->irq) {
+		ret = devm_request_threaded_irq(&client->dev, client->irq,
+						NULL, bq24735_charger_isr,
+						IRQF_TRIGGER_RISING |
+						IRQF_TRIGGER_FALLING |
+						IRQF_ONESHOT,
+						supply->name, supply);
+		if (ret) {
+			dev_err(&client->dev,
+				"Unable to register IRQ %d err %d\n",
+				client->irq, ret);
+			goto err_unregister_supply;
+		}
+	}
+
+	return 0;
+err_unregister_supply:
+	power_supply_unregister(supply);
+err_free_name:
+	if (name != charger->pdata->name)
+		kfree(name);
+
+	return ret;
+}
+
+static int bq24735_charger_remove(struct i2c_client *client)
+{
+	struct bq24735 *charger = i2c_get_clientdata(client);
+
+	if (charger->client->irq)
+		devm_free_irq(&charger->client->dev, charger->client->irq,
+			      &charger->charger);
+
+	power_supply_unregister(&charger->charger);
+
+	if (charger->charger.name != charger->pdata->name)
+		kfree(charger->charger.name);
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
index 0000000..f536164
--- /dev/null
+++ b/include/linux/power/bq24735-charger.h
@@ -0,0 +1,39 @@
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
+struct bq24735_platform {
+	uint32_t charge_current;
+	uint32_t charge_voltage;
+	uint32_t input_current;
+
+	const char *name;
+
+	int status_gpio;
+	int status_gpio_active_low;
+	bool status_gpio_valid;
+
+	char **supplied_to;
+	size_t num_supplicants;
+};
+
+#endif /* __CHARGER_BQ24735_H_ */
-- 
1.7.9.5

