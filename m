Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaKYSRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:17:46 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39189 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYSRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:17:45 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v2 RESEND 1/2] ARM: vexpress: Remove non-DT code
Date: Tue, 25 Nov 2014 18:17:34 +0000
Message-Id: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, with the CLCD DT support available, there is no
more reason to keep the non-DT support for V2P-CA9.

Removed, together with "some" supporting code. It was
necessary to make PLAT_VERSATILE_SCHED_CLOCK optional
and selected by the machines still interested in it.

Acked-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
Changes since v1:

- Removed MFD and power/reset changes from the patch;
  will be posted separately after this is merged.

 arch/arm/Kconfig                                  |   2 +
 arch/arm/mach-vexpress/Kconfig                    |   3 -
 arch/arm/mach-vexpress/Makefile                   |   3 +-
 arch/arm/mach-vexpress/core.h                     |   7 -
 arch/arm/mach-vexpress/ct-ca9x4.c                 | 212 ------------
 arch/arm/mach-vexpress/include/mach/ct-ca9x4.h    |  47 ---
 arch/arm/mach-vexpress/include/mach/hardware.h    |   1 -
 arch/arm/mach-vexpress/include/mach/irqs.h        |   6 -
 arch/arm/mach-vexpress/include/mach/motherboard.h |  88 -----
 arch/arm/mach-vexpress/platsmp.c                  |  42 ---
 arch/arm/mach-vexpress/v2m.c                      | 374 ----------------------
 arch/arm/plat-versatile/Kconfig                   |   2 +-
 drivers/clk/versatile/Makefile                    |   1 -
 drivers/clk/versatile/clk-vexpress-osc.c          |   7 -
 drivers/clk/versatile/clk-vexpress.c              |  86 -----
 drivers/misc/vexpress-syscfg.c                    |  60 +---
 include/linux/vexpress.h                          |  19 --
 17 files changed, 17 insertions(+), 943 deletions(-)
 delete mode 100644 arch/arm/mach-vexpress/ct-ca9x4.c
 delete mode 100644 arch/arm/mach-vexpress/include/mach/ct-ca9x4.h
 delete mode 100644 arch/arm/mach-vexpress/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-vexpress/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-vexpress/include/mach/motherboard.h
 delete mode 100644 drivers/clk/versatile/clk-vexpress.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..6c6fdb8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -350,6 +350,7 @@ config ARCH_REALVIEW
 	select ICST
 	select NEED_MACH_MEMORY_H
 	select PLAT_VERSATILE
+	select PLAT_VERSATILE_SCHED_CLOCK
 	help
 	  This enables support for ARM Ltd RealView boards.
 
@@ -365,6 +366,7 @@ config ARCH_VERSATILE
 	select ICST
 	select PLAT_VERSATILE
 	select PLAT_VERSATILE_CLOCK
+	select PLAT_VERSATILE_SCHED_CLOCK
 	select VERSATILE_FPGA_IRQ
 	help
 	  This enables support for ARM Ltd Versatile board.
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index b2cfba16c..9a96bab 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -49,9 +49,6 @@ config ARCH_VEXPRESS_CORTEX_A5_A9_ERRATA
 	  build a working kernel, you must also enable relevant core
 	  tile support or Flattened Device Tree based support options.
 
-config ARCH_VEXPRESS_CA9X4
-	bool "Versatile Express Cortex-A9x4 tile"
-
 config ARCH_VEXPRESS_DCSCB
 	bool "Dual Cluster System Control Block (DCSCB) support"
 	depends on MCPM
diff --git a/arch/arm/mach-vexpress/Makefile b/arch/arm/mach-vexpress/Makefile
index fc649bc..f5c1006 100644
--- a/arch/arm/mach-vexpress/Makefile
+++ b/arch/arm/mach-vexpress/Makefile
@@ -1,11 +1,10 @@
 #
 # Makefile for the linux kernel.
 #
-ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include \
+ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := \
 	-I$(srctree)/arch/arm/plat-versatile/include
 
 obj-y					:= v2m.o
-obj-$(CONFIG_ARCH_VEXPRESS_CA9X4)	+= ct-ca9x4.o
 obj-$(CONFIG_ARCH_VEXPRESS_DCSCB)	+= dcscb.o	dcscb_setup.o
 CFLAGS_dcscb.o				+= -march=armv7-a
 CFLAGS_REMOVE_dcscb.o			= -pg
diff --git a/arch/arm/mach-vexpress/core.h b/arch/arm/mach-vexpress/core.h
index 152fad9..2a11d3a 100644
--- a/arch/arm/mach-vexpress/core.h
+++ b/arch/arm/mach-vexpress/core.h
@@ -1,12 +1,5 @@
-/* 2MB large area for motherboard's peripherals static mapping */
-#define V2M_PERIPH 0xf8000000
-
-/* Tile's peripherals static mappings should start here */
-#define V2T_PERIPH 0xf8200000
-
 bool vexpress_smp_init_ops(void);
 
-extern struct smp_operations	vexpress_smp_ops;
 extern struct smp_operations	vexpress_smp_dt_ops;
 
 extern void vexpress_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
