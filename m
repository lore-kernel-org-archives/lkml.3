Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaCCSX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:23:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43706 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaCCSXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:23:24 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-2d-5314c89a1a7f
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mturquette@linaro.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, grant.likely@linaro.org, mark.rutland@arm.com,
        galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH v2 2/2] clk: Add handling of clk parent and rate assigned
 from DT
Date: Mon, 03 Mar 2014 19:22:55 +0100
Message-id: <1393870975-21020-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jQd3ZJ0SCDb5+ZbGYf+Qcq0X/m4Ws
	Fgf+7GC0aF68ns3ibNMbdotNj6+xWlzeNYfN4vZlXou1R+6yWyy9fpHJ4umEi2wWrXuPsFsc
	ftPOajFj8ks2i/UzXrM48HusmbeG0aOluYfN43JfL5PHplWdbB53ru1h89g/dw27x+Yl9R59
	W1YxenzeJBfAGcVlk5Kak1mWWqRvl8CVcWntY8aCv4YVF1qXsjcwHlbvYuTgkBAwkZi6zquL
	kRPIFJO4cG89G4gtJDCdUeLJ31wIu4NJYke7EojNJmAo0Xu0jxHEFhFwkeh8sI4FxGYWuMUk
	MeWkFIgtLBAusWvFCmYQm0VAVeLbrzawel4BN4k5nx4zQqxVkJgzyQYkzCngLjH7aCczxCo3
	iZczL7JPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4hJ9J72Bc1WBxiFGAg1GJ
	h9dhikiwEGtiWXFl7iFGCQ5mJRHeiBqgEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLp
	iSWp2ampBalFMFkmDk6pBsawbzILjJu+vTHtPjvVQOnK+318hTqq/3wT5aPOTJkRdz1wn1ZZ
	p9iS3OgLjRunbLh99l5Gatxl64q/b7or3KSeOJUuCdj1PU2uXjBQ/+DyOWv8Mpd8zOpzNZx7
	MWF5bumTqj2Ssv0ms+a62+unNSXyvmnUObDv4PniDcs7730wmhapsGzKnnVKLMUZiYZazEXF
	iQB8r3SlXQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function adds a notifier callback run before a driver is bound
to a device. It will configure any parent clocks and clock frequencies
according to values of 'clock-parents' and 'clock-rates' DT properties
respectively.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - the helper function to parse and set assigned clock parents and
   rates made public so it is available to clock providers to call
   directly;
 - dropped the platform bus notification and call of_clk_device_setup()
   is is now called from the driver core, rather than from the
   notification callback;
 - s/of_clk_get_list_entry/of_clk_get_by_property.
---
 .../devicetree/bindings/clock/clock-bindings.txt   |   23 ++++++
 drivers/base/dd.c                                  |    5 ++
 drivers/clk/clk.c                                  |   77 ++++++++++++++++++++
 include/linux/clk-provider.h                       |    6 ++
 4 files changed, 111 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
index 7c52c29..eb8d547 100644
--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -115,3 +115,26 @@ clock signal, and a UART.
   ("pll" and "pll-switched").
 * The UART has its baud clock connected the external oscillator and its
   register clock connected to the PLL clock (the "pll-switched" signal)
+
+==Assigned clock parents and rates==
+
+Some platforms require static configuration of (parts of) the clock controller
+often determined by the board design. Such a configuration can be specified in
+a clock consumer node through clock-parents and clock-rates DT properties.
+The former should contain list of parent clocks in form of phandle and clock
+specifier pairs, the latter the list of assigned clock frequency values
+(one cell each).
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
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..f0cbac1 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
+#include <linux/clk-provider.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -278,6 +279,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (ret)
 		goto probe_failed;
 
+	ret = of_clk_device_setup(dev);
+	if (ret)
+		goto probe_failed;
+
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
 			__func__, dev_name(dev));
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 19f6f3f..6fdc49b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2528,6 +2528,83 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
 EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
 
 /**
+ * of_clk_device_setup() - parse and set clk configuration assigned to a device
+ * @node: device node to apply the configuration for
+ *
+ * This function parses 'clock-parents' and 'clock-rates' properties and sets
+ * any specified clock parents and rates.
+ */
+int of_clk_device_setup(struct device *dev)
+{
+	struct device_node *node = dev->of_node;
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
+
+/**
  * of_clk_init() - Scan and init clock providers from the DT
  * @matches: array of compatible values and init functions for providers.
  *
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 939533d..2cd0fbb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -509,6 +509,7 @@ const char *of_clk_get_parent_name(struct device_node *np, int index);
 
 void of_clk_init(const struct of_device_id *matches);
 
+int of_clk_device_setup(struct device *dev);
 #else /* !CONFIG_OF */
 
 static inline int of_clk_add_provider(struct device_node *np,
@@ -537,6 +538,11 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
 }
 #define of_clk_init(matches) \
 	{ while (0); }
+
+int of_clk_device_setup(struct device *dev)
+{
+	return 0;
+}
 #endif /* CONFIG_OF */
 
 /*
-- 
1.7.9.5

