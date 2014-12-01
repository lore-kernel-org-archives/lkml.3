Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbaLAXZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:25:49 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34527 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbaLAXUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:48 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 04/16] clk: tz1090: add deleter clock driver
Date: Mon,  1 Dec 2014 23:19:54 +0000
Message-Id: <1417476006-10407-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver for clock deleters in the TZ1090 SoC, which delete up
to 1023 out of every 1024 clock pulses. There are 4 of these in TZ1090,
for the system clock, the Meta core clock, and one for each UCC.

The tz1090_clk_register_deleters() helper function can be used to
register a set of deleters from static initialisation data. A DEL()
macro is provided in tz1090/clk.h to aid the creation of this data, for
example:

static const struct tz1090_clk_deleter deleters[] __initconst = {
	DEL(CLK_TOP_SYS, "sys_undeleted", "sys", TOP_CLKDELETE),
	...
};
...
tz1090_clk_register_deleters(p, deleters, ARRAY_SIZE(deleters));

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
Changes since v1 (patch 10):
- Renamed function prefixes from clk_tz1090_ to tz1090_clk_ for
  consistency with the rest.
- Drop DT binding as it will be instantiated directly from a provider.
- Add tz1090_clk_register_deleters() to conveniently register a set of
  deleters in a clock provider from static initilisation data.
- Extend tz1090/clk.h interface for easy static initialisation with
  macros.
---
 drivers/clk/tz1090/Makefile             |   1 +
 drivers/clk/tz1090/clk-tz1090-deleter.c | 132 ++++++++++++++++++++++++++++++++
 drivers/clk/tz1090/clk.h                |  31 ++++++++
 3 files changed, 164 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-deleter.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index d44acac..39c29ac 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -1,5 +1,6 @@
 # Makefile for TZ1090-specific clocks
 obj-y		+= clk.o
 
+obj-y		+= clk-tz1090-deleter.o
 obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
diff --git a/drivers/clk/tz1090/clk-tz1090-deleter.c b/drivers/clk/tz1090/clk-tz1090-deleter.c
new file mode 100644
index 0000000..9ec604d
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-deleter.c
@@ -0,0 +1,132 @@
+/*
+ * Copyright (C) 2012-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Clock deleter in TZ1090
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include "clk.h"
+
+/**
+ * struct tz1090_clk_deleter_priv - Clock deleter
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @reg:	delete register
+ * @period:	cycle period
+ * @mask:	bit mask of delete field
+ * @shift:	start bit of delete field
+ *
+ * Deleter in TZ1090, allowing up to period-1 out of each period cycles to be
+ * deleted.
+ */
+struct tz1090_clk_deleter_priv {
+	struct clk_hw	hw;
+	void __iomem	*reg;
+	u32		period;
+	u32		mask;
+	u8		shift;
+};
+
+#define to_tz1090_clk_deleter(_hw) \
+	container_of(_hw, struct tz1090_clk_deleter_priv, hw)
+
+static unsigned long tz1090_clk_deleter_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	struct tz1090_clk_deleter_priv *deleter = to_tz1090_clk_deleter(hw);
+	u32 delete;
+	u64 rate;
+
+	delete = (readl(deleter->reg) & deleter->mask) >> deleter->shift;
+	rate = (u64)parent_rate * (deleter->period - delete);
+	do_div(rate, deleter->period);
+	return rate;
+}
+
+static const struct clk_ops tz1090_clk_deleter_ops = {
+	.recalc_rate = tz1090_clk_deleter_recalc_rate,
+};
+
+/**
+ * __register_deleter() - register a clock deleter
+ * @name:		name of this clock
+ * @parent_name:	name of clock's parent
+ * @flags:		framework-specific flags
+ * @reg:		register address to adjust deleter
+ * @period:		delete cycle period
+ * @mask:		mask of delete field
+ * @shift:		start bit of delete field
+ *
+ * Register a TZ1090 clock deleter with the clock framework.
+ */
+static struct clk *__init __register_deleter(const char *name,
+					     const char *parent_name,
+					     unsigned long flags,
+					     void __iomem *reg,
+					     u32 period,
+					     u32 mask,
+					     u8 shift)
+{
+	struct tz1090_clk_deleter_priv *deleter;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the deleter */
+	deleter = kzalloc(sizeof(struct tz1090_clk_deleter_priv), GFP_KERNEL);
+	if (!deleter)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &tz1090_clk_deleter_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct tz1090_clk_deleter_priv assignments */
+	deleter->reg = reg;
+	deleter->period = period;
+	deleter->mask = mask;
+	deleter->shift = shift;
+	deleter->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(NULL, &deleter->hw);
+
+	if (IS_ERR(clk))
+		kfree(deleter);
+
+	return clk;
+}
+
+/**
+ * tz1090_clk_register_deleters() - Register set of deleters with a provider.
+ * @p:		TZ1090 clock provider.
+ * @deleters:	Array of deleter descriptions.
+ * @count	Number of deleters described in the array.
+ */
+void __init tz1090_clk_register_deleters(struct tz1090_clk_provider *p,
+				const struct tz1090_clk_deleter *deleters,
+				unsigned int count)
+{
+	const struct tz1090_clk_deleter *del;
+	struct clk *clk;
+	unsigned int i;
+
+	for (del = deleters, i = 0; i < count; ++del, ++i) {
+		clk = __register_deleter(tz1090_clk_xlate(p, del->name),
+					 tz1090_clk_xlate(p, del->parent), 0,
+					 p->base + del->reg, 1024, 0x3ff, 0);
+		p->clk_data.clks[del->id] = clk;
+	}
+}
diff --git a/drivers/clk/tz1090/clk.h b/drivers/clk/tz1090/clk.h
index c9fe6ca..8f90908 100644
--- a/drivers/clk/tz1090/clk.h
+++ b/drivers/clk/tz1090/clk.h
@@ -135,4 +135,35 @@ struct tz1090_clk_mux_bank {
 void tz1090_clk_register_mux_bank(struct tz1090_clk_provider *p,
 				  const struct tz1090_clk_mux_bank *bank);
 
+
+/* Deleters */
+
+/**
+ * struct tz1090_clk_deleter - Describes a clock deleter.
+ * @id:		Id of output clock in provider.
+ * @reg:	Offset of deleter register in the MMIO region.
+ * @name:	Name of deleted clock to provide.
+ * @parent:	Name of parent/source clocks.
+ *
+ * The deleter is assumed to have a period of 1024.
+ */
+struct tz1090_clk_deleter {
+	unsigned int		id;
+	unsigned long		reg;
+	const char		*name;
+	const char		*parent;
+};
+
+#define DEL(_id, _parent, _name, _reg)		\
+	{					\
+		.id		= (_id),	\
+		.reg		= (_reg),	\
+		.name		= (_name),	\
+		.parent		= (_parent),	\
+	}
+
+void tz1090_clk_register_deleters(struct tz1090_clk_provider *p,
+				  const struct tz1090_clk_deleter *deleters,
+				  unsigned int count);
+
 #endif
-- 
2.0.4

