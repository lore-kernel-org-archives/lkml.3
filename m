Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3EJPDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:03:17 -0400
Received: from multi.imgtec.com ([194.200.65.239]:14600 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab3EJPCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:02:55 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH RFC 2/2] clk: metag/clk-mux: add metag specific clk-mux
Date: Fri, 10 May 2013 16:02:07 +0100
Message-ID: <1368198127-1295-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
References: <1368198127-1295-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_10_16_02_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a metag architecture specific clk-mux which extends the generic one
to use global lock2 to protect the register fields. It is common with
metag to have an RTOS running on a different thread or core with access
to different bits in the same register (in this case clock switch bits
for other clocks). Access to such registers must be serialised with a
global lock such as the one provided by the metag architecture port in
<asm/global_lock.h>

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 .../bindings/clock/img,meta-mux-clock.txt          |  33 ++++
 drivers/clk/metag/Makefile                         |   1 +
 drivers/clk/metag/clk-mux.c                        | 211 +++++++++++++++++++++
 3 files changed, 245 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,meta-mux-clock.txt
 create mode 100644 drivers/clk/metag/clk-mux.c

diff --git a/Documentation/devicetree/bindings/clock/img,meta-mux-clock.txt b/Documentation/devicetree/bindings/clock/img,meta-mux-clock.txt
new file mode 100644
index 0000000..7802939
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,meta-mux-clock.txt
@@ -0,0 +1,33 @@
+Binding for clock multiplexer requiring global Meta locking.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "img,meta-mux-clock".
+- #clock-cells       : From common clock binding; shall be set to 0.
+- reg                : Address of configuration register.
+- shift              : Shift of mux value field in configuration register.
+- width              : Width of mux value field in configuration register.
+- clocks             : From common clock binding.
+
+Required source clocks:
+- 0..(1<<width)-1    : Input clocks to multiplex (don't have to be named).
+
+Optional properties:
+- clock-output-names : From common clock binding.
+- default-clock      : Mux value to set initially.
+
+Example:
+	clock {
+		compatible = "img,meta-mux-clock";
+		#clock-cells = <0>;
+		clocks = <&xtal1>,
+			 <&xtal2>;
+		reg = <0x02005908 0x4>;
+		shift = <0>;
+		width = <1>;
+		clock-output-names = "sysclk0_sw";
+		default-clock = <1>; /* default to xtal2 */
+	};
diff --git a/drivers/clk/metag/Makefile b/drivers/clk/metag/Makefile
index 8e9a6ac..c53ccb2 100644
--- a/drivers/clk/metag/Makefile
+++ b/drivers/clk/metag/Makefile
@@ -1,2 +1,3 @@
 # metag clock types
 obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
diff --git a/drivers/clk/metag/clk-mux.c b/drivers/clk/metag/clk-mux.c
new file mode 100644
index 0000000..5afedde
--- /dev/null
+++ b/drivers/clk/metag/clk-mux.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Metag simple multiplexer clock implementation
+ * Based on simple multiplexer clock implementation, but does appropriate
+ * locking to protect registers shared between hardware threads.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+#include <asm/global_lock.h>
+
+/**
+ * struct clk_metag_mux - metag multiplexer clock
+ *
+ * @mux:	the parent class
+ * @ops:	pointer to clk_ops of parent class
+ *
+ * Clock with multiple selectable parents. Extends basic mux by using a global
+ * exclusive lock when read-modify-writing the mux field so that multiple
+ * threads/cores can use different fields in the same register.
+ */
+struct clk_metag_mux {
+	struct clk_mux		mux;
+	const struct clk_ops	*ops;
+};
+
+static inline struct clk_metag_mux *to_clk_metag_mux(struct clk_hw *hw)
+{
+	struct clk_mux *mux = container_of(hw, struct clk_mux, hw);
+
+	return container_of(mux, struct clk_metag_mux, mux);
+}
+
+static u8 clk_metag_mux_get_parent(struct clk_hw *hw)
+{
+	struct clk_metag_mux *mux = to_clk_metag_mux(hw);
+
+	return mux->ops->get_parent(&mux->mux.hw);
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static int clk_metag_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_metag_mux *mux = to_clk_metag_mux(hw);
+	int ret;
+	unsigned long flags;
+
+	__global_lock2(flags);
+	ret = mux->ops->set_parent(&mux->mux.hw, index);
+	__global_unlock2(flags);
+
+	return ret;
+}
+
+static const struct clk_ops clk_metag_mux_ops = {
+	.get_parent = clk_metag_mux_get_parent,
+	.set_parent = clk_metag_mux_set_parent,
+};
+
+static struct clk *__init clk_register_metag_mux(struct device *dev,
+		const char *name, const char **parent_names, u8 num_parents,
+		s32 default_parent, unsigned long flags, void __iomem *reg,
+		u8 shift, u8 width, u8 clk_mux_flags)
+{
+	struct clk_metag_mux *mux;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the mux */
+	mux = kzalloc(sizeof(struct clk_metag_mux), GFP_KERNEL);
+	if (!mux) {
+		pr_err("%s: could not allocate metag mux clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	init.name = name;
+	init.ops = &clk_metag_mux_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = parent_names;
+	init.num_parents = num_parents;
+
+	/* struct clk_mux assignments */
+	mux->mux.reg = reg;
+	mux->mux.shift = shift;
+	mux->mux.mask = BIT(width) - 1;
+	mux->mux.flags = clk_mux_flags;
+	mux->mux.hw.init = &init;
+
+	/* struct clk_metag_mux assignments */
+	mux->ops = &clk_mux_ops;
+
+	/* set default value */
+	if (default_parent >= 0)
+		clk_metag_mux_set_parent(&mux->mux.hw, default_parent);
+
+	clk = clk_register(dev, &mux->mux.hw);
+
+	if (IS_ERR(clk))
+		kfree(mux);
+
+	return clk;
+}
+
+#ifdef CONFIG_OF
+/**
+ * of_metag_mux_clk_setup() - Setup function for simple fixed rate clock
+ */
+static void __init of_metag_mux_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	u32 shift, width, default_clock;
+	void __iomem *reg;
+	int len, i;
+	struct property *prop;
+	const char **parent_names;
+	unsigned int num_parents;
+	u8 flags = 0;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	if (of_property_read_u32(node, "shift", &shift)) {
+		pr_err("%s(%s): could not read shift property\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	if (of_property_read_u32(node, "width", &width)) {
+		pr_err("%s(%s): could not read width property\n",
+		       __func__, clk_name);
+		return;
+	}
+
+	/* count maximum number of parent clocks */
+	prop = of_find_property(node, "clocks", &len);
+	if (!prop) {
+		pr_err("%s(%s): could not find clocks property\n",
+		       __func__, clk_name);
+		return;
+	}
+	/*
+	 * There cannot be more parents than entries in "clocks" property (which
+	 * may include additional args too. It also needs to fit in a u8.
+	 */
+	num_parents = len / sizeof(u32);
+	num_parents = min(num_parents, 0xffu);
+
+	/* allocate an array of parent names */
+	parent_names = kzalloc(sizeof(const char *)*num_parents, GFP_KERNEL);
+	if (!parent_names) {
+		pr_err("%s(%s): could not allocate %u parent names\n",
+		       __func__, clk_name, num_parents);
+		goto err_kfree;
+	}
+
+	/* fill in the parent names */
+	for (i = 0; i < num_parents; ++i) {
+		parent_names[i] = of_clk_get_parent_name(node, i);
+		if (!parent_names[i]) {
+			/* truncate array length if we hit the end early */
+			num_parents = i;
+			break;
+		}
+	}
+
+	/* default parent clock (mux value) */
+	if (!of_property_read_u32(node, "default-clock", &default_clock)) {
+		if (default_clock >= num_parents) {
+			pr_err("%s(%s): default-clock %u out of range (%u bits)\n",
+			       __func__, clk_name, default_clock, width);
+			goto err_kfree;
+		}
+	} else {
+		default_clock = -1;
+	}
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("%s(%s): of_iomap failed\n",
+		       __func__, clk_name);
+		goto err_kfree;
+	}
+
+	clk = clk_register_metag_mux(NULL, clk_name, parent_names, num_parents,
+				     default_clock, 0, reg, shift,
+				     width, flags);
+	if (IS_ERR(clk))
+		goto err_iounmap;
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+	return;
+
+err_iounmap:
+	iounmap(reg);
+err_kfree:
+	kfree(parent_names);
+}
+CLK_OF_DECLARE(metag_mux_clk, "img,meta-mux-clock", of_metag_mux_clk_setup);
+#endif /* CONFIG_OF */
-- 
1.8.1.2


