Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbbAXAy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:54:27 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6355 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbbAXAyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:54:24 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>
CC: Courtney Cavin <courtney.cavin@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-leds@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v2 2/2] leds: add Qualcomm PM8941 WLED driver
Date: Fri, 23 Jan 2015 16:54:13 -0800
Message-ID: <1422060853-1067-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422060853-1067-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422060853-1067-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Courtney Cavin <courtney.cavin@sonymobile.com>

This adds support for the WLED ('White' LED) block on Qualcomm's
PM8941 PMICs.

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/leds/Kconfig            |   8 +
 drivers/leds/Makefile           |   1 +
 drivers/leds/leds-pm8941-wled.c | 459 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 468 insertions(+)
 create mode 100644 drivers/leds/leds-pm8941-wled.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index a6c3d2f..901b21a 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -516,6 +516,14 @@ config LEDS_VERSATILE
 	  This option enabled support for the LEDs on the ARM Versatile
 	  and RealView boards. Say Y to enabled these.
 
+config LEDS_PM8941_WLED
+	tristate "LED support for the Qualcomm PM8941 WLED block"
+	depends on LEDS_CLASS
+	select REGMAP
+	help
+	  This option enables support for the 'White' LED block
+	  on Qualcomm PM8941 PMICs.
+
 comment "LED Triggers"
 source "drivers/leds/trigger/Kconfig"
 
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 1c65a19..4325e49 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
 obj-$(CONFIG_LEDS_SYSCON)		+= leds-syscon.o
 obj-$(CONFIG_LEDS_VERSATILE)		+= leds-versatile.o
 obj-$(CONFIG_LEDS_MENF21BMC)		+= leds-menf21bmc.o
