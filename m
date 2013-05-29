Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab3E2DLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:11:31 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:56301 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759448Ab3E2DL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:11:29 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <haojian.zhuang@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>, Chao Xie <chao.xie@marvell.com>
Subject: [PATCH] ARM: mmp: bring up pxa988 with device tree support
Date: Wed, 29 May 2013 11:10:42 +0800
Message-ID: <1369797042-22174-2-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369797042-22174-1-git-send-email-zhangwm@marvell.com>
References: <1369797042-22174-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bring up pxa988 with device tree support.

Change-Id: I6fc869b7d5ff8dc6e4eb0042a89429200f7a9fb1
Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/boot/dts/pxa988-dkb.dts          |   36 ++++++
 arch/arm/boot/dts/pxa988.dtsi             |  189 +++++++++++++++++++++++++++++
 arch/arm/mach-mmp/Kconfig                 |   27 ++++
 arch/arm/mach-mmp/Makefile                |    2 +
 arch/arm/mach-mmp/common.c                |   11 ++-
 arch/arm/mach-mmp/common.h                |    2 +
 arch/arm/mach-mmp/headsmp.S               |  104 ++++++++++++++++
 arch/arm/mach-mmp/include/mach/addr-map.h |    6 +
 arch/arm/mach-mmp/mmpx-dt.c               |   74 +++++++++++
 arch/arm/mach-mmp/platsmp.c               |  163 +++++++++++++++++++++++++
 arch/arm/mach-mmp/reset.c                 |   66 ++++++++++
 arch/arm/mach-mmp/reset.h                 |   29 +++++
 drivers/clk/mmp/Makefile                  |    1 +
 13 files changed, 709 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/boot/dts/pxa988-dkb.dts
 create mode 100644 arch/arm/boot/dts/pxa988.dtsi
 create mode 100644 arch/arm/mach-mmp/headsmp.S
 create mode 100644 arch/arm/mach-mmp/mmpx-dt.c
 create mode 100644 arch/arm/mach-mmp/platsmp.c
 create mode 100644 arch/arm/mach-mmp/reset.c
 create mode 100644 arch/arm/mach-mmp/reset.h

