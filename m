Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3FKIkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:40:43 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56706 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3FKIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:40:40 -0400
From: Daniel Tang <dt.tangr@gmail.com>
To: arm@kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCHv2 1/2] arm: Add Initial TI-Nspire support
Date: Tue, 11 Jun 2013 18:40:17 +1000
Message-Id: <1370940018-54330-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the TI-Nspire platform.

Changes between v1 and v2:
* Added GENERIC_IRQ_CHIP to platform Kconfig

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/Kconfig                   |   2 +
 arch/arm/Kconfig.debug             |  16 +++++
 arch/arm/Makefile                  |   1 +
 arch/arm/include/debug/nspire.S    |  28 +++++++++
 arch/arm/mach-nspire/Kconfig       |  16 +++++
 arch/arm/mach-nspire/Makefile      |   2 +
 arch/arm/mach-nspire/Makefile.boot |   0
 arch/arm/mach-nspire/clcd.c        | 119 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-nspire/clcd.h        |  14 +++++
 arch/arm/mach-nspire/mmio.h        |  20 +++++++
 arch/arm/mach-nspire/nspire.c      |  89 +++++++++++++++++++++++++++
 11 files changed, 307 insertions(+)
 create mode 100644 arch/arm/include/debug/nspire.S
 create mode 100644 arch/arm/mach-nspire/Kconfig
 create mode 100644 arch/arm/mach-nspire/Makefile
 create mode 100644 arch/arm/mach-nspire/Makefile.boot
 create mode 100644 arch/arm/mach-nspire/clcd.c
 create mode 100644 arch/arm/mach-nspire/clcd.h
 create mode 100644 arch/arm/mach-nspire/mmio.h
 create mode 100644 arch/arm/mach-nspire/nspire.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 49d993c..86a3ed9 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -964,6 +964,8 @@ source "arch/arm/mach-netx/Kconfig"
 
 source "arch/arm/mach-nomadik/Kconfig"
 
+source "arch/arm/mach-nspire/Kconfig"
+
 source "arch/arm/plat-omap/Kconfig"
 
 source "arch/arm/mach-omap1/Kconfig"
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 1d41908..fe07941 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -309,6 +309,20 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on MVEBU based platforms.
 
+	config DEBUG_NSPIRE_CLASSIC_UART
+		bool "Kernel low-level debugging via TI-NSPIRE 8250 UART"
+		depends on ARCH_NSPIRE
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on TI-NSPIRE classic models.
+
+	config DEBUG_NSPIRE_CX_UART
+		bool "Kernel low-level debugging via TI-NSPIRE PL011 UART"
+		depends on ARCH_NSPIRE
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on TI-NSPIRE CX models.
+
 	config DEBUG_NOMADIK_UART
 		bool "Kernel low-level debugging messages via NOMADIK UART"
 		depends on ARCH_NOMADIK
@@ -633,6 +647,8 @@ config DEBUG_LL_INCLUDE
 				 DEBUG_IMX53_UART ||\
 				 DEBUG_IMX6Q_UART
 	default "debug/mvebu.S" if DEBUG_MVEBU_UART
+	default "debug/nspire.S" if 	DEBUG_NSPIRE_CX_UART || \
+					DEBUG_NSPIRE_CLASSIC_UART
 	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
 	default "debug/nomadik.S" if DEBUG_NOMADIK_UART
 	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 1ba358b..b4615aa 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -164,6 +164,7 @@ machine-$(CONFIG_ARCH_MXS)		+= mxs
 machine-$(CONFIG_ARCH_MVEBU)		+= mvebu
 machine-$(CONFIG_ARCH_NETX)		+= netx
 machine-$(CONFIG_ARCH_NOMADIK)		+= nomadik
+machine-$(CONFIG_ARCH_NSPIRE)		+= nspire
 machine-$(CONFIG_ARCH_OMAP1)		+= omap1
 machine-$(CONFIG_ARCH_OMAP2PLUS)	+= omap2
 machine-$(CONFIG_ARCH_ORION5X)		+= orion5x
