Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbaDIL1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:27:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32008 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaDIL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:27:12 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-b1-53452e8e6ff2
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mturquette@linaro.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, grant.likely@linaro.org, mark.rutland@arm.com,
        galak@codeaurora.org, laurent.pinchart@ideasonboard.com,
        s.hauer@pengutronix.de, ben.dooks@codethink.co.uk,
        pdeschrijver@nvidia.com, kyungmin.park@samsung.com, t-kristo@ti.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v5 2/2] clk: Add handling of clk parent and rate assigned
 from DT
Date: Wed, 09 Apr 2014 13:26:30 +0200
Message-id: <1397042790-10636-3-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
References: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAd0+Pddgg/8b1C0e3Gplsph/5Byr
	Rf+bhawWB/7sYLRoXryezeJs0xt2i86JS9gtNj2+xmpxedccNovbl3kt1h65y26x9PpFJoun
	Ey6yWUxaO5XRonXvEXaLv9s3sVgcftPOajFj8ks2iyVPO9gs1s94zeIg4rFm3hpGj5bmHjaP
	y329TB7PXk5m8pjdMZPVY9OqTjaPO9f2sHnsn7uG3WPzknqP3uZ3bB79fw08+rasYvQ4fmM7
	k8fnTXIBfFFcNimpOZllqUX6dglcGXdbbzEWvPaumHtboYHxqnUXIweHhICJxPPtvF2MnECm
	mMSFe+vZuhi5OIQEFjFKrGrbwgThdDBJbHh7lhWkik3AUKL3aB8jiC0i4CLR+WAdC0gRs8A9
	Zonj5+ewgCSEBcIluk/8ZgOxWQRUJU4+ewBm8wq4Sbw58psRYrOCxJxJNiBhTgF3iW1fm8Fm
	CgGVfLg+n2kCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGR8kxqB+PKBotDjAIc
	jEo8vIqWLsFCrIllxZW5hxglOJiVRHifs7kGC/GmJFZWpRblxxeV5qQWH2KU5mBREuc90God
	KCSQnliSmp2aWpBaBJNl4uCUamCs0Fp/lv28yQQu1+da3T6zS40uLFuRwlq+ZHmYoU9buJhq
	0RL+KzsMzOIuMm148SFwQn3i6b9BClyeHBaSCyYEP1x34m/Ud63CN8m5r9fFpe9P0ek68rzK
	StB+13RfiXPRloGBf/KdZjPnL2M2WjI3+sHFbk39Rf69K2fIuE1zCeb9Hef9g0uJpTgj0VCL
	uag4EQC1V+QmkAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper function to configure clock parents and
rates as specified in clock-parents, clock-rates DT properties
for a consumer device and a call to it before driver is bound to
a device.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
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
 .../devicetree/bindings/clock/clock-bindings.txt   |   44 ++++++++++
 drivers/base/platform.c                            |    5 ++
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-conf.c                             |   85 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   12 ++-
 include/linux/clk/clk-conf.h                       |   19 +++++
 6 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
index 700e7aa..93513fc 100644
--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -132,3 +132,47 @@ clock signal, and a UART.
   ("pll" and "pll-switched").
 * The UART has its baud clock connected the external oscillator and its
   register clock connected to the PLL clock (the "pll-switched" signal)
+
+==Assigned clock parents and rates==
+
+Some platforms require static initial configuration of parts of the clocks
+controller. Such a configuration can be specified in a clock consumer node
+through clock-parents and clock-rates DT properties. The former should
+contain a list of parent clocks in form of phandle and clock specifier pairs,
+the latter the list of assigned clock frequency values (one cell each).
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
+In this example the pll is set as parent of "mux" clock and frequency of "baud"
+clock is specified as 460800 Hz.
+
+Configuring a clock's parent and rate through the device node that uses
+the clock can be done only for clocks that have a single user. Specifying
+conflicting parent or rate configuration in multiple consumer nodes for
+a shared clock is forbidden.
+
+Configuration of common clocks, which affect multiple consumer devices
+can be specified in a dedicated 'assigned-clocks' subnode of a clock
+provider node, e.g.:
+
+    clkcon {
+        ...
+        #clock-cells = <1>;
+
+        assigned-clocks {
+            clocks = <&clkcon 16>, <&clkcon 17>;
+            clock-parents = <0>, <&clkcon 1>;
+            clock-rates = <200000>;
+        };
+    };
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index e714709..4b95322 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -22,6 +22,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/idr.h>
 #include <linux/acpi.h>
