Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaLAXUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:20:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55772 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaLAXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:45 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 03/16] clk: tz1090: add mux bank clock driver
Date: Mon,  1 Dec 2014 23:19:53 +0000
Message-Id: <1417476006-10407-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver for banks of clock muxes in the TZ1090 SoC. A single
32 bit register controls up to 32 separate clock muxes. The generic
clock mux clock operations are wrapped in order to acquire and release
the Meta global exclusive lock (__global_lock2) to ensure atomicity with
other non-Linux cores and threads which may need to control some of the
clocks.

The tz1090_clk_register_mux_bank() helper function can be used to
register a mux bank from static initialisation data. Macros are provided
in tz1090/clk.h to aid the creation of this data, for example:

MUX_BANK(tz1090_top_clkswitch, CLK_TOP_CLKSWITCH_BASE, TOP_CLKSWITCH,
	/*  bit in[0]    in[1]            out */
	MUX( 0, "@xtal1" "@xtal2",        "sys_sw")
	MUX( 1, "@xtal1" "sys_div",       "sys_x2_undeleted")
	MUX( 2, "@xtal1" "@afe_progdiv1", "out0_sw0")
	...
);
...
tz1090_clk_register_mux_bank(p, &tz1090_top_clkswitch);

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
Changes since v1 (patch 8):
- Renamed function prefixes from clk_tz1090_ to tz1090_clk_ for
  consistency with the rest.
- Drop DT binding as it will be instantiated directly from a provider.
- Add tz1090_clk_register_mux_bank() to conveniently register a bank of
  gates in a clock provider from static initilisation data.
- Extend tz1090/clk.h interface for easy static initialisation with
  macros.
---
 drivers/clk/tz1090/Makefile              |   1 +
 drivers/clk/tz1090/clk-tz1090-mux-bank.c | 139 +++++++++++++++++++++++++++++++
 drivers/clk/tz1090/clk.h                 |  52 ++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-mux-bank.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index ab88f53..d44acac 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -2,3 +2,4 @@
 obj-y		+= clk.o
 
 obj-y		+= clk-tz1090-gate-bank.o
