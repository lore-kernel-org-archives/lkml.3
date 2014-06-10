Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbaFJB3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:29:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26787 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933296AbaFJB2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:28:16 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <mturquette@linaro.org>,
        <chao.xie@marvell.com>, <xiechao_mail@163.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/12] clk: mmp: add device tree support for composite type clock
Date: Tue, 10 Jun 2014 09:27:46 +0800
Message-ID: <1402363668-25806-11-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402363668-25806-1-git-send-email-chao.xie@marvell.com>
References: <1402363668-25806-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_01:2014-06-09,2014-06-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406100017
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

To parse composite clock from device tree file, there are some
rules.
The clock to be composited will be the child of the composite
clock in device tree file.
It can support the composition of (mux,div,gate) clock defined
as common clock and (mix,gate) defined only for MMP series.

Signed-off-by: Chao Xie <chao.xie@marvell.com>

Conflicts:
	drivers/clk/mmp/Makefile
---
 .../devicetree/bindings/clock/mmp/clk-composite    |  58 +++++
 drivers/clk/mmp/Makefile                           |   2 +-
 drivers/clk/mmp/clk-of-composite.c                 | 253 +++++++++++++++++++++
 drivers/clk/mmp/clk.h                              |  14 ++
 4 files changed, 326 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/clk-composite
 create mode 100644 drivers/clk/mmp/clk-of-composite.c

diff --git a/Documentation/devicetree/bindings/clock/mmp/clk-composite b/Documentation/devicetree/bindings/clock/mmp/clk-composite
new file mode 100644
index 0000000..224968c
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/clk-composite
@@ -0,0 +1,58 @@
+Binding for Marvell MMP series composite clock
+
+The common clock defines a general composite clock with div/mux/gate.
+Because MMP series has clock need combines the div/mux together, so
+there is a new type of clock "mix". The "mix" clock can also be
+composited with gate clock. In fact, many mix clocks and gate clocks
+share same registers.
+
+In the device tree file, the clock to be composited should be child
+of the composite clock.
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-composite" for (mix, gate)
+               composition, or "marvell,mmp-clk-general-composite" for
+               (mux, div, gate) composition.
+
+
+Examples
+1. There are three clocks mux1, div1, gate1.
+
+apmu_clk {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xde210000 0x1000>;
+
+	general_composite_clk {
+		compatible = "marvell,mmp-clk-general-composite";
+
+		mux1 {
+			...
+		};
+		div1 {
+			...
+		};
+		gate1 {
+			...
+		};
+	};
+};
+
+2. There are two clocks mix1, gate2
+
+apmu_clk {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xde210000 0x1000>;
+
+	composite_clk {
+		compatible = "marvell,mmp-clk-composite";
+
+		mix1 {
+			...
+		};
+		gate2 {
+			...
+		};
+	};
+};
+
+
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index e8810b6..84dce78 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -6,7 +6,7 @@ obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o	\
 	 clk-mix-composite.o
 
 ifneq ($(CONFIG_OF),)