deleted file mode 100644
index 27bea04..0000000
--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ /dev/null
@@ -1,212 +0,0 @@
-/*
- * Versatile Express Core Tile Cortex A9x4 Support
- */
-#include <linux/init.h>
-#include <linux/gfp.h>
-#include <linux/device.h>
-#include <linux/dma-mapping.h>
-#include <linux/platform_device.h>
-#include <linux/amba/bus.h>
-#include <linux/amba/clcd.h>
-#include <linux/platform_data/video-clcd-versatile.h>
-#include <linux/clkdev.h>
-#include <linux/vexpress.h>
-#include <linux/irqchip/arm-gic.h>
-
-#include <asm/hardware/arm_timer.h>
-#include <asm/hardware/cache-l2x0.h>
-#include <asm/smp_scu.h>
-#include <asm/smp_twd.h>
-
-#include <mach/ct-ca9x4.h>
-
-#include <asm/hardware/timer-sp.h>
-
-#include <asm/mach/map.h>
-#include <asm/mach/time.h>
-
-#include "core.h"
-
-#include <mach/motherboard.h>
-#include <mach/irqs.h>
-
-static struct map_desc ct_ca9x4_io_desc[] __initdata = {
-	{
-		.virtual        = V2T_PERIPH,
-		.pfn            = __phys_to_pfn(CT_CA9X4_MPIC),
-		.length         = SZ_8K,
-		.type           = MT_DEVICE,
-	},
-};
-
-static void __init ct_ca9x4_map_io(void)
-{
-	iotable_init(ct_ca9x4_io_desc, ARRAY_SIZE(ct_ca9x4_io_desc));
-}
-
-static void __init ca9x4_l2_init(void)
-{
-#ifdef CONFIG_CACHE_L2X0
-	void __iomem *l2x0_base = ioremap(CT_CA9X4_L2CC, SZ_4K);
-
-	if (l2x0_base) {
-		/* set RAM latencies to 1 cycle for this core tile. */
-		writel(0, l2x0_base + L310_TAG_LATENCY_CTRL);
-		writel(0, l2x0_base + L310_DATA_LATENCY_CTRL);
-
-		l2x0_init(l2x0_base, 0x00400000, 0xfe0fffff);
-	} else {
-		pr_err("L2C: unable to map L2 cache controller\n");
-	}
-#endif
-}
-
-#ifdef CONFIG_HAVE_ARM_TWD
-static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, A9_MPCORE_TWD, IRQ_LOCALTIMER);
-
-static void __init ca9x4_twd_init(void)
-{
-	int err = twd_local_timer_register(&twd_local_timer);
-	if (err)
-		pr_err("twd_local_timer_register failed %d\n", err);
-}
-#else
-#define ca9x4_twd_init()	do {} while(0)
-#endif
-
-static void __init ct_ca9x4_init_irq(void)
-{
-	gic_init(0, 29, ioremap(A9_MPCORE_GIC_DIST, SZ_4K),
-		 ioremap(A9_MPCORE_GIC_CPU, SZ_256));
-	ca9x4_twd_init();
-	ca9x4_l2_init();
-}
-
-static int ct_ca9x4_clcd_setup(struct clcd_fb *fb)
-{
-	unsigned long framesize = 1024 * 768 * 2;
-
-	fb->panel = versatile_clcd_get_panel("XVGA");
-	if (!fb->panel)
-		return -EINVAL;
-
-	return versatile_clcd_setup_dma(fb, framesize);
-}
-
-static struct clcd_board ct_ca9x4_clcd_data = {
-	.name		= "CT-CA9X4",
-	.caps		= CLCD_CAP_5551 | CLCD_CAP_565,
-	.check		= clcdfb_check,
-	.decode		= clcdfb_decode,
-	.setup		= ct_ca9x4_clcd_setup,
-	.mmap		= versatile_clcd_mmap_dma,
-	.remove		= versatile_clcd_remove_dma,
-};
-
-static AMBA_AHB_DEVICE(clcd, "ct:clcd", 0, CT_CA9X4_CLCDC, IRQ_CT_CA9X4_CLCDC, &ct_ca9x4_clcd_data);
-static AMBA_APB_DEVICE(dmc, "ct:dmc", 0, CT_CA9X4_DMC, IRQ_CT_CA9X4_DMC, NULL);
-static AMBA_APB_DEVICE(smc, "ct:smc", 0, CT_CA9X4_SMC, IRQ_CT_CA9X4_SMC, NULL);
-static AMBA_APB_DEVICE(gpio, "ct:gpio", 0, CT_CA9X4_GPIO, IRQ_CT_CA9X4_GPIO, NULL);
-
-static struct amba_device *ct_ca9x4_amba_devs[] __initdata = {
-	&clcd_device,
-	&dmc_device,
-	&smc_device,
-	&gpio_device,
-};
-
-static struct resource pmu_resources[] = {
-	[0] = {
-		.start	= IRQ_CT_CA9X4_PMU_CPU0,
-		.end	= IRQ_CT_CA9X4_PMU_CPU0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[1] = {
-		.start	= IRQ_CT_CA9X4_PMU_CPU1,
-		.end	= IRQ_CT_CA9X4_PMU_CPU1,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[2] = {
-		.start	= IRQ_CT_CA9X4_PMU_CPU2,
-		.end	= IRQ_CT_CA9X4_PMU_CPU2,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[3] = {
-		.start	= IRQ_CT_CA9X4_PMU_CPU3,
-		.end	= IRQ_CT_CA9X4_PMU_CPU3,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device pmu_device = {
-	.name		= "arm-pmu",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(pmu_resources),
-	.resource	= pmu_resources,
-};
-
-static struct clk_lookup osc1_lookup = {
-	.dev_id		= "ct:clcd",
-};
-
-static struct platform_device osc1_device = {
-	.name		= "vexpress-osc",
-	.id		= 1,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0xf, 1),
-	},
-	.dev.platform_data = &osc1_lookup,
-};
-
-static void __init ct_ca9x4_init(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ct_ca9x4_amba_devs); i++)
-		amba_device_register(ct_ca9x4_amba_devs[i], &iomem_resource);
-
-	platform_device_register(&pmu_device);
-	vexpress_syscfg_device_register(&osc1_device);
-}
-
-#ifdef CONFIG_SMP
-static void *ct_ca9x4_scu_base __initdata;
-
-static void __init ct_ca9x4_init_cpu_map(void)
-{
-	int i, ncores;
-
-	ct_ca9x4_scu_base = ioremap(A9_MPCORE_SCU, SZ_128);
-	if (WARN_ON(!ct_ca9x4_scu_base))
-		return;
-
-	ncores = scu_get_core_count(ct_ca9x4_scu_base);
-
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; ++i)
-		set_cpu_possible(i, true);
-}
-
-static void __init ct_ca9x4_smp_enable(unsigned int max_cpus)
-{
-	scu_enable(ct_ca9x4_scu_base);
-}
-#endif
-
-struct ct_desc ct_ca9x4_desc __initdata = {
-	.id		= V2M_CT_ID_CA9,
-	.name		= "CA9x4",
-	.map_io		= ct_ca9x4_map_io,
-	.init_irq	= ct_ca9x4_init_irq,
-	.init_tile	= ct_ca9x4_init,
-#ifdef CONFIG_SMP
-	.init_cpu_map	= ct_ca9x4_init_cpu_map,
-	.smp_enable	= ct_ca9x4_smp_enable,
-#endif
-};
diff --git a/arch/arm/mach-vexpress/include/mach/ct-ca9x4.h b/arch/arm/mach-vexpress/include/mach/ct-ca9x4.h
deleted file mode 100644
index 84acf84..0000000
--- a/arch/arm/mach-vexpress/include/mach/ct-ca9x4.h
+++ /dev/null
@@ -1,47 +0,0 @@
-#ifndef __MACH_CT_CA9X4_H
-#define __MACH_CT_CA9X4_H
-
-/*
- * Physical base addresses
- */
-#define CT_CA9X4_CLCDC		(0x10020000)
-#define CT_CA9X4_AXIRAM		(0x10060000)
-#define CT_CA9X4_DMC		(0x100e0000)
-#define CT_CA9X4_SMC		(0x100e1000)
-#define CT_CA9X4_SCC		(0x100e2000)
-#define CT_CA9X4_SP804_TIMER	(0x100e4000)
-#define CT_CA9X4_SP805_WDT	(0x100e5000)
-#define CT_CA9X4_TZPC		(0x100e6000)
-#define CT_CA9X4_GPIO		(0x100e8000)
-#define CT_CA9X4_FASTAXI	(0x100e9000)
-#define CT_CA9X4_SLOWAXI	(0x100ea000)
-#define CT_CA9X4_TZASC		(0x100ec000)
-#define CT_CA9X4_CORESIGHT	(0x10200000)
-#define CT_CA9X4_MPIC		(0x1e000000)
-#define CT_CA9X4_SYSTIMER	(0x1e004000)
-#define CT_CA9X4_SYSWDT		(0x1e007000)
-#define CT_CA9X4_L2CC		(0x1e00a000)
-
-#define A9_MPCORE_SCU		(CT_CA9X4_MPIC + 0x0000)
-#define A9_MPCORE_GIC_CPU	(CT_CA9X4_MPIC + 0x0100)
-#define A9_MPCORE_GIT		(CT_CA9X4_MPIC + 0x0200)
-#define A9_MPCORE_TWD		(CT_CA9X4_MPIC + 0x0600)
-#define A9_MPCORE_GIC_DIST	(CT_CA9X4_MPIC + 0x1000)
-
-/*
- * Interrupts.  Those in {} are for AMBA devices
- */
-#define IRQ_CT_CA9X4_CLCDC	{ 76 }
-#define IRQ_CT_CA9X4_DMC	{ 0 }
-#define IRQ_CT_CA9X4_SMC	{ 77, 78 }
-#define IRQ_CT_CA9X4_TIMER0	80
-#define IRQ_CT_CA9X4_TIMER1	81
-#define IRQ_CT_CA9X4_GPIO	{ 82 }
-#define IRQ_CT_CA9X4_PMU_CPU0	92
-#define IRQ_CT_CA9X4_PMU_CPU1	93
-#define IRQ_CT_CA9X4_PMU_CPU2	94
-#define IRQ_CT_CA9X4_PMU_CPU3	95
-
-extern struct ct_desc ct_ca9x4_desc;
-
-#endif
diff --git a/arch/arm/mach-vexpress/include/mach/hardware.h b/arch/arm/mach-vexpress/include/mach/hardware.h
deleted file mode 100644
index 40a8c17..0000000
--- a/arch/arm/mach-vexpress/include/mach/hardware.h
+++ /dev/null
@@ -1 +0,0 @@
-/* empty */
diff --git a/arch/arm/mach-vexpress/include/mach/irqs.h b/arch/arm/mach-vexpress/include/mach/irqs.h
deleted file mode 100644
index f8f7f78..0000000
--- a/arch/arm/mach-vexpress/include/mach/irqs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#define IRQ_LOCALTIMER		29
-#define IRQ_LOCALWDOG		30
-
-#ifndef CONFIG_SPARSE_IRQ
-#define NR_IRQS	256
-#endif
diff --git a/arch/arm/mach-vexpress/include/mach/motherboard.h b/arch/arm/mach-vexpress/include/mach/motherboard.h
deleted file mode 100644
index 68abc8b..0000000
--- a/arch/arm/mach-vexpress/include/mach/motherboard.h
+++ /dev/null
@@ -1,88 +0,0 @@
-#ifndef __MACH_MOTHERBOARD_H
-#define __MACH_MOTHERBOARD_H
-
-/*
- * Physical addresses, offset from V2M_PA_CS0-3
- */
-#define V2M_NOR0		(V2M_PA_CS0)
-#define V2M_NOR1		(V2M_PA_CS1)
-#define V2M_SRAM		(V2M_PA_CS2)
-#define V2M_VIDEO_SRAM		(V2M_PA_CS3 + 0x00000000)
-#define V2M_LAN9118		(V2M_PA_CS3 + 0x02000000)
-#define V2M_ISP1761		(V2M_PA_CS3 + 0x03000000)
-
-/*
- * Physical addresses, offset from V2M_PA_CS7
- */
-#define V2M_SYSREGS		(V2M_PA_CS7 + 0x00000000)
-#define V2M_SYSCTL		(V2M_PA_CS7 + 0x00001000)
-#define V2M_SERIAL_BUS_PCI	(V2M_PA_CS7 + 0x00002000)
-
-#define V2M_AACI		(V2M_PA_CS7 + 0x00004000)
-#define V2M_MMCI		(V2M_PA_CS7 + 0x00005000)
-#define V2M_KMI0		(V2M_PA_CS7 + 0x00006000)
-#define V2M_KMI1		(V2M_PA_CS7 + 0x00007000)
-
-#define V2M_UART0		(V2M_PA_CS7 + 0x00009000)
-#define V2M_UART1		(V2M_PA_CS7 + 0x0000a000)
-#define V2M_UART2		(V2M_PA_CS7 + 0x0000b000)
-#define V2M_UART3		(V2M_PA_CS7 + 0x0000c000)
-
-#define V2M_WDT			(V2M_PA_CS7 + 0x0000f000)
-
-#define V2M_TIMER01		(V2M_PA_CS7 + 0x00011000)
-#define V2M_TIMER23		(V2M_PA_CS7 + 0x00012000)
-
-#define V2M_SERIAL_BUS_DVI	(V2M_PA_CS7 + 0x00016000)
-#define V2M_RTC			(V2M_PA_CS7 + 0x00017000)
-
-#define V2M_CF			(V2M_PA_CS7 + 0x0001a000)
-#define V2M_CLCD		(V2M_PA_CS7 + 0x0001f000)
-
-
-/*
- * Interrupts.  Those in {} are for AMBA devices
- */
-#define IRQ_V2M_WDT		{ (32 + 0) }
-#define IRQ_V2M_TIMER0		(32 + 2)
-#define IRQ_V2M_TIMER1		(32 + 2)
-#define IRQ_V2M_TIMER2		(32 + 3)
-#define IRQ_V2M_TIMER3		(32 + 3)
-#define IRQ_V2M_RTC		{ (32 + 4) }
-#define IRQ_V2M_UART0		{ (32 + 5) }
-#define IRQ_V2M_UART1		{ (32 + 6) }
-#define IRQ_V2M_UART2		{ (32 + 7) }
-#define IRQ_V2M_UART3		{ (32 + 8) }
-#define IRQ_V2M_MMCI		{ (32 + 9), (32 + 10) }
-#define IRQ_V2M_AACI		{ (32 + 11) }
-#define IRQ_V2M_KMI0		{ (32 + 12) }
-#define IRQ_V2M_KMI1		{ (32 + 13) }
-#define IRQ_V2M_CLCD		{ (32 + 14) }
-#define IRQ_V2M_LAN9118		(32 + 15)
-#define IRQ_V2M_ISP1761		(32 + 16)
-#define IRQ_V2M_PCIE		(32 + 17)
-
-
-/*
- * Core tile IDs
- */
-#define V2M_CT_ID_CA9		0x0c000191
-#define V2M_CT_ID_UNSUPPORTED	0xff000191
-#define V2M_CT_ID_MASK		0xff000fff
-
-struct ct_desc {
-	u32			id;
-	const char		*name;
-	void			(*map_io)(void);
-	void			(*init_early)(void);
-	void			(*init_irq)(void);
-	void			(*init_tile)(void);
-#ifdef CONFIG_SMP
-	void			(*init_cpu_map)(void);
-	void			(*smp_enable)(unsigned int);
-#endif
-};
-
-extern struct ct_desc *ct_desc;
-
-#endif
diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index a1f3804..83188cf 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -19,48 +19,10 @@
 #include <asm/smp_scu.h>
 #include <asm/mach/map.h>
 
