Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab3K0AXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:23:01 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63946 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3K0AW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:22:59 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
Date: Tue, 26 Nov 2013 16:22:23 -0800
Message-Id: <1385511748-27869-2-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM7xxx series of Broadcom SoCs are used primarily in set-top boxes.

This patch adds machine support for the ARM-based Broadcom SoCs.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/Kconfig.debug              |   16 +++-
 arch/arm/configs/brcmstb_defconfig  |  127 ++++++++++++++++++++++
 arch/arm/mach-bcm/Kconfig           |   18 +++
 arch/arm/mach-bcm/Makefile          |    2 +
 arch/arm/mach-bcm/brcmstb.c         |  205 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-bcm/brcmstb.h         |   70 ++++++++++++
 arch/arm/mach-bcm/headsmp-brcmstb.S |   29 +++++
 arch/arm/mach-bcm/hotplug-brcmstb.c |  203 ++++++++++++++++++++++++++++++++++
 8 files changed, 669 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/configs/brcmstb_defconfig
 create mode 100644 arch/arm/mach-bcm/brcmstb.c
 create mode 100644 arch/arm/mach-bcm/brcmstb.h
 create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 create mode 100644 arch/arm/mach-bcm/hotplug-brcmstb.c

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5765abf..266c699 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -94,6 +94,17 @@ choice
 		depends on ARCH_BCM2835
 		select DEBUG_UART_PL01X
 
+	config DEBUG_BRCMSTB_UART
+		bool "Use BRCMSTB UART for low-level debug"
+		depends on ARCH_BRCMSTB
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to the first serial port on these devices.
+
+		  If you have a Broadcom STB chip and would like early print
+		  messages to appear over the UART, select this option.
+
 	config DEBUG_CLPS711X_UART1
 		bool "Kernel low-level debugging messages via UART1"
 		depends on ARCH_CLPS711X
@@ -988,6 +999,7 @@ config DEBUG_UART_PHYS
 	default 0x20064000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 	default 0x20068000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
 	default 0x20201000 if DEBUG_BCM2835
+	default 0xf0406b00 if DEBUG_BRCMSTB_UART
 	default 0x4000e400 if DEBUG_LL_UART_EFM32
 	default 0x40090000 if ARCH_LPC32XX
 	default 0x40100000 if DEBUG_PXA_UART1
@@ -1029,6 +1041,7 @@ config DEBUG_UART_VIRT
 	default 0xf0009000 if DEBUG_CNS3XXX
 	default 0xf01fb000 if DEBUG_NOMADIK_UART
 	default 0xf0201000 if DEBUG_BCM2835
+	default 0xfc406b00 if DEBUG_BRCMSTB_UART
 	default 0xf11f1000 if ARCH_VERSATILE
 	default 0xf1600000 if ARCH_INTEGRATOR
 	default 0xf1c28000 if DEBUG_SUNXI_UART0
@@ -1091,7 +1104,8 @@ config DEBUG_UART_8250_WORD
 	default y if DEBUG_PICOXCELL_UART || DEBUG_SOCFPGA_UART || \
 		ARCH_KEYSTONE || \
 		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
-		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1
+		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1 || \
+		DEBUG_BRCMSTB_UART
 
 config DEBUG_UART_8250_FLOW_CONTROL
 	bool "Enable flow control for 8250 UART"
