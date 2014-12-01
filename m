Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaLAXUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:20:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45720 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbaLAXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:43 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 02/16] clk: tz1090: add gate bank clock driver
Date: Mon,  1 Dec 2014 23:19:52 +0000
Message-Id: <1417476006-10407-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver for banks of clock gates in the TZ1090 SoC. A single
32 bit register controls up to 32 separate clock gates. The generic
clock gate clock operations are wrapped in order to acquire and release
the Meta global exclusive lock (__global_lock2) to ensure atomicity with
other non-Linux cores and threads which may need to control some of the
clocks.

The tz1090_clk_register_gate_bank() helper function can be used to
register a gate bank from static initialisation data. Macros are
provided in tz1090/clk.h to aid the creation of this data, for example:

GATE_BANK(tz1090_perip_clken, 0, PERIP_CLKEN,
        /*   bit in      out */
        GATE( 0, "@sys", "sys_scb0")
        GATE( 1, "@sys", "sys_scb1")
        GATE( 2, "@sys", "sys_scb2")
        ...
);
...
clk_register_gate_bank(p, &tz1090_perip_clken);

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
Changes since v1 (patch 6):
- Renamed function prefixes from clk_tz1090_ to tz1090_clk_ for
  consistency with the rest.
- Drop DT binding as it will be instantiated directly from a provider.
- Add tz1090_clk_register_gate_bank() to conveniently register a bank of
  gates in a clock provider from static initilisation data.
- Extend tz1090/clk.h interface for easy static initialisation with
  macros.
---
 drivers/clk/tz1090/Makefile               |   2 +
 drivers/clk/tz1090/clk-tz1090-gate-bank.c | 149 ++++++++++++++++++++++++++++++
 drivers/clk/tz1090/clk.h                  |  49 ++++++++++
 3 files changed, 200 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-gate-bank.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index a2ace14..ab88f53 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -1,2 +1,4 @@
 # Makefile for TZ1090-specific clocks
 obj-y		+= clk.o
