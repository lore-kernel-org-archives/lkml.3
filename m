Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbaESR0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:26:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55374 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaESR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:26:14 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-62-537a3eb30257
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        mturquette@linaro.org
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, pawel.moll@arm.com,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC V6 2/2] clk: Add handling of clk parent and rate assigned
 from DT
Date: Mon, 19 May 2014 19:22:51 +0200
Message-id: <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
References: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jAd3NdlXBBrOWWFrMP3KO1aL/zUJW
	iwN/djBanG16w26x6fE1VovLu+awWdy+zGux9shddoul1y8yWTydcJHNYsL0tSwWrXuPsFsc
	ftPOajFj8ks2i/UzXrM48HusmbeG0aOluYfN43JfL5PHplWdbB53ru1h89i8pN6jb8sqRo/P
	m+QCOKK4bFJSczLLUov07RK4Mu7dn89ccCGhouPIEbYGxrU+XYycHBICJhINHetYIWwxiQv3
	1rN1MXJxCAksYpTonj6fEcLpYJJ4c/EsI0gVm4ChRO/RPjBbRCBWYsOzvWBFzAK7mSTWfzoC
	NkpYIFzi/qvZLCA2i4CqRGP3TyYQm1fAVWL1qnVANgfQOgWJOZNsQMKcAm4ST99MYwUJCwGV
	nHvgMYGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4PB9JrWDcWWDxSFGAQ5GJR7e
	A+JVwUKsiWXFlbmHGCU4mJVEeN1MgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeW
	pGanphakFsFkmTg4pRoYC5RFOszCpO+sb76S1SH3apc0y34dq+r5m688fGZ0atYt5WM/z9/c
	9dzh1qkoZebjb04s+PfCxCOgUuy1yYoMnutxJ4qlH3tG7vJsKllX45Tz4/LNb9u9l7ofrc67
	Ejuh/Y1ivlFj0hmerxuX1n7vVWW+myVaf+fXxYVyfbv4KzwytscJXxXRV2Ipzkg01GIuKk4E
	ABQ9uCxbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function to configure clock parents and
rates as specified in clock-parents, clock-rates DT properties
for a consumer device and a call to it before driver is bound to
a device.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
Changes since v5:
 - updated the DT binding description (dropped 'assigned-clocks'
   node);
 - fixed detecting of null phandles (ENOENT error handling);
 - modified of_clk_init() to account for that the clocks property may now
   contain a clock specifier with a phandle that points to our node;

Changes since v4:
 - added note explaining how to skip setting parent and rate
   of a clock,
 - moved of_clk_dev_init() calls to the platform bus,
 - added missing call to of_node_put(),
 - dropped debug traces.

Changes since v3:
 - added detailed description of the assigned-clocks subnode,
 - added missing 'static inline' to the function stub definition,
 - clk-conf.c is now excluded when CONFIG_OF is not set,
 - s/of_clk_device_setup/of_clk_device_init.

Changes since v2:
 - edited in clock-bindings.txt, added note about 'assigned-clocks'
   subnode which may be used to specify "global" clocks configuration
   at a clock provider node,
 - moved of_clk_device_setup() function declaration from clk-provider.h
   to clk-conf.h so required function stubs are available when
   CONFIG_COMMON_CLK is not enabled,

Changes since v1:
 - the helper function to parse and set assigned clock parents and
   rates made public so it is available to clock providers to call
   directly;
 - dropped the platform bus notification and call of_clk_device_setup()
   is is now called from the driver core, rather than from the
   notification callback;
 - s/of_clk_get_list_entry/of_clk_get_by_property.
