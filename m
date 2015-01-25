Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbbAYMXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 07:23:07 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35307 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbAYMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 07:22:25 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v2 1/9] clk: sunxi: Add support for sun9i a80 usb clocks and resets
Date: Sun, 25 Jan 2015 20:22:02 +0800
Message-Id: <1422188530-1794-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422188530-1794-1-git-send-email-wens@csie.org>
References: <1422188530-1794-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB controller/phy clocks and reset controls are in a separate
address block, unlike previous SoCs where they were in the clock
controller.

This patch copies the original gates clk functions used for usb
clocks into a separate file, and renames them to *_usb_*. Also
add a per-gate parent index, so we can set different parents for
each gate.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/clock/sunxi.txt |   2 +
 drivers/clk/sunxi/Makefile                        |   1 +
 drivers/clk/sunxi/clk-usb.c                       | 193 ++++++++++++++++++++++
 3 files changed, 196 insertions(+)
 create mode 100644 drivers/clk/sunxi/clk-usb.c

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index 60b44285250d..3f1dcd879af7 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -66,6 +66,8 @@ Required properties:
 	"allwinner,sun4i-a10-usb-clk" - for usb gates + resets on A10 / A20
 	"allwinner,sun5i-a13-usb-clk" - for usb gates + resets on A13
 	"allwinner,sun6i-a31-usb-clk" - for usb gates + resets on A31
+	"allwinner,sun9i-a80-usb-mod-clk" - for usb gates + resets on A80
+	"allwinner,sun9i-a80-usb-phy-clk" - for usb phy gates + resets on A80
 
 Required properties for all clocks:
 - reg : shall be the control register address for the clock.
diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
index 3a5292e3fcf8..058f273d6154 100644
--- a/drivers/clk/sunxi/Makefile
+++ b/drivers/clk/sunxi/Makefile
@@ -9,6 +9,7 @@ obj-y += clk-mod0.o
 obj-y += clk-sun8i-mbus.o
 obj-y += clk-sun9i-core.o
 obj-y += clk-sun9i-mmc.o
+obj-y += clk-usb.o
 
 obj-$(CONFIG_MFD_SUN6I_PRCM) += \
 	clk-sun6i-ar100.o clk-sun6i-apb0.o clk-sun6i-apb0-gates.o \
