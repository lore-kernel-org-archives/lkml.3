Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbaLAXXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:23:48 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44639 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaLAXUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:49 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 05/16] clk: tz1090: add divider clock driver
Date: Mon,  1 Dec 2014 23:19:55 +0000
Message-Id: <1417476006-10407-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a clock driver for dividers in the TZ1090 SoC, which divide an input
clock by an integer. The generic divider operations are optionally
wrapped in order to acquire and release the Meta global exclusive lock
(__global_lock2) to ensure atomicity with other non-Linux cores and
threads which may need to use some other fields in the same register.

The tz1090_clk_register_dividers() helper function can be used to
register a set of dividers from static initialisation data. DIV(),
DIV_FLAGS(), and DIV_SHARED() (for globally locked divider) macros are
provided in tz1090/clk.h to aid the creation of this data.  For example:

static const struct tz1090_clk_divider dividers[] __initconst = {
	DIV(CLK_TOP_SYS_DIV, "sys_pll", "sys_div", TOP_SYSCLK_DIV, 8),
	DIV_FLAGS(CLK_TOP_UART, "uart_en", "uart", TOP_UARTCLK_DIV, 8,
		  CLK_SET_RATE_PARENT, 0),
	DIV_SHARED(CLK_PDC_XTAL1_DIV, "@xtal1", "xtal1_div", PDC_SOC0,
		   11, 16),
	...
};
...
tz1090_clk_register_dividers(p, dividers, ARRAY_SIZE(dividers));

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
Changes since v1 (patches 14 and 12):
- Drop divider DT binding and divider specific flags (policy) as
  dividers will be instantiated directly from a provider. These were the
  only things in clk-tz1090-divider.c.
- Split out wrapped (meta exclusive locked) divider driver from PDC
  clock driver.
- Renamed function prefixes from clk_tz1090_ to tz1090_clk_ for
  consistency with the rest.
- Switch back to using clk_divider::width rather than clk_divider::mask.
  Mask was only added to make it easier to be exposed in a DT binding,
  which is no longer required.
- Add tz1090_clk_register_dividers() to conveniently register a set of
  dividers in a clock provider from static initilisation data, either
  wrapped or generic dividers.
- Extend tz1090/clk.h interface for easy static initialisation with
  macros.
---
 drivers/clk/tz1090/Makefile             |   1 +
 drivers/clk/tz1090/clk-tz1090-divider.c | 151 ++++++++++++++++++++++++++++++++
 drivers/clk/tz1090/clk.h                |  63 +++++++++++++
 3 files changed, 215 insertions(+)
 create mode 100644 drivers/clk/tz1090/clk-tz1090-divider.c

diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
index 39c29ac..a7127d9 100644
--- a/drivers/clk/tz1090/Makefile
+++ b/drivers/clk/tz1090/Makefile
@@ -2,5 +2,6 @@
 obj-y		+= clk.o
 
 obj-y		+= clk-tz1090-deleter.o
+obj-y		+= clk-tz1090-divider.o
 obj-y		+= clk-tz1090-gate-bank.o
 obj-y		+= clk-tz1090-mux-bank.o
