Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3EHTHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:07:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47099 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab3EHTG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:06:58 -0400
From: Nishanth Menon <nm@ti.com>
To: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V5 1/6] clk: OMAP: introduce device tree binding to kernel clock data
Date: Wed, 8 May 2013 14:06:11 -0500
Message-ID: <1368039976-29648-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368039976-29648-1-git-send-email-nm@ti.com>
References: <1368039976-29648-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP clock data is located in arch/arm/mach-omap2/cclockXYZ_data.c.
However, this presents an obstacle for using these clock nodes in
Device Tree definitions. This is especially true for board specific
clocks initially. The fixed clocks are currently found via clock
aliases table. There are many possible approaches to this problem as
discussed in the following thread:
http://marc.info/?t=136370325600009&r=1&w=2.
Highlights of the options:
a) device specific clk_add_alias:
   cons: driver handling required
b) using an generic clk node and indexing to reach the clock required.
   This is similar in approach taken by tegra and few other platforms.
   Example usage: clock = <&clk 5>;
   cons: potential to have mismatches in indexed table and associated
   dtb data. In addition, managing continued documentation in bindings
   as clock indexing increases. Even though readability angle could be
   improved by using preprocessing of DT using macros, indexed
   approach is inherently risky from cases like the following:
   clk indexes in kernel:
   1 - mpu_dpll
   2 - aux_clk1
   3 - core_clk
   DT entry for peripheral X uses <&clk 2> to reach aux_clk1. Now, let's
   say kernel updates indices to:
   1 - mpu_dpll
   2 - per_dpll
   3 - aux_clk1
   4 - core_clk
   using the old dtb(or dts missing an update), on new kernel which
   has updated indices will result in per_dpll now controlled for
   peripheral X without warning or any potential error detection.

   Even though we could claim this is user error, such errors are hard
   to track down and fix.

An alternate approach introduced here is to introduce device tree
bindings corresponding to the clock nodes required in DT definition
for SoC which automatically maps back to the definitions in
cclockXYZ_data.c.

The driver introduced here to do this mapping will eventually be the
place where the clock handling will migrate to. We need to consider
this angle as well so that the solution will be an valid transition
point for moving the clock data out of kernel image (into device tree
or firmware load etc..).

Overall strategy introduced here is simple: a clock node described in
device tree blob is used to identify the exact clock provided in the
SoC specific data. This is then linked back using of_clk_add_provider
to the device node to be accessible by of_clk_get.

Based on discussion contributions from Roger Quadros, Grygorii Strashko
and others.

Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
[tony@atomide.com: co-developed]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Changes in this version:
	- review comments incorporated.
Previous version of this patch was discussed in:
	http://marc.info/?t=136580758500001&r=1&w=2

 .../devicetree/bindings/clock/omap-clock.txt       |   40 +++++++++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/omap/Makefile                          |    1 +
 drivers/clk/omap/clk.c                             |   91 ++++++++++++++++++++
 4 files changed, 133 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/omap-clock.txt
 create mode 100644 drivers/clk/omap/Makefile
 create mode 100644 drivers/clk/omap/clk.c

