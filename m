Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936377Ab3DIUtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:49:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54963 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936180Ab3DIUtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:49:21 -0400
Date: Tue, 9 Apr 2013 15:49:00 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <grygorii.strashko@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
Message-ID: <20130409204900.GA8815@kahuna>
References: <1363703220-4777-1-git-send-email-rogerq@ti.com>
 <1363703220-4777-2-git-send-email-rogerq@ti.com>
 <20130403234242.GE10155@atomide.com>
 <515D2D30.3000306@ti.com>
 <20130404164137.GH10155@atomide.com>
 <515EA9E3.1010409@ti.com>
 <20130405155851.GA10155@atomide.com>
 <5163E589.1040809@ti.com>
 <20130409164928.GL10155@atomide.com>
 <20130409174319.GP10155@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130409174319.GP10155@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:43-20130409, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [130409 09:54]:
> > * Roger Quadros <rogerq@ti.com> [130409 03:00]:
> > > On 04/05/2013 06:58 PM, Tony Lindgren wrote:
> > > > 
> > > > Can't you just use the clock name there to get it?
> > > 
> > > In device tree we don't pass around clock names. You can either get
> > > a phandle or an index to the clock.
> > > 
> > > e.g. Documentation/devicetree/bindings/clock/imx31-clock.txt
> > 
> > Yes I understand that. But the driver/clock/omap driver can just
> > remap the DT device initially so the board specific clock is
> > found from the clock alias table. Basically initially a passthrough
> > driver that can be enhanced to parse DT clock bindings and load
> > data from /lib/firmware.
> 
> Actually probably the driver/clock/omap can even do even less
> initially. There probably even no need to remap clocks there.
> 
> As long as the DT clock driver understands that a board specific
> auxclk is specified in the DT it can just call clk_add_alias() so
> the driver will get the right auxclk from cclock44xx_data.c.
> 
> Then other features can be added later on like to allocate a
> clock entirely based on the binding etc.
I did try to have an implementation for cpufreq using clock nodes.
unfortunately, device tree wont let me have arguments of strings :(
So, I am unable to do clock = <&clk mpu_dpll>;
instead, I am forced to do clock = <&clk 249>;

Here is an attempt on beagleXM - adds every clock node to the list.
Tons of un-necessary prints added to give an idea - see log:
http://pastebin.com/F9A2zSTr

Would an cleaned up version be good enough as a step #1 of transition?

>From 7d373bdb9e9549c1b6ba1775a8dfd96ebe78abfb Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Tue, 26 Mar 2013 10:23:27 +0000
Subject: [PATCH] OMAP: add devicetree support for clock nodes.

Dummy patch based on Roger's original idea

Nyet-Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap3.dtsi          |    5 ++
 arch/arm/boot/dts/omap34xx.dtsi       |    2 +
 arch/arm/mach-omap2/cclock3xxx_data.c |    3 +-
 arch/arm/mach-omap2/cclock44xx_data.c |    3 +-
 arch/arm/mach-omap2/pm.c              |   11 +++-
 drivers/clk/Kconfig                   |    6 ++
 drivers/clk/Makefile                  |    2 +
 drivers/clk/ti.c                      |  100 +++++++++++++++++++++++++++++++++
 include/linux/clk/ti.h                |   30 ++++++++++
 9 files changed, 157 insertions(+), 5 deletions(-)
 create mode 100644 drivers/clk/ti.c
 create mode 100644 include/linux/clk/ti.h

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 3344f05..a08990d 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -73,6 +73,11 @@
 			ti,hwmods = "counter_32k";
 		};
 
+		clks: clocks {
+			compatible = "ti,clock";
+			#clock-cells = <1>;
+		};
+
 		intc: interrupt-controller@48200000 {
 			compatible = "ti,omap2-intc";
 			interrupt-controller;
diff --git a/arch/arm/boot/dts/omap34xx.dtsi b/arch/arm/boot/dts/omap34xx.dtsi
index 75ed4ae..93c2621 100644
--- a/arch/arm/boot/dts/omap34xx.dtsi
+++ b/arch/arm/boot/dts/omap34xx.dtsi
@@ -23,6 +23,8 @@
 				600000  1350000
 			>;
 			clock-latency = <300000>; /* From legacy driver */
+			clocks = <&clks 249>; /* index to cpufreq_ck */
+			clock-names = "cpu";
 		};
 	};
 };
diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 4579c3c..d5d5ef5 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -22,6 +22,7 @@
 #include <linux/clk-private.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/clk/ti.h>
 
 #include "soc.h"
 #include "iomap.h"
@@ -3574,7 +3575,7 @@ int __init omap3xxx_clk_init(void)
 	for (c = omap3xxx_clks; c < omap3xxx_clks + ARRAY_SIZE(omap3xxx_clks);
 	     c++)
 		if (c->cpu & cpu_clkflg) {
-			clkdev_add(&c->lk);
+			ti_clk_node_add(&c->lk);
 			if (!__clk_init(NULL, c->lk.clk))
 				omap2_init_clk_hw_omap_clocks(c->lk.clk);
 		}
diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index 0c6834a..338ef64 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -27,6 +27,7 @@
 #include <linux/clk-private.h>
 #include <linux/clkdev.h>
 #include <linux/io.h>
+#include <linux/clk/ti.h>
 
 #include "soc.h"
 #include "iomap.h"
