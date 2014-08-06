Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaHFNt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:49:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57012 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaHFNri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:47:38 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <mturquette@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <airlied@linux.ie>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <bcousson@baylibre.com>
CC: <tony@atomide.com>, <broonie@kernel.org>,
        <liam.r.girdwood@linux.intel.com>, <peter.ujfalusi@ti.com>,
        <detheridge@ti.com>, <zonque@gmail.com>, <t-kristo@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 2/9] clk: add gpio controlled clock
Date: Wed, 6 Aug 2014 16:47:17 +0300
Message-ID: <bb168f7d8ee4937adbd1f57dc4b1df9c40daf52c.1407332062.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407332062.git.jsarha@ti.com>
References: <cover.1407332062.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The added clk-gpio is a basic clock that can be enabled and disabled
trough a gpio output. The DT binding document for the clock is also
added. For EPROBE_DEFER handling the registering of the clock has to
be delayed until of_clk_get() call time.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
---
 .../devicetree/bindings/clock/gpio-clock.txt       |   21 ++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-gpio.c                             |  206 ++++++++++++++++++++
 include/linux/clk-provider.h                       |   23 +++
 4 files changed, 251 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/gpio-clock.txt
 create mode 100644 drivers/clk/clk-gpio.c

diff --git a/Documentation/devicetree/bindings/clock/gpio-clock.txt b/Documentation/devicetree/bindings/clock/gpio-clock.txt
new file mode 100644
index 0000000..54fea39
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/gpio-clock.txt
@@ -0,0 +1,21 @@
+Binding for simple gpio controlled clock.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "gpio-clock".
+- #clock-cells : from common clock binding; shall be set to 0.
+- enable-gpios : GPIO reference for enabling and disabling the clock.
+
+Optional properties:
+- clocks: Maximum of one parent clock is supported.
+
+Example:
+	clock {
+		compatible = "gpio-clock";
+		clocks = <&parentclk>;
+		#clock-cells = <0>;
+		enable-gpios = <&gpio 1 GPIO_ACTIVE_HIGH>;
+	};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 567f102..bde8fdf 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-fractional-divider.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-gpio.o
 
 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