diff --git a/arch/arm/include/debug/nspire.S b/arch/arm/include/debug/nspire.S
new file mode 100644
index 0000000..886fd27
--- /dev/null
+++ b/arch/arm/include/debug/nspire.S
@@ -0,0 +1,28 @@
+/*
+ *	linux/arch/arm/include/debug/nspire.S
+ *
+ *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define NSPIRE_EARLY_UART_PHYS_BASE	   0x90020000
+#define NSPIRE_EARLY_UART_VIRT_BASE	   0xfee20000
+
+.macro	addruart, rp, rv, tmp
+	ldr \rp, =(NSPIRE_EARLY_UART_PHYS_BASE)		@ physical base address
+	ldr \rv, =(NSPIRE_EARLY_UART_VIRT_BASE)		@ virtual base address
+.endm
+
+
+#ifdef CONFIG_DEBUG_NSPIRE_CX_UART
+#include <asm/hardware/debug-pl01x.S>
+#endif
+
+#ifdef CONFIG_DEBUG_NSPIRE_CLASSIC_UART
+#define UART_SHIFT 2
+#include <asm/hardware/debug-8250.S>
+#endif
diff --git a/arch/arm/mach-nspire/Kconfig b/arch/arm/mach-nspire/Kconfig
new file mode 100644
index 0000000..59d8f0a
--- /dev/null
+++ b/arch/arm/mach-nspire/Kconfig
@@ -0,0 +1,16 @@
+config ARCH_NSPIRE
+	bool "TI-NSPIRE based"
+	depends on ARCH_MULTI_V4_V5
+	depends on MMU
+	select CPU_ARM926T
+	select COMMON_CLK
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_IRQ_CHIP
+	select SPARSE_IRQ
+	select ARM_AMBA
+	select ARM_VIC
+	select ARM_TIMER_SP804
+	select USE_OF
+	select CLKSRC_OF
+	help
+	  This enables support for systems using the TI-NSPIRE CPU
diff --git a/arch/arm/mach-nspire/Makefile b/arch/arm/mach-nspire/Makefile
new file mode 100644
index 0000000..1bec256
--- /dev/null
+++ b/arch/arm/mach-nspire/Makefile
@@ -0,0 +1,2 @@
+obj-y				+= nspire.o
+obj-y				+= clcd.o
diff --git a/arch/arm/mach-nspire/Makefile.boot b/arch/arm/mach-nspire/Makefile.boot
new file mode 100644
index 0000000..e69de29
diff --git a/arch/arm/mach-nspire/clcd.c b/arch/arm/mach-nspire/clcd.c
new file mode 100644
index 0000000..abea126
--- /dev/null
+++ b/arch/arm/mach-nspire/clcd.c
@@ -0,0 +1,119 @@
+/*
+ *	linux/arch/arm/mach-nspire/clcd.c
+ *
+ *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/of.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/dma-mapping.h>
+
+static struct clcd_panel nspire_cx_lcd_panel = {
+	.mode		= {
+		.name		= "Color LCD",
+		.refresh	= 60,
+		.xres		= 320,
+		.yres		= 240,
+		.sync		= 0,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.pixclock	= 1,
+		.hsync_len	= 6,
+		.vsync_len	= 1,
+		.right_margin	= 50,
+		.left_margin	= 38,
+		.lower_margin	= 3,
+		.upper_margin	= 17,
+	},
+	.width		= 65, /* ~6.50 cm */
+	.height		= 49, /* ~4.87 cm */
+	.tim2		= TIM2_IPC,
+	.cntl		= CNTL_LCDTFT | CNTL_LCDVCOMP(1),
+	.bpp		= 16,
+	.caps		= CLCD_CAP_565,
+};
+
+static struct clcd_panel nspire_classic_lcd_panel = {
+	.mode		= {
+		.name		= "Grayscale LCD",
+		.refresh	= 60,
+		.xres		= 320,
+		.yres		= 240,
+		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+		.vmode		= FB_VMODE_NONINTERLACED,
+		.pixclock	= 1,
+		.hsync_len	= 6,
+		.vsync_len	= 1,
+		.right_margin	= 6,
+		.left_margin	= 6,
+	},
+	.width		= 71, /* 7.11cm */
+	.height		= 53, /* 5.33cm */
+	.tim2		= 0x80007d0,
+	.cntl		= CNTL_LCDMONO8,
+	.bpp		= 8,
+	.grayscale	= 1,
+	.caps		= CLCD_CAP_5551,
+};
+
+int nspire_clcd_setup(struct clcd_fb *fb)
+{
+	struct clcd_panel *panel;
+	size_t panel_size;
+	const char *type;
+	dma_addr_t dma;
+	int err;
+
+	BUG_ON(!fb->dev->dev.of_node);
+
+	err = of_property_read_string(fb->dev->dev.of_node, "lcd-type", &type);
+	if (err) {
+		pr_err("CLCD: Could not find lcd-type property\n");
+		return err;
+	}
+
+	if (!strcmp(type, "cx")) {
+		panel = &nspire_cx_lcd_panel;
+	} else if (!strcmp(type, "classic")) {
+		panel = &nspire_classic_lcd_panel;
+	} else {
+		pr_err("CLCD: Unknown lcd-type %s\n", type);
+		return -EINVAL;
+	}
+
+	panel_size = ((panel->mode.xres * panel->mode.yres) * panel->bpp) / 8;
+	panel_size = ALIGN(panel_size, PAGE_SIZE);
+
+	fb->fb.screen_base = dma_alloc_writecombine(&fb->dev->dev,
+		panel_size, &dma, GFP_KERNEL);
+
+	if (!fb->fb.screen_base) {
+		pr_err("CLCD: unable to map framebuffer\n");
+		return -ENOMEM;
+	}
+
+	fb->fb.fix.smem_start = dma;
+	fb->fb.fix.smem_len = panel_size;
+	fb->panel = panel;
+
+	return 0;
+}
+
+int nspire_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
+{
+	return dma_mmap_writecombine(&fb->dev->dev, vma,
+		fb->fb.screen_base, fb->fb.fix.smem_start,
+		fb->fb.fix.smem_len);
+}
+
+void nspire_clcd_remove(struct clcd_fb *fb)
+{
+	dma_free_writecombine(&fb->dev->dev, fb->fb.fix.smem_len,
+		fb->fb.screen_base, fb->fb.fix.smem_start);
+}
diff --git a/arch/arm/mach-nspire/clcd.h b/arch/arm/mach-nspire/clcd.h
new file mode 100644
index 0000000..8c33d2c
--- /dev/null
+++ b/arch/arm/mach-nspire/clcd.h
@@ -0,0 +1,14 @@
+/*
+ *	linux/arch/arm/mach-nspire/clcd.h
+ *
+ *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+int nspire_clcd_setup(struct clcd_fb *fb);
+int nspire_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma);
+void nspire_clcd_remove(struct clcd_fb *fb);
diff --git a/arch/arm/mach-nspire/mmio.h b/arch/arm/mach-nspire/mmio.h
new file mode 100644
index 0000000..8813471
--- /dev/null
+++ b/arch/arm/mach-nspire/mmio.h
@@ -0,0 +1,20 @@
+/*
+ *	linux/arch/arm/mach-nspire/mmio.h
+ *
+ *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define NSPIRE_MISC_PHYS_BASE		0x900A0000
+#define NSPIRE_MISC_HWRESET		0x08
+
+#define NSPIRE_PWR_PHYS_BASE		0x900B0000
+#define NSPIRE_PWR_VIRT_BASE		0xFEEB0000
+#define NSPIRE_PWR_BUS_DISABLE1		0x18
+#define NSPIRE_PWR_BUS_DISABLE2		0x20
+
+#define NSPIRE_LCD_PHYS_BASE		0xC0000000
diff --git a/arch/arm/mach-nspire/nspire.c b/arch/arm/mach-nspire/nspire.c
new file mode 100644
index 0000000..99e2609
--- /dev/null
+++ b/arch/arm/mach-nspire/nspire.c
@@ -0,0 +1,89 @@
+/*
+ *	linux/arch/arm/mach-nspire/nspire.c
+ *
+ *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/init.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/irqchip.h>
+#include <linux/irqchip/arm-vic.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/clcd.h>
+#include <linux/clocksource.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach-types.h>
+#include <asm/mach/map.h>
+
+#include <asm/hardware/timer-sp.h>
+
+#include "mmio.h"
+#include "clcd.h"
+
+static const char *nspire_dt_match[] __initconst = {
+	"ti,nspire",
+	"ti,nspire-cx",
+	"ti,nspire-tp",
+	"ti,nspire-clp",
+	NULL,
+};
+
+static void __init nspire_map_io(void)
+{
+	debug_ll_io_init();
+}
+
+static struct clcd_board nspire_clcd_data = {
+	.name		= "LCD",
+	.caps		= CLCD_CAP_5551 | CLCD_CAP_565,
+	.check		= clcdfb_check,
+	.decode		= clcdfb_decode,
+	.setup		= nspire_clcd_setup,
+	.mmap		= nspire_clcd_mmap,
+	.remove		= nspire_clcd_remove,
+};
+
+
+static struct of_dev_auxdata nspire_auxdata[] __initdata = {
+	OF_DEV_AUXDATA("arm,pl111", NSPIRE_LCD_PHYS_BASE,
+			NULL, &nspire_clcd_data),
+	{ }
+};
+
+static void __init nspire_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			nspire_auxdata, NULL);
+}
+
+static void __init nspire_init_time(void)
+{
+	of_clk_init(NULL);
+	clocksource_of_init();
+}
+
+static void nspire_restart(char mode, const char *cmd)
+{
+	void __iomem *base = ioremap(NSPIRE_MISC_PHYS_BASE, SZ_4K);
+	if (!base)
+		return;
+
+	writel(2, base + NSPIRE_MISC_HWRESET);
+}
+
+DT_MACHINE_START(NSPIRE, "TI-NSPIRE")
+	.dt_compat	= nspire_dt_match,
+	.map_io		= nspire_map_io,
+	.init_time	= nspire_init_time,
+	.init_machine	= nspire_init,
+	.restart	= nspire_restart,
+MACHINE_END
-- 
1.8.1.3