diff --git a/arch/arm/configs/brcmstb_defconfig b/arch/arm/configs/brcmstb_defconfig
new file mode 100644
index 0000000..1741d92
--- /dev/null
+++ b/arch/arm/configs/brcmstb_defconfig
@@ -0,0 +1,127 @@
+CONFIG_CROSS_COMPILE="arm-linux-"
+CONFIG_KERNEL_LZO=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_RELAY=y
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_EMBEDDED=y
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_FORCE_LOAD=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODVERSIONS=y
+# CONFIG_BLK_DEV_BSG is not set
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_BCM=y
+CONFIG_ARCH_BRCMSTB=y
+# CONFIG_SWP_EMULATE is not set
+CONFIG_SMP=y
+CONFIG_HAVE_ARM_ARCH_TIMER=y
+CONFIG_AEABI=y
+CONFIG_HIGHMEM=y
+CONFIG_CMA=y
+CONFIG_CMA_DEBUG=y
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_VFP=y
+CONFIG_NEON=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+CONFIG_PM_RUNTIME=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+CONFIG_IP_PNP_RARP=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_IPV6 is not set
+CONFIG_BRIDGE=y
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+CONFIG_MTD=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_CFI_STAA=y
+CONFIG_MTD_ROM=y
+CONFIG_MTD_ABSENT=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_MTD_M25P80=y
+CONFIG_MTD_NAND=y
+CONFIG_MTD_UBI=y
+CONFIG_MTD_UBI_GLUEBI=y
+CONFIG_PROC_DEVICETREE=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=8192
+CONFIG_BLK_DEV_SD=y
+CONFIG_BLK_DEV_SR=y
+CONFIG_CHR_DEV_SG=y
+CONFIG_ATA=y
+CONFIG_NETDEVICES=y
+CONFIG_USB_PEGASUS=y
+CONFIG_USB_USBNET=y
+# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
+CONFIG_INPUT_EVDEV=y
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+CONFIG_INPUT_MISC=y
+CONFIG_INPUT_UINPUT=y
+# CONFIG_SERIO is not set
+# CONFIG_CONSOLE_TRANSLATIONS is not set
+# CONFIG_VT_CONSOLE is not set
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_DW=y
+CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_HW_RANDOM=y
+CONFIG_SPI=y
+# CONFIG_HWMON is not set
+CONFIG_USB=y
+CONFIG_USB_MON=y
+CONFIG_USB_STORAGE=y
+CONFIG_MMC=y
+CONFIG_MMC_SDHCI=y
+CONFIG_MMC_SDHCI_PLTFM=y
+# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
+CONFIG_EXT4_FS=y
+CONFIG_JBD2_DEBUG=y
+# CONFIG_DNOTIFY is not set
+CONFIG_FUSE_FS=y
+CONFIG_ISO9660_FS=y
+CONFIG_JOLIET=y
+CONFIG_UDF_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_TMPFS=y
+CONFIG_JFFS2_FS=y
+CONFIG_UBIFS_FS=y
+CONFIG_SQUASHFS=y
+CONFIG_NFS_FS=y
+CONFIG_ROOT_NFS=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_DYNAMIC_DEBUG=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_DEBUG_FS=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_USER=y
+CONFIG_DEBUG_LL=y
+CONFIG_EARLY_PRINTK=y
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 9fe6d88..9179259 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -31,6 +31,24 @@ config ARCH_BCM_MOBILE
 	  BCM11130, BCM11140, BCM11351, BCM28145 and
 	  BCM28155 variants.
 
+config ARCH_BRCMSTB
+	bool "Broadcom BCM7XXX based boards" if ARCH_MULTI_V7
+	depends on MMU
+	select ARM_ARCH_TIMER
+	select ARM_GIC
+	select BRCMSTB
+	select MIGHT_HAVE_PCI
+	select HAVE_SMP
+	select USE_OF
+	select CPU_V7
+	select GENERIC_CLOCKEVENTS
+	help
+	  Say Y if you intend to run the kernel on a Broadcom ARM-based STB
+	  chipset.
+
+	  This enables support for Broadcom ARM-based set-top box chipsets,
+	  including the 7445 family of chips.
+
 endmenu
 
 endif
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index c2ccd5a..1e9060e 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -13,3 +13,5 @@
 obj-$(CONFIG_ARCH_BCM_MOBILE)	:= board_bcm281xx.o bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
