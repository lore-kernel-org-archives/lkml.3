Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3F0VIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 17:08:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56230 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3F0VIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 17:08:38 -0400
From: Hanumant Singh <hanumant@codeaurora.org>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, Hanumant Singh <hanumant@codeaurora.org>
Subject: [PATCH v2] pinctrl: msm: Add support for MSM TLMM pinmux
Date: Thu, 27 Jun 2013 14:08:16 -0700
Message-Id: <1372367296-25197-1-git-send-email-hanumant@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <371851554-4492-1-git-send-email-hanumant@codeaurora.org>
References: <371851554-4492-1-git-send-email-hanumant@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new device tree enabled pinctrl driver for
Qualcomm MSM SoC's. This driver provides an extensible
framework to interface all MSM's that use a TLMM pinmux,
with the pinctrl subsytem.

This driver is split into two parts: the pinctrl interface
and the TLMM version specific implementation. The pinctrl
interface parses the device tree and registers with the pinctrl
subsytem. The TLMM version specific implementation supports
pin configuration/register programming for the different
pin types present on a given TLMM pinmux version.

Add support only for TLMM version 3 pinmux right now,
as well as, only two of the different pin types present on the
TLMM v3 pinmux.
Pintype 1: General purpose pins.
Pintype 2: SDC pins.

Signed-off-by: Hanumant Singh <hanumant@codeaurora.org>
---
 .../devicetree/bindings/pinctrl/msm-pinctrl.txt    | 171 +++++
 drivers/pinctrl/Kconfig                            |  10 +
 drivers/pinctrl/Makefile                           |   2 +
 drivers/pinctrl/pinctrl-msm-tlmm-v3.c              | 261 +++++++
 drivers/pinctrl/pinctrl-msm.c                      | 791 +++++++++++++++++++++
 drivers/pinctrl/pinctrl-msm.h                      | 112 +++
 6 files changed, 1347 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-msm-tlmm-v3.c
 create mode 100644 drivers/pinctrl/pinctrl-msm.c
 create mode 100644 drivers/pinctrl/pinctrl-msm.h

diff --git a/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
new file mode 100644
index 0000000..9b25794
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
@@ -0,0 +1,171 @@
+MSM TLMM pinmux controller
+
+Qualcomm MSM integrates a GPIO and Pin mux/config hardware, (TOP Level Mode
+Multiplexper in short TLMM). It controls the input/output settings on the
+available pads/pins and also provides ability to multiplex and configure the
+output of various on-chip controllers onto these pads. The pins are also of
+different types, encapsulating different functions and having differing register
+semantics.
+
+Required Properties:
+- compatible: should be one of the following.
+  - "qcom,msm-tlmm-v3": for MSM with TLMM version 3.
+
+- reg: Base address of the pin controller hardware module and length of
+  the address space it occupies.
+
+- Pin types as child nodes: Pin types supported by a particular controller
+  instance are represented as child nodes of the controller node. Each
+  pin type node must contain following properties:
+
+Required Properties
+  - qcom,pin-type: identifies the pin type.
+  - qcom,pin-cells: number of cells in the pin type specifier.
+  - qcom,num-pins: number of pins of given type present on the MSM.
+
+- Pin groups as child nodes: The pin mux (selecting pin function
+  mode) and pin config (pull up/down, driver strength, direction) settings are
+  represented as child nodes of the pin-controller node. There is no limit on
+  the count of these child nodes.
+
+  Required Properties
+    -qcom,pins: phandle specifying pin type and a pin number.
+
+  Optional Properties
+    -qcom,pin-func: function setting for the pin group.
+
+  The child node should contain a list of pin(s) on which a particular pin
+  function selection or pin configuration (or both) have to applied. This
+  list of pins is specified using the property name "qcom,pins". There
+  should be atleast one pin specfied for this property and there is no upper
+  limit on the count of pins that can be specified. The pins are specified
+  using the pintype phandle and the pin number within that pintype.
+
+  The pin function selection that should be applied on the pins listed in the
+  child node is specified using the "qcom,pin-func" property. The value
+  of this property that should be applied to each of the pins listed in the
+  "qcom,pins" property, should be picked from the hardware manual of the SoC.
+  This property is optional in the child node if no specific function
+  selection is desired for the pins listed in the child node or if the pin is
+  to be used for bit bang. The value of this property is used as-is to program
+  the pin-controller
+
+  The pin group node must additionally have a pin configuration node as its own
+  child node. There can be more then one such configuration node for a pin group
+  node. There can be one or more configurations within the configuration
+  node. These configurations are applied to all pins mentoned above using the
+  "qcom,pins" property. These configurations are specific to the pintype of the
+  pins. For the pin configuration properties supported by general purpose and
+  sdc pins lookup Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+  Of the above only, bias-disable,-pull-up,-pull-down, drive-strength and
+  output-high/low are supported.
+
+  The values specified by these config properties should be derived from the
+  hardware manual and these values are programmed as-is into the pin
+  configuration register for the corresponding pintype.
+
+  NOTE: A pin group node should be formed for all pins that are going to have
+  the same function and configuration settings. If a subset of pins to be used
+  by a client require different function or configuration settings or both
+  then they should be modelled as a separate pin group node to be used by
+  the client.
+
+  The client nodes that require a particular pin function selection and/or
+  pin configuration should use the bindings listed in the "pinctrl-bindings txt"
+  file.
+
+Example 1: A pin-controller node with pin types
+
+	pinctrl@fd5110000 {
+		compatible = "qcom,msm-tlmm-v3";
+		reg = <0x11400000 0x4000>;
+
+		/* General purpose pin type */
+		gp: gp {
+			qcom,pin-type = "gp";
+			qcom,num-pins = <117>;
+			#qcom,pin-cells = <1>;
+		};
+	};
+
+Example 2: Spi pin entries within the pincontroller node
+	pinctrl@fd511000 {
+		....
+		..
+		spi-bus {
+			/*
+			 * MOSI, MISO and CLK lines
+			 * all sharing same function and config
+			 * settings for each configuration node.
+			 */
+			qcom,pins = <&gp 0>, <&gp 1>, <&gp 3>;
+			qcom,pin-func = <1>;
+
+			/* Active configuration of bus pins */
+			spi-bus-active: spi-bus-active {
+				drive-strength = <3>; /* 8 MA */
+				bias-disable; /* No PULL */
+			};
+			/* Sleep configuration of bus pins */
+			spi-bus-sleep: spi-bus-sleep {
+				drive-strength = <0>; /* 2 MA */
+				bias-disable; /* No PULL */
+			};
+		};
+
+		spi-cs {
+			/*
+			 * Chip select for SPI
+			 * different config
+			 * settings as compared to bus pins.
+			 */
+			qcom,pins = <&Gp 2>;
+			qcom,num-grp-pins = <1>;
+			qcom,pin-func = <1>;
+
+			/* Active configuration of cs pin */
+			spi-cs-active: spi-cs-active {
+				drive-strength = <2>; /* 4 MA */
+				bias-disable; /* No PULL */
+			};
+			/* Sleep configuration of cs pin */
+			spi-bus-sleep: spi-bus-sleep {
+				drive-strength = <0>; /* 2 MA */
+				bias-disable = <0>; /* No PULL */
+			};
+		};
+	};
+
+Example 3: A SPI client node that supports 'active' and 'sleep' states.
+
+	spi_0: spi@f9923000 { /* BLSP1 QUP1 */
+			compatible = "qcom,spi-qup-v2";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg-names = "spi_physical", "spi_bam_physical";
+			reg = <0xf9923000 0x1000>,
+			<0xf9904000 0xF000>;
+			interrupt-names = "spi_irq", "spi_bam_irq";
+			interrupts = <0 95 0>, <0 238 0>;
+			spi-max-frequency = <19200000>;
+
+			/* pins used by spi controllers */
+			pinctrl-names = "default", "sleep";
+			pinctrl-0 = <&spi-bus-active &spi-cs-active>;
+			pinctrl-1 = <&spi-bus-sleep &spi-cs-sleep>;
+
+			qcom,infinite-mode = <0>;
+			qcom,use-bam;
+			qcom,ver-reg-exists;
+		qcom,bam-consumer-pipe-index = <12>;
+		qcom,bam-producer-pipe-index = <13>;
+		 };
+
+Example 4: Set up the default pin state for spi controller.
+
+	static inline int msm_spi_request_pins{struct msm_spi *dd)
+	{
+		/* ... */
+		state = pinctrl_lookup_state(dd->dev->pins->p, "sleep");
+		pinctrl_select_state(dd->dev->pins->p, state);
+	}
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 34f51d2..480cb26 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -133,6 +133,16 @@ config PINCTRL_IMX28
 	bool
 	select PINCTRL_MXS
 