diff --git a/arch/arm/boot/dts/pxa988-dkb.dts b/arch/arm/boot/dts/pxa988-dkb.dts
new file mode 100644
index 0000000..2cee3ed
--- /dev/null
+++ b/arch/arm/boot/dts/pxa988-dkb.dts
@@ -0,0 +1,36 @@
+/*
+ *  Copyright (C) 2012 Marvell Technology Group Ltd.
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+/dts-v1/;
+/include/ "pxa988.dtsi"
+
+/ {
+	model = "Marvell PXA988 DKB Development Board";
+	compatible = "mrvl,pxa988-dkb", "mrvl,pxa988";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 root=/dev/nfs nfsroot=192.168.1.100:/nfsroot/ ip=192.168.1.101:192.168.1.100::255.255.255.0::eth0:on";
+	};
+
+	memory {
+		reg = <0x00000000 0x10000000>;
+	};
+
+	soc {
+		apb@d4000000 {
+			uart1: uart@d4017000 {
+				status = "okay";
+			};
+
+			rtc: rtc@d4010000 {
+				status = "okay";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/pxa988.dtsi b/arch/arm/boot/dts/pxa988.dtsi
new file mode 100644
index 0000000..567d33d
--- /dev/null
+++ b/arch/arm/boot/dts/pxa988.dtsi
@@ -0,0 +1,189 @@
+/*
+ *  Copyright (C) 2013 Marvell Technology Group Ltd.
+ *  Author: Chao Xie <chao.xie@marvell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&gic>;
+
+	aliases {
+		serial0 = &uart1;
+		serial1 = &uart2;
+		serial2 = &uart3;
+		i2c0 = &twsi1;
+		i2c1 = &twsi2;
+	};
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+			next-level-cache = <&L2>;
+		};
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+			next-level-cache = <&L2>;
+		};
+	};
+
+	gic: interrupt-controller@d1dfe100 {
+		compatible = "arm,cortex-a9-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = <0xd1dff000 0x1000>,
+		      <0xd1dfe100 0x0100>;
+	};
+
+	L2: l2-cache-controller@d1dfb000 {
+		compatible = "arm,pl310-cache";
+		reg = <0xd1dfb000 0x1000>;
+		arm,data-latency = <2 1 1>;
+		arm,tag-latency = <2 1 1>;
+		arm,pwr-dynamic-clk-gating;
+		arm,pwr-standby-mode;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	local-timer@d1dfe600 {
+		compatible = "arm,cortex-a9-twd-timer";
+		reg = <0xd1dfe600 0x20>;
+		interrupts = <1 13 0x304>;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		interrupt-parent = <&gic>;
+		ranges;
+
+		axi@d4200000 {	/* AXI */
+			compatible = "mrvl,axi-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0xd4200000 0x00200000>;
+			ranges;
+
+			intc: wakeupgen@d4282000 {
+				compatible = "mrvl,mmp-intc";
+				reg = <0xd4282000 0x1000>;
+				mrvl,intc-wakeup = <0x114 0x3
+						    0x144 0x3>;
+			};
+
+		};
+
+		apb@d4000000 {	/* APB */
+			compatible = "mrvl,apb-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0xd4000000 0x00200000>;
+			ranges;
+
+			timer0: timer@d4014000 {
+				compatible = "mrvl,mmp-timer";
+				reg = <0xd4014000 0x100>;
+				interrupts = <0 13 0x4>;
+			};
+
+			uart1: uart@d4017000 {
+				compatible = "mrvl,mmp-uart";
+				reg = <0xd4017000 0x1000>;
+				interrupts = <0 27 0x4>;
+				status = "disabled";
+			};
+
+			uart2: uart@d4018000 {
+				compatible = "mrvl,mmp-uart";
+				reg = <0xd4018000 0x1000>;
+				interrupts = <0 28 0x4>;
+				status = "disabled";
+			};
+
+			uart3: uart@d4036000 {
+				compatible = "mrvl,mmp-uart";
+				reg = <0xd4036000 0x1000>;
+				interrupts = <0 59 0x4>;
+				status = "disabled";
+			};
+
+			gpio@d4019000 {
+				compatible = "marvell,mmp-gpio";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0xd4019000 0x1000>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupts = <49>;
+				interrupt-names = "gpio_mux";
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				ranges;
+
+				gcb0: gpio@d4019000 {
+					reg = <0xd4019000 0x4>;
+				};
+
+				gcb1: gpio@d4019004 {
+					reg = <0xd4019004 0x4>;
+				};
+
+				gcb2: gpio@d4019008 {
+					reg = <0xd4019008 0x4>;
+				};
+
+				gcb3: gpio@d4019100 {
+					reg = <0xd4019100 0x4>;
+				};
+			};
+
+			twsi1: i2c@d4011000 {
+				compatible = "mrvl,mmp-twsi";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0xd4011000 0x1000>;
+				interrupts = <0 7 0x4>;
+				mrvl,i2c-fast-mode;
+				status = "disabled";
+			};
+
+			twsi2: i2c@d4037000 {
+				compatible = "mrvl,mmp-twsi";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0xd4037000 0x1000>;
+				interrupts = <0 54 0x4>;
+				status = "disabled";
+			};
+
+			rtc: rtc@d4010000 {
+				compatible = "mrvl,mmp-rtc";
+				reg = <0xd4010000 0x1000>;
+				interrupts = <0 5 0x4>,<0 6 0x4>;
+				interrupt-names = "rtc 1Hz", "rtc alarm";
+				status = "disabled";
+			};
+			pmx: pinmux@d401e000 {
+				compatible = "pinconf-single";
+				reg = <0xd401e000 0x330>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				#gpio-range-cells = <3>;
+				ranges;
+
+				pinctrl-single,register-width = <32>;
+				pinctrl-single,function-mask = <7>;
+
+				range: gpio-range {
+					#pinctrl-single,gpio-range-cells = <3>;
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index ebdda83..0955191 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -107,6 +107,16 @@ config MACH_MMP2_DT
 	  Include support for Marvell MMP2 based platforms using
 	  the device tree.
 
+config MACH_MMPX_DT
+	bool "Support no-PJ/PJ4(ARMv7) platforms from device tree"
+	depends on !CPU_MOHAWK && !CPU_PJ4
+	select CPU_PXA988
+	select USE_OF
+	select PINCTRL
+	select PINCTRL_SINGLE
+	help
+	  Include support for Marvell MMP2 based platforms using
+	  the device tree.
 endmenu
 
 config CPU_PXA168
@@ -123,6 +133,23 @@ config CPU_PXA910
 	help
 	  Select code specific to PXA910
 
+config CPU_PXA988
+	bool
+	select CPU_V7
+	select ARM_GIC
+	select HAVE_SMP
+	select HAVE_ARM_SCU
+	select LOCAL_TIMERS
+	select HAVE_ARM_TWD
+	select COMMON_CLK
+	select CLKSRC_OF
+	select MIGHT_HAVE_CACHE_L2X0
+	help
+	  Say 'Y' here if you want to support the Marvell pxa988-base
+	  platforms.
+	  PXA988 is an SoC with dual-core Cotex-A9 and comunication
+	  processor, code name "Emei".
+
 config CPU_MMP2
 	bool
 	select COMMON_CLK
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index 095c155..e572786 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -8,6 +8,7 @@ obj-y				+= common.o devices.o time.o irq.o
 obj-$(CONFIG_CPU_PXA168)	+= pxa168.o
 obj-$(CONFIG_CPU_PXA910)	+= pxa910.o
 obj-$(CONFIG_CPU_MMP2)		+= mmp2.o sram.o
+obj-$(CONFIG_CPU_PXA988)        += platsmp.o headsmp.o reset.o
 
 ifeq ($(CONFIG_COMMON_CLK), )
 obj-y				+= clock.o
@@ -31,5 +32,6 @@ obj-$(CONFIG_MACH_FLINT)	+= flint.o
 obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
 obj-$(CONFIG_MACH_MMP_DT)	+= mmp-dt.o
 obj-$(CONFIG_MACH_MMP2_DT)	+= mmp2-dt.o
+obj-$(CONFIG_MACH_MMPX_DT)	+= mmpx-dt.o
 obj-$(CONFIG_MACH_TETON_BGA)	+= teton_bga.o
 obj-$(CONFIG_MACH_GPLUGD)	+= gplugd.o
diff --git a/arch/arm/mach-mmp/common.c b/arch/arm/mach-mmp/common.c
index 9292b79..0c621bc 100644
--- a/arch/arm/mach-mmp/common.c
+++ b/arch/arm/mach-mmp/common.c
@@ -11,6 +11,10 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/of_address.h>
 
 #include <asm/page.h>
 #include <asm/mach/map.h>
@@ -36,7 +40,12 @@ static struct map_desc standard_io_desc[] __initdata = {
 		.virtual	= (unsigned long)AXI_VIRT_BASE,
 		.length		= AXI_PHYS_SIZE,
 		.type		= MT_DEVICE,
-	},
+	}, {
+		.pfn		= __phys_to_pfn(MMP_CORE_PERIPH_PHYS_BASE),
+		.virtual	= (unsigned long)MMP_CORE_PERIPH_VIRT_BASE,
+		.length		= MMP_CORE_PERIPH_PHYS_SIZE,
+		.type		= MT_DEVICE,
+	}
 };
 
 void __init mmp_map_io(void)
diff --git a/arch/arm/mach-mmp/common.h b/arch/arm/mach-mmp/common.h
index 0bdc50b..ea0225f 100644
--- a/arch/arm/mach-mmp/common.h
+++ b/arch/arm/mach-mmp/common.h
@@ -1,5 +1,7 @@
 #define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
 
+extern struct smp_operations mmp_smp_ops;
+
 extern void timer_init(int irq);
 
 extern void __init icu_init_irq(void);
diff --git a/arch/arm/mach-mmp/headsmp.S b/arch/arm/mach-mmp/headsmp.S
new file mode 100644
index 0000000..2b6177e
--- /dev/null
+++ b/arch/arm/mach-mmp/headsmp.S
@@ -0,0 +1,104 @@
+/*
+ * linux/arch/arm/mach-mmp/headsmp.S
+ *
+ * Copyright (C) 2012 Marvell, Inc.
+ *
+ * Author: Neil Zhang <zhangwm@marvell.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/memory.h>
+#include <asm/cache.h>
+#include <asm/assembler.h>
+#include <mach/addr-map.h>
+
+	__CPUINIT
+
+/*
+ * Marvell specific entry point for secondary CPUs.
+ * The secondary kernel init calls v7_flush_dcache_all before it enables
+ * the L1; however, the L1 comes out of reset in an undefined state, so
+ * the clean + invalidate performed by v7_flush_dcache_all causes a bunch
+ * of cache lines with uninitialized data and uninitialized tags to get
+ * written out to memory, which does really unpleasant things to the main
+ * processor.  We fix this by performing an invalidate, rather than a
+ * clean + invalidate for secondary core, before jumping into the kernel.
+ *
+ * This funciton is cloned from arch/arm/mach-tegra/headsmp.S, and needs
+ * to be called for both secondary cores startup and primary core resume
+ * procedures.
+ */
+	.align L1_CACHE_SHIFT
+
+
+/*
+ * PXA specific entry point for secondary CPUs.  This provides
+ * a "holding pen" into which all secondary cores are held until we're
+ * ready for them to initialise.
+ */
+ENTRY(mmp_secondary_startup)
+	mrc	p15, 0, r0, c0, c0, 5
+	and	r0, r0, #15
+	adr	r4, 1f
+	ldmia	r4, {r5, r6}
+	sub	r4, r4, r5
+	add	r6, r6, r4
+pen:	ldr	r7, [r6]
+	cmp	r7, r0
+	bne	pen
+
+	/*
+	 * we've been released from the holding pen: secondary_stack
+	 * should now contain the SVC stack for this core
+	 */
+	bl	v7_invalidate_l1
+	b	secondary_startup
+ENDPROC(mmp_secondary_startup)
+
+	.align	2
+1:	.long	.
+	.long	pen_release
+
+
+/*
+ * Note: The following code is located into the .data section. This is to
+ *       allow sw_reset_flag and cpu_plugin_handler to be accessed with a
+ *       relative load while we can't rely on any MMU translation.
+ *       Reference from: arch/arm/kernel/sleep.S
+ */
+
+	.data
+	.align
+
+/*
+ * ROM code jumps to this function while waking up from CPU
+ * OFF or software reset state. Physical address of the function is
+ * stored at CA9_WARM_RESET_VECTOR while system is bring up.
+ */
+ENTRY(mmp_cpu_reset_entry)
+	adr	r1, mmp_entry_vectors
+	mrc	p15, 0, r0, c0, c0, 5
+	and	r0, r0, #15		@ fetch CPUID
+1:
+	ldr	r2, [r1, r0, lsl #2]    @ get the handler addr for this core
+	cmp	r2, #0
+	movne	pc, r2			@ jump to the handler
+	beq	1b
+ENDPROC(mmp_cpu_reset_entry)
+
+	/* Point to the address that save handlers for each core */
+	.global mmp_entry_vectors
+mmp_entry_vectors:
+	.rept   CONFIG_NR_CPUS
+        .long   0                               @ preserve stack phys ptr here
+	.endr
diff --git a/arch/arm/mach-mmp/include/mach/addr-map.h b/arch/arm/mach-mmp/include/mach/addr-map.h
index f88a44c..092005b 100644
--- a/arch/arm/mach-mmp/include/mach/addr-map.h
+++ b/arch/arm/mach-mmp/include/mach/addr-map.h
@@ -25,6 +25,10 @@
 #define AXI_VIRT_BASE		IOMEM(0xfe200000)
 #define AXI_PHYS_SIZE		0x00200000
 
+#define MMP_CORE_PERIPH_PHYS_BASE	0xd1dfe000
+#define MMP_CORE_PERIPH_VIRT_BASE	IOMEM(0xfe400000)
+#define MMP_CORE_PERIPH_PHYS_SIZE	0x00002000
+
 /* Static Memory Controller - Chip Select 0 and 1 */
 #define SMC_CS0_PHYS_BASE	0x80000000
 #define SMC_CS0_PHYS_SIZE	0x10000000
@@ -43,4 +47,6 @@
 #define CIU_VIRT_BASE		(AXI_VIRT_BASE + 0x82c00)
 #define CIU_REG(x)		(CIU_VIRT_BASE + (x))
 
+#define SCU_VIRT_BASE		(MMP_CORE_PERIPH_VIRT_BASE)
+
 #endif /* __ASM_MACH_ADDR_MAP_H */
diff --git a/arch/arm/mach-mmp/mmpx-dt.c b/arch/arm/mach-mmp/mmpx-dt.c
new file mode 100644
index 0000000..2ebd057
--- /dev/null
+++ b/arch/arm/mach-mmp/mmpx-dt.c
@@ -0,0 +1,74 @@
+/*
+ *  linux/arch/arm/mach-mmp/mmpx-dt.c
+ *
+ *  Copyright (C) 2012 Marvell Technology Group Ltd.
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+#include <linux/clocksource.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <asm/smp_twd.h>
+#include <asm/hardware/cache-l2x0.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <mach/irqs.h>
+#include <mach/regs-apbc.h>
+
+#include "common.h"
+
+/* PXA988 */
+static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst = {
+	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
+	{}
+};
+
+void __init pxa988_dt_init_timer(void)
+{
+	extern void __init mmp_dt_init_timer(void);
+	/*
+	 * Is is a SOC timer, and will be used for broadcasting
+	 * when local timers are disabled.
+	 */
+	mmp_dt_init_timer();
+
+	clocksource_of_init();
+}
+
+static void __init pxa988_dt_init_machine(void)
+{
+	l2x0_of_init(0x30800000, 0xFE7FFFFF);
+
+	pxa910_clk_init();
+
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     pxa988_auxdata_lookup, NULL);
+}
+
+static const char *pxa988_dt_board_compat[] __initdata = {
+	"mrvl,pxa988-dkb",
+	NULL,
+};
+
+DT_MACHINE_START(PXA988_DT, "Marvell PXA988 (Device Tree Support)")
+	.smp		= smp_ops(mmp_smp_ops),
+	.map_io		= mmp_map_io,
+	.init_irq	= irqchip_init,
+	.init_time	= pxa988_dt_init_timer,
+	.init_machine	= pxa988_dt_init_machine,
+	.dt_compat	= pxa988_dt_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-mmp/platsmp.c b/arch/arm/mach-mmp/platsmp.c
new file mode 100644
index 0000000..5aafde9
--- /dev/null
+++ b/arch/arm/mach-mmp/platsmp.c
@@ -0,0 +1,163 @@
+/*
+ *  linux/arch/arm/mach-mmp/platsmp.c
+ *
+ *  Copyright (C) 2002 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+
+#include <asm/cacheflush.h>
+#include <mach/hardware.h>
+#include <linux/irqchip/arm-gic.h>
+#include <asm/mach-types.h>
+#include <asm/localtimer.h>
+#include <asm/smp_scu.h>
+
+#include <mach/irqs.h>
+#include <mach/addr-map.h>
+
+#include "common.h"
+#include "reset.h"
+
+/*
+ * Write pen_release in a way that is guaranteed to be visible to all
+ * observers, irrespective of whether they're taking part in coherency
+ * or not.  This is necessary for the hotplug code to work reliably.
+ */
+static void __cpuinit write_pen_release(int val)
+{
+	pen_release = val;
+	smp_wmb();
+	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
+	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
+}
+
+#ifdef CONFIG_HAVE_ARM_SCU
+static void __iomem *scu_get_base_addr(void)
+{
+	return SCU_VIRT_BASE;
+}
+#endif
+
+static inline unsigned int get_core_count(void)
+{
+	u32 ret = 1;
+#ifdef CONFIG_HAVE_ARM_SCU
+	ret = scu_get_core_count(scu_get_base_addr());
+#endif
+
+	return ret;
+}
+
+static DEFINE_SPINLOCK(boot_lock);
+
+static void __cpuinit mmp_secondary_init(unsigned int cpu)
+{
+	/*
+	 * let the primary processor know we're out of the
+	 * pen, then head off into the C entry point
+	 */
+	write_pen_release(-1);
+
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+static int __cpuinit mmp_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	/*
+	 * Avoid timer calibration on slave cpus. Use the value calibrated
+	 * on master cpu. Referenced from tegra3
+	 */
+	preset_lpj = loops_per_jiffy;
+
+	/*
+	 * set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+
+	spin_lock(&boot_lock);
+
+	/*
+	 * The secondary processor is waiting to be released from
+	 * the holding pen - release it, then wait for it to flag
+	 * that it has been released by resetting pen_release.
+	 *
+	 * Note that "pen_release" is the hardware CPU ID, whereas
+	 * "cpu" is Linux's internal ID.
+	 */
+	write_pen_release(cpu);
+
+	/* reset the cpu, let it branch to the kernel entry */
+	mmp_cpu_power_up(cpu);
+
+	timeout = jiffies + (1 * HZ);
+	while (time_before(jiffies, timeout)) {
+		smp_rmb();
+		if (pen_release == -1)
+			break;
+
+		udelay(10);
+	}
+
+	/*
+	 * now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	spin_unlock(&boot_lock);
+
+	return pen_release != -1 ? -ENOSYS : 0;
+}
+
+/*
+ * Initialise the CPU possible map early - this describes the CPUs
+ * which may be present or become present in the system.
+ */
+static void __init mmp_smp_init_cpus(void)
+{
+	unsigned int i, ncores = get_core_count();
+
+	for (i = 0; i < ncores; i++)
+		set_cpu_possible(i, true);
+}
+
+static void __init mmp_smp_prepare_cpus(unsigned int max_cpus)
+{
+	int i;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs
+	 * actually populated at the present time.
+	 */
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+
+#ifdef CONFIG_HAVE_ARM_SCU
+	scu_enable(scu_get_base_addr());
+#endif
+
+	mmp_entry_vector_init();
+}
+
+struct smp_operations mmp_smp_ops __initdata = {
+	.smp_init_cpus		= mmp_smp_init_cpus,
+	.smp_prepare_cpus	= mmp_smp_prepare_cpus,
+	.smp_secondary_init	= mmp_secondary_init,
+	.smp_boot_secondary	= mmp_boot_secondary,
+};
diff --git a/arch/arm/mach-mmp/reset.c b/arch/arm/mach-mmp/reset.c
new file mode 100644
index 0000000..b47e400
--- /dev/null
+++ b/arch/arm/mach-mmp/reset.c
@@ -0,0 +1,66 @@
+/*
+ * linux/arch/arm/mach-mmp/reset.c
+ *
+ * Author:	Neil Zhang <zhangwm@marvell.com>
+ * Copyright:	(C) 2012 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/smp.h>
+
+#include <asm/io.h>
+#include <asm/cacheflush.h>
+#include <asm/mach/map.h>
+
+#include <mach/addr-map.h>
+
+#include "reset.h"
+
+#define PMU_CC2_AP			APMU_REG(0x0100)
+#define CIU_CA9_WARM_RESET_VECTOR	CIU_REG(0x00d8)
+
+/*
+ * This function is called from boot_secondary to bootup the secondary cpu.
+ */
+void mmp_cpu_power_up(u32 cpu)
+{
+	u32 tmp;
+
+	BUG_ON(cpu == 0);
+
+	tmp = readl(PMU_CC2_AP);
+	if (tmp & CPU_CORE_RST(cpu)) {
+		/* Release secondary core from reset */
+		tmp &= ~(CPU_CORE_RST(cpu)
+			| CPU_DBG_RST(cpu) | CPU_WDOG_RST(cpu));
+		writel(tmp, PMU_CC2_AP);
+	}
+}
+
+void mmp_set_entry_vector(u32 cpu, u32 addr)
+{
+	BUG_ON(cpu >= CONFIG_NR_CPUS);
+
+	mmp_entry_vectors[cpu] = addr;
+	smp_wmb();
+	__cpuc_flush_dcache_area((void *)&mmp_entry_vectors[cpu],
+				sizeof(mmp_entry_vectors[cpu]));
+	outer_clean_range(__pa(&mmp_entry_vectors[cpu]),
+				__pa(&mmp_entry_vectors[cpu + 1]));
+}
+
+void __init mmp_entry_vector_init(void)
+{
+	int cpu;
+
+	/* We will reset from DDR directly by default */
+	writel(__pa(mmp_cpu_reset_entry), CIU_CA9_WARM_RESET_VECTOR);
+
+	for (cpu = 1; cpu < CONFIG_NR_CPUS; cpu++)
+		mmp_set_entry_vector(cpu, __pa(mmp_secondary_startup));
+}
diff --git a/arch/arm/mach-mmp/reset.h b/arch/arm/mach-mmp/reset.h
new file mode 100644
index 0000000..78d5486
--- /dev/null
+++ b/arch/arm/mach-mmp/reset.h
@@ -0,0 +1,29 @@
+/*
+ * linux/arch/arm/mach-mmp/include/mach/reset.h
+ *
+ * Author:	Neil Zhang <zhangwm@marvell.com>
+ * Copyright:	(C) 2012 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __RESET_PXA988_H__
+#define __RESET_PXA988_H__
+
+#define CPU_CORE_RST(n)	(1 << ((n) * 4 + 16))
+#define CPU_DBG_RST(n)	(1 << ((n) * 4 + 18))
+#define CPU_WDOG_RST(n)	(1 << ((n) * 4 + 19))
+
+extern u32 mmp_entry_vectors[CONFIG_NR_CPUS];
+
+void mmp_secondary_startup(void);
+void mmp_cpu_reset_entry(void);
+
+void mmp_cpu_power_up(u32 cpu);
+void mmp_set_entry_vector(u32 cpu, u32 addr);
+void __init mmp_entry_vector_init(void);
+
+#endif /* __RESET_PXA988_H__ */
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 392d780..59a3f9f7 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -7,3 +7,4 @@ obj-y += clk-apbc.o clk-apmu.o clk-frac.o
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
 obj-$(CONFIG_CPU_MMP2) += clk-mmp2.o
+obj-$(CONFIG_CPU_PXA988) += clk-pxa910.o
-- 
1.7.4.1

