Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaCaQnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:43:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38077 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaCaQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:43:07 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-3d-53399b193d85
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate assigned
 from DT
Date: Mon, 31 Mar 2014 18:41:56 +0200
Message-id: <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jAV2p2ZbBBksPsFnMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu0XnxCXsFpseX2O1uLxrDpvF7cu8FmuP3GW3WHr9IpPF0wkX2Sxa
	9x5ht/i7fROLxeE37awWMya/ZLNYP+M1i4Ogx5p5axg9Wpp72Dwu9/UyeczumMnqsWlVJ5vH
	nWt72Dz2z13D7rF5Sb1H/18Dj74tqxg9Pm+SC+CO4rJJSc3JLEst0rdL4MpYvXguc8F1r4qD
	J4IaGF9bdTFyckgImEi8ubibDcIWk7hwbz2YLSSwiFFi2ZaELkYuILuDSWLngTtMIAk2AUOJ
	3qN9jCC2iICNRM+Wk4wgRcwC85kljj85AdYtLBAucfzIElYQm0VAVaLn8m52EJtXwE3izsd9
	QA0cQNsUJOZMsgEJcwq4Syza9pURYrGbxNynm5gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iREc7M+kdjCubLA4xCjAwajEw2tRbhksxJpYVlyZe4hRgoNZSYT3yHSgEG9KYmVV
	alF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZdmyalR+T+8tdfPCco
	R4KzdZfN2wCbGabHbvTO9pBe4HfvwS8/161ygVK9bNtmv+3ZuGzzVIcT52q703TetvzqT3dt
	r5z64NaH3J5TMR91nv5bk8dyuVyyRm6zY4/Mf79Vn1Uz5cPr936wZ1WoEHzJmGCipCdfx+13
	hXfP4jPejWfWRgWY7lRiKc5INNRiLipOBADbP39McgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function adds a helper function to configure clock parents and rates
as specified in clock-parents, clock-rates DT properties for a consumer
device and a call to it before driver is bound to a device.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
Changes since v3:
 - added detailed description of the assigned-clocks subnode,
 - clk-conf.c is now excluded when CONFIG_OF is not set,
 - s/of_clk_device_setup/of_clk_device_init,
 - added missing 'static inline' to the function stub definition.

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
 .../devicetree/bindings/clock/clock-bindings.txt   |   42 ++++++++++
 drivers/base/dd.c                                  |    7 ++
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-conf.c                             |   87 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   10 ++-
 include/linux/clk/clk-conf.h                       |   19 +++++
 6 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
index 700e7aa..59fbb4e 100644
--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -132,3 +132,45 @@ clock signal, and a UART.
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
+Configuring a clock parent and rate through the device node that uses
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
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..4c633e7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
+#include <linux/clk/clk-conf.h>

 #include "base.h"
 #include "power/power.h"
@@ -278,6 +279,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (ret)
 		goto probe_failed;

+	if (dev->of_node) {
+		ret = of_clk_device_init(dev->of_node);
+		if (ret)
+			goto probe_failed;
+	}
+
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
 			__func__, dev_name(dev));
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 85a33e6..5ec53cb 100644
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
index 0000000..a2e992e
--- /dev/null
+++ b/drivers/clk/clk-conf.c
@@ -0,0 +1,87 @@
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
+ * of_clk_device_init() - parse and set clk configuration assigned to a device
+ * @node: device node to apply the configuration for
+ *
+ * This function parses 'clock-parents' and 'clock-rates' properties and sets
+ * any specified clock parents and rates.
+ */
+int of_clk_device_init(struct device_node *node)
+{
+	struct property	*prop;
+	const __be32 *cur;
+	int rc, index, num_parents;
+	struct clk *clk, *pclk;
+	u32 rate;
+
+	num_parents = of_count_phandle_with_args(node, "clock-parents",
+						 "#clock-cells");
+	if (num_parents == -EINVAL)
+		pr_err("clk: Invalid value of clock-parents property at %s\n",
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
+		else
+			pr_debug("clk: set %s as parent of %s\n",
+				 __clk_get_name(pclk), __clk_get_name(clk));
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
+			else
+				pr_debug("clk: set rate of clock %s to %lu\n",
+					 __clk_get_name(clk), clk_get_rate(clk));
+		}
+		index++;
+	}
+
+	return 0;
+}
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dff0373..ea6d8bd 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -10,6 +10,7 @@
  */

 #include <linux/clk-private.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -2620,7 +2621,15 @@ void __init of_clk_init(const struct of_device_id *matches)
 		list_for_each_entry_safe(clk_provider, next,
 					&clk_provider_list, node) {
 			if (force || parent_ready(clk_provider->np)) {
+
 				clk_provider->clk_init_cb(clk_provider->np);
+
+				/* Set any assigned clock parents and rates */
+				np = of_get_child_by_name(clk_provider->np,
+							  "assigned-clocks");
+				if (np)
+					of_clk_device_init(np);
+
 				list_del(&clk_provider->node);
 				kfree(clk_provider);
 				is_init_done = true;
@@ -2635,7 +2644,6 @@ void __init of_clk_init(const struct of_device_id *matches)
 		 */
 		if (!is_init_done)
 			force = true;
-
 	}
 }
 #endif
diff --git a/include/linux/clk/clk-conf.h b/include/linux/clk/clk-conf.h
new file mode 100644
index 0000000..51b9c01
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
+int of_clk_device_init(struct device_node *node);
+#else
+static inline int of_clk_device_init(struct device_node *node)
+{
+	return 0;
+}
+#endif
--
1.7.9.5

