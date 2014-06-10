Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbaFJB2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:28:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39441 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbaFJB2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:28:15 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <mturquette@linaro.org>,
        <chao.xie@marvell.com>, <xiechao_mail@163.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/12] clk: mmp: add clock type master
Date: Tue, 10 Jun 2014 09:27:44 +0800
Message-ID: <1402363668-25806-9-git-send-email-chao.xie@marvell.com>
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

To support device tree for clock, we need pass the register
base and range to the clock.
There are many clock share same range of registers.
For example, clk1 has register as 0xd4210010 while clk2
has 0xd42100c0. If we map the register seperately. There
will waste some space. If there are many clocks like that,
the waste will be huge.
clock type "master node" will map the register for all clocks
that listed as its child in DT file. Each clock will invoke
the APIs provided by "master node" to get its register base.
The following is a exmaple of master clock usage in DT file

apmu_clocks {
	compatible = "marvell,mmp-clk-master";
	reg = <0xd4210000 0x1000>;

	ck1 {
		marvell,reg-offset = <0 0x10>;
	};

	clk2 {
		marvell,reg-offset = <0 0xc0>;
	};
}

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 .../devicetree/bindings/clock/mmp/clk-master       |  47 +++++
 drivers/clk/mmp/Makefile                           |   4 +
 drivers/clk/mmp/clk-master-node.c                  | 195 +++++++++++++++++++++
 drivers/clk/mmp/clk.h                              |   7 +
 4 files changed, 253 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/clk-master
 create mode 100644 drivers/clk/mmp/clk-master-node.c

diff --git a/Documentation/devicetree/bindings/clock/mmp/clk-master b/Documentation/devicetree/bindings/clock/mmp/clk-master
new file mode 100644
index 0000000..b6acde1
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/clk-master
@@ -0,0 +1,47 @@
+Binding for Marvell MMP series master clock.
+
+The MMP related device tree support for clock based on the clock type not clock
+controller. So specific SOC, user need define the DT file for the clock such as
+pxa910-clock.dtsi.
+
+Almost all types of clock will need parameter as "register", and it will map the
+"register" before access it. If every clock map the "register" seperately, there
+will be a lot of waste.
+
+A master clock is defined for this kind of situation. It will be responsible for
+map the registers for all clocks that lists as its children in DT file.
+
+Required properties
+- compatible : It should be "marvell,mmp-clk-master".
+
+
+Optional properties:
+- reg : The register start and range the master clock covered.
+
+Optional properties for child node:
+- marvell,reg-offset : It is a two-values item - <register_index regiser_offset>.
+                   Master node will map the registers for all its children. So
+                   for the child it need to pass the information about register
+                   index and offset. "register_index" indicates which register space
+                   it from because master clock can have mutiple register space in
+                   "reg". "register_offset" indicates the offset in the register
+                   space.
+
+Examples
+There are two clocks, clk1 has register at 0xd4210010, and clk2 has register at
+0xd42100c0.
+
+apmu_clk {
+	compatible = "marvell,mmp-clk-master";
+	reg = <0xd4210000 0x1000>;
+
+	clk1 {
+		...
+		marvell,reg-offset = <0 0x10>;
+	};
+
+	clk2 {
+		...
+		marvell,reg-offset = <0 0xc0>;
+	};
+};
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 2cd7d94..518931e 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -5,6 +5,10 @@
 obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o	\
 	 clk-mix-composite.o
 
+ifneq ($(CONFIG_OF),)
+obj-y += clk-master-node.o
+endif
+
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
 obj-$(CONFIG_CPU_MMP2) += clk-mmp2.o
