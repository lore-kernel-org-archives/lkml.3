Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaHZEjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:39:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64691 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932580AbaHZEho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:44 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/12] clk: mmp: add mmp private gate clock
Date: Tue, 26 Aug 2014 12:38:18 +0800
Message-ID: <1409027904-21859-7-git-send-email-chao.xie@marvell.com>
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

Some SOCes have this kind of the gate clock
1. There are some bits to control the gate not only one bit.
2. Some clocks has operations of "out of reset" and "enable".
   To enable clock, we need do "out of reset" and "enable".
   To disable clock, we may not need "set to reset". It depends
   on the SOCes' design.
3. It is not always that "1" is to enable while "0" is to disable
   when write register.

So we have to define the "mask", "enable_val", "disable_val" for
this kind of gate clock.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/Makefile   |   2 +-
 drivers/clk/mmp/clk-gate.c | 133 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/mmp/clk.h      |  21 +++++++
 3 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/mmp/clk-gate.c

diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 8bfee860..2855f7b 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -2,7 +2,7 @@
 # Makefile for mmp specific clk
 #
 
-obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o
+obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
diff --git a/drivers/clk/mmp/clk-gate.c b/drivers/clk/mmp/clk-gate.c
new file mode 100644
index 0000000..adbd9d6
--- /dev/null
+++ b/drivers/clk/mmp/clk-gate.c
@@ -0,0 +1,133 @@
+/*
+ * mmp gate clock operation source file
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
+#include <linux/delay.h>
+
+#include "clk.h"
+
+/*
+ * Some clocks will have mutiple bits to enable the clocks, and
+ * the bits to disable the clock is not same as enabling bits.
+ */
+
+#define to_clk_mmp_gate(hw)	container_of(hw, struct mmp_clk_gate, hw)
+
+static int mmp_clk_gate_enable(struct clk_hw *hw)
+{
+	struct mmp_clk_gate *gate = to_clk_mmp_gate(hw);
+	struct clk *clk = hw->clk;
+	unsigned long flags = 0;
+	unsigned long rate;
+	u32 tmp;
+
+	if (gate->lock)
+		spin_lock_irqsave(gate->lock, flags);
+
+	tmp = readl(gate->reg);
+	tmp &= ~gate->mask;
+	tmp |= gate->val_enable;
+	writel(tmp, gate->reg);
+
+	if (gate->lock)
+		spin_unlock_irqrestore(gate->lock, flags);
+
+	if (gate->flags & MMP_CLK_GATE_NEED_DELAY) {
+		rate = __clk_get_rate(clk);
+		/* Need delay 2 cycles. */
+		udelay(2000000/rate);
+	}
+
+	return 0;
+}
+
+static void mmp_clk_gate_disable(struct clk_hw *hw)
+{
+	struct mmp_clk_gate *gate = to_clk_mmp_gate(hw);
+	unsigned long flags = 0;
+	u32 tmp;
+
+	if (gate->lock)
+		spin_lock_irqsave(gate->lock, flags);
+
+	tmp = readl(gate->reg);
+	tmp &= ~gate->mask;
+	tmp |= gate->val_disable;
+	writel(tmp, gate->reg);
+
+	if (gate->lock)
+		spin_unlock_irqrestore(gate->lock, flags);
+}
+
+static int mmp_clk_gate_is_enabled(struct clk_hw *hw)
+{
+	struct mmp_clk_gate *gate = to_clk_mmp_gate(hw);
+	unsigned long flags = 0;
+	u32 tmp;
+
+	if (gate->lock)
+		spin_lock_irqsave(gate->lock, flags);
+
+	tmp = readl(gate->reg);
+
+	if (gate->lock)
+		spin_unlock_irqrestore(gate->lock, flags);
+
+	return (tmp & gate->mask) == gate->val_enable;
+}
+
+const struct clk_ops mmp_clk_gate_ops = {
+	.enable = mmp_clk_gate_enable,
+	.disable = mmp_clk_gate_disable,
+	.is_enabled = mmp_clk_gate_is_enabled,
+};
+
+struct clk *mmp_clk_register_gate(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u32 mask, u32 val_enable, u32 val_disable,
+		unsigned int gate_flags, spinlock_t *lock)
+{
+	struct mmp_clk_gate *gate;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the gate */
+	gate = kzalloc(sizeof(*gate), GFP_KERNEL);
+	if (!gate) {
+		pr_err("%s:%s could not allocate gate clk\n", __func__, name);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.ops = &mmp_clk_gate_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_gate assignments */
+	gate->reg = reg;
+	gate->mask = mask;
+	gate->val_enable = val_enable;
+	gate->val_disable = val_disable;
+	gate->flags = gate_flags;
+	gate->lock = lock;
+	gate->hw.init = &init;
+
+	clk = clk_register(dev, &gate->hw);
+
+	if (IS_ERR(clk))
+		kfree(gate);
+
+	return clk;
+}
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index 26b2469..2337106 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -103,6 +103,27 @@ extern struct clk *mmp_clk_register_mix(struct device *dev,
 					spinlock_t *lock);
 
 
+/* Clock type "gate". MMP private gate */
+#define MMP_CLK_GATE_NEED_DELAY		BIT(0)
+
+struct mmp_clk_gate {
+	struct clk_hw hw;
+	void __iomem *reg;
+	u32 mask;
+	u32 val_enable;
+	u32 val_disable;
+	unsigned int flags;
+	spinlock_t *lock;
+};
+
+extern const struct clk_ops mmp_clk_gate_ops;
+extern struct clk *mmp_clk_register_gate(struct device *dev, const char *name,
+			const char *parent_name, unsigned long flags,
+			void __iomem *reg, u32 mask, u32 val_enable,
+			u32 val_disable, unsigned int gate_flags,
+			spinlock_t *lock);
+
+
 extern struct clk *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
 extern struct clk *mmp_clk_register_apbc(const char *name,
-- 
1.8.3.2