+config PINCTRL_MSM
+	depends on OF
+	bool
+	select PINMUX
+	select GENERIC_PINCONF
+
+config PINCTRL_MSM_TLMM_V3
+	bool
+	select PINCTRL_MSM
+
 config PINCTRL_NOMADIK
 	bool "Nomadik pin controller driver"
 	depends on ARCH_U8500 || ARCH_NOMADIK
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index f82cc5b..3cf8fba 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -27,6 +27,8 @@ obj-$(CONFIG_PINCTRL_MMP2)	+= pinctrl-mmp2.o
 obj-$(CONFIG_PINCTRL_MXS)	+= pinctrl-mxs.o
 obj-$(CONFIG_PINCTRL_IMX23)	+= pinctrl-imx23.o
 obj-$(CONFIG_PINCTRL_IMX28)	+= pinctrl-imx28.o
+obj-$(CONFIG_PINCTRL_MSM)	+= pinctrl-msm.o
+obj-$(CONFIG_PINCTRL_MSM_TLMM_V3)	+= pinctrl-msm-tlmm-v3.o
 obj-$(CONFIG_PINCTRL_NOMADIK)	+= pinctrl-nomadik.o
 obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
 obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
diff --git a/drivers/pinctrl/pinctrl-msm-tlmm-v3.c b/drivers/pinctrl/pinctrl-msm-tlmm-v3.c
new file mode 100644
index 0000000..ad49ce9
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-msm-tlmm-v3.c
@@ -0,0 +1,261 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include "pinctrl-msm.h"
+
+/* GP PIN TYPE REG MASKS */
+#define TLMMV3_GP_DRV_SHFT		6
+#define TLMMV3_GP_DRV_MASK		0x7
+#define TLMMV3_GP_PULL_SHFT		0
+#define TLMMV3_GP_PULL_MASK		0x3
+#define TLMMV3_GP_DIR_SHFT		9
+#define TLMMV3_GP_DIR_MASK		1
+#define TLMMV3_GP_FUNC_SHFT		2
+#define TLMMV3_GP_FUNC_MASK		0xF
+/* SDC1 PIN TYPE REG MASKS */
+#define TLMMV3_SDC1_CLK_DRV_SHFT	6
+#define TLMMV3_SDC1_CLK_DRV_MASK	0x7
+#define TLMMV3_SDC1_DATA_DRV_SHFT	0
+#define TLMMV3_SDC1_DATA_DRV_MASK	0x7
+#define TLMMV3_SDC1_CMD_DRV_SHFT	3
+#define TLMMV3_SDC1_CMD_DRV_MASK	0x7
+#define TLMMV3_SDC1_CLK_PULL_SHFT	13
+#define TLMMV3_SDC1_CLK_PULL_MASK	0x3
+#define TLMMV3_SDC1_DATA_PULL_SHFT	9
+#define TLMMV3_SDC1_DATA_PULL_MASK	0x3
+#define TLMMV3_SDC1_CMD_PULL_SHFT	11
+#define TLMMV3_SDC1_CMD_PULL_MASK	0x3
+/* SDC2 PIN TYPE REG MASKS */
+#define TLMMV3_SDC2_CLK_DRV_SHFT	6
+#define TLMMV3_SDC2_CLK_DRV_MASK	0x7
+#define TLMMV3_SDC2_DATA_DRV_SHFT	0
+#define TLMMV3_SDC2_DATA_DRV_MASK	0x7
+#define TLMMV3_SDC2_CMD_DRV_SHFT	3
+#define TLMMV3_SDC2_CMD_DRV_MASK	0x7
+#define TLMMV3_SDC2_CLK_PULL_SHFT	14
+#define TLMMV3_SDC2_CLK_PULL_MASK	0x3
+#define TLMMV3_SDC2_DATA_PULL_SHFT	9
+#define TLMMV3_SDC2_DATA_PULL_MASK	0x3
+#define TLMMV3_SDC2_CMD_PULL_SHFT	11
+#define TLMMV3_SDC2_CMD_PULL_MASK	0x3
+
+#define TLMMV3_GP_INOUT_BIT		1
+#define TLMMV3_GP_OUT			BIT(TLMMV3_GP_INOUT_BIT)
+#define TLMMV3_GP_IN			0
+
+/* SDC Pin type register offsets */
+#define TLMMV3_SDC1_CFG(base)		(base + 0x2044)
+#define TLMMV3_SDC2_CFG(base)		(TLMMV3_SDC1_CFG(base) + 0x4)
+
+/* GP pin type register offsets */
+#define TLMMV3_GP_CFG(base, pin)	(base + 0x1000 + 0x10 * (pin))
+#define TLMMV3_GP_INOUT(base, pin)	(base + 0x1004 + 0x10 * (pin))
+
+struct msm_sdc_regs {
+	unsigned int offset;
+	unsigned long pull_mask;
+	unsigned long pull_shft;
+	unsigned long drv_mask;
+	unsigned long drv_shft;
+};
+
+static struct msm_sdc_regs sdc_regs[] = {
+	/* SDC1 CLK */
+	{
+		.offset = 0,
+		.pull_mask = TLMMV3_SDC1_CLK_PULL_MASK,
+		.pull_shft = TLMMV3_SDC1_CLK_PULL_SHFT,
+		.drv_mask = TLMMV3_SDC1_CLK_DRV_MASK,
+		.drv_shft = TLMMV3_SDC1_CLK_DRV_SHFT,
+	},
+	/* SDC1 CMD */
+	{
+		.offset = 0,
+		.pull_mask = TLMMV3_SDC1_CMD_PULL_MASK,
+		.pull_shft = TLMMV3_SDC1_CMD_PULL_SHFT,
+		.drv_mask = TLMMV3_SDC1_CMD_DRV_MASK,
+		.drv_shft = TLMMV3_SDC1_CMD_DRV_SHFT,
+	},
+	/* SDC1 DATA */
+	{
+		.offset = 0,
+		.pull_mask = TLMMV3_SDC1_DATA_PULL_MASK,
+		.pull_shft = TLMMV3_SDC1_DATA_PULL_SHFT,
+		.drv_mask = TLMMV3_SDC1_DATA_DRV_MASK,
+		.drv_shft = TLMMV3_SDC1_DATA_DRV_SHFT,
+	},
+	/* SDC2 CLK */
+	{
+		.offset = 0x4,
+		.pull_mask = TLMMV3_SDC2_CLK_PULL_MASK,
+		.pull_shft = TLMMV3_SDC2_CLK_PULL_SHFT,
+		.drv_mask = TLMMV3_SDC2_CLK_DRV_MASK,
+		.drv_shft = TLMMV3_SDC2_CLK_DRV_SHFT,
+	},
+	/* SDC2 CMD */
+	{
+		.offset = 0x4,
+		.pull_mask = TLMMV3_SDC2_CMD_PULL_MASK,
+		.pull_shft = TLMMV3_SDC2_CMD_PULL_SHFT,
+		.drv_mask = TLMMV3_SDC2_CMD_DRV_MASK,
+		.drv_shft = TLMMV3_SDC2_CMD_DRV_SHFT,
+	},
+	/* SDC2 DATA */
+	{
+		.offset = 0x4,
+		.pull_mask = TLMMV3_SDC2_DATA_PULL_MASK,
+		.pull_shft = TLMMV3_SDC2_DATA_PULL_SHFT,
+		.drv_mask = TLMMV3_SDC2_DATA_DRV_MASK,
+		.drv_shft = TLMMV3_SDC2_DATA_DRV_SHFT,
+	},
+};
+
+static int msm_tlmm_v3_sdc_cfg(uint pin_no, unsigned long *config,
+						void __iomem *reg_base,
+						bool write)
+{
+	unsigned int val, id, data;
+	u32 mask, shft;
+	void __iomem *cfg_reg;
+
+	cfg_reg = reg_base + sdc_regs[pin_no].offset;
+	id = pinconf_to_config_param(*config);
+	/* Get mask and shft values for this config type */
+	switch (id) {
+	case PIN_CONFIG_BIAS_DISABLE:
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+	case PIN_CONFIG_BIAS_PULL_UP:
+		mask = sdc_regs[pin_no].pull_mask;
+		shft = sdc_regs[pin_no].pull_shft;
+		break;
+	case PIN_CONFIG_DRIVE_STRENGTH:
+		mask = sdc_regs[pin_no].drv_mask;
+		shft = sdc_regs[pin_no].drv_shft;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	val = readl_relaxed(cfg_reg);
+	if (write) {
+		data = pinconf_to_config_argument(*config);
+		val &= ~(mask << shft);
+		val |= (data << shft);
+		writel_relaxed(val, cfg_reg);
+	} else {
+		val >>= shft;
+		val &= mask;
+		*config = pinconf_to_config_packed(id, val);
+	}
+	return 0;
+}
+
+static void msm_tlmm_v3_sdc_set_reg_base(void __iomem **ptype_base,
+							void __iomem *tlmm_base)
+{
+	*ptype_base = tlmm_base + 0x2044;
+}
+
+static int msm_tlmm_v3_gp_cfg(uint pin_no, unsigned long *config,
+						void *reg_base, bool write)
+{
+	unsigned int val, id, data;
+	u32 mask = 0, shft = 0;
+	void __iomem *inout_reg = NULL;
+	void __iomem *cfg_reg = TLMMV3_GP_CFG(reg_base, pin_no);
+
+	id = pinconf_to_config_param(*config);
+	/* Get mask and shft values for this config type */
+	switch (id) {
+	case PIN_CONFIG_BIAS_DISABLE:
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+	case PIN_CONFIG_BIAS_PULL_UP:
+		mask = TLMMV3_GP_PULL_MASK;
+		shft = TLMMV3_GP_PULL_SHFT;
+		break;
+	case PIN_CONFIG_DRIVE_STRENGTH:
+		mask = TLMMV3_GP_DRV_MASK;
+		shft = TLMMV3_GP_DRV_SHFT;
+		break;
+	case PIN_CONFIG_OUTPUT:
+		mask = TLMMV3_GP_DIR_MASK;
+		shft = TLMMV3_GP_DIR_SHFT;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	val = readl_relaxed(cfg_reg);
+	if (write) {
+		data = pinconf_to_config_argument(*config);
+		if (id == PIN_CONFIG_OUTPUT) {
+			if (data == TLMMV3_GP_OUT) {
+				inout_reg = TLMMV3_GP_INOUT(reg_base, pin_no);
+				writel_relaxed(TLMMV3_GP_OUT, inout_reg);
+			}
+			if (data > TLMMV3_GP_IN)
+				data = TLMMV3_GP_OUT;
+		}
+		val &= ~(mask << shft);
+		val |= (data << shft);
+		writel_relaxed(val, cfg_reg);
+	} else {
+		val >>= shft;
+		val &= mask;
+		*config = pinconf_to_config_packed(id, val);
+	}
+	return 0;
+}
+
+/* TODO: Make this return int after verifying func value is valid. */
+static void msm_tlmm_v3_gp_fn(uint pin_no, u32 func, void *reg_base,
+								bool enable)
+{
+	unsigned int val;
+	void __iomem *cfg_reg = TLMMV3_GP_CFG(reg_base, pin_no);
+	val = readl_relaxed(cfg_reg);
+	val &= ~(TLMMV3_GP_FUNC_MASK << TLMMV3_GP_FUNC_SHFT);
+	if (enable)
+		val |= (func << TLMMV3_GP_FUNC_SHFT);
+	writel_relaxed(val, cfg_reg);
+}
+
+static void msm_tlmm_v3_gp_set_reg_base(void __iomem **ptype_base,
+						void __iomem *tlmm_base)
+{
+	*ptype_base = tlmm_base;
+}
+
+static struct msm_pintype_info tlmm_v3_pininfo[] = {
+	{
+		.prg_cfg = msm_tlmm_v3_gp_cfg,
+		.prg_func = msm_tlmm_v3_gp_fn,
+		.set_reg_base = msm_tlmm_v3_gp_set_reg_base,
+		.reg_data = NULL,
+		.name = "gp",
+	},
+	{
+		.prg_cfg = msm_tlmm_v3_sdc_cfg,
+		.set_reg_base = msm_tlmm_v3_sdc_set_reg_base,
+		.reg_data = NULL,
+		.name = "sdc",
+	}
+};
+
+struct msm_tlmm tlmm_v3_pintypes = {
+	.num_entries = ARRAY_SIZE(tlmm_v3_pininfo),
+	.pintype_info = tlmm_v3_pininfo,
+};
+
diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
new file mode 100644
index 0000000..7c1f91a
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -0,0 +1,791 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/irqdomain.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include "core.h"
+#include "pinconf.h"
+#include "pinctrl-msm.h"
+
+/**
+ * struct msm_pinctrl_dd: represents the pinctrol driver data.
+ * @base: virtual base of TLMM.
+ * @irq: interrupt number for TLMM summary interrupt.
+ * @num_pins: Number of total pins present on TLMM.
+ * @msm_pindesc: list of descriptors for each pin.
+ * @num_pintypes: number of pintypes on TLMM.
+ * @msm_pintype: points to the representation of all pin types supported.
+ * @pctl: pin controller instance managed by the driver.
+ * @pctl_dev: pin controller descriptor registered with the pinctrl subsystem.
+ * @pin_grps: list of pin groups available to the driver.
+ * @num_grps: number of groups.
+ * @pmx_funcs:list of pin functions available to the driver
+ * @num_funcs: number of functions.
+ * @dev: pin contol device.
+ */
+struct msm_pinctrl_dd {
+	void __iomem *base;
+	int	irq;
+	unsigned int num_pins;
+	struct msm_pindesc *msm_pindesc;
+	unsigned int num_pintypes;
+	struct msm_pintype_info *msm_pintype;
+	struct pinctrl_desc pctl;
+	struct pinctrl_dev *pctl_dev;
+	struct msm_pin_grps *pin_grps;
+	unsigned int num_grps;
+	struct  msm_pmx_funcs *pmx_funcs;
+	unsigned int num_funcs;
+	struct device *dev;
+};
+
+static int msm_pmx_functions_count(struct pinctrl_dev *pctldev)
+{
+	struct msm_pinctrl_dd *dd;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	return dd->num_funcs;
+}
+
+/* return the name of the pin function specified */
+static const char *msm_pmux_get_fname(struct pinctrl_dev *pctldev,
+						unsigned selector)
+{
+	struct msm_pinctrl_dd *dd;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	return dd->pmx_funcs[selector].name;
+}
+
+/* return the groups associated for the specified function selector */
+static int msm_pmux_get_groups(struct pinctrl_dev *pctldev,
+		unsigned selector, const char * const **groups,
+		unsigned * const num_groups)
+{
+	struct msm_pinctrl_dd *dd;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	*groups = dd->pmx_funcs[selector].gps;
+	*num_groups = dd->pmx_funcs[selector].num_grps;
+	return 0;
+}
+
+/* enable or disable a pinmux function */
+static void msm_pmux_prg_fn(struct pinctrl_dev *pctldev, unsigned selector,
+					unsigned group, bool enable)
+{
+	struct msm_pinctrl_dd *dd;
+	const unsigned int *pins;
+	struct msm_pindesc *pindesc;
+	struct msm_pintype_info *pintype;
+	unsigned int pin, cnt, func;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	pins = dd->pin_grps[group].pins;
+	pindesc = dd->msm_pindesc;
+
+	/*
+	 * for each pin in the pin group selected, program the correspoding
+	 * pin function number in the config register.
+	 */
+	for (cnt = 0; cnt < dd->pin_grps[group].num_pins; cnt++) {
+		pin = pins[cnt];
+		/* Obtain the pin type for given pin */
+		pintype = pindesc[pin].pin_info;
+		/* Obtain the pin number within the pin type */
+		pin = pin - pintype->pin_start;
+		func = dd->pin_grps[group].func;
+		/* program the function value for the given pin type */
+		pintype->prg_func(pin, func, pintype->reg_data, enable);
+	}
+}
+
+/* enable a specified pinmux by writing to registers */
+static int msm_pmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
+					unsigned group)
+{
+	msm_pmux_prg_fn(pctldev, selector, group, true);
+	return 0;
+}
+
+/* disable a specified pinmux by writing to registers */
+static void msm_pmux_disable(struct pinctrl_dev *pctldev,
+					unsigned selector, unsigned group)
+{
+	msm_pmux_prg_fn(pctldev, selector, group, false);
+}
+
+static struct pinmux_ops msm_pmxops = {
+	.get_functions_count	= msm_pmx_functions_count,
+	.get_function_name	= msm_pmux_get_fname,
+	.get_function_groups	= msm_pmux_get_groups,
+	.enable			= msm_pmux_enable,
+	.disable		= msm_pmux_disable,
+};
+
+/* set or get the pin config settings for a specified pin */
+static int msm_pconf_prg(struct pinctrl_dev *pctldev, unsigned int pin,
+				unsigned long *config, bool rw)
+{
+	struct msm_pinctrl_dd *dd;
+	struct msm_pindesc *pindesc;
+	struct msm_pintype_info *pintype;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	pindesc = dd->msm_pindesc;
+	/* Get pin type for given pin */
+	pintype = pindesc[pin].pin_info;
+	/* Get pin offset from the pintype start pin number */
+	pin = pin - pintype->pin_start;
+	/* Program the config value for pin type */
+	return pintype->prg_cfg(pin, config, pintype->reg_data, rw);
+}
+
+/* set the pin config settings for a specified pin */
+static int msm_pconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
+				unsigned long config)
+{
+	return msm_pconf_prg(pctldev, pin, &config, true);
+}
+
+/* get the pin config settings for a specified pin */
+static int msm_pconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
+					unsigned long *config)
+{
+	return msm_pconf_prg(pctldev, pin, config, false);
+}
+
+/* set the pin config settings for a specified pin group */
+static int msm_pconf_group_set(struct pinctrl_dev *pctldev,
+			unsigned group, unsigned long config)
+{
+	struct msm_pinctrl_dd *dd;
+	const unsigned int *pins;
+	unsigned int cnt;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	pins = dd->pin_grps[group].pins;
+
+	for (cnt = 0; cnt < dd->pin_grps[group].num_pins; cnt++)
+		msm_pconf_set(pctldev, pins[cnt], config);
+
+	return 0;
+}
+
+/* get the pin config settings for a specified pin group */
+static int msm_pconf_group_get(struct pinctrl_dev *pctldev,
+				unsigned int group, unsigned long *config)
+{
+	struct msm_pinctrl_dd *dd;
+	const unsigned int *pins;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	pins = dd->pin_grps[group].pins;
+	msm_pconf_get(pctldev, pins[0], config);
+	return 0;
+}
+
+static struct pinconf_ops msm_pinconfops = {
+	.pin_config_get		= msm_pconf_get,
+	.pin_config_set		= msm_pconf_set,
+	.pin_config_group_get	= msm_pconf_group_get,
+	.pin_config_group_set	= msm_pconf_group_set,
+};
+
+/* check if the selector is a valid pin group selector */
+static int msm_get_grps_count(struct pinctrl_dev *pctldev)
+{
+	struct msm_pinctrl_dd *dd;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	return dd->num_grps;
+}
+
+/* return the name of the group selected by the group selector */
+static const char *msm_get_grps_name(struct pinctrl_dev *pctldev,
+						unsigned selector)
+{
+	struct msm_pinctrl_dd *dd;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	return dd->pin_grps[selector].name;
+}
+
+/* return the pin numbers associated with the specified group */
+static int msm_get_grps_pins(struct pinctrl_dev *pctldev,
+		unsigned selector, const unsigned **pins, unsigned *num_pins)
+{
+	struct msm_pinctrl_dd *dd;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	*pins = dd->pin_grps[selector].pins;
+	*num_pins = dd->pin_grps[selector].num_pins;
+	return 0;
+}
+
+static int msm_pinconf_parse_dt(struct device_node *cfg_np,
+				unsigned long **configs, unsigned int *cnt,
+				struct msm_pintype_info *pinfo)
+{
+	struct msm_tlmm_cfg_params const *cfg_params;
+	unsigned int num_cfg_params, idx = 0, cfg_cnt = 0;
+	unsigned long *cfg = NULL;
+	unsigned int val = 0;
+
+	cfg_params = pinfo->tlmm_cfg_param;
+	num_cfg_params = pinfo->num_cfg_params;
+
+	for (idx = 0; idx < num_cfg_params; idx++) {
+		if (!of_find_property(cfg_np, cfg_params[idx].name, NULL))
+			continue;
+		cfg_cnt++;
+	}
+	if (!cfg_cnt)
+		return -EINVAL;
+	/* Allocate memory to hold configs */
+	cfg = kzalloc(sizeof(*cfg) * cfg_cnt, GFP_KERNEL);
+	if (!cfg)
+		return -ENOMEM;
+	/* read cfg property values from cfg device tree node */
+	for (idx = 0, cfg_cnt = 0; idx < num_cfg_params; idx++) {
+		if (!of_find_property(cfg_np, cfg_params[idx].name, NULL))
+			continue;
+		of_property_read_u32(cfg_np, cfg_params[idx].name, &val);
+		cfg[cfg_cnt++] = pinfo->pack_cfg(val, &cfg_params[idx]);
+	}
+	*cnt = cfg_cnt;
+	*configs = cfg;
+	return 0;
+}
+
+static struct msm_pintype_info *msm_pgrp_to_pintype(struct device_node *nd,
+						struct msm_pinctrl_dd *dd)
+{
+	struct device_node *ptype_nd;
+	struct msm_pintype_info *pinfo = NULL;
+	int idx = 0;
+
+	/*Extract pin type node from parent node */
+	ptype_nd = of_parse_phandle(nd, "qcom,pins", 0);
+	/* find the pin type info for this pin type node */
+	for (idx = 0; idx < dd->num_pintypes; idx++) {
+		pinfo = &dd->msm_pintype[idx];
+		if (ptype_nd == pinfo->node) {
+			of_node_put(ptype_nd);
+			break;
+		}
+	}
+	return pinfo;
+}
+
+/* create pinctrl_map entries by parsing device tree nodes */
+static int msm_dt_node_to_map(struct pinctrl_dev *pctldev,
+			struct device_node *cfg_np, struct pinctrl_map **maps,
+			unsigned *nmaps)
+{
+	struct msm_pinctrl_dd *dd;
+	struct device_node *parent;
+	struct msm_pindesc *pindesc;
+	struct msm_pintype_info *pinfo;
+	struct pinctrl_map *map;
+	char *grp_name, *fn_name;
+	u32 val;
+	unsigned long *cfg;
+	int cfg_cnt = 0, map_cnt = 0, func_cnt = 0, ret = 0;
+
+	dd = pinctrl_dev_get_drvdata(pctldev);
+	pindesc = dd->msm_pindesc;
+	/* get parent node of config node */
+	parent = of_get_parent(cfg_np);
+	/*
+	 * parent node contains pin grouping
+	 * get pin type from pin grouping
+	 */
+	pinfo = msm_pgrp_to_pintype(parent, dd);
+	/* check if there is a function associated with the parent pin group */
+	if (of_find_property(parent, "qcom,pin-func", NULL))
+		func_cnt++;
+	/*
+	 * If no pin type specifc config parameters are specified
+	 * use general puropse pin config parsing
+	 */
+	if (!pinfo->tlmm_cfg_param)
+		ret = pinconf_generic_parse_dt_config(cfg_np, &cfg,
+								&cfg_cnt);
+
+	 else
+		ret = msm_pinconf_parse_dt(cfg_np, &cfg, &cfg_cnt, pinfo);
+
+	if (ret) {
+		dev_err(dd->dev, "generic properties incorrect\n");
+		return ret;
+	}
+
+	map_cnt = cfg_cnt + func_cnt;
+
+	/* Allocate memory for pin-map entries */
+	map = kzalloc(sizeof(*map) * map_cnt, GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+	*nmaps = 0;
+
+	grp_name = kzalloc(strlen(parent->name) + 1, GFP_KERNEL);
+	if (!grp_name) {
+		ret = -ENOMEM;
+		goto grp_err;
+	}
+	snprintf(grp_name, strlen(parent->name) + 1, "%s", parent->name);
+
+	/* create the config map entry */
+	map[*nmaps].data.configs.group_or_pin = grp_name;
+	map[*nmaps].data.configs.configs = cfg;
+	map[*nmaps].data.configs.num_configs = cfg_cnt;
+	map[*nmaps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+	*nmaps += 1;
+
+	/* If there is no function specified in device tree return */
+	if (func_cnt == 0) {
+		*maps = map;
+		goto no_func;
+	}
+	/* Get function mapping */
+	of_property_read_u32(parent, "qcom,pin-func", &val);
+	fn_name = kzalloc(strlen(grp_name) + strlen("-func"),
+						GFP_KERNEL);
+	if (!fn_name) {
+		ret = -ENOMEM;
+		goto func_err;
+	}
+	snprintf(fn_name, strlen(grp_name) + strlen("-func") + 1, "%s%s",
+						parent->name, "-func");
+	map[*nmaps].data.mux.group = grp_name;
+	map[*nmaps].data.mux.function = fn_name;
+	map[*nmaps].type = PIN_MAP_TYPE_MUX_GROUP;
+	*nmaps += 1;
+	*maps = map;
+	of_node_put(parent);
+	return 0;
+
+func_err:
+	kfree(grp_name);
+grp_err:
+	kfree(cfg);
+	kfree(map);
+no_func:
+	of_node_put(parent);
+	return ret;
+}
+
+/* free the memory allocated to hold the pin-map table */
+static void msm_dt_free_map(struct pinctrl_dev *pctldev,
+			     struct pinctrl_map *map, unsigned num_maps)
+{
+	int idx;
+
+	for (idx = 0; idx < num_maps; idx++) {
+		if (map[idx].type == PIN_MAP_TYPE_CONFIGS_GROUP) {
+			kfree(map[idx].data.configs.group_or_pin);
+			kfree(map[idx].data.configs.configs);
+		} else if (map->type == PIN_MAP_TYPE_MUX_GROUP)
+			kfree(map[idx].data.mux.function);
+	};
+
+	kfree(map);
+}
+
+static struct pinctrl_ops msm_pctrlops = {
+	.get_groups_count	= msm_get_grps_count,
+	.get_group_name		= msm_get_grps_name,
+	.get_group_pins		= msm_get_grps_pins,
+	.dt_node_to_map		= msm_dt_node_to_map,
+	.dt_free_map		= msm_dt_free_map,
+};
+
+static int msm_of_get_pin(struct device_node *np, int index,
+				struct msm_pinctrl_dd *dd, uint *pin)
+{
+	struct of_phandle_args pargs;
+	struct msm_pintype_info *pinfo;
+	int num_pintypes;
+	int ret, i;
+
+	ret = of_parse_phandle_with_args(np, "qcom,pins", "#qcom,pin-cells",
+								index, &pargs);
+	if (ret)
+		return ret;
+	pinfo = dd->msm_pintype;
+	num_pintypes = dd->num_pintypes;
+	for (i = 0; i < num_pintypes; i++)  {
+		/* Find the matching pin type node */
+		if (pargs.np != pinfo->node)
+			continue;
+		/* Check if arg specified is in valid range for pin type */
+		if (pargs.args[0] > pinfo->num_pins) {
+			ret = -EINVAL;
+			goto out;
+		}
+		/*
+		 * Pin number = index within pin type + start of pin numbers
+		 * for this pin type
+		 */
+		*pin = pargs.args[0] + pinfo->pin_start;
+	}
+out:
+	of_node_put(pargs.np);
+	return 0;
+}
+
+static int msm_pinctrl_dt_parse_pins(struct device_node *dev_node,
+						struct msm_pinctrl_dd *dd)
+{
+	struct device *dev;
+	struct device_node *pgrp_np;
+	struct msm_pin_grps *pin_grps, *curr_grp;
+	struct msm_pmx_funcs *pmx_funcs, *curr_func;
+	char *grp_name, *func_name;
+	int ret, i, grp_index = 0, func_index = 0;
+	uint pin = 0, *pins, num_grps = 0, num_pins = 0;
+	uint num_funcs = 0;
+	u32 func = 0;
+
+	dev = dd->dev;
+	for_each_child_of_node(dev_node, pgrp_np) {
+		if (!of_find_property(pgrp_np, "qcom,pins", NULL))
+			continue;
+		num_grps++;
+	}
+
+	for_each_child_of_node(dev_node, pgrp_np) {
+		if (!of_find_property(pgrp_np, "qcom,pin-func", NULL))
+			continue;
+		num_funcs++;
+	}
+
+	pin_grps = (struct msm_pin_grps *)devm_kzalloc(dd->dev,
+						sizeof(*pin_grps) * num_grps,
+						GFP_KERNEL);
+	if (!pin_grps) {
+		dev_err(dev, "Failed to allocate grp desc\n");
+		return -ENOMEM;
+	}
+	pmx_funcs = (struct msm_pmx_funcs *)devm_kzalloc(dd->dev,
+						sizeof(*pmx_funcs) * num_funcs,
+						GFP_KERNEL);
+	if (!pmx_funcs) {
+		dev_err(dev, "Failed to allocate grp desc\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Iterate over all child nodes, and for nodes containing pin lists
+	 * populate corresponding pin group, and if provided, corresponding
+	 * function
+	 */
+	for_each_child_of_node(dev_node, pgrp_np) {
+		if (!of_find_property(pgrp_np, "qcom,pins", NULL))
+			continue;
+		curr_grp = pin_grps + grp_index;
+		/* Node name is group name */
+		grp_name = devm_kzalloc(dev, strlen(pgrp_np->name) + 1,
+							GFP_KERNEL);
+		if (!grp_name) {
+			dev_err(dev, "Unable to allocate group name\n");
+			return -ENOMEM;
+		}
+		snprintf(grp_name, strlen(pgrp_np->name) + 1, "%s",
+							pgrp_np->name);
+
+		num_pins = of_count_phandle_with_args(pgrp_np,
+							"qcom,pins",
+							"qcom,pin-cells");
+		if (IS_ERR_VALUE(num_pins)) {
+			dev_err(dev, "pin count not specified for groups %s\n",
+								grp_name);
+			return ret;
+		}
+		pins = devm_kzalloc(dd->dev, sizeof(unsigned int) * num_pins,
+						GFP_KERNEL);
+		if (!pins) {
+			dev_err(dev, "Unable to allocte pins for %s\n",
+								grp_name);
+		}
+		for (i = 0; i < num_pins; i++) {
+			ret = msm_of_get_pin(pgrp_np, i, dd, &pin);
+			if (ret) {
+				dev_err(dev, "Pin grp %s does not have pins\n",
+								grp_name);
+				return ret;
+			}
+			pins[i] = pin;
+		}
+		curr_grp->pins = pins;
+		curr_grp->num_pins = num_pins;
+		curr_grp->name = grp_name;
+		grp_index++;
+		/* Check if func specified */
+		if (!of_find_property(pgrp_np, "qcom,pin-func", NULL))
+			continue;
+		curr_func = pmx_funcs + func_index;
+		func_name = devm_kzalloc(dev, strlen(grp_name) +
+							strlen("-func") + 1,
+							GFP_KERNEL);
+		if (!func_name) {
+			dev_err(dev, "Cannot allocate func name for grp %s",
+								grp_name);
+			return -ENOMEM;
+		}
+		snprintf(func_name, strlen(grp_name)+strlen("-func") + 1,
+					"%s%s", grp_name, "-func");
+		curr_func->name = func_name;
+		curr_func->gps = devm_kzalloc(dev, sizeof(char *), GFP_KERNEL);
+		if (!curr_func->gps) {
+			dev_err(dev, "failed to alloc memory for group list ");
+			return -ENOMEM;
+		}
+		of_property_read_u32(pgrp_np, "qcom,pin-func", &func);
+		curr_grp->func = func;
+		curr_func->gps[0] = grp_name;
+		curr_func->num_grps = 1;
+		func_index++;
+	}
+	dd->pin_grps = pin_grps;
+	dd->num_grps = num_grps;
+	dd->pmx_funcs = pmx_funcs;
+	dd->num_funcs = num_funcs;
+	return 0;
+}
+
+static void msm_populate_pindesc(struct msm_pintype_info *pinfo,
+					struct msm_pindesc *msm_pindesc)
+{
+	int i;
+	struct msm_pindesc *pindesc;
+
+	for (i = 0; i < pinfo->num_pins; i++) {
+		pindesc = &msm_pindesc[i + pinfo->pin_start];
+		pindesc->pin_info = pinfo;
+		snprintf(pindesc->name, sizeof(pindesc->name),
+					"%s-%d", pinfo->name, i);
+	}
+}
+
+static int msm_pinctrl_dt_parse_pintype(struct device_node *dev_node,
+						struct msm_pinctrl_dd *dd)
+{
+	struct device_node *pt_node;
+	struct msm_pindesc *msm_pindesc;
+	struct msm_pintype_info *pintype, *pinfo;
+	void __iomem **ptype_base;
+	u32 num_pins, pinfo_entries, curr_pins;
+	int i;
+	uint total_pins = 0;
+
+	for_each_child_of_node(dev_node, pt_node) {
+		if (!of_find_property(pt_node, "qcom,pin-type", NULL))
+			break;
+		else {
+			of_property_read_u32(pt_node, "qcom,num-pins",
+								&num_pins);
+			total_pins += num_pins;
+		}
+	}
+	dd->msm_pindesc = devm_kzalloc(dd->dev,
+						sizeof(struct msm_pindesc) *
+						total_pins, GFP_KERNEL);
+	if (!dd->msm_pindesc) {
+		dev_err(dd->dev, "Unable to allocate msm pindesc");
+		return -ENOMEM;
+	}
+	pinfo = dd->msm_pintype;
+	pinfo_entries = dd->num_pintypes;
+	dd->num_pins = total_pins;
+	msm_pindesc = dd->msm_pindesc;
+	curr_pins = 0;
+	/*
+	 * Populate pin descriptor based on each pin type present in Device
+	 * tree and supported by the driver
+	 */
+	for_each_child_of_node(dev_node, pt_node) {
+		if (!of_find_property(pt_node, "qcom,pin-type", NULL))
+			break;
+		else {
+			for (i = 0; i < pinfo_entries; i++) {
+				pintype = &pinfo[i];
+				if (!of_property_match_string(pt_node,
+							"qcom,pin-type",
+							pintype->name)) {
+					of_property_read_u32(pt_node,
+							"qcom,num-pins",
+							&num_pins);
+					pintype->num_pins = num_pins;
+					pintype->pin_start = curr_pins;
+					pintype->pin_end = curr_pins +
+								num_pins;
+					of_node_get(pt_node);
+					pintype->node = pt_node;
+					ptype_base = &pintype->reg_data;
+					pintype->set_reg_base(ptype_base,
+								dd->base);
+					msm_populate_pindesc(pintype,
+								msm_pindesc);
+					curr_pins += num_pins;
+				}
+
+			}
+		}
+	}
+	return 0;
+}
+
+static const struct of_device_id msm_pinctrl_dt_match[] = {
+	{ .compatible = "qcom,msm-tlmm-v3",
+		.data = &tlmm_v3_pintypes, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, msm_pinctrl_dt_match);
+
+static int msm_pinctrl_get_drvdata(struct msm_pinctrl_dd *dd,
+						struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	const struct msm_tlmm *tlmm_info;
+	int ret, i;
+	struct device_node *node = pdev->dev.of_node;
+
+	match = of_match_node(msm_pinctrl_dt_match, node);
+	if (IS_ERR(match))
+		return PTR_ERR(match);
+	tlmm_info = match->data;
+	dd->msm_pintype = tlmm_info->pintype_info;
+	dd->num_pintypes = tlmm_info->num_entries;
+	ret = msm_pinctrl_dt_parse_pintype(node, dd);
+	if (ret)
+		goto out;
+
+	ret = msm_pinctrl_dt_parse_pins(node, dd);
+	if (ret)
+		goto pin_err;
+
+pin_err:
+	for (i = 0; i < dd->num_pintypes; i++)
+		of_node_put(dd->msm_pintype[i].node);
+
+out:
+	return ret;
+}
+
+static int msm_register_pinctrl(struct msm_pinctrl_dd *dd)
+{
+	int i;
+	struct pinctrl_pin_desc *pindesc;
+	struct pinctrl_desc *ctrl_desc = &dd->pctl;
+
+	ctrl_desc->name = "msm-pinctrl";
+	ctrl_desc->owner = THIS_MODULE;
+	ctrl_desc->pmxops = &msm_pmxops;
+	ctrl_desc->confops = &msm_pinconfops;
+	ctrl_desc->pctlops = &msm_pctrlops;
+
+	pindesc = devm_kzalloc(dd->dev, sizeof(*pindesc) * dd->num_pins,
+							 GFP_KERNEL);
+	if (!pindesc) {
+		dev_err(dd->dev, "Failed to allocate pinctrl pin desc\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < dd->num_pins; i++) {
+		pindesc[i].number = i;
+		pindesc[i].name = dd->msm_pindesc[i].name;
+	}
+	ctrl_desc->pins = pindesc;
+	ctrl_desc->npins = dd->num_pins;
+	dd->pctl_dev = pinctrl_register(ctrl_desc, dd->dev, dd);
+	if (!dd->pctl_dev) {
+		dev_err(dd->dev, "could not register pinctrl driver\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void msm_pinctrl_cleanup_dd(struct msm_pinctrl_dd *dd)
+{
+	int i;
+	for (i = 0; i < dd->num_pintypes; i++)
+		of_node_put(dd->msm_pintype[i].node);
+}
+
+static int msm_pinctrl_probe(struct platform_device *pdev)
+{
+	struct msm_pinctrl_dd *dd;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int ret;
+
+	dd = devm_kzalloc(dev, sizeof(*dd), GFP_KERNEL);
+	if (!dd) {
+		dev_err(dev, "Alloction failed for driver data\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dd->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dd->base))
+		return PTR_ERR(dd->base);
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res)
+		dd->irq = res->start;
+	dd->dev = dev;
+	ret = msm_pinctrl_get_drvdata(dd, pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "driver data not available\n");
+		return -EINVAL;
+	}
+	ret = msm_register_pinctrl(dd);
+	if (ret) {
+		msm_pinctrl_cleanup_dd(dd);
+		return ret;
+	}
+	platform_set_drvdata(pdev, dd);
+	return 0;
+}
+
+static struct platform_driver msm_pinctrl_driver = {
+	.probe		= msm_pinctrl_probe,
+	.driver = {
+		.name	= "msm-pinctrl",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(msm_pinctrl_dt_match),
+	},
+};
+
+static int __init msm_pinctrl_drv_register(void)
+{
+	return platform_driver_register(&msm_pinctrl_driver);
+}
+postcore_initcall(msm_pinctrl_drv_register);
+
+static void __exit msm_pinctrl_drv_unregister(void)
+{
+	platform_driver_unregister(&msm_pinctrl_driver);
+}
+module_exit(msm_pinctrl_drv_unregister);
+
+MODULE_AUTHOR("Hanumant Singh <hanumant@codeaurora.org>");
+MODULE_LICENSE("GPLv2");
+
diff --git a/drivers/pinctrl/pinctrl-msm.h b/drivers/pinctrl/pinctrl-msm.h
new file mode 100644
index 0000000..7903a8e
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-msm.h
@@ -0,0 +1,112 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#ifndef __PINCTRL_MSM_H__
+#define __PINCTRL_MSM_H__
+
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/machine.h>
+
+/**
+ * struct msm_pin_group: group of pins having the same pinmux function.
+ * @name: name of the pin group.
+ * @pins: the pins included in this group.
+ * @num_pins: number of pins included in this group.
+ * @func: the function number to be programmed when selected.
+ */
+struct msm_pin_grps {
+	const char *name;
+	unsigned int *pins;
+	unsigned num_pins;
+	u32 func;
+};
+
+/**
+ * struct msm_pmx_funcs: represent a pin function.
+ * @name: name of the pin function.
+ * @gps: one or more names of pin groups that provide this function.
+ * @num_grps: number of groups included in @groups.
+ */
+struct msm_pmx_funcs {
+	const char *name;
+	const char **gps;
+	unsigned num_grps;
+};
+
+/**
+ * struct msm_tlmm_cfgs: represent config properties of a pin type.
+ * @name: name of config.
+ * @id: id of the config.
+ */
+
+struct msm_tlmm_cfg_params {
+	const char *name;
+	unsigned int id;
+};
+
+/**
+ * struct msm_pintype_info: represent a pin type supported by the TLMM.
+ * @prg_cfg: helper to program a given config for a pintype.
+ * @prg_func: helper to program a given func for a pintype.
+ * @pack_cfg: helper to pack a parsed config as per a pintype.
+ * @set_reg_base: helper to set the register base address for a pintype.
+ * @reg_data: register base for a pintype.
+ * @tlmm_cfg_param: config parameters for pins of a given pintype.
+ * @name: name of pintype.
+ * @num_pins: number of pins of given pintype.
+ * @pin_start: starting pin number for the given pintype within pinctroller.
+ * @pin_end: ending pin number for the given pintype within pinctroller.
+ * @node: device node for the pintype.
+ */
+struct msm_pintype_info {
+	int (*prg_cfg)(uint pin_no, unsigned long *config, void *reg_data,
+								bool rw);
+	void (*prg_func)(uint pin_no, u32 func, void *reg_data, bool enable);
+	unsigned long (*pack_cfg)(u32 val,
+				struct msm_tlmm_cfg_params const *param);
+	void (*set_reg_base)(void __iomem **ptype_base,
+						void __iomem *tlmm_base);
+	void __iomem *reg_data;
+	struct msm_tlmm_cfg_params const *tlmm_cfg_param;
+	u32 num_cfg_params;
+	const char *name;
+	u32 num_pins;
+	int pin_start;
+	int pin_end;
+	struct device_node *node;
+};
+
+/**
+ * struct msm_tlmm: represents all the TLMM pintypes for a given TLMM version.
+ * @num_entries: number of pintypes.
+ * @pintype_info: descriptor for the pintypes. One for each present.
+ */
+struct msm_tlmm {
+	const uint num_entries;
+	struct msm_pintype_info *pintype_info;
+};
+
+/**
+ * struct msm_pindesc: descriptor for all pins maintained by pinctrl driver
+ * @pin_info: pintype for a given pin.
+ * @name: name of the pin.
+ */
+struct msm_pindesc {
+	struct msm_pintype_info *pin_info;
+	char name[20];
+};
+
+/* TLMM version specific data */
+extern struct msm_tlmm tlmm_v3_pintypes;
+#endif
+
-- 
1.8.2.1

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, hosted by The Linux Foundation
-- 
