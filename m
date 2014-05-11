Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbaEKUYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:24:53 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50416 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbaEKUYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 16:24:51 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] clk: add helper for unique DT clock names
Date: Sun, 11 May 2014 22:24:34 +0200
Message-Id: <1399839881-29895-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, most DT clock drivers pick a unique node name to allow unique
clock names. As ePAPR recommends node names to be generic, we therefore
provide a helper to generate a unique clock name from the DT node name
plus reg property or a magic number instead. This is basically the same
we already do for proper devices and may vanish as soon as there is some
(early) device support for clocks available.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk.c            | 29 +++++++++++++++++++++++++++++
 include/linux/clk-provider.h |  5 +++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dff0373f53c1..b449a635dbfa 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -2543,6 +2544,34 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
 }
 EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
 
+/**
+ * of_clk_create_name() - Allocate and create a unique clock name
+ * @np: Device node pointer of the clock node
+ *
+ * This will allocate and create a unique clock name based on the
+ * reg property value. As a last resort, it will use the node name
+ * followed by a unique number. The caller has to deallocate the
+ * buffer.
+ */
+char *of_clk_create_name(struct device_node *np)
+{
+	static atomic_t clk_no_reg_magic;
+	const __be32 *reg;
+	u64 addr;
+	int magic;
+
+	reg = of_get_property(np, "reg", NULL);
+	if (reg) {
+		addr = of_translate_address(np, reg);
+		return kasprintf(GFP_KERNEL, "%llx.%s",
+				 (unsigned long long)addr, np->name);
+	}
+
+	magic = atomic_add_return(1, &clk_no_reg_magic);
+	return kasprintf(GFP_KERNEL, "%s.%d", np->name, magic);
+}
+EXPORT_SYMBOL_GPL(of_clk_create_name);
+
 struct clock_provider {
 	of_clk_init_cb_t clk_init_cb;
 	struct device_node *np;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 511917416fb0..c6f3ca1cd81c 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -514,6 +514,7 @@ struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
 int of_clk_get_parent_count(struct device_node *np);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
+char *of_clk_create_name(struct device_node *np);
 
 void of_clk_init(const struct of_device_id *matches);
 
@@ -543,6 +544,10 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
 {
 	return NULL;
 }
+static inline char *of_clk_create_name(struct device_node *np)
+{
+	return NULL;
+}
 #define of_clk_init(matches) \
 	{ while (0); }
 #endif /* CONFIG_OF */
-- 
1.9.1