-#include <mach/motherboard.h>
-
 #include <plat/platsmp.h>
 
 #include "core.h"
 
-/*
- * Initialise the CPU possible map early - this describes the CPUs
- * which may be present or become present in the system.
- */
-static void __init vexpress_smp_init_cpus(void)
-{
-	ct_desc->init_cpu_map();
-}
-
-static void __init vexpress_smp_prepare_cpus(unsigned int max_cpus)
-{
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	ct_desc->smp_enable(max_cpus);
-
-	/*
-	 * Write the address of secondary startup into the
-	 * system-wide flags register. The boot monitor waits
-	 * until it receives a soft interrupt, and then the
-	 * secondary CPU branches to this address.
-	 */
-	vexpress_flags_set(virt_to_phys(versatile_secondary_startup));
-}
-
-struct smp_operations __initdata vexpress_smp_ops = {
-	.smp_init_cpus		= vexpress_smp_init_cpus,
-	.smp_prepare_cpus	= vexpress_smp_prepare_cpus,
-	.smp_secondary_init	= versatile_secondary_init,
-	.smp_boot_secondary	= versatile_boot_secondary,
-#ifdef CONFIG_HOTPLUG_CPU
-	.cpu_die		= vexpress_cpu_die,
-#endif
-};
-
 bool __init vexpress_smp_init_ops(void)
 {
 #ifdef CONFIG_MCPM
@@ -79,8 +41,6 @@ bool __init vexpress_smp_init_ops(void)
 	return false;
 }
 
