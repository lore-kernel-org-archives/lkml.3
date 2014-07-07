Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaGGPMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:12:48 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35840 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaGGPMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:12:22 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/4] pinctrl: qpnp: Qualcomm PMIC pin controller driver
Date: Mon,  7 Jul 2014 18:11:30 +0300
Message-Id: <1404745893-6379-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This is the pinctrl, pinmux, pinconf and gpiolib driver for the
Qualcomm GPIO and MPP subfunction blocks found in the PMIC chips.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/pinctrl/Kconfig                    |   10 +
 drivers/pinctrl/Makefile                   |    1 +
 drivers/pinctrl/pinctrl-qpnp.c             | 1454 ++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-qpnp.h             |   41 +
 include/dt-bindings/pinctrl/pinctrl-qpnp.h |   76 ++
 5 files changed, 1582 insertions(+)
 create mode 100644 drivers/pinctrl/pinctrl-qpnp.c
 create mode 100644 drivers/pinctrl/pinctrl-qpnp.h
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-qpnp.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 0042ccb..297c84d 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -383,6 +383,16 @@ config PINCTRL_PALMAS
 	  open drain configuration for the Palmas series devices like
 	  TPS65913, TPS80036 etc.
 
+config PINCTRL_QPNP
+	bool
+	select PINMUX
+	select PINCONF
+	select GENERIC_PINCONF
+	select GPIOLIB
+	help
+	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
+	  Qualcomm GPIO and MPP blocks found in the Qualcomm PMIC's chips.
+
 config PINCTRL_S3C24XX
 	bool "Samsung S3C24XX SoC pinctrl driver"
 	depends on ARCH_S3C24XX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index c4b5d40..bfbdba1 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
 obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
 obj-$(CONFIG_PINCTRL_DB8540)	+= pinctrl-nomadik-db8540.o
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
+obj-$(CONFIG_PINCTRL_QPNP)	+= pinctrl-qpnp.o
 obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
 obj-$(CONFIG_PINCTRL_SIRF)	+= sirf/