diff --git a/Documentation/devicetree/bindings/clock/omap-clock.txt b/Documentation/devicetree/bindings/clock/omap-clock.txt
new file mode 100644
index 0000000..047c1e7
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/omap-clock.txt
@@ -0,0 +1,40 @@
+Device Tree Clock bindings for Texas Instrument's OMAP compatible platforms
+
+This binding is an initial minimal binding that may be enhanced as part of
+transitioning OMAP clock data out of kernel image.
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "ti,omap-clock"
+- #clock-cells : from common clock binding; shall be set to 0.
+NOTE:
+node name should map to clock database in arch/arm/mach-omap2/cclock<SoC>_data.c
+Since all clocks are described with _ck, the node name is optimized to drop the
+usage of _ck. For example, a clock called dpll1_ck will be defined as dpll1.
+
+Example #1: describing clock node for CPU on OMAP34xx platform:
+Ref: arch/arm/mach-omap2/cclock3xxx_data.c
+describes the CPU clock to be as follows
+	CLK(NULL,	"dpll1_ck",	&dpll1_ck,	CK_3XXX),
+Corresponding binding will be:
+	dpll1: dpll1 {
+		#clock-cells = <0>;
+		compatible = "ti,omap-clock";
+	};
+And it's usage will be:
+		clocks = <&dpll1>;
+
+Example #2: describing clock node for auxilary clock #3 on OMAP443x platform:
+Ref: arch/arm/mach-omap2/cclock44xx_data.c
+describes the auxclk3 clock to be as follows:
+	CLK(NULL,	"auxclk3_ck",	&auxclk3_ck,	CK_443X),
+Corresponding binding will be:
+	auxclk3: auxclk3 {
+		#clock-cells = <0>;
+		compatible = "ti,omap-clock";
+	};
+And it's usage will be:
+	clocks = <&auxclk3>;
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 137d3e7..1d5a2ec 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
+obj-$(CONFIG_ARCH_OMAP)		+= omap/
 
 obj-$(CONFIG_X86)		+= x86/
 
diff --git a/drivers/clk/omap/Makefile b/drivers/clk/omap/Makefile
new file mode 100644
index 0000000..8195931
--- /dev/null
+++ b/drivers/clk/omap/Makefile
@@ -0,0 +1 @@
+obj-y					+= clk.o
diff --git a/drivers/clk/omap/clk.c b/drivers/clk/omap/clk.c
new file mode 100644
index 0000000..5a3c6d9
--- /dev/null
+++ b/drivers/clk/omap/clk.c
@@ -0,0 +1,91 @@
+/*
+ * Texas Instruments OMAP Clock driver
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *	Nishanth Menon <nm@ti.com>
+ *	Tony Lindgren <tony@atomide.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/string.h>
+
+static const struct of_device_id omap_clk_of_match[] = {
+	{.compatible = "ti,omap-clock",},
+	{},
+};
+
+/**
+ * omap_clk_src_get() - Get OMAP clock from node name when needed
+ * @clkspec:	clkspec argument
+ * @data:	unused
+ *
+ * REVISIT: We assume the following:
+ * 1. omap clock names end with _ck
+ * 2. omap clock names are under 32 characters in length
+ */
+static struct clk *omap_clk_src_get(struct of_phandle_args *clkspec, void *data)
+{
+	struct clk *clk;
+	char clk_name[32];
+	struct device_node *np = clkspec->np;
+
+	snprintf(clk_name, 32, "%s_ck", np->name);
+	clk = clk_get(NULL, clk_name);
+	if (IS_ERR(clk))
+		pr_err("%s: could not get clock %s(%ld)\n", __func__,
+		       clk_name, PTR_ERR(clk));
+
+	return clk;
+}
+
+/**
+ * omap_clk_probe() - create link from DT definition to clock data
+ * @pdev:	device node
+ *
+ * NOTE: we look up the clock lazily when the consumer driver does
+ * of_clk_get() and initialize a NULL clock here.
+ */
+static int omap_clk_probe(struct platform_device *pdev)
+{
+	int res;
+	struct device_node *np = pdev->dev.of_node;
+
+	/* This allows the driver to of_clk_get() */
+	res = of_clk_add_provider(np, omap_clk_src_get, NULL);
+	if (res)
+		dev_err(&pdev->dev, "could not add provider(%d)\n", res);
+
+	return res;
+}
+
+static struct platform_driver omap_clk_driver = {
+	.probe = omap_clk_probe,
+	.driver = {
+		   .name = "omap_clk",
+		   .of_match_table = of_match_ptr(omap_clk_of_match),
+		   },
+};
+
+static int __init omap_clk_init(void)
+{
+	return platform_driver_register(&omap_clk_driver);
+}
+arch_initcall(omap_clk_init);
+
+MODULE_DESCRIPTION("OMAP Clock driver");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