---
 .../devicetree/bindings/clock/clock-bindings.txt   |   32 +++++
 drivers/base/platform.c                            |    5 +
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-conf.c                             |  141 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   27 +++-
 include/linux/clk/clk-conf.h                       |   20 +++
 6 files changed, 225 insertions(+), 3 deletions(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
index 700e7aa..bee649b 100644
--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -132,3 +132,35 @@ clock signal, and a UART.
   ("pll" and "pll-switched").
 * The UART has its baud clock connected the external oscillator and its
   register clock connected to the PLL clock (the "pll-switched" signal)
+
+==Assigned clock parents and rates==
+
+Some platforms require static initial configuration of default parent clocks
+and clock frequecies. Such a configuration can be specified in a device node
+through clock-parents and clock-rates DT properties. The former should contain
+a list of parent clocks in form of phandle and clock specifier pairs, the
+latter the list of assigned clock frequency values (one cell each).
+To skip setting parent or rate of a clock its corresponding entry should be
+set to 0, or can be omitted if it is not followed by any non-zero entry.
+
+    uart@a000 {
+        compatible = "fsl,imx-uart";
+        reg = <0xa000 0x1000>;
+        ...
+        clocks = <&clkcon 0>, <&clkcon 3>;
+        clock-names = "baud", "mux";
+
+        clock-parents = <0>, <&pll 1>;
+        clock-rates = <460800>;
+    };
+
+In this example the pll is set as parent of "mux" clock and frequency of
+"baud" clock is specified as 460800 Hz.
+
+Configuring a clock's parent and rate through the device node that consumes
+the clock can be done only for clocks that have a single user. Specifying
+conflicting parent or rate configuration in multiple consumer nodes for
+a shared clock is forbidden.
+
+Configuration of common clocks, which affect multiple consumer devices can
+be similarly specified in the clock provider node.
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 5b47210..f622733 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -23,6 +23,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/idr.h>
 #include <linux/acpi.h>
+#include <linux/clk/clk-conf.h>

 #include "base.h"
 #include "power/power.h"
@@ -486,6 +487,10 @@ static int platform_drv_probe(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;

+	ret = of_clk_set_defaults(_dev->of_node, false);
+	if (ret < 0)
+		return ret;
+
 	acpi_dev_pm_attach(_dev, true);

 	ret = drv->probe(dev);
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5f8a287..45598f7 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -8,6 +8,9 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
+ifeq ($(CONFIG_OF), y)
+obj-$(CONFIG_COMMON_CLK)	+= clk-conf.o
+endif

 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
new file mode 100644
index 0000000..0bf26d5
--- /dev/null
+++ b/drivers/clk/clk-conf.c
@@ -0,0 +1,141 @@
+/*
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/printk.h>
+#include "clk.h"
+
+static int __set_clk_parents(struct device_node *node, bool self_consumer)
+{
+	struct of_phandle_args clkspec;
+	int index, rc, num_parents;
+	struct clk *clk, *pclk;
+
+	num_parents = of_count_phandle_with_args(node, "clock-parents",
+						 "#clock-cells");
+	if (num_parents == -EINVAL)
+		pr_err("clk: invalid value of clock-parents property at %s\n",
+		       node->full_name);
+
+	for (index = 0; index < num_parents; index++) {
+		rc = of_parse_phandle_with_args(node, "clock-parents",
+					"#clock-cells",	index, &clkspec);
+		if (rc < 0) {
+			/* skip empty (null) phandles */
+			if (rc == -ENOENT)
+				continue;
+			else
+				return rc;
+		}
+		if (clkspec.np == node && !self_consumer)
+			return 0;
+		pclk = of_clk_get_by_clkspec(&clkspec);
+		if (IS_ERR(pclk)) {
+			pr_warn("clk: couldn't get parent clock %d for %s\n",
+				index, node->full_name);
+			return PTR_ERR(pclk);
+		}
+
+		rc = of_parse_phandle_with_args(node, "clocks",	"#clock-cells",
+						index, &clkspec);
+		if (rc < 0)
+			goto err;
+		if (clkspec.np == node && !self_consumer) {
+			rc = 0;
+			goto err;
+		}
+		clk = of_clk_get_by_clkspec(&clkspec);
+		if (IS_ERR(pclk)) {
+			pr_warn("clk: couldn't get parent clock %d for %s\n",
+				index, node->full_name);
+			rc = PTR_ERR(pclk);
+			goto err;
+		}
+
+		rc = clk_set_parent(clk, pclk);
+		if (rc < 0)
+			pr_err("clk: failed to reparent %s to %s: %d\n",
+			       __clk_get_name(clk), __clk_get_name(pclk), rc);
+		clk_put(clk);
+		clk_put(pclk);
+	}
+	return 0;
+err:
+	clk_put(pclk);
+	return rc;
+}
+
+static int __set_clk_rates(struct device_node *node, bool self_consumer)
+{
+	struct of_phandle_args clkspec;
+	struct property	*prop;
+	const __be32 *cur;
+	int rc, index = 0;
+	struct clk *clk;
+	u32 rate;
+
+	of_property_for_each_u32(node, "clock-rates", prop, cur, rate) {
+		if (rate) {
+			rc = of_parse_phandle_with_args(node, "clocks",
+					"#clock-cells",	index, &clkspec);
+			if (rc < 0) {
+				/* skip empty (null) phandles */
+				if (rc == -ENOENT)
+					continue;
+				else
+					return rc;
+			}
+			if (clkspec.np == node && !self_consumer)
+				return 0;
+
+			clk = of_clk_get_by_clkspec(&clkspec);
+			if (IS_ERR(clk)) {
+				pr_warn("clk: couldn't get clock %d for %s\n",
+					index, node->full_name);
+				return PTR_ERR(clk);
+			}
+
+			rc = clk_set_rate(clk, rate);
+			if (rc < 0)
+				pr_err("clk: couldn't set %s clock rate: %d\n",
+				       __clk_get_name(clk), rc);
+			clk_put(clk);
+		}
+		index++;
+	}
+	return 0;
+}
+
+/**
+ * of_clk_set_defaults() - parse and set assigned clocks configuration
+ * @node: device node to apply clock settings for
+ * @self_consumer: true to indicate @node may also consume clocks it supplies
+ *
+ * This function parses 'clock-parents' and 'clock-rates' properties and sets
+ * any specified clock parents and rates. The @self_consumer argument should be
+ * set to true if @node may be also a clock supplier of any clock listed in its
+ * 'clocks' or 'clock-parents' properties. Otherwise the functions exits as soon
+ * as it determines the @node is also a supplier of any of the clocks.
+ */
+int of_clk_set_defaults(struct device_node *node, bool self_consumer)
+{
+	int rc;
+
+	if (!node)
+		return 0;
+
+	rc = __set_clk_parents(node, self_consumer);
+	if (rc < 0)
+		return rc;
+
+	return __set_clk_rates(node, self_consumer);
+}
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dff0373..3a8947d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -10,6 +10,7 @@
  */

 #include <linux/clk-private.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -2429,6 +2430,7 @@ int of_clk_add_provider(struct device_node *np,
 			void *data)
 {
 	struct of_clk_provider *cp;
+	int ret;

 	cp = kzalloc(sizeof(struct of_clk_provider), GFP_KERNEL);
 	if (!cp)
@@ -2443,7 +2445,11 @@ int of_clk_add_provider(struct device_node *np,
 	mutex_unlock(&of_clk_mutex);
 	pr_debug("Added clock from %s\n", np->full_name);

-	return 0;
+	ret = of_clk_set_defaults(np, true);
+	if (ret < 0)
+		of_clk_del_provider(np);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(of_clk_add_provider);

@@ -2558,10 +2564,23 @@ static LIST_HEAD(clk_provider_list);
  */
 static int parent_ready(struct device_node *np)
 {
+	struct of_phandle_args clkspec;
 	int i = 0;

 	while (true) {
-		struct clk *clk = of_clk_get(np, i);
+		struct clk *clk;
+
+		int rc = of_parse_phandle_with_args(np, "clocks",
+				"#clock-cells", i, &clkspec);
+		if (!rc) {
+			if (clkspec.np == np) {
+				i++;
+				continue;
+			}
+			clk = of_clk_get_by_clkspec(&clkspec);
+		} else {
+			clk = ERR_PTR(rc);
+		}

 		/* this parent is ready we can check the next one */
 		if (!IS_ERR(clk)) {
@@ -2620,7 +2639,10 @@ void __init of_clk_init(const struct of_device_id *matches)
 		list_for_each_entry_safe(clk_provider, next,
 					&clk_provider_list, node) {
 			if (force || parent_ready(clk_provider->np)) {
+
 				clk_provider->clk_init_cb(clk_provider->np);
+				of_clk_set_defaults(np, true);
+
 				list_del(&clk_provider->node);
 				kfree(clk_provider);
 				is_init_done = true;
@@ -2635,7 +2657,6 @@ void __init of_clk_init(const struct of_device_id *matches)
 		 */
 		if (!is_init_done)
 			force = true;
-
 	}
 }
 #endif
diff --git a/include/linux/clk/clk-conf.h b/include/linux/clk/clk-conf.h
new file mode 100644
index 0000000..0a1f311
--- /dev/null
+++ b/include/linux/clk/clk-conf.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+struct device_node;
+
+#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
+int of_clk_set_defaults(struct device_node *node, bool self_consumer);
+#else
+static inline int of_clk_set_defaults(struct device_node *node,
+				      bool self_consumer)
+{
+	return 0;
+}
+#endif
--
1.7.9.5