diff --git a/drivers/clk/clk-gpio.c b/drivers/clk/clk-gpio.c
new file mode 100644
index 0000000..1eff97c
--- /dev/null
+++ b/drivers/clk/clk-gpio.c
@@ -0,0 +1,206 @@
+/*
+ * Copyright (C) 2012 - 2014 Texas Instruments Incorporated - http://www.ti.com
+ * Author: Jyri Sarha <jsarha@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Gpio controlled clock implementation
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/err.h>
+#include <linux/device.h>
+
+/**
+ * DOC: basic gpio controlled clock which can be enabled and disabled
+ *      with gpio output
+ * Traits of this clock:
+ * prepare - clk_(un)prepare only ensures parent is (un)prepared
+ * enable - clk_enable and clk_disable are functional & control gpio
+ * rate - inherits rate from parent.  No clk_set_rate support
+ * parent - fixed parent.  No clk_set_parent support
+ */
+
+#define to_clk_gpio(_hw) container_of(_hw, struct clk_gpio, hw)
+
+static int clk_gpio_enable(struct clk_hw *hw)
+{
+	struct clk_gpio *clk = to_clk_gpio(hw);
+
+	gpiod_set_value(clk->gpiod, 1);
+
+	return 0;
+}
+
+static void clk_gpio_disable(struct clk_hw *hw)
+{
+	struct clk_gpio *clk = to_clk_gpio(hw);
+
+	gpiod_set_value(clk->gpiod, 0);
+}
+
+static int clk_gpio_is_enabled(struct clk_hw *hw)
+{
+	struct clk_gpio *clk = to_clk_gpio(hw);
+
+	return gpiod_get_value(clk->gpiod);
+}
+
+const struct clk_ops clk_gpio_ops = {
+	.enable = clk_gpio_enable,
+	.disable = clk_gpio_disable,
+	.is_enabled = clk_gpio_is_enabled,
+};
+EXPORT_SYMBOL_GPL(clk_gpio_ops);
+
+/**
+ * clk_register_gpio - register a gpip clock with the clock framework
+ * @dev: device that is registering this clock
+ * @name: name of this clock
+ * @parent_name: name of this clock's parent
+ * @gpiod: gpio descriptor to control this clock
+ */
+struct clk *clk_register_gpio(struct device *dev, const char *name,
+		const char *parent_name, struct gpio_desc *gpiod,
+		unsigned long flags)
+{
+	struct clk_gpio *clk_gpio = NULL;
+	struct clk *clk = ERR_PTR(-EINVAL);
+	struct clk_init_data init = { NULL };
+	unsigned long gpio_flags;
+	int err;
+
+	if (gpiod_is_active_low(gpiod))
+		gpio_flags = GPIOF_OUT_INIT_HIGH;
+	else
+		gpio_flags = GPIOF_OUT_INIT_LOW;
+
+	if (dev)
+		err = devm_gpio_request_one(dev, desc_to_gpio(gpiod),
+					    gpio_flags, name);
+	else
+		err = gpio_request_one(desc_to_gpio(gpiod), gpio_flags, name);
+
+	if (err) {
+		pr_err("%s: %s: Error requesting clock control gpio %u\n",
+		       __func__, name, desc_to_gpio(gpiod));
+		return ERR_PTR(err);
+	}
+
+	if (dev)
+		clk_gpio = devm_kzalloc(dev, sizeof(struct clk_gpio),
+					GFP_KERNEL);
+	else
+		clk_gpio = kzalloc(sizeof(struct clk_gpio), GFP_KERNEL);
+
+	if (!clk_gpio) {
+		pr_err("%s: %s: could not allocate gpio clk\n", __func__, name);
+		clk = ERR_PTR(-ENOMEM);
+		goto clk_register_gpio_err;
+	}
+
+	init.name = name;
+	init.ops = &clk_gpio_ops;
+	init.flags = flags | CLK_IS_BASIC;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	clk_gpio->gpiod = gpiod;
+	clk_gpio->hw.init = &init;
+
+	clk = clk_register(dev, &clk_gpio->hw);
+
+	if (!IS_ERR(clk))
+		return clk;
+
+	if (!dev)
+		kfree(clk_gpio);
+
+clk_register_gpio_err:
+	gpiod_put(gpiod);
+
+	return clk;
+}
+EXPORT_SYMBOL_GPL(clk_register_gpio);
+
+#ifdef CONFIG_OF
+/**
+ * The clk_register_gpio has to be delayed, because the EPROBE_DEFER
+ * can not be handled properly at of_clk_init() call time.
+ */
+
+struct clk_gpio_delayed_register_data {
+	struct device_node *node;
+	struct mutex lock;
+	struct clk *clk;
+};
+
+struct clk *of_clk_gpio_delayed_register_get(struct of_phandle_args *clkspec,
+					     void *_data)
+{
+	struct clk_gpio_delayed_register_data *data = _data;
+	struct clk *clk;
+	const char *clk_name = data->node->name;
+	const char *parent_name;
+	struct gpio_desc *gpiod;
+	int gpio;
+
+	mutex_lock(&data->lock);
+
+	if (data->clk) {
+		mutex_unlock(&data->lock);
+		return data->clk;
+	}
+
+	gpio = of_get_named_gpio_flags(data->node, "enable-gpios", 0, NULL);
+	if (gpio < 0) {
+		mutex_unlock(&data->lock);
+		if (gpio != -EPROBE_DEFER)
+			pr_err("%s: %s: Can't get 'enable-gpios' DT property\n",
+			       __func__, clk_name);
+		return ERR_PTR(gpio);
+	}
+	gpiod = gpio_to_desc(gpio);
+
+	parent_name = of_clk_get_parent_name(data->node, 0);
+
+	clk = clk_register_gpio(NULL, clk_name, parent_name, gpiod, 0);
+	if (IS_ERR(clk)) {
+		mutex_unlock(&data->lock);
+		return clk;
+	}
+
+	data->clk = clk;
+	mutex_unlock(&data->lock);
+
+	return clk;
+}
+
+/**
+ * of_gpio_clk_setup() - Setup function for gpio controlled clock
+ */
+void __init of_gpio_clk_setup(struct device_node *node)
+{
+	struct clk_gpio_delayed_register_data *data;
+
+	data = kzalloc(sizeof(struct clk_gpio_delayed_register_data),
+		       GFP_KERNEL);
+	if (!data) {
+		pr_err("%s: could not allocate gpio clk\n", __func__);
+		return;
+	}
+
+	data->node = node;
+	mutex_init(&data->lock);
+
+	of_clk_add_provider(node, of_clk_gpio_delayed_register_get, data);
+}
+EXPORT_SYMBOL_GPL(of_gpio_clk_setup);
+CLK_OF_DECLARE(gpio_clk, "gpio-clock", of_gpio_clk_setup);
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 0c287db..09252d9 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -488,6 +488,29 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
 		struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
 		unsigned long flags);
 
+/***
+ * struct clk_gpio - gpio controlled clock
+ *
+ * @hw:		handle between common and hardware-specific interfaces
+ * @gpio:	gpio
+ * @active_low:	gpio polarity
+ *
+ * Clock with a gpio control for enabling and disabling the parent clock.
+ * Implements .enable, .disable and .is_enabled
+ */
+
+struct clk_gpio {
+	struct clk_hw	hw;
+	struct gpio_desc *gpiod;
+};
+
+extern const struct clk_ops clk_gpio_ops;
+struct clk *clk_register_gpio(struct device *dev, const char *name,
+		const char *parent_name, struct gpio_desc *gpio,
+		unsigned long flags);
+
+void of_gpio_clk_setup(struct device_node *node);
+
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
-- 
1.7.9.5

