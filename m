Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609Ab3E3LRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:17:03 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42636 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030406Ab3E3LQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:16:53 -0400
From: Daniel Tang <dt.tangr@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Add TI-Nspire clock drivers
Date: Thu, 30 May 2013 21:16:44 +1000
Message-Id: <ABF49C25-2D7C-4FFF-811D-667A8D785E6A@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
To: Mike Turquette <mturquette@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds a basic clock driver for the TI-Nspire calculator series.

Cheers,
Daniel Tang

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 .../devicetree/bindings/clock/nspire-clock.txt     |  24 ++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-nspire.c                           | 155 +++++++++++++++++++++
 3 files changed, 180 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/nspire-clock.txt
 create mode 100644 drivers/clk/clk-nspire.c

diff --git a/Documentation/devicetree/bindings/clock/nspire-clock.txt b/Documentation/devicetree/bindings/clock/nspire-clock.txt
new file mode 100644
index 0000000..7c3bc8b
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/nspire-clock.txt
@@ -0,0 +1,24 @@
+TI-NSPIRE Clocks
+
+Required properties:
+- compatible: Valid compatible properties include:
+	"lsi,nspire-cx-ahb-divider" for the AHB divider in the CX model
+	"lsi,nspire-classic-ahb-divider" for the AHB divider in the older model
+	"lsi,nspire-cx-clock" for the base clock in the CX model
+	"lsi,nspire-classic-clock" for the base clock in the older model
+
+- reg: Physical base address of the controller and length of memory mapped
+	region.
+
+Optional:
+- clocks: For the "nspire-*-ahb-divider" compatible clocks, this is the parent
+	clock where it divides the rate from.
+
+Example:
+
+ahb_clk {
+	#clock-cells = <0>;
+	compatible = "lsi,nspire-cx-clock";
+	reg = <0x900B0000 0x4>;
+	clocks = <&base_clk>;
+};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 137d3e7..72ebbe1 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
 obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
 obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
+obj-$(CONFIG_ARCH_NSPIRE)	+= clk-nspire.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs/
 obj-$(CONFIG_ARCH_SOCFPGA)	+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
diff --git a/drivers/clk/clk-nspire.c b/drivers/clk/clk-nspire.c
new file mode 100644
index 0000000..2546f7d
--- /dev/null
+++ b/drivers/clk/clk-nspire.c
@@ -0,0 +1,155 @@
+/*
+ *  linux/drivers/clk/clk-nspire.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#define MHZ (1000 * 1000)
+
+#define BASE_CPU_SHIFT		1
+#define BASE_CPU_MASK		0x7F
+
+#define CPU_AHB_SHIFT		12
+#define CPU_AHB_MASK		0x07
+
+#define FIXED_BASE_SHIFT	8
+#define FIXED_BASE_MASK		0x01
+
+#define CLASSIC_BASE_SHIFT	16
+#define CLASSIC_BASE_MASK	0x1F
+
+#define CX_BASE_SHIFT		15
+#define CX_BASE_MASK		0x3F
+
+#define CX_UNKNOWN_SHIFT	21
+#define CX_UNKNOWN_MASK		0x03
+
+struct nspire_clk_info {
+	u32 base_clock;
+	u16 base_cpu_ratio;
+	u16 base_ahb_ratio;
+};
+
+
+#define EXTRACT(var, prop) (((var)>>prop##_SHIFT) & prop##_MASK)
+static void nspire_clkinfo_cx(u32 val, struct nspire_clk_info *clk)
+{
+	if (EXTRACT(val, FIXED_BASE))
+		clk->base_clock = 48 * MHZ;
+	else
+		clk->base_clock = 6 * EXTRACT(val, CX_BASE) * MHZ;
+
+	clk->base_cpu_ratio = EXTRACT(val, BASE_CPU) * EXTRACT(val, CX_UNKNOWN);
+	clk->base_ahb_ratio = clk->base_cpu_ratio * (EXTRACT(val, CPU_AHB) + 1);
+}
+
+static void nspire_clkinfo_classic(u32 val, struct nspire_clk_info *clk)
+{
+	if (EXTRACT(val, FIXED_BASE))
+		clk->base_clock = 27 * MHZ;
+	else
+		clk->base_clock = (300 - 6 * EXTRACT(val, CLASSIC_BASE)) * MHZ;
+
+	clk->base_cpu_ratio = EXTRACT(val, BASE_CPU) * 2;
+	clk->base_ahb_ratio = clk->base_cpu_ratio * (EXTRACT(val, CPU_AHB) + 1);
+}
+#undef EXTRACT
+
+static void __init nspire_ahbdiv_setup(struct device_node *node,
+		void (*get_clkinfo)(u32, struct nspire_clk_info *))
+{
+	u32 val;
+	void __iomem *io;
+	struct clk *clk;
+	const char *clk_name = node->name;
+	const char *parent_name;
+	struct nspire_clk_info info;
+
+	io = of_iomap(node, 0);
+	if (!io)
+		return;
+	val = readl(io);
+	iounmap(io);
+
+	get_clkinfo(val, &info);
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+	parent_name = of_clk_get_parent_name(node, 0);
+
+	clk = clk_register_fixed_factor(NULL, clk_name, parent_name, 0,
+					1, info.base_ahb_ratio);
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+
+static void __init nspire_ahbdiv_setup_cx(struct device_node *node)
+{
+	nspire_ahbdiv_setup(node, nspire_clkinfo_cx);
+}
+
+static void __init nspire_ahbdiv_setup_classic(struct device_node *node)
+{
+	nspire_ahbdiv_setup(node, nspire_clkinfo_classic);
+}
+
+CLK_OF_DECLARE(nspire_ahbdiv_cx, "lsi,nspire-cx-ahb-divider",
+		nspire_ahbdiv_setup_cx);
+CLK_OF_DECLARE(nspire_ahbdiv_classic, "lsi,nspire-classic-ahb-divider",
+		nspire_ahbdiv_setup_classic);
+
+static void __init nspire_clk_setup(struct device_node *node,
+		void (*get_clkinfo)(u32, struct nspire_clk_info *))
+{
+	u32 val;
+	void __iomem *io;
+	struct clk *clk;
+	const char *clk_name = node->name;
+	struct nspire_clk_info info;
+
+	io = of_iomap(node, 0);
+	if (!io)
+		return;
+	val = readl(io);
+	iounmap(io);
+
+	get_clkinfo(val, &info);
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT,
+			info.base_clock);
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	else
+		return;
+
+	pr_info("TI-NSPIRE Base: %uMHz CPU: %uMHz AHB: %uMHz\n",
+		info.base_clock / MHZ,
+		info.base_clock / info.base_cpu_ratio / MHZ,
+		info.base_clock / info.base_ahb_ratio / MHZ);
+}
+
+static void __init nspire_clk_setup_cx(struct device_node *node)
+{
+	nspire_clk_setup(node, nspire_clkinfo_cx);
+}
+
+static void __init nspire_clk_setup_classic(struct device_node *node)
+{
+	nspire_clk_setup(node, nspire_clkinfo_classic);
+}
+
+CLK_OF_DECLARE(nspire_clk_cx, "lsi,nspire-cx-clock", nspire_clk_setup_cx);
+CLK_OF_DECLARE(nspire_clk_classic, "lsi,nspire-classic-clock",
+		nspire_clk_setup_classic);
-- 
1.8.1.3


