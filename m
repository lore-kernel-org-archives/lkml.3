Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbaHZElc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:41:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2659 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044AbaHZEhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:38 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/12] clk: mmp: add clock type mix
Date: Tue, 26 Aug 2014 12:38:17 +0800
Message-ID: <1409027904-21859-6-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_02:2014-08-25,2014-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408260059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

The clock type mix is a kind of clock combines "div" and "mux".
This kind of clock can not allow to change div first then
mux or change mux first or div.
The reason is
1. Some clock has frequency change bit. Each time want to change
   the frequency, there are some operations based on this bit, and
   these operations are time-cost.
   Seperating div and mux change will make the process longer, and
   waste more time.
2. Seperting the div and mux may generate middle clock that the
   peripharals do not support. It may make the peripharals hang.

There are three kinds of this type of clock in all SOCes.
1. The clock has bit to trigger the frequency change.
2. Same as #1, but the operations for the bit is different
3. Do not have frequency change bit.

So this type of clock has implemented the callbacks
->determine_rate
->set_rate_and_parent
These callbacks can help to change the div and mux together.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/Makefile  |   2 +-
 drivers/clk/mmp/clk-mix.c | 513 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk.h     |  66 ++++++
 3 files changed, 580 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/mmp/clk-mix.c

diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 392d780..8bfee860 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -2,7 +2,7 @@
 # Makefile for mmp specific clk
 #
 
