Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbaFJB2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:28:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48161 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933917AbaFJB20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:28:26 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <mturquette@linaro.org>,
        <chao.xie@marvell.com>, <xiechao_mail@163.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/12] clk: mmp: add device tree support for clocks.
Date: Tue, 10 Jun 2014 09:27:47 +0800
Message-ID: <1402363668-25806-12-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402363668-25806-1-git-send-email-chao.xie@marvell.com>
References: <1402363668-25806-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_01:2014-06-09,2014-06-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406100017
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

For MMP series SOC, it will use some types of clock.
Add the device tree support for these kind of clocks.
It includes mux/div/mix/gate/factor clock.

Signed-off-by: Chao Xie <chao.xie@marvell.com>

Conflicts:
	drivers/clk/mmp/Makefile
---
 .../devicetree/bindings/clock/mmp/clk-div          |  28 +
 .../devicetree/bindings/clock/mmp/clk-factor       |  28 +
 .../devicetree/bindings/clock/mmp/clk-gate         |  41 ++
 .../devicetree/bindings/clock/mmp/clk-mix          |  38 ++
 .../devicetree/bindings/clock/mmp/clk-mux          |  20 +
 drivers/clk/mmp/Makefile                           |   2 +-
 drivers/clk/mmp/clk-of.c                           | 689 +++++++++++++++++++++
 7 files changed, 845 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/clk-div
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/clk-factor
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/clk-gate
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/clk-mix
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/clk-mux
 create mode 100644 drivers/clk/mmp/clk-of.c

