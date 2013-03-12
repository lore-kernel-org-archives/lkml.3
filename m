Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3CLWK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:10:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15131 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab3CLWKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:10:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 15:10:06 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [Patch v3 4/4] power: tps65090: Add support for tps65090-charger
Date: Tue, 12 Mar 2013 18:08:09 -0400
Message-ID: <1363126089-9071-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the tps65090 charger driver. This driver is
responsible for controlling the charger aspect of the tps65090 mfd.
Currently, this mainly consists of turning on and off the charger, but
some features of the charger can be supported through this driver
including:

Enable Auto Recharge based on Battery voltage
Fast Charge Safety Timer
Maximum battery discharge current
Maximum battery adapter current
Enable External Charge
Disable charging termination based on low charger current (supported)

Once the driver is accepted, later patches can add support for the
features above which are not yet supported.

Based on work by:
Syed Rafiuddin <srafiuddin@nvidia.com>
Laxman Dewangan <ldewangan@nvidia.com>

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v3:
 - fixed build errors/warnings around devm_free_irq and unused irq label
v2:
 - updated commit description with more info
 - cleaned up misc comments (var names, spacing, etc)
 - reordered probe around irq so it is cleaner

 drivers/power/Kconfig            |    7 +
 drivers/power/Makefile           |    1 +
 drivers/power/tps65090-charger.c |  315 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65090.h     |    5 +
 4 files changed, 328 insertions(+)
 create mode 100644 drivers/power/tps65090-charger.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9e00c38..0c5d336 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -340,6 +340,13 @@ config CHARGER_SMB347
 	  Say Y to include support for Summit Microelectronics SMB347
 	  Battery Charger.
 
+config CHARGER_TPS65090
+	tristate "TPS65090 battery charger driver"
+	depends on MFD_TPS65090
+	help
+	 Say Y here to enable support for battery charging with TPS65090
+	 PMIC chips.
+
 config AB8500_BM
 	bool "AB8500 Battery Management Driver"
 	depends on AB8500_CORE && AB8500_GPADC
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 3f66436..8720987 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -53,4 +53,5 @@ obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
 obj-$(CONFIG_POWER_AVS)		+= avs/
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
+obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
 obj-$(CONFIG_POWER_RESET)	+= reset/
diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
new file mode 100644
index 0000000..0c66c66
--- /dev/null
+++ b/drivers/power/tps65090-charger.c
@@ -0,0 +1,315 @@
+/*
+ * Battery charger driver for TI's tps65090
+ *
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/mfd/tps65090.h>
+
+#define TPS65090_REG_INTR_STS	0x00
+#define TPS65090_REG_CG_CTRL0	0x04
+#define TPS65090_REG_CG_CTRL1	0x05
+#define TPS65090_REG_CG_CTRL2	0x06
+#define TPS65090_REG_CG_CTRL3	0x07
+#define TPS65090_REG_CG_CTRL4	0x08
+#define TPS65090_REG_CG_CTRL5	0x09
+#define TPS65090_REG_CG_STATUS1	0x0a
+#define TPS65090_REG_CG_STATUS2	0x0b
+
+#define TPS65090_CHARGER_ENABLE	BIT(0)
+#define TPS65090_VACG		BIT(1)
+#define TPS65090_NOITERM	BIT(5)
+
+struct tps65090_charger {
+	struct	device	*dev;
+	int	ac_online;
+	int	prev_ac_online;
+	int	irq;
+	struct power_supply	ac;
+	struct tps65090_platform_data *pdata;
+};
+
+static enum power_supply_property tps65090_ac_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static int tps65090_low_chrg_current(struct tps65090_charger *charger)
+{
+	int ret;
+
+	ret = tps65090_write(charger->dev->parent, TPS65090_REG_CG_CTRL5,
+			TPS65090_NOITERM);
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
+			__func__, TPS65090_REG_CG_CTRL5);
+		return ret;
+	}
+	return 0;
+}
+
+static int tps65090_enable_charging(struct tps65090_charger *charger,
+	uint8_t enable)
+{
+	int ret;
+	uint8_t ctrl0 = 0;
+
+	ret = tps65090_read(charger->dev->parent, TPS65090_REG_CG_CTRL0,
+			    &ctrl0);
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
+				__func__, TPS65090_REG_CG_CTRL0);
+		return ret;
+	}
+
+	ret = tps65090_write(charger->dev->parent, TPS65090_REG_CG_CTRL0,
+				(ctrl0 | TPS65090_CHARGER_ENABLE));
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): error reading in register 0x%x\n",
+				__func__, TPS65090_REG_CG_CTRL0);
+		return ret;
+	}
+	return 0;
+}
+
+static int tps65090_config_charger(struct tps65090_charger *charger)
+{
+	int ret;
+
+	if (charger->pdata->enable_low_current_chrg) {
+		ret = tps65090_low_chrg_current(charger);
+		if (ret < 0) {
+			dev_err(charger->dev,
+				"error configuring low charge current\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int tps65090_ac_get_property(struct power_supply *psy,
+			enum power_supply_property psp,
+			union power_supply_propval *val)
+{
+	struct tps65090_charger *charger = container_of(psy,
+					struct tps65090_charger, ac);
+
+	if (psp == POWER_SUPPLY_PROP_ONLINE) {
+		val->intval = charger->ac_online;
+		charger->prev_ac_online = charger->ac_online;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static irqreturn_t tps65090_charger_isr(int irq, void *dev_id)
+{
+	struct tps65090_charger *charger = dev_id;
+	int ret;
+	uint8_t status1 = 0;
+	uint8_t intrsts = 0;
+
+	ret = tps65090_read(charger->dev->parent, TPS65090_REG_CG_STATUS1,
+			    &status1);
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): Error in reading reg 0x%x\n",
+				__func__, TPS65090_REG_CG_STATUS1);
+		return IRQ_HANDLED;
+	}
+	msleep(75);
+	ret = tps65090_read(charger->dev->parent, TPS65090_REG_INTR_STS,
+			    &intrsts);
+	if (ret < 0) {
+		dev_err(charger->dev, "%s(): Error in reading reg 0x%x\n",
+				__func__, TPS65090_REG_INTR_STS);
+		return IRQ_HANDLED;
+	}
+
+	if (intrsts & TPS65090_VACG) {
+		ret = tps65090_enable_charging(charger, 1);
+		if (ret < 0)
+			return IRQ_HANDLED;
+		charger->ac_online = 1;
+	} else {
+		charger->ac_online = 0;
+	}
+
+	if (charger->prev_ac_online != charger->ac_online)
+		power_supply_changed(&charger->ac);
+
+	return IRQ_HANDLED;
+}
+
+#if defined(CONFIG_OF)
+
+#include <linux/of_device.h>
+
+static struct tps65090_platform_data *
+		tps65090_parse_dt_charger_data(struct platform_device *pdev)
+{
+	struct tps65090_platform_data *pdata;
+	struct device_node *np = pdev->dev.parent->of_node;
+	unsigned int prop;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev, "Memory alloc for tps65090_pdata failed\n");
+		return NULL;
+	}
+
+	prop = of_property_read_bool(np, "ti,enable-low-current-chrg");
+	pdata->enable_low_current_chrg = prop;
+
+	pdata->irq_base = -1;
+
+	return pdata;
+
+}
+#else
+static struct tps65090_platform_data *
+		tps65090_parse_dt_charger_data(struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif
+
+static int tps65090_charger_probe(struct platform_device *pdev)
+{
+	struct tps65090 *tps65090_mfd = dev_get_drvdata(pdev->dev.parent);
+	struct tps65090_charger *cdata;
+	struct tps65090_platform_data *pdata;
+	uint8_t status1 = 0;
+	int ret;
+	int irq;
+
+	pdata = dev_get_platdata(pdev->dev.parent);
+
+	if (!pdata && tps65090_mfd->dev->of_node)
+		pdata = tps65090_parse_dt_charger_data(pdev);
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "%s():no platform data available\n",
+				__func__);
+		return -ENODEV;
+	}
+
+	cdata = devm_kzalloc(&pdev->dev, sizeof(*cdata), GFP_KERNEL);
+	if (!cdata) {
+		dev_err(&pdev->dev, "failed to allocate memory status\n");
+		return -ENOMEM;
+	}
+
+	dev_set_drvdata(&pdev->dev, cdata);
+
+	cdata->dev			= &pdev->dev;
+	cdata->pdata			= pdata;
+
+	cdata->ac.name			= "tps65090-ac";
+	cdata->ac.type			= POWER_SUPPLY_TYPE_MAINS;
+	cdata->ac.get_property		= tps65090_ac_get_property;
+	cdata->ac.properties		= tps65090_ac_props;
+	cdata->ac.num_properties	= ARRAY_SIZE(tps65090_ac_props);
+	cdata->ac.supplied_to		= pdata->supplied_to;
+	cdata->ac.num_supplicants	= pdata->num_supplicants;
+
+	ret = power_supply_register(&pdev->dev, &cdata->ac);
+	if (ret) {
+		dev_err(&pdev->dev, "failed: power supply register\n");
+		return ret;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_warn(&pdev->dev, "Unable to get charger irq = %d\n", irq);
+		ret = irq;
+		goto fail_unregister_supply;
+	}
+
+	cdata->irq = irq;
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+		tps65090_charger_isr, 0, "tps65090-charger", cdata);
+	if (ret) {
+		dev_err(cdata->dev, "Unable to register irq %d err %d\n", irq,
+			ret);
+		goto fail_free_irq;
+	}
+
+	ret = tps65090_config_charger(cdata);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "charger config failed, err %d\n", ret);
+		goto fail_free_irq;
+	}
+
+	/* Check for charger presence */
+	ret = tps65090_read(cdata->dev->parent, TPS65090_REG_CG_STATUS1,
+			&status1);
+	if (ret < 0) {
+		dev_err(cdata->dev, "%s(): Error in reading reg 0x%x", __func__,
+			TPS65090_REG_CG_STATUS1);
+		goto fail_free_irq;
+	}
+
+	if (status1 != 0) {
+		ret = tps65090_enable_charging(cdata, 1);
+		if (ret < 0) {
+			dev_err(cdata->dev, "error enabling charger\n");
+			goto fail_free_irq;
+		}
+		cdata->ac_online = 1;
+		power_supply_changed(&cdata->ac);
+	}
+
+	return 0;
+
+fail_free_irq:
+	devm_free_irq(cdata->dev, irq, cdata);
+fail_unregister_supply:
+	power_supply_unregister(&cdata->ac);
+
+	return ret;
+}
+
+static int tps65090_charger_remove(struct platform_device *pdev)
+{
+	struct tps65090_charger *cdata = dev_get_drvdata(&pdev->dev);
+
+	devm_free_irq(cdata->dev, cdata->irq, cdata);
+	power_supply_unregister(&cdata->ac);
+
+	return 0;
+}
+
+static struct platform_driver tps65090_charger_driver = {
+	.driver	= {
+		.name	= "tps65090-charger",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= tps65090_charger_probe,
+	.remove = tps65090_charger_remove,
+};
+module_platform_driver(tps65090_charger_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Syed Rafiuddin <srafiuddin@nvidia.com>");
+MODULE_DESCRIPTION("tps65090 battery charger driver");
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 9ce231f..3f43069 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -87,6 +87,11 @@ struct tps65090_regulator_plat_data {
 
 struct tps65090_platform_data {
 	int irq_base;
+
+	char **supplied_to;
+	size_t num_supplicants;
+	int enable_low_current_chrg;
+
 	struct tps65090_regulator_plat_data *reg_pdata[TPS65090_REGULATOR_MAX];
 };
 
-- 
1.7.9.5

