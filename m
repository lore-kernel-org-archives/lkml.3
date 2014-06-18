Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966028AbaFRKt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:49:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25374 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965512AbaFRKt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:49:57 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-4d-53a16ed2484b
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, devicetree@vger.kernel.org
Cc: wsa@the-dreams.de, broonie@kernel.org,
        linux-arm-kernel@lists.infradead.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, gregkh@linuxfoundation.org,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC V7] clk: Support for clock parents and rates assigned from
 device tree
Date: Wed, 18 Jun 2014 12:47:16 +0200
Message-id: <1403088436-29956-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403088436-29956-1-git-send-email-s.nawrocki@samsung.com>
References: <1403088436-29956-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jQd1LeQuDDV5OtrCY+vAJm8X8I+dY
	LfrfLGS1aF68ns3ibNMbdotNj6+xWnT8/cJocXnXHDaLxo832S2WXr/IZPF0wkU2iwnT17JY
	HH7Tzmqx8sQsZgc+jzXz1jB6XO7rZfLYtKqTzePOtT1sHvvnrmH32Lyk3qNvyypGj5OnnrB4
	fN4kF8AZxWWTkpqTWZZapG+XwJVxcdlbxoJt5RUrXt9ha2CcEd/FyMkhIWAi0bN9OzOELSZx
	4d56ti5GLg4hgemMEif2rIZyOpgkui7/ZwSpYhMwlOg92gdmiwiYSry7/o0JxGYWuMgk8fOo
	J4gtLBAjseH/LTYQm0VAVWJH72ewel4BN4mftzcB2RxA2xQk5kyyATE5BdwlPt6SA6kQAqpY
	dnob0wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP3mdQOxpUNFocYBTgYlXh4
	OXIXBAuxJpYVV+YeYpTgYFYS4X2ZujBYiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0
	xJLU7NTUgtQimCwTB6dUAyOz4eFJpVc/+GUW7HlvqP89b9vLQ98PdMa3n73F33leuf3ib+aJ
	UT++e5w41VQRy2N84cCzFqO4VZOfP/g442J7wsvynxNTrtyT2F+whaGtdp/Zn+CABY4lmp9b
	JY6vut96ecmxwu23P+98oBxjair7pbpgWk7WFRc+llMTFma3L01MVWPW/qOvxFKckWioxVxU
	nAgAiUYd+FsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds helper functions to configure clock parents and rates
as specified through 'assigned-clock-parents', 'assigned-clock-rates'
DT properties for a clock provider or clock consumer device.
The helpers are now being called by the bus code for the platform, I2C
and SPI busses, before the driver probing and also in the clock core
after registration of a clock provider.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v6:
 - use a set of separate DT properties to specify the default parent
   clocks and rates;
 - the clock defaults setting extended to the I2C and SPI busses;
 - added struct dev_clk_info to struct device so we can prevent multiple
   calls to clk_dev_set_defaults() in case of deferred probing.

Changes since v5:
 - updated the DT binding description (dropped 'assigned-clocks' node);
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
 .../devicetree/bindings/clock/clock-bindings.txt   |   36 +++++
 drivers/base/platform.c                            |    5 +
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-conf.c                             |  154 ++++++++++++++++++++
 drivers/clk/clk.c                                  |   12 +-
 drivers/i2c/i2c-core.c                             |    5 +
 drivers/spi/spi.c                                  |    5 +
 include/linux/clk/clk-conf.h                       |   33 +++++
 include/linux/device.h                             |    4 +
 9 files changed, 255 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 include/linux/clk/clk-conf.h

diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
index f1578781..06fc6d5 100644
--- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
+++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
@@ -131,3 +131,39 @@ clock signal, and a UART.
   ("pll" and "pll-switched").
 * The UART has its baud clock connected the external oscillator and its
   register clock connected to the PLL clock (the "pll-switched" signal)