diff --git a/drivers/clk/mmp/clk-master-node.c b/drivers/clk/mmp/clk-master-node.c
new file mode 100644
index 0000000..584f72f
--- /dev/null
+++ b/drivers/clk/mmp/clk-master-node.c
@@ -0,0 +1,195 @@
+/*
+ * mmp master clock source file
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
+#include <linux/of_address.h>
+#include <linux/ioport.h>
+
+#include "clk.h"
+
+#define MAX_REG		8
+
+struct mmp_clk_master_node {
+	unsigned int reg_base[MAX_REG];
+	void __iomem *reg[MAX_REG];
+	struct device_node *np;
+	struct list_head node;
+};
+
+static LIST_HEAD(master_list);
+static DEFINE_MUTEX(master_mutex);
+
+static void mmp_clk_master_setup(struct device_node *np)
+{
+	struct mmp_clk_master_node *node;
+	struct resource res;
+	int i, ret;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		pr_err("%s:%s failed to allocate master node.\n",
+			__func__, np->name);
+		return;
+	}
+
+	for (i = 0; i < MAX_REG; i++) {
+		ret = of_address_to_resource(np, i, &res);
+		if (ret)
+			break;
+		node->reg_base[i] = res.start;
+		node->reg[i] = ioremap(res.start, resource_size(&res));
+		if (!node->reg[i]) {
+			pr_err("%s:%s failed to map register.\n",
+				__func__, np->name);
+			goto error;
+		}
+	}
+
+	node->np = np;
+	INIT_LIST_HEAD(&node->node);
+
+	mutex_lock(&master_mutex);
+
+	list_add(&node->node, &master_list);
+
+	mutex_unlock(&master_mutex);
+
+	return;
+error:
+	for (i--; i >= 0; i--)
+		iounmap(node->reg[i]);
+
+	kfree(node);
+}
+
+struct of_device_id mmp_clk_master_of_id[] = {
+	{
+		.compatible = "marvell,mmp-clk-master",
+		.data = mmp_clk_master_setup,
+	},
+	{ },
+};
+
+static struct mmp_clk_master_node *get_master_node(struct device_node *child)
+{
+	struct device_node *master;
+	struct mmp_clk_master_node *node;
+
+	/* Find the master device node */
+	master = child;
+	do {
+		master = of_get_next_parent(master);
+	} while (!of_match_node(mmp_clk_master_of_id, master));
+
+	mutex_lock(&master_mutex);
+
+	list_for_each_entry(node, &master_list, node) {
+		if (node->np == master) {
+			mutex_unlock(&master_mutex);
+			return node;
+		}
+	}
+
+	mutex_unlock(&master_mutex);
+
+	return NULL;
+}
+
+static void __iomem *get_child_reg(struct device_node *child,
+				unsigned int reg_index,
+				unsigned int *reg_base)
+{
+	struct mmp_clk_master_node *node;
+
+	if (reg_index >= MAX_REG) {
+		pr_err("%s:%s reg_index too big.\n", __func__, child->name);
+		return NULL;
+	}
+
+	node = get_master_node(child);
+	if (!node) {
+		pr_err("%s:%s failed to get master node\n",
+			__func__, child->name);
+		return NULL;
+	}
+
+	*reg_base = node->reg_base[reg_index];
+
+	return node->reg[reg_index];
+}
+
+void __iomem *of_mmp_clk_get_reg(struct device_node *np,
+					unsigned int index,
+					unsigned int *reg_phys)
+{
+	const __be32 *prop;
+	unsigned int proplen, size;
+	u32 reg_index, reg_offset;
+	unsigned int reg_base;
+	void __iomem *reg;
+
+	prop = of_get_property(np, "marvell,reg-offset", &proplen);
+	if (!prop) {
+		pr_err("%s:%s can not find marvell,reg-offset\n",
+			__func__, np->name);
+		return NULL;
+	}
+
+	size = proplen / sizeof(u32);
+
+	if ((proplen % sizeof(u32)) || (size <= (index * 2))) {
+		pr_err("%s:%s prop len is not correct\n",
+			__func__, np->name);
+		return NULL;
+	}
+
+	reg_index = be32_to_cpup(prop + index * 2);
+	reg_offset = be32_to_cpup(prop + index * 2 + 1);
+	reg = get_child_reg(np, reg_index, &reg_base);
+	if (!reg) {
+		pr_err("%s:%s failed to get reg\n",
+			__func__, np->name);
+		return NULL;
+	}
+
+	*reg_phys = reg_base + reg_offset;
+
+	return reg + reg_offset;
+}
+
+struct device_node *of_mmp_clk_master_init(struct device_node *from)
+{
+	struct device_node *parent, *child;
+	const struct of_device_id *match;
+	of_clk_init_cb_t clk_init_cb;
+
+	parent = from;
+	parent = of_find_matching_node_and_match(from, mmp_clk_master_of_id,
+						&match);
+	if (parent) {
+		clk_init_cb = (of_clk_init_cb_t)match->data;
+		clk_init_cb(parent);
+		for_each_child_of_node(parent, child) {
+			match = of_match_node(&__clk_of_table, child);
+			if (!match)
+				continue;
+			clk_init_cb = (of_clk_init_cb_t)match->data;
+			clk_init_cb(child);
+		}
+	}
+
+	return parent;
+}
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index 9827a4f..6d8c3b3 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -140,6 +140,13 @@ extern struct clk *mmp_clk_register_composite(struct device *dev,
 			unsigned long flags);
 
 
+/* Master clock exported APIs and data. */
+extern void __iomem *of_mmp_clk_get_reg(struct device_node *np,
+					unsigned int reg_index,
+					unsigned int *reg_phys);
+struct device_node *of_mmp_clk_master_init(struct device_node *from);
+
+
 extern struct clk *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
 extern struct clk *mmp_clk_register_apbc(const char *name,
-- 
1.8.3.2