diff --git a/Documentation/devicetree/bindings/clock/mmp/clk-div b/Documentation/devicetree/bindings/clock/mmp/clk-div
new file mode 100644
index 0000000..62eb7d5
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/clk-div
@@ -0,0 +1,28 @@
+Binding for div type clock
+
+The div clock is defined as common clock.
+
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-div".
+- clocks : The parents of the clock.
+- marvell,mmp-clk-bits-div : The width and shift of divider bits.
+
+Optional properties:
+- marvell,mmp-clk-div-power-of-two : The value of divider is a power of two.
+- marvell,mmp-clk-div-one-based : The value of divider starts from 1.
+- marvell,mmp-clk-div-table : The value of divider is not continous, and need
+                              a table to record it.
+
+
+Examples
+apmu_clk {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xd4282800 0x1000>;
+	dsi_phy_slow_div: dsi_phy_slow_div {
+		compatible = "marvell,mmp-clk-div";
+		marvell,reg-offset = <0 0x44>;
+		clocks = <&vctcxo>;
+		marvell,mmp-clk-bits-div = <5 6>;
+	};
+};
diff --git a/Documentation/devicetree/bindings/clock/mmp/clk-factor b/Documentation/devicetree/bindings/clock/mmp/clk-factor
new file mode 100644
index 0000000..9e1816c
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/clk-factor
@@ -0,0 +1,28 @@
+Binding for Marvell MMP series factor clock
+
+The factor clock is calculated by
+  Fout = (Fin * (den / num)) / factor;
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-factor";
+- clock: The parent of the clock.
+- marvell,mmp-clk-factor-factor : The "factor" of the clock.
+- marvell,mmp-clk-factor-bits-num : The width and shift of bits for "num".
+- marvell,mmp-clk-factor-bits-den : The width and shift of bits for "dev".
+- marvell,mmp-clk-factor-table : The table of (num, den) for the clock.
+
+Examples
+mpmu_clocks: mpmu_clocks {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xd4050000 0x1000>;
+	uart_pll: uart_pll {
+		compatible = "marvell,mmp-clk-factor";
+		clocks = <&pll1_4>;
+		marvell,reg-offset = <0 0x14>;
+		marvell,mmp-clk-factor-factor = <2>;
+		marvell,mmp-clk-factor-bits-den = <13 0>;
+		marvell,mmp-clk-factor-bits-num = <13 16>;
+		marvell,mmp-clk-factor-table = <8125 1536>;
+	};
+};
++
diff --git a/Documentation/devicetree/bindings/clock/mmp/clk-gate b/Documentation/devicetree/bindings/clock/mmp/clk-gate
new file mode 100644
index 0000000..5da6c63
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/clk-gate
@@ -0,0 +1,41 @@
+Binding for Marvell MMP series gate clock and common gate clock
+
+There two type of gate clock used by Marvell MMP series SOC.
+The common gate clock and the gate clock defined for MMP series SOC.
+
+For common gate clock
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-general-gate";
+- clock : The parent of the clock.
+- marvell,mmp-clk-bit-gate : The offset of the bit control the gate.
+
+Examples
+apmu_clocks: apmu_clocks {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xd4282800 0x1000>;
+	pll1_416_gate: pll1_416_gate {
+		compatible = "marvell,mmp-clk-general-gate";
+		clocks = <&pll1_416m>;
+		marvell,reg-offset = <0 0x40>;
+		marvell,mmp-clk-bit-gate = <27>;
+	};
+};
+
+For MMP series gate clock
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-gate";
+- clock : The parent of the clock.
+- marvell,mmp-clk-mask : The (mask, val_enable, val_disable) for the clock.
+
+Examples
+apmu_clocks: apmu_clocks {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xd4282800 0x1000>;
+	usb_clock: usb_clock {
+		compatible = "marvell,mmp-clk-gate";
+		marvell,reg-offset = <0 0x5c>;
+		marvell,mmp-clk-mask = <0x9 0x9 0x1>;
+	};
+};
diff --git a/Documentation/devicetree/bindings/clock/mmp/clk-mix b/Documentation/devicetree/bindings/clock/mmp/clk-mix
new file mode 100644
index 0000000..8cf9b38
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/clk-mix
@@ -0,0 +1,38 @@
+Binding for Marvell MMP series mix clock
+
+The mix clock is a combination of mux and div clock. It need to
+change the bits of mux and div together.
+
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-mix".
+- clocks : The parents of the clock.
+- marvell,mmp-clk-bits-div : The width and shift of divider bits.
+- marvell,mmp-clk-bits-mux : The width and shift of divider bits.
+- marvell,mmp-clk-bit-fc : The offset of the frequency change bit.
+- marvell,mmp-clk-mix-table : The array of (rate, parent_index). The rate
+                              means the clock's rate, and parent_index means
+                              the suggested parent index from user.
+
+Optional properties:
+- marvell,mmp-clk-div-power-of-two : The value of divider is a power of two.
+- marvell,mmp-clk-div-one-based : The value of divider starts from 1.
+- marvell,mmp-clk-div-table : The value of divider is not continous, and need
+                              a table to record it.
+
+
+Exampels
+
+apmu_clk {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xd4282800 0x1000>;
+	lcd_clk {
+		compatible = "marvell,mmp-clk-mix";
+		clocks = <&pll1_416m &pll1_624 &pll2 &pll2p>;
+		marvell,reg-offset = <0 0x4c>;
+		marvell,mmp-clk-bits-mux = <2 17>;
+		marvell,mmp-clk-bits-div = <3 19>;
+		marvell,mmp-clk-bit-fc = <22>;
+	};
+};
+
diff --git a/Documentation/devicetree/bindings/clock/mmp/clk-mux b/Documentation/devicetree/bindings/clock/mmp/clk-mux
new file mode 100644
index 0000000..f5bb4dd
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/clk-mux
@@ -0,0 +1,20 @@
+Binding for mux type clock
+
+The mux clock is defined as common clock.
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-mux".
+- clocks : The parents of the clock.
+- marvell,mmp-clk-bits-mux : The width and shift of mux bits.
+
+Examples
+apmu_clk {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xd4282800 0x1000>;
+	dsi_phy_esc_mux: dsi_phy_esc_mux {
+		compatible = "marvell,mmp-clk-mux";
+		marvell,reg-offset = <0 0x44>;
+		clocks = <&pll1_12 &pll1_13 &vctcxo &pll1_8>;
+		marvell,mmp-clk-bits-mux = <2 0>;
+	};
+};
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 84dce78..e29c6f1 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -6,7 +6,7 @@ obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o	\
 	 clk-mix-composite.o
 
 ifneq ($(CONFIG_OF),)
