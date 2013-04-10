Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937040Ab3DJRjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:39:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50216 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab3DJRjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:39:36 -0400
Date: Wed, 10 Apr 2013 12:39:21 -0500
From: Nishanth Menon <nm@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Mike Turquette <mturquette@linaro.org>, Tony Lindgren <tony@atomide.com>,
        <linux-usb@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <grygorii.strashko@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
Message-ID: <20130410173921.GA31017@kahuna>
References: <515D2D30.3000306@ti.com>
 <20130404164137.GH10155@atomide.com>
 <515EA9E3.1010409@ti.com>
 <20130405155851.GA10155@atomide.com>
 <5163E589.1040809@ti.com>
 <20130409164928.GL10155@atomide.com>
 <20130409174319.GP10155@atomide.com>
 <20130409204900.GA8815@kahuna>
 <20130410080630.14359.68178@quantum>
 <5165453E.6090503@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5165453E.6090503@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:55-20130410, Roger Quadros wrote:
> On 04/10/2013 11:06 AM, Mike Turquette wrote:
> > Quoting Nishanth Menon (2013-04-09 13:49:00)
> >> On 10:43-20130409, Tony Lindgren wrote:
> >>> * Tony Lindgren <tony@atomide.com> [130409 09:54]:
> >>>> * Roger Quadros <rogerq@ti.com> [130409 03:00]:
> >>>>> On 04/05/2013 06:58 PM, Tony Lindgren wrote:
> >>>>>>
> >>>>>> Can't you just use the clock name there to get it?
> >>>>>
> >>>>> In device tree we don't pass around clock names. You can either get
> >>>>> a phandle or an index to the clock.
> >>>>>
> >>>>> e.g. Documentation/devicetree/bindings/clock/imx31-clock.txt
> >>>>
> >>>> Yes I understand that. But the driver/clock/omap driver can just
> >>>> remap the DT device initially so the board specific clock is
> >>>> found from the clock alias table. Basically initially a passthrough
> >>>> driver that can be enhanced to parse DT clock bindings and load
> >>>> data from /lib/firmware.
> >>>
> >>> Actually probably the driver/clock/omap can even do even less
> >>> initially. There probably even no need to remap clocks there.
> >>>
> >>> As long as the DT clock driver understands that a board specific
> >>> auxclk is specified in the DT it can just call clk_add_alias() so
> >>> the driver will get the right auxclk from cclock44xx_data.c.
> >>>
> >>> Then other features can be added later on like to allocate a
> >>> clock entirely based on the binding etc.
> >> I did try to have an implementation for cpufreq using clock nodes.
> >> unfortunately, device tree wont let me have arguments of strings :(
> >> So, I am unable to do clock = <&clk mpu_dpll>;
> >> instead, I am forced to do clock = <&clk 249>;
> >>
> > 
> > See http://article.gmane.org/gmane.linux.ports.arm.kernel/229034
> > 
> 
> Awesome. Thanks for pointing this out Mike.
> 
> Now all we need to do is create a named define for each clock index in the
> header file.
Approach #3: Thanks to Tony for collaborating on this:
Works for cpufreq-cpu0 - additional patches:
http://pastebin.com/GHnTRVJf, http://pastebin.com/FZS89J6L (tested on
beagleXM)
Work for USB - http://pastebin.com/aJpDnXci - thanks Roger for testing
this.
Details in the patch below (Tony, I have added you as collaborator for
helping in getting this working-clk_add_alias was'nt needed in the
internal patch discussion we had - I have taken a bit of freedom in
adding your contributions to the patch below)

Folks, this does seem to be the best compromise we can achieve at this
point in time. feedback on this approach is much appreciated - if folks
are ok, I can post this as an formal patch series.

>From 130a41821bf57081ca45ef654029175d173135e6 Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Tue, 9 Apr 2013 19:26:40 -0500
Subject: [RFC PATCH] clk: OMAP: introduce device tree binding to kernel clock
 data

OMAP clock data is located in arch/arm/mach-omap2/cclockXYZ_data.c.
However, this presents an obstacle for using these clock nodes in
Device Tree definitions. There are many possible approaches to this
problem as discussed in the following thread:
http://marc.info/?t=136370325600009&r=1&w=2
Highlights of the options:
a) device specific clk_add_alias:
	cons: driver handling required
