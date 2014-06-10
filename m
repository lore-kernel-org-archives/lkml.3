Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbaFJB2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:28:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28627 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbaFJB2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:28:14 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <mturquette@linaro.org>,
        <chao.xie@marvell.com>, <xiechao_mail@163.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/12] clk: mmp: add spin lock automatic detection from device tree
Date: Tue, 10 Jun 2014 09:27:45 +0800
Message-ID: <1402363668-25806-10-git-send-email-chao.xie@marvell.com>
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

For Marvell MMP series SOC, many clocks share same register.
In the operations of these clock, a spin lock is needed to avoid
confilicts.
When parse the clock from the device tree and register the clock,
we do not know whether it share the register with others.
So a common API is provided to get the spin lock for the clock based
on device tree support.
The general idea is record the node (clock device node, regsiter),
and before register a new clock, search the node list based on
register. If a node is found, return the shared spin lock, or create
a new.

Signed-off-by: Chao Xie <chao.xie@marvell.com>

Conflicts:
	drivers/clk/mmp/Makefile
---
 Documentation/devicetree/bindings/clock/mmp/lock |  44 +++++++
 drivers/clk/mmp/Makefile                         |   2 +-
 drivers/clk/mmp/clk.h                            |   5 +
 drivers/clk/mmp/lock.c                           | 159 +++++++++++++++++++++++
 4 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/mmp/lock
 create mode 100644 drivers/clk/mmp/lock.c

diff --git a/Documentation/devicetree/bindings/clock/mmp/lock b/Documentation/devicetree/bindings/clock/mmp/lock
new file mode 100644
index 0000000..7e7b5bc
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mmp/lock
@@ -0,0 +1,44 @@
+Binding of spin lock support for Marvell MMP series clock
+
+Because some clocks share same register, spinlock need to be used to avoid
+conflicts.
+
+The spin lock sharing detection is based on regsiter address, and it is
+automatically. To support some clocks, the spin lock is not based on
+register address, some properies are provided.
+The properites are used as part of clock's properties in clock device tree
+files.
+
+Optional properties:
+marvell,mmp-clk-spinlock-new : Skip the automatic detection based on
+			       register address. Direclty create a new
+			       spin lock.
+marvell,mmp-clk-spinlock : It is handle. It points to the clock that share
+			   same spin lock.
+
+Examples:
+
+Assume that clk1, clk2, clk3 share same spin lock.
+
+apmu_clk {
+	compatible = "marvell,mmp-clk-master";
+	...
+
+	clk1 {
+		...
+		marvell,mmp-clk-spinlock-new;
+		...
+	};
+
+	clk2 {
+		...
+		mmp-clk-spinlock = <&clk1>;
+		...
+	};
+
+	clk3 {
+		...
+		mmp-clk-spinlock = <&clk1>;
+		...
+	};
+};
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 518931e..e8810b6 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -6,7 +6,7 @@ obj-y += clk-apbc.o clk-apmu.o clk-frac.o clk-mix.o clk-gate.o	\
 	 clk-mix-composite.o
 
 ifneq ($(CONFIG_OF),)