diff --git a/drivers/clk/tz1090/clk-tz1090-divider.c b/drivers/clk/tz1090/clk-tz1090-divider.c
new file mode 100644
index 0000000..22db67d
--- /dev/null
+++ b/drivers/clk/tz1090/clk-tz1090-divider.c
@@ -0,0 +1,151 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Divider Clock.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <asm/global_lock.h>
+
+#include "clk.h"
+
+/**
+ * struct tz1090_clk_div_priv - tz1090 divider clock
+ *
+ * @div:	the parent class
+ * @ops:	pointer to clk_ops of parent class
+ *
+ * Divider clock whose field shares a register with other fields which may be
+ * used by multiple threads/cores and other drivers.
+ */
+struct tz1090_clk_div_priv {
+	struct clk_divider	div;
+	const struct clk_ops	*ops;
+};
+
+static inline struct tz1090_clk_div_priv *to_tz1090_clk_div(struct clk_hw *hw)
+{
+	struct clk_divider *div = container_of(hw, struct clk_divider, hw);
+
+	return container_of(div, struct tz1090_clk_div_priv, div);
+}
+
+static unsigned long tz1090_clk_divider_recalc_rate(struct clk_hw *hw,
+						    unsigned long parent_rate)
+{
+	struct tz1090_clk_div_priv *div = to_tz1090_clk_div(hw);
+
+	return div->ops->recalc_rate(&div->div.hw, parent_rate);
+}
+
+static long tz1090_clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+					  unsigned long *prate)
+{
+	struct tz1090_clk_div_priv *div = to_tz1090_clk_div(hw);
+
+	return div->ops->round_rate(&div->div.hw, rate, prate);
+}
+
+/* Acquire exclusive lock since other cores may access the same register */
+static int tz1090_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long parent_rate)
+{
+	struct tz1090_clk_div_priv *div = to_tz1090_clk_div(hw);
+	int ret;
+	unsigned long flags;
+
+	__global_lock2(flags);
+	ret = div->ops->set_rate(&div->div.hw, rate, parent_rate);
+	__global_unlock2(flags);
+
+	return ret;
+}
+
+static const struct clk_ops tz1090_clk_div_ops = {
+	.recalc_rate	= tz1090_clk_divider_recalc_rate,
+	.round_rate	= tz1090_clk_divider_round_rate,
+	.set_rate	= tz1090_clk_divider_set_rate,
+};
+
+static struct clk *__init __register_divider(const char *name,
+					     const char *parent_name,
+					     unsigned long flags,
+					     void __iomem *reg, u8 shift,
+					     u8 width, u8 clk_divider_flags)
+{
+	struct tz1090_clk_div_priv *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	/* allocate the divider */
+	div = kzalloc(sizeof(struct tz1090_clk_div_priv), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &tz1090_clk_div_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	/* struct clk_divider assignments */
+	div->div.reg = reg;
+	div->div.shift = shift;
+	div->div.width = width;
+	div->div.flags = clk_divider_flags;
+	div->div.hw.init = &init;
+
+	/* struct tz1090_clk_div_priv assignments */
+	div->ops = &clk_divider_ops;
+
+	/* register the clock */
+	clk = clk_register(NULL, &div->div.hw);
+
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
+
+/**
+ * tz1090_clk_register_dividers() - Register set of dividers with a provider.
+ * @p:		TZ1090 clock provider.
+ * @dividers:	Array of divider descriptions.
+ * @count	Number of dividers described in the array.
+ */
+void __init tz1090_clk_register_dividers(struct tz1090_clk_provider *p,
+				const struct tz1090_clk_divider *dividers,
+				unsigned int count)
+{
+	const struct tz1090_clk_divider *div;
+	struct clk *clk;
+	unsigned int i;
+
+	for (div = dividers, i = 0; i < count; ++div, ++i) {
+		/*
+		 * Dividers in registers shared between OSes must protect the
+		 * register with a global lock. Others with dedicated registers
+		 * can just use a normal divider.
+		 */
+		if (div->shared)
+			clk = __register_divider(tz1090_clk_xlate(p, div->name),
+					tz1090_clk_xlate(p, div->parent),
+					div->flags, p->base + div->reg,
+					div->shift, div->width, div->div_flags);
+		else
+			clk = clk_register_divider(NULL,
+					tz1090_clk_xlate(p, div->name),
+					tz1090_clk_xlate(p, div->parent),
+					div->flags, p->base + div->reg,
+					div->shift, div->width, div->div_flags,
+					NULL);
+		p->clk_data.clks[div->id] = clk;
+	}
+}
diff --git a/drivers/clk/tz1090/clk.h b/drivers/clk/tz1090/clk.h
index 8f90908..ca51f87 100644
--- a/drivers/clk/tz1090/clk.h
+++ b/drivers/clk/tz1090/clk.h
@@ -166,4 +166,67 @@ void tz1090_clk_register_deleters(struct tz1090_clk_provider *p,
 				  const struct tz1090_clk_deleter *deleters,
 				  unsigned int count);
 
+
+/* Dividers */
+
+/**
+ * struct tz1090_clk_divider - Describes a clock divider.
+ * @id:		Id of output clock in provider.
+ * @reg:	Offset of divider register in the MMIO region.
+ * @flags:	Clock flags.
+ * @div_flags:	Divider flags.
+ * @shift:	Shift of field controlling divider.
+ * @width:	Width of field controlling divider.
+ * @shared:	1 if register is shared with other important fields and requires
+ *		global locking.
+ * @name:	Name of divided clock to provide.
+ * @parent:	Name of parent/source clocks.
+ */
+struct tz1090_clk_divider {
+	unsigned int		id;
+	unsigned long		reg;
+	unsigned long		flags;
+	u8			div_flags;
+	u8			shift;
+	u8			width;
+	u8			shared;
+	const char		*name;
+	const char		*parent;
+};
+
+#define DIV(_id, _parent, _name, _reg, _width)	\
+	{								\
+		.id		= (_id),				\
+		.reg		= (_reg),				\
+		.width		= (_width),				\
+		.name		= (_name),				\
+		.parent		= (_parent),				\
+	}
+
+#define DIV_FLAGS(_id, _parent, _name, _reg, _width, _flags, _divflags)	\
+	{								\
+		.id		= (_id),				\
+		.reg		= (_reg),				\
+		.flags		= (_flags),				\
+		.div_flags	= (_divflags),				\
+		.width		= (_width),				\
+		.name		= (_name),				\
+		.parent		= (_parent),				\
+	}
+
+#define DIV_SHARED(_id, _parent, _name, _reg, _width, _shift)		\
+	{								\
+		.id		= (_id),				\
+		.reg		= (_reg),				\
+		.shift		= (_shift),				\
+		.width		= (_width),				\
+		.shared		= 1,					\
+		.name		= (_name),				\
+		.parent		= (_parent),				\
+	}
+
+void tz1090_clk_register_dividers(struct tz1090_clk_provider *p,
+				  const struct tz1090_clk_divider *dividers,
+				  unsigned int count);
+
 #endif
-- 
2.0.4