+obj-y		+= clk-tz1090-mux-bank.o
diff --git a/drivers/clk/tz1090/clk-tz1090-mux-bank.c b/drivers/clk/tz1090/clk-tz1090-mux-bank.c
new file mode 100644
index 0000000..0c7732d
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-mux-bank.c
@@ -0,0 +1,139 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Clock mux bank
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
+ * struct tz1090_clk_mux_priv - tz1090 multiplexer clock
+ *
+ * @mux:	the parent class
+ * @ops:	pointer to clk_ops of parent class
+ *
+ * Clock with multiple selectable parents. Extends basic mux by using a global
+ * exclusive lock when read-modify-writing the mux field so that multiple
+ * threads/cores can use different fields in the same register.
+ */
+struct tz1090_clk_mux_priv {
+	struct clk_mux		mux;
+	const struct clk_ops	*ops;
+};
+
+static inline struct tz1090_clk_mux_priv *to_tz1090_clk_mux(struct clk_hw *hw)
+{
+	struct clk_mux *mux = container_of(hw, struct clk_mux, hw);
+
+	return container_of(mux, struct tz1090_clk_mux_priv, mux);
+}
+
+static u8 tz1090_clk_mux_get_parent(struct clk_hw *hw)
+{
+	struct tz1090_clk_mux_priv *mux = to_tz1090_clk_mux(hw);
+
+	return mux->ops->get_parent(&mux->mux.hw);
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static int tz1090_clk_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct tz1090_clk_mux_priv *mux = to_tz1090_clk_mux(hw);
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
+static long tz1090_clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+				     unsigned long *prate,
+				     struct clk **best_parent)
+{
+	struct tz1090_clk_mux_priv *mux = to_tz1090_clk_mux(hw);
+
+	return mux->ops->determine_rate(&mux->mux.hw, rate, prate, best_parent);
+}
+
+static const struct clk_ops tz1090_clk_mux_ops = {
+	.get_parent = tz1090_clk_mux_get_parent,
+	.set_parent = tz1090_clk_mux_set_parent,
+	.determine_rate = tz1090_clk_mux_determine_rate,
+};
+
+static struct clk *__init __register_mux(const char *name,
+					 const char **parent_names,
+					 unsigned long flags, void __iomem *reg,
+					 u8 shift, u8 clk_mux_flags)
+{
+	struct tz1090_clk_mux_priv *mux;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the mux */
+	mux = kzalloc(sizeof(struct tz1090_clk_mux_priv), GFP_KERNEL);
+	if (!mux)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &tz1090_clk_mux_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = parent_names;
+	init.num_parents = 2;
+
+	/* struct clk_mux assignments */
+	mux->mux.reg = reg;
+	mux->mux.shift = shift;
+	mux->mux.mask = 0x1;
+	mux->mux.flags = clk_mux_flags;
+	mux->mux.hw.init = &init;
+
+	/* struct tz1090_clk_mux_priv assignments */
+	mux->ops = &clk_mux_ops;
+
+	clk = clk_register(NULL, &mux->mux.hw);
+
+	if (IS_ERR(clk))
+		kfree(mux);
+
+	return clk;
+}
+
+/**
+ * tz1090_clk_register_mux_bank() - Register bank of muxes with a provider.
+ * @p:		TZ1090 clock provider.
+ * @bank:	Data describing mux bank.
+ */
+void __init tz1090_clk_register_mux_bank(struct tz1090_clk_provider *p,
+					 const struct tz1090_clk_mux_bank *bank)
+{
+	const struct tz1090_clk_mux *mux;
+	struct clk *clk;
+	unsigned int id = bank->id_base;
+	const char *parents[2];
+
+	for (mux = bank->muxes; mux->name; ++mux, ++id) {
+		parents[0] = tz1090_clk_xlate(p, mux->parents[0]);
+		parents[1] = tz1090_clk_xlate(p, mux->parents[1]);
+		clk = __register_mux(tz1090_clk_xlate(p, mux->name), parents,
+				     CLK_SET_RATE_PARENT,
+				     p->base + bank->reg_base, mux->shift, 0);
+		p->clk_data.clks[id] = clk;
+	}
+}
diff --git a/drivers/clk/tz1090/clk.h b/drivers/clk/tz1090/clk.h
index 06274b7..c9fe6ca 100644
--- a/drivers/clk/tz1090/clk.h
+++ b/drivers/clk/tz1090/clk.h
@@ -83,4 +83,56 @@ struct tz1090_clk_gate_bank {
 void tz1090_clk_register_gate_bank(struct tz1090_clk_provider *p,
 				   const struct tz1090_clk_gate_bank *bank);
 
+
+/* Clock mux banks */
+
+/**
+ * struct tz1090_clk_mux - Describes an individual mux in a bank.
+ * @shift:	Shift of bit controlling mux within the bank control register.
+ * @name:	Name of muxed clock to provide.
+ * @parents:	Name of two parent/source clocks for when the bit is 0 and 1.
+ */
+struct tz1090_clk_mux {
+	unsigned int	shift;
+	const char	*name;
+	const char	*parents[2];
+};
+
+/**
+ * struct tz1090_clk_mux_bank - Describes a mux bank.
+ * @id_base:	Base id of bank in provider.
+ *		Individual muxes get the id id_base + index in muxes array.
+ * @reg_base:	Offset of mux bank register in the MMIO region.
+ * @muxes:	Pointer to array of muxes in the bank, terminated by one with a
+ *		NULL name field.
+ */
+struct tz1090_clk_mux_bank {
+	unsigned int			id_base;
+	unsigned long			reg_base;
+	const struct tz1090_clk_mux	*muxes;
+};
+
+#define MUX(_shift, _parent0, _parent1, _name)				\
+	{								\
+		.shift		= (_shift),				\
+		.name		= (_name),				\
+		.parents	= {					\
+			_parent0,					\
+			_parent1					\
+		},							\
+	},
+
+#define MUX_BANK(_name, _id, _reg, _muxes)				\
+	static const struct tz1090_clk_mux_bank _name __initconst = {	\
+		.id_base	= (_id),				\
+		.reg_base	= (_reg),				\
+		.muxes		= (const struct tz1090_clk_mux[]) {	\
+			_muxes						\
+			{ .name	= NULL }				\
+		},							\
+	}
+
+void tz1090_clk_register_mux_bank(struct tz1090_clk_provider *p,
+				  const struct tz1090_clk_mux_bank *bank);
+
 #endif
-- 
2.0.4