+
+obj-y		+= clk-tz1090-gate-bank.o
diff --git a/drivers/clk/tz1090/clk-tz1090-gate-bank.c b/drivers/clk/tz1090/clk-tz1090-gate-bank.c
new file mode 100644
index 0000000..5834afd
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-gate-bank.c
@@ -0,0 +1,149 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Clock gate bank
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
+#include "clk.h"
+
+/**
+ * struct tz1090_clk_gate_priv - tz1090 gating clock
+ *
+ * @mux:	the parent class
+ * @ops:	pointer to clk_ops of parent class
+ *
+ * Clock which can gate its output. Extends basic mux by using a global
+ * exclusive lock when read-modify-writing the mux field so that multiple
+ * threads/cores can use different fields in the same register.
+ */
+struct tz1090_clk_gate_priv {
+	struct clk_gate		gate;
+	const struct clk_ops	*ops;
+};
+
+static inline struct tz1090_clk_gate_priv *to_tz1090_clk_gate(struct clk_hw *hw)
+{
+	struct clk_gate *gate = container_of(hw, struct clk_gate, hw);
+
+	return container_of(gate, struct tz1090_clk_gate_priv, gate);
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static int tz1090_clk_gate_enable(struct clk_hw *hw)
+{
+	struct tz1090_clk_gate_priv *gate = to_tz1090_clk_gate(hw);
+	int ret;
+	unsigned long flags;
+
+	__global_lock2(flags);
+	ret = gate->ops->enable(&gate->gate.hw);
+	__global_unlock2(flags);
+
+	return ret;
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static void tz1090_clk_gate_disable(struct clk_hw *hw)
+{
+	struct tz1090_clk_gate_priv *gate = to_tz1090_clk_gate(hw);
+	unsigned long flags;
+
+	__global_lock2(flags);
+	gate->ops->disable(&gate->gate.hw);
+	__global_unlock2(flags);
+}
+
+static int tz1090_clk_gate_is_enabled(struct clk_hw *hw)
+{
+	struct tz1090_clk_gate_priv *gate = to_tz1090_clk_gate(hw);
+
+	return gate->ops->is_enabled(&gate->gate.hw);
+}
+
+static const struct clk_ops tz1090_clk_gate_ops = {
+	.enable = tz1090_clk_gate_enable,
+	.disable = tz1090_clk_gate_disable,
+	.is_enabled = tz1090_clk_gate_is_enabled,
+};
+
+/**
+ * __register_gate() - register a TZ1090 gate clock with clock framework.
+ * @name: name of this clock
+ * @parent_name: name of this clock's parent
+ * @flags: framework-specific flags for this clock
+ * @reg: register address to control gating of this clock
+ * @bit_idx: which bit in the register controls gating of this clock
+ * @clk_gate_flags: gate-specific flags for this clock
+ */
+static struct clk *__init __register_gate(const char *name,
+					  const char *parent_name,
+					  unsigned long flags,
+					  void __iomem *reg,
+					  u8 bit_idx,
+					  u8 clk_gate_flags)
+{
+	struct tz1090_clk_gate_priv *gate;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the gate */
+	gate = kzalloc(sizeof(struct tz1090_clk_gate_priv), GFP_KERNEL);
+	if (!gate)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &tz1090_clk_gate_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_gate assignments */
+	gate->gate.reg = reg;
+	gate->gate.bit_idx = bit_idx;
+	gate->gate.flags = clk_gate_flags;
+	gate->gate.hw.init = &init;
+
+	/* struct tz1090_clk_gate_priv assignments */
+	gate->ops = &clk_gate_ops;
+
+	clk = clk_register(NULL, &gate->gate.hw);
+
+	if (IS_ERR(clk))
+		kfree(gate);
+
+	return clk;
+}
+
+/**
+ * tz1090_clk_register_gate_bank() - Register bank of gates with a provider.
+ * @p:		TZ1090 clock provider.
+ * @bank:	Data describing gate bank.
+ */
+void __init tz1090_clk_register_gate_bank(struct tz1090_clk_provider *p,
+					const struct tz1090_clk_gate_bank *bank)
+{
+	const struct tz1090_clk_gate *gate;
+	struct clk *clk;
+	unsigned int id = bank->id_base;
+
+	for (gate = bank->gates; gate->name; ++gate, ++id) {
+		clk = __register_gate(tz1090_clk_xlate(p, gate->name),
+				      tz1090_clk_xlate(p, gate->parent),
+				      CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT,
+				      p->base + bank->reg_base, gate->shift, 0);
+		p->clk_data.clks[id] = clk;
+	}
+}
diff --git a/drivers/clk/tz1090/clk.h b/drivers/clk/tz1090/clk.h
index c20e7b4..06274b7 100644
--- a/drivers/clk/tz1090/clk.h
+++ b/drivers/clk/tz1090/clk.h
@@ -34,4 +34,53 @@ const char *tz1090_clk_xlate(struct tz1090_clk_provider *p,
 			     const char *clk_name);
 void tz1090_clk_register_provider(struct tz1090_clk_provider *p);
 
+
+/* Clock gate banks */
+
+/**
+ * struct tz1090_clk_gate - Describes an individual gate in a bank.
+ * @shift:	Shift of bit controlling gate within the bank control register.
+ * @name:	Name of gated clock to provide.
+ * @parent:	Name of parent/source clock.
+ */
+struct tz1090_clk_gate {
+	unsigned int	shift;
+	const char	*name;
+	const char	*parent;
+};
+
+/**
+ * struct tz1090_clk_gate_bank - Describes a gate bank.
+ * @id_base:	Base id of bank in provider.
+ *		Individual gates get the id id_base + index in gates array.
+ * @reg_base:	Offset of gate bank register in the MMIO region.
+ * @gates:	Pointer to array of gates in the bank, terminated by one with a
+ *		NULL name field.
+ */
+struct tz1090_clk_gate_bank {
+	unsigned int			id_base;
+	unsigned long			reg_base;
+	const struct tz1090_clk_gate	*gates;
+};
+
+#define GATE(_shift, _parent, _name)					\
+	{								\
+		.shift		= (_shift),				\
+		.name		= (_name),				\
+		.parent		= (_parent),				\
+	},
+
+#define GATE_BANK(_name, _id, _reg, _gates)				\
+	static const struct tz1090_clk_gate_bank _name __initconst = {	\
+		.id_base	= (_id),				\
+		.reg_base	= (_reg),				\
+		.gates		= (const struct tz1090_clk_gate[]) {	\
+			_gates						\
+			{ .name	= NULL }				\
+		},							\
+	}
+
+void tz1090_clk_register_gate_bank(struct tz1090_clk_provider *p,
+				   const struct tz1090_clk_gate_bank *bank);
+
 #endif
-- 
2.0.4