+#include <linux/clk/clk-conf.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -481,6 +482,10 @@ static int platform_drv_probe(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;
 
+	ret = of_clk_dev_init(_dev->of_node);
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
index 0000000..c0d4096
--- /dev/null
+++ b/drivers/clk/clk-conf.c
@@ -0,0 +1,85 @@
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
+
+/**
+ * of_clk_dev_init() - parse and set clk configuration assigned to a device
+ * @node: device node to apply the configuration for
+ *
+ * This function parses 'clock-parents' and 'clock-rates' properties and sets
+ * any specified clock parents and rates.
+ */
+int of_clk_dev_init(struct device_node *node)
+{
+	struct property	*prop;
+	const __be32 *cur;
+	int rc, index, num_parents;
+	struct clk *clk, *pclk;
+	u32 rate;
+
+	if (!node)
+		return 0;
+
+	num_parents = of_count_phandle_with_args(node, "clock-parents",
+						 "#clock-cells");
+	if (num_parents == -EINVAL)
+		pr_err("clk: invalid value of clock-parents property at %s\n",
+		       node->full_name);
+
+	for (index = 0; index < num_parents; index++) {
+		pclk = of_clk_get_by_property(node, "clock-parents", index);
+		if (IS_ERR(pclk)) {
+			/* skip empty (null) phandles */
+			if (PTR_ERR(pclk) == -ENOENT)
+				continue;
+
+			pr_warn("clk: couldn't get parent clock %d for %s\n",
+				index, node->full_name);
+
+			return PTR_ERR(pclk);
+		}
+
+		clk = of_clk_get(node, index);
+		if (IS_ERR(clk)) {
+			pr_warn("clk: couldn't get clock %d for %s\n",
+				index, node->full_name);
+			return PTR_ERR(clk);
+		}
+
+		rc = clk_set_parent(clk, pclk);
+		if (rc < 0)
+			pr_err("clk: failed to reparent %s to %s: %d\n",
+			       __clk_get_name(clk), __clk_get_name(pclk), rc);
+	}
+
+	index = 0;
+	of_property_for_each_u32(node, "clock-rates", prop, cur, rate) {
+		if (rate) {
+			clk = of_clk_get(node, index);
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
+		}
+		index++;
+	}
+
+	return 0;
+}
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dff0373..0d72a4d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/clk-private.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -2620,7 +2621,17 @@ void __init of_clk_init(const struct of_device_id *matches)
 		list_for_each_entry_safe(clk_provider, next,
 					&clk_provider_list, node) {
 			if (force || parent_ready(clk_provider->np)) {
+
 				clk_provider->clk_init_cb(clk_provider->np);
+
+				/* Set any assigned clock parents and rates */
+				np = of_get_child_by_name(clk_provider->np,
+							  "assigned-clocks");
+				if (np) {
+					of_clk_dev_init(np);
+					of_node_put(np);
+				}
+
 				list_del(&clk_provider->node);
 				kfree(clk_provider);
 				is_init_done = true;
@@ -2635,7 +2646,6 @@ void __init of_clk_init(const struct of_device_id *matches)
 		 */
 		if (!is_init_done)
 			force = true;
-
 	}
 }
 #endif
diff --git a/include/linux/clk/clk-conf.h b/include/linux/clk/clk-conf.h
new file mode 100644
index 0000000..afb4228
--- /dev/null
+++ b/include/linux/clk/clk-conf.h
@@ -0,0 +1,19 @@
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
+int of_clk_dev_init(struct device_node *node);
+#else
+static inline int of_clk_dev_init(struct device_node *node)
+{
+	return 0;
+}
+#endif
-- 
1.7.9.5

