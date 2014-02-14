Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaBNGbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:31:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40902 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaBNGbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:31:15 -0500
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH 01/10] mfd: Add TI LMU driver
Date: Fri, 14 Feb 2014 15:30:50 +0900
Message-ID: <1392359450-6890-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI LMU (Lighting Management Unit) driver supports lighting devices such like
LM3532, LM3631, LM3633, LM3695 and LM3697.

LMU devices has common features as below.
  - I2C interface for accessing device registers
  - Hardware enable pin control
  - Backlight brightness control
  - Light effect driver for backlight and LED patterns

It contains backlight, light effect, LED and regulator driver.

Backlight
---------
  It's handled by TI LMU backlight common driver and chip dependent driver.
  Please refer to separate patches for ti-lmu-backlight.

Light effect
------------
  LMU effect driver is used for setting any light effects.
  Each device has specific time value and register map.
  Backlight and LED driver can use consitent APIs for light effects.

  There are two lists for effect management. LMU effect list and pending list.
  Light effect list is added when ti-lmu-effect driver is loaded by referencing
  platform resource data.
  However, it can be a problem because some LMU device requests the effect
  in advance of loading ti-lmu-effect driver.

  For example, LM3532 backlight driver requests light ramp effects before
  ti-lmu-effect is loaded.
  Then, requested effect can not be handled because it doesn't exist in the list.
  To solve this situation, pending request list is used.
  If requested effect is not in the list, just insert it into the pending list.
  And then pending request is handled as soon as the effect is added.

LED indicator
-------------
  LM3633 has 6 indicator LEDs. Programmable pattern is supported.

Regulator
---------
  LM3631 has 5 regulators for the display bias.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 drivers/mfd/Kconfig                 |   12 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/ti-lmu-effect.c         |  328 +++++++++++++++++++++++++
 drivers/mfd/ti-lmu.c                |  464 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/ti-lmu-effect.h   |  109 ++++++++
 include/linux/mfd/ti-lmu-register.h |  269 ++++++++++++++++++++
 include/linux/mfd/ti-lmu.h          |  150 +++++++++++
 7 files changed, 1333 insertions(+)
 create mode 100644 drivers/mfd/ti-lmu-effect.c
 create mode 100644 drivers/mfd/ti-lmu.c
 create mode 100644 include/linux/mfd/ti-lmu-effect.h
 create mode 100644 include/linux/mfd/ti-lmu-register.h
 create mode 100644 include/linux/mfd/ti-lmu.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d4be491..e7e1e6b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -784,6 +784,18 @@ config MFD_PALMAS
 	  If you say yes here you get support for the Palmas
 	  series of PMIC chips from Texas Instruments.
 
+config MFD_TI_LMU
+	tristate "TI Lighting Management Unit driver"
+	depends on I2C
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  Say yes here to enable support for TI LMU chips.
+
+	  TI LMU MFD supports LM3532, LM3631, LM3633, LM3695 and LM3697.
+	  It consists of backlight, light effect, LED and regulator driver.
+	  It provides consistent device controls for lighting functions.
+
 config MFD_TI_SSP
 	tristate "TI Sequencer Serial Port support"
 	depends on ARCH_DAVINCI_TNETV107X
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 93c7cad..02dc65a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
 
 obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
+obj-$(CONFIG_MFD_TI_LMU)	+= ti-lmu.o ti-lmu-effect.o
 obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
 obj-$(CONFIG_MFD_TI_AM335X_TSCADC)	+= ti_am335x_tscadc.o
 