@@ -1697,7 +1698,7 @@ int __init omap4xxx_clk_init(void)
 	for (c = omap44xx_clks; c < omap44xx_clks + ARRAY_SIZE(omap44xx_clks);
 									c++) {
 		if (c->cpu & cpu_clkflg) {
-			clkdev_add(&c->lk);
+			ti_clk_node_add(&c->lk);
 			if (!__clk_init(NULL, c->lk.clk))
 				omap2_init_clk_hw_omap_clocks(c->lk.clk);
 		}
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 8d15f9a..6cf95160 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -267,7 +267,12 @@ static void __init omap4_init_voltages(void)
 
 static inline void omap_init_cpufreq(void)
 {
-	struct platform_device_info devinfo = { .name = "omap-cpufreq", };
+	struct platform_device_info devinfo = { };
+
+	if (!of_have_populated_dt())
+		devinfo.name = "omap-cpufreq";
+	else
+		devinfo.name = "cpufreq-cpu0";
 	platform_device_register_full(&devinfo);
 }
 
@@ -301,9 +306,9 @@ int __init omap2_common_pm_late_init(void)
 		/* Smartreflex device init */
 		omap_devinit_smartreflex();
 
-		/* cpufreq dummy device instantiation */
-		omap_init_cpufreq();
 	}
+	/* cpufreq dummy device instantiation */
+	omap_init_cpufreq();
 
 #ifdef CONFIG_SUSPEND
 	suspend_set_ops(&omap_pm_ops);
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index a47e6ee..03c6e48 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -55,6 +55,12 @@ config COMMON_CLK_MAX77686
 	---help---
 	  This driver supports Maxim 77686 crystal oscillator clock. 
 
+config COMMON_CLK_TI
+	tristate "Clock driver for TI SoCs"
+	depends on ARCH_OMAP && OF
+	---help---
+	  Fill me up.. some generic statement ofcourse (lets start with OMAP)
+
 config CLK_TWL6040
 	tristate "External McPDM functional clock from twl6040"
 	depends on TWL6040_CORE
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 300d477..9621815 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -30,6 +30,8 @@ obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 
 obj-$(CONFIG_X86)		+= x86/
 
+obj-$(CONFIG_COMMON_CLK_TI)	+= ti.o
+
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
diff --git a/drivers/clk/ti.c b/drivers/clk/ti.c
new file mode 100644
index 0000000..c747381
--- /dev/null
+++ b/drivers/clk/ti.c
@@ -0,0 +1,100 @@
+/*
+ * TI Clock node provider
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *	Nishanth Menon
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
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/clk-private.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/clk/ti.h>
+
+struct ti_clk {
+	struct clk_lookup *lk;
+	struct list_head node;
+};
+
+static LIST_HEAD(ti_clk_list);
+
+static struct clk *ti_bypass_clk_get_by_name(struct of_phandle_args *clkspec,
+					     void *data)
+{
+	struct ti_clk *c;
+#if 0
+	/* Eww.. IF ONLY phandle arguments could be string */
+	char clk_name[32]; /* 32 is max size of property name */
+
+	char *name = clkspec->args[0];
+
+	snprintf(clk_name, 32, "%s_ck", name);
+	list_for_each_entry(c, &ti_clk_list, node) {
+		int r = strncmp(c->lk->conn_id, clk_name, 32);
+		pr_err("%s: searching %s in %s - %d\n",
+			__func__, clk_name, c->lk->con_id, r);
+		if (!r) {
+			pr_err("%s: found it!\n", __func__);
+			return c->lk.clk;
+		}
+	}
+#else
+	/* Use integer indexing into clkdev list! Sigh.. */
+	int idx = clkspec->args[0];
+	int cindex = 1;
+
+	list_for_each_entry(c, &ti_clk_list, node) {
+		int r = (idx == cindex) ? 0 :  1;
+		pr_err("%s: searching index search = %d in %d in %s - %d\n",
+			__func__, idx, cindex, c->lk->con_id, r);
+		if (!r) {
+			pr_err("%s: found it!\n", __func__);
+			return c->lk->clk;
+		}
+		cindex++;
+	}
+#endif
+
+	pr_err("%s: ran out of options\n", __func__);
+	return ERR_PTR(-ENODEV);
+}
+
+static void __init ti_clock_init(struct device_node *node)
+{
+
+	pr_err("%s: START\n", __func__);
+	of_clk_add_provider(node, ti_bypass_clk_get_by_name, NULL);
+	pr_err("%s: END\n", __func__);
+}
+CLK_OF_DECLARE(ti_clk, "ti,clock", ti_clock_init);
+
+void __init ti_clk_node_add(struct clk_lookup *lk)
+{
+	struct ti_clk *c;
+	static bool of_added;
+
+	c = kzalloc(sizeof(struct ti_clk), GFP_KERNEL);
+	if (!c) {
+		pr_err("%s: No memory!! cannot add clk node!\n", __func__);
+		return;
+	}
+	clkdev_add(lk);
+	c->lk = lk;
+	list_add_tail(&c->node, &ti_clk_list);
+	pr_err("%s: Added clock node %s\n", __func__, lk->con_id);
+	if (!of_added) {
+		of_clk_init(NULL);
+		of_added =  true;
+	}
+};
+
diff --git a/include/linux/clk/ti.h b/include/linux/clk/ti.h
new file mode 100644
index 0000000..eb502a8
--- /dev/null
+++ b/include/linux/clk/ti.h
@@ -0,0 +1,30 @@
+/*
+ * TI Clock node provider header
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *	Nishanth Menon
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
+#ifndef __TI_CLK_H
+#define __TI_CLK_H
+
+#include <linux/clkdev.h>
+
+#ifdef CONFIG_OF
+extern void ti_clk_node_add(struct clk_lookup *lk);
+#else
+static inline void ti_clk_node_add(struct clk_lookup *lk)
+{
+	clkdev_add(lk);
+}
+#endif /* CONFIG_OF */
+
+#endif	/* __TI_CLK_H */
-- 
1.7.9.5


-- 
Regards,
Nishanth Menon