b) using an generic clk node and indexing to reach the clock required.
   This is similar in approach taken by tegra and few other platforms.
   example clock = <&clk 5>;
   cons: potential to have mismatches in indexed table and associated
   dtb data. In addition, managing continued documentation in bindings
   as clock indexing increases. Even though readability angle could be
   improved by using preprocessing of DT using macros, indexed approach
   is inherently risky from cases like the following:
   clk indexes in kernel:
   1 - mpu_dpll
   2 - aux_clk1
   3 - core_clk
   DT entry for peripheral x uses <&clk 2>, kernel updates to:
   1 - mpu_dpll
   2 - per_dpll
   3 - aux_clk1
   4 - core_clk
   using the old dtb(or dts missing an update), on new kernel which has
   updated indices will result in per_dpll now controlled for peripheral
   X without warning or any potential error detection and warning.

   Even though we can claim this is user error, such errors are hard to
   track down and fix.

An alternate approach introduced here is to introduce device tree bindings
corresponding to the clock nodes required in DT definition for SoC which
automatically maps back to the definitions in cclockXYZ_data.c.

The driver introduced here to do this mapping will eventually be the
place where the clock handling will migrate to. We need to consider this
angle as well so that the solution will be an valid transition point for
moving the clock data out of kernel image (into device tree or firmware load
etc..).

Overall strategy introduced here is simple: an clock node described in
device tree blob is used to identify the exact clock provided in the SoC
specific data. This is then linked back using of_clk_add_provider to the
device node to be accessible by of_clk_get.

Based on discussion contributions from Roger Quadros, Grygorii Strashko
and others.

[tony@atomide.com: co-developed]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/clock/omap-clock.txt       |   40 +++++++++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/omap/Makefile                          |    1 +
 drivers/clk/omap/clk.c                             |   94 ++++++++++++++++++++
 4 files changed, 136 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/omap-clock.txt
 create mode 100644 drivers/clk/omap/Makefile
 create mode 100644 drivers/clk/omap/clk.c

diff --git a/Documentation/devicetree/bindings/clock/omap-clock.txt b/Documentation/devicetree/bindings/clock/omap-clock.txt
new file mode 100644
index 0000000..07e3ff8
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/omap-clock.txt
@@ -0,0 +1,40 @@
+Device Tree Clock bindings for Texas Instrument's OMAP compatible platforms
+
+This binding is a work-in-progress, and meant to be stage #1 of transitioning
+OMAP clock data out of kernel image.
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
+		#clock-cells = <1>;
+		compatible = "ti,omap-clock";
+	};
+And it's usage will be:
+	clocks = <&auxclk3>;
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 300d477..a0209d7 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_ARCH_U8500)	+= ux500/
 obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
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
index 0000000..63a4cce
--- /dev/null
+++ b/drivers/clk/omap/clk.c
@@ -0,0 +1,94 @@
+/*
+ * Texas Instruments OMAP Clock driver
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *	Nishanth Menon
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
+#include <linux/clk-private.h>
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
+MODULE_DEVICE_TABLE(of, omap_clk_of_match);
+
+/**
+ * omap_clk_probe() - create link from DT definition to clock data
+ * @pdev:	device node
+ *
+ * REVISIT: We are now assuming the following:
+ * 1. omap clock names end with _ck
+ * 2. omap clocks don't get removed
+ */
+static int omap_clk_probe(struct platform_device *pdev)
+{
+	struct clk *clk;
+	int res;
+
+	const struct of_device_id *match;
+	struct device_node *np = pdev->dev.of_node;
+	char clk_name[32];
+
+	match = of_match_device(omap_clk_of_match, &pdev->dev);
+
+	/* Set up things so consumer can call clk_get() with name */
+	snprintf(clk_name, 32, "%s_ck", np->name);
+	clk = clk_get(NULL, clk_name);
+	if (IS_ERR(clk)) {
+		res = PTR_ERR(clk);
+		dev_err(&pdev->dev, "could not get clock %s (%d)\n",
+			clk_name, res);
+		goto out;
+	}
+
+	/* This allows the driver to of_clk_get() */
+	res = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	if (res)
+		dev_err(&pdev->dev, "could not add provider for %s (%d)\n",
+			clk_name, res);
+
+	clk_put(clk);
+out:
+	return res;
+}
+
+MODULE_ALIAS("platform:omap_clk");
+
+/* We assume here that OMAP clocks will not be removed */
+static struct platform_driver omap_clk_driver = {
+	.probe = omap_clk_probe,
+	.driver = {
+		   .name = "omap_clk",
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(omap_clk_of_match),
+		   },
+};
+
+static int __init omap_clk_init(void)
+{
+	return platform_driver_register(&omap_clk_driver);
+}
+
+arch_initcall(omap_clk_init);
+
+MODULE_DESCRIPTION("OMAP Clock driver");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

-- 
Regards,
Nishanth Menon
