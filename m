Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab3FMBvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:51:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41161 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3FMBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:49:16 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC/PATCH 06/13] clk: msm: Add support for root clock generators (RCGs)
Date: Wed, 12 Jun 2013 18:49:02 -0700
Message-Id: <1371088149-22562-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
References: <1371088149-22562-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/devicetree/bindings/clock/msm.txt |  31 +
 drivers/clk/msm/Makefile                        |   2 +
 drivers/clk/msm/clk-rcg.c                       | 754 ++++++++++++++++++++++++
 drivers/clk/msm/clk-rcg.h                       | 114 ++++
 drivers/clk/msm/clk-rcg2.c                      | 320 ++++++++++
 5 files changed, 1221 insertions(+)
 create mode 100644 drivers/clk/msm/clk-rcg.c
 create mode 100644 drivers/clk/msm/clk-rcg.h
 create mode 100644 drivers/clk/msm/clk-rcg2.c

diff --git a/Documentation/devicetree/bindings/clock/msm.txt b/Documentation/devicetree/bindings/clock/msm.txt
index 2192621..f4595fa 100644
--- a/Documentation/devicetree/bindings/clock/msm.txt
+++ b/Documentation/devicetree/bindings/clock/msm.txt
@@ -38,3 +38,34 @@ Example:
 		clocks = <&pll8>;
 	};
 
+M/N:D Binding
+-------------
+
+Required properties:
+- compatible : shall be one of "qcom,p2-mn16-clock" or "qcom,p2-mn8-clock"
+- #clock-cells : from common clock binding; shall be set to 0
+- clocks : from common clock binding; shall be set of muxed input sources
+
+Example:
+	gsbi5_uart_rcg: gsbi5_uart_rcg {
+		#clock-cells = <0>;
+		compatible = "qcom,p2-mn16-clock";
+		clocks = <&pxo>, <&pll8>;
+	};
+
+M/N:D Dynamic Binding
+---------------------
+
+Required properties:
+- compatible : shall be one of "qcom,mn4-dyn-clock", "qcom,mn8-dyn-clock" or
+	       "qcom,p4-dyn-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : from common clock binding; shall be set of muxed input sources
+
+Example:
+	gfx2d_rcg : gfx2d_rcg {
+		#clock-cells = <0>;
+		compatible = "qcom,mn4-dyn-clock";
+		clocks = <&pxo>, <&pll2>, <&pll8>;
+	};
+
diff --git a/drivers/clk/msm/Makefile b/drivers/clk/msm/Makefile
index 16b750f..fb78ac9 100644
--- a/drivers/clk/msm/Makefile
+++ b/drivers/clk/msm/Makefile
@@ -1,3 +1,5 @@
 obj-$(CONFIG_COMMON_CLK_MSM) += clk-msm.o
 
 clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-pll.o
+clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg.o
+clk-msm-$(CONFIG_COMMON_CLK_MSM) += clk-rcg2.o
diff --git a/drivers/clk/msm/clk-rcg.c b/drivers/clk/msm/clk-rcg.c
new file mode 100644
index 0000000..3400fee
--- /dev/null
+++ b/drivers/clk/msm/clk-rcg.c
@@ -0,0 +1,754 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+
+#include <asm/div64.h>
+
+#include "clk-rcg.h"
+
+/**
+ * struct mn - M/N:D counter
+ * @mnctr_en_bit: bit to enable mn counter
+ * @mnctr_reset_bit: bit to assert mn counter reset
+ * @mnctr_mode_shift: lowest bit of mn counter mode field
+ * @n_val_shift: lowest bit of n value field
+ * @m_val_shift: lowest bit of m value field
+ * @width: number of bits in m/n/d values
+ */
+struct mn {
+	u8		mnctr_en_bit;
+	u8		mnctr_reset_bit;
+	u8		mnctr_mode_shift;
+#define MNCTR_MODE_DUAL 0x2
+#define MNCTR_MODE_MASK 0x3
+	u8		n_val_shift;
+	u8		m_val_shift;
+	u8		width;
+};
+
+/**
+ * struct pre_div - pre-divider
+ * @pre_div_shift: lowest bit of pre divider field
+ * @pre_div_width: number of bits in predivider
+ */
+struct pre_div {
+	u8		pre_div_shift;
+	u8		pre_div_width;
+};
+
+/**
+ * struct src_sel - source selector
+ * @src_sel_shift: lowest bit of source selection field
+ * @parent_map: map from software's parent index to hardware's src_sel field
+ */
+struct src_sel {
+	u8		src_sel_shift;
+#define SRC_SEL_MASK	0x7
+	u8		*parent_map;
+};
+
+/**
+ * struct clk_rcg - root clock generator
+ *
+ * @ctl_reg: clock control register
+ * @ctl_bit: ORed with @ctl_reg to enable the clock
+ * @ns_reg: NS register
+ * @md_reg: MD register
+ * @mn: mn counter
+ * @p: pre divider
+ * @s: source selector
+ * @freq_tbl: Frequency table
+ * @hw: handle between common and hardware-specific interfaces
+ * @lock: register lock
+ *
+ */
+struct clk_rcg {
+	void __iomem	*ctl_reg;
+	void __iomem	*ns_reg;
+	void __iomem	*md_reg;
+
+	u8		ctl_bit;
+	struct mn	mn;
+	struct pre_div	p;
+	struct src_sel	s;
+
+	const struct freq_tbl	*freq_tbl;
+
+	struct clk_hw	hw;
+	spinlock_t	*lock;
+};
+
+#define to_clk_rcg(_hw) container_of(_hw, struct clk_rcg, hw)
+
+/**
+ * struct clk_dyn_rcg - root clock generator with glitch free mux
+ *
+ * @ctl_reg: clock control register
+ * @ctl_bit: ORed with @ctl_reg to enable the clock
+ * @mux_sel_bit: Bit to switch glitch free mux
+ * @ns_reg: NS register
+ * @md_reg: MD0 and MD1 register
+ * @mn: mn counter (banked)
+ * @s: source selector (banked)
+ * @freq_tbl: Frequency table
+ * @hw: handle between common and hardware-specific interfaces
+ * @lock: register lock
+ *
+ */
+struct clk_dyn_rcg {
+	void __iomem	*ctl_reg;
+	void __iomem	*ns_reg;
+	void __iomem	*md_reg[2];
+
+	u8		ctl_bit;
+	u8		mux_sel_bit;
+	struct mn	mn[2];
+	struct pre_div	p[2];
+	struct src_sel	s[2];
+
+	const struct freq_tbl	*freq_tbl;
+
+	struct clk_hw	hw;
+	spinlock_t	*lock;
+};
+
+#define to_clk_dyn_rcg(_hw) container_of(_hw, struct clk_dyn_rcg, hw)
+
+static int clk_rcg_toggle(void __iomem *ctl_reg, u8 ctl_bit,
+		spinlock_t *lock, bool en)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(lock, flags);
+
+	val = readl_relaxed(ctl_reg);
+	if (en)
+		val |= BIT(ctl_bit);
+	else
+		val &= ~BIT(ctl_bit);
+	writel(val, ctl_reg);
+
+	spin_unlock_irqrestore(lock, flags);
+
+	return 0;
+}
+
+static int clk_rcg_enable(struct clk_hw *hw)
+{
+	struct clk_rcg *rcg = to_clk_rcg(hw);
+
+	return clk_rcg_toggle(rcg->ctl_reg, rcg->ctl_bit, rcg->lock, true);
+}
+
+static void clk_rcg_disable(struct clk_hw *hw)
+{
+	struct clk_rcg *rcg = to_clk_rcg(hw);
+
+	clk_rcg_toggle(rcg->ctl_reg, rcg->ctl_bit, rcg->lock, false);
+}
+
+static int clk_dyn_rcg_enable(struct clk_hw *hw)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+
+	return clk_rcg_toggle(rcg->ctl_reg, rcg->ctl_bit, rcg->lock, true);
+}
+
+static void clk_dyn_rcg_disable(struct clk_hw *hw)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+
+	clk_rcg_toggle(rcg->ctl_reg, rcg->ctl_bit, rcg->lock, false);
+}
+
+static int clk_dyn_rcg_is_enabled(struct clk_hw *hw)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+	u32 val;
+
+	val = readl_relaxed(rcg->ctl_reg);
+	val &= BIT(rcg->ctl_bit);
+
+	return val ? 1 : 0;
+}
+
+static u32 ns_to_src(struct src_sel *s, u32 ns)
+{
+	ns >>= s->src_sel_shift;
+	ns &= SRC_SEL_MASK;
+	return ns;
+}
+
+static u32 src_to_ns(struct src_sel *s, u8 src, u32 ns)
+{
+	u32 mask;
+
+	mask = SRC_SEL_MASK;
+	mask <<= s->src_sel_shift;
+	ns &= ~mask;
+
+	ns |= src << s->src_sel_shift;
+	return ns;
+}
+
+static u8 clk_rcg_get_parent(struct clk_hw *hw)
+{
+	struct clk_rcg *rcg = to_clk_rcg(hw);
+	int num_parents = __clk_get_num_parents(hw->clk);
+	u32 ns;
+	int i;
+
+	ns = readl_relaxed(rcg->ns_reg);
+	ns = ns_to_src(&rcg->s, ns);
+
+	for (i = 0; i < num_parents; i++)
+		if (ns == rcg->s.parent_map[i])
+			return i;
+
+	return -EINVAL;
+}
+
+static int reg_to_bank(struct clk_dyn_rcg *rcg, u32 bank)
+{
+	bank &= BIT(rcg->mux_sel_bit);
+	return !!bank;
+}
+
+static u8 clk_dyn_rcg_get_parent(struct clk_hw *hw)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+	int num_parents = __clk_get_num_parents(hw->clk);
+	u32 ns, ctl;
+	int bank;
+	int i;
+	struct src_sel *s;
+
+	ctl = readl_relaxed(rcg->ctl_reg);
+	bank = reg_to_bank(rcg, ctl);
+	s = &rcg->s[bank];
+
+	ns = readl_relaxed(rcg->ns_reg);
+	ns = ns_to_src(s, ns);
+
+	for (i = 0; i < num_parents; i++)
+		if (ns == s->parent_map[i])
+			return i;
+
+	return -EINVAL;
+}
+
+static int clk_rcg_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_rcg *rcg = to_clk_rcg(hw);
+	unsigned long flags;
+	u32 ns;
+
+	spin_lock_irqsave(rcg->lock, flags);
+
+	ns = readl_relaxed(rcg->ns_reg);
+	ns = src_to_ns(&rcg->s, rcg->s.parent_map[index], ns);
+	writel(ns, rcg->ns_reg);
+
+	spin_unlock_irqrestore(rcg->lock, flags);
+
+	return 0;
+}
+
+static u32 md_to_m(struct mn *mn, u32 md)
+{
+	md >>= mn->m_val_shift;
+	md &= BIT(mn->width) - 1;
+	return md;
+}
+
+static u32 ns_to_pre_div(struct pre_div *p, u32 ns)
+{
+	ns >>= p->pre_div_shift;
+	ns &= BIT(p->pre_div_width) - 1;
+	return ns;
+}
+
+static u32 pre_div_to_ns(struct pre_div *p, u8 pre_div, u32 ns)
+{
+	u32 mask;
+
+	mask = BIT(p->pre_div_width) - 1;
+	mask <<= p->pre_div_shift;
+	ns &= ~mask;
+
+	ns |= pre_div << p->pre_div_shift;
+	return ns;
+}
+
+static u32 mn_to_md(struct mn *mn, u32 m, u32 n, u32 md)
+{
+	u32 mask, mask_w;
+
+	mask_w = BIT(mn->width) - 1;
+	mask = (mask_w << mn->m_val_shift) | mask_w;
+	md &= ~mask;
+
+	if (n) {
+		m <<= mn->m_val_shift;
+		md |= m;
+		md |= ~n & mask_w;
+	}
+
+	return md;
+}
+
+static u32 ns_m_to_n(struct mn *mn, u32 ns, u32 m)
+{
+	ns = ~ns >> mn->n_val_shift;
+	ns &= BIT(mn->width) - 1;
+	return ns + m;
+}
+
+static u32 reg_to_mnctr_mode(struct mn *mn, u32 val)
+{
+	val >>= mn->mnctr_mode_shift;
+	val &= MNCTR_MODE_MASK;
+	return val;
+}
+
+static u32 mn_to_ns(struct mn *mn, u32 m, u32 n, u32 ns)
+{
+	u32 mask;
+
+	mask = BIT(mn->width) - 1;
+	mask <<= mn->n_val_shift;
+	ns &= ~mask;
+
+	if (n) {
+		n = n - m;
+		n = ~n;
+		n &= BIT(mn->width) - 1;
+		n <<= mn->n_val_shift;
+		ns |= n;
+	}
+
+	return ns;
+}
+
+static u32 mn_to_reg(struct mn *mn, u32 m, u32 n, u32 val)
+{
+	u32 mask;
+
+	mask = MNCTR_MODE_MASK << mn->mnctr_mode_shift;
+	mask |= BIT(mn->mnctr_en_bit);
+	val &= ~mask;
+
+	if (n) {
+		val |= BIT(mn->mnctr_en_bit);
+		val |= MNCTR_MODE_DUAL << mn->mnctr_mode_shift;
+	}
+
+	return val;
+}
+
+static void configure_bank(struct clk_dyn_rcg *rcg, const struct freq_tbl *f)
+{
+	unsigned long flags;
+	u32 ns, md, ctl, *regp;
+	int bank, new_bank;
+	struct mn *mn;
+	struct pre_div *p;
+	struct src_sel *s;
+	bool enabled;
+	void __iomem *md_reg;
+	void __iomem *bank_reg;
+	bool banked_mn = !!rcg->md_reg[0];
+
+	spin_lock_irqsave(rcg->lock, flags);
+
+	enabled = __clk_is_enabled(rcg->hw.clk);
+
+	ns = readl_relaxed(rcg->ns_reg);
+	ctl = readl_relaxed(rcg->ctl_reg);
+
+	if (banked_mn) {
+		regp = &ctl;
+		bank_reg = rcg->ctl_reg;
+	} else {
+		regp = &ns;
+		bank_reg = rcg->ns_reg;
+	}
+
+	bank = reg_to_bank(rcg, *regp);
+	new_bank = enabled ? !bank : bank;
+
+	if (banked_mn) {
+		mn = &rcg->mn[new_bank];
+		md_reg = rcg->md_reg[new_bank];
+
+		ns |= BIT(mn->mnctr_reset_bit);
+		writel_relaxed(ns, rcg->ns_reg);
+
+		md = readl_relaxed(md_reg);
+		md = mn_to_md(mn, f->m, f->n, md);
+		writel_relaxed(md, md_reg);
+
+		ns = mn_to_ns(mn, f->m, f->n, ns);
+		writel_relaxed(ns, rcg->ns_reg);
+
+		ctl = mn_to_reg(mn, f->m, f->n, ctl);
+		writel_relaxed(ctl, rcg->ctl_reg);
+
+		ns &= ~BIT(mn->mnctr_reset_bit);
+		writel_relaxed(ns, rcg->ns_reg);
+	} else {
+		p = &rcg->p[new_bank];
+		ns = pre_div_to_ns(p, f->pre_div - 1, ns);
+	}
+
+	s = &rcg->s[new_bank];
+	ns = src_to_ns(s, s->parent_map[f->src], ns);
+	writel_relaxed(ns, rcg->ns_reg);
+
+	if (enabled) {
+		*regp ^= BIT(rcg->mux_sel_bit);
+		writel_relaxed(*regp, bank_reg);
+	}
+
+	/* Ensure parent switch is completed */
+	mb();
+	spin_unlock_irqrestore(rcg->lock, flags);
+}
+
+static int clk_dyn_rcg_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+	u32 ns, ctl, md, reg;
+	int bank;
+	struct freq_tbl f = { 0 };
+	bool banked_mn = !!rcg->md_reg[0];
+
+	ctl = readl_relaxed(rcg->ctl_reg);
+	ns = readl_relaxed(rcg->ns_reg);
+	reg = banked_mn ? ctl : ns;
+
+	bank = reg_to_bank(rcg, reg);
+
+	if (banked_mn) {
+		md = readl_relaxed(rcg->md_reg[bank]);
+		f.m = md_to_m(&rcg->mn[bank], md);
+		f.n = ns_m_to_n(&rcg->mn[bank], ns, f.m);
+	} else {
+		f.pre_div = ns_to_pre_div(&rcg->p[bank], ns) + 1;
+	}
+	f.src = index;
+
+	configure_bank(rcg, &f);
+
+	return 0;
+}
+
+/*
+ * Calculate m/n:d rate
+ *
+ *          parent_rate     m
+ *   rate = ----------- x  ---
+ *            pre_div       n
+ */
+static unsigned long
+calc_rate(unsigned long rate, u32 m, u32 n, u32 mode, u32 pre_div)
+{
+	if (pre_div)
+		rate /= pre_div + 1;
+
+	if (mode) {
+		u64 tmp = rate;
+		tmp *= m;
+		do_div(tmp, n);
+		rate = tmp;
+	}
+
+	return rate;
+}
+
+static unsigned long
+clk_rcg_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct clk_rcg *rcg = to_clk_rcg(hw);
+	u32 pre_div, m, n, ns, md, mode;
+	struct mn *mn = &rcg->mn;
+
+	ns = readl_relaxed(rcg->ns_reg);
+	md = readl_relaxed(rcg->md_reg);
+
+	pre_div = ns_to_pre_div(&rcg->p, ns);
+	m = md_to_m(mn, md);
+	n = ns_m_to_n(mn, ns, m);
+	/* MN counter mode is in ctl_reg sometimes */
+	if (rcg->ctl_reg != rcg->ns_reg)
+		mode = readl_relaxed(rcg->ctl_reg);
+	else
+		mode = ns;
+	mode = reg_to_mnctr_mode(mn, mode);
+
+	return calc_rate(parent_rate, m, n, mode, pre_div);
+}
+
+static unsigned long
+clk_dyn_rcg_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+	u32 m, n, pre_div, ns, md, mode, reg;
+	int bank;
+	struct mn *mn;
+	bool banked_mn = !!rcg->md_reg[0];
+
+	ns = readl_relaxed(rcg->ns_reg);
+
+	if (banked_mn)
+		reg = readl_relaxed(rcg->ctl_reg);
+	else
+		reg = ns;
+
+	bank = reg_to_bank(rcg, reg);
+
+	if (banked_mn) {
+		mn = &rcg->mn[bank];
+		md = readl_relaxed(rcg->md_reg[bank]);
+		m = md_to_m(mn, md);
+		n = ns_m_to_n(mn, ns, m);
+		mode = reg_to_mnctr_mode(mn, reg);
+		return calc_rate(parent_rate, m, n, mode, 0);
+	} else {
+		pre_div = ns_to_pre_div(&rcg->p[bank], ns);
+		return calc_rate(parent_rate, 0, 0, 0, pre_div);
+	}
+}
+
+static const
+struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
+{
+	for (; f->freq; f++)
+		if (rate <= f->freq)
+			return f;
+
+	return NULL;
+}
+
+static long _freq_tbl_determine_rate(struct clk_hw *hw,
+		const struct freq_tbl *f, unsigned long rate,
+		unsigned long *p_rate, struct clk **p)
+{
+	f = find_freq(f, rate);
+	if (!f)
+		return -EINVAL;
+
+	*p = clk_get_parent_by_index(hw->clk, f->src);
+	*p_rate =  __clk_get_rate(*p);
+
+	return f->freq;
+}
+
+static long clk_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long *p_rate, struct clk **p)
+{
+	struct clk_rcg *rcg = to_clk_rcg(hw);
+
+	return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, p_rate, p);
+}
+
+static long clk_dyn_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long *p_rate, struct clk **p)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+
+	return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, p_rate, p);
+}
+
+static int clk_rcg_set_rate(struct clk_hw *hw, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	struct clk_rcg *rcg = to_clk_rcg(hw);
+	unsigned long flags;
+	const struct freq_tbl *f;
+	u32 ns, md, ctl;
+	struct mn *mn = &rcg->mn;
+
+	f = find_freq(rcg->freq_tbl, rate);
+	if (!f)
+		return -EINVAL;
+
+	spin_lock_irqsave(rcg->lock, flags);
+
+	ns = readl_relaxed(rcg->ns_reg);
+	ns |= BIT(mn->mnctr_reset_bit);
+	writel_relaxed(ns, rcg->ns_reg);
+
+	md = readl_relaxed(rcg->md_reg);
+	md = mn_to_md(mn, f->m, f->n, md);
+	writel_relaxed(md, rcg->md_reg);
+
+	/* MN counter mode is in ctl_reg sometimes */
+	if (rcg->ctl_reg != rcg->ns_reg) {
+		ctl = readl_relaxed(rcg->ctl_reg);
+		ctl = mn_to_reg(mn, f->m, f->n, ctl);
+		writel_relaxed(ctl, rcg->ctl_reg);
+	} else {
+		ns = mn_to_reg(mn, f->m, f->n, ns);
+	}
+	ns = mn_to_ns(mn, f->m, f->n, ns);
+	ns = pre_div_to_ns(&rcg->p, f->pre_div - 1, ns);
+	writel_relaxed(ns, rcg->ns_reg);
+
+	ns &= ~BIT(mn->mnctr_reset_bit);
+	writel(ns, rcg->ns_reg);
+
+	spin_unlock_irqrestore(rcg->lock, flags);
+
+	return 0;
+}
+
+static int __clk_dyn_rcg_set_rate(struct clk_hw *hw, unsigned long rate)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+	const struct freq_tbl *f;
+
+	f = find_freq(rcg->freq_tbl, rate);
+	if (!f)
+		return -EINVAL;
+
+	configure_bank(rcg, f);
+
+	return 0;
+}
+
+static int clk_dyn_rcg_set_rate(struct clk_hw *hw, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	return __clk_dyn_rcg_set_rate(hw, rate);
+}
+
+static int clk_dyn_rcg_set_rate_and_parent(struct clk_hw *hw,
+		unsigned long rate, unsigned long parent_rate, u8 index)
+{
+	return __clk_dyn_rcg_set_rate(hw, rate);
+}
+
+static const struct clk_ops clk_rcg_ops = {
+	.enable = clk_rcg_enable,
+	.disable = clk_rcg_disable,
+	.get_parent = clk_rcg_get_parent,
+	.set_parent = clk_rcg_set_parent,
+	.recalc_rate = clk_rcg_recalc_rate,
+	.determine_rate = clk_rcg_determine_rate,
+	.set_rate = clk_rcg_set_rate,
+};
+
+struct clk *rcg_clk_register(struct device *dev, struct rcg_desc *desc,
+		spinlock_t *lock, struct clk_init_data *init,
+		u8 pre_div_width, u8 mnd_width)
+{
+	struct clk_rcg *r;
+
+	r = devm_kzalloc(dev, sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	r->ctl_reg = desc->base + desc->ctl_reg;
+	r->ns_reg = desc->base + desc->ns_reg;
+	r->md_reg = desc->base + desc->md_reg;
+	r->ctl_bit = desc->ctl_bit;
+	r->mn.mnctr_en_bit = desc->mnctr_en_bit;
+	r->mn.mnctr_reset_bit = desc->mnctr_reset_bit;
+	r->mn.mnctr_mode_shift = desc->mnctr_mode_shift;
+	r->mn.n_val_shift = desc->n_val_shift;
+	r->mn.m_val_shift = desc->m_val_shift;
+	r->p.pre_div_shift = desc->pre_div_shift;
+	r->p.pre_div_width = pre_div_width;
+	r->s.src_sel_shift = desc->src_sel_shift;
+	r->s.parent_map = desc->parent_map;
+	r->freq_tbl = desc->freq_tbl;
+	r->lock = lock;
+	r->mn.width = mnd_width;
+
+	init->ops = &clk_rcg_ops;
+	init->flags |= CLK_SET_RATE_GATE;
+	r->hw.init = init;
+
+	return devm_clk_register(dev, &r->hw);
+}
+
+static const struct clk_ops clk_dyn_rcg_ops = {
+	.enable = clk_dyn_rcg_enable,
+	.is_enabled = clk_dyn_rcg_is_enabled,
+	.disable = clk_dyn_rcg_disable,
+	.get_parent = clk_dyn_rcg_get_parent,
+	.set_parent = clk_dyn_rcg_set_parent,
+	.recalc_rate = clk_dyn_rcg_recalc_rate,
+	.determine_rate = clk_dyn_rcg_determine_rate,
+	.set_rate = clk_dyn_rcg_set_rate,
+	.set_rate_and_parent = clk_dyn_rcg_set_rate_and_parent,
+};
+
+struct clk *
+rcg_dyn_clk_register(struct device *dev, struct rcg_dyn_desc *desc,
+		spinlock_t *lock, struct clk_init_data *init, u8 pre_div_width,
+		u8 mnd_width)
+{
+	struct clk_dyn_rcg *r;
+
+	r = devm_kzalloc(dev, sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	r->ctl_reg = desc->base + desc->ctl_reg;
+	r->ns_reg = desc->base + desc->ns_reg;
+	r->ctl_bit = desc->ctl_bit;
+	if (mnd_width) {
+		r->md_reg[0] = desc->base + desc->md0_reg;
+		r->md_reg[1] = desc->base + desc->md1_reg;
+		r->mn[0].mnctr_en_bit = desc->mnctr0_en_bit;
+		r->mn[0].mnctr_reset_bit = desc->mnctr0_reset_bit;
+		r->mn[0].mnctr_mode_shift = desc->mnctr0_mode_shift;
+		r->mn[0].n_val_shift = desc->n0_val_shift;
+		r->mn[0].m_val_shift = desc->m0_val_shift;
+		r->mn[0].width = mnd_width;
+		r->mn[1].mnctr_en_bit = desc->mnctr1_en_bit;
+		r->mn[1].mnctr_reset_bit = desc->mnctr1_reset_bit;
+		r->mn[1].mnctr_mode_shift = desc->mnctr1_mode_shift;
+		r->mn[1].n_val_shift = desc->n1_val_shift;
+		r->mn[1].m_val_shift = desc->m1_val_shift;
+		r->mn[1].width = mnd_width;
+	}
+	if (pre_div_width) {
+		r->p[0].pre_div_shift = desc->pre_div0_shift;
+		r->p[0].pre_div_width = pre_div_width;
+		r->p[1].pre_div_shift = desc->pre_div1_shift;
+		r->p[1].pre_div_width = pre_div_width;
+	}
+	r->s[0].src_sel_shift = desc->src0_sel_shift;
+	r->s[0].parent_map = desc->parent_map;
+	r->s[1].src_sel_shift = desc->src1_sel_shift;
+	r->s[1].parent_map = desc->parent_map;
+	r->mux_sel_bit = desc->mux_sel_bit;
+	r->freq_tbl = desc->freq_tbl;
+	r->lock = lock;
+
+	init->ops = &clk_dyn_rcg_ops;
+	r->hw.init = init;
+
+	return devm_clk_register(dev, &r->hw);
+}
diff --git a/drivers/clk/msm/clk-rcg.h b/drivers/clk/msm/clk-rcg.h
new file mode 100644
index 0000000..9cc572d
--- /dev/null
+++ b/drivers/clk/msm/clk-rcg.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MSM_CLK_RCG_H__
+#define __MSM_CLK_RCG_H__
+
+struct device;
+struct clk;
+struct clk_init_data;
+
+struct freq_tbl {
+	unsigned long freq;
+	u8 src;
+	u8 pre_div;
+	u16 m;
+	u16 n;
+};
+
+struct rcg_desc {
+	void __iomem *base;
+	u32 ctl_reg;
+	u32 ns_reg;
+	u32 md_reg;
+
+	u8 ctl_bit;
+	u8 mnctr_en_bit;
+	u8 mnctr_reset_bit;
+	u8 mnctr_mode_shift;
+	u8 pre_div_shift;
+	u8 src_sel_shift;
+	u8 n_val_shift;
+	u8 m_val_shift;
+
+	u8 *parent_map;
+	struct freq_tbl *freq_tbl;
+};
+
+extern struct clk *rcg_clk_register(struct device *dev, struct rcg_desc *desc,
+		spinlock_t *lock, struct clk_init_data *init,
+		u8 pre_div_width, u8 mnd_width);
+
+#define rcg_p2mn8_clk_register(dev, desc, lock, init) \
+	rcg_clk_register(dev, desc, lock, init, 2, 8)
+#define rcg_p2mn16_clk_register(dev, desc, lock, init) \
+	rcg_clk_register(dev, desc, lock, init, 2, 16)
+
+struct rcg_dyn_desc {
+	void __iomem *base;
+	u32 ctl_reg;
+	u32 ns_reg;
+	u32 md0_reg;
+	u32 md1_reg;
+
+	u8 ctl_bit;
+	u8 mnctr0_en_bit;
+	u8 mnctr1_en_bit;
+	u8 mnctr0_reset_bit;
+	u8 mnctr1_reset_bit;
+	u8 mnctr0_mode_shift;
+	u8 mnctr1_mode_shift;
+	u8 pre_div0_shift;
+	u8 pre_div1_shift;
+	u8 src0_sel_shift;
+	u8 src1_sel_shift;
+	u8 n0_val_shift;
+	u8 n1_val_shift;
+	u8 m0_val_shift;
+	u8 m1_val_shift;
+	u8 mux_sel_bit;
+
+	u8 *parent_map;
+	struct freq_tbl *freq_tbl;
+};
+
+struct clk *rcg_dyn_clk_register(struct device *dev,
+		struct rcg_dyn_desc *desc, spinlock_t *lock,
+		struct clk_init_data *init, u8 pre_div_width, u8 mnd_width);
+
+#define rcg_mn4_dyn_clk_register(dev, desc, lock, init) \
+	rcg_dyn_clk_register(dev, desc, lock, init, 0, 4)
+#define rcg_mn8_dyn_clk_register(dev, desc, lock, init) \
+	rcg_dyn_clk_register(dev, desc, lock, init, 0, 8)
+#define rcg_p4_dyn_clk_register(dev, desc, lock, init) \
+	rcg_dyn_clk_register(dev, desc, lock, init, 4, 0)
+
+struct rcg2_desc {
+	void __iomem *base;
+	u32 cmd_rcgr;
+	u8 *parent_map;
+	struct freq_tbl *freq_tbl;
+};
+
+extern struct clk *rcg2_clk_register(struct device *dev, struct rcg2_desc *desc,
+		spinlock_t *lock, struct clk_init_data *init,
+		u8 hid_width, u8 mnd_width);
+
+#define rcg_h5_clk_register(dev, desc, lock, init) \
+	rcg2_clk_register(dev, desc, lock, init, 5, 0)
+#define rcg_h5mn8_clk_register(dev, desc, lock, init) \
+	rcg2_clk_register(dev, desc, lock, init, 5, 8)
+#define rcg_h5mn16_clk_register(dev, desc, lock, init) \
+	rcg2_clk_register(dev, desc, lock, init, 5, 16)
+
+#endif
diff --git a/drivers/clk/msm/clk-rcg2.c b/drivers/clk/msm/clk-rcg2.c
new file mode 100644
index 0000000..b8daf87
--- /dev/null
+++ b/drivers/clk/msm/clk-rcg2.c
@@ -0,0 +1,320 @@
+/*
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+
+#include <asm/div64.h>
+
+#include "clk-rcg.h"
+
+#define CMD_REG			0x0
+#define CMD_UPDATE		BIT(0)
+#define CMD_ROOT_EN		BIT(1)
+#define CMD_DIRTY_CFG		BIT(4)
+#define CMD_DIRTY_N		BIT(5)
+#define CMD_DIRTY_M		BIT(6)
+#define CMD_DIRTY_D		BIT(7)
+#define CMD_ROOT_OFF		BIT(31)
+
+#define CFG_REG			0x4
+#define CFG_SRC_DIV_SHIFT	0
+#define CFG_SRC_SEL_SHIFT	8
+#define CFG_SRC_SEL_MASK	(0x7 << CFG_SRC_SEL_SHIFT)
+#define CFG_MODE_SHIFT		12
+#define CFG_MODE_MASK		(0x3 << CFG_MODE_SHIFT)
+#define CFG_MODE_DUAL_EDGE	(0x2 << CFG_MODE_SHIFT)
+
+#define M_REG			0x8
+#define N_REG			0xc
+#define D_REG			0x10
+
+/**
+ * struct clk_rcg2 - root clock generator
+ *
+ * @base: corresponds to *_CMD_RCGR
+ * @mnd_width: number of bits in m/n/d values
+ * @hid_width: number of bits in half integer divider
+ * @parent_map: map from software's parent index to hardware's src_sel field
+ * @freq_tbl: Frequency table
+ * @hw: handle between common and hardware-specific interfaces
+ * @lock: register lock
+ *
+ */
+struct clk_rcg2 {
+	void __iomem		*base;
+	u8			mnd_width;
+	u8			hid_width;
+	u8			*parent_map;
+	const struct freq_tbl	*freq_tbl;
+	struct clk_hw		hw;
+	spinlock_t		*lock;
+};
+
+#define to_clk_rcg2(_hw) container_of(_hw, struct clk_rcg2, hw)
+
+static int clk_rcg2_is_enabled(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	u32 cmd;
+
+	cmd = readl_relaxed(rcg->base + CMD_REG);
+	cmd &= CMD_ROOT_OFF;
+
+	return cmd ? 0 : 1;
+}
+
+static u8 clk_rcg2_get_parent(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	int num_parents = __clk_get_num_parents(hw->clk);
+	u32 cfg;
+	int i;
+
+	cfg = readl_relaxed(rcg->base + CFG_REG);
+	cfg &= CFG_SRC_SEL_MASK;
+	cfg >>= CFG_SRC_SEL_SHIFT;
+
+	for (i = 0; i < num_parents; i++)
+		if (cfg == rcg->parent_map[i])
+			return i;
+
+	return -EINVAL;
+}
+
+static void update_config(struct clk_rcg2 *rcg)
+{
+	int count;
+	u32 cmd;
+	const char *name = __clk_get_name(rcg->hw.clk);
+
+	cmd = readl_relaxed(rcg->base + CMD_REG);
+	cmd |= CMD_UPDATE;
+	writel_relaxed(cmd, rcg->base + CMD_REG);
+
+	/* Wait for update to take effect */
+	for (count = 500; count > 0; count--) {
+		if (!(readl_relaxed(rcg->base + CMD_REG) & CMD_UPDATE))
+			return;
+		udelay(1);
+	}
+
+	WARN(1, "%s: rcg didn't update its configuration.", name);
+}
+
+static int clk_rcg2_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	unsigned long flags;
+	u32 cfg;
+
+	spin_lock_irqsave(rcg->lock, flags);
+
+	cfg = readl_relaxed(rcg->base + CFG_REG);
+	cfg &= ~CFG_SRC_SEL_MASK;
+	cfg |= rcg->parent_map[index] << CFG_SRC_SEL_SHIFT;
+	writel(cfg, rcg->base + CFG_REG);
+
+	update_config(rcg);
+
+	spin_unlock_irqrestore(rcg->lock, flags);
+
+	return 0;
+}
+
+/*
+ * Calculate m/n:d rate
+ *
+ *          parent_rate     m
+ *   rate = ----------- x  ---
+ *            hid_div       n
+ */
+static unsigned long
+calc_rate(unsigned long rate, u32 m, u32 n, u32 mode, u32 hid_div)
+{
+	if (hid_div) {
+		rate *= 2;
+		rate /= hid_div + 1;
+	}
+
+	if (mode) {
+		u64 tmp = rate;
+		tmp *= m;
+		do_div(tmp, n);
+		rate = tmp;
+	}
+
+	return rate;
+}
+
+static unsigned long
+clk_rcg2_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	u32 cfg, hid_div, m = 0, n = 0, mode = 0, mask;
+
+	cfg = readl_relaxed(rcg->base + CFG_REG);
+
+	if (rcg->mnd_width) {
+		mask = BIT(rcg->mnd_width) - 1;
+		m = readl_relaxed(rcg->base + M_REG);
+		m &= mask;
+		n = readl_relaxed(rcg->base + N_REG);
+		n =  ~n;
+		n &= mask;
+		n += m;
+		mode = cfg & CFG_MODE_MASK;
+		mode >>= CFG_MODE_SHIFT;
+	}
+
+	mask = BIT(rcg->hid_width) - 1;
+	hid_div = cfg >> CFG_SRC_DIV_SHIFT;
+	hid_div &= mask;
+
+	return calc_rate(parent_rate, m, n, mode, hid_div);
+}
+
+static const
+struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
+{
+	for (; f->freq; f++)
+		if (rate <= f->freq)
+			return f;
+
+	return NULL;
+}
+
+static long _freq_tbl_determine_rate(struct clk_hw *hw,
+		const struct freq_tbl *f, unsigned long rate,
+		unsigned long *p_rate, struct clk **p)
+{
+	f = find_freq(f, rate);
+	if (!f)
+		return -EINVAL;
+
+	*p = clk_get_parent_by_index(hw->clk, f->src);
+	*p_rate =  __clk_get_rate(*p);
+
+	return f->freq;
+}
+
+static long clk_rcg2_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long *p_rate, struct clk **p)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+
+	return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, p_rate, p);
+}
+
+static int __clk_rcg2_set_rate(struct clk_hw *hw, unsigned long rate)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	unsigned long flags;
+	const struct freq_tbl *f;
+	u32 cfg, m, n, d, mask, val;
+
+	f = find_freq(rcg->freq_tbl, rate);
+	if (!f)
+		return -EINVAL;
+
+	spin_lock_irqsave(rcg->lock, flags);
+
+	cfg = readl_relaxed(rcg->base + CFG_REG);
+	mask = BIT(rcg->hid_width) - 1;
+	mask |= CFG_SRC_SEL_MASK | CFG_MODE_MASK;
+	cfg &= ~mask;
+
+	if (rcg->mnd_width && f->n) {
+		mask = BIT(rcg->mnd_width) - 1;
+		m = readl_relaxed(rcg->base + M_REG);
+		m &= ~mask;
+		m |= f->m;
+		writel_relaxed(m, rcg->base + M_REG);
+
+		val = readl_relaxed(rcg->base + M_REG);
+		val &= ~mask;
+		n = f->n - f->m;
+		n = ~n;
+		n &= mask;
+		val |= n;
+		writel_relaxed(val, rcg->base + N_REG);
+
+		d = readl_relaxed(rcg->base + D_REG);
+		d &= ~mask;
+		d |= ~f->n & mask;
+		writel_relaxed(d, rcg->base + D_REG);
+
+		cfg |= CFG_MODE_DUAL_EDGE;
+	}
+
+	cfg |= f->pre_div << CFG_SRC_DIV_SHIFT;
+	cfg |= rcg->parent_map[f->src] << CFG_SRC_SEL_SHIFT;
+	writel_relaxed(cfg, rcg->base + CFG_REG);
+
+	update_config(rcg);
+
+	spin_unlock_irqrestore(rcg->lock, flags);
+
+	return 0;
+}
+
+static int clk_rcg2_set_rate(struct clk_hw *hw, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	return __clk_rcg2_set_rate(hw, rate);
+}
+
+static int clk_rcg2_set_rate_and_parent(struct clk_hw *hw,
+		unsigned long rate, unsigned long parent_rate, u8 index)
+{
+	return __clk_rcg2_set_rate(hw, rate);
+}
+
+static const struct clk_ops clk_rcg2_ops = {
+	.is_enabled = clk_rcg2_is_enabled,
+	.get_parent = clk_rcg2_get_parent,
+	.set_parent = clk_rcg2_set_parent,
+	.recalc_rate = clk_rcg2_recalc_rate,
+	.determine_rate = clk_rcg2_determine_rate,
+	.set_rate = clk_rcg2_set_rate,
+	.set_rate_and_parent = clk_rcg2_set_rate_and_parent,
+};
+
+struct clk *rcg2_clk_register(struct device *dev, struct rcg2_desc *desc,
+		spinlock_t *lock, struct clk_init_data *init,
+		u8 hid_width, u8 mnd_width)
+{
+	struct clk_rcg2 *r;
+
+	r = devm_kzalloc(dev, sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	r->base = desc->base + desc->cmd_rcgr;
+	r->parent_map = desc->parent_map;
+	r->freq_tbl = desc->freq_tbl;
+	r->lock = lock;
+	r->mnd_width = mnd_width;
+	r->hid_width = hid_width;
+
+	init->ops = &clk_rcg2_ops;
+	r->hw.init = init;
+
+	return devm_clk_register(dev, &r->hw);
+}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