-obj-y += clk-master-node.o lock.o
+obj-y += clk-master-node.o lock.o clk-of-composite.o
 endif
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
diff --git a/drivers/clk/mmp/clk-of-composite.c b/drivers/clk/mmp/clk-of-composite.c
new file mode 100644
index 0000000..403ebe2
--- /dev/null
+++ b/drivers/clk/mmp/clk-of-composite.c
@@ -0,0 +1,253 @@
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
+struct mmp_clk_composite_member {
+	struct device_node *np;
+	struct clk_hw *hw;
+	const struct clk_ops *ops;
+	int num_parents;
+	const char **parent_names;
+};
+
+struct mmp_clk_composite_node {
+	struct device_node *np;
+	struct mmp_clk_composite_member *members[MMP_CLK_COMPOSITE_TYPE_MAX];
+	struct list_head node;
+};
+
+static LIST_HEAD(composite_list);
+static DEFINE_MUTEX(composite_mutex);
+
+int of_mmp_clk_composite_add_member(struct device_node *np, struct clk_hw *hw,
+				const struct clk_ops *ops, int type)
+{
+	struct device_node *parent_np;
+	struct mmp_clk_composite_node *node;
+	struct mmp_clk_composite_member *member;
+	unsigned int found = 0;
+	size_t size;
+	int i, ret;
+
+	mutex_lock(&composite_mutex);
+
+	parent_np = of_get_next_parent(np);
+
+	list_for_each_entry(node, &composite_list, node) {
+		if (node->np == parent_np) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		pr_err("%s:%s can not find member %s\n",
+			__func__, parent_np->name, np->name);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (node->members[type]) {
+		pr_err("%s:%s already has type %d,when add member %s\n",
+			__func__, parent_np->name, type, np->name);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	member = kzalloc(sizeof(*member), GFP_KERNEL);
+	if (!member) {
+		pr_err("%s:%s failed to allocate member.\n",
+			__func__, parent_np->name);
+		ret = -ENOMEM;
+		goto out;
+	}
+	member->np = np;
+	member->hw = hw;
+	member->ops = ops;
+
+	ret = of_clk_get_parent_count(np);
+	if (ret >= 1) {
+		member->num_parents = ret;
+		size = sizeof(*member->parent_names) * member->num_parents;
+		member->parent_names = kzalloc(size, GFP_KERNEL);
+		if (!member->parent_names) {
+			pr_err("%s:%s failed to allocate parent_names.\n",
+				__func__, parent_np->name);
+			ret = -ENOMEM;
+			goto member_free;
+		}
+		for (i = 0; i < member->num_parents; i++)
+			member->parent_names[i] =
+					of_clk_get_parent_name(np, i);
+	} else {
+		member->num_parents = 0;
+		member->parent_names = NULL;
+	}
+
+	node->members[type] = member;
+
+	ret = 0;
+	goto out;
+
+member_free:
+	kfree(member);
+out:
+	mutex_unlock(&composite_mutex);
+
+	return ret;
+}
+
+static void of_mmp_clk_composite_setup(struct device_node *np)
+{
+	struct mmp_clk_composite_node *node;
+	struct mmp_clk_composite_member *mix, *gate;
+	struct device_node *child;
+	struct clk *clk;
+	const struct of_device_id *match;
+	of_clk_init_cb_t clk_init_cb;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		pr_err("%s:%s failed to allocate node\n", __func__, np->name);
+		return;
+	}
+
+	INIT_LIST_HEAD(&node->node);
+	node->np = np;
+
+	mutex_lock(&composite_mutex);
+	list_add(&node->node, &composite_list);
+	mutex_unlock(&composite_mutex);
+
+	for_each_child_of_node(np, child) {
+		match = of_match_node(&__clk_of_table, child);
+		clk_init_cb = (of_clk_init_cb_t)match->data;
+		clk_init_cb(child);
+	}
+
+	mix = node->members[MMP_CLK_COMPOSITE_TYPE_MUXMIX];
+	gate = node->members[MMP_CLK_COMPOSITE_TYPE_GATE];
+	if (!mix || !gate) {
+		pr_err("%s:%s failed to parse members.\n", __func__, np->name);
+		goto error;
+	}
+
+	clk = mmp_clk_register_composite(NULL, np->name,
+				mix->parent_names, mix->num_parents,
+				mix->hw, mix->ops,
+				gate->hw, gate->ops, 0);
+	if (!IS_ERR(clk))
+		of_clk_add_provider(np, of_clk_src_simple_get, clk);
+
+	return;
+
+error:
+	mutex_lock(&composite_mutex);
+	list_del(&node->node);
+	mutex_unlock(&composite_mutex);
+	kfree(node);
+}
+
+static void of_mmp_clk_general_composite_setup(struct device_node *np)
+{
+	struct mmp_clk_composite_node *node;
+	struct mmp_clk_composite_member *mux, *gate, *div;
+	struct device_node *child;
+	struct clk *clk;
+	const char **parent_names;
+	int num_parents;
+	const struct of_device_id *match;
+	of_clk_init_cb_t clk_init_cb;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		pr_err("%s:%s failed to allocate node\n", __func__, np->name);
+		return;
+	}
+
+	INIT_LIST_HEAD(&node->node);
+	node->np = np;
+
+	mutex_lock(&composite_mutex);
+	list_add(&node->node, &composite_list);
+	mutex_unlock(&composite_mutex);
+
+	for_each_child_of_node(np, child) {
+		match = of_match_node(&__clk_of_table, child);
+		clk_init_cb = (of_clk_init_cb_t)match->data;
+		clk_init_cb(child);
+	}
+
+	mux = node->members[MMP_CLK_COMPOSITE_TYPE_MUXMIX];
+	gate = node->members[MMP_CLK_COMPOSITE_TYPE_GATE];
+	div = node->members[MMP_CLK_COMPOSITE_TYPE_DIV];
+
+	if ((!mux && !div) || (!mux && !gate) || (!gate && !div)) {
+		pr_err("%s:%s failed to parse members.\n", __func__, np->name);
+		goto error;
+	}
+
+	if (mux) {
+		parent_names = mux->parent_names;
+		num_parents = mux->num_parents;
+	} else {
+		parent_names = div->parent_names;
+		num_parents = div->num_parents;
+	}
+
+	clk = clk_register_composite(NULL, np->name,
+				parent_names, num_parents,
+				mux ? mux->hw : NULL, mux ? mux->ops : NULL,
+				div ? div->hw : NULL, div ? div->ops : NULL,
+				gate ? gate->hw : NULL,
+				gate ? gate->ops : NULL, 0);
+	if (!IS_ERR(clk))
+		of_clk_add_provider(np, of_clk_src_simple_get, clk);
+
+	return;
+
+error:
+	mutex_lock(&composite_mutex);
+	list_del(&node->node);
+	mutex_unlock(&composite_mutex);
+	kfree(node);
+}
+
+CLK_OF_DECLARE(mmp_clk_composite, "marvell,mmp-clk-composite",
+		of_mmp_clk_composite_setup);
+CLK_OF_DECLARE(mmp_clk_general_composite, "marvell,mmp-clk-general-composite",
+		of_mmp_clk_general_composite_setup);
+
+int of_mmp_clk_is_composite(struct device_node *np)
+{
+	struct device_node *parent_np;
+	struct mmp_clk_composite_node *node;
+
+	parent_np = of_get_next_parent(np);
+	mutex_lock(&composite_mutex);
+	list_for_each_entry(node, &composite_list, node) {
+		if (node->np == parent_np) {
+			mutex_unlock(&composite_mutex);
+			return 1;
+		}
+	}
+	mutex_unlock(&composite_mutex);
+
+	return 0;
+}
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index e06a228..66d0fd4 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -152,6 +152,20 @@ extern spinlock_t *of_mmp_clk_get_spinlock(struct device_node *np,
 					   unsigned int reg_base);
 
 
+/* DT support for composiste type clock. */
+enum {
+	MMP_CLK_COMPOSITE_TYPE_MUXMIX,
+	MMP_CLK_COMPOSITE_TYPE_DIV,
+	MMP_CLK_COMPOSITE_TYPE_GATE,
+	MMP_CLK_COMPOSITE_TYPE_MAX,
+};
+
+extern int of_mmp_clk_composite_add_member(struct device_node *np,
+				struct clk_hw *hw,
+				const struct clk_ops *ops, int type);
+extern int of_mmp_clk_is_composite(struct device_node *np);
+
+
 extern struct clk *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
 extern struct clk *mmp_clk_register_apbc(const char *name,
-- 
1.8.3.2