-#if defined(CONFIG_OF)
-
 static const struct of_device_id vexpress_smp_dt_scu_match[] __initconst = {
 	{ .compatible = "arm,cortex-a5-scu", },
 	{ .compatible = "arm,cortex-a9-scu", },
@@ -112,5 +72,3 @@ struct smp_operations __initdata vexpress_smp_dt_ops = {
 	.cpu_die		= vexpress_cpu_die,
 #endif
 };
-
-#endif
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 6ff681a..a0400f4 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -1,380 +1,7 @@
-/*
- * Versatile Express V2M Motherboard Support
- */
-#include <linux/device.h>
-#include <linux/amba/bus.h>
-#include <linux/amba/mmci.h>
-#include <linux/io.h>
-#include <linux/smp.h>
-#include <linux/init.h>
-#include <linux/of_address.h>
-#include <linux/of_fdt.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-#include <linux/platform_device.h>
-#include <linux/ata_platform.h>
-#include <linux/smsc911x.h>
-#include <linux/spinlock.h>
-#include <linux/usb/isp1760.h>
-#include <linux/mtd/physmap.h>
-#include <linux/regulator/fixed.h>
-#include <linux/regulator/machine.h>
-#include <linux/vexpress.h>
-#include <linux/clkdev.h>
-
-#include <asm/mach-types.h>
-#include <asm/sizes.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/time.h>
-#include <asm/hardware/arm_timer.h>
-#include <asm/hardware/cache-l2x0.h>
-#include <asm/hardware/timer-sp.h>
-
-#include <mach/ct-ca9x4.h>
-#include <mach/motherboard.h>
-
-#include <plat/sched_clock.h>
-#include <plat/platsmp.h>
 
 #include "core.h"
 
-#define V2M_PA_CS0	0x40000000
-#define V2M_PA_CS1	0x44000000
-#define V2M_PA_CS2	0x48000000
-#define V2M_PA_CS3	0x4c000000
-#define V2M_PA_CS7	0x10000000
-
-static struct map_desc v2m_io_desc[] __initdata = {
-	{
-		.virtual	= V2M_PERIPH,
-		.pfn		= __phys_to_pfn(V2M_PA_CS7),
-		.length		= SZ_128K,
-		.type		= MT_DEVICE,
-	},
-};
-
-static void __init v2m_sp804_init(void __iomem *base, unsigned int irq)
-{
-	if (WARN_ON(!base || irq == NO_IRQ))
-		return;
-
-	sp804_clocksource_init(base + TIMER_2_BASE, "v2m-timer1");
-	sp804_clockevents_init(base + TIMER_1_BASE, irq, "v2m-timer0");
-}
-
-
-static struct resource v2m_pcie_i2c_resource = {
-	.start	= V2M_SERIAL_BUS_PCI,
-	.end	= V2M_SERIAL_BUS_PCI + SZ_4K - 1,
-	.flags	= IORESOURCE_MEM,
-};
-
-static struct platform_device v2m_pcie_i2c_device = {
-	.name		= "versatile-i2c",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= &v2m_pcie_i2c_resource,
-};
-
-static struct resource v2m_ddc_i2c_resource = {
-	.start	= V2M_SERIAL_BUS_DVI,
-	.end	= V2M_SERIAL_BUS_DVI + SZ_4K - 1,
-	.flags	= IORESOURCE_MEM,
-};
-
-static struct platform_device v2m_ddc_i2c_device = {
-	.name		= "versatile-i2c",
-	.id		= 1,
-	.num_resources	= 1,
-	.resource	= &v2m_ddc_i2c_resource,
-};
-
-static struct resource v2m_eth_resources[] = {
-	{
-		.start	= V2M_LAN9118,
-		.end	= V2M_LAN9118 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_V2M_LAN9118,
-		.end	= IRQ_V2M_LAN9118,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct smsc911x_platform_config v2m_eth_config = {
-	.flags		= SMSC911X_USE_32BIT,
-	.irq_polarity	= SMSC911X_IRQ_POLARITY_ACTIVE_HIGH,
-	.irq_type	= SMSC911X_IRQ_TYPE_PUSH_PULL,
-	.phy_interface	= PHY_INTERFACE_MODE_MII,
-};
-
-static struct platform_device v2m_eth_device = {
-	.name		= "smsc911x",
-	.id		= -1,
-	.resource	= v2m_eth_resources,
-	.num_resources	= ARRAY_SIZE(v2m_eth_resources),
-	.dev.platform_data = &v2m_eth_config,
-};
-
-static struct regulator_consumer_supply v2m_eth_supplies[] = {
-	REGULATOR_SUPPLY("vddvario", "smsc911x"),
-	REGULATOR_SUPPLY("vdd33a", "smsc911x"),
-};
-
-static struct resource v2m_usb_resources[] = {
-	{
-		.start	= V2M_ISP1761,
-		.end	= V2M_ISP1761 + SZ_128K - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= IRQ_V2M_ISP1761,
-		.end	= IRQ_V2M_ISP1761,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct isp1760_platform_data v2m_usb_config = {
-	.is_isp1761		= true,
-	.bus_width_16		= false,
-	.port1_otg		= true,
-	.analog_oc		= false,
-	.dack_polarity_high	= false,
-	.dreq_polarity_high	= false,
-};
-
-static struct platform_device v2m_usb_device = {
-	.name		= "isp1760",
-	.id		= -1,
-	.resource	= v2m_usb_resources,
-	.num_resources	= ARRAY_SIZE(v2m_usb_resources),
-	.dev.platform_data = &v2m_usb_config,
-};
-
-static struct physmap_flash_data v2m_flash_data = {
-	.width		= 4,
-};
-
-static struct resource v2m_flash_resources[] = {
-	{
-		.start	= V2M_NOR0,
-		.end	= V2M_NOR0 + SZ_64M - 1,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= V2M_NOR1,
-		.end	= V2M_NOR1 + SZ_64M - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device v2m_flash_device = {
-	.name		= "physmap-flash",
-	.id		= -1,
-	.resource	= v2m_flash_resources,
-	.num_resources	= ARRAY_SIZE(v2m_flash_resources),
-	.dev.platform_data = &v2m_flash_data,
-};
-
-static struct pata_platform_info v2m_pata_data = {
-	.ioport_shift	= 2,
-};
-
-static struct resource v2m_pata_resources[] = {
-	{
-		.start	= V2M_CF,
-		.end	= V2M_CF + 0xff,
-		.flags	= IORESOURCE_MEM,
-	}, {
-		.start	= V2M_CF + 0x100,
-		.end	= V2M_CF + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device v2m_cf_device = {
-	.name		= "pata_platform",
-	.id		= -1,
-	.resource	= v2m_pata_resources,
-	.num_resources	= ARRAY_SIZE(v2m_pata_resources),
-	.dev.platform_data = &v2m_pata_data,
-};
-
-static struct mmci_platform_data v2m_mmci_data = {
-	.ocr_mask	= MMC_VDD_32_33|MMC_VDD_33_34,
-	.status		= vexpress_get_mci_cardin,
-	.gpio_cd	= -1,
-	.gpio_wp	= -1,
-};
-
-static struct resource v2m_sysreg_resources[] = {
-	{
-		.start	= V2M_SYSREGS,
-		.end	= V2M_SYSREGS + 0xfff,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device v2m_sysreg_device = {
-	.name		= "vexpress-sysreg",
-	.id		= -1,
-	.resource	= v2m_sysreg_resources,
-	.num_resources	= ARRAY_SIZE(v2m_sysreg_resources),
-};
-
-static struct platform_device v2m_muxfpga_device = {
-	.name		= "vexpress-muxfpga",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 7),
-	}
-};
-
-static struct platform_device v2m_shutdown_device = {
-	.name		= "vexpress-shutdown",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 8),
-	}
-};
-
-static struct platform_device v2m_reboot_device = {
-	.name		= "vexpress-reboot",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 9),
-	}
-};
-
-static struct platform_device v2m_dvimode_device = {
-	.name		= "vexpress-dvimode",
-	.id		= 0,
-	.num_resources	= 1,
-	.resource	= (struct resource []) {
-		VEXPRESS_RES_FUNC(0, 11),
-	}
-};
-
-static AMBA_APB_DEVICE(aaci,  "mb:aaci",  0, V2M_AACI, IRQ_V2M_AACI, NULL);
-static AMBA_APB_DEVICE(mmci,  "mb:mmci",  0, V2M_MMCI, IRQ_V2M_MMCI, &v2m_mmci_data);
-static AMBA_APB_DEVICE(kmi0,  "mb:kmi0",  0, V2M_KMI0, IRQ_V2M_KMI0, NULL);
-static AMBA_APB_DEVICE(kmi1,  "mb:kmi1",  0, V2M_KMI1, IRQ_V2M_KMI1, NULL);
-static AMBA_APB_DEVICE(uart0, "mb:uart0", 0, V2M_UART0, IRQ_V2M_UART0, NULL);
-static AMBA_APB_DEVICE(uart1, "mb:uart1", 0, V2M_UART1, IRQ_V2M_UART1, NULL);
-static AMBA_APB_DEVICE(uart2, "mb:uart2", 0, V2M_UART2, IRQ_V2M_UART2, NULL);
-static AMBA_APB_DEVICE(uart3, "mb:uart3", 0, V2M_UART3, IRQ_V2M_UART3, NULL);
-static AMBA_APB_DEVICE(wdt,   "mb:wdt",   0, V2M_WDT, IRQ_V2M_WDT, NULL);
-static AMBA_APB_DEVICE(rtc,   "mb:rtc",   0, V2M_RTC, IRQ_V2M_RTC, NULL);
-
-static struct amba_device *v2m_amba_devs[] __initdata = {
-	&aaci_device,
-	&mmci_device,
-	&kmi0_device,
-	&kmi1_device,
-	&uart0_device,
-	&uart1_device,
-	&uart2_device,
-	&uart3_device,
-	&wdt_device,
-	&rtc_device,
-};
-
-static void __init v2m_timer_init(void)
-{
-	vexpress_clk_init(ioremap(V2M_SYSCTL, SZ_4K));
-	v2m_sp804_init(ioremap(V2M_TIMER01, SZ_4K), IRQ_V2M_TIMER0);
-}
-
-static void __init v2m_init_early(void)
-{
-	if (ct_desc->init_early)
-		ct_desc->init_early();
-	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
-}
-
-struct ct_desc *ct_desc;
-
-static struct ct_desc *ct_descs[] __initdata = {
-#ifdef CONFIG_ARCH_VEXPRESS_CA9X4
-	&ct_ca9x4_desc,
-#endif
-};
-
-static void __init v2m_populate_ct_desc(void)
-{
-	int i;
-	u32 current_tile_id;
-
-	ct_desc = NULL;
-	current_tile_id = vexpress_get_procid(VEXPRESS_SITE_MASTER)
-				& V2M_CT_ID_MASK;
-
-	for (i = 0; i < ARRAY_SIZE(ct_descs) && !ct_desc; ++i)
-		if (ct_descs[i]->id == current_tile_id)
-			ct_desc = ct_descs[i];
-
-	if (!ct_desc)
-		panic("vexpress: this kernel does not support core tile ID 0x%08x when booting via ATAGs.\n"
-		      "You may need a device tree blob or a different kernel to boot on this board.\n",
-		      current_tile_id);
-}
-
-static void __init v2m_map_io(void)
-{
-	iotable_init(v2m_io_desc, ARRAY_SIZE(v2m_io_desc));
-	vexpress_sysreg_early_init(ioremap(V2M_SYSREGS, SZ_4K));
-	v2m_populate_ct_desc();
-	ct_desc->map_io();
-}
-
-static void __init v2m_init_irq(void)
-{
-	ct_desc->init_irq();
-}
-
-static void __init v2m_init(void)
-{
-	int i;
-
-	regulator_register_fixed(0, v2m_eth_supplies,
-			ARRAY_SIZE(v2m_eth_supplies));
-
-	platform_device_register(&v2m_sysreg_device);
-	platform_device_register(&v2m_pcie_i2c_device);
-	platform_device_register(&v2m_ddc_i2c_device);
-	platform_device_register(&v2m_flash_device);
-	platform_device_register(&v2m_cf_device);
-	platform_device_register(&v2m_eth_device);
-	platform_device_register(&v2m_usb_device);
-
-	for (i = 0; i < ARRAY_SIZE(v2m_amba_devs); i++)
-		amba_device_register(v2m_amba_devs[i], &iomem_resource);
-
-	vexpress_syscfg_device_register(&v2m_muxfpga_device);
-	vexpress_syscfg_device_register(&v2m_shutdown_device);
-	vexpress_syscfg_device_register(&v2m_reboot_device);
-	vexpress_syscfg_device_register(&v2m_dvimode_device);
-
-	ct_desc->init_tile();
-}
-
-MACHINE_START(VEXPRESS, "ARM-Versatile Express")
-	.atag_offset	= 0x100,
-	.smp		= smp_ops(vexpress_smp_ops),
-	.map_io		= v2m_map_io,
-	.init_early	= v2m_init_early,
-	.init_irq	= v2m_init_irq,
-	.init_time	= v2m_timer_init,
-	.init_machine	= v2m_init,
-MACHINE_END
-
-static void __init v2m_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
 static const char * const v2m_dt_match[] __initconst = {
 	"arm,vexpress",
 	NULL,
@@ -386,5 +13,4 @@ DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.l2c_aux_mask	= 0xfe0fffff,
 	.smp		= smp_ops(vexpress_smp_dt_ops),
 	.smp_init	= smp_init_ops(vexpress_smp_init_ops),
-	.init_machine	= v2m_dt_init,
 MACHINE_END
diff --git a/arch/arm/plat-versatile/Kconfig b/arch/arm/plat-versatile/Kconfig
index a301ca2..49b8ef9 100644
--- a/arch/arm/plat-versatile/Kconfig
+++ b/arch/arm/plat-versatile/Kconfig
@@ -4,6 +4,6 @@ config PLAT_VERSATILE_CLOCK
 	bool
 
 config PLAT_VERSATILE_SCHED_CLOCK
-	def_bool y
+	bool
 
 endif
diff --git a/drivers/clk/versatile/Makefile b/drivers/clk/versatile/Makefile
index 162e519..8ff0374 100644
--- a/drivers/clk/versatile/Makefile
+++ b/drivers/clk/versatile/Makefile
@@ -2,6 +2,5 @@
 obj-$(CONFIG_ICST)		+= clk-icst.o clk-versatile.o
 obj-$(CONFIG_INTEGRATOR_IMPD1)	+= clk-impd1.o
 obj-$(CONFIG_ARCH_REALVIEW)	+= clk-realview.o
-obj-$(CONFIG_ARCH_VEXPRESS)	+= clk-vexpress.o
 obj-$(CONFIG_CLK_SP810)		+= clk-sp810.o
 obj-$(CONFIG_CLK_VEXPRESS_OSC)	+= clk-vexpress-osc.o
diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index 529a59c..765f1e0 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -70,7 +70,6 @@ static struct clk_ops vexpress_osc_ops = {
 
 static int vexpress_osc_probe(struct platform_device *pdev)
 {
-	struct clk_lookup *cl = pdev->dev.platform_data; /* Non-DT lookup */
 	struct clk_init_data init;
 	struct vexpress_osc *osc;
 	struct clk *clk;
@@ -106,12 +105,6 @@ static int vexpress_osc_probe(struct platform_device *pdev)
 
 	of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get, clk);
 
-	/* Only happens for non-DT cases */
-	if (cl) {
-		cl->clk = clk;
-		clkdev_add(cl);
-	}
-
 	dev_dbg(&pdev->dev, "Registered clock '%s'\n", init.name);
 
 	return 0;
diff --git a/drivers/clk/versatile/clk-vexpress.c b/drivers/clk/versatile/clk-vexpress.c
deleted file mode 100644
index 2d5e1b4..0000000
--- a/drivers/clk/versatile/clk-vexpress.c
+++ /dev/null
@@ -1,86 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * Copyright (C) 2012 ARM Limited
- */
-
-#include <linux/amba/sp810.h>
-#include <linux/clkdev.h>
-#include <linux/clk-provider.h>
-#include <linux/err.h>
-#include <linux/vexpress.h>
-
-static struct clk *vexpress_sp810_timerclken[4];
-static DEFINE_SPINLOCK(vexpress_sp810_lock);
-
-static void __init vexpress_sp810_init(void __iomem *base)
-{
-	int i;
-
-	if (WARN_ON(!base))
-		return;
-
-	for (i = 0; i < ARRAY_SIZE(vexpress_sp810_timerclken); i++) {
-		char name[12];
-		const char *parents[] = {
-			"v2m:refclk32khz", /* REFCLK */
-			"v2m:refclk1mhz" /* TIMCLK */
-		};
-
-		snprintf(name, ARRAY_SIZE(name), "timerclken%d", i);
-
-		vexpress_sp810_timerclken[i] = clk_register_mux(NULL, name,
-				parents, 2, CLK_SET_RATE_NO_REPARENT,
-				base + SCCTRL, SCCTRL_TIMERENnSEL_SHIFT(i), 1,
-				0, &vexpress_sp810_lock);
-
-		if (WARN_ON(IS_ERR(vexpress_sp810_timerclken[i])))
-			break;
-	}
-}
-
-
-static const char * const vexpress_clk_24mhz_periphs[] __initconst = {
-	"mb:uart0", "mb:uart1", "mb:uart2", "mb:uart3",
-	"mb:mmci", "mb:kmi0", "mb:kmi1"
-};
-
-void __init vexpress_clk_init(void __iomem *sp810_base)
-{
-	struct clk *clk;
-	int i;
-
-	clk = clk_register_fixed_rate(NULL, "dummy_apb_pclk", NULL,
-			CLK_IS_ROOT, 0);
-	WARN_ON(clk_register_clkdev(clk, "apb_pclk", NULL));
-
-	clk = clk_register_fixed_rate(NULL, "v2m:clk_24mhz", NULL,
-			CLK_IS_ROOT, 24000000);
-	for (i = 0; i < ARRAY_SIZE(vexpress_clk_24mhz_periphs); i++)
-		WARN_ON(clk_register_clkdev(clk, NULL,
-				vexpress_clk_24mhz_periphs[i]));
-
-	clk = clk_register_fixed_rate(NULL, "v2m:refclk32khz", NULL,
-			CLK_IS_ROOT, 32768);
-	WARN_ON(clk_register_clkdev(clk, NULL, "v2m:wdt"));
-
-	clk = clk_register_fixed_rate(NULL, "v2m:refclk1mhz", NULL,
-			CLK_IS_ROOT, 1000000);
-
-	vexpress_sp810_init(sp810_base);
-
-	for (i = 0; i < ARRAY_SIZE(vexpress_sp810_timerclken); i++)
-		WARN_ON(clk_set_parent(vexpress_sp810_timerclken[i], clk));
-
-	WARN_ON(clk_register_clkdev(vexpress_sp810_timerclken[0],
-				"v2m-timer0", "sp804"));
-	WARN_ON(clk_register_clkdev(vexpress_sp810_timerclken[1],
-				"v2m-timer1", "sp804"));
-}
diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
index b3a8123..c344483 100644
--- a/drivers/misc/vexpress-syscfg.c
+++ b/drivers/misc/vexpress-syscfg.c
@@ -145,7 +145,7 @@ static struct regmap_config vexpress_syscfg_regmap_config = {
 static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
 		void *context)
 {
-	struct platform_device *pdev = to_platform_device(dev);
+	int err;
 	struct vexpress_syscfg *syscfg = context;
 	struct vexpress_syscfg_func *func;
 	struct property *prop;
@@ -155,32 +155,18 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
 	u32 site, position, dcc;
 	int i;
 
-	if (dev->of_node) {
-		int err = vexpress_config_get_topo(dev->of_node, &site,
+	err = vexpress_config_get_topo(dev->of_node, &site,
 				&position, &dcc);
+	if (err)
+		return ERR_PTR(err);
 
-		if (err)
-			return ERR_PTR(err);
-
-		prop = of_find_property(dev->of_node,
-				"arm,vexpress-sysreg,func", NULL);
-		if (!prop)
-			return ERR_PTR(-EINVAL);
-
-		num = prop->length / sizeof(u32) / 2;
-		val = prop->value;
-	} else {
-		if (pdev->num_resources != 1 ||
-				pdev->resource[0].flags != IORESOURCE_BUS)
-			return ERR_PTR(-EFAULT);
-
-		site = pdev->resource[0].start;
-		if (site == VEXPRESS_SITE_MASTER)
-			site = vexpress_config_get_master();
-		position = 0;
-		dcc = 0;
-		num = 1;
-	}
+	prop = of_find_property(dev->of_node,
+			"arm,vexpress-sysreg,func", NULL);
+	if (!prop)
+		return ERR_PTR(-EINVAL);
+
+	num = prop->length / sizeof(u32) / 2;
+	val = prop->value;
 
 	/*
 	 * "arm,vexpress-energy" function used to be described
@@ -207,13 +193,8 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
 	for (i = 0; i < num; i++) {
 		u32 function, device;
 
-		if (dev->of_node) {
-			function = be32_to_cpup(val++);
-			device = be32_to_cpup(val++);
-		} else {
-			function = pdev->resource[0].end;
-			device = pdev->id;
-		}
+		function = be32_to_cpup(val++);
+		device = be32_to_cpup(val++);
 
 		dev_dbg(dev, "func %p: %u/%u/%u/%u/%u\n",
 				func, site, position, dcc,
@@ -265,17 +246,6 @@ static struct vexpress_config_bridge_ops vexpress_syscfg_bridge_ops = {
 };
 
 
-/* Non-DT hack, to be gone... */
-static struct device *vexpress_syscfg_bridge;
-
-int vexpress_syscfg_device_register(struct platform_device *pdev)
-{
-	pdev->dev.parent = vexpress_syscfg_bridge;
-
-	return platform_device_register(pdev);
-}
-
-
 static int vexpress_syscfg_probe(struct platform_device *pdev)
 {
 	struct vexpress_syscfg *syscfg;
@@ -303,10 +273,6 @@ static int vexpress_syscfg_probe(struct platform_device *pdev)
 	if (IS_ERR(bridge))
 		return PTR_ERR(bridge);
 
-	/* Non-DT case */
-	if (!pdev->dev.of_node)
-		vexpress_syscfg_bridge = bridge;
-
 	return 0;
 }
 
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index a4c9547..f8e76e0 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -15,8 +15,6 @@
 #define _LINUX_VEXPRESS_H
 
 #include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/reboot.h>
 #include <linux/regmap.h>
 
 #define VEXPRESS_SITE_MB		0
@@ -24,13 +22,6 @@
 #define VEXPRESS_SITE_DB2		2
 #define VEXPRESS_SITE_MASTER		0xf
 
-#define VEXPRESS_RES_FUNC(_site, _func)	\
-{					\
-	.start = (_site),		\
-	.end = (_func),			\
-	.flags = IORESOURCE_BUS,	\
-}
-
 /* Config infrastructure */
 
 void vexpress_config_set_master(u32 site);
@@ -58,16 +49,6 @@ struct regmap *devm_regmap_init_vexpress_config(struct device *dev);
 
 /* Platform control */
 
-unsigned int vexpress_get_mci_cardin(struct device *dev);
-u32 vexpress_get_procid(int site);
-void *vexpress_get_24mhz_clock_base(void);
 void vexpress_flags_set(u32 data);
 
-void vexpress_sysreg_early_init(void __iomem *base);
-int vexpress_syscfg_device_register(struct platform_device *pdev);
-
-/* Clocks */
-
-void vexpress_clk_init(void __iomem *sp810_base);
-
 #endif
-- 
2.1.0