-obj-y += clk-master-node.o
+obj-y += clk-master-node.o lock.o
 endif
 
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index 6d8c3b3..e06a228 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -147,6 +147,11 @@ extern void __iomem *of_mmp_clk_get_reg(struct device_node *np,
 struct device_node *of_mmp_clk_master_init(struct device_node *from);
 
 
+/* spin lock sharing support. */
+extern spinlock_t *of_mmp_clk_get_spinlock(struct device_node *np,
+					   unsigned int reg_base);
+
+
 extern struct clk *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
 extern struct clk *mmp_clk_register_apbc(const char *name,
diff --git a/drivers/clk/mmp/lock.c b/drivers/clk/mmp/lock.c
new file mode 100644
index 0000000..e2e246c
--- /dev/null
+++ b/drivers/clk/mmp/lock.c
@@ -0,0 +1,159 @@
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
+struct mmp_clk_spinlock_node {
+	struct device_node *share;
+	struct list_head node;
+};
+
+struct mmp_clk_spinlock {
+	spinlock_t lock;
+	struct device_node *owner;
+	unsigned int reg_base;
+	struct list_head share_list;
+	struct list_head node;
+};
+
+static LIST_HEAD(lock_list);
+
+static DEFINE_MUTEX(lock_mutex);
+
+static struct mmp_clk_spinlock_node *create_lock_node(struct device_node *np)
+{
+	struct mmp_clk_spinlock_node *node;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		pr_err("%s:%s failed to allocate spinlock node.\n",
+			__func__, np->name);
+		return NULL;
+	}
+
+	node->share = np;
+
+	return node;
+}
+
+static struct mmp_clk_spinlock *create_lock(struct device_node *np,
+					    unsigned int reg_base)
+{
+	struct mmp_clk_spinlock *lock;
+
+	lock = kzalloc(sizeof(*lock), GFP_KERNEL);
+	if (!lock) {
+		pr_err("%s:%s failed to allocate spinlock.\n",
+			__func__, np->name);
+		return NULL;
+	}
+
+	lock->owner = np;
+	lock->reg_base = reg_base;
+	INIT_LIST_HEAD(&lock->node);
+	INIT_LIST_HEAD(&lock->share_list);
+	spin_lock_init(&lock->lock);
+
+	return lock;
+}
+
+static struct mmp_clk_spinlock *find_lock_by_np(struct device_node *np)
+{
+	struct mmp_clk_spinlock *lock;
+
+	list_for_each_entry(lock, &lock_list, node) {
+		if (lock->owner == np)
+			return lock;
+	}
+
+	return NULL;
+}
+
+static struct mmp_clk_spinlock *find_lock_by_reg_base(unsigned int reg_base)
+{
+	struct mmp_clk_spinlock *lock;
+
+	list_for_each_entry(lock, &lock_list, node) {
+		if (lock->reg_base == reg_base)
+			return lock;
+	}
+
+	return NULL;
+}
+
+spinlock_t *of_mmp_clk_get_spinlock(struct device_node *np,
+					unsigned int reg_base)
+{
+	struct mmp_clk_spinlock *lock;
+	struct mmp_clk_spinlock_node *node;
+	struct device_node *owner;
+
+	if (of_property_read_bool(np, "marvell,mmp-clk-spinlock-new")) {
+
+		mutex_lock(&lock_mutex);
+
+		lock = find_lock_by_np(np);
+		if (!lock) {
+			lock = create_lock(np, reg_base);
+			if (lock)
+				list_add(&lock->node, &lock_list);
+		}
+
+		mutex_unlock(&lock_mutex);
+
+		return &lock->lock;
+	}
+
+	if (of_find_property(np, "marvell,mmp-clk-spinlock", NULL)) {
+
+		mutex_lock(&lock_mutex);
+
+		owner = of_parse_phandle(np, "marvell,mmp-clk-spinlock", 0);
+		lock = find_lock_by_np(owner);
+	} else {
+
+		mutex_lock(&lock_mutex);
+
+		lock = find_lock_by_reg_base(reg_base);
+	}
+
+	if (!lock) {
+		lock = create_lock(np, reg_base);
+		if (lock)
+			list_add(&lock->node, &lock_list);
+	}
+
+	if (!lock) {
+		mutex_unlock(&lock_mutex);
+		pr_err("%s:%s failed to get spinlock\n", __func__, np->name);
+		return NULL;
+	}
+
+	node = create_lock_node(np);
+	if (!node) {
+		mutex_unlock(&lock_mutex);
+		pr_err("%s:%s failed to create spinlock node\n",
+			__func__, np->name);
+		return NULL;
+	}
+	node->share = np;
+	list_add(&node->node, &lock->share_list);
+
+	mutex_unlock(&lock_mutex);
+
+	return &lock->lock;
+}
+
-- 
1.8.3.2