-obj-y += clk-master-node.o lock.o clk-of-composite.o
+obj-y += clk-master-node.o lock.o clk-of-composite.o clk-of.o
 endif
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
diff --git a/drivers/clk/mmp/clk-of.c b/drivers/clk/mmp/clk-of.c
new file mode 100644
index 0000000..2bba7ee
--- /dev/null
+++ b/drivers/clk/mmp/clk-of.c
@@ -0,0 +1,689 @@
+/*
+ * mmp mix(div and mux) clock operation source file
+ *
+ * Copyright (C) 2014 Marvell
+ * Chao Xie <chao.xie@marvell.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/of.h>
+
+#include "clk.h"
+
+static int of_mmp_clk_get_flags(struct device_node *np,
+				unsigned long *flags)
+{
+	*flags = 0;
+
+	return 0;
+}
+
+static int of_mmp_clk_get_bits(struct device_node *np, const char *name,
+				u8 *width, u8 *shift)
+{
+	int ret;
+	u32 tmp[2];
+
+	ret = of_property_read_u32_array(np, name, tmp, 2);
+	if (ret) {
+		pr_err("%s:%s failed to read bits %s\n",
+			__func__, np->name, name);
+		return -EINVAL;
+	}
+
+	*width = tmp[0];
+	*shift = tmp[1];
+
+	return 0;
+}
+
+static int of_mmp_clk_div_dt_parse(struct device_node *np, u8 *shift,
+					u8 *width,
+					struct clk_div_table **ptable,
+					u8 *div_flags)
+{
+	int i, ret;
+	const __be32 *prop;
+	unsigned int proplen;
+	struct clk_div_table *table;
+	unsigned int size;
+
+	ret = of_mmp_clk_get_bits(np, "marvell,mmp-clk-bits-div",
+				width, shift);
+	if (ret)
+		return ret;
+
+	*div_flags = 0;
+	if (of_property_read_bool(np, "marvell,mmp-clk-div-power-of-two"))
+		*div_flags |= CLK_DIVIDER_POWER_OF_TWO;
+	else if (of_property_read_bool(np, "marvell,mmp-clk-div-one-based"))
+		*div_flags |= CLK_DIVIDER_ONE_BASED;
+
+	if (ptable)
+		*ptable = NULL;
+
+	prop = of_get_property(np, "marvell,mmp-clk-div-table", &proplen);
+	if (prop) {
+		if (!ptable)
+			return -EINVAL;
+
+		size = proplen / sizeof(u32);
+		if ((proplen % sizeof(u32)) || size % 2) {
+			pr_err("%s:%s marvell,mmp-clk-mix-table wrong value\n",
+				__func__, np->name);
+			return -EINVAL;
+		}
+		table = kzalloc(sizeof(*table) * (size / 2 + 1), GFP_KERNEL);
+		if (!table) {
+			pr_err("%s:%s failed to allocate table\n",
+				__func__, np->name);
+			return -EINVAL;
+		}
+
+		for (i = 0; i < size; i += 2) {
+			table[i / 2].val = be32_to_cpup(prop + i);
+			table[i / 2].div = be32_to_cpup(prop + i + 1);
+		}
+		/* For safe. */
+		table[i / 2].val = 0;
+		table[i / 2].div = 0;
+
+		*ptable = table;
+	}
+
+	return 0;
+}
+
+static int of_mmp_clk_mux_dt_parse(struct device_node *np, u8 *shift,
+					u8 *width, u8 *mux_flags)
+{
+	int ret;
+
+	ret = of_mmp_clk_get_bits(np, "marvell,mmp-clk-bits-mux",
+				width, shift);
+	if (ret)
+		return ret;
+
+	*mux_flags = 0;
+
+	return 0;
+}
+
+static int of_mmp_clk_general_gate_dt_parse(struct device_node *np,
+					u8 *bit_idx, u8 *gate_flags)
+{
+	int ret;
+	u32 tmp;
+
+	ret = of_property_read_u32(np, "marvell,mmp-clk-bit-gate", &tmp);
+	if (ret) {
+		pr_err("%s:%s can not find marvell,mmp-clk-bit-gate\n",
+			__func__, np->name);
+		return -EINVAL;
+	}
+	*bit_idx = tmp;
+
+	*gate_flags = 0;
+
+	return 0;
+}
+
+static int of_mmp_clk_gate_dt_parse(struct device_node *np,
+				u32 *mask, u32 *val_enable, u32 *val_disable,
+				unsigned int *gate_flags)
+{
+	int ret;
+	u32 tmp[3];
+
+	ret = of_property_read_u32_array(np, "marvell,mmp-clk-mask", tmp, 3);
+	if (ret) {
+		pr_err("%s:%s can not find marvell,mmp-clk-mask\n",
+			__func__, np->name);
+		return -EINVAL;
+	}
+	*mask = tmp[0];
+	*val_enable = tmp[1];
+	*val_disable = tmp[2];
+
+	*gate_flags = 0;
+	if (of_property_read_bool(np, "marvell,mmp-clk-gate-need-delay"))
+		*gate_flags |= MMP_CLK_GATE_NEED_DELAY;
+
+	return 0;
+}
+
+
+static int of_mmp_clk_mix_dt_parse(struct device_node *np,
+					struct mmp_clk_mix_config *config,
+					spinlock_t **plock)
+{
+	struct mmp_clk_mix_reg_info *ri;
+	struct mmp_clk_mix_clk_table *table;
+	int i, ret, size;
+	u32 tmp;
+	spinlock_t *lock;
+	void __iomem *reg;
+	unsigned int reg_phys;
+	const __be32 *prop;
+	unsigned int proplen;
+
+	ri = &config->reg_info;
+	ret = of_mmp_clk_div_dt_parse(np, &ri->shift_div, &ri->width_div,
+					NULL, &config->div_flags);
+	if (ret)
+		return ret;
+
+	ret = of_mmp_clk_mux_dt_parse(np, &ri->shift_mux, &ri->width_mux,
+					&config->mux_flags);
+	if (ret)
+		return ret;
+
+	ret = of_property_read_u32(np, "marvell,mmp-clk-bit-fc", &tmp);
+	if (ret)
+		ri->bit_fc = (u8)-1;
+	else
+		ri->bit_fc = tmp;
+
+	reg = of_mmp_clk_get_reg(np, 0, &reg_phys);
+	if (!reg)
+		return -EINVAL;
+	ri->reg_clk_ctrl = reg;
+
+	lock = of_mmp_clk_get_spinlock(np, reg_phys);
+	if (!lock)
+		return -EINVAL;
+
+	*plock = lock;
+	reg = of_mmp_clk_get_reg(np, 1, &reg_phys);
+	if (reg)
+		ri->reg_clk_sel = reg;
+
+	prop = of_get_property(np, "marvell,mmp-clk-mix-table", &proplen);
+	if (prop) {
+		size = proplen / sizeof(u32);
+		if ((proplen % sizeof(u32)) || size % 2) {
+			pr_err("%s:%s marvell,mmp-clk-mix-table wrong value\n",
+				__func__, np->name);
+			return -EINVAL;
+		}
+		table = kzalloc(sizeof(*table) * (size / 2), GFP_KERNEL);
+		if (!table) {
+			pr_err("%s:%s failed to allocate table\n",
+				__func__, np->name);
+			return -EINVAL;
+		}
+
+		for (i = 0; i < size; i += 2) {
+			table[i / 2].rate = be32_to_cpup(prop + i);
+			table[i / 2].parent_index = be32_to_cpup(prop + i + 1);
+		}
+		config->table = table;
+		config->table_size = size / 2;
+	} else {
+		config->table = NULL;
+		config->table_size = 0;
+	}
+
+	return 0;
+}
+
+static int of_mmp_clk_factor_dt_parse(struct device_node *np,
+					struct mmp_clk_factor_masks **pmasks,
+					struct mmp_clk_factor_tbl **pftbl,
+					unsigned int *pftbl_cnt)
+{
+	struct mmp_clk_factor_masks *masks;
+	struct mmp_clk_factor_tbl *table;
+	u8 width, shift;
+	int i, ret, size;
+	u32 tmp;
+	const __be32 *prop;
+	unsigned int proplen;
+
+	masks = kzalloc(sizeof(*masks), GFP_KERNEL);
+	if (!masks) {
+		pr_err("%s:%s failed to allocate factor masks\n",
+			__func__, np->name);
+		return -ENOMEM;
+	}
+
+	ret = of_property_read_u32(np, "marvell,mmp-clk-factor-factor", &tmp);
+	if (ret) {
+		pr_err("%s:%s can not find marvell,mmp-clk-factor-num\n",
+			__func__, np->name);
+		return -EINVAL;
+	}
+	masks->factor = tmp;
+
+	ret = of_mmp_clk_get_bits(np, "marvell,mmp-clk-factor-bits-num",
+				&width, &shift);
+	if (ret)
+		return ret;
+	masks->num_mask = BIT(width) - 1;
+	masks->num_shift = shift;
+
+	ret = of_mmp_clk_get_bits(np, "marvell,mmp-clk-factor-bits-den",
+				&width, &shift);
+	if (ret)
+		return ret;
+	masks->den_mask = BIT(width) - 1;
+	masks->den_shift = shift;
+	*pmasks = masks;
+
+	prop = of_get_property(np, "marvell,mmp-clk-factor-table", &proplen);
+	if (!prop) {
+		pr_err("%s:%s failed to get marvell,mmp-clk-factor-table\n",
+			__func__, np->name);
+		return -EINVAL;
+	}
+
+	size = proplen / sizeof(u32);
+	if ((proplen % sizeof(u32)) || size % 2) {
+		pr_err("%s:%s marvell,mmp-clk-factor-table wrong value\n",
+			__func__, np->name);
+		return -EINVAL;
+	}
+	table = kzalloc(sizeof(*table) * (size / 2), GFP_KERNEL);
+	if (!table) {
+		pr_err("%s:%s failed to allocate table\n",
+			__func__, np->name);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < size; i += 2) {
+		table[i / 2].num = be32_to_cpup(prop + i);
+		table[i / 2].den = be32_to_cpup(prop + i + 1);
+	}
+	*pftbl = table;
+	*pftbl_cnt = size / 2;
+
+	return 0;
+}
+
+static void of_mmp_clk_mix_setup(struct device_node *np)
+{
+	struct mmp_clk_mix *mix;
+	struct mmp_clk_mix_config config;
+	struct clk *clk;
+	spinlock_t *lock;
+	unsigned int num_parents;
+	const char **parent_names;
+	int i, ret;
+
+	ret = of_mmp_clk_mix_dt_parse(np, &config, &lock);
+	if (ret)
+		return;
+
+	if (of_mmp_clk_is_composite(np)) {
+		mix = kzalloc(sizeof(*mix), GFP_KERNEL);
+		if (!mix) {
+			pr_err("%s:%s failed to allocate clk\n",
+				__func__, np->name);
+			return;
+		}
+		memcpy(&mix->reg_info, &config.reg_info,
+			sizeof(config.reg_info));
+		mix->div_flags = config.div_flags;
+		mix->mux_flags = config.mux_flags;
+		mix->lock = lock;
+		if (config.table) {
+			mix->table = config.table;
+			mix->table_size = config.table_size;
+		}
+
+		of_mmp_clk_composite_add_member(np, &mix->hw, &mmp_clk_mix_ops,
+					MMP_CLK_COMPOSITE_TYPE_MUXMIX);
+	} else {
+		num_parents = of_clk_get_parent_count(np);
+		parent_names = kcalloc(num_parents, sizeof(char *),
+					GFP_KERNEL);
+		if (!parent_names) {
+			pr_err("%s:%s failed to allocate parent_names\n",
+				__func__, np->name);
+			return;
+		}
+		for (i = 0; i < num_parents; i++)
+			parent_names[i] = of_clk_get_parent_name(np, i);
+
+		clk = mmp_clk_register_mix(NULL, np->name, num_parents,
+					parent_names, 0, &config, lock);
+
+		if (IS_ERR(clk)) {
+			kfree(parent_names);
+
+			pr_err("%s:%s failed to register clk\n",
+				__func__, np->name);
+			return;
+		}
+
+		of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	}
+}
+CLK_OF_DECLARE(mmp_clk_mix, "marvell,mmp-clk-mix",
+		of_mmp_clk_mix_setup);
+
+static void of_mmp_clk_div_setup(struct device_node *np)
+{
+	struct clk_divider *div;
+	void __iomem *reg;
+	u8 width, shift, div_flags;
+	struct clk_div_table *table;
+	unsigned long flags;
+	const char *parent_name;
+	struct clk *clk;
+	unsigned int reg_phys;
+	spinlock_t *lock;
+	int ret;
+
+	reg = of_mmp_clk_get_reg(np, 0, &reg_phys);
+	if (!reg)
+		return;
+
+	ret = of_mmp_clk_div_dt_parse(np, &shift, &width, &table, &div_flags);
+	if (ret)
+		return;
+
+	ret = of_mmp_clk_get_flags(np, &flags);
+	if (ret)
+		return;
+
+	lock = of_mmp_clk_get_spinlock(np, reg_phys);
+	if (!lock)
+		return;
+
+	if (of_mmp_clk_is_composite(np)) {
+		div = kzalloc(sizeof(*div), GFP_KERNEL);
+		if (!div) {
+			pr_err("%s:%s failed to allocate clk\n",
+				__func__, np->name);
+			return;
+		}
+		div->shift = shift;
+		div->width = width;
+		div->table = table;
+		div->flags = div_flags;
+		div->lock = lock;
+		div->reg = reg;
+
+		of_mmp_clk_composite_add_member(np, &div->hw, &clk_divider_ops,
+					MMP_CLK_COMPOSITE_TYPE_DIV);
+	} else {
+		parent_name = of_clk_get_parent_name(np, 0);
+
+		if (!table)
+			clk = clk_register_divider(NULL, np->name, parent_name,
+					flags, reg, shift, width, div_flags,
+					lock);
+		else
+			clk = clk_register_divider_table(NULL, np->name,
+					parent_name, flags, reg, shift, width,
+					div_flags, table, lock);
+		if (IS_ERR(clk)) {
+			pr_err("%s:%s failed to register clk\n",
+				__func__, np->name);
+			return;
+		}
+
+		of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	}
+}
+CLK_OF_DECLARE(mmp_clk_div, "marvell,mmp-clk-div",
+		of_mmp_clk_div_setup);
+
+static void of_mmp_clk_mux_setup(struct device_node *np)
+{
+	struct clk_mux *mux;
+	void __iomem *reg;
+	u8 width, shift, mux_flags;
+	unsigned long flags;
+	spinlock_t *lock;
+	unsigned int num_parents;
+	const char **parent_names;
+	struct clk *clk;
+	unsigned int reg_phys;
+	int i, ret;
+
+	reg = of_mmp_clk_get_reg(np, 0, &reg_phys);
+	if (!reg)
+		return;
+
+	ret = of_mmp_clk_mux_dt_parse(np, &shift, &width, &mux_flags);
+	if (ret)
+		return;
+
+	ret = of_mmp_clk_get_flags(np, &flags);
+	if (ret)
+		return;
+
+	lock = of_mmp_clk_get_spinlock(np, reg_phys);
+	if (!lock)
+		return;
+
+	if (of_mmp_clk_is_composite(np)) {
+		mux = kzalloc(sizeof(*mux), GFP_KERNEL);
+		if (!mux) {
+			pr_err("%s:%s failed to allocate clk\n",
+				__func__, np->name);
+			return;
+		}
+
+		mux->reg = reg;
+		mux->mask = BIT(width) - 1;
+		mux->shift = shift;
+		mux->lock = lock;
+		mux->flags = mux_flags;
+		of_mmp_clk_composite_add_member(np, &mux->hw, &clk_mux_ops,
+					MMP_CLK_COMPOSITE_TYPE_MUXMIX);
+	} else {
+		num_parents = of_clk_get_parent_count(np);
+		parent_names = kcalloc(num_parents, sizeof(char *),
+					GFP_KERNEL);
+		if (!parent_names) {
+			pr_err("%s:%s failed to allocate parent_names\n",
+				__func__, np->name);
+			return;
+		}
+		for (i = 0; i < num_parents; i++)
+			parent_names[i] = of_clk_get_parent_name(np, i);
+
+		clk = clk_register_mux(NULL, np->name, parent_names,
+					num_parents, flags,
+					reg, shift, width, mux_flags, lock);
+		if (IS_ERR(clk)) {
+			pr_err("%s:%s failed to register clk\n",
+				__func__, np->name);
+			return;
+		}
+
+		of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	}
+}
+CLK_OF_DECLARE(mmp_clk_mux, "marvell,mmp-clk-mux",
+		of_mmp_clk_mux_setup);
+
+static void of_mmp_clk_general_gate_setup(struct device_node *np)
+{
+	struct clk_gate *gate;
+	void __iomem *reg;
+	u8 bit_idx, gate_flags;
+	unsigned long flags;
+	spinlock_t *lock;
+	const char *parent_name;
+	struct clk *clk;
+	unsigned int reg_phys;
+	int ret;
+
+	reg = of_mmp_clk_get_reg(np, 0, &reg_phys);
+	if (!reg)
+		return;
+
+	ret = of_mmp_clk_general_gate_dt_parse(np, &bit_idx, &gate_flags);
+	if (ret)
+		return;
+
+	ret = of_mmp_clk_get_flags(np, &flags);
+	if (ret)
+		return;
+
+	lock = of_mmp_clk_get_spinlock(np, reg_phys);
+	if (!lock)
+		return;
+
+	if (of_mmp_clk_is_composite(np)) {
+		gate = kzalloc(sizeof(*gate), GFP_KERNEL);
+		if (!gate) {
+			pr_err("%s:%s failed to allocate clk\n",
+				__func__, np->name);
+			return;
+		}
+		gate->bit_idx = bit_idx;
+		gate->flags = gate_flags;
+		gate->reg = reg;
+		gate->lock = lock;
+		of_mmp_clk_composite_add_member(np, &gate->hw, &clk_gate_ops,
+					MMP_CLK_COMPOSITE_TYPE_GATE);
+	} else {
+		parent_name = of_clk_get_parent_name(np, 0);
+
+		clk = clk_register_gate(NULL, np->name, parent_name, flags,
+					reg, bit_idx, gate_flags, lock);
+		if (IS_ERR(clk)) {
+			pr_err("%s:%s failed to register clk\n",
+				__func__, np->name);
+			return;
+		}
+
+		of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	}
+}
+CLK_OF_DECLARE(mmp_clk_general_gate, "marvell,mmp-clk-general-gate",
+		of_mmp_clk_general_gate_setup);
+
+static void of_mmp_clk_gate_setup(struct device_node *np)
+{
+	struct mmp_clk_gate *gate;
+	void __iomem *reg;
+	u32 mask, val_enable, val_disable;
+	unsigned int gate_flags;
+	unsigned long flags;
+	spinlock_t *lock;
+	const char *parent_name;
+	struct clk *clk;
+	unsigned int reg_phys;
+	int ret;
+
+	reg = of_mmp_clk_get_reg(np, 0, &reg_phys);
+	if (!reg)
+		return;
+
+	ret = of_mmp_clk_gate_dt_parse(np, &mask, &val_enable, &val_disable,
+					&gate_flags);
+	if (ret)
+		return;
+
+	ret = of_mmp_clk_get_flags(np, &flags);
+	if (ret)
+		return;
+
+	lock = of_mmp_clk_get_spinlock(np, reg_phys);
+	if (!lock)
+		return;
+
+	if (of_mmp_clk_is_composite(np)) {
+		gate = kzalloc(sizeof(*gate), GFP_KERNEL);
+		if (!gate) {
+			pr_err("%s:%s failed to allocate clk\n",
+				__func__, np->name);
+			return;
+		}
+
+		gate->flags = gate_flags;
+		gate->mask = mask;
+		gate->val_enable = val_enable;
+		gate->val_disable = val_disable;
+		gate->reg = reg;
+		gate->lock = lock;
+		of_mmp_clk_composite_add_member(np, &gate->hw,
+				&mmp_clk_gate_ops,
+				MMP_CLK_COMPOSITE_TYPE_GATE);
+	} else {
+		parent_name = of_clk_get_parent_name(np, 0);
+
+		clk = mmp_clk_register_gate(NULL, np->name, parent_name, flags,
+					reg, mask, val_enable, val_disable,
+					gate_flags, lock);
+		if (IS_ERR(clk)) {
+			pr_err("%s:%s failed to register clk\n",
+				__func__, np->name);
+			return;
+		}
+
+		of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	}
+}
+CLK_OF_DECLARE(mmp_clk_gate, "marvell,mmp-clk-gate",
+		of_mmp_clk_gate_setup);
+
+static void of_mmp_clk_factor_setup(struct device_node *np)
+{
+	void __iomem *reg;
+	struct mmp_clk_factor_masks *masks;
+	struct mmp_clk_factor_tbl *table;
+	unsigned int table_size;
+	unsigned long flags;
+	spinlock_t *lock;
+	const char *parent_name;
+	struct clk *clk;
+	unsigned int reg_phys;
+	int ret;
+
+	reg = of_mmp_clk_get_reg(np, 0, &reg_phys);
+	if (!reg)
+		return;
+
+	ret = of_mmp_clk_factor_dt_parse(np, &masks, &table, &table_size);
+	if (ret)
+		return;
+
+	ret = of_mmp_clk_get_flags(np, &flags);
+	if (ret)
+		return;
+
+	lock = of_mmp_clk_get_spinlock(np, reg_phys);
+	if (!lock)
+		return;
+
+	parent_name = of_clk_get_parent_name(np, 0);
+
+	clk = mmp_clk_register_factor(np->name, parent_name, flags,
+					reg, masks, table, table_size,
+					lock);
+	if (IS_ERR(clk)) {
+		pr_err("%s:%s failed to register clk\n", __func__, np->name);
+		return;
+	}
+
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+
+}
+CLK_OF_DECLARE(mmp_clk_factor,
+		"marvell,mmp-clk-factor",
+		of_mmp_clk_factor_setup);
+
+void mmp_clk_of_init(void)
+{
+	struct device_node *next;
+
+	next = NULL;
+	do {
+		next = of_mmp_clk_master_init(next);
+	} while (next);
+}
-- 
1.8.3.2

