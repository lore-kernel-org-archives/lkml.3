Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbaLAX0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:26:53 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35387 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbaLAXUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:41 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 01/16] clk: tz1090: add clock provider common code
Date: Mon,  1 Dec 2014 23:19:51 +0000
Message-Id: <1417476006-10407-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some common code for the TZ1090 SoC to allocate and register onecell
based clock providers. These have some memory mapped registers and are
instantiated from DT.

Also provided is a tz1090_clk_xlate() function to help handle external
clocks from other clock providers by processing the internal clock
names.

Parent clocks from other providers can be specified as "@label" where
label is the name of an input clock provided by the clock-names DT
property. tz1090_clk_xlate() translates these strings by finding the
actual name of the parent clock. It first uses
of_property_match_string() to find the index of the matching parent
clock, and then of_clk_get_parent_name() to get its name. Since
of_clk_get_parent_name() uses the parent clock node's clock-output-names
property, this should be specified for any complex input clocks which
use this mechanism.

Clock strings which don't start with '@' are used directly as the parent
clock name. This is intended for other clocks within the clock provider.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-metag@vger.kernel.org
---
New patch in v2
---
 drivers/clk/Makefile        |  1 +
 drivers/clk/tz1090/Makefile |  2 +
 drivers/clk/tz1090/clk.c    | 89 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tz1090/clk.h    | 37 +++++++++++++++++++
 4 files changed, 129 insertions(+)
 create mode 100644 drivers/clk/tz1090/Makefile
 create mode 100644 drivers/clk/tz1090/clk.c
 create mode 100644 drivers/clk/tz1090/clk.h

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index d5fba5b..ca486ed 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_PLAT_SPEAR)		+= spear/
 obj-$(CONFIG_ARCH_STI)			+= st/
 obj-$(CONFIG_ARCH_SUNXI)		+= sunxi/
 obj-$(CONFIG_ARCH_TEGRA)		+= tegra/
+obj-$(CONFIG_SOC_TZ1090)		+= tz1090/
 obj-$(CONFIG_ARCH_OMAP2PLUS)		+= ti/
 obj-$(CONFIG_ARCH_U8500)		+= ux500/
 obj-$(CONFIG_COMMON_CLK_VERSATILE)	+= versatile/
diff --git a/drivers/clk/tz1090/Makefile b/drivers/clk/tz1090/Makefile
new file mode 100644
index 0000000..a2ace14
--- /dev/null
+++ b/drivers/clk/tz1090/Makefile
@@ -0,0 +1,2 @@
+# Makefile for TZ1090-specific clocks
+obj-y		+= clk.o
diff --git a/drivers/clk/tz1090/clk.c b/drivers/clk/tz1090/clk.c
new file mode 100644
index 0000000..5f4e8f28
--- /dev/null
+++ b/drivers/clk/tz1090/clk.c
@@ -0,0 +1,89 @@
+/*
+ * Copyright (C) 2014 Google, Inc.
+ * Copyright (C) 2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Clocks
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
+
+#include "clk.h"
+
+struct tz1090_clk_provider *tz1090_clk_alloc_provider(struct device_node *node,
+						      unsigned int num_clks)
+{
+	struct tz1090_clk_provider *p;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return p;
+
+	p->clk_data.clks = kcalloc(num_clks, sizeof(struct clk *), GFP_KERNEL);
+	if (!p->clk_data.clks)
+		goto free_provider;
+	p->clk_data.clk_num = num_clks;
+	p->node = node;
+	p->base = of_iomap(node, 0);
+	if (!p->base) {
+		pr_err("%s: Failed to map clock provider registers\n",
+		       node->full_name);
+		goto free_clks;
+	}
+
+	return p;
+
+free_clks:
+	kfree(p->clk_data.clks);
+free_provider:
+	kfree(p);
+	return NULL;
+}
+
+const char *tz1090_clk_xlate(struct tz1090_clk_provider *p,
+			     const char *clk_name)
+{
+	/*
+	 * If clock name begins with @, the rest refers to an external clock.
+	 *
+	 * Look for the index of the parent clock with a matching label in
+	 * clock-names. If found, find the name of the specified parent clock.
+	 *
+	 * If not found, we leave it unchanged. The @ at the beginning should
+	 * ensure it doesn't accidentally match a real clock.
+	 */
+	if (*clk_name == '@') {
+		const char *clk_label = clk_name + 1;
+		int idx = of_property_match_string(p->node, "clock-names",
+						   clk_label);
+		if (idx >= 0) {
+			clk_name = of_clk_get_parent_name(p->node, idx);
+			pr_debug("%s: Parent clock '%s' found as '%s'\n",
+				 p->node->full_name, clk_label, clk_name);
+		} else {
+			pr_err("%s: No parent clock '%s' found\n",
+			       p->node->full_name, clk_label);
+		}
+	}
+
+	return clk_name;
+}
+
+void tz1090_clk_register_provider(struct tz1090_clk_provider *p)
+{
+	unsigned int i;
+
+	for (i = 0; i < p->clk_data.clk_num; i++)
+		if (IS_ERR(p->clk_data.clks[i]))
+			pr_warn("%s: Failed to register clock %d: %ld\n",
+				p->node->full_name, i,
+				PTR_ERR(p->clk_data.clks[i]));
+
+	of_clk_add_provider(p->node, of_clk_src_onecell_get, &p->clk_data);
+}
diff --git a/drivers/clk/tz1090/clk.h b/drivers/clk/tz1090/clk.h
new file mode 100644
index 0000000..c20e7b4
--- /dev/null
+++ b/drivers/clk/tz1090/clk.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ *
+ * TZ1090 Clocks
+ */
+
+#ifndef CLK_TZ1090_CLK_H
+#define CLK_TZ1090_CLK_H
+
+#include <linux/clk-provider.h>
+#include <linux/init.h>
+
+/* Generic TZ1090 clock provider */
+
+/**
+ * struct tz1090_clk_provider - Clock provider data.
+ * @node:	Device tree node for the clock provider.
+ * @base:	IO remapped base address.
+ * @clk_data:	Standard onecell clock data including list of clocks.
+ */
+struct tz1090_clk_provider {
+	struct device_node		*node;
+	void __iomem			*base;
+	struct clk_onecell_data		clk_data;
+};
+
+struct tz1090_clk_provider *tz1090_clk_alloc_provider(struct device_node *node,
+						      unsigned int num_clks);
+const char *tz1090_clk_xlate(struct tz1090_clk_provider *p,
+			     const char *clk_name);
+void tz1090_clk_register_provider(struct tz1090_clk_provider *p);
+
+#endif
-- 
2.0.4