diff --git a/drivers/clk/sunxi/clk-usb.c b/drivers/clk/sunxi/clk-usb.c
new file mode 100644
index 000000000000..1a93400353de
--- /dev/null
+++ b/drivers/clk/sunxi/clk-usb.c
@@ -0,0 +1,193 @@
+/*
+ * Copyright 2013 Emilio López
+ *
+ * Emilio López <emilio@elopez.com.ar>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/reset-controller.h>
+#include <linux/spinlock.h>
+
+
+/**
+ * sunxi_usb_reset... - reset bits in usb clk registers handling
+ */
+
+struct usb_reset_data {
+	void __iomem			*reg;
+	spinlock_t			*lock;
+	struct clk			*clk;
+	struct reset_controller_dev	rcdev;
+};
+
+static int sunxi_usb_reset_assert(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	struct usb_reset_data *data = container_of(rcdev,
+						   struct usb_reset_data,
+						   rcdev);
+	unsigned long flags;
+	u32 reg;
+
+	clk_prepare_enable(data->clk);
+	spin_lock_irqsave(data->lock, flags);
+
+	reg = readl(data->reg);
+	writel(reg & ~BIT(id), data->reg);
+
+	spin_unlock_irqrestore(data->lock, flags);
+	clk_disable_unprepare(data->clk);
+
+	return 0;
+}
+
+static int sunxi_usb_reset_deassert(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct usb_reset_data *data = container_of(rcdev,
+						     struct usb_reset_data,
+						     rcdev);
+	unsigned long flags;
+	u32 reg;
+
+	clk_prepare_enable(data->clk);
+	spin_lock_irqsave(data->lock, flags);
+
+	reg = readl(data->reg);
+	writel(reg | BIT(id), data->reg);
+
+	spin_unlock_irqrestore(data->lock, flags);
+	clk_disable_unprepare(data->clk);
+
+	return 0;
+}
+
+static struct reset_control_ops sunxi_usb_reset_ops = {
+	.assert		= sunxi_usb_reset_assert,
+	.deassert	= sunxi_usb_reset_deassert,
+};
+
+/**
+ * sunxi_usb_clk_setup() - Setup function for usb gate clocks
+ */
+
+#define SUNXI_USB_MAX_SIZE 32
+
+struct usb_clk_data {
+	u32 clk_mask;
+	u32 reset_mask;
+	bool reset_needs_clk;
+};
+
+static void __init sunxi_usb_clk_setup(struct device_node *node,
+				       const struct usb_clk_data *data,
+				       spinlock_t *lock)
+{
+	struct clk_onecell_data *clk_data;
+	struct usb_reset_data *reset_data;
+	const char *clk_parent;
+	const char *clk_name;
+	void __iomem *reg;
+	int qty;
+	int i = 0;
+	int j = 0;
+
+	reg = of_io_request_and_map(node, 0, of_node_full_name(node));
+
+	clk_parent = of_clk_get_parent_name(node, 0);
+	if (!clk_parent)
+		return;
+
+	/* Worst-case size approximation and memory allocation */
+	qty = find_last_bit((unsigned long *)&data->clk_mask,
+			    SUNXI_USB_MAX_SIZE);
+	clk_data = kmalloc(sizeof(struct clk_onecell_data), GFP_KERNEL);
+	if (!clk_data)
+		return;
+	clk_data->clks = kzalloc((qty+1) * sizeof(struct clk *), GFP_KERNEL);
+	if (!clk_data->clks) {
+		kfree(clk_data);
+		return;
+	}
+
+	for_each_set_bit(i, (unsigned long *)&data->clk_mask,
+			 SUNXI_USB_MAX_SIZE) {
+		of_property_read_string_index(node, "clock-output-names",
+					      j, &clk_name);
+		clk_data->clks[i] = clk_register_gate(NULL, clk_name,
+						      clk_parent, 0,
+						      reg, i, 0, lock);
+		WARN_ON(IS_ERR(clk_data->clks[i]));
+		clk_register_clkdev(clk_data->clks[i], clk_name, NULL);
+
+		j++;
+	}
+
+	/* Adjust to the real max */
+	clk_data->clk_num = i;
+
+	of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
+
+	/* Register a reset controller for usb with reset bits */
+	if (data->reset_mask == 0)
+		return;
+
+	reset_data = kzalloc(sizeof(*reset_data), GFP_KERNEL);
+	if (!reset_data)
+		return;
+
+	if (data->reset_needs_clk)
+		reset_data->clk = of_clk_get(node, 0);
+	if (IS_ERR(reset_data->clk)) {
+		pr_err("Could not get clock for reset controls\n");
+		kfree(reset_data);
+		return;
+	}
+	reset_data->reg = reg;
+	reset_data->lock = lock;
+	reset_data->rcdev.nr_resets = __fls(data->reset_mask) + 1;
+	reset_data->rcdev.ops = &sunxi_usb_reset_ops;
+	reset_data->rcdev.of_node = node;
+	reset_controller_register(&reset_data->rcdev);
+}
+
+static const struct usb_clk_data sun9i_a80_usb_mod_data __initconst = {
+	.clk_mask = BIT(6) | BIT(5) | BIT(4) | BIT(3) | BIT(2) | BIT(1),
+	.reset_mask = BIT(19) | BIT(18) | BIT(17),
+	.reset_needs_clk = 1,
+};
+
+static DEFINE_SPINLOCK(a80_usb_mod_lock);
+
+static void __init sun9i_a80_usb_mod_setup(struct device_node *node)
+{
+	sunxi_usb_clk_setup(node, &sun9i_a80_usb_mod_data, &a80_usb_mod_lock);
+}
+CLK_OF_DECLARE(sun9i_a80_usb_mod, "allwinner,sun9i-a80-usb-mod-clk", sun9i_a80_usb_mod_setup);
+
+static const struct usb_clk_data sun9i_a80_usb_phy_data __initconst = {
+	.clk_mask = BIT(10) | BIT(5) | BIT(4) | BIT(3) | BIT(2) | BIT(1),
+	.reset_mask = BIT(21) | BIT(20) | BIT(19) | BIT(18) | BIT(17),
+	.reset_needs_clk = 1,
+};
+
+static DEFINE_SPINLOCK(a80_usb_phy_lock);
+
+static void __init sun9i_a80_usb_phy_setup(struct device_node *node)
+{
+	sunxi_usb_clk_setup(node, &sun9i_a80_usb_phy_data, &a80_usb_phy_lock);
+}
+CLK_OF_DECLARE(sun9i_a80_usb_phy, "allwinner,sun9i-a80-usb-phy-clk", sun9i_a80_usb_phy_setup);
-- 
2.1.4