+
+obj-$(CONFIG_ARCH_BRCMSTB) := brcmstb.o headsmp-brcmstb.o hotplug-brcmstb.o
diff --git a/arch/arm/mach-bcm/brcmstb.c b/arch/arm/mach-bcm/brcmstb.c
new file mode 100644
index 0000000..9e27fe0
--- /dev/null
+++ b/arch/arm/mach-bcm/brcmstb.c
@@ -0,0 +1,205 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/console.h>
+#include <linux/clocksource.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+#include <linux/smp.h>
+
+#include <asm/cacheflush.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/time.h>
+
+#include "brcmstb.h"
+
+struct platform_regs brcm_plat_regs;
+
+/***********************************************************************
+ * STB CPU (main application processor)
+ ***********************************************************************/
+
+static struct map_desc brcmstb_io_map[] __initdata = {
+	{
+	.virtual = (unsigned long)BRCMSTB_PERIPH_VIRT,
+	.pfn     = __phys_to_pfn(BRCMSTB_PERIPH_PHYS),
+	.length  = BRCMSTB_PERIPH_LENGTH,
+	.type    = MT_DEVICE,
+	},
+};
+
+static const char *brcmstb_match[] __initconst = {
+	"brcm,brcmstb",
+	NULL
+};
+
+static struct node_reg sun_top_ctrl_regs[] __initdata = {
+	{"reset-source-enable-reg", &brcm_plat_regs.reset_source_enable_reg},
+	{"sw-master-reset-reg", &brcm_plat_regs.sw_master_reset_reg},
+	{NULL, NULL}
+};
+
+static struct node_reg cpu_biu_ctrl_regs[] __initdata = {
+	{"cpu-reset-config-reg", &brcm_plat_regs.cpu_reset_config_reg},
+	{"cpu0-pwr-zone-ctrl-reg", &brcm_plat_regs.cpu0_pwr_zone_ctrl_reg},
+	{NULL, NULL}
+};
+
+static struct node_reg hif_continuation_regs[] __initdata = {
+	{"stb-boot-hi-addr0-reg", &brcm_plat_regs.hif_continuation_regs_base},
+	{NULL, NULL}
+};
+
+static struct node_reg_block top_reg_blocks[] __initdata = {
+	{"brcm,brcmstb-sun-top-ctrl", sun_top_ctrl_regs},
+	{"brcm,brcmstb-cpu-biu-ctrl", cpu_biu_ctrl_regs},
+	{"brcm,brcmstb-hif-continuation", hif_continuation_regs},
+	{NULL, NULL}
+};
+
+static void __init brcmstb_map_io(void)
+{
+	iotable_init(brcmstb_io_map, ARRAY_SIZE(brcmstb_io_map));
+}
+
+static void brcmstb_restart(enum reboot_mode mode, const char *cmd)
+{
+	writel_relaxed(1, brcm_plat_regs.reset_source_enable_reg);
+	readl_relaxed(brcm_plat_regs.reset_source_enable_reg);
+
+	writel_relaxed(1, brcm_plat_regs.sw_master_reset_reg);
+	readl_relaxed(brcm_plat_regs.sw_master_reset_reg);
+
+	while (1)
+		;
+}
+
+static void __init brcmstb_init_early(void)
+{
+	void __iomem *addr;
+	struct node_reg_block *block;
+
+	add_preferred_console("ttyS", 0, "115200");
+
+	addr = ioremap(BPHYSADDR(BCHP_IRQ0_IRQEN), sizeof(u32));
+	writel_relaxed(BCHP_IRQ0_IRQEN_uarta_irqen_MASK
+		| BCHP_IRQ0_IRQEN_uartb_irqen_MASK
+		| BCHP_IRQ0_IRQEN_uartc_irqen_MASK, addr);
+	iounmap(addr);
+
+	block = top_reg_blocks;
+	while (block->compatible) {
+		struct device_node *np;
+		struct node_reg *reg;
+
+		np = of_find_compatible_node(NULL, NULL, block->compatible);
+		if (!np)
+			panic("brcmstb: DT missing \"%s\" node\n",
+				block->compatible);
+
+		addr = of_iomap(np, 0);
+		if (!addr)
+			panic("brcmstb: iomap failure\n");
+
+		reg = block->regs;
+		while (reg->prop) {
+			u32 val;
+
+			if (!of_property_read_u32(np, reg->prop, &val))
+				*(reg->addr) = addr + val;
+			else
+				panic("brcmstb: node \"%s\" missing prop \"%s\"\n",
+					block->compatible, reg->prop);
+
+			reg++;
+		}
+
+		of_node_put(np);
+
+		block++;
+	}
+}
+
+static void __init brcmstb_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+/***********************************************************************
+ * SMP boot
+ ***********************************************************************/
+
+static DEFINE_SPINLOCK(boot_lock);
+
+static void __cpuinit brcmstb_secondary_init(unsigned int cpu)
+{
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+static int __cpuinit brcmstb_boot_secondary(unsigned int cpu,
+					    struct task_struct *idle)
+{
+	/*
+	 * set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+	spin_lock(&boot_lock);
+
+	/* Bring up power to the core if necessary */
+	if (brcmstb_cpu_get_power_state(cpu) == 0)
+		brcmstb_cpu_power_on(cpu);
+
+	brcmstb_cpu_boot(cpu);
+
+	/*
+	 * now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	spin_unlock(&boot_lock);
+
+	return 0;
+}
+
+struct smp_operations brcmstb_smp_ops __initdata = {
+	.smp_secondary_init	= brcmstb_secondary_init,
+	.smp_boot_secondary	= brcmstb_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_kill		= brcmstb_cpu_kill,
+	.cpu_die		= brcmstb_cpu_die,
+#endif
+};
+
+DT_MACHINE_START(BRCMSTB, "Broadcom STB (Flattened Device Tree)")
+	.map_io		= brcmstb_map_io,
+	.dt_compat	= brcmstb_match,
+	.restart	= brcmstb_restart,
+	.smp		= smp_ops(brcmstb_smp_ops),
+	.init_early	= brcmstb_init_early,
+	.init_machine	= brcmstb_init
+MACHINE_END
diff --git a/arch/arm/mach-bcm/brcmstb.h b/arch/arm/mach-bcm/brcmstb.h
new file mode 100644
index 0000000..d08dffc
--- /dev/null
+++ b/arch/arm/mach-bcm/brcmstb.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __BRCMSTB_H__
+#define __BRCMSTB_H__
+
+#if !defined(__ASSEMBLY__)
+#include <linux/smp.h>
+#endif
+
+#define BRCMSTB_PERIPH_VIRT				0xfc000000
+#define BRCMSTB_PERIPH_PHYS				0xf0000000
+#define BRCMSTB_PERIPH_LENGTH				0x02000000
+
+#define BVIRTADDR(x)	(BRCMSTB_PERIPH_VIRT + ((x) & 0x0fffffff))
+#define BPHYSADDR(x)	((x) + BRCMSTB_PERIPH_PHYS)
+
+#define BCHP_UARTA_REG_START				0x00406b00
+
+#define BCHP_IRQ0_IRQEN					0x00406780
+#define BCHP_IRQ0_IRQEN_uarta_irqen_MASK		0x00010000
+#define BCHP_IRQ0_IRQEN_uartb_irqen_MASK		0x00020000
+#define BCHP_IRQ0_IRQEN_uartc_irqen_MASK		0x00040000
+
+#if !defined(__ASSEMBLY__)
+
+extern void brcmstb_secondary_startup(void);
+extern void brcmstb_cpu_boot(unsigned int cpu);
+extern void brcmstb_cpu_power_on(unsigned int cpu);
+extern int brcmstb_cpu_get_power_state(unsigned int cpu);
+extern struct smp_operations brcmstb_smp_ops;
+
+#ifdef CONFIG_HOTPLUG_CPU
+extern void brcmstb_cpu_die(unsigned int cpu);
+extern int brcmstb_cpu_kill(unsigned int cpu);
+#endif
+
+struct node_reg {
+	const char *prop;
+	void __iomem **addr;
+};
+
+struct node_reg_block {
+	const char *compatible;
+	struct node_reg *regs;
+};
+
+struct platform_regs {
+	void __iomem *cpu_reset_config_reg;
+	void __iomem *cpu0_pwr_zone_ctrl_reg;
+	void __iomem *hif_continuation_regs_base;
+	void __iomem *reset_source_enable_reg;
+	void __iomem *sw_master_reset_reg;
+};
+
+extern struct platform_regs brcm_plat_regs;
+
+#endif
+
+#endif /* __BRCMSTB_H__ */
diff --git a/arch/arm/mach-bcm/headsmp-brcmstb.S b/arch/arm/mach-bcm/headsmp-brcmstb.S
new file mode 100644
index 0000000..cb86e4b
--- /dev/null
+++ b/arch/arm/mach-bcm/headsmp-brcmstb.S
@@ -0,0 +1,29 @@
+/*
+ * SMP boot code for secondary CPUs
+ * Based on arch/arm/mach-tegra/headsmp.S
+ *
+ * Copyright (C) 2010 NVIDIA, Inc.
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+        .section ".text.head", "ax"
+	__CPUINIT
+
+ENTRY(brcmstb_secondary_startup)
+        mov     r0, #0xd3
+        msr     cpsr_fsxc, r0
+        bl      v7_invalidate_l1
+        b       secondary_startup
+ENDPROC(brcmstb_secondary_startup)
diff --git a/arch/arm/mach-bcm/hotplug-brcmstb.c b/arch/arm/mach-bcm/hotplug-brcmstb.c
new file mode 100644
index 0000000..53ecc6d
--- /dev/null
+++ b/arch/arm/mach-bcm/hotplug-brcmstb.c
@@ -0,0 +1,203 @@
+/*
+ * Broadcom STB CPU hotplug support for ARM
+ *
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/printk.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+
+#include <asm/cacheflush.h>
+#include <asm/mach-types.h>
+
+#include "brcmstb.h"
+
+#define ZONE_PWR_DN_REQ_MASK		0x00000200
+#define ZONE_PWR_UP_REQ_MASK		0x00000400
+#define ZONE_BLK_RST_ASSERT_MASK	0x00001000
+#define ZONE_PWR_OFF_STATE_MASK		0x02000000
+#define ZONE_PWR_ON_STATE_MASK		0x04000000
+#define ZONE_RESET_STATE_MASK		0x80000000
+
+static void __iomem *pwr_zone_ctrl_get_base(unsigned int cpu)
+{
+	void __iomem *base = brcm_plat_regs.cpu0_pwr_zone_ctrl_reg;
+	base += (cpu * 4);
+	return base;
+}
+
+static u32 pwr_zone_ctrl_rd(unsigned int cpu)
+{
+	void __iomem *base = pwr_zone_ctrl_get_base(cpu);
+	return readl_relaxed(base);
+}
+
+static void pwr_zone_ctrl_wr(unsigned int cpu, u32 val)
+{
+	void __iomem *base = pwr_zone_ctrl_get_base(cpu);
+	writel_relaxed(val, base);
+	dsb();
+}
+
+void brcmstb_cpu_boot(unsigned int cpu)
+{
+	unsigned long boot_vector;
+	const int reg_ofs = cpu * 8;
+	u32 val;
+
+	pr_info("SMP: Booting CPU%d...\n", cpu);
+
+	/*
+	* set the reset vector to point to the secondary_startup
+	* routine
+	*/
+	boot_vector = virt_to_phys(brcmstb_secondary_startup);
+	writel_relaxed(0, brcm_plat_regs.hif_continuation_regs_base + reg_ofs);
+	writel_relaxed(boot_vector, brcm_plat_regs.hif_continuation_regs_base
+			+ 4 + reg_ofs);
+
+	flush_cache_all();
+
+	/* unhalt the cpu */
+	val = readl_relaxed(brcm_plat_regs.cpu_reset_config_reg);
+	val &= ~BIT(cpu);
+	writel_relaxed(val, brcm_plat_regs.cpu_reset_config_reg);
+}
+
+void brcmstb_cpu_power_on(unsigned int cpu)
+{
+	/*
+	 * The secondary cores power was cut, so we must go through
+	 * power-on initialization.
+	 */
+	u32 tmp;
+
+	pr_info("SMP: Powering up CPU%d...\n", cpu);
+
+	/* Request zone power up */
+	pwr_zone_ctrl_wr(cpu, ZONE_PWR_UP_REQ_MASK);
+
+	/* Wait for the power up FSM to complete */
+	do {
+		tmp = pwr_zone_ctrl_rd(cpu);
+	} while (!(tmp & ZONE_PWR_ON_STATE_MASK));
+}
+
+int brcmstb_cpu_get_power_state(unsigned int cpu)
+{
+	int tmp = pwr_zone_ctrl_rd(cpu);
+	return (tmp & ZONE_RESET_STATE_MASK) ? 0 : 1;
+}
+
+void __ref brcmstb_cpu_die(unsigned int cpu)
+{
+	/* Derived from misc_bpcm_arm.c */
+
+	/* Clear SCTLR.C bit */
+	__asm__(
+		"mrc	p15, 0, r0, c1, c0, 0\n"
+		"bic	r0, r0, #(1 << 2)\n"
+		"mcr	p15, 0, r0, c1, c0, 0\n"
+		: /* no output */
+		: /* no input */
+		: "r0"	/* clobber r0 */
+	);
+
+	/*
+	 * Instruction barrier to ensure cache is really disabled before
+	 * cleaning/invalidating the caches
+	 */
+	isb();
+
+	flush_cache_all();
+
+	/* Invalidate all instruction caches to PoU (ICIALLU) */
+	/* Data sync. barrier to ensure caches have emptied out */
+	__asm__("mcr	p15, 0, r0, c7, c5, 0\n" : : : "r0");
+	dsb();
+
+	/*
+	 * Clear ACTLR.SMP bit to prevent broadcast TLB messages from reaching
+	 * this core
+	 */
+	__asm__(
+		"mrc	p15, 0, r0, c1, c0, 1\n"
+		"bic	r0, r0, #(1 << 6)\n"
+		"mcr	p15, 0, r0, c1, c0, 1\n"
+		: /* no output */
+		: /* no input */
+		: "r0"	/* clobber r0 */
+	);
+
+	/* Disable all IRQs for this CPU */
+	arch_local_irq_disable();
+
+	/*
+	 * Final full barrier to ensure everything before this instruction has
+	 * quiesced.
+	 */
+	isb();
+	dsb();
+
+	/* Sit and wait to die */
+	wfi();
+
+	/* We should never get here... */
+	nop();
+	panic("Spurious interrupt on CPU %d received!\n", cpu);
+}
+
+static void busy_wait(int i)
+{
+	while (--i != 0)
+		nop();
+}
+
+int brcmstb_cpu_kill(unsigned int cpu)
+{
+	u32 tmp;
+	u32 val;
+
+	pr_info("SMP: Powering down CPU%d...\n", cpu);
+
+	/* Program zone reset */
+	pwr_zone_ctrl_wr(cpu, ZONE_RESET_STATE_MASK | ZONE_BLK_RST_ASSERT_MASK |
+			      ZONE_PWR_DN_REQ_MASK);
+
+	/* Verify zone reset */
+	tmp = pwr_zone_ctrl_rd(cpu);
+	if (!(tmp & ZONE_RESET_STATE_MASK))
+		pr_err("%s: Zone reset bit for CPU %d not asserted!\n",
+			__func__, cpu);
+
+	/* Wait for power down */
+	do {
+		tmp = pwr_zone_ctrl_rd(cpu);
+	} while (!(tmp & ZONE_PWR_OFF_STATE_MASK));
+
+	/* Magic delay from misc_bpcm_arm.c */
+	busy_wait(10000);
+
+	/* Assert reset on the CPU */
+	val = readl_relaxed(brcm_plat_regs.cpu_reset_config_reg);
+	val |= BIT(cpu);
+	writel_relaxed(val, brcm_plat_regs.cpu_reset_config_reg);
+
+	return 1;
+}
+
-- 
1.7.1

