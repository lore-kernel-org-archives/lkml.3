Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaAOSuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:50:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49401 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaAOSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:41 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v5 05/14] clk: qcom: Add support for root clock generators (RCGs)
Date: Wed, 15 Jan 2014 10:47:25 -0800
Message-Id: <1389811654-21397-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the root clock generators on Qualcomm devices.
RCGs are highly customizable mux/divider/counter clocks that can
be used to generate almost any rate desired given some input
source that is faster than the desired rate.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile   |   2 +
 drivers/clk/qcom/clk-rcg.c  | 517 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-rcg.h  | 159 ++++++++++++++
 drivers/clk/qcom/clk-rcg2.c | 291 +++++++++++++++++++++++++
 4 files changed, 969 insertions(+)
 create mode 100644 drivers/clk/qcom/clk-rcg.c
 create mode 100644 drivers/clk/qcom/clk-rcg.h
 create mode 100644 drivers/clk/qcom/clk-rcg2.c

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index 7871e235c2b1..5d0a6e0ac01f 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -2,3 +2,5 @@ obj-$(CONFIG_COMMON_CLK_QCOM) += clk-qcom.o
 
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-regmap.o
 clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-pll.o
+clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg.o
+clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg2.o
diff --git a/drivers/clk/qcom/clk-rcg.c b/drivers/clk/qcom/clk-rcg.c
new file mode 100644
index 000000000000..abfc2b675aea
--- /dev/null
+++ b/drivers/clk/qcom/clk-rcg.c
@@ -0,0 +1,517 @@
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
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+
+#include <asm/div64.h>
+
+#include "clk-rcg.h"
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
+	regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+	ns = ns_to_src(&rcg->s, ns);
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
+	regmap_read(rcg->clkr.regmap, rcg->clkr.enable_reg, &ctl);
+	bank = reg_to_bank(rcg, ctl);
+	s = &rcg->s[bank];
+
+	regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
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
+	u32 ns;
+
+	regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+	ns = src_to_ns(&rcg->s, rcg->s.parent_map[index], ns);
+	regmap_write(rcg->clkr.regmap, rcg->ns_reg, ns);
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
+	u32 ns, md, ctl, *regp;
+	int bank, new_bank;
+	struct mn *mn;
+	struct pre_div *p;
+	struct src_sel *s;
+	bool enabled;
+	u32 md_reg;
+	u32 bank_reg;
+	bool banked_mn = !!rcg->mn[1].width;
+	struct clk_hw *hw = &rcg->clkr.hw;
+
+	enabled = __clk_is_enabled(hw->clk);
+
+	regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+	regmap_read(rcg->clkr.regmap, rcg->clkr.enable_reg, &ctl);
+
+	if (banked_mn) {
+		regp = &ctl;
+		bank_reg = rcg->clkr.enable_reg;
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
+		regmap_write(rcg->clkr.regmap, rcg->ns_reg, ns);
+
+		regmap_read(rcg->clkr.regmap, md_reg, &md);
+		md = mn_to_md(mn, f->m, f->n, md);
+		regmap_write(rcg->clkr.regmap, md_reg, md);
+
+		ns = mn_to_ns(mn, f->m, f->n, ns);
+		regmap_write(rcg->clkr.regmap, rcg->ns_reg, ns);
+
+		ctl = mn_to_reg(mn, f->m, f->n, ctl);
+		regmap_write(rcg->clkr.regmap, rcg->clkr.enable_reg, ctl);
+
+		ns &= ~BIT(mn->mnctr_reset_bit);
+		regmap_write(rcg->clkr.regmap, rcg->ns_reg, ns);
+	} else {
+		p = &rcg->p[new_bank];
+		ns = pre_div_to_ns(p, f->pre_div - 1, ns);
+	}
+
+	s = &rcg->s[new_bank];
+	ns = src_to_ns(s, s->parent_map[f->src], ns);
+	regmap_write(rcg->clkr.regmap, rcg->ns_reg, ns);
+
+	if (enabled) {
+		*regp ^= BIT(rcg->mux_sel_bit);
+		regmap_write(rcg->clkr.regmap, bank_reg, *regp);
+	}
+}
+
+static int clk_dyn_rcg_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
+	u32 ns, ctl, md, reg;
+	int bank;
+	struct freq_tbl f = { 0 };
+	bool banked_mn = !!rcg->mn[1].width;
+
+	regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+	regmap_read(rcg->clkr.regmap, rcg->clkr.enable_reg, &ctl);
+	reg = banked_mn ? ctl : ns;
+
+	bank = reg_to_bank(rcg, reg);
+
+	if (banked_mn) {
+		regmap_read(rcg->clkr.regmap, rcg->md_reg[bank], &md);
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
+	u32 pre_div, m = 0, n = 0, ns, md, mode = 0;
+	struct mn *mn = &rcg->mn;
+
+	regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+	pre_div = ns_to_pre_div(&rcg->p, ns);
+
+	if (rcg->mn.width) {
+		regmap_read(rcg->clkr.regmap, rcg->md_reg, &md);
+		m = md_to_m(mn, md);
+		n = ns_m_to_n(mn, ns, m);
+		/* MN counter mode is in hw.enable_reg sometimes */
+		if (rcg->clkr.enable_reg != rcg->ns_reg)
+			regmap_read(rcg->clkr.regmap, rcg->clkr.enable_reg, &mode);
+		else
+			mode = ns;
+		mode = reg_to_mnctr_mode(mn, mode);
+	}
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
+	bool banked_mn = !!rcg->mn[1].width;
+
+	regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+
+	if (banked_mn)
+		regmap_read(rcg->clkr.regmap, rcg->clkr.enable_reg, &reg);
+	else
+		reg = ns;
+
+	bank = reg_to_bank(rcg, reg);
+
+	if (banked_mn) {
+		mn = &rcg->mn[bank];
+		regmap_read(rcg->clkr.regmap, rcg->md_reg[bank], &md);
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
+	if (!f)
+		return NULL;
+
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
+	unsigned long clk_flags;
+
+	f = find_freq(f, rate);
+	if (!f)
+		return -EINVAL;
+
+	clk_flags = __clk_get_flags(hw->clk);
+	*p = clk_get_parent_by_index(hw->clk, f->src);
+	if (clk_flags & CLK_SET_RATE_PARENT) {
+		rate = rate * f->pre_div;
+		if (f->n) {
+			u64 tmp = rate;
+			tmp = tmp * f->n;
+			do_div(tmp, f->m);
+			rate = tmp;
+		}
+	} else {
+		rate =  __clk_get_rate(*p);
+	}
+	*p_rate = rate;
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
+	const struct freq_tbl *f;
+	u32 ns, md, ctl;
+	struct mn *mn = &rcg->mn;
+	u32 mask = 0;
+	unsigned int reset_reg;
+
+	f = find_freq(rcg->freq_tbl, rate);
+	if (!f)
+		return -EINVAL;
+
+	if (rcg->mn.reset_in_cc)
+		reset_reg = rcg->clkr.enable_reg;
+	else
+		reset_reg = rcg->ns_reg;
+
+	if (rcg->mn.width) {
+		mask = BIT(mn->mnctr_reset_bit);
+		regmap_update_bits(rcg->clkr.regmap, reset_reg, mask, mask);
+
+		regmap_read(rcg->clkr.regmap, rcg->md_reg, &md);
+		md = mn_to_md(mn, f->m, f->n, md);
+		regmap_write(rcg->clkr.regmap, rcg->md_reg, md);
+
+		regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+		/* MN counter mode is in hw.enable_reg sometimes */
+		if (rcg->clkr.enable_reg != rcg->ns_reg) {
+			regmap_read(rcg->clkr.regmap, rcg->clkr.enable_reg, &ctl);
+			ctl = mn_to_reg(mn, f->m, f->n, ctl);
+			regmap_write(rcg->clkr.regmap, rcg->clkr.enable_reg, ctl);
+		} else {
+			ns = mn_to_reg(mn, f->m, f->n, ns);
+		}
+		ns = mn_to_ns(mn, f->m, f->n, ns);
+	} else {
+		regmap_read(rcg->clkr.regmap, rcg->ns_reg, &ns);
+	}
+
+	ns = pre_div_to_ns(&rcg->p, f->pre_div - 1, ns);
+	regmap_write(rcg->clkr.regmap, rcg->ns_reg, ns);
+
+	regmap_update_bits(rcg->clkr.regmap, reset_reg, mask, 0);
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
+const struct clk_ops clk_rcg_ops = {
+	.enable = clk_enable_regmap,
+	.disable = clk_disable_regmap,
+	.get_parent = clk_rcg_get_parent,
+	.set_parent = clk_rcg_set_parent,
+	.recalc_rate = clk_rcg_recalc_rate,
+	.determine_rate = clk_rcg_determine_rate,
+	.set_rate = clk_rcg_set_rate,
+};
+EXPORT_SYMBOL_GPL(clk_rcg_ops);
+
+const struct clk_ops clk_dyn_rcg_ops = {
+	.enable = clk_enable_regmap,
+	.is_enabled = clk_is_enabled_regmap,
+	.disable = clk_disable_regmap,
+	.get_parent = clk_dyn_rcg_get_parent,
+	.set_parent = clk_dyn_rcg_set_parent,
+	.recalc_rate = clk_dyn_rcg_recalc_rate,
+	.determine_rate = clk_dyn_rcg_determine_rate,
+	.set_rate = clk_dyn_rcg_set_rate,
+	.set_rate_and_parent = clk_dyn_rcg_set_rate_and_parent,
+};
+EXPORT_SYMBOL_GPL(clk_dyn_rcg_ops);
diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
new file mode 100644
index 000000000000..1d6b6dece328
--- /dev/null
+++ b/drivers/clk/qcom/clk-rcg.h
@@ -0,0 +1,159 @@
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
+#ifndef __QCOM_CLK_RCG_H__
+#define __QCOM_CLK_RCG_H__
+
+#include <linux/clk-provider.h>
+#include "clk-regmap.h"
+
+struct freq_tbl {
+	unsigned long freq;
+	u8 src;
+	u8 pre_div;
+	u16 m;
+	u16 n;
+};
+
+/**
+ * struct mn - M/N:D counter
+ * @mnctr_en_bit: bit to enable mn counter
+ * @mnctr_reset_bit: bit to assert mn counter reset
+ * @mnctr_mode_shift: lowest bit of mn counter mode field
+ * @n_val_shift: lowest bit of n value field
+ * @m_val_shift: lowest bit of m value field
+ * @width: number of bits in m/n/d values
+ * @reset_in_cc: true if the mnctr_reset_bit is in the CC register
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
+	bool		reset_in_cc;
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
+	const u8	*parent_map;
+};
+
+/**
+ * struct clk_rcg - root clock generator
+ *
+ * @ns_reg: NS register
+ * @md_reg: MD register
+ * @mn: mn counter
+ * @p: pre divider
+ * @s: source selector
+ * @freq_tbl: frequency table
+ * @clkr: regmap clock handle
+ * @lock: register lock
+ *
+ */
+struct clk_rcg {
+	u32		ns_reg;
+	u32		md_reg;
+
+	struct mn	mn;
+	struct pre_div	p;
+	struct src_sel	s;
+
+	const struct freq_tbl	*freq_tbl;
+
+	struct clk_regmap	clkr;
+};
+
+extern const struct clk_ops clk_rcg_ops;
+
+#define to_clk_rcg(_hw) container_of(to_clk_regmap(_hw), struct clk_rcg, clkr)
+
+/**
+ * struct clk_dyn_rcg - root clock generator with glitch free mux
+ *
+ * @mux_sel_bit: bit to switch glitch free mux
+ * @ns_reg: NS register
+ * @md_reg: MD0 and MD1 register
+ * @mn: mn counter (banked)
+ * @s: source selector (banked)
+ * @freq_tbl: frequency table
+ * @clkr: regmap clock handle
+ * @lock: register lock
+ *
+ */
+struct clk_dyn_rcg {
+	u32	ns_reg;
+	u32	md_reg[2];
+
+	u8	mux_sel_bit;
+
+	struct mn	mn[2];
+	struct pre_div	p[2];
+	struct src_sel	s[2];
+
+	const struct freq_tbl *freq_tbl;
+
+	struct clk_regmap clkr;
+};
+
+extern const struct clk_ops clk_dyn_rcg_ops;
+
+#define to_clk_dyn_rcg(_hw) \
+	container_of(to_clk_regmap(_hw), struct clk_dyn_rcg, clkr)
+
+/**
+ * struct clk_rcg2 - root clock generator
+ *
+ * @cmd_rcgr: corresponds to *_CMD_RCGR
+ * @mnd_width: number of bits in m/n/d values
+ * @hid_width: number of bits in half integer divider
+ * @parent_map: map from software's parent index to hardware's src_sel field
+ * @freq_tbl: frequency table
+ * @clkr: regmap clock handle
+ * @lock: register lock
+ *
+ */
+struct clk_rcg2 {
+	u32			cmd_rcgr;
+	u8			mnd_width;
+	u8			hid_width;
+	const u8		*parent_map;
+	const struct freq_tbl	*freq_tbl;
+	struct clk_regmap	clkr;
+};
+
+#define to_clk_rcg2(_hw) container_of(to_clk_regmap(_hw), struct clk_rcg2, clkr)
+
+extern const struct clk_ops clk_rcg2_ops;
+
+#endif
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
new file mode 100644
index 000000000000..00f878a04d3f
--- /dev/null
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -0,0 +1,291 @@
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
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/bug.h>
+#include <linux/export.h>
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/regmap.h>
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
+static int clk_rcg2_is_enabled(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	u32 cmd;
+	int ret;
+
+	ret = regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CMD_REG, &cmd);
+	if (ret)
+		return ret;
+
+	return (cmd & CMD_ROOT_OFF) != 0;
+}
+
+static u8 clk_rcg2_get_parent(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	int num_parents = __clk_get_num_parents(hw->clk);
+	u32 cfg;
+	int i, ret;
+
+	ret = regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, &cfg);
+	if (ret)
+		return ret;
+
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
+static int update_config(struct clk_rcg2 *rcg)
+{
+	int count, ret;
+	u32 cmd;
+	struct clk_hw *hw = &rcg->clkr.hw;
+	const char *name = __clk_get_name(hw->clk);
+
+	ret = regmap_update_bits(rcg->clkr.regmap, rcg->cmd_rcgr + CMD_REG,
+				 CMD_UPDATE, CMD_UPDATE);
+	if (ret)
+		return ret;
+
+	/* Wait for update to take effect */
+	for (count = 500; count > 0; count--) {
+		ret = regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CMD_REG, &cmd);
+		if (ret)
+			return ret;
+		if (!(cmd & CMD_UPDATE))
+			return 0;
+		udelay(1);
+	}
+
+	WARN(1, "%s: rcg didn't update its configuration.", name);
+	return 0;
+}
+
+static int clk_rcg2_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+	int ret;
+
+	ret = regmap_update_bits(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG,
+				 CFG_SRC_SEL_MASK,
+				 rcg->parent_map[index] << CFG_SRC_SEL_SHIFT);
+	if (ret)
+		return ret;
+
+	return update_config(rcg);
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
+	regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, &cfg);
+
+	if (rcg->mnd_width) {
+		mask = BIT(rcg->mnd_width) - 1;
+		regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + M_REG, &m);
+		m &= mask;
+		regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + N_REG, &n);
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
+	if (!f)
+		return NULL;
+
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
+	unsigned long clk_flags;
+
+	f = find_freq(f, rate);
+	if (!f)
+		return -EINVAL;
+
+	clk_flags = __clk_get_flags(hw->clk);
+	*p = clk_get_parent_by_index(hw->clk, f->src);
+	if (clk_flags & CLK_SET_RATE_PARENT) {
+		if (f->pre_div) {
+			rate /= 2;
+			rate *= f->pre_div + 1;
+		}
+
+		if (f->n) {
+			u64 tmp = rate;
+			tmp = tmp * f->n;
+			do_div(tmp, f->m);
+			rate = tmp;
+		}
+	} else {
+		rate =  __clk_get_rate(*p);
+	}
+	*p_rate = rate;
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
+	const struct freq_tbl *f;
+	u32 cfg, mask;
+	int ret;
+
+	f = find_freq(rcg->freq_tbl, rate);
+	if (!f)
+		return -EINVAL;
+
+	if (rcg->mnd_width && f->n) {
+		mask = BIT(rcg->mnd_width) - 1;
+		ret = regmap_update_bits(rcg->clkr.regmap, rcg->cmd_rcgr + M_REG,
+					 mask, f->m);
+		if (ret)
+			return ret;
+
+		ret = regmap_update_bits(rcg->clkr.regmap, rcg->cmd_rcgr + N_REG,
+					 mask, ~(f->n - f->m));
+		if (ret)
+			return ret;
+
+		ret = regmap_update_bits(rcg->clkr.regmap, rcg->cmd_rcgr + D_REG,
+					 mask, ~f->n);
+		if (ret)
+			return ret;
+	}
+
+	mask = BIT(rcg->hid_width) - 1;
+	mask |= CFG_SRC_SEL_MASK | CFG_MODE_MASK;
+	cfg = f->pre_div << CFG_SRC_DIV_SHIFT;
+	cfg |= rcg->parent_map[f->src] << CFG_SRC_SEL_SHIFT;
+	if (rcg->mnd_width && f->n)
+		cfg |= CFG_MODE_DUAL_EDGE;
+	ret = regmap_update_bits(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, mask,
+			cfg);
+	if (ret)
+		return ret;
+
+	return update_config(rcg);
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
+const struct clk_ops clk_rcg2_ops = {
+	.is_enabled = clk_rcg2_is_enabled,
+	.get_parent = clk_rcg2_get_parent,
+	.set_parent = clk_rcg2_set_parent,
+	.recalc_rate = clk_rcg2_recalc_rate,
+	.determine_rate = clk_rcg2_determine_rate,
+	.set_rate = clk_rcg2_set_rate,
+	.set_rate_and_parent = clk_rcg2_set_rate_and_parent,
+};
+EXPORT_SYMBOL_GPL(clk_rcg2_ops);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