+
+==Assigned clock parents and rates==
+
+Some platforms may require initial configuration of default parent clocks
+and clock frequencies. Such a configuration can be specified in a device tree
+node through assigned-clocks, assigned-clock-parents and assigned-clock-rates
+properties. The assigned-clock-parents property should contain a list of parent
+clocks in form of phandle and clock specifier pairs, the assigned-clock-parents
+property the list of assigned clock frequency values - corresponding to clocks
+listed in the assigned-clocks property.
+
+To skip setting parent or rate of a clock its corresponding entry should be
+set to 0, or can be omitted if it is not followed by any non-zero entry.
+
+    uart@a000 {
+        compatible = "fsl,imx-uart";
+        reg = <0xa000 0x1000>;
+        ...
+        clocks = <&osc 0>, <&pll 1>;
+        clock-names = "baud", "register";
+
+        assigned-clocks = <&clkcon 0>, <&pll 2>;
+        assigned-clock-parents = <&pll 2>;
+        assigned-clock-rates = <0>, <460800>;
+    };
+
+In this example the <&pll 2> clock is set as parent of clock <&clkcon 0> and
+the <&pll 2> clock is assigned a frequency value of 460800 Hz.
+
+Configuring a clock's parent and rate through the device node that consumes
+the clock can be done only for clocks that have a single user. Specifying
+conflicting parent or rate configuration in multiple consumer nodes for
+a shared clock is forbidden.
+
+Configuration of common clocks, which affect multiple consumer devices can
+be similarly specified in the clock provider node.
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 9e9227e..cbb5528 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -23,6 +23,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/idr.h>
 #include <linux/acpi.h>
+#include <linux/clk/clk-conf.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -489,6 +490,10 @@ static int platform_drv_probe(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;
 
+	ret = clk_dev_set_defaults(_dev, false);
+	if (ret < 0)
+		return ret;
+
 	acpi_dev_pm_attach(_dev, true);
 
 	ret = drv->probe(dev);
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 567f102..7c5ecd6 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -9,6 +9,9 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-fractional-divider.o
+ifeq ($(CONFIG_OF), y)
+obj-$(CONFIG_COMMON_CLK)	+= clk-conf.o
+endif
 
 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