-obj-y += clk-apbc.o clk-apmu.o clk-frac.o
+obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
diff --git a/drivers/clk/mmp/clk-mix.c b/drivers/clk/mmp/clk-mix.c
new file mode 100644
index 0000000..b79742c
--- /dev/null
+++ b/drivers/clk/mmp/clk-mix.c
@@ -0,0 +1,513 @@
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
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+
+#include "clk.h"
+
+/*
+ * The mix clock is a clock combined mux and div type clock.
+ * Because the div field and mux field need to be set at same
+ * time, we can not divide it into 2 types of clock
+ */
+
+#define to_clk_mix(hw)	container_of(hw, struct mmp_clk_mix, hw)
+
+static unsigned int _get_maxdiv(struct mmp_clk_mix *mix)
+{
+	unsigned int div_mask = (1 << mix->reg_info.width_div) - 1;
+	unsigned int maxdiv = 0;
+	struct clk_div_table *clkt;
+
+	if (mix->div_flags & CLK_DIVIDER_ONE_BASED)
+		return div_mask;
+	if (mix->div_flags & CLK_DIVIDER_POWER_OF_TWO)
+		return 1 << div_mask;
+	if (mix->div_table) {
+		for (clkt = mix->div_table; clkt->div; clkt++)
+			if (clkt->div > maxdiv)
+				maxdiv = clkt->div;
+		return maxdiv;
+	}
+	return div_mask + 1;
+}
+
+static unsigned int _get_div(struct mmp_clk_mix *mix, unsigned int val)
+{
+	struct clk_div_table *clkt;
+
+	if (mix->div_flags & CLK_DIVIDER_ONE_BASED)
+		return val;
+	if (mix->div_flags & CLK_DIVIDER_POWER_OF_TWO)
+		return 1 << val;
+	if (mix->div_table) {
+		for (clkt = mix->div_table; clkt->div; clkt++)
+			if (clkt->val == val)
+				return clkt->div;
+		if (clkt->div == 0)
+			return 0;
+	}
+	return val + 1;
+}
+
+static unsigned int _get_mux(struct mmp_clk_mix *mix, unsigned int val)
+{
+	int num_parents = __clk_get_num_parents(mix->hw.clk);
+	int i;
+
+	if (mix->mux_flags & CLK_MUX_INDEX_BIT)
+		return ffs(val) - 1;
+	if (mix->mux_flags & CLK_MUX_INDEX_ONE)
+		return val - 1;
+	if (mix->mux_table) {
+		for (i = 0; i < num_parents; i++)
+			if (mix->mux_table[i] == val)
+				return i;
+		if (i == num_parents)
+			return 0;
+	}
+
+	return val;
+}
+static unsigned int _get_div_val(struct mmp_clk_mix *mix, unsigned int div)
+{
+	struct clk_div_table *clkt;
+
+	if (mix->div_flags & CLK_DIVIDER_ONE_BASED)
+		return div;
+	if (mix->div_flags & CLK_DIVIDER_POWER_OF_TWO)
+		return __ffs(div);
+	if (mix->div_table) {
+		for (clkt = mix->div_table; clkt->div; clkt++)
+			if (clkt->div == div)
+				return clkt->val;
+		if (clkt->div == 0)
+			return 0;
+	}
+
+	return div - 1;
+}
+
+static unsigned int _get_mux_val(struct mmp_clk_mix *mix, unsigned int mux)
+{
+	if (mix->mux_table)
+		return mix->mux_table[mux];
+
+	return mux;
+}
+
+static void _filter_clk_table(struct mmp_clk_mix *mix,
+				struct mmp_clk_mix_clk_table *table,
+				unsigned int table_size)
+{
+	int i;
+	struct mmp_clk_mix_clk_table *item;
+	struct clk *parent, *clk;
+	unsigned long parent_rate;
+
+	clk = mix->hw.clk;
+
+	for (i = 0; i < table_size; i++) {
+		item = &table[i];
+		parent = clk_get_parent_by_index(clk, item->parent_index);
+		parent_rate = __clk_get_rate(parent);
+		if (parent_rate % item->rate) {
+			item->valid = 0;
+		} else {
+			item->divisor = parent_rate / item->rate;
+			item->valid = 1;
+		}
+	}
+}
+
+static int _set_rate(struct mmp_clk_mix *mix, u32 mux_val, u32 div_val,
+			unsigned int change_mux, unsigned int change_div)
+{
+	struct mmp_clk_mix_reg_info *ri = &mix->reg_info;
+	u8 width, shift;
+	u32 mux_div, fc_req;
+	int ret, timeout = 50;
+	unsigned long flags = 0;
+
+	if (!change_mux && !change_div)
+		return -EINVAL;
+
+	if (mix->lock)
+		spin_lock_irqsave(mix->lock, flags);
+
+	if (mix->type == MMP_CLK_MIX_TYPE_V1
+		|| mix->type == MMP_CLK_MIX_TYPE_V2)
+		mux_div = readl(ri->reg_clk_ctrl);
+	else
+		mux_div = readl(ri->reg_clk_sel);
+
+	if (change_div) {
+		width = ri->width_div;
+		shift = ri->shift_div;
+		mux_div &= ~MMP_CLK_BITS_MASK(width, shift);
+		mux_div |= MMP_CLK_BITS_SET_VAL(div_val, width, shift);
+	}
+
+	if (change_mux) {
+		width = ri->width_mux;
+		shift = ri->shift_mux;
+		mux_div &= ~MMP_CLK_BITS_MASK(width, shift);
+		mux_div |= MMP_CLK_BITS_SET_VAL(mux_val, width, shift);
+	}
+
+	if (mix->type == MMP_CLK_MIX_TYPE_V1) {
+		writel(mux_div, ri->reg_clk_ctrl);
+	} else if (mix->type == MMP_CLK_MIX_TYPE_V2) {
+		mux_div |= (1 << ri->bit_fc);
+		writel(mux_div, ri->reg_clk_ctrl);
+
+		do {
+			fc_req = readl(ri->reg_clk_ctrl);
+			timeout--;
+			if (!(fc_req & (1 << ri->bit_fc)))
+				break;
+		} while (timeout);
+
+		if (timeout == 0) {
+			pr_err("%s:%s cannot do frequency change\n",
+				__func__, __clk_get_name(mix->hw.clk));
+			ret = -EBUSY;
+			goto error;
+		}
+	} else {
+		fc_req = readl(ri->reg_clk_ctrl);
+		fc_req |= 1 << ri->bit_fc;
+		writel(fc_req, ri->reg_clk_ctrl);
+		writel(mux_div, ri->reg_clk_sel);
+		fc_req &= ~(1 << ri->bit_fc);
+	}
+
+	ret = 0;
+error:
+	if (mix->lock)
+		spin_unlock_irqrestore(mix->lock, flags);
+
+	return ret;
+}
+
+static long mmp_clk_mix_determine_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long *best_parent_rate,
+					struct clk **best_parent_clk)
+{
+	struct mmp_clk_mix *mix = to_clk_mix(hw);
+	struct mmp_clk_mix_clk_table *item;
+	struct clk *parent, *parent_best, *mix_clk;
+	unsigned long parent_rate, mix_rate, mix_rate_best, parent_rate_best;
+	unsigned long gap, gap_best;
+	u32 div_val_max;
+	unsigned int div;
+	int i, j;
+
+	mix_clk = hw->clk;
+
+	parent = NULL;
+	mix_rate_best = 0;
+	parent_rate_best = 0;
+	gap_best = rate;
+	parent_best = NULL;
+
+	if (mix->table) {
+		for (i = 0; i < mix->table_size; i++) {
+			item = &mix->table[i];
+			if (item->valid == 0)
+				continue;
+			parent = clk_get_parent_by_index(mix_clk,
+							item->parent_index);
+			parent_rate = __clk_get_rate(parent);
+			mix_rate = parent_rate / item->divisor;
+			gap = abs(mix_rate - rate);
+			if (parent_best == NULL || gap < gap_best) {
+				parent_best = parent;
+				parent_rate_best = parent_rate;
+				mix_rate_best = mix_rate;
+				gap_best = gap;
+				if (gap_best == 0)
+					goto found;
+			}
+		}
+	} else {
+		for (i = 0; i < __clk_get_num_parents(mix_clk); i++) {
+			parent = clk_get_parent_by_index(mix_clk, i);
+			parent_rate = __clk_get_rate(parent);
+			div_val_max = _get_maxdiv(mix);
+			for (j = 0; j < div_val_max; j++) {
+				div = _get_div(mix, j);
+				mix_rate = parent_rate / div;
+				gap = abs(mix_rate - rate);
+				if (parent_best == NULL || gap < gap_best) {
+					parent_best = parent;
+					parent_rate_best = parent_rate;
+					mix_rate_best = mix_rate;
+					gap_best = gap;
+					if (gap_best == 0)
+						goto found;
+				}
+			}
+		}
+	}
+
+found:
+	*best_parent_rate = parent_rate_best;
+	*best_parent_clk = parent_best;
+
+	return mix_rate_best;
+}
+
+static int mmp_clk_mix_set_rate_and_parent(struct clk_hw *hw,
+						unsigned long rate,
+						unsigned long parent_rate,
+						u8 index)
+{
+	struct mmp_clk_mix *mix = to_clk_mix(hw);
+	unsigned int div;
+	u32 div_val, mux_val;
+
+	div = parent_rate / rate;
+	div_val = _get_div_val(mix, div);
+	mux_val = _get_mux_val(mix, index);
+
+	return _set_rate(mix, mux_val, div_val, 1, 1);
+}
+
+static u8 mmp_clk_mix_get_parent(struct clk_hw *hw)
+{
+	struct mmp_clk_mix *mix = to_clk_mix(hw);
+	struct mmp_clk_mix_reg_info *ri = &mix->reg_info;
+	unsigned long flags = 0;
+	u32 mux_div = 0;
+	u8 width, shift;
+	u32 mux_val;
+
+	if (mix->lock)
+		spin_lock_irqsave(mix->lock, flags);
+
+	if (mix->type == MMP_CLK_MIX_TYPE_V1
+		|| mix->type == MMP_CLK_MIX_TYPE_V2)
+		mux_div = readl(ri->reg_clk_ctrl);
+	else
+		mux_div = readl(ri->reg_clk_sel);
+
+	if (mix->lock)
+		spin_unlock_irqrestore(mix->lock, flags);
+
+	width = mix->reg_info.width_mux;
+	shift = mix->reg_info.shift_mux;
+
+	mux_val = MMP_CLK_BITS_GET_VAL(mux_div, width, shift);
+
+	return _get_mux(mix, mux_val);
+}
+
+static unsigned long mmp_clk_mix_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	struct mmp_clk_mix *mix = to_clk_mix(hw);
+	struct mmp_clk_mix_reg_info *ri = &mix->reg_info;
+	unsigned long flags = 0;
+	u32 mux_div = 0;
+	u8 width, shift;
+	unsigned int div;
+
+	if (mix->lock)
+		spin_lock_irqsave(mix->lock, flags);
+
+	if (mix->type == MMP_CLK_MIX_TYPE_V1
+		|| mix->type == MMP_CLK_MIX_TYPE_V2)
+		mux_div = readl(ri->reg_clk_ctrl);
+	else
+		mux_div = readl(ri->reg_clk_sel);
+
+	if (mix->lock)
+		spin_unlock_irqrestore(mix->lock, flags);
+
+	width = mix->reg_info.width_div;
+	shift = mix->reg_info.shift_div;
+
+	div = _get_div(mix, MMP_CLK_BITS_GET_VAL(mux_div, width, shift));
+
+	return parent_rate / div;
+}
+
+static int mmp_clk_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct mmp_clk_mix *mix = to_clk_mix(hw);
+	struct mmp_clk_mix_clk_table *item;
+	int i;
+	u32 div_val, mux_val;
+
+	if (mix->table) {
+		for (i = 0; i < mix->table_size; i++) {
+			item = &mix->table[i];
+			if (item->valid == 0)
+				continue;
+			if (item->parent_index == index)
+				break;
+		}
+		if (i < mix->table_size) {
+			div_val = _get_div_val(mix, item->divisor);
+			mux_val = _get_mux_val(mix, item->parent_index);
+		} else
+			return -EINVAL;
+	} else {
+		mux_val = _get_mux_val(mix, index);
+		div_val = 0;
+	}
+
+	return _set_rate(mix, mux_val, div_val, 1, div_val ? 1 : 0);
+}
+
+static int mmp_clk_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long best_parent_rate)
+{
+	struct mmp_clk_mix *mix = to_clk_mix(hw);
+	struct mmp_clk_mix_clk_table *item;
+	unsigned long parent_rate;
+	unsigned int best_divisor;
+	struct clk *mix_clk, *parent;
+	int i;
+
+	best_divisor = best_parent_rate / rate;
+
+	mix_clk = hw->clk;
+	if (mix->table) {
+		for (i = 0; i < mix->table_size; i++) {
+			item = &mix->table[i];
+			if (item->valid == 0)
+				continue;
+			parent = clk_get_parent_by_index(mix_clk,
+							item->parent_index);
+			parent_rate = __clk_get_rate(parent);
+			if (parent_rate == best_parent_rate
+				&& item->divisor == best_divisor)
+				break;
+		}
+		if (i < mix->table_size)
+			return _set_rate(mix,
+					_get_mux_val(mix, item->parent_index),
+					_get_div_val(mix, item->divisor),
+					1, 1);
+		else
+			return -EINVAL;
+	} else {
+		for (i = 0; i < __clk_get_num_parents(mix_clk); i++) {
+			parent = clk_get_parent_by_index(mix_clk, i);
+			parent_rate = __clk_get_rate(parent);
+			if (parent_rate == best_parent_rate)
+				break;
+		}
+		if (i < __clk_get_num_parents(mix_clk))
+			return _set_rate(mix, _get_mux_val(mix, i),
+					_get_div_val(mix, best_divisor), 1, 1);
+		else
+			return -EINVAL;
+	}
+}
+
+static void mmp_clk_mix_init(struct clk_hw *hw)
+{
+	struct mmp_clk_mix *mix = to_clk_mix(hw);
+
+	if (mix->table)
+		_filter_clk_table(mix, mix->table, mix->table_size);
+}
+
+const struct clk_ops mmp_clk_mix_ops = {
+	.determine_rate = mmp_clk_mix_determine_rate,
+	.set_rate_and_parent = mmp_clk_mix_set_rate_and_parent,
+	.set_rate = mmp_clk_set_rate,
+	.set_parent = mmp_clk_set_parent,
+	.get_parent = mmp_clk_mix_get_parent,
+	.recalc_rate = mmp_clk_mix_recalc_rate,
+	.init = mmp_clk_mix_init,
+};
+
+struct clk *mmp_clk_register_mix(struct device *dev,
+					const char *name,
+					const char **parent_names,
+					u8 num_parents,
+					unsigned long flags,
+					struct mmp_clk_mix_config *config,
+					spinlock_t *lock)
+{
+	struct mmp_clk_mix *mix;
+	struct clk *clk;
+	struct clk_init_data init;
+	size_t table_bytes;
+
+	mix = kzalloc(sizeof(*mix), GFP_KERNEL);
+	if (!mix) {
+		pr_err("%s:%s: could not allocate mmp mix clk\n",
+			__func__, name);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.flags = flags | CLK_GET_RATE_NOCACHE;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.ops = &mmp_clk_mix_ops;
+
+	memcpy(&mix->reg_info, &config->reg_info, sizeof(config->reg_info));
+	if (config->table) {
+		table_bytes = sizeof(*config->table) * config->table_size;
+		mix->table = kzalloc(table_bytes, GFP_KERNEL);
+		if (!mix->table) {
+			pr_err("%s:%s: could not allocate mmp mix table\n",
+				__func__, name);
+			kfree(mix);
+			return ERR_PTR(-ENOMEM);
+		}
+		memcpy(mix->table, config->table, table_bytes);
+		mix->table_size = config->table_size;
+	}
+
+	if (config->mux_table) {
+		table_bytes = sizeof(u32) * num_parents;
+		mix->mux_table = kzalloc(table_bytes, GFP_KERNEL);
+		if (!mix->mux_table) {
+			pr_err("%s:%s: could not allocate mmp mix mux-table\n",
+				__func__, name);
+			kfree(mix->table);
+			kfree(mix);
+			return ERR_PTR(-ENOMEM);
+		}
+		memcpy(mix->mux_table, config->mux_table, table_bytes);
+	}
+
+	mix->div_flags = config->div_flags;
+	mix->mux_flags = config->mux_flags;
+	mix->lock = lock;
+	mix->hw.init = &init;
+
+	if (config->reg_info.bit_fc >= 32)
+		mix->type = MMP_CLK_MIX_TYPE_V1;
+	else if (config->reg_info.reg_clk_sel)
+		mix->type = MMP_CLK_MIX_TYPE_V3;
+	else
+		mix->type = MMP_CLK_MIX_TYPE_V2;
+	clk = clk_register(dev, &mix->hw);
+
+	if (IS_ERR(clk)) {
+		kfree(mix->mux_table);
+		kfree(mix->table);
+		kfree(mix);
+	}
+
+	return clk;
+}
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index d267639..26b2469 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -37,6 +37,72 @@ extern struct clk *mmp_clk_register_factor(const char *name,
 		struct mmp_clk_factor_tbl *ftbl, unsigned int ftbl_cnt,
 		spinlock_t *lock);
 
+/* Clock type "mix" */
+#define MMP_CLK_BITS_MASK(width, shift)			\
+		(((1 << (width)) - 1) << (shift))
+#define MMP_CLK_BITS_GET_VAL(data, width, shift)	\
+		((data & MMP_CLK_BITS_MASK(width, shift)) >> (shift))
+#define MMP_CLK_BITS_SET_VAL(val, width, shift)		\
+		(((val) << (shift)) & MMP_CLK_BITS_MASK(width, shift))
+
+enum {
+	MMP_CLK_MIX_TYPE_V1,
+	MMP_CLK_MIX_TYPE_V2,
+	MMP_CLK_MIX_TYPE_V3,
+};
+
+/* The register layout */
+struct mmp_clk_mix_reg_info {
+	void __iomem *reg_clk_ctrl;
+	void __iomem *reg_clk_sel;
+	u8 width_div;
+	u8 shift_div;
+	u8 width_mux;
+	u8 shift_mux;
+	u8 bit_fc;
+};
+
+/* The suggested clock table from user. */
+struct mmp_clk_mix_clk_table {
+	unsigned long rate;
+	u8 parent_index;
+	unsigned int divisor;
+	unsigned int valid;
+};
+
+struct mmp_clk_mix_config {
+	struct mmp_clk_mix_reg_info reg_info;
+	struct mmp_clk_mix_clk_table *table;
+	unsigned int table_size;
+	u32 *mux_table;
+	struct clk_div_table *div_table;
+	u8 div_flags;
+	u8 mux_flags;
+};
+
+struct mmp_clk_mix {
+	struct clk_hw hw;
+	struct mmp_clk_mix_reg_info reg_info;
+	struct mmp_clk_mix_clk_table *table;
+	u32 *mux_table;
+	struct clk_div_table *div_table;
+	unsigned int table_size;
+	u8 div_flags;
+	u8 mux_flags;
+	unsigned int type;
+	spinlock_t *lock;
+};
+
+extern const struct clk_ops mmp_clk_mix_ops;
+extern struct clk *mmp_clk_register_mix(struct device *dev,
+					const char *name,
+					u8 num_parents,
+					const char **parent_names,
+					unsigned long flags,
+					struct mmp_clk_mix_config *config,
+					spinlock_t *lock);
+
+
 extern struct clk *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
 extern struct clk *mmp_clk_register_apbc(const char *name,
-- 
1.8.3.2