diff --git a/drivers/mfd/ti-lmu-effect.c b/drivers/mfd/ti-lmu-effect.c
new file mode 100644
index 0000000..a4a3d26
--- /dev/null
+++ b/drivers/mfd/ti-lmu-effect.c
@@ -0,0 +1,328 @@
+/*
+ * TI LMU Effect Driver
+ *
+ * Copyright 2014 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * LMU effect driver is used for setting any light effects.
+ * Each device has specific time value and register map.
+ * Light effect can be controlled with consistent APIs.
+ *
+ * Examples:
+ *   Backlight ramp time control - LM3532, LM3631, LM3633 and LM3697
+ *   LED pattern display - LM3633
+ *
+ * Flow:
+ *   1) LMU backlight and LED drivers request to the light effect driver
+ *      by using ti_lmu_effect_request().
+ *   2) Call ti_lmu_effect_set_* APIs in each callback function.
+ */
+
+#include <linux/mfd/ti-lmu.h>
+#include <linux/mfd/ti-lmu-effect.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define LMU_EFFECT_MAX_TIME_PERIOD		9700
+
+struct ti_lmu_effect_req {
+	struct list_head list;
+	const char *name;
+	ti_lmu_effect_cb_t *cbfunc;
+	int req_id;
+	void *data;
+};
+
+struct ti_lmu_effect {
+	struct list_head list;
+	struct ti_lmu *lmu;
+
+	const char *name;
+	u8 addr;
+	u8 mask;
+	u8 shift;
+	unsigned int val;
+};
+
+static DEFINE_MUTEX(lmu_effect_list_mutex);
+static LIST_HEAD(lmu_effect_list);
+static LIST_HEAD(lmu_effect_pending_list);
+
+static const int lm3532_ramp_table[] = { 0, 1, 2, 4, 8, 16, 32, 65 };
+static const int lm3631_ramp_table[] = {
+	   0,   1,   2,    5,   10,   20,   50,  100,
+	 250, 500, 750, 1000, 1500, 2000, 3000, 4000,
+};
+static const int lm3633_ramp_table[] = {
+	   2, 250, 500, 1000, 2000, 4000, 8000, 16000,
+};
+
+static u8 ti_lmu_effect_get_ramp_index(struct ti_lmu_effect *lmu_effect,
+				       int msec)
+{
+	const int *table = NULL;
+	int size = 0;
+	int index = 0;
+	int i;
+
+	switch (lmu_effect->lmu->id) {
+	case LM3532:
+		table = lm3532_ramp_table;
+		size = ARRAY_SIZE(lm3532_ramp_table);
+		break;
+	case LM3631:
+		table = lm3631_ramp_table;
+		size = ARRAY_SIZE(lm3631_ramp_table);
+		break;
+	case LM3633:
+	case LM3697:	/* LM3697 has same ramp table as LM3633 */
+		table = lm3633_ramp_table;
+		size = ARRAY_SIZE(lm3633_ramp_table);
+		break;
+	default:
+		break;
+	}
+
+	if (msec <= table[0]) {
+		index = 0;
+		goto out;
+	}
+
+	if (msec >= table[size-1]) {
+		index = size - 1;
+		goto out;
+	}
+
+	/* Find appropriate register index from the table */
+	for (i = 1; i < size; i++) {
+		if (msec >= table[i-1] && msec < table[i]) {
+			index = i - 1;
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	return index;
+}
+
+static u8 ti_lmu_effect_get_time_index(struct ti_lmu_effect *lmu_effect,
+				       int msec)
+{
+	u8 idx, offset;
+
+	/*
+	 * Find appropriate register index around input time value
+	 *
+	 *      0 <= time <= 1000 : 16ms step
+	 *   1000 <  time <= 9700 : 131ms step, base index is 61
+	 */
+
+	msec = min_t(int, msec, LMU_EFFECT_MAX_TIME_PERIOD);
+
+	if (msec >= 0 && msec <= 1000) {
+		idx = msec / 16;
+		if (idx > 1)
+			idx--;
+		offset = 0;
+	} else {
+		idx = (msec - 1000) / 131;
+		offset = 61;
+	}
+
+	return idx + offset;
+}
+
+static struct ti_lmu_effect *ti_lmu_effect_lookup(const char *name)
+{
+	struct ti_lmu_effect *lmu_effect;
+
+	list_for_each_entry(lmu_effect, &lmu_effect_list, list)
+		if (!strcmp(lmu_effect->name, name))
+			return lmu_effect;
+
+	return NULL;
+}
+
+int ti_lmu_effect_request(const char *name, ti_lmu_effect_cb_t cbfunc,
+			  int req_id, void *data)
+{
+	struct ti_lmu_effect *lmu_effect;
+	struct ti_lmu_effect_req *lmu_effect_req;
+
+	if (!cbfunc || !name)
+		return -EINVAL;
+
+	/* If requested effect is in the list, handle it immediately */
+	lmu_effect = ti_lmu_effect_lookup(name);
+	if (lmu_effect) {
+		cbfunc(lmu_effect, req_id, data);
+		goto out;
+	}
+
+	/*
+	 * If requested effect is not in the list yet,
+	 * add it into pending request list to handle it later.
+	 */
+
+	lmu_effect_req = kzalloc(sizeof(*lmu_effect_req), GFP_KERNEL);
+	if (!lmu_effect_req)
+		return -ENOMEM;
+
+	lmu_effect_req->name = name;
+	lmu_effect_req->cbfunc = cbfunc;
+	lmu_effect_req->req_id = req_id;
+	lmu_effect_req->data = data;
+
+	mutex_lock(&lmu_effect_list_mutex);
+	list_add(&lmu_effect_req->list, &lmu_effect_pending_list);
+	mutex_unlock(&lmu_effect_list_mutex);
+
+out:
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ti_lmu_effect_request);
+
+int ti_lmu_effect_set_ramp(struct ti_lmu_effect *lmu_effect, int msec)
+{
+	u8 val = ti_lmu_effect_get_ramp_index(lmu_effect, msec);
+
+	return ti_lmu_update_bits(lmu_effect->lmu, lmu_effect->addr,
+				  lmu_effect->mask, val << lmu_effect->shift);
+}
+EXPORT_SYMBOL_GPL(ti_lmu_effect_set_ramp);
+
+int ti_lmu_effect_set_time(struct ti_lmu_effect *lmu_effect, int msec,
+			   u8 reg_offset)
+{
+	u8 val = ti_lmu_effect_get_time_index(lmu_effect, msec);
+
+	return ti_lmu_update_bits(lmu_effect->lmu,
+				  lmu_effect->addr + reg_offset,
+				  lmu_effect->mask, val << lmu_effect->shift);
+}
+EXPORT_SYMBOL_GPL(ti_lmu_effect_set_time);
+
+int ti_lmu_effect_set_level(struct ti_lmu_effect *lmu_effect, u8 val,
+			    u8 reg_offset)
+{
+	return ti_lmu_update_bits(lmu_effect->lmu,
+				  lmu_effect->addr + reg_offset,
+				  lmu_effect->mask, val << lmu_effect->shift);
+}
+EXPORT_SYMBOL_GPL(ti_lmu_effect_set_level);
+
+static void ti_lmu_effect_handle_pending_list(struct ti_lmu_effect *lmu_effect)
+{
+	struct ti_lmu_effect_req *req, *n;
+
+	/*
+	 * If an effect driver is requested before, then handle it.
+	 * Then, requested list and memory should be released.
+	 */
+
+	mutex_lock(&lmu_effect_list_mutex);
+
+	list_for_each_entry_safe(req, n, &lmu_effect_pending_list, list) {
+		if (!strcmp(req->name, lmu_effect->name)) {
+			req->cbfunc(lmu_effect, req->req_id, req->data);
+			list_del(&req->list);
+			kfree(req);
+		}
+	}
+
+	mutex_unlock(&lmu_effect_list_mutex);
+}
+
+static int ti_lmu_effect_probe(struct platform_device *pdev)
+{
+	struct ti_lmu *lmu = dev_get_drvdata(pdev->dev.parent);
+	struct ti_lmu_effect *lmu_effect;
+	struct ti_lmu_effect *each;
+	struct resource *r;
+	int num_res = pdev->num_resources;
+	int i;
+
+	if (num_res <= 0) {
+		dev_err(&pdev->dev, "Invalid numbers of resources: %d\n",
+			num_res);
+		return -EINVAL;
+	}
+
+	lmu_effect = devm_kzalloc(&pdev->dev, sizeof(*lmu_effect) * num_res,
+				  GFP_KERNEL);
+	if (!lmu_effect)
+		return -ENOMEM;
+
+	for (i = 0; i < num_res; i++) {
+		r = platform_get_resource(pdev, IORESOURCE_REG, i);
+		if (!r)
+			continue;
+
+		each = lmu_effect + i;
+
+		each->name   = r->name;
+		each->lmu    = lmu;
+		each->addr   = LMU_EFFECT_GET_ADDR(r->start);
+		each->mask   = LMU_EFFECT_GET_MASK(r->start);
+		each->shift  = LMU_EFFECT_GET_SHIFT(r->start);
+
+		mutex_lock(&lmu_effect_list_mutex);
+		list_add(&each->list, &lmu_effect_list);
+		mutex_unlock(&lmu_effect_list_mutex);
+
+		/*
+		 * If an effect driver is requested when the driver is not
+		 * ready, the effect driver is inserted into the pending list.
+		 * Then, pending requested driver is handled here.
+		 */
+
+		ti_lmu_effect_handle_pending_list(each);
+	}
+
+	platform_set_drvdata(pdev, lmu_effect);
+
+	return 0;
+}
+
+static int ti_lmu_effect_remove(struct platform_device *pdev)
+{
+	struct ti_lmu_effect *lmu_effect, *n;
+	struct ti_lmu_effect_req *req, *m;
+
+	mutex_lock(&lmu_effect_list_mutex);
+
+	list_for_each_entry_safe(lmu_effect, n, &lmu_effect_list, list)
+		list_del(&lmu_effect->list);
+
+	/* Remove pending list forcedly */
+	list_for_each_entry_safe(req, m, &lmu_effect_pending_list, list) {
+		list_del(&req->list);
+		kfree(req);
+	}
+
+	mutex_unlock(&lmu_effect_list_mutex);
+
+	return 0;
+}
+
+static struct platform_driver ti_lmu_effect_driver = {
+	.probe = ti_lmu_effect_probe,
+	.remove = ti_lmu_effect_remove,
+	.driver = {
+		.name = "lmu-effect",
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(ti_lmu_effect_driver);
+
+MODULE_DESCRIPTION("TI LMU Effect Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lmu-effect");
diff --git a/drivers/mfd/ti-lmu.c b/drivers/mfd/ti-lmu.c
new file mode 100644
index 0000000..e97d686
--- /dev/null
+++ b/drivers/mfd/ti-lmu.c
@@ -0,0 +1,464 @@
+/*
+ * TI LMU(Lighting Management Unit) Core Driver
+ *
+ * Copyright 2014 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * LMU MFD supports LM3532, LM3631, LM3633, LM3695 and LM3697.
+ *
+ *   LM3532: backlight + light effect
+ *   LM3631: backlight + light effect + regulators
+ *   LM3633: backlight + light effect + LED indicators
+ *   LM3695: backlight
+ *   LM3697: backlight + light effect
+ *
+ * Those devices have common features as below.
+ *
+ *   - I2C interface for accessing device registers
+ *   - Hardware enable pin control
+ *   - Backlight brightness control with current settings
+ *   - Light effect driver for backlight and LED patterns
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/ti-lmu.h>
+#include <linux/mfd/ti-lmu-effect.h>
+#include <linux/mfd/ti-lmu-register.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/slab.h>
+
+#define LMU_IMAX_OFFSET		6
+
+static const struct resource lm3532_effect_resources[] = {
+	{
+		.name  = LM3532_EFFECT_RAMPUP,
+		.flags = IORESOURCE_REG,
+		.start = LM3532_EFFECT_REGISTER(RAMPUP),
+	},
+	{
+		.name  = LM3532_EFFECT_RAMPDOWN,
+		.flags = IORESOURCE_REG,
+		.start = LM3532_EFFECT_REGISTER(RAMPDN),
+	},
+};
+
+static struct mfd_cell lm3532_devices[] = {
+	{
+		.name          = "lm3532-backlight",
+		.of_compatible = "ti,lmu-backlight",
+	},
+	{
+		.name          = "lmu-effect",
+		.id            = LM3532,
+		.resources     = lm3532_effect_resources,
+		.num_resources = ARRAY_SIZE(lm3532_effect_resources),
+	},
+};
+
+static const struct resource lm3631_effect_resources[] = {
+	{
+		.name  = LM3631_EFFECT_SLOPE,
+		.flags = IORESOURCE_REG,
+		.start = LM3631_EFFECT_REGISTER(SLOPE),
+	},
+};
+
+#define LM3631_REGULATOR(_id)			\
+{						\
+	.name          = "lm3631-regulator",	\
+	.id            = _id,			\
+	.of_compatible = "ti,lm3631-regulator",	\
+}						\
+
+static struct mfd_cell lm3631_devices[] = {
+	LM3631_REGULATOR(0),
+	LM3631_REGULATOR(1),
+	LM3631_REGULATOR(2),
+	LM3631_REGULATOR(3),
+	LM3631_REGULATOR(4),
+	{
+		.name          = "lm3631-backlight",
+		.of_compatible = "ti,lmu-backlight",
+	},
+	{
+		.name          = "lmu-effect",
+		.id            = LM3631,
+		.resources     = lm3631_effect_resources,
+		.num_resources = ARRAY_SIZE(lm3631_effect_resources),
+	},
+};
+
+static const struct resource lm3633_effect_resources[] = {
+	{
+		.name  = LM3633_EFFECT_BL0_RAMPUP,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(BL0_RAMPUP),
+	},
+	{
+		.name  = LM3633_EFFECT_BL0_RAMPDOWN,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(BL0_RAMPDN),
+	},
+	{
+		.name  = LM3633_EFFECT_BL1_RAMPUP,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(BL1_RAMPUP),
+	},
+	{
+		.name  = LM3633_EFFECT_BL1_RAMPDOWN,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(BL1_RAMPDN),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN_DELAY,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(DELAY),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN_HIGHTIME,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(HIGHTIME),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN_LOWTIME,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(LOWTIME),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN0_RAMPUP,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(PTN0_RAMPUP),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN0_RAMPDOWN,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(PTN0_RAMPDN),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN1_RAMPUP,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(PTN1_RAMPUP),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN1_RAMPDOWN,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(PTN1_RAMPDN),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN_LOWBRT,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(LOWBRT),
+	},
+	{
+		.name  = LM3633_EFFECT_PTN_HIGHBRT,
+		.flags = IORESOURCE_REG,
+		.start = LM3633_EFFECT_REGISTER(HIGHBRT),
+	},
+};
+
+static struct mfd_cell lm3633_devices[] = {
+	{
+		.name          = "lm3633-backlight",
+		.of_compatible = "ti,lmu-backlight",
+	},
+	{
+		.name          = "lm3633-leds",
+		.of_compatible = "ti,lm3633-leds",
+	},
+	{
+		.name          = "lmu-effect",
+		.id            = LM3633,
+		.resources     = lm3633_effect_resources,
+		.num_resources = ARRAY_SIZE(lm3633_effect_resources),
+	},
+};
+
+static struct mfd_cell lm3695_devices[] = {
+	{
+		.name          = "lm3695-backlight",
+		.of_compatible = "ti,lmu-backlight",
+	},
+};
+
+static const struct resource lm3697_effect_resources[] = {
+	{
+		.name  = LM3697_EFFECT_BL0_RAMPUP,
+		.flags = IORESOURCE_REG,
+		.start = LM3697_EFFECT_REGISTER(BL0_RAMPUP),
+	},
+	{
+		.name  = LM3697_EFFECT_BL0_RAMPDOWN,
+		.flags = IORESOURCE_REG,
+		.start = LM3697_EFFECT_REGISTER(BL0_RAMPDN),
+	},
+	{
+		.name  = LM3697_EFFECT_BL1_RAMPUP,
+		.flags = IORESOURCE_REG,
+		.start = LM3697_EFFECT_REGISTER(BL1_RAMPUP),
+	},
+	{
+		.name  = LM3697_EFFECT_BL1_RAMPDOWN,
+		.flags = IORESOURCE_REG,
+		.start = LM3697_EFFECT_REGISTER(BL1_RAMPDN),
+	},
+};
+
+static struct mfd_cell lm3697_devices[] = {
+	{
+		.name          = "lm3697-backlight",
+		.of_compatible = "ti,lmu-backlight",
+	},
+	{
+		.name          = "lmu-effect",
+		.id            = LM3697,
+		.resources     = lm3697_effect_resources,
+		.num_resources = ARRAY_SIZE(lm3697_effect_resources),
+	},
+};
+
+static struct mfd_cell *ti_lmu_cell[] = {
+	lm3532_devices,
+	lm3631_devices,
+	lm3633_devices,
+	lm3695_devices,
+	lm3697_devices,
+};
+
+static const int ti_lmu_num_cells[] = {
+	ARRAY_SIZE(lm3532_devices),
+	ARRAY_SIZE(lm3631_devices),
+	ARRAY_SIZE(lm3633_devices),
+	ARRAY_SIZE(lm3695_devices),
+	ARRAY_SIZE(lm3697_devices),
+};
+
+int ti_lmu_read_byte(struct ti_lmu *lmu, u8 reg, u8 *read)
+{
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(lmu->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
+
+	*read = (u8)val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ti_lmu_read_byte);
+
+int ti_lmu_write_byte(struct ti_lmu *lmu, u8 reg, u8 data)
+{
+	return regmap_write(lmu->regmap, reg, data);
+}
+EXPORT_SYMBOL_GPL(ti_lmu_write_byte);
+
+int ti_lmu_update_bits(struct ti_lmu *lmu, u8 reg, u8 mask, u8 data)
+{
+	if (mask == LMU_FULL_MASKBIT)
+		return regmap_write(lmu->regmap, reg, data);
+	else
+		return regmap_update_bits(lmu->regmap, reg, mask, data);
+}
+EXPORT_SYMBOL_GPL(ti_lmu_update_bits);
+
+enum ti_lmu_max_current ti_lmu_get_current_code(u8 imax_mA)
+{
+	const enum ti_lmu_max_current imax_table[] = {
+		LMU_IMAX_6mA,  LMU_IMAX_7mA,  LMU_IMAX_8mA,  LMU_IMAX_9mA,
+		LMU_IMAX_10mA, LMU_IMAX_11mA, LMU_IMAX_12mA, LMU_IMAX_13mA,
+		LMU_IMAX_14mA, LMU_IMAX_15mA, LMU_IMAX_16mA, LMU_IMAX_17mA,
+		LMU_IMAX_18mA, LMU_IMAX_19mA, LMU_IMAX_20mA, LMU_IMAX_21mA,
+		LMU_IMAX_22mA, LMU_IMAX_23mA, LMU_IMAX_24mA, LMU_IMAX_25mA,
+		LMU_IMAX_26mA, LMU_IMAX_27mA, LMU_IMAX_28mA, LMU_IMAX_29mA,
+	};
+
+	/*
+	 * Convert milliampere to appropriate enum code value.
+	 * Input range : 5 ~ 30mA
+	 */
+
+	if (imax_mA <= 5)
+		return LMU_IMAX_5mA;
+
+	if (imax_mA >= 30)
+		return LMU_IMAX_30mA;
+
+	return imax_table[imax_mA - LMU_IMAX_OFFSET];
+}
+EXPORT_SYMBOL_GPL(ti_lmu_get_current_code);
+
+static int ti_lmu_enable_hw(struct ti_lmu *lmu)
+{
+	int ret;
+
+	ret = devm_gpio_request_one(lmu->dev, lmu->pdata->en_gpio,
+				    GPIOF_OUT_INIT_HIGH, "lmu_hwen");
+	if (ret)
+		return ret;
+
+	/*
+	 * LM3631 Powerup Sequence
+	 *
+	 * 1) Enable nRST pin : GPIO control
+	 * 2) Delay about 1ms : bias delay 200us + EPROM read time 700us
+	 * 3) Set LCD_EN bit to 1
+	 */
+
+	if (lmu->id == LM3631) {
+		usleep_range(1000, 1500);
+
+		return ti_lmu_update_bits(lmu, LM3631_REG_DEVCTRL,
+					  LM3631_LCD_EN_MASK,
+					  1 << LM3631_LCD_EN_SHIFT);
+	}
+
+	return 0;
+}
+
+static void ti_lmu_disable_hw(struct ti_lmu *lmu)
+{
+	gpio_set_value(lmu->pdata->en_gpio, 0);
+}
+
+static struct regmap_config lmu_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int ti_lmu_parse_dt(struct device *dev, struct ti_lmu *lmu)
+{
+	struct device_node *node = dev->of_node;
+	struct ti_lmu_platform_data *pdata;
+
+	if (!node)
+		return -EINVAL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdata->en_gpio = of_get_named_gpio(node, "ti,enable-gpio", 0);
+	if (pdata->en_gpio < 0)
+		return pdata->en_gpio;
+
+	lmu->pdata = pdata;
+
+	return 0;
+}
+
+static int ti_lmu_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+	struct device *dev = &cl->dev;
+	struct ti_lmu_platform_data *pdata = dev_get_platdata(dev);
+	struct ti_lmu *lmu;
+	int ret;
+
+	lmu = devm_kzalloc(dev, sizeof(*lmu), GFP_KERNEL);
+	if (!lmu)
+		return -ENOMEM;
+
+	lmu->pdata = pdata;
+	if (!lmu->pdata) {
+		if (IS_ENABLED(CONFIG_OF))
+			ret = ti_lmu_parse_dt(dev, lmu);
+		else
+			ret = -ENODEV;
+
+		if (ret)
+			return ret;
+	}
+
+	lmu->id = id->driver_data;
+	switch (lmu->id) {
+	case LM3532:
+		lmu_regmap_config.max_register = LM3532_MAX_REGISTERS;
+		break;
+	case LM3631:
+		lmu_regmap_config.max_register = LM3631_MAX_REGISTERS;
+		break;
+	case LM3633:
+		lmu_regmap_config.max_register = LM3633_MAX_REGISTERS;
+		break;
+	case LM3695:
+		lmu_regmap_config.max_register = LM3695_MAX_REGISTERS;
+		break;
+	case LM3697:
+		lmu_regmap_config.max_register = LM3697_MAX_REGISTERS;
+		break;
+	default:
+		break;
+	}
+
+	lmu_regmap_config.name = id->name;
+	lmu->regmap = devm_regmap_init_i2c(cl, &lmu_regmap_config);
+	if (IS_ERR(lmu->regmap))
+		return PTR_ERR(lmu->regmap);
+
+	lmu->dev = &cl->dev;
+	i2c_set_clientdata(cl, lmu);
+
+	ret = ti_lmu_enable_hw(lmu);
+	if (ret)
+		return ret;
+
+	return mfd_add_devices(lmu->dev, 0, ti_lmu_cell[lmu->id],
+			       ti_lmu_num_cells[lmu->id], NULL, 0, NULL);
+}
+
+static int ti_lmu_remove(struct i2c_client *cl)
+{
+	struct ti_lmu *lmu = i2c_get_clientdata(cl);
+
+	ti_lmu_disable_hw(lmu);
+	mfd_remove_devices(lmu->dev);
+	return 0;
+}
+
+static const struct i2c_device_id ti_lmu_ids[] = {
+	{ "lm3532", LM3532 },
+	{ "lm3631", LM3631 },
+	{ "lm3633", LM3633 },
+	{ "lm3695", LM3695 },
+	{ "lm3697", LM3697 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ti_lmu_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id ti_lmu_of_match[] = {
+	{ .compatible = "ti,lm3532", },
+	{ .compatible = "ti,lm3631", },
+	{ .compatible = "ti,lm3633", },
+	{ .compatible = "ti,lm3695", },
+	{ .compatible = "ti,lm3697", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ti_lmu_of_match);
+#endif
+
+static struct i2c_driver ti_lmu_driver = {
+	.probe = ti_lmu_probe,
+	.remove = ti_lmu_remove,
+	.driver = {
+		.name = "ti-lmu",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(ti_lmu_of_match),
+	},
+	.id_table = ti_lmu_ids,
+};
+module_i2c_driver(ti_lmu_driver);
+
+MODULE_DESCRIPTION("TI LMU MFD Core Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/ti-lmu-effect.h b/include/linux/mfd/ti-lmu-effect.h
new file mode 100644
index 0000000..24d50d2
--- /dev/null
+++ b/include/linux/mfd/ti-lmu-effect.h
@@ -0,0 +1,109 @@
+/*
+ * TI LMU(Lighting Management Unit) Effect Driver
+ *
+ * Copyright 2014 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __MFD_TI_LMU_EFFECT_H__
+#define __MFD_TI_LMU_EFFECT_H__
+
+#include <linux/mfd/ti-lmu.h>
+
+/*
+ * LMU effect IO resource structure
+ *
+ *	shift[23:16] | mask[15:8] | address[7:0]
+ *
+ * All TI LMU device is 8-bit register base. address, mask and shift are 8-bit.
+ * To activate a light effect, updating registers is required.
+ * However, register information depends on the device.
+ * In other words, each chip driver should manage own its register address,
+ * mask and shift bits.
+ * To make it simpler, registers are configured with IORESOURCE_REG.
+ * LMU uses bit combination for efficient IO resource.
+ *
+ * LMU MFD    : Register configuration by combining address/mask/shift.
+ *              XXX_LMU_EFFECT_REGISTER() macros are used.
+ * LMU effect : Get address/mask/shift by using platform_get_resource().
+ *              LMU_EFFECT_GET_XXX() macros are used.
+ */
+
+#define _LMU_EFFECT_REGISTER(addr, mask, shift)		\
+	((shift << 16) | (mask << 8) | addr)
+
+#define LMU_EFFECT_REGISTER(chip, effect)		\
+	_LMU_EFFECT_REGISTER(chip##_REG_##effect,	\
+			    chip##_##effect##_MASK,	\
+			    chip##_##effect##_SHIFT)	\
+
+#define LM3532_EFFECT_REGISTER(effect)			\
+	LMU_EFFECT_REGISTER(LM3532, effect)
+#define LM3631_EFFECT_REGISTER(effect)			\
+	LMU_EFFECT_REGISTER(LM3631, effect)
+#define LM3633_EFFECT_REGISTER(effect)			\
+	LMU_EFFECT_REGISTER(LM3633, effect)
+#define LM3697_EFFECT_REGISTER(effect)			\
+	LMU_EFFECT_REGISTER(LM3697, effect)
+
+#define LMU_EFFECT_GET_ADDR(x)			(x & 0xFF)
+#define LMU_EFFECT_GET_MASK(x)			((x >> 8) & 0xFF)
+#define LMU_EFFECT_GET_SHIFT(x)			((x >> 16) & 0xFF)
+
+#define LM3532_EFFECT_RAMPUP			"lm3532:ramp_up"
+#define LM3532_EFFECT_RAMPDOWN			"lm3532:ramp_down"
+#define LM3631_EFFECT_SLOPE			"lm3631:slope"
+#define LM3633_EFFECT_BL0_RAMPUP		"lm3633_bl:0:ramp_up"
+#define LM3633_EFFECT_BL0_RAMPDOWN		"lm3633_bl:0:ramp_down"
+#define LM3633_EFFECT_BL1_RAMPUP		"lm3633_bl:1:ramp_up"
+#define LM3633_EFFECT_BL1_RAMPDOWN		"lm3633_bl:1:ramp_down"
+#define LM3633_EFFECT_PTN_DELAY			"lm3633_ptn:delay"
+#define LM3633_EFFECT_PTN_HIGHTIME		"lm3633_ptn:high_time"
+#define LM3633_EFFECT_PTN_LOWTIME		"lm3633_ptn:low_time"
+#define LM3633_EFFECT_PTN0_RAMPUP		"lm3633_ptn:0:ramp_up"
+#define LM3633_EFFECT_PTN0_RAMPDOWN		"lm3633_ptn:0:ramp_down"
+#define LM3633_EFFECT_PTN1_RAMPUP		"lm3633_ptn:1:ramp_up"
+#define LM3633_EFFECT_PTN1_RAMPDOWN		"lm3633_ptn:1:ramp_down"
+#define LM3633_EFFECT_PTN_LOWBRT		"lm3633_ptn:low_brt"
+#define LM3633_EFFECT_PTN_HIGHBRT		"lm3633_ptn:high_brt"
+#define LM3697_EFFECT_BL0_RAMPUP		"lm3697:0:ramp_up"
+#define LM3697_EFFECT_BL0_RAMPDOWN		"lm3697:0:ramp_down"
+#define LM3697_EFFECT_BL1_RAMPUP		"lm3697:1:ramp_up"
+#define LM3697_EFFECT_BL1_RAMPDOWN		"lm3697:1:ramp_down"
+
+enum lmu_effect_request_id {
+	/* Backlight effect */
+	BL_EFFECT_RAMPUP,
+	BL_EFFECT_RAMPDN,
+
+	/* LED pattern effect */
+	LED_EFFECT_DELAY,
+	LED_EFFECT_HIGHTIME,
+	LED_EFFECT_LOWTIME,
+	LED_EFFECT_PTN0_RAMPUP,
+	LED_EFFECT_PTN0_RAMPDN,
+	LED_EFFECT_PTN1_RAMPUP,
+	LED_EFFECT_PTN1_RAMPDN,
+	LED_EFFECT_LOWBRT,
+	LED_EFFECT_HIGHBRT,
+};
+
+struct ti_lmu_effect;
+
+typedef void (ti_lmu_effect_cb_t)(struct ti_lmu_effect *, int, void *);
+
+int ti_lmu_effect_request(const char *name, ti_lmu_effect_cb_t cbfunc,
+			  int req_id, void *data);
+int ti_lmu_effect_set_ramp(struct ti_lmu_effect *lmu_effect, int msec);
+int ti_lmu_effect_set_time(struct ti_lmu_effect *lmu_effect, int msec,
+			   u8 reg_offset);
+int ti_lmu_effect_set_level(struct ti_lmu_effect *lmu_effect, u8 val,
+			    u8 reg_offset);
+
+#endif
diff --git a/include/linux/mfd/ti-lmu-register.h b/include/linux/mfd/ti-lmu-register.h
new file mode 100644
index 0000000..27eb20c
--- /dev/null
+++ b/include/linux/mfd/ti-lmu-register.h
@@ -0,0 +1,269 @@
+/*
+ * TI LMU(Lighting Management Unit) Device Register Map
+ *
+ * Copyright 2014 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __MFD_TI_LMU_REGISTER_H__
+#define __MFD_TI_LMU_REGISTER_H__
+
+#include <linux/mfd/ti-lmu.h>
+
+#define LMU_FULL_MASKBIT		0xFF
+
+/* LM3532 */
+#define LM3532_REG_OUTPUT_CFG		0x10
+#define LM3532_ILED1_CFG_MASK		0x03
+#define LM3532_ILED2_CFG_MASK		0x0C
+#define LM3532_ILED3_CFG_MASK		0x30
+#define LM3532_ILED1_CFG_SHIFT		0
+#define LM3532_ILED2_CFG_SHIFT		2
+#define LM3532_ILED3_CFG_SHIFT		4
+
+#define LM3532_REG_RAMPUP		0x12
+#define LM3532_REG_RAMPDN		LM3532_REG_RAMPUP
+#define LM3532_RAMPUP_MASK		0x07
+#define LM3532_RAMPUP_SHIFT		0
+#define LM3532_RAMPDN_MASK		0x38
+#define LM3532_RAMPDN_SHIFT		3
+
+#define LM3532_REG_ENABLE		0x1D
+
+#define LM3532_REG_PWM_CFG_BASE		0x13
+#define LM3532_PWM_SEL_A_MASK		0x05	/* zone 0 */
+#define LM3532_PWM_SEL_B_MASK		0x09	/* zone 1 */
+#define LM3532_PWM_SEL_C_MASK		0x11	/* zone 2 */
+#define LM3532_PWM_SEL_A_SHIFT		2
+#define LM3532_PWM_SEL_B_SHIFT		3
+#define LM3532_PWM_SEL_C_SHIFT		4
+
+#define LM3532_REG_ZONE_CFG_A		0x16
+#define LM3532_REG_ZONE_CFG_B		0x18
+#define LM3532_REG_ZONE_CFG_C		0x1A
+#define LM3532_ZONE_CFG_MASK		(BIT(2) | BIT(3) | BIT(4))
+#define LM3532_ZONE_CFG_SHIFT		2
+
+#define LM3532_REG_IMAX_A		0x17
+#define LM3532_REG_IMAX_B		0x19
+#define LM3532_REG_IMAX_C		0x1B
+
+#define LM3532_REG_BRT_A		0x70	/* zone 0 */
+#define LM3532_REG_BRT_B		0x76	/* zone 1 */
+#define LM3532_REG_BRT_C		0x7C	/* zone 2 */
+
+#define LM3532_MAX_REGISTERS		0x7E
+
+/* LM3631 */
+#define LM3631_REG_DEVCTRL		0x00
+#define LM3631_LCD_EN_MASK		BIT(1)
+#define LM3631_LCD_EN_SHIFT		1
+#define LM3631_BL_EN_MASK		BIT(0)
+#define LM3631_BL_EN_SHIFT		0
+
+#define LM3631_REG_BRT_LSB		0x01
+#define LM3631_BRT_LSB_MASK		(BIT(0) | BIT(1) | BIT(2))
+#define LM3631_REG_BRT_MSB		0x02
+#define LM3631_BRT_MSB_SHIFT		3
+
+#define LM3631_REG_BL_CFG		0x06
+#define LM3631_BL_STRING_MASK		BIT(3)
+#define LM3631_BL_TWO_STRINGS		0
+#define LM3631_BL_ONE_STRING		BIT(3)
+#define LM3631_MAP_MASK			BIT(5)
+#define LM3631_EXPONENTIAL_MAP		0
+
+#define LM3631_REG_BL_BOOST		0x07
+#define LM3631_BOOST_OVP_MASK		(BIT(1) | BIT(2))
+#define LM3631_BOOST_OVP_25V		0x04
+
+#define LM3631_REG_BRT_MODE		0x08
+#define LM3631_EN_SLOPE_MASK		BIT(1)
+#define LM3631_MODE_MASK		(BIT(2) | BIT(3))
+#define LM3631_MODE_I2C			(0 << 2)
+#define LM3631_MODE_PWM			(1 << 2)
+#define LM3631_MODE_COMB1		(2 << 2) /* PWM x I2C before sloping */
+#define LM3631_MODE_COMB2		(3 << 2) /* PWM x Sloped I2C */
+
+#define LM3631_REG_SLOPE		0x09
+#define LM3631_SLOPE_MASK		0xF0
+#define LM3631_SLOPE_SHIFT		4
+
+#define LM3631_REG_LDO_CTRL1		0x0A
+#define LM3631_EN_OREF_MASK		BIT(0)
+#define LM3631_EN_VNEG_MASK		BIT(1)
+#define LM3631_EN_VPOS_MASK		BIT(2)
+
+#define LM3631_REG_LDO_CTRL2		0x0B
+#define LM3631_EN_CONT_MASK		BIT(0)
+
+#define LM3631_REG_VOUT_CONT		0x0C
+#define LM3631_VOUT_CONT_MASK		(BIT(6) | BIT(7))
+
+#define LM3631_REG_VOUT_BOOST		0x0C
+#define LM3631_REG_VOUT_POS		0x0D
+#define LM3631_REG_VOUT_NEG		0x0E
+#define LM3631_REG_VOUT_OREF		0x0F
+#define LM3631_VOUT_MASK		0x3F
+
+#define LM3631_REG_ENTIME_VCONT		0x0B
+#define LM3631_ENTIME_CONT_MASK		0x70
+
+#define LM3631_REG_ENTIME_VOREF		0x0F
+#define LM3631_REG_ENTIME_VPOS		0x10
+#define LM3631_REG_ENTIME_VNEG		0x11
+#define LM3631_ENTIME_MASK		0xF0
+#define LM3631_ENTIME_SHIFT		4
+
+#define LM3631_MAX_REGISTERS		0x16
+
+/* LM3633 */
+#define LM3633_REG_HVLED_OUTPUT_CFG	0x10
+
+#define LM3633_REG_BANK_SEL		0x11
+
+#define LM3633_REG_BL0_RAMPUP		0x12
+#define LM3633_REG_BL0_RAMPDN		LM3633_REG_BL0_RAMPUP
+#define LM3633_BL0_RAMPUP_MASK		0xF0
+#define LM3633_BL0_RAMPUP_SHIFT		4
+#define LM3633_BL0_RAMPDN_MASK		0x0F
+#define LM3633_BL0_RAMPDN_SHIFT		0
+
+#define LM3633_REG_BL1_RAMPUP		0x13
+#define LM3633_REG_BL1_RAMPDN		LM3633_REG_BL1_RAMPUP
+#define LM3633_BL1_RAMPUP_MASK		LM3633_BL0_RAMPUP_MASK
+#define LM3633_BL1_RAMPUP_SHIFT		LM3633_BL0_RAMPUP_SHIFT
+#define LM3633_BL1_RAMPDN_MASK		LM3633_BL0_RAMPDN_MASK
+#define LM3633_BL1_RAMPDN_SHIFT		LM3633_BL0_RAMPDN_SHIFT
+
+#define LM3633_REG_BL_RAMP_CONF		0x1B
+#define LM3633_BL_RAMP_MASK		0x0F
+#define LM3633_BL_RAMP_EACH		0x05
+
+#define LM3633_REG_PTN0_RAMPUP		0x1C
+#define LM3633_REG_PTN0_RAMPDN		LM3633_REG_PTN0_RAMPUP
+#define LM3633_PTN0_RAMPUP_MASK		0x70
+#define LM3633_PTN0_RAMPUP_SHIFT	4
+#define LM3633_PTN0_RAMPDN_MASK		0x07
+#define LM3633_PTN0_RAMPDN_SHIFT	0
+
+#define LM3633_REG_PTN1_RAMPUP		0x1D
+#define LM3633_REG_PTN1_RAMPDN		LM3633_REG_PTN1_RAMPUP
+#define LM3633_PTN1_RAMPUP_MASK		LM3633_PTN0_RAMPUP_MASK
+#define LM3633_PTN1_RAMPUP_SHIFT	LM3633_PTN0_RAMPUP_SHIFT
+#define LM3633_PTN1_RAMPDN_MASK		LM3633_PTN0_RAMPDN_MASK
+#define LM3633_PTN1_RAMPDN_SHIFT	LM3633_PTN0_RAMPDN_SHIFT
+
+#define LM3633_REG_IMAX_HVLED_A		0x20
+#define LM3633_REG_IMAX_HVLED_B		0x21
+#define LM3633_REG_IMAX_LVLED_BASE	0x22
+
+#define LM3633_REG_ENABLE		0x2B
+#define LM3633_LED_BANK_OFFSET		2
+
+#define LM3633_REG_PATTERN		0x2C
+#define LM3633_PATTERN_EN		1
+
+#define LM3633_REG_BOOST_CFG		0x2D
+#define LM3633_BOOST_OVP_MASK		(BIT(1) | BIT(2))
+
+#define LM3633_REG_PWM_CFG		0x2F
+
+#define LM3633_REG_BRT_HVLED_A_LSB	0x40
+#define LM3633_REG_BRT_HVLED_A_MSB	0x41
+#define LM3633_REG_BRT_HVLED_B_LSB	0x42
+#define LM3633_REG_BRT_HVLED_B_MSB	0x43
+#define LM3633_BRT_HVLED_LSB_MASK	(BIT(0) | BIT(1) | BIT(2))
+#define LM3633_BRT_HVLED_MSB_SHIFT	3
+
+#define LM3633_REG_BRT_LVLED_BASE	0x44
+
+#define LM3633_REG_DELAY		0x50
+#define LM3633_DELAY_MASK		LMU_FULL_MASKBIT
+#define LM3633_DELAY_SHIFT		0
+
+#define LM3633_REG_LOWTIME		0x51
+#define LM3633_LOWTIME_MASK		LMU_FULL_MASKBIT
+#define LM3633_LOWTIME_SHIFT		0
+
+#define LM3633_REG_HIGHTIME		0x52
+#define LM3633_HIGHTIME_MASK		LMU_FULL_MASKBIT
+#define LM3633_HIGHTIME_SHIFT		0
+
+#define LM3633_REG_LOWBRT		0x53
+#define LM3633_LOWBRT_MASK		LMU_FULL_MASKBIT
+#define LM3633_LOWBRT_SHIFT		0
+
+#define LM3633_REG_HIGHBRT		LM3633_REG_BRT_LVLED_BASE
+#define LM3633_HIGHBRT_MASK		LMU_FULL_MASKBIT
+#define LM3633_HIGHBRT_SHIFT		0
+
+#define LM3633_PATTERN_REG_OFFSET	16
+
+#define LM3633_MAX_REGISTERS		0xB4
+
+/* LM3695 */
+#define LM3695_REG_GP			0x10
+#define LM3695_BL_STRING_MASK		BIT(3)
+#define LM3695_BL_TWO_STRINGS		0
+#define LM3695_BL_ONE_STRING		BIT(3)
+#define LM3695_BRT_RW_MASK		BIT(2)
+#define LM3695_BRT_SET_RW		BIT(2)
+#define LM3695_BL_EN_MASK		BIT(0)
+
+#define LM3695_REG_BRT_LSB		0x13
+#define LM3695_BRT_LSB_MASK		(BIT(0) | BIT(1) | BIT(2))
+#define LM3695_REG_BRT_MSB		0x14
+#define LM3695_BRT_MSB_SHIFT		3
+
+#define LM3695_MAX_REGISTERS		0x14
+
+/* LM3697 */
+#define LM3697_REG_HVLED_OUTPUT_CFG	0x10
+
+#define LM3697_REG_BL0_RAMPUP		0x11
+#define LM3697_REG_BL0_RAMPDN		LM3697_REG_BL0_RAMPUP
+#define LM3697_BL0_RAMPUP_MASK		0xF0
+#define LM3697_BL0_RAMPUP_SHIFT		4
+#define LM3697_BL0_RAMPDN_MASK		0x0F
+#define LM3697_BL0_RAMPDN_SHIFT		0
+
+#define LM3697_REG_BL1_RAMPUP		0x12
+#define LM3697_REG_BL1_RAMPDN		LM3697_REG_BL1_RAMPUP
+#define LM3697_BL1_RAMPUP_MASK		LM3697_BL0_RAMPUP_MASK
+#define LM3697_BL1_RAMPUP_SHIFT		LM3697_BL0_RAMPUP_SHIFT
+#define LM3697_BL1_RAMPDN_MASK		LM3697_BL0_RAMPDN_MASK
+#define LM3697_BL1_RAMPDN_SHIFT		LM3697_BL0_RAMPDN_SHIFT
+
+#define LM3697_REG_RAMP_CONF		0x14
+#define LM3697_RAMP_MASK		0x0F
+#define LM3697_RAMP_EACH		0x05
+
+#define LM3697_REG_PWM_CFG		0x1C
+
+#define LM3697_REG_IMAX_A		0x17
+#define LM3697_REG_IMAX_B		0x18
+
+#define LM3697_REG_BOOST_CFG		0x1A
+#define LM3697_BOOST_FREQ_MASK		BIT(0)
+#define LM3697_BOOST_FREQ_SHIFT		0
+#define LM3697_BOOST_OVP_MASK		(BIT(1) | BIT(2))
+#define LM3697_BOOST_OVP_SHIFT		1
+
+#define LM3697_REG_BRT_A_LSB		0x20
+#define LM3697_REG_BRT_A_MSB		0x21
+#define LM3697_REG_BRT_B_LSB		0x22
+#define LM3697_REG_BRT_B_MSB		0x23
+#define LM3697_BRT_LSB_MASK		(BIT(0) | BIT(1) | BIT(2))
+#define LM3697_BRT_MSB_SHIFT		3
+
+#define LM3697_REG_ENABLE		0x24
+
+#define LM3697_MAX_REGISTERS		0xB4
+#endif
diff --git a/include/linux/mfd/ti-lmu.h b/include/linux/mfd/ti-lmu.h
new file mode 100644
index 0000000..c785a0d
--- /dev/null
+++ b/include/linux/mfd/ti-lmu.h
@@ -0,0 +1,150 @@
+/*
+ * TI LMU(Lighting Management Unit) Devices
+ *
+ * Copyright 2014 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __MFD_TI_LMU_H__
+#define __MFD_TI_LMU_H__
+
+#include <linux/gpio.h>
+#include <linux/regmap.h>
+
+#define LM3631_NUM_REGULATORS			5
+
+enum ti_lmu_id {
+	LM3532,
+	LM3631,
+	LM3633,
+	LM3695,
+	LM3697,
+};
+
+enum ti_lmu_max_current {
+	LMU_IMAX_5mA,
+	LMU_IMAX_6mA,
+	LMU_IMAX_7mA = 0x03,
+	LMU_IMAX_8mA,
+	LMU_IMAX_9mA,
+	LMU_IMAX_10mA = 0x07,
+	LMU_IMAX_11mA,
+	LMU_IMAX_12mA,
+	LMU_IMAX_13mA,
+	LMU_IMAX_14mA,
+	LMU_IMAX_15mA = 0x0D,
+	LMU_IMAX_16mA,
+	LMU_IMAX_17mA,
+	LMU_IMAX_18mA,
+	LMU_IMAX_19mA,
+	LMU_IMAX_20mA = 0x13,
+	LMU_IMAX_21mA,
+	LMU_IMAX_22mA,
+	LMU_IMAX_23mA = 0x17,
+	LMU_IMAX_24mA,
+	LMU_IMAX_25mA,
+	LMU_IMAX_26mA,
+	LMU_IMAX_27mA = 0x1C,
+	LMU_IMAX_28mA,
+	LMU_IMAX_29mA,
+	LMU_IMAX_30mA,
+};
+
+/*
+ * struct lm3633_bl_platform_data
+ * @name: Backlight device name
+ * @bl_string: Bit mask of backlight output string
+ * @imax: Max current for backlight output string
+ * @init_brightness: Initial brightness value
+ * @ramp_up_ms: Backlight light effect for ramp up or slope rate
+ * @ramp_down_ms: Backlight light effect for ramp down rate
+ * @pwm_period: Platform specific PWM period value. unit is nano
+ */
+struct ti_lmu_backlight_platform_data {
+	const char *name;
+
+	unsigned long bl_string;	/* bit OR mask of LMU_HVLEDx */
+#define LMU_HVLED1		BIT(0)
+#define LMU_HVLED2		BIT(1)
+#define LMU_HVLED3		BIT(2)
+
+	enum ti_lmu_max_current imax;
+	u8 init_brightness;
+
+	/* Used for light effect */
+	unsigned int ramp_up_ms;
+	unsigned int ramp_down_ms;
+
+	/* Only valid in case of PWM mode */
+	unsigned int pwm_period;
+};
+
+/*
+ * struct lmu_led_platform_data
+ * @name: LED channel name
+ * @led_string: Bit mask of LED output string
+ * @imax: LED max current
+ */
+struct ti_lmu_led_platform_data {
+	const char *name;
+
+	unsigned long led_string;	/* bit OR mask of LMU_LVLEDx */;
+#define LMU_LVLED1		BIT(0)
+#define LMU_LVLED2		BIT(1)
+#define LMU_LVLED3		BIT(2)
+#define LMU_LVLED4		BIT(3)
+#define LMU_LVLED5		BIT(4)
+#define LMU_LVLED6		BIT(5)
+
+	enum ti_lmu_max_current imax;
+};
+
+/*
+ * struct lmu_platform_data
+ * @en_gpio: GPIO for HWEN pin
+ * @bl_pdata: Backlight platform data
+ * @num_backlights: Number of backlight outputs
+ * @led_pdata: LED platform data
+ * @num_leds: Number of LED outputs
+ * @regulator_data: Regulator init data
+ */
+struct ti_lmu_platform_data {
+	int en_gpio;
+
+	/* Backlight */
+	struct ti_lmu_backlight_platform_data *bl_pdata;
+	int num_backlights;
+
+	/* LEDs */
+	struct ti_lmu_led_platform_data *led_pdata;
+	int num_leds;
+
+	/* Regulators of LM3631 */
+	struct regulator_init_data *regulator_data[LM3631_NUM_REGULATORS];
+};
+
+/*
+ * struct ti_lmu
+ * @id: Chip ID
+ * @dev: Parent device pointer
+ * @regmap: Used for i2c communcation on accessing registers
+ * @pdata: LMU platform specific data
+ */
+struct ti_lmu {
+	int id;
+	struct device *dev;
+	struct regmap *regmap;
+	struct ti_lmu_platform_data *pdata;
+};
+
+int ti_lmu_read_byte(struct ti_lmu *lmu, u8 reg, u8 *read);
+int ti_lmu_write_byte(struct ti_lmu *lmu, u8 reg, u8 data);
+int ti_lmu_update_bits(struct ti_lmu *lmu, u8 reg, u8 mask, u8 data);
+enum ti_lmu_max_current ti_lmu_get_current_code(u8 imax);
+#endif
-- 
1.7.9.5