new file mode 100644
index 0000000..e7141e1
--- /dev/null
+++ b/drivers/clk/clk-conf.c
@@ -0,0 +1,154 @@
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
+#include <linux/clk/clk-conf.h>
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
+	num_parents = of_count_phandle_with_args(node, "assigned-clock-parents",
+						 "#clock-cells");
+	if (num_parents == -EINVAL)
+		pr_err("clk: invalid value of clock-parents property at %s\n",
+		       node->full_name);
+
+	for (index = 0; index < num_parents; index++) {
+		rc = of_parse_phandle_with_args(node, "assigned-clock-parents",
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
+		rc = of_parse_phandle_with_args(node, "assigned-clocks",
+					"#clock-cells", index, &clkspec);
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
+	of_property_for_each_u32(node, "assigned-clock-rates", prop, cur, rate) {
+		if (rate) {
+			rc = of_parse_phandle_with_args(node, "assigned-clocks",
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
+ * clk_of_set_defaults() - parse and set assigned clocks configuration
+ * @node: device node to apply clock settings for
+ * @self_consumer: true to indicate @node may also consume clocks it supplies
+ *
+ * This function parses 'clock-parents' and 'clock-rates' properties and sets
+ * any specified clock parents and rates. The @self_consumer argument should be
+ * set to true if @node may be also a clock supplier of any clock listed in its
+ * 'clocks' or 'clock-parents' properties. Otherwise the functions exits as soon
+ * as it determines the @node is also a supplier of any of the clocks.
+ */
+int clk_of_set_defaults(struct device_node *node, bool self_consumer)
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
+
+int clk_dev_set_defaults(struct device *dev, bool self_consumer)
+{
+	int rc = 0;
+
+	if (!dev->clk_info->assigned_conf) {
+		rc = clk_of_set_defaults(dev->of_node, self_consumer);
+		if (!rc)
+			dev->clk_info->assigned_conf = 1;
+	}
+	return rc;
+}
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73ede..ff17b53 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/clk-private.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -2414,6 +2415,7 @@ int of_clk_add_provider(struct device_node *np,
 			void *data)
 {
 	struct of_clk_provider *cp;
+	int ret;
 
 	cp = kzalloc(sizeof(struct of_clk_provider), GFP_KERNEL);
 	if (!cp)
@@ -2428,7 +2430,11 @@ int of_clk_add_provider(struct device_node *np,
 	mutex_unlock(&of_clk_mutex);
 	pr_debug("Added clock from %s\n", np->full_name);
 
-	return 0;
+	ret = clk_of_set_defaults(np, true);
+	if (ret < 0)
+		of_clk_del_provider(np);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(of_clk_add_provider);
 
@@ -2605,7 +2611,10 @@ void __init of_clk_init(const struct of_device_id *matches)
 		list_for_each_entry_safe(clk_provider, next,
 					&clk_provider_list, node) {
 			if (force || parent_ready(clk_provider->np)) {
+
 				clk_provider->clk_init_cb(clk_provider->np);
+				clk_of_set_defaults(clk_provider->np, true);
+
 				list_del(&clk_provider->node);
 				kfree(clk_provider);
 				is_init_done = true;
@@ -2620,7 +2629,6 @@ void __init of_clk_init(const struct of_device_id *matches)
 		 */
 		if (!is_init_done)
 			force = true;
-
 	}
 }
 #endif
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7c7f4b8..2142530 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -42,6 +42,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/completion.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
@@ -274,6 +275,10 @@ static int i2c_device_probe(struct device *dev)
 					client->flags & I2C_CLIENT_WAKE);
 	dev_dbg(dev, "probe\n");
 
+	status = clk_dev_set_defaults(dev, false);
+	if (status < 0)
+		return status;
+
 	acpi_dev_pm_attach(&client->dev, true);
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
 	if (status)
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index d4f9670..0e4e4d3 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/slab.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
@@ -259,6 +260,10 @@ static int spi_drv_probe(struct device *dev)
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
 	int ret;
 
+	ret = clk_dev_set_defaults(dev, false);
+	if (ret)
+		return ret;
+
 	acpi_dev_pm_attach(dev, true);
 	ret = sdrv->probe(to_spi_device(dev));
 	if (ret)
diff --git a/include/linux/clk/clk-conf.h b/include/linux/clk/clk-conf.h
new file mode 100644
index 0000000..7e07950
--- /dev/null
+++ b/include/linux/clk/clk-conf.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/**
+ * struct dev_clk_info - clock state container for devices
+ * @assigned_conf: set to 1 if the clock defaults are set successfully
+ */
+struct dev_clk_info {
+	unsigned int assigned_conf;
+};
+
+struct device_node;
+
+#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
+int clk_of_set_defaults(struct device_node *node, bool self_consumer);
+int clk_dev_set_defaults(struct device *dev, bool self_consumer);
+#else
+static inline int clk_of_set_defaults(struct device_node *node,
+				      bool self_consumer)
+{
+	return 0;
+}
+int clk_dev_set_defaults(struct device *dev, bool self_consumer)
+{
+	return 0;
+}
+#endif
diff --git a/include/linux/device.h b/include/linux/device.h
index af424ac..ff0a98c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -751,6 +751,10 @@ struct device {
 	struct dev_pin_info	*pins;
 #endif
 
+#ifdef CONFIG_COMMON_CLK
+	struct dev_clk_info	*clk_info;
+#endif
+
 #ifdef CONFIG_NUMA
 	int		numa_node;	/* NUMA node this device is close to */
 #endif
-- 
1.7.9.5