diff --git a/drivers/pinctrl/pinctrl-qpnp.c b/drivers/pinctrl/pinctrl-qpnp.c
new file mode 100644
index 0000000..9d4ef70
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-qpnp.c
@@ -0,0 +1,1454 @@
+/* Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#include <linux/export.h>
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <dt-bindings/pinctrl/pinctrl-qpnp.h>
+
+#include "core.h"
+#include "pinctrl-utils.h"
+#include "pinctrl-qpnp.h"
+
+/*
+ * Mode select - indicates whether the pin should be input, output, or both
+ * for GPIOs. MPP pins also support bidirectional, analog input, analog output
+ * and current sink.
+ */
+#define QPNP_PIN_MODE_DIG_IN			0
+#define QPNP_PIN_MODE_DIG_OUT			1
+#define QPNP_PIN_MODE_DIG_IN_OUT		2
+#define QPNP_PIN_MODE_BIDIR			3
+#define QPNP_PIN_MODE_AIN			4
+#define QPNP_PIN_MODE_AOUT			5
+#define QPNP_PIN_MODE_SINK			6
+
+#define QPNP_PIN_MODE_GPIO_INVALID		3
+#define QPNP_PIN_MODE_MPP_INVALID		7
+
+/*
+ * Voltage select (GPIO, MPP) - specifies the voltage level when the output
+ * is set to 1. For an input GPIO specifies the voltage level at which
+ * the input is interpreted as a logical 1
+ * To be used with "power-source = <>"
+ */
+#define QPNP_PIN_VIN_4CH_INVALID		5
+#define QPNP_PIN_VIN_8CH_INVALID		8
+
+/*
+ * Source Select (GPIO) / Enable Select (MPP) - select alternate function for
+ * the pin. Certain pins can be paired (shorted) with each other. Some pins
+ * can act as alternate functions. In the context of GPIO, this acts as a
+ * source select. For MPPs, this is an enable select.
+ * To be used with "output-high = <>"
+ */
+#define QPNP_PIN_SEL_INVALID			8
+
+/*
+ * Analog Output (MPP) - Set the analog output reference.
+ * To be used with "qcom,aout-ctrl = <>"
+ */
+#define QPNP_PIN_AOUT_INVALID			8
+
+/*
+ * Analog Input (MPP) - Set the source for analog input.
+ * To be used with "qcom,ain-ctrl = <>"
+ */
+#define QPNP_PIN_AIN_INVALID			8
+
+/*
+ * Output type (GPIO) - indicates pin should be configured as CMOS or
+ * open drain.
+ */
+#define QPNP_PIN_OUT_BUF_CMOS			0
+#define QPNP_PIN_OUT_BUF_OPEN_DRAIN_NMOS	1
+#define QPNP_PIN_OUT_BUF_OPEN_DRAIN_PMOS	2
+
+/*
+ * Pull Up Values (GPIO) - it indicates whether a pull up or pull down
+ * should be applied. If a pull-up is required the current strength needs
+ * to be specified. Current values of 30uA, 1.5uA, 31.5uA, 1.5uA with 30uA
+ * boost are supported.
+ * Note that the hardware ignores this configuration if the GPIO is not set
+ * to input or output open-drain mode.
+ */
+#define QPNP_PIN_GPIO_PULL_UP_30		0
+#define QPNP_PIN_GPIO_PULL_UP_1P5		1
+#define QPNP_PIN_GPIO_PULL_UP_31P5		2
+#define QPNP_PIN_GPIO_PULL_UP_1P5_30		3
+#define QPNP_PIN_GPIO_PULL_DN			4
+#define QPNP_PIN_GPIO_PULL_NO			5
+#define QPNP_PIN_GPIO_PULL_INVALID		6
+
+/*
+ * Pull Up Values (MPP) - it indicates whether a pull-up should be
+ * applied for bidirectional mode only. The hardware ignores the
+ * configuration when operating in other modes.
+ */
+#define QPNP_PIN_MPP_PULL_UP_0P6KOHM		0
+#define QPNP_PIN_MPP_PULL_UP_OPEN		1
+#define QPNP_PIN_MPP_PULL_UP_10KOHM		2
+#define QPNP_PIN_MPP_PULL_UP_30KOHM		3
+#define QPNP_PIN_MPP_PULL_INVALID		4
+
+/* Out Strength (GPIO) - the amount of current supplied for an output GPIO */
+#define QPNP_PIN_OUT_STRENGTH_LOW		1
+#define QPNP_PIN_OUT_STRENGTH_MED		2
+#define QPNP_PIN_OUT_STRENGTH_HIGH		3
+#define QPNP_PIN_OUT_STRENGTH_INVALID		4
+
+/*
+ * Master enable (GPIO, MPP) - Enable features within the pin block based on
+ * configurations. QPNP_PIN_MASTER_DISABLE = Completely disable the pin
+ * lock and let the pin float with high impedance regardless of other settings.
+ */
+#define QPNP_PIN_MASTER_DISABLE			0
+#define QPNP_PIN_MASTER_ENABLE			1
+
+/* Current Sink (MPP) Set the the amount of current to sync in mA. */
+#define QPNP_PIN_CS_OUT_5MA			0
+#define QPNP_PIN_CS_OUT_10MA			1
+#define QPNP_PIN_CS_OUT_15MA			2
+#define QPNP_PIN_CS_OUT_20MA			3
+#define QPNP_PIN_CS_OUT_25MA			4
+#define QPNP_PIN_CS_OUT_30MA			5
+#define QPNP_PIN_CS_OUT_35MA			6
+#define QPNP_PIN_CS_OUT_40MA			7
+
+/* revision registers base address offsets */
+#define QPNP_REG_DIG_MINOR_REV			0x0
+#define QPNP_REG_DIG_MAJOR_REV			0x1
+#define QPNP_REG_ANA_MINOR_REV			0x2
+
+/* type registers base address offsets */
+#define QPNP_REG_TYPE				0x4
+#define QPNP_REG_SUBTYPE			0x5
+
+/* GPIO peripheral type and subtype values */
+#define QPNP_GPIO_TYPE				0x10
+#define QPNP_GPIO_SUBTYPE_GPIO_4CH		0x1
+#define QPNP_GPIO_SUBTYPE_GPIOC_4CH		0x5
+#define QPNP_GPIO_SUBTYPE_GPIO_8CH		0x9
+#define QPNP_GPIO_SUBTYPE_GPIOC_8CH		0xd
+
+/* mpp peripheral type and subtype values */
+#define QPNP_MPP_TYPE				0x11
+#define QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT		0x3
+#define QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT	0x4
+#define QPNP_MPP_SUBTYPE_4CH_NO_SINK		0x5
+#define QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK	0x6
+#define QPNP_MPP_SUBTYPE_4CH_FULL_FUNC		0x7
+#define QPNP_MPP_SUBTYPE_8CH_FULL_FUNC		0xf
+
+#define QPNP_REG_STATUS1			0x8
+#define QPNP_REG_STATUS1_VAL_MASK		0x1
+#define QPNP_REG_STATUS1_GPIO_EN_REV0_MASK	0x2
+#define QPNP_REG_STATUS1_GPIO_EN_MASK		0x80
+#define QPNP_REG_STATUS1_MPP_EN_MASK		0x80
+
+/* control register base address offsets */
+#define QPNP_REG_MODE_CTL			0x40
+#define QPNP_REG_DIG_VIN_CTL			0x41
+#define QPNP_REG_DIG_PULL_CTL			0x42
+#define QPNP_REG_DIG_IN_CTL			0x43
+#define QPNP_REG_DIG_OUT_CTL			0x45
+#define QPNP_REG_EN_CTL				0x46
+#define QPNP_REG_AOUT_CTL			0x4b
+#define QPNP_REG_AIN_CTL			0x4a
+#define QPNP_REG_SINK_CTL			0x4c
+
+#define QPNP_NUM_CTL_REGS			13
+
+/* QPNP_REG_MODE_CTL */
+#define QPNP_REG_OUT_SRC_SEL_SHIFT		0
+#define QPNP_REG_OUT_SRC_SEL_MASK		0xf
+#define QPNP_REG_MODE_SEL_SHIFT			4
+#define QPNP_REG_MODE_SEL_MASK			0x70
+
+/* QPNP_REG_DIG_VIN_CTL */
+#define QPNP_REG_VIN_SHIFT			0
+#define QPNP_REG_VIN_MASK			0x7
+
+/* QPNP_REG_DIG_PULL_CTL */
+#define QPNP_REG_PULL_SHIFT			0
+#define QPNP_REG_PULL_MASK			0x7
+
+/* QPNP_REG_DIG_OUT_CTL */
+#define QPNP_REG_OUT_STRENGTH_SHIFT		0
+#define QPNP_REG_OUT_STRENGTH_MASK		0x3
+#define QPNP_REG_OUT_TYPE_SHIFT			4
+#define QPNP_REG_OUT_TYPE_MASK			0x30
+
+/* QPNP_REG_EN_CTL */
+#define QPNP_REG_MASTER_EN_SHIFT		7
+#define QPNP_REG_MASTER_EN_MASK			0x80
+
+/* QPNP_REG_AOUT_CTL */
+#define QPNP_REG_AOUT_REF_SHIFT			0
+#define QPNP_REG_AOUT_REF_MASK			0x7
+
+/* QPNP_REG_AIN_CTL */
+#define QPNP_REG_AIN_ROUTE_SHIFT		0
+#define QPNP_REG_AIN_ROUTE_MASK			0x7
+
+/* QPNP_REG_SINK_CTL */
+#define QPNP_REG_CS_OUT_SHIFT			0
+#define QPNP_REG_CS_OUT_MASK			0x7
+
+/* Qualcomm specific pin configurations */
+#define QPNP_PINCONF_PARAM_AIN_CTRL		(PIN_CONFIG_END + 1)
+#define QPNP_PINCONF_PARAM_AOUT_CTRL		(PIN_CONFIG_END + 2)
+
+struct qpnp_pindesc {
+	u16 offset;		/* address offset in SPMI device */
+	u32 index;		/* offset from GPIO info base */
+	u8 type;		/* peripheral hardware type */
+	u8 subtype;		/* peripheral hardware subtype */
+	u8 major;		/* digital major version */
+	u8 num_regs;		/* control register count */
+	u8 cache[QPNP_NUM_CTL_REGS]; /* control register cache */
+};
+
+#define QPNP_REG_ADDR(qdesc, reg) ((qdesc)->offset + reg)
+#define QPNP_REG_CACHE(qdesc, reg) (&(qdesc)->cache[reg - QPNP_REG_MODE_CTL])
+
+struct qpnp_pingroups {
+	const char **pins;
+	unsigned npins;
+};
+
+struct qpnp_pinctrl {
+	struct device *dev;
+	struct regmap *map;
+	struct pinctrl_dev *ctrl;
+	struct gpio_chip chip;
+	struct pinctrl_desc desc;
+	struct qpnp_pindesc *pins;
+	struct pinctrl_gpio_range range;
+	struct qpnp_pingroups groups[QPNP_MUX_CNT];
+	const struct qpnp_pinctrl_info *info;
+};
+
+static inline struct qpnp_pinctrl *to_qpnp_pinctrl(struct gpio_chip *chip)
+{
+	return container_of(chip, struct qpnp_pinctrl, chip);
+};
+
+struct qpnp_pinbindings {
+	const char *property;
+	unsigned param;
+	u32 default_value;
+};
+
+struct qpnp_pinattrib {
+	unsigned addr;
+	unsigned shift;
+	unsigned mask;
+	unsigned val;
+};
+
+static struct qpnp_pinbindings qpnp_pinbindings[] = {
+	/* QPNP_PIN_AIN_AMUX_CH5...QPNP_PIN_AIN_AMUX_ABUS4 */
+	{"qcom,ain-ctrl",	QPNP_PINCONF_PARAM_AIN_CTRL, 0},
+	/* QPNP_PIN_AOUT_1V25...QPNP_PIN_AOUT_ABUS4 */
+	{"qcom,aout-ctrl",	QPNP_PINCONF_PARAM_AOUT_CTRL, 0},
+};
+
+static const char *const qpnp_functions_names[] = {
+	[QPNP_MUX_GPIO]	= "gpio",
+	[QPNP_MUX_AIN]	= "mpp-ain",
+	[QPNP_MUX_AOUT]	= "mpp-aout",
+	[QPNP_MUX_CS]	= "mpp-cs"
+};
+
+static inline struct qpnp_pindesc *qpnp_get_desc(struct qpnp_pinctrl *qctrl,
+						 unsigned pin)
+{
+	if (pin > qctrl->info->npads) {
+		dev_warn(qctrl->dev, "invalid pin number %d", pin);
+		return NULL;
+	}
+
+	return &qctrl->pins[pin];
+}
+
+static inline u8 QPNP_GET(u8 *buff, int shift, int mask)
+{
+	return (*buff & mask) >> shift;
+}
+
+static inline void QPNP_SET(u8 *buff, int shift, int mask, int value)
+{
+	*buff &= ~mask;
+	*buff |= (value << shift) & mask;
+}
+
+static int qpnp_read_regs(struct qpnp_pinctrl *qctrl,
+			  struct qpnp_pindesc *qdesc)
+{
+	int left = qdesc->num_regs;
+	u8 *buff = QPNP_REG_CACHE(qdesc, QPNP_REG_MODE_CTL);
+	u16 addr = QPNP_REG_ADDR(qdesc, QPNP_REG_MODE_CTL);
+	int ret;
+
+	while (left > 0) {
+		ret = regmap_bulk_read(qctrl->map, addr, buff,
+				      left < 8 ? left : 8);
+		if (ret)
+			return ret;
+		left -= 8;
+		buff += 8;
+		addr += 8;
+	}
+
+	return 0;
+}
+
+static int qpnp_write_regs(struct qpnp_pinctrl *qctrl,
+			  struct qpnp_pindesc *qdesc)
+{
+	int left = qdesc->num_regs;
+	u8 *buff = QPNP_REG_CACHE(qdesc, QPNP_REG_MODE_CTL);
+	u16 addr = QPNP_REG_ADDR(qdesc, QPNP_REG_MODE_CTL);
+	int ret;
+
+	while (left > 0) {
+		ret = regmap_bulk_write(qctrl->map, addr, buff,
+				      left < 8 ? left : 8);
+		if (ret)
+			return ret;
+		left -= 8;
+		buff += 8;
+		addr += 8;
+	}
+
+	return 0;
+}
+
+/*
+ * Calculate the minimum number of registers that must be read / written
+ * in order to satisfy the full feature set of the given pin.
+ */
+static int qpnp_control_init(struct qpnp_pinctrl *qctrl,
+			  struct qpnp_padinfo *qpad,
+			  struct qpnp_pindesc *qdesc)
+{
+	if (qdesc->type == QPNP_GPIO_TYPE) {
+		switch (qdesc->subtype) {
+		case QPNP_GPIO_SUBTYPE_GPIO_4CH:
+		case QPNP_GPIO_SUBTYPE_GPIOC_4CH:
+		case QPNP_GPIO_SUBTYPE_GPIO_8CH:
+		case QPNP_GPIO_SUBTYPE_GPIOC_8CH:
+			qdesc->num_regs = 7;
+
+			/* only GPIO is supported*/
+			qpad->funcs[QPNP_MUX_AIN] = QPNP_MUX_GPIO;
+			qpad->funcs[QPNP_MUX_AOUT] = QPNP_MUX_GPIO;
+			qpad->funcs[QPNP_MUX_CS] = QPNP_MUX_GPIO;
+
+			qctrl->groups[QPNP_MUX_GPIO].npins++;
+			break;
+		default:
+			dev_err(qctrl->dev, "invalid GPIO subtype 0x%x\n",
+				qdesc->subtype);
+			return -EINVAL;
+		}
+
+	} else if (qdesc->type == QPNP_MPP_TYPE) {
+		switch (qdesc->subtype) {
+		case QPNP_MPP_SUBTYPE_4CH_NO_SINK:
+		case QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK:
+			qdesc->num_regs = 12;
+
+			/* Current sink not supported*/
+			qpad->funcs[QPNP_MUX_CS] = QPNP_MUX_GPIO;
+
+			qctrl->groups[QPNP_MUX_GPIO].npins++;
+			qctrl->groups[QPNP_MUX_AIN].npins++;
+			qctrl->groups[QPNP_MUX_AOUT].npins++;
+			break;
+		case QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT:
+		case QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT:
+			qdesc->num_regs = 13;
+
+			/* Analog output not supported*/
+			qpad->funcs[QPNP_MUX_AOUT] = QPNP_MUX_GPIO;
+
+			qctrl->groups[QPNP_MUX_GPIO].npins++;
+			qctrl->groups[QPNP_MUX_AIN].npins++;
+			qctrl->groups[QPNP_MUX_CS].npins++;
+			break;
+		case QPNP_MPP_SUBTYPE_4CH_FULL_FUNC:
+		case QPNP_MPP_SUBTYPE_8CH_FULL_FUNC:
+			qdesc->num_regs = 13;
+
+			qctrl->groups[QPNP_MUX_GPIO].npins++;
+			qctrl->groups[QPNP_MUX_AIN].npins++;
+			qctrl->groups[QPNP_MUX_AOUT].npins++;
+			qctrl->groups[QPNP_MUX_CS].npins++;
+			break;
+		default:
+			dev_err(qctrl->dev, "invalid MPP subtype 0x%x\n",
+				qdesc->subtype);
+			return -EINVAL;
+		}
+	} else {
+		dev_err(qctrl->dev, "invalid type 0x%x\n", qdesc->type);
+		return -EINVAL;
+	}
+
+	return qpnp_read_regs(qctrl, qdesc);
+}
+
+static int qpnp_conv_to_pinattrib(struct qpnp_pindesc *qdesc, unsigned param,
+			       unsigned val, struct qpnp_pinattrib attr[4])
+{
+	unsigned type, subtype;
+	int nattrs = 1;
+
+	type = qdesc->type;
+	subtype = qdesc->subtype;
+
+	switch (param) {
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
+		if (type != QPNP_GPIO_TYPE)
+			return -ENXIO;
+		attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
+		attr[0].shift = QPNP_REG_OUT_TYPE_SHIFT;
+		attr[0].mask  = QPNP_REG_OUT_TYPE_MASK;
+		attr[0].val   = QPNP_PIN_OUT_BUF_CMOS;
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+		if (type != QPNP_GPIO_TYPE)
+			return -ENXIO;
+		if (subtype == QPNP_GPIO_SUBTYPE_GPIOC_4CH ||
+		    subtype == QPNP_GPIO_SUBTYPE_GPIOC_8CH)
+			return -EINVAL;
+		attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
+		attr[0].shift = QPNP_REG_OUT_TYPE_SHIFT;
+		attr[0].mask  = QPNP_REG_OUT_TYPE_MASK;
+		attr[0].val   = QPNP_PIN_OUT_BUF_OPEN_DRAIN_NMOS;
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_SOURCE:
+		if (type != QPNP_GPIO_TYPE)
+			return -ENXIO;
+		if (subtype == QPNP_GPIO_SUBTYPE_GPIOC_4CH ||
+		    subtype == QPNP_GPIO_SUBTYPE_GPIOC_8CH)
+			return -EINVAL;
+		attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
+		attr[0].shift = QPNP_REG_OUT_TYPE_SHIFT;
+		attr[0].mask  = QPNP_REG_OUT_TYPE_MASK;
+		attr[0].val   = QPNP_PIN_OUT_BUF_OPEN_DRAIN_PMOS;
+		break;
+	case PIN_CONFIG_BIAS_DISABLE:
+		attr[0].addr  = QPNP_REG_DIG_PULL_CTL;
+		attr[0].shift = QPNP_REG_PULL_SHIFT;
+		attr[0].mask  = QPNP_REG_PULL_MASK;
+		if (type == QPNP_GPIO_TYPE)
+			attr[0].val = QPNP_PIN_GPIO_PULL_NO;
+		else
+			attr[0].val = QPNP_PIN_MPP_PULL_UP_OPEN;
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		if (type == QPNP_GPIO_TYPE) {
+			if (val >= QPNP_PIN_GPIO_PULL_INVALID)
+				return -EINVAL;
+		} else {
+			switch (val) {
+			case 0:
+				val = QPNP_PIN_MPP_PULL_UP_OPEN;
+				break;
+			case 600:
+				val = QPNP_PIN_MPP_PULL_UP_0P6KOHM;
+				break;
+			case 10000:
+				val = QPNP_PIN_MPP_PULL_UP_10KOHM;
+				break;
+			case 30000:
+				val = QPNP_PIN_MPP_PULL_UP_30KOHM;
+				break;
+			default:
+				return -EINVAL;
+				break;
+			}
+		}
+		attr[0].addr  = QPNP_REG_DIG_PULL_CTL;
+		attr[0].shift = QPNP_REG_PULL_SHIFT;
+		attr[0].mask  = QPNP_REG_PULL_MASK;
+		attr[0].val   = val;
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		if (type != QPNP_GPIO_TYPE)
+			return -EINVAL;
+		attr[0].addr  = QPNP_REG_DIG_PULL_CTL;
+		attr[0].shift = QPNP_REG_PULL_SHIFT;
+		attr[0].mask  = QPNP_REG_PULL_MASK;
+		attr[0].val   = QPNP_PIN_GPIO_PULL_DN;
+		break;
+	case PIN_CONFIG_POWER_SOURCE:
+		if (val >= QPNP_PIN_VIN_8CH_INVALID)
+			return -EINVAL;
+		if (val >= QPNP_PIN_VIN_4CH_INVALID) {
+			if (type == QPNP_GPIO_TYPE &&
+			   (subtype == QPNP_GPIO_SUBTYPE_GPIO_4CH ||
+			    subtype == QPNP_GPIO_SUBTYPE_GPIOC_4CH))
+				return -EINVAL;
+			if (type == QPNP_MPP_TYPE &&
+			   (subtype == QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT ||
+			    subtype == QPNP_MPP_SUBTYPE_4CH_NO_SINK ||
+			    subtype == QPNP_MPP_SUBTYPE_4CH_FULL_FUNC ||
+			    subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT ||
+			    subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK))
+				return -EINVAL;
+		}
+		attr[0].addr  = QPNP_REG_DIG_VIN_CTL;
+		attr[0].shift = QPNP_REG_VIN_SHIFT;
+		attr[0].mask  = QPNP_REG_VIN_MASK;
+		attr[0].val   = val;
+		break;
+	case PIN_CONFIG_DRIVE_STRENGTH:
+		if (type == QPNP_GPIO_TYPE) {
+			if (val >= QPNP_PIN_OUT_STRENGTH_INVALID || val == 0)
+				return -EINVAL;
+			attr[0].addr  = QPNP_REG_DIG_OUT_CTL;
+			attr[0].shift = QPNP_REG_OUT_STRENGTH_SHIFT;
+			attr[0].mask  = QPNP_REG_OUT_STRENGTH_MASK;
+			attr[0].val   = val;
+		} else {
+			if (subtype == QPNP_MPP_SUBTYPE_4CH_NO_SINK ||
+			    subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK)
+				return -ENXIO;
+			if (val > 50)	/* mA */
+				return -EINVAL;
+			attr[0].addr  = QPNP_REG_SINK_CTL;
+			attr[0].shift = QPNP_REG_CS_OUT_SHIFT;
+			attr[0].mask  = QPNP_REG_CS_OUT_MASK;
+			attr[0].val   = (val / 5) - 1;
+		}
+		break;
+	case PIN_CONFIG_INPUT_ENABLE:
+		nattrs = 2;
+		attr[0].addr  = QPNP_REG_MODE_CTL;
+		attr[0].shift = QPNP_REG_MODE_SEL_SHIFT;
+		attr[0].mask  = QPNP_REG_MODE_SEL_MASK;
+		attr[0].val   = QPNP_PIN_MODE_DIG_IN;
+		attr[1].addr  = QPNP_REG_EN_CTL;
+		attr[1].shift = QPNP_REG_MASTER_EN_SHIFT;
+		attr[1].mask  = QPNP_REG_MASTER_EN_MASK;
+		attr[1].val   = 1;
+		if (val)
+			break;
+	/* Fallthrough */
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
+		attr[1].addr  = QPNP_REG_EN_CTL;
+		attr[1].shift = QPNP_REG_MASTER_EN_SHIFT;
+		attr[1].mask  = QPNP_REG_MASTER_EN_MASK;
+		attr[1].val   = 0;
+		break;
+	case PIN_CONFIG_OUTPUT:
+		nattrs = 3;
+		if (val >= QPNP_PIN_SEL_INVALID)
+			return -EINVAL;
+		if (type == QPNP_MPP_TYPE &&
+		    (val == QPNP_PIN_SEL_FUNC_1 ||
+		     val == QPNP_PIN_SEL_FUNC_2))
+			return -EINVAL;
+		attr[0].addr  = QPNP_REG_MODE_CTL;
+		attr[0].shift = QPNP_REG_OUT_SRC_SEL_SHIFT;
+		attr[0].mask  = QPNP_REG_OUT_SRC_SEL_MASK;
+		attr[0].val   = val;
+		attr[1].addr  = QPNP_REG_MODE_CTL;
+		attr[1].shift = QPNP_REG_MODE_SEL_SHIFT;
+		attr[1].mask  = QPNP_REG_MODE_SEL_MASK;
+		attr[1].val   = QPNP_PIN_MODE_DIG_OUT;
+		attr[2].addr  = QPNP_REG_EN_CTL;
+		attr[2].shift = QPNP_REG_MASTER_EN_SHIFT;
+		attr[2].mask  = QPNP_REG_MASTER_EN_MASK;
+		attr[2].val   = 1;
+		break;
+	case QPNP_PINCONF_PARAM_AOUT_CTRL:
+		if (type != QPNP_MPP_TYPE)
+			return -ENXIO;
+		if (val >= QPNP_PIN_AOUT_INVALID)
+			return -EINVAL;
+		if (subtype == QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT ||
+		    subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT)
+			return -ENXIO;
+		attr[0].addr  = QPNP_REG_AOUT_CTL;
+		attr[0].shift = QPNP_REG_AOUT_REF_SHIFT;
+		attr[0].mask  = QPNP_REG_AOUT_REF_MASK;
+		attr[0].val   = val;
+		break;
+	case QPNP_PINCONF_PARAM_AIN_CTRL:
+		if (type != QPNP_MPP_TYPE)
+			return -ENXIO;
+		if (val >= QPNP_PIN_AIN_INVALID)
+			return -EINVAL;
+		attr[0].addr  = QPNP_REG_AIN_CTL;
+		attr[0].shift = QPNP_REG_AIN_ROUTE_SHIFT;
+		attr[0].mask  = QPNP_REG_AIN_ROUTE_MASK;
+		attr[0].val   = val;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return nattrs;
+}
+
+
+static int qpnp_conv_from_pinattrib(struct qpnp_pinctrl *qctrl,
+				  struct qpnp_pindesc *qdesc,
+				  unsigned param, unsigned *val)
+{
+	struct qpnp_pinattrib attr;
+	unsigned type, subtype, field;
+	unsigned int addr;
+	u8 *buff;
+
+	*val = 0;
+	type = qdesc->type;
+	subtype = qdesc->subtype;
+
+	switch (param) {
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+	case PIN_CONFIG_DRIVE_OPEN_SOURCE:
+		if (type != QPNP_GPIO_TYPE)
+			return -ENXIO;
+		attr.addr  = QPNP_REG_DIG_OUT_CTL;
+		attr.shift = QPNP_REG_OUT_TYPE_SHIFT;
+		attr.mask  = QPNP_REG_OUT_TYPE_MASK;
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		if (type != QPNP_GPIO_TYPE)
+			return -ENXIO;
+	/* Fallthrough */
+	case PIN_CONFIG_BIAS_DISABLE:
+	case PIN_CONFIG_BIAS_PULL_UP:
+		attr.addr  = QPNP_REG_DIG_PULL_CTL;
+		attr.shift = QPNP_REG_PULL_SHIFT;
+		attr.mask  = QPNP_REG_PULL_MASK;
+		break;
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
+		attr.addr  = QPNP_REG_EN_CTL;
+		attr.shift = QPNP_REG_MASTER_EN_SHIFT;
+		attr.mask  = QPNP_REG_MASTER_EN_MASK;
+		break;
+	case PIN_CONFIG_POWER_SOURCE:
+		attr.addr  = QPNP_REG_DIG_VIN_CTL;
+		attr.shift = QPNP_REG_VIN_SHIFT;
+		attr.mask  = QPNP_REG_VIN_MASK;
+		break;
+	case PIN_CONFIG_DRIVE_STRENGTH:
+		if (type == QPNP_GPIO_TYPE) {
+			attr.addr  = QPNP_REG_DIG_OUT_CTL;
+			attr.shift = QPNP_REG_OUT_STRENGTH_SHIFT;
+			attr.mask  = QPNP_REG_OUT_STRENGTH_MASK;
+		} else {
+			attr.addr  = QPNP_REG_SINK_CTL;
+			attr.shift = QPNP_REG_CS_OUT_SHIFT;
+			attr.mask  = QPNP_REG_CS_OUT_MASK;
+		}
+		break;
+	case PIN_CONFIG_INPUT_ENABLE:
+		attr.addr  = QPNP_REG_EN_CTL;
+		attr.shift = QPNP_REG_MASTER_EN_SHIFT;
+		attr.mask  = QPNP_REG_MASTER_EN_MASK;
+		break;
+	case PIN_CONFIG_OUTPUT:
+		attr.addr  = QPNP_REG_MODE_CTL;
+		attr.shift = QPNP_REG_OUT_SRC_SEL_SHIFT;
+		attr.mask  = QPNP_REG_OUT_SRC_SEL_MASK;
+		break;
+	case QPNP_PINCONF_PARAM_AOUT_CTRL:
+		if (type != QPNP_MPP_TYPE)
+			return -ENXIO;
+		if (subtype == QPNP_MPP_SUBTYPE_4CH_NO_ANA_OUT ||
+		    subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT)
+			return -ENXIO;
+		attr.addr  = QPNP_REG_AOUT_CTL;
+		attr.shift = QPNP_REG_AOUT_REF_SHIFT;
+		attr.mask  = QPNP_REG_AOUT_REF_MASK;
+		break;
+	case QPNP_PINCONF_PARAM_AIN_CTRL:
+		if (type != QPNP_MPP_TYPE)
+			return -ENXIO;
+		attr.addr  = QPNP_REG_AIN_CTL;
+		attr.shift = QPNP_REG_AIN_ROUTE_SHIFT;
+		attr.mask  = QPNP_REG_AIN_ROUTE_MASK;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	addr = QPNP_REG_ADDR(qdesc, attr.addr);
+	buff = QPNP_REG_CACHE(qdesc, attr.addr);
+
+	field = QPNP_GET(buff, attr.shift, attr.mask);
+
+	switch (param) {
+	case PIN_CONFIG_DRIVE_PUSH_PULL:
+		if (field == QPNP_PIN_OUT_BUF_CMOS)
+			*val = 1;
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+		if (field == QPNP_PIN_OUT_BUF_OPEN_DRAIN_NMOS)
+			*val = 1;
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_SOURCE:
+		if (field == QPNP_PIN_OUT_BUF_OPEN_DRAIN_PMOS)
+			*val = 1;
+		break;
+	case PIN_CONFIG_BIAS_DISABLE:
+		if (type == QPNP_GPIO_TYPE) {
+			if (field == QPNP_PIN_GPIO_PULL_NO)
+				*val = 1;
+		} else {
+			if (field == QPNP_PIN_MPP_PULL_UP_OPEN)
+				*val = 1;
+		}
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		if (type == QPNP_GPIO_TYPE) {
+			*val = field;
+		} else {
+			switch (field) {
+			default:
+			case QPNP_PIN_MPP_PULL_UP_OPEN:
+				*val = 0;
+				break;
+			case QPNP_PIN_MPP_PULL_UP_0P6KOHM:
+				*val = 600;
+				break;
+			case QPNP_PIN_MPP_PULL_UP_10KOHM:
+				*val = 10000;
+				break;
+			case QPNP_PIN_MPP_PULL_UP_30KOHM:
+				*val = 30000;
+				break;
+			}
+		}
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		if (field == QPNP_PIN_GPIO_PULL_DN)
+			*val = 1;
+		break;
+	case PIN_CONFIG_POWER_SOURCE:
+		*val = field;
+		break;
+	case PIN_CONFIG_DRIVE_STRENGTH:
+		if (type == QPNP_GPIO_TYPE)
+			*val = field;
+		else
+			*val = (field + 1) * 5;
+		break;
+	case PIN_CONFIG_INPUT_ENABLE:
+		*val = field;
+		break;
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
+		if (field == QPNP_PIN_MASTER_DISABLE)
+			*val = 1;
+		break;
+	case PIN_CONFIG_OUTPUT:
+		*val = field;
+		break;
+	case QPNP_PINCONF_PARAM_AOUT_CTRL:
+		*val = field;
+		break;
+	case QPNP_PINCONF_PARAM_AIN_CTRL:
+		*val = field;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int qpnp_get_groups_cnt(struct pinctrl_dev *pctldev)
+{
+	struct qpnp_pinctrl *qpctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	/* Every PIN is a group */
+	return qpctrl->info->npads;
+}
+
+static const char *qpnp_get_group_name(struct pinctrl_dev *pctldev,
+				       unsigned pin)
+{
+	struct qpnp_pinctrl *qpctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	/* Every PIN is a group */
+	return qpctrl->info->pads[pin].name;
+}
+
+static int qpnp_get_group_pins(struct pinctrl_dev *pctldev,
+			      unsigned pin,
+			      const unsigned **pins,
+			      unsigned *num_pins)
+{
+	struct qpnp_pinctrl *qpctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	/* Every PIN is a group */
+	*pins = &qpctrl->info->desc[pin].number;
+	*num_pins = 1;
+	return 0;
+}
+
+static int qpnp_parse_dt_config(struct device *dev, struct device_node *np,
+			unsigned long **configs, unsigned int *nconfigs)
+{
+	struct qpnp_pinbindings *par;
+	unsigned long *cfg;
+	unsigned int ncfg = 0;
+	int ret;
+	int i;
+	u32 val;
+
+	if (!np)
+		return -EINVAL;
+
+	/* allocate a temporary array big enough to hold one of each option */
+	cfg = kcalloc(ARRAY_SIZE(qpnp_pinbindings), sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(qpnp_pinbindings); i++) {
+		par = &qpnp_pinbindings[i];
+		ret = of_property_read_u32(np, par->property, &val);
+
+		/* property not found */
+		if (ret == -EINVAL)
+			continue;
+
+		/* use default value, when no value is specified */
+		if (ret)
+			val = par->default_value;
+
+		dev_info(dev, "found %s with value %u\n", par->property, val);
+		cfg[ncfg] = pinconf_to_config_packed(par->param, val);
+		ncfg++;
+	}
+
+	ret = 0;
+
+	/* no configs found at all */
+	if (ncfg == 0) {
+		*configs = NULL;
+		*nconfigs = 0;
+		goto out;
+	}
+
+	/*
+	 * Now limit the number of configs to the real number of
+	 * found properties.
+	 */
+	*configs = kcalloc(ncfg, sizeof(unsigned long), GFP_KERNEL);
+	if (!*configs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(*configs, cfg, ncfg * sizeof(unsigned long));
+	*nconfigs = ncfg;
+
+out:
+	kfree(cfg);
+	return ret;
+}
+
+static int qpnp_dt_subnode_to_map(struct pinctrl_dev *pctldev,
+				  struct device_node *np,
+				  struct pinctrl_map **map,
+				  unsigned *reserv, unsigned *nmaps,
+				  enum pinctrl_map_type type)
+{
+	unsigned long *configs = NULL;
+	unsigned num_configs = 0;
+	struct property *prop;
+	const char *group;
+	int ret;
+
+	ret = qpnp_parse_dt_config(pctldev->dev, np, &configs, &num_configs);
+	if (ret < 0)
+		return ret;
+
+	if (!num_configs)
+		return 0;
+
+	ret = of_property_count_strings(np, "pins");
+	if (ret < 0)
+		goto exit;
+
+	ret = pinctrl_utils_reserve_map(pctldev, map, reserv,
+					nmaps, ret);
+	if (ret < 0)
+		goto exit;
+
+	of_property_for_each_string(np, "pins", prop, group) {
+		ret = pinctrl_utils_add_map_configs(pctldev, map,
+				reserv, nmaps, group, configs,
+				num_configs, type);
+		if (ret < 0)
+			break;
+	}
+exit:
+	kfree(configs);
+	return ret;
+}
+
+static int qpnp_dt_node_to_map(struct pinctrl_dev *pctldev,
+			       struct device_node *np_config,
+			       struct pinctrl_map **map,
+			       unsigned *nmaps)
+{
+	struct device_node *np;
+	enum pinctrl_map_type type;
+	unsigned reserv;
+	int ret;
+
+	ret = 0;
+	*map = NULL;
+	*nmaps = 0;
+	reserv = 0;
+	type = PIN_MAP_TYPE_CONFIGS_PIN;
+
+	for_each_child_of_node(np_config, np) {
+
+		ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
+							&reserv, nmaps, type);
+		if (ret)
+			break;
+
+		ret = qpnp_dt_subnode_to_map(pctldev, np, map, &reserv,
+					     nmaps, type);
+		if (ret)
+			break;
+	}
+
+	if (ret < 0)
+		pinctrl_utils_dt_free_map(pctldev, *map, *nmaps);
+
+	return ret;
+}
+
+static const struct pinctrl_ops qpnp_pinctrl_ops = {
+	.get_groups_count	= qpnp_get_groups_cnt,
+	.get_group_name		= qpnp_get_group_name,
+	.get_group_pins		= qpnp_get_group_pins,
+	.dt_node_to_map		= qpnp_dt_node_to_map,
+	.dt_free_map		= pinctrl_utils_dt_free_map,
+};
+
+static int qpnp_get_functions_count(struct pinctrl_dev *pctldev)
+{
+	return ARRAY_SIZE(qpnp_functions_names);
+}
+
+static const char *qpnp_get_function_name(struct pinctrl_dev *pctldev,
+					 unsigned function)
+{
+	return qpnp_functions_names[function];
+}
+
+static int qpnp_get_function_groups(struct pinctrl_dev *pctldev,
+				  unsigned function,
+				  const char *const **groups,
+				  unsigned *const num_groups)
+{
+	struct qpnp_pinctrl *qctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = qctrl->groups[function].pins;
+	*num_groups = qctrl->groups[function].npins;
+	return 0;
+}
+
+static int qpnp_pinmux_enable(struct pinctrl_dev *pctldev,
+			     unsigned function,
+			     unsigned pin)
+{
+	struct qpnp_pinctrl *qctrl = pinctrl_dev_get_drvdata(pctldev);
+	const struct qpnp_padinfo *qpad;
+	struct qpnp_pindesc *qdesc;
+	unsigned int addr, val;
+	int idx;
+	u8 *buff;
+
+	qpad = &qctrl->info->pads[pin];
+
+	for (idx = 0; idx < ARRAY_SIZE(qpad->funcs); idx++)
+		if (qpad->funcs[idx] == function)
+			break;
+
+	if (WARN_ON(idx == ARRAY_SIZE(qpad->funcs)))
+		return -EINVAL;
+
+	qdesc = qpnp_get_desc(qctrl, pin);
+	if (!qdesc)
+		return -EINVAL;
+
+	switch (function) {
+	case QPNP_MUX_GPIO:
+		val = QPNP_PIN_MODE_DIG_IN_OUT;
+		break;
+	case QPNP_MUX_AIN:
+		val = QPNP_PIN_MODE_AIN;
+		break;
+	case QPNP_MUX_AOUT:
+		val = QPNP_PIN_MODE_AOUT;
+		break;
+	case QPNP_MUX_CS:
+		val = QPNP_PIN_MODE_SINK;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+
+	if (qdesc->type == QPNP_GPIO_TYPE &&
+	    val >= QPNP_PIN_MODE_GPIO_INVALID) {
+		return -EINVAL;
+	} else if (qdesc->type == QPNP_MPP_TYPE) {
+		if (val >= QPNP_PIN_MODE_MPP_INVALID)
+			return -EINVAL;
+		if ((qdesc->subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_ANA_OUT ||
+		     qdesc->subtype == QPNP_MPP_SUBTYPE_ULT_4CH_NO_SINK) &&
+		     (val == QPNP_PIN_MODE_BIDIR))
+			return -ENXIO;
+	}
+
+	addr = QPNP_REG_ADDR(qdesc, QPNP_REG_MODE_CTL);
+	buff = QPNP_REG_CACHE(qdesc, QPNP_REG_MODE_CTL);
+
+	QPNP_SET(buff, QPNP_REG_MODE_SEL_SHIFT, QPNP_REG_MODE_SEL_MASK, val);
+
+	addr = QPNP_REG_ADDR(qdesc, QPNP_REG_EN_CTL);
+	buff = QPNP_REG_CACHE(qdesc, QPNP_REG_EN_CTL);
+
+	QPNP_SET(buff, QPNP_REG_MASTER_EN_SHIFT, QPNP_REG_MASTER_EN_MASK, 1);
+
+	return qpnp_write_regs(qctrl, qdesc);
+}
+
+static const struct pinmux_ops qpnp_pinmux_ops = {
+	.get_functions_count	= qpnp_get_functions_count,
+	.get_function_name	= qpnp_get_function_name,
+	.get_function_groups	= qpnp_get_function_groups,
+	.enable			= qpnp_pinmux_enable,
+};
+
+static int qpnp_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
+	struct qpnp_pindesc *qdesc;
+	u8 val, en_mask, *buff;
+	unsigned int addr;
+	int ret;
+
+	qdesc = qpnp_get_desc(qctrl, offset);
+	if (!qdesc)
+		return -ENODEV;
+
+	buff = QPNP_REG_CACHE(qdesc, QPNP_REG_MODE_CTL);
+
+	/* GPIO val is from RT status if input is enabled */
+	if ((*buff & QPNP_REG_MODE_SEL_MASK) == QPNP_PIN_MODE_DIG_IN) {
+
+		addr = QPNP_REG_ADDR(qdesc, QPNP_REG_STATUS1);
+		ret = regmap_bulk_read(qctrl->map, addr, &val, 1);
+
+		if (qdesc->type == QPNP_GPIO_TYPE && qdesc->major == 0)
+			en_mask = QPNP_REG_STATUS1_GPIO_EN_REV0_MASK;
+		else if (qdesc->type == QPNP_GPIO_TYPE &&
+			 qdesc->major > 0)
+			en_mask = QPNP_REG_STATUS1_GPIO_EN_MASK;
+		else		/* MPP */
+			en_mask = QPNP_REG_STATUS1_MPP_EN_MASK;
+
+		if (!(val & en_mask))
+			return -EPERM;
+
+		ret = val & QPNP_REG_STATUS1_VAL_MASK;
+
+	} else {
+		ret = *buff & QPNP_REG_OUT_SRC_SEL_MASK;
+		ret =  ret >> QPNP_REG_OUT_SRC_SEL_SHIFT;
+	}
+
+	return ret;
+}
+
+static void qpnp_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
+	struct qpnp_pindesc *qdesc;
+	unsigned int addr;
+	u8 *buff;
+
+	qdesc = qpnp_get_desc(qctrl, offset);
+	if (!qdesc)
+		return;
+
+	addr = QPNP_REG_ADDR(qdesc, QPNP_REG_MODE_CTL);
+	buff = QPNP_REG_CACHE(qdesc, QPNP_REG_MODE_CTL);
+
+	QPNP_SET(buff, QPNP_REG_OUT_SRC_SEL_SHIFT,
+		 QPNP_REG_OUT_SRC_SEL_MASK, value);
+
+	regmap_write(qctrl->map, addr, *buff);
+}
+
+static int qpnp_config_get(struct pinctrl_dev *pctldev,
+			  unsigned int pin,
+			  unsigned long *config)
+{
+	struct qpnp_pinctrl *qctrl = pinctrl_dev_get_drvdata(pctldev);
+	struct qpnp_pindesc *qdesc = qpnp_get_desc(qctrl, pin);
+	unsigned param = pinconf_to_config_param(*config);
+	unsigned arg;
+	int ret;
+
+	/* Convert pinconf values to register values */
+	ret = qpnp_conv_from_pinattrib(qctrl, qdesc, param, &arg);
+	if (ret)
+		return ret;
+
+	/* Convert register value to pinconf value */
+	*config = pinconf_to_config_packed(param, arg);
+	return 0;
+}
+
+static int qpnp_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
+			  unsigned long *configs, unsigned num_configs)
+{
+	struct qpnp_pinctrl *qctrl = pinctrl_dev_get_drvdata(pctldev);
+	struct qpnp_pindesc *qdesc = qpnp_get_desc(qctrl, pin);
+	struct qpnp_pinattrib attr[4];
+	unsigned param;
+	unsigned arg;
+	int idx, ret, reg;
+	u8 *buff;
+
+	for (idx = 0; idx < num_configs; idx++) {
+		param = pinconf_to_config_param(configs[idx]);
+		arg = pinconf_to_config_argument(configs[idx]);
+
+		/* Convert pinconf values to register values */
+		ret = qpnp_conv_to_pinattrib(qdesc, param, arg, attr);
+		if (ret < 0)
+			return -EINVAL;
+
+		for (reg = 0; reg < ret; reg++) {
+			buff = QPNP_REG_CACHE(qdesc, attr[reg].addr);
+			QPNP_SET(buff, attr[reg].mask, attr[reg].shift,
+				 attr[reg].val);
+		}
+	}
+
+	return qpnp_write_regs(qctrl, qdesc);
+}
+
+static void qpnp_config_dbg_show(struct pinctrl_dev *pctldev,
+				 struct seq_file *s, unsigned pin)
+{
+	struct qpnp_pinctrl *qctrl = pinctrl_dev_get_drvdata(pctldev);
+	struct qpnp_pindesc *qdesc;
+	bool is_digital = true;
+	bool is_input = false;
+	const char *mode = NULL, *name = NULL;
+	unsigned en, val;
+	u8 *buff;
+	int ret;
+
+	qdesc = qpnp_get_desc(qctrl, pin);
+	if (!qdesc)
+		return;
+
+	name = qctrl->info->pads[pin].name;
+
+	ret = qpnp_read_regs(qctrl, qdesc);
+	if (ret) {
+		seq_printf(s, " %-8s: read error %d", name, ret);
+		return;
+	}
+
+	buff = QPNP_REG_CACHE(qdesc, QPNP_REG_MODE_CTL);
+	val = QPNP_GET(buff, QPNP_REG_MODE_SEL_SHIFT, QPNP_REG_MODE_SEL_MASK);
+
+	buff = QPNP_REG_CACHE(qdesc, QPNP_REG_EN_CTL);
+	en = QPNP_GET(buff, QPNP_REG_MASTER_EN_SHIFT, QPNP_REG_MASTER_EN_MASK);
+
+	switch (val) {
+	case QPNP_PIN_MODE_DIG_IN:
+		is_input = true;
+		mode = "dig-in";
+		break;
+	case QPNP_PIN_MODE_DIG_OUT:
+		mode = "dig-out";
+		break;
+	case QPNP_PIN_MODE_DIG_IN_OUT:
+		is_input = true;
+		mode = "dig-io";
+		break;
+	case QPNP_PIN_MODE_BIDIR:
+		is_digital = false;
+		mode = "ana-io";
+		break;
+	case QPNP_PIN_MODE_AIN:
+		is_input = true;
+		is_digital = false;
+		mode = "ana-in";
+		break;
+	case QPNP_PIN_MODE_AOUT:
+		is_digital = false;
+		mode = "ana-out";
+		break;
+	case QPNP_PIN_MODE_SINK:
+		is_digital = false;
+		mode = "ana-sink";
+		break;
+	default:
+		return;
+	}
+
+	seq_printf(s, " %-8s: %-9s %s", name, mode, !en ? "high-Z" : "");
+}
+
+static const struct pinconf_ops qpnp_pinconf_ops = {
+	.pin_config_get		= qpnp_config_get,
+	.pin_config_set		= qpnp_config_set,
+	.pin_config_group_get	= qpnp_config_get,
+	.pin_config_group_set	= qpnp_config_set,
+	.pin_config_group_dbg_show = qpnp_config_dbg_show,
+};
+
+static int qpnp_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
+	unsigned long config;
+
+	config = pinconf_to_config_packed(PIN_CONFIG_INPUT_ENABLE, 1);
+
+	return qpnp_config_set(qctrl->ctrl, offset, &config, 1);
+}
+
+static int qpnp_direction_output(struct gpio_chip *chip,
+			      unsigned offset, int val)
+{
+	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
+	unsigned long config;
+
+	config = pinconf_to_config_packed(PIN_CONFIG_OUTPUT, val);
+
+	return qpnp_config_set(qctrl->ctrl, offset, &config, 1);
+}
+
+static int qpnp_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void qpnp_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int qpnp_of_xlate(struct gpio_chip *chip,
+		       const struct of_phandle_args *gpio_desc, u32 *flags)
+{
+	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
+	struct qpnp_pindesc *qdesc;
+
+	if (chip->of_gpio_n_cells < 2) {
+		dev_err(qctrl->dev, "of_gpio_n_cells < 2\n");
+		return -EINVAL;
+	}
+
+	qdesc = qpnp_get_desc(qctrl, gpio_desc->args[0]);
+	if (!qdesc)
+		return -EINVAL;
+
+	if (flags)
+		*flags = gpio_desc->args[1];
+
+	return qdesc->index;
+}
+
+static void qpnp_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	struct qpnp_pinctrl *qctrl = to_qpnp_pinctrl(chip);
+	unsigned idx;
+
+	for (idx = 0; idx < chip->ngpio; idx++) {
+		qpnp_config_dbg_show(qctrl->ctrl, s, idx);
+		seq_puts(s, "\n");
+	}
+}
+
+static const struct gpio_chip qpnp_gpio_template = {
+	.direction_input  = qpnp_direction_input,
+	.direction_output = qpnp_direction_output,
+	.get              = qpnp_get,
+	.set              = qpnp_set,
+	.request          = qpnp_request,
+	.free             = qpnp_free,
+	.of_xlate	  = qpnp_of_xlate,
+	.dbg_show         = qpnp_dbg_show,
+};
+
+static int qpnp_discover(struct qpnp_pinctrl *qctrl,
+			const struct qpnp_pinctrl_info *data)
+{
+	struct device *dev = qctrl->dev;
+	struct qpnp_pindesc *qdesc;
+	struct qpnp_padinfo *qpad;
+	int idx, ret, cnt, gios, ais, aos, css;
+	const char **pins;
+
+	for (qdesc = qctrl->pins, idx = 0; idx < data->npads; idx++, qdesc++) {
+
+		qpad = &data->pads[idx];
+		qdesc->offset = qpad->base;
+		qdesc->index = idx;
+
+		/* Read up to including QPNP_REG_SUBTYPE */
+		ret = regmap_bulk_read(qctrl->map, QPNP_REG_ADDR(qdesc, 0),
+				       qdesc->cache, QPNP_REG_SUBTYPE + 1);
+		if (ret)
+			return ret;
+
+		qdesc->major   = qdesc->cache[QPNP_REG_DIG_MAJOR_REV];
+		qdesc->type = qdesc->cache[QPNP_REG_TYPE];
+		qdesc->subtype = qdesc->cache[QPNP_REG_SUBTYPE];
+
+		/* Assume PIN support all functions */
+		qpad->funcs[QPNP_MUX_GPIO] = QPNP_MUX_GPIO;
+		qpad->funcs[QPNP_MUX_AIN] = QPNP_MUX_AIN;
+		qpad->funcs[QPNP_MUX_AOUT] = QPNP_MUX_AOUT;
+		qpad->funcs[QPNP_MUX_CS] = QPNP_MUX_CS;
+
+		ret = qpnp_control_init(qctrl, qpad, qdesc);
+		if (ret)
+			return ret;
+	}
+
+	for (idx = QPNP_MUX_GPIO; idx < QPNP_MUX_CNT; idx++) {
+		cnt = qctrl->groups[idx].npins;
+		if (cnt) {
+			pins = devm_kzalloc(dev, cnt * sizeof(pins),
+					    GFP_KERNEL);
+			if (!pins)
+				return -ENOMEM;
+			qctrl->groups[idx].pins = pins;
+		}
+	}
+
+	gios = ais = aos = css = 0;
+	/* now scan through again and populate the lookup table */
+	for (qdesc = qctrl->pins, idx = 0; idx < data->npads; idx++, qdesc++) {
+		qpad = &data->pads[idx];
+		if (qpad->funcs[QPNP_MUX_GPIO] == QPNP_MUX_GPIO)
+			qctrl->groups[QPNP_MUX_GPIO].pins[gios++] = qpad->name;
+		if (qpad->funcs[QPNP_MUX_AIN] == QPNP_MUX_AIN)
+			qctrl->groups[QPNP_MUX_AIN].pins[ais++] = qpad->name;
+		if (qpad->funcs[QPNP_MUX_AOUT] == QPNP_MUX_AOUT)
+			qctrl->groups[QPNP_MUX_AOUT].pins[aos++] = qpad->name;
+		if (qpad->funcs[QPNP_MUX_CS] == QPNP_MUX_CS)
+			qctrl->groups[QPNP_MUX_CS].pins[css++] = qpad->name;
+	}
+
+	return 0;
+}
+
+int qpnp_pinctrl_probe(struct platform_device *pdev,
+		     const struct qpnp_pinctrl_info *data)
+{
+	struct device *dev = &pdev->dev;
+	struct qpnp_pinctrl *qctrl;
+	int ret;
+
+	qctrl = devm_kzalloc(dev, sizeof(*qctrl), GFP_KERNEL);
+	if (!qctrl)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, qctrl);
+
+	qctrl->dev = &pdev->dev;
+	qctrl->map = dev_get_regmap(dev->parent, NULL);
+	qctrl->info = data;
+
+	qctrl->chip = qpnp_gpio_template;
+	qctrl->chip.base = -1;
+	qctrl->chip.ngpio = data->npads;
+	qctrl->chip.label = dev_name(dev);
+	qctrl->chip.of_gpio_n_cells = 2;
+	qctrl->chip.can_sleep = 1;
+
+	qctrl->desc.pctlops = &qpnp_pinctrl_ops,
+	qctrl->desc.pmxops = &qpnp_pinmux_ops,
+	qctrl->desc.confops = &qpnp_pinconf_ops,
+	qctrl->desc.owner = THIS_MODULE,
+	qctrl->desc.name = dev_name(dev);
+	qctrl->desc.pins = data->desc;
+	qctrl->desc.npins = data->npads;
+
+	qctrl->range.name = dev_name(dev);
+	qctrl->range.id = 0;
+	qctrl->range.base = 0;
+	qctrl->range.npins = data->npads;
+	qctrl->range.gc = &qctrl->chip;
+
+	qctrl->pins = devm_kzalloc(dev, sizeof(*qctrl->pins) * data->npads,
+				   GFP_KERNEL);
+	if (!qctrl->pins)
+		return -ENOMEM;
+
+	ret = qpnp_discover(qctrl, data);
+	if (ret)
+		return ret;
+
+	ret = gpiochip_add(&qctrl->chip);
+	if (ret) {
+		dev_err(qctrl->dev, "can't add gpio chip\n");
+		return ret;
+	}
+
+	qctrl->ctrl = pinctrl_register(&qctrl->desc, dev, qctrl);
+	if (!qctrl->ctrl)
+		ret = -ENODEV;
+	else
+		pinctrl_add_gpio_range(qctrl->ctrl, &qctrl->range);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qpnp_pinctrl_probe);
+
+int qpnp_pinctrl_remove(struct platform_device *pdev)
+{
+	struct qpnp_pinctrl *qctrl = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(qctrl->ctrl);
+
+	return gpiochip_remove(&qctrl->chip);
+}
+EXPORT_SYMBOL_GPL(qpnp_pinctrl_remove);
diff --git a/drivers/pinctrl/pinctrl-qpnp.h b/drivers/pinctrl/pinctrl-qpnp.h
new file mode 100644
index 0000000..13ffc77
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-qpnp.h
@@ -0,0 +1,41 @@
+/* Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#ifndef __PINCTRL_QPNP_H__
+#define __PINCTRL_QPNP_H__
+
+struct platform_device;
+
+enum qpnp_functions {
+	QPNP_MUX_GPIO,
+	QPNP_MUX_AIN,
+	QPNP_MUX_AOUT,
+	QPNP_MUX_CS,
+	QPNP_MUX_CNT,
+};
+
+struct qpnp_padinfo {
+	unsigned base;
+	char name[8];
+	enum qpnp_functions funcs[QPNP_MUX_CNT];
+};
+
+struct qpnp_pinctrl_info {
+	unsigned npads;
+	struct qpnp_padinfo *pads;
+	struct pinctrl_pin_desc *desc;
+};
+
+int qpnp_pinctrl_probe(struct platform_device *pdev,
+		      const struct qpnp_pinctrl_info *data);
+int qpnp_pinctrl_remove(struct platform_device *pdev);
+
+#endif
diff --git a/include/dt-bindings/pinctrl/pinctrl-qpnp.h b/include/dt-bindings/pinctrl/pinctrl-qpnp.h
new file mode 100644
index 0000000..ae61ed6
--- /dev/null
+++ b/include/dt-bindings/pinctrl/pinctrl-qpnp.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This header provides constants for Qualcomm QPNP pinctrl bindings.
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
+#ifndef _DT_BINDINGS_PINCTRL_QPNP_H
+#define _DT_BINDINGS_PINCTRL_QPNP_H
+
+/*
+ * Voltage select (GPIO, MPP) - specifies the voltage level when the output
+ * is set to 1. For an input GPIO specifies the voltage level at which
+ * the input is interpreted as a logical 1
+ * To be used with "power-source = <>"
+ */
+#define QPNP_PIN_VIN0				0
+#define QPNP_PIN_VIN1				1
+#define QPNP_PIN_VIN2				2
+#define QPNP_PIN_VIN3				3
+#define QPNP_PIN_VIN4				4
+#define QPNP_PIN_VIN5				5
+#define QPNP_PIN_VIN6				6
+#define QPNP_PIN_VIN7				7
+
+/*
+ * Source Select (GPIO) / Enable Select (MPP) - select alternate function for
+ * the pin. Certain pins can be paired (shorted) with each other. Some pins
+ * can act as alternate functions. In the context of GPIO, this acts as a
+ * source select. For MPPs, this is an enable select.
+ * To be used with "output-high = <>"
+ */
+#define QPNP_PIN_SEL_FUNC_CONSTANT		0
+#define QPNP_PIN_SEL_FUNC_PAIRED		1
+#define QPNP_PIN_SEL_FUNC_1			2
+#define QPNP_PIN_SEL_FUNC_2			3
+#define QPNP_PIN_SEL_DTEST1			4
+#define QPNP_PIN_SEL_DTEST2			5
+#define QPNP_PIN_SEL_DTEST3			6
+#define QPNP_PIN_SEL_DTEST4			7
+
+/*
+ * Analog Output (MPP) - Set the analog output reference.
+ * To be used with "qcom,aout-ctrl = <>"
+ */
+#define QPNP_PIN_AOUT_1V25			0
+#define QPNP_PIN_AOUT_0V625			1
+#define QPNP_PIN_AOUT_0V3125			2
+#define QPNP_PIN_AOUT_MPP			3
+#define QPNP_PIN_AOUT_ABUS1			4
+#define QPNP_PIN_AOUT_ABUS2			5
+#define QPNP_PIN_AOUT_ABUS3			6
+#define QPNP_PIN_AOUT_ABUS4			7
+
+/*
+ * Analog Input (MPP) - Set the source for analog input. /
+ * To be used with "qcom,ain-ctrl = <>"
+ */
+#define QPNP_PIN_AIN_CH5			0
+#define QPNP_PIN_AIN_CH6			1
+#define QPNP_PIN_AIN_CH7			2
+#define QPNP_PIN_AIN_CH8			3
+#define QPNP_PIN_AIN_ABUS1			4
+#define QPNP_PIN_AIN_ABUS2			5
+#define QPNP_PIN_AIN_ABUS3			6
+#define QPNP_PIN_AIN_ABUS4			7
+
+#endif
-- 
1.8.3.2

