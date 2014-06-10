Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaFJB2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:28:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32978 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933917AbaFJB2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:28:20 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <mturquette@linaro.org>,
        <chao.xie@marvell.com>, <xiechao_mail@163.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/12] clk: mmp: add clock type composite for mix
Date: Tue, 10 Jun 2014 09:27:43 +0800
Message-ID: <1402363668-25806-8-git-send-email-chao.xie@marvell.com>
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

The general composite clock supports div/mux/gate.
marvell SOCes have many clocks that need change
div and mux together. So it need the composite
clock that supports mix/gate.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/Makefile            |   3 +-
 drivers/clk/mmp/clk-mix-composite.c | 195 ++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk.h               |  20 ++++
 3 files changed, 217 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/mmp/clk-mix-composite.c

diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 2855f7b..2cd7d94 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -2,7 +2,8 @@
 # Makefile for mmp specific clk
 #
 
-obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o
+obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o	\
+	 clk-mix-composite.o
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
diff --git a/drivers/clk/mmp/clk-mix-composite.c b/drivers/clk/mmp/clk-mix-composite.c
new file mode 100644
index 0000000..79d5286
--- /dev/null
+++ b/drivers/clk/mmp/clk-mix-composite.c
@@ -0,0 +1,195 @@
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
+
+#include "clk.h"
+
+#define to_clk_composite(_hw) container_of(_hw, struct mmp_clk_composite, hw)
+
+static u8 mmp_clk_composite_get_parent(struct clk_hw *hw)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *mix_ops = composite->mix_ops;
+	struct clk_hw *mix_hw = composite->mix_hw;
+
+	mix_hw->clk = hw->clk;
+
+	return mix_ops->get_parent(mix_hw);
+}
+
+static int mmp_clk_composite_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *mix_ops = composite->mix_ops;
+	struct clk_hw *mix_hw = composite->mix_hw;
+
+	mix_hw->clk = hw->clk;
+
+	return mix_ops->set_parent(mix_hw, index);
+}
+
+static int mmp_clk_composite_set_rate(struct clk_hw *hw, unsigned long rate,
+			       unsigned long parent_rate)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *mix_ops = composite->mix_ops;
+	struct clk_hw *mix_hw = composite->mix_hw;
+
+	mix_hw->clk = hw->clk;
+
+	return mix_ops->set_rate(mix_hw, rate, parent_rate);
+}
+
+static unsigned long mmp_clk_composite_recalc_rate(struct clk_hw *hw,
+					    unsigned long parent_rate)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *mix_ops = composite->mix_ops;
+	struct clk_hw *mix_hw = composite->mix_hw;
+
+	mix_hw->clk = hw->clk;
+
+	return mix_ops->recalc_rate(mix_hw, parent_rate);
+}
+
+static long mmp_clk_composite_determine_rate(struct clk_hw *hw,
+					unsigned long rate,
+					unsigned long *best_parent_rate,
+					struct clk **best_parent_p)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *mix_ops = composite->mix_ops;
+	struct clk_hw *mix_hw = composite->mix_hw;
+
+	mix_hw->clk = hw->clk;
+
+	return mix_ops->determine_rate(mix_hw, rate, best_parent_rate,
+					best_parent_p);
+}
+
+static int mmp_clk_composite_set_rate_and_parent(struct clk_hw *hw,
+					unsigned long rate,
+					unsigned long parent_rate, u8 index)
+
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *mix_ops = composite->mix_ops;
+	struct clk_hw *mix_hw = composite->mix_hw;
+
+	mix_hw->clk = hw->clk;
+
+	return mix_ops->set_rate_and_parent(mix_hw, rate, parent_rate, index);
+}
+
+static int mmp_clk_composite_is_enabled(struct clk_hw *hw)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *gate_ops = composite->gate_ops;
+	struct clk_hw *gate_hw = composite->gate_hw;
+
+	gate_hw->clk = hw->clk;
+
+	return gate_ops->is_enabled(gate_hw);
+}
+
+static int mmp_clk_composite_enable(struct clk_hw *hw)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *gate_ops = composite->gate_ops;
+	struct clk_hw *gate_hw = composite->gate_hw;
+
+	gate_hw->clk = hw->clk;
+
+	return gate_ops->enable(gate_hw);
+}
+
+static void mmp_clk_composite_disable(struct clk_hw *hw)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *gate_ops = composite->gate_ops;
+	struct clk_hw *gate_hw = composite->gate_hw;
+
+	gate_hw->clk = hw->clk;
+
+	gate_ops->disable(gate_hw);
+}
+
+static void mmp_clk_composite_init(struct clk_hw *hw)
+{
+	struct mmp_clk_composite *composite = to_clk_composite(hw);
+	const struct clk_ops *gate_ops = composite->gate_ops;
+	struct clk_hw *gate_hw = composite->gate_hw;
+	const struct clk_ops *mix_ops = composite->mix_ops;
+	struct clk_hw *mix_hw = composite->mix_hw;
+
+	mix_hw->clk = hw->clk;
+	gate_hw->clk = hw->clk;
+
+	if (mix_ops->init)
+		mix_ops->init(mix_hw);
+	if (gate_ops->init)
+		gate_ops->init(gate_hw);
+}
+
+static struct clk_ops mmp_clk_composite_ops = {
+	.enable = mmp_clk_composite_enable,
+	.disable = mmp_clk_composite_disable,
+	.is_enabled = mmp_clk_composite_is_enabled,
+	.determine_rate = mmp_clk_composite_determine_rate,
+	.set_rate_and_parent = mmp_clk_composite_set_rate_and_parent,
+	.set_rate = mmp_clk_composite_set_rate,
+	.recalc_rate = mmp_clk_composite_recalc_rate,
+	.get_parent = mmp_clk_composite_get_parent,
+	.set_parent = mmp_clk_composite_set_parent,
+	.init = mmp_clk_composite_init,
+};
+
+struct clk *mmp_clk_register_composite(struct device *dev, const char *name,
+			const char **parent_names, int num_parents,
+			struct clk_hw *mix_hw, const struct clk_ops *mix_ops,
+			struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
+			unsigned long flags)
+{
+	struct clk *clk;
+	struct clk_init_data init;
+	struct mmp_clk_composite *composite;
+
+	if (!mix_hw || !gate_hw)
+		return ERR_PTR(-EINVAL);
+
+	composite = kzalloc(sizeof(*composite), GFP_KERNEL);
+	if (!composite) {
+		pr_err("%s: could not allocate mmp composite clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.flags = flags;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+	init.ops = &mmp_clk_composite_ops;
+
+	composite->mix_hw = mix_hw;
+	composite->mix_ops = mix_ops;
+	composite->gate_hw = gate_hw;
+	composite->gate_ops = gate_ops;
+	composite->hw.init = &init;
+
+	clk = clk_register(dev, &composite->hw);
+	if (IS_ERR(clk))
+		kfree(composite);
+
+	return clk;
+}
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index 9096f0a..9827a4f 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -120,6 +120,26 @@ extern struct clk *mmp_clk_register_gate(struct device *dev, const char *name,
 			spinlock_t *lock);
 
 
+/* Clock type "composite" for mix clock */
+struct mmp_clk_composite {
+	struct clk_hw hw;
+	struct clk_ops ops;
+
+	struct clk_hw *mix_hw;
+	struct clk_hw *gate_hw;
+
+	const struct clk_ops *mix_ops;
+	const struct clk_ops *gate_ops;
+};
+
+extern struct clk *mmp_clk_register_composite(struct device *dev,
+			const char *name,
+			const char **parent_names, int num_parents,
+			struct clk_hw *mix_hw, const struct clk_ops *mix_ops,
+			struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
+			unsigned long flags);
+
+
 extern struct clk *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
 extern struct clk *mmp_clk_register_apbc(const char *name,
-- 
1.8.3.2