+obj-$(CONFIG_LEDS_PM8941_WLED)		+= leds-pm8941-wled.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-pm8941-wled.c b/drivers/leds/leds-pm8941-wled.c
new file mode 100644
index 0000000..beaa7de
--- /dev/null
+++ b/drivers/leds/leds-pm8941-wled.c
@@ -0,0 +1,459 @@
+/* Copyright (c) 2015, Sony Mobile Communications, AB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+
+#define PM8941_WLED_REG_VAL_BASE		0x40
+#define  PM8941_WLED_REG_VAL_MAX		0xFFF
+
+#define PM8941_WLED_REG_MOD_EN			0x46
+#define  PM8941_WLED_REG_MOD_EN_BIT		BIT(7)
+#define  PM8941_WLED_REG_MOD_EN_MASK		BIT(7)
+
+#define PM8941_WLED_REG_SYNC			0x47
+#define  PM8941_WLED_REG_SYNC_MASK		0x07
+#define  PM8941_WLED_REG_SYNC_LED1		BIT(0)
+#define  PM8941_WLED_REG_SYNC_LED2		BIT(1)
+#define  PM8941_WLED_REG_SYNC_LED3		BIT(2)
+#define  PM8941_WLED_REG_SYNC_ALL		0x07
+#define  PM8941_WLED_REG_SYNC_CLEAR		0x00
+
+#define PM8941_WLED_REG_FREQ			0x4c
+#define  PM8941_WLED_REG_FREQ_MASK		0x0f
+
+#define PM8941_WLED_REG_OVP			0x4d
+#define  PM8941_WLED_REG_OVP_MASK		0x03
+
+#define PM8941_WLED_REG_BOOST			0x4e
+#define  PM8941_WLED_REG_BOOST_MASK		0x07
+
+#define PM8941_WLED_REG_SINK			0x4f
+#define  PM8941_WLED_REG_SINK_MASK		0xe0
+#define  PM8941_WLED_REG_SINK_SHFT		0x05
+
+/* Per-'string' registers below */
+#define PM8941_WLED_REG_STR_OFFSET		0x10
+
+#define PM8941_WLED_REG_STR_MOD_EN_BASE		0x60
+#define  PM8941_WLED_REG_STR_MOD_MASK		BIT(7)
+#define  PM8941_WLED_REG_STR_MOD_EN		BIT(7)
+
+#define PM8941_WLED_REG_STR_SCALE_BASE		0x62
+#define  PM8941_WLED_REG_STR_SCALE_MASK		0x1f
+
+#define PM8941_WLED_REG_STR_MOD_SRC_BASE	0x63
+#define  PM8941_WLED_REG_STR_MOD_SRC_MASK	0x01
+#define  PM8941_WLED_REG_STR_MOD_SRC_INT	0x00
+#define  PM8941_WLED_REG_STR_MOD_SRC_EXT	0x01
+
+#define PM8941_WLED_REG_STR_CABC_BASE		0x66
+#define  PM8941_WLED_REG_STR_CABC_MASK		BIT(7)
+#define  PM8941_WLED_REG_STR_CABC_EN		BIT(7)
+
+struct pm8941_wled_config {
+	u32 i_boost_limit;
+	u32 ovp;
+	u32 switch_freq;
+	u32 num_strings;
+	u32 i_limit;
+	bool cs_out_en;
+	bool ext_gen;
+	bool cabc_en;
+};
+
+struct pm8941_wled {
+	struct regmap *regmap;
+	u16 addr;
+
+	struct led_classdev cdev;
+
+	struct pm8941_wled_config cfg;
+};
+
+static int pm8941_wled_set(struct led_classdev *cdev,
+			   enum led_brightness value)
+{
+	struct pm8941_wled *wled;
+	u8 ctrl = 0;
+	u16 val;
+	int rc;
+	int i;
+
+	wled = container_of(cdev, struct pm8941_wled, cdev);
+
+	if (value != 0)
+		ctrl = PM8941_WLED_REG_MOD_EN_BIT;
+
+	val = value * PM8941_WLED_REG_VAL_MAX / LED_FULL;
+
+	rc = regmap_update_bits(wled->regmap,
+			wled->addr + PM8941_WLED_REG_MOD_EN,
+			PM8941_WLED_REG_MOD_EN_MASK, ctrl);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < wled->cfg.num_strings; ++i) {
+		u8 v[2] = { val & 0xff, (val >> 8) & 0xf };
+
+		rc = regmap_bulk_write(wled->regmap,
+				wled->addr + PM8941_WLED_REG_VAL_BASE + 2 * i,
+				v, 2);
+		if (rc)
+			return rc;
+	}
+
+	rc = regmap_update_bits(wled->regmap,
+			wled->addr + PM8941_WLED_REG_SYNC,
+			PM8941_WLED_REG_SYNC_MASK, PM8941_WLED_REG_SYNC_ALL);
+	if (rc)
+		return rc;
+
+	rc = regmap_update_bits(wled->regmap,
+			wled->addr + PM8941_WLED_REG_SYNC,
+			PM8941_WLED_REG_SYNC_MASK, PM8941_WLED_REG_SYNC_CLEAR);
+	return rc;
+}
+
+static void pm8941_wled_set_brightness(struct led_classdev *cdev,
+				       enum led_brightness value)
+{
+	if (pm8941_wled_set(cdev, value)) {
+		dev_err(cdev->dev, "Unable to set brightness\n");
+		return;
+	}
+	cdev->brightness = value;
+}
+
+static int pm8941_wled_setup(struct pm8941_wled *wled)
+{
+	int rc;
+	int i;
+
+	rc = regmap_update_bits(wled->regmap,
+			wled->addr + PM8941_WLED_REG_OVP,
+			PM8941_WLED_REG_OVP_MASK, wled->cfg.ovp);
+	if (rc)
+		return rc;
+
+	rc = regmap_update_bits(wled->regmap,
+			wled->addr + PM8941_WLED_REG_BOOST,
+			PM8941_WLED_REG_BOOST_MASK, wled->cfg.i_boost_limit);
+	if (rc)
+		return rc;
+
+	rc = regmap_update_bits(wled->regmap,
+			wled->addr + PM8941_WLED_REG_FREQ,
+			PM8941_WLED_REG_FREQ_MASK, wled->cfg.switch_freq);
+	if (rc)
+		return rc;
+
+	if (wled->cfg.cs_out_en) {
+		u8 all = (BIT(wled->cfg.num_strings) - 1)
+				<< PM8941_WLED_REG_SINK_SHFT;
+
+		rc = regmap_update_bits(wled->regmap,
+				wled->addr + PM8941_WLED_REG_SINK,
+				PM8941_WLED_REG_SINK_MASK, all);
+		if (rc)
+			return rc;
+	}
+
+	for (i = 0; i < wled->cfg.num_strings; ++i) {
+		u16 addr = wled->addr + PM8941_WLED_REG_STR_OFFSET * i;
+
+		rc = regmap_update_bits(wled->regmap,
+				addr + PM8941_WLED_REG_STR_MOD_EN_BASE,
+				PM8941_WLED_REG_STR_MOD_MASK,
+				PM8941_WLED_REG_STR_MOD_EN);
+		if (rc)
+			return rc;
+
+		if (wled->cfg.ext_gen) {
+			rc = regmap_update_bits(wled->regmap,
+					addr + PM8941_WLED_REG_STR_MOD_SRC_BASE,
+					PM8941_WLED_REG_STR_MOD_SRC_MASK,
+					PM8941_WLED_REG_STR_MOD_SRC_EXT);
+			if (rc)
+				return rc;
+		}
+
+		rc = regmap_update_bits(wled->regmap,
+				addr + PM8941_WLED_REG_STR_SCALE_BASE,
+				PM8941_WLED_REG_STR_SCALE_MASK,
+				wled->cfg.i_limit);
+		if (rc)
+			return rc;
+
+		rc = regmap_update_bits(wled->regmap,
+				addr + PM8941_WLED_REG_STR_CABC_BASE,
+				PM8941_WLED_REG_STR_CABC_MASK,
+				wled->cfg.cabc_en ?
+					PM8941_WLED_REG_STR_CABC_EN : 0);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static const struct pm8941_wled_config pm8941_wled_config_defaults = {
+	.i_boost_limit = 3,
+	.i_limit = 20,
+	.ovp = 2,
+	.switch_freq = 5,
+	.num_strings = 0,
+	.cs_out_en = false,
+	.ext_gen = false,
+	.cabc_en = false,
+};
+
+struct pm8941_wled_var_cfg {
+	const u32 *values;
+	u32 (*fn)(u32);
+	int size;
+};
+
+static const u32 pm8941_wled_i_boost_limit_values[] = {
+	105, 385, 525, 805, 980, 1260, 1400, 1680,
+};
+
+static const struct pm8941_wled_var_cfg pm8941_wled_i_boost_limit_cfg = {
+	.values = pm8941_wled_i_boost_limit_values,
+	.size = ARRAY_SIZE(pm8941_wled_i_boost_limit_values),
+};
+
+static const u32 pm8941_wled_ovp_values[] = {
+	35, 32, 29, 27,
+};
+
+static const struct pm8941_wled_var_cfg pm8941_wled_ovp_cfg = {
+	.values = pm8941_wled_ovp_values,
+	.size = ARRAY_SIZE(pm8941_wled_ovp_values),
+};
+
+static u32 pm8941_wled_num_strings_values_fn(u32 idx)
+{
+	return idx + 1;
+}
+
+static const struct pm8941_wled_var_cfg pm8941_wled_num_strings_cfg = {
+	.fn = pm8941_wled_num_strings_values_fn,
+	.size = 3,
+};
+
+static u32 pm8941_wled_switch_freq_values_fn(u32 idx)
+{
+	return 19200 / (2 * (1 + idx));
+}
+
+static const struct pm8941_wled_var_cfg pm8941_wled_switch_freq_cfg = {
+	.fn = pm8941_wled_switch_freq_values_fn,
+	.size = 16,
+};
+
+static const struct pm8941_wled_var_cfg pm8941_wled_i_limit_cfg = {
+	.size = 26,
+};
+
+static u32 pm8941_wled_values(const struct pm8941_wled_var_cfg *cfg, u32 idx)
+{
+	if (idx >= cfg->size)
+		return UINT_MAX;
+	if (cfg->fn)
+		return cfg->fn(idx);
+	if (cfg->values)
+		return cfg->values[idx];
+	return idx;
+}
+
+static int pm8941_wled_configure(struct pm8941_wled *wled, struct device *dev)
+{
+	struct pm8941_wled_config *cfg = &wled->cfg;
+	u32 val;
+	int rc;
+	int i;
+
+	const struct {
+		const char *name;
+		u32 *val_ptr;
+		const struct pm8941_wled_var_cfg *cfg;
+	} u32_opts[] = {
+		{
+			"qcom,current-boost-limit",
+			&cfg->i_boost_limit,
+			.cfg = &pm8941_wled_i_boost_limit_cfg,
+		},
+		{
+			"qcom,current-limit",
+			&cfg->i_limit,
+			.cfg = &pm8941_wled_i_limit_cfg,
+		},
+		{
+			"qcom,ovp",
+			&cfg->ovp,
+			.cfg = &pm8941_wled_ovp_cfg,
+		},
+		{
+			"qcom,switching-freq",
+			&cfg->switch_freq,
+			.cfg = &pm8941_wled_switch_freq_cfg,
+		},
+		{
+			"qcom,num-strings",
+			&cfg->num_strings,
+			.cfg = &pm8941_wled_num_strings_cfg,
+		},
+	};
+	const struct {
+		const char *name;
+		bool *val_ptr;
+	} bool_opts[] = {
+		{ "qcom,cs-out", &cfg->cs_out_en, },
+		{ "qcom,ext-gen", &cfg->ext_gen, },
+		{ "qcom,cabc", &cfg->cabc_en, },
+	};
+
+	rc = of_property_read_u32(dev->of_node, "reg", &val);
+	if (rc || val > 0xffff) {
+		dev_err(dev, "invalid IO resources\n");
+		return rc ? rc : -EINVAL;
+	}
+	wled->addr = val;
+
+	rc = of_property_read_string(dev->of_node, "label", &wled->cdev.name);
+	if (rc)
+		wled->cdev.name = dev->of_node->name;
+
+	wled->cdev.default_trigger = of_get_property(dev->of_node,
+			"linux,default-trigger", NULL);
+
+	*cfg = pm8941_wled_config_defaults;
+	for (i = 0; i < ARRAY_SIZE(u32_opts); ++i) {
+		u32 sel, c;
+		int j, rj;
+
+		rc = of_property_read_u32(dev->of_node, u32_opts[i].name, &val);
+		if (rc) {
+			if (rc != -EINVAL) {
+				dev_err(dev, "error reading '%s'\n",
+						u32_opts[i].name);
+				return rc;
+			}
+			continue;
+		}
+
+		sel = UINT_MAX;
+		rj = -1;
+		c = pm8941_wled_values(u32_opts[i].cfg, 0);
+		for (j = 0; c != UINT_MAX; ++j) {
+			if (c <= val && (sel == UINT_MAX || c >= sel)) {
+				sel = c;
+				rj = j;
+			}
+			c = pm8941_wled_values(u32_opts[i].cfg, j + 1);
+		}
+		if (sel == UINT_MAX) {
+			dev_err(dev, "invalid value for '%s'\n",
+					u32_opts[i].name);
+			return rc;
+		}
+		if (sel != val) {
+			dev_warn(dev, "rounding '%s' down to %u\n",
+					u32_opts[i].name, sel);
+		}
+		dev_dbg(dev, "'%s' = %u\n", u32_opts[i].name, sel);
+		*u32_opts[i].val_ptr = rj;
+	};
+
+	for (i = 0; i < ARRAY_SIZE(bool_opts); ++i) {
+		if (of_property_read_bool(dev->of_node, bool_opts[i].name))
+			*bool_opts[i].val_ptr = true;
+	}
+
+	cfg->num_strings = cfg->num_strings + 1;
+
+	return 0;
+}
+
+static int pm8941_wled_probe(struct platform_device *pdev)
+{
+	struct pm8941_wled *wled;
+	struct regmap *regmap;
+	int rc;
+
+	regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!regmap) {
+		dev_err(&pdev->dev, "Unable to get regmap\n");
+		return -EINVAL;
+	}
+
+	wled = devm_kzalloc(&pdev->dev, sizeof(*wled), GFP_KERNEL);
+	if (!wled)
+		return -ENOMEM;
+
+	wled->regmap = regmap;
+
+	rc = pm8941_wled_configure(wled, &pdev->dev);
+	if (rc)
+		return rc;
+
+	rc = pm8941_wled_setup(wled);
+	if (rc)
+		return rc;
+
+	wled->cdev.brightness_set = pm8941_wled_set_brightness;
+
+	rc = led_classdev_register(&pdev->dev, &wled->cdev);
+	if (rc)
+		return rc;
+
+	platform_set_drvdata(pdev, wled);
+
+	return 0;
+};
+
+static int pm8941_wled_remove(struct platform_device *pdev)
+{
+	struct pm8941_wled *wled;
+
+	wled = platform_get_drvdata(pdev);
+	led_classdev_unregister(&wled->cdev);
+
+	return 0;
+}
+
+static const struct of_device_id pm8941_wled_match_table[] = {
+	{ .compatible = "qcom,pm8941-wled" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, pm8941_wled_match_table);
+
+static struct platform_driver pm8941_wled_driver = {
+	.probe	= pm8941_wled_probe,
+	.remove = pm8941_wled_remove,
+	.driver	= {
+		.name		= "pm8941-wled",
+		.owner		= THIS_MODULE,
+		.of_match_table	= pm8941_wled_match_table,
+	},
+};
+
+module_platform_driver(pm8941_wled_driver);
+
+MODULE_DESCRIPTION("pm8941 wled driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:pm8941-wled");
-- 
1.9.1

