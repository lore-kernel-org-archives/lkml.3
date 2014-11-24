Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaKXCle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:41:34 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58108 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKXClK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:41:10 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 11/11] MIPS: Add multiplatform BMIPS target
Date: Sun, 23 Nov 2014 18:40:46 -0800
Message-Id: <1416796846-28149-12-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bmips_be_defconfig supports Linux running on the following CM and DSL
SoCs:

 - BCM3384 (BMIPS5000) cable modem application processor, BE, SMP
 - BCM3384 (BMIPS4355) cable modem "spare CPU"*, BE
 - BCM6328 (BMIPS4355) ADSL chip, BE
 - BCM6368 (BMIPS4350) ADSL chip, BE, SMP

*experimental; most configurations will require changing CONFIG_PHYSICAL_START

bmips_stb_defconfig supports Linux running on the (nominally LE) STB
chipsets:

 - BCM7125 (BMIPS4380) set-top box chip, LE, SMP
 - BCM7346 (BMIPS5000) set-top box chip, LE, SMP
 - BCM7360 (BMIPS3300) set-top box chip, LE
 - BCM7420 (BMIPS5000) set-top box chip, LE, SMP
 - BCM7425 (BMIPS5000) set-top box chip, LE, SMP

serial8250 and bcm63xx_uart do not currently coexist.  If/when this is
fixed, it will be also possible to boot the BE image on any supported STB
board configured for BE.  For now, each defconfig can only pick one UART
driver, and the BE defconfig enables bcm63xx_uart.

On these MIPS systems, endianness cannot be reconfigured at runtime.  On
STB it is sometimes offered as a board jumper or 0-ohm resistor, and
sometimes hardwired to LE only.  The CM and DSL systems always run BE.

Device Tree is used to configure the following items:

 - UART, USB, GENET peripherals
 - IRQ controllers
 - Early console base address (bcm63xx_uart only)
 - SMP or UP mode
 - MIPS counter frequency
 - Memory size / regions
 - DMA remappings
 - Kernel command line

The DT-enabled bootloader and build instructions for 3384 are posted at
https://github.com/Broadcom/aeolus .  The other chips use legacy non-DT
bootloaders, so they will need to select an appropriate builtin DTB at
compile time until the bootloader is updated.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../devicetree/bindings/mips/brcm/bmips.txt        |   8 +
 .../devicetree/bindings/mips/brcm/soc.txt          |  12 ++
 arch/mips/Kbuild.platforms                         |   1 +
 arch/mips/Kconfig                                  |  36 ++++
 arch/mips/bmips/Kconfig                            |  50 ++++++
 arch/mips/bmips/Makefile                           |   1 +
 arch/mips/bmips/Platform                           |   7 +
 arch/mips/bmips/dma.c                              | 141 +++++++++++++++
 arch/mips/bmips/irq.c                              |  38 ++++
 arch/mips/bmips/setup.c                            | 195 +++++++++++++++++++++
 arch/mips/boot/dts/Makefile                        |   9 +
 arch/mips/boot/dts/bcm3384_viper.dtsi              | 108 ++++++++++++
 arch/mips/boot/dts/bcm3384_zephyr.dtsi             | 126 +++++++++++++
 arch/mips/boot/dts/bcm6328.dtsi                    |  87 +++++++++
 arch/mips/boot/dts/bcm6368.dtsi                    |  94 ++++++++++
 arch/mips/boot/dts/bcm7125.dtsi                    | 107 +++++++++++
 arch/mips/boot/dts/bcm7346.dtsi                    | 192 ++++++++++++++++++++
 arch/mips/boot/dts/bcm7360.dtsi                    | 129 ++++++++++++++
 arch/mips/boot/dts/bcm7420.dtsi                    | 151 ++++++++++++++++
 arch/mips/boot/dts/bcm7425.dtsi                    | 191 ++++++++++++++++++++
 arch/mips/boot/dts/bcm93384wvg.dts                 |  25 +++
 arch/mips/boot/dts/bcm93384wvg_viper.dts           |  25 +++
 arch/mips/boot/dts/bcm96368mvwg.dts                |  31 ++++
 arch/mips/boot/dts/bcm97125cbmb.dts                |  31 ++++
 arch/mips/boot/dts/bcm97346dbsmb.dts               |  58 ++++++
 arch/mips/boot/dts/bcm97360svmb.dts                |  34 ++++
 arch/mips/boot/dts/bcm97420c.dts                   |  45 +++++
 arch/mips/boot/dts/bcm97425svmb.dts                |  60 +++++++
 arch/mips/boot/dts/bcm9ejtagprb.dts                |  22 +++
 arch/mips/configs/bmips_be_defconfig               |  86 +++++++++
 arch/mips/configs/bmips_stb_defconfig              |  86 +++++++++
 arch/mips/include/asm/mach-bmips/dma-coherence.h   |  45 +++++
 arch/mips/include/asm/mach-bmips/spaces.h          |  17 ++
 arch/mips/include/asm/mach-bmips/war.h             |  24 +++
 34 files changed, 2272 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/bmips.txt
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/soc.txt
 create mode 100644 arch/mips/bmips/Kconfig
 create mode 100644 arch/mips/bmips/Makefile
 create mode 100644 arch/mips/bmips/Platform
 create mode 100644 arch/mips/bmips/dma.c
 create mode 100644 arch/mips/bmips/irq.c
 create mode 100644 arch/mips/bmips/setup.c
 create mode 100644 arch/mips/boot/dts/bcm3384_viper.dtsi
 create mode 100644 arch/mips/boot/dts/bcm3384_zephyr.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6328.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6368.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7125.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7346.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7360.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7420.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7425.dtsi
 create mode 100644 arch/mips/boot/dts/bcm93384wvg.dts
 create mode 100644 arch/mips/boot/dts/bcm93384wvg_viper.dts
 create mode 100644 arch/mips/boot/dts/bcm96368mvwg.dts
 create mode 100644 arch/mips/boot/dts/bcm97125cbmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97346dbsmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97360svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97420c.dts
 create mode 100644 arch/mips/boot/dts/bcm97425svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm9ejtagprb.dts
 create mode 100644 arch/mips/configs/bmips_be_defconfig
 create mode 100644 arch/mips/configs/bmips_stb_defconfig
 create mode 100644 arch/mips/include/asm/mach-bmips/dma-coherence.h
 create mode 100644 arch/mips/include/asm/mach-bmips/spaces.h
 create mode 100644 arch/mips/include/asm/mach-bmips/war.h

diff --git a/Documentation/devicetree/bindings/mips/brcm/bmips.txt b/Documentation/devicetree/bindings/mips/brcm/bmips.txt
new file mode 100644
index 000000000000..4a8cd8f4d41a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/brcm/bmips.txt
@@ -0,0 +1,8 @@
+* Broadcom MIPS (BMIPS) CPUs
+
+Required properties:
+- compatible: "brcm,bmips3300", "brcm,bmips4350", "brcm,bmips4380"
+              "brcm,bmips5000"
+
+- mips-hpt-frequency: This is common to all CPUs in the system so it lives
+  under the "cpus" node.
diff --git a/Documentation/devicetree/bindings/mips/brcm/soc.txt b/Documentation/devicetree/bindings/mips/brcm/soc.txt
new file mode 100644
index 000000000000..f011443eb9d3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/brcm/soc.txt
@@ -0,0 +1,12 @@
+* Broadcom cable/DSL/settop platforms
+
+Required properties:
+
+- compatible: "brcm,bcm3384", "brcm,bcm33843"
+              "brcm,bcm3384-viper", "brcm,bcm33843-viper"
+              "brcm,bcm6328", "brcm,bcm6368",
+              "brcm,bcm7125", "brcm,bcm7346", "brcm,bcm7360",
+              "brcm,bcm7420", "brcm,bcm7425"
+
+The experimental -viper variants are for running Linux on the 3384's
+BMIPS4355 cable modem CPU instead of the BMIPS5000 application processor.
diff --git a/arch/mips/Kbuild.platforms b/arch/mips/Kbuild.platforms
index 1780c74ed0da..a4d1e4f2ebb6 100644
--- a/arch/mips/Kbuild.platforms
+++ b/arch/mips/Kbuild.platforms
@@ -6,6 +6,7 @@ platforms += ath25
 platforms += ath79
 platforms += bcm47xx
 platforms += bcm63xx
+platforms += bmips
 platforms += cavium-octeon
 platforms += cobalt
 platforms += dec
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 9c09a5a43f87..36ac0e2f9d99 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -130,6 +130,41 @@ config ATH79
 	help
 	  Support for the Atheros AR71XX/AR724X/AR913X SoCs.
 
+config BMIPS_MULTIPLATFORM
+	bool "Broadcom BCM33xx/BCM63xx/BCM7xxx multiplatform kernel"
+	select BOOT_RAW
+	select NO_EXCEPT_FILL
+	select USE_OF
+	select CEVT_R4K
+	select CSRC_R4K
+	select SYNC_R4K
+	select COMMON_CLK
+	select BCM7038_L1_IRQ
+	select BCM7120_L2_IRQ
+	select BRCMSTB_L2_IRQ
+	select IRQ_CPU
+	select RAW_IRQ_ACCESSORS
+	select DMA_NONCOHERENT
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select SYS_SUPPORTS_BIG_ENDIAN
+	select SYS_SUPPORTS_HIGHMEM
+	select SYS_HAS_CPU_BMIPS3300
+	select SYS_HAS_CPU_BMIPS4350
+	select SYS_HAS_CPU_BMIPS4380
+	select SYS_HAS_CPU_BMIPS5000
+	select SWAP_IO_SPACE
+	select USB_EHCI_BIG_ENDIAN_DESC if CPU_BIG_ENDIAN
+	select USB_EHCI_BIG_ENDIAN_MMIO if CPU_BIG_ENDIAN
+	select USB_OHCI_BIG_ENDIAN_DESC if CPU_BIG_ENDIAN
+	select USB_OHCI_BIG_ENDIAN_MMIO if CPU_BIG_ENDIAN
+	help
+	  Build a multiplatform DT-based kernel image that boots on select
+	  BCM33xx cable modem chips, BCM63xx DSL chips, and BCM7xxx set-top
+	  box chips.  Note that CONFIG_CPU_BIG_ENDIAN/CONFIG_CPU_LITTLE_ENDIAN
+	  must be set appropriately for your board, and the dts/dtsi files may
+	  require changes based on the system endianness.
+
 config BCM47XX
 	bool "Broadcom BCM47XX based boards"
 	select ARCH_WANT_OPTIONAL_GPIOLIB
@@ -858,6 +893,7 @@ source "arch/mips/ath25/Kconfig"
 source "arch/mips/ath79/Kconfig"
 source "arch/mips/bcm47xx/Kconfig"
 source "arch/mips/bcm63xx/Kconfig"
+source "arch/mips/bmips/Kconfig"
 source "arch/mips/jazz/Kconfig"
 source "arch/mips/jz4740/Kconfig"
 source "arch/mips/lantiq/Kconfig"
diff --git a/arch/mips/bmips/Kconfig b/arch/mips/bmips/Kconfig
new file mode 100644
index 000000000000..dced2cdc3d85
--- /dev/null
+++ b/arch/mips/bmips/Kconfig
@@ -0,0 +1,50 @@
+choice
+	prompt "Built-in device tree"
+	help
+	  Legacy bootloaders do not pass a DTB pointer to the kernel, so
+	  if a "wrapper" is not being used, the kernel will need to include
+	  a device tree that matches the target board.
+
+	  The builtin DTB will only be used if the firmware does not supply
+	  a valid DTB.
+
+config DT_NONE
+	bool "None"
+
+config DT_BCM93384WVG
+	bool "BCM93384WVG Zephyr CPU"
+	select BUILTIN_DTB
+
+config DT_BCM93384WVG_VIPER
+	bool "BCM93384WVG Viper CPU (EXPERIMENTAL)"
+	select BUILTIN_DTB
+
+config DT_BCM96368MVWG
+	bool "BCM96368MVWG"
+	select BUILTIN_DTB
+
+config DT_BCM9EJTAGPRB
+	bool "BCM9EJTAGPRB"
+	select BUILTIN_DTB
+
+config DT_BCM97125CBMB
+	bool "BCM97125CBMB"
+	select BUILTIN_DTB
+
+config DT_BCM97346DBSMB
+	bool "BCM97346DBSMB"
+	select BUILTIN_DTB
+
+config DT_BCM97360SVMB
+	bool "BCM97360SVMB"
+	select BUILTIN_DTB
+
+config DT_BCM97420C
+	bool "BCM97420C"
+	select BUILTIN_DTB
+
+config DT_BCM97425SVMB
+	bool "BCM97425SVMB"
+	select BUILTIN_DTB
+
+endchoice
diff --git a/arch/mips/bmips/Makefile b/arch/mips/bmips/Makefile
new file mode 100644
index 000000000000..a393955cba08
--- /dev/null
+++ b/arch/mips/bmips/Makefile
@@ -0,0 +1 @@
+obj-y		+= setup.o irq.o dma.o
diff --git a/arch/mips/bmips/Platform b/arch/mips/bmips/Platform
new file mode 100644
index 000000000000..bb2716225f76
--- /dev/null
+++ b/arch/mips/bmips/Platform
@@ -0,0 +1,7 @@
+#
+# Broadcom BMIPS multiplatform kernel
+#
+platform-$(CONFIG_BMIPS_MULTIPLATFORM)	+= bmips/
+cflags-$(CONFIG_BMIPS_MULTIPLATFORM)	+=				\
+		-I$(srctree)/arch/mips/include/asm/mach-bmips/
+load-$(CONFIG_BMIPS_MULTIPLATFORM)	:= 0xffffffff80010000
diff --git a/arch/mips/bmips/dma.c b/arch/mips/bmips/dma.c
new file mode 100644
index 000000000000..9453c688dcfa
--- /dev/null
+++ b/arch/mips/bmips/dma.c
@@ -0,0 +1,141 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2014 Broadcom Corporation
+ * Author: Kevin Cernekee <cernekee@gmail.com>
+ */
+
+#define pr_fmt(fmt)		"bmips-dma: " fmt
+
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/of.h>
+#include <linux/pci.h>
+#include <linux/printk.h>
+#include <linux/types.h>
+#include <asm/bmips.h>
+#include <asm/cpu-type.h>
+#include <dma-coherence.h>
+
+/*
+ * BCM338x has configurable address translation windows which allow the
+ * peripherals' DMA addresses to be different from the Zephyr-visible
+ * physical addresses.  e.g. usb_dma_addr = zephyr_pa ^ 0x08000000
+ *
+ * If the "brcm,ubus" node has a "dma-ranges" property we will enable this
+ * translation globally using the provided information.  This implements a
+ * very limited subset of "dma-ranges" support and it will probably be
+ * replaced by a more generic version later.
+ */
+
+struct bmips_dma_range {
+	u32			child_addr;
+	u32			parent_addr;
+	u32			size;
+};
+
+static struct bmips_dma_range *bmips_dma_ranges;
+
+#define FLUSH_RAC		0x100
+
+static dma_addr_t bmips_phys_to_dma(struct device *dev, phys_addr_t pa)
+{
+	struct bmips_dma_range *r;
+
+	for (r = bmips_dma_ranges; r && r->size; r++) {
+		if (pa >= r->child_addr &&
+		    pa < (r->child_addr + r->size))
+			return pa - r->child_addr + r->parent_addr;
+	}
+	return pa;
+}
+
+dma_addr_t plat_map_dma_mem(struct device *dev, void *addr, size_t size)
+{
+	return bmips_phys_to_dma(dev, virt_to_phys(addr));
+}
+
+dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page)
+{
+	return bmips_phys_to_dma(dev, page_to_phys(page));
+}
+
+unsigned long plat_dma_addr_to_phys(struct device *dev, dma_addr_t dma_addr)
+{
+	struct bmips_dma_range *r;
+
+	for (r = bmips_dma_ranges; r && r->size; r++) {
+		if (dma_addr >= r->parent_addr &&
+		    dma_addr < (r->parent_addr + r->size))
+			return dma_addr - r->parent_addr + r->child_addr;
+	}
+	return dma_addr;
+}
+
+static int __init bmips_init_dma_ranges(void)
+{
+	struct device_node *np =
+		of_find_compatible_node(NULL, NULL, "brcm,ubus");
+	const __be32 *data;
+	struct bmips_dma_range *r;
+	int len;
+
+	if (!np)
+		return 0;
+
+	data = of_get_property(np, "dma-ranges", &len);
+	if (!data)
+		goto out_good;
+
+	len /= sizeof(*data) * 3;
+	if (!len)
+		goto out_bad;
+
+	/* add a dummy (zero) entry at the end as a sentinel */
+	bmips_dma_ranges = kzalloc(sizeof(struct bmips_dma_range) * (len + 1),
+				   GFP_KERNEL);
+	if (!bmips_dma_ranges)
+		goto out_bad;
+
+	for (r = bmips_dma_ranges; len; len--, r++) {
+		r->child_addr = be32_to_cpup(data++);
+		r->parent_addr = be32_to_cpup(data++);
+		r->size = be32_to_cpup(data++);
+	}
+
+out_good:
+	of_node_put(np);
+	return 0;
+
+out_bad:
+	pr_err("error parsing dma-ranges property\n");
+	of_node_put(np);
+	return -EINVAL;
+}
+arch_initcall(bmips_init_dma_ranges);
+
+void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction dir)
+{
+	if (dir == DMA_TO_DEVICE)
+		return;
+
+	switch (current_cpu_type()) {
+	case CPU_BMIPS3300:
+	case CPU_BMIPS4350:
+	case CPU_BMIPS4380: {
+		void __iomem *cbr = BMIPS_GET_CBR();
+
+		/* Flush stale data out of the readahead cache */
+		__raw_writel(FLUSH_RAC, cbr + BMIPS_RAC_CONFIG);
+		__raw_readl(cbr + BMIPS_RAC_CONFIG);
+		break;
+	}
+	}
+}
diff --git a/arch/mips/bmips/irq.c b/arch/mips/bmips/irq.c
new file mode 100644
index 000000000000..14552e58ff7e
--- /dev/null
+++ b/arch/mips/bmips/irq.c
@@ -0,0 +1,38 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * Copyright (C) 2014 Broadcom Corporation
+ * Author: Kevin Cernekee <cernekee@gmail.com>
+ */
+
+#include <linux/of.h>
+#include <linux/irqchip.h>
+
+#include <asm/bmips.h>
+#include <asm/irq.h>
+#include <asm/irq_cpu.h>
+#include <asm/time.h>
+
+unsigned int get_c0_compare_int(void)
+{
+	return CP0_LEGACY_COMPARE_IRQ;
+}
+
+void __init arch_init_irq(void)
+{
+	struct device_node *dn;
+
+	/* Only the STB (bcm7038) controller supports SMP IRQ affinity */
+	dn = of_find_compatible_node(NULL, NULL, "brcm,bcm7038-l1-intc");
+	if (dn)
+		of_node_put(dn);
+	else
+		bmips_tp1_irqs = 0;
+
+	irqchip_init();
+}
+
+OF_DECLARE_2(irqchip, mips_cpu_intc, "mti,cpu-interrupt-controller",
+	     mips_cpu_irq_of_init);
diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
new file mode 100644
index 000000000000..f1474f682b22
--- /dev/null
+++ b/arch/mips/bmips/setup.c
@@ -0,0 +1,195 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2014 Broadcom Corporation
+ * Author: Kevin Cernekee <cernekee@gmail.com>
+ */
+
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/bootmem.h>
+#include <linux/clk-provider.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
+#include <linux/smp.h>
+#include <asm/addrspace.h>
+#include <asm/bmips.h>
+#include <asm/bootinfo.h>
+#include <asm/cpu-type.h>
+#include <asm/mipsregs.h>
+#include <asm/prom.h>
+#include <asm/smp-ops.h>
+#include <asm/time.h>
+#include <asm/traps.h>
+#include <asm/fw/cfe/cfe_api.h>
+
+#define RELO_NORMAL_VEC		BIT(18)
+
+#define REG_BCM6328_OTP		((void __iomem *)CKSEG1ADDR(0x1000062c))
+#define BCM6328_TP1_DISABLED	BIT(9)
+
+static const unsigned long kbase = VMLINUX_LOAD_ADDRESS & 0xfff00000;
+
+struct bmips_quirk {
+	const char		*compatible;
+	void			(*quirk_fn)(void);
+};
+
+static void kbase_setup(void)
+{
+	__raw_writel(kbase | RELO_NORMAL_VEC,
+		     BMIPS_GET_CBR() + BMIPS_RELO_VECTOR_CONTROL_1);
+	ebase = kbase;
+}
+
+static void bcm3384_viper_quirks(void)
+{
+	/*
+	 * Some experimental CM boxes are set up to let CM own the Viper TP0
+	 * and let Linux own TP1.  This requires moving the kernel
+	 * load address to a non-conflicting region (e.g. via
+	 * CONFIG_PHYSICAL_START) and supplying an alternate DTB.
+	 * If we detect this condition, we need to move the MIPS exception
+	 * vectors up to an area that we own.
+	 *
+	 * This is distinct from the OTHER special case mentioned in
+	 * smp-bmips.c (boot on TP1, but enable SMP, then TP0 becomes our
+	 * logical CPU#1).  For the Viper TP1 case, SMP is off limits.
+	 *
+	 * Also note that many BMIPS435x CPUs do not have a
+	 * BMIPS_RELO_VECTOR_CONTROL_1 register, so it isn't safe to just
+	 * write VMLINUX_LOAD_ADDRESS into that register on every SoC.
+	 */
+	board_ebase_setup = &kbase_setup;
+	bmips_smp_enabled = 0;
+}
+
+static void bcm63xx_fixup_cpu1(void)
+{
+	/*
+	 * The bootloader has set up the CPU1 reset vector at
+	 * 0xa000_0200.
+	 * This conflicts with the special interrupt vector (IV).
+	 * The bootloader has also set up CPU1 to respond to the wrong
+	 * IPI interrupt.
+	 * Here we will start up CPU1 in the background and ask it to
+	 * reconfigure itself then go back to sleep.
+	 */
+	memcpy((void *)0xa0000200, &bmips_smp_movevec, 0x20);
+	__sync();
+	set_c0_cause(C_SW0);
+	cpumask_set_cpu(1, &bmips_booted_mask);
+}
+
+static void bcm6328_quirks(void)
+{
+	/* Check CPU1 status in OTP (it is usually disabled) */
+	if (__raw_readl(REG_BCM6328_OTP) & BCM6328_TP1_DISABLED)
+		bmips_smp_enabled = 0;
+	else
+		bcm63xx_fixup_cpu1();
+}
+
+static void bcm6368_quirks(void)
+{
+	bcm63xx_fixup_cpu1();
+}
+
+static const struct bmips_quirk bmips_quirk_list[] = {
+	{ "brcm,bcm3384-viper",		&bcm3384_viper_quirks		},
+	{ "brcm,bcm33843-viper",	&bcm3384_viper_quirks		},
+	{ "brcm,bcm6328",		&bcm6328_quirks			},
+	{ "brcm,bcm6368",		&bcm6368_quirks			},
+	{ },
+};
+
+void __init prom_init(void)
+{
+	register_bmips_smp_ops();
+}
+
+void __init prom_free_prom_memory(void)
+{
+}
+
+void __init plat_mem_setup(void)
+{
+	void *dtb;
+	const struct bmips_quirk *q;
+
+	set_io_port_base(0);
+	ioport_resource.start = 0;
+	ioport_resource.end = ~0;
+
+	/* Intended to somewhat resemble ARM; see Documentation/arm/Booting */
+	if (fw_arg0 == 0 && fw_arg1 == 0xffffffff)
+		dtb = phys_to_virt(fw_arg2);
+	else if (__dtb_start != __dtb_end)
+		dtb = (void *)__dtb_start;
+	else
+		panic("no dtb found");
+
+	__dt_setup_arch(dtb);
+	strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
+
+	for (q = bmips_quirk_list; q->quirk_fn; q++) {
+		if (of_flat_dt_is_compatible(of_get_flat_dt_root(),
+					     q->compatible)) {
+			q->quirk_fn();
+		}
+	}
+}
+
+void __init device_tree_init(void)
+{
+	struct device_node *np;
+
+	unflatten_and_copy_device_tree();
+
+	/* Disable SMP boot unless both CPUs are listed in DT and !disabled */
+	np = of_find_node_by_name(NULL, "cpus");
+	if (np && of_get_available_child_count(np) <= 1)
+		bmips_smp_enabled = 0;
+	of_node_put(np);
+}
+
+void __init plat_time_init(void)
+{
+	struct device_node *np;
+	u32 freq;
+
+	np = of_find_node_by_name(NULL, "cpus");
+	if (!np)
+		panic("missing 'cpus' DT node");
+	if (of_property_read_u32(np, "mips-hpt-frequency", &freq) < 0)
+		panic("missing 'mips-hpt-frequency' property");
+	of_node_put(np);
+
+	mips_hpt_frequency = freq;
+}
+
+int __init plat_of_setup(void)
+{
+	return __dt_register_buses("simple-bus", NULL);
+}
+
+arch_initcall(plat_of_setup);
+
+static int __init plat_dev_init(void)
+{
+	of_clk_init(NULL);
+	return 0;
+}
+
+device_initcall(plat_dev_init);
+
+const char *get_system_type(void)
+{
+	return "BMIPS multiplatform kernel";
+}
diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
index ca9c90e2cabf..153d04489c46 100644
--- a/arch/mips/boot/dts/Makefile
+++ b/arch/mips/boot/dts/Makefile
@@ -1,4 +1,13 @@
 dtb-$(CONFIG_CAVIUM_OCTEON_SOC)		+= octeon_3xxx.dtb octeon_68xx.dtb
+dtb-$(CONFIG_DT_BCM93384WVG)		+= bcm93384wvg.dtb
+dtb-$(CONFIG_DT_BCM93384WVG_VIPER)	+= bcm93384wvg_viper.dtb
+dtb-$(CONFIG_DT_BCM96368MVWG)		+= bcm96368mvwg.dtb
+dtb-$(CONFIG_DT_BCM9EJTAGPRB)		+= bcm9ejtagprb.dtb
+dtb-$(CONFIG_DT_BCM97125CBMB)		+= bcm97125cbmb.dtb
+dtb-$(CONFIG_DT_BCM97346DBSMB)		+= bcm97346dbsmb.dtb
+dtb-$(CONFIG_DT_BCM97360SVMB)		+= bcm97360svmb.dtb
+dtb-$(CONFIG_DT_BCM97420C)		+= bcm97420c.dtb
+dtb-$(CONFIG_DT_BCM97425SVMB)		+= bcm97425svmb.dtb
 dtb-$(CONFIG_DT_EASY50712)		+= easy50712.dtb
 dtb-$(CONFIG_DT_XLP_EVP)		+= xlp_evp.dtb
 dtb-$(CONFIG_DT_XLP_SVP)		+= xlp_svp.dtb
diff --git a/arch/mips/boot/dts/bcm3384_viper.dtsi b/arch/mips/boot/dts/bcm3384_viper.dtsi
new file mode 100644
index 000000000000..8f803de68ac7
--- /dev/null
+++ b/arch/mips/boot/dts/bcm3384_viper.dtsi
@@ -0,0 +1,108 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm3384-viper", "brcm,bcm33843-viper";
+
+	memory@0 {
+		device_type = "memory";
+
+		/* Typical ranges.  The bootloader should fill these in. */
+		reg = <0x06000000 0x02000000>,
+		      <0x0e000000 0x02000000>;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* 1/2 of the CPU core clock (standard MIPS behavior) */
+		mips-hpt-frequency = <300000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <0>;
+		};
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <54000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "brcm,ubus", "simple-bus";
+		ranges;
+		/* No dma-ranges on Viper. */
+
+		periph_intc: periph_intc@14e00048 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x14e00048 0x8>, <0x14e00350 0x8>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <4>;
+			brcm,int-map-mask = <0xffffffff>, <0xffffffff>;
+		};
+
+		cmips_intc: cmips_intc@151f8048 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x151f8048 0x8>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <30>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		uart0: serial@14e00520 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x14e00520 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <2>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@15400300 {
+			compatible = "brcm,bcm3384-ehci", "generic-ehci";
+			reg = <0x15400300 0x100>;
+			big-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <41>;
+			status = "disabled";
+		};
+
+		ohci0: usb@15400400 {
+			compatible = "brcm,bcm3384-ohci", "generic-ohci";
+			reg = <0x15400400 0x100>;
+			big-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <40>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm3384_zephyr.dtsi b/arch/mips/boot/dts/bcm3384_zephyr.dtsi
new file mode 100644
index 000000000000..37f46f41e527
--- /dev/null
+++ b/arch/mips/boot/dts/bcm3384_zephyr.dtsi
@@ -0,0 +1,126 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm3384", "brcm,bcm33843";
+
+	memory@0 {
+		device_type = "memory";
+
+		/* Typical range.  The bootloader should fill this in. */
+		reg = <0x0 0x08000000>;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* On BMIPS5000 this is 1/8th of the CPU core clock */
+		mips-hpt-frequency = <100000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <54000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "brcm,ubus", "simple-bus";
+		ranges;
+		dma-ranges = <0x00000000 0x08000000 0x08000000>,
+			     <0x08000000 0x00000000 0x08000000>;
+
+		periph_intc: periph_intc@14e00038 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x14e00038 0x8>, <0x14e00340 0x8>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <4>;
+			brcm,int-map-mask = <0xffffffff>, <0xffffffff>;
+		};
+
+		zmips_intc: zmips_intc@104b0060 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x104b0060 0x8>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <29>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		iop_intc: iop_intc@14e00058 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x14e00058 0x8>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <6>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		uart0: serial@14e00520 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x14e00520 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <2>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@15400300 {
+			compatible = "brcm,bcm3384-ehci", "generic-ehci";
+			reg = <0x15400300 0x100>;
+			big-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <41>;
+			status = "disabled";
+		};
+
+		ohci0: usb@15400400 {
+			compatible = "brcm,bcm3384-ohci", "generic-ohci";
+			reg = <0x15400400 0x100>;
+			big-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <40>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm6328.dtsi b/arch/mips/boot/dts/bcm6328.dtsi
new file mode 100644
index 000000000000..648e8594145c
--- /dev/null
+++ b/arch/mips/boot/dts/bcm6328.dtsi
@@ -0,0 +1,87 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6328";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <160000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <50000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges;
+
+		periph_intc: periph_intc@10000020 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x10000024 0x4 0x1000002c 0x4>,
+			      <0x10000020 0x4 0x10000028 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>;
+			brcm,int-map-mask = <0xffffffff>, <0xffffffff>;
+		};
+
+		uart0: serial@10000100 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x10000100 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <28>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		timer: timer@10000040 {
+			compatible = "syscon";
+			reg = <0x10000040 0x2c>;
+			little-endian;
+		};
+
+		reboot {
+			compatible = "syscon-reboot";
+			regmap = <&timer>;
+			offset = <0x28>;
+			mask = <0x1>;
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm6368.dtsi b/arch/mips/boot/dts/bcm6368.dtsi
new file mode 100644
index 000000000000..dd11853a6ecb
--- /dev/null
+++ b/arch/mips/boot/dts/bcm6368.dtsi
@@ -0,0 +1,94 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm6368";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <200000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips4350";
+			device_type = "cpu";
+			reg = <1>;
+		};
+
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <50000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges;
+
+		periph_intc: periph_intc@10000020 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x10000024 0x4 0x1000002c 0x4>,
+			      <0x10000020 0x4 0x10000028 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>;
+			brcm,int-map-mask = <0xffffffff>, <0xffffffff>;
+		};
+
+		uart0: serial@10000100 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x10000100 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <2>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@10001500 {
+			compatible = "brcm,bcm6368-ehci", "generic-ehci";
+			reg = <0x10001500 0x100>;
+			big-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <7>;
+			status = "disabled";
+		};
+
+		ohci0: usb@10001600 {
+			compatible = "brcm,bcm6368-ohci", "generic-ohci";
+			reg = <0x10001600 0x100>;
+			big-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <5>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7125.dtsi b/arch/mips/boot/dts/bcm7125.dtsi
new file mode 100644
index 000000000000..292ef0cf29ef
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7125.dtsi
@@ -0,0 +1,107 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7125";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <202500000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips4380";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips4380";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@441400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x441400 0x30>, <0x441600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <18>;
+		};
+
+		uart0: serial@406b00 {
+			compatible = "ns16550a";
+			reg = <0x406b00 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <21>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@488300 {
+			compatible = "brcm,bcm7125-ehci", "generic-ehci";
+			reg = <0x488300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <60>;
+			status = "disabled";
+		};
+
+		ohci0: usb@488400 {
+			compatible = "brcm,bcm7125-ohci", "generic-ohci";
+			reg = <0x488400 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7346.dtsi b/arch/mips/boot/dts/bcm7346.dtsi
new file mode 100644
index 000000000000..ba2a91a4b111
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7346.dtsi
@@ -0,0 +1,192 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7346";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <163125000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@411400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x411400 0x30>, <0x411600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <59>;
+		};
+
+		uart0: serial@406900 {
+			compatible = "ns16550a";
+			reg = <0x406900 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <64>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@430000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v2";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0x430000 0x4c8c>;
+			interrupts = <24>, <25>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v2";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,40nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@480300 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x480300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <68>;
+			status = "disabled";
+		};
+
+		ohci0: usb@480400 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x480400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <70>;
+			status = "disabled";
+		};
+
+		ehci1: usb@480500 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x480500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <69>;
+			status = "disabled";
+		};
+
+		ohci1: usb@480600 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x480600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <71>;
+			status = "disabled";
+		};
+
+		ehci2: usb@490300 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x490300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <73>;
+			status = "disabled";
+		};
+
+		ohci2: usb@490400 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x490400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <75>;
+			status = "disabled";
+		};
+
+		ehci3: usb@490500 {
+			compatible = "brcm,bcm7346-ehci", "generic-ehci";
+			reg = <0x490500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <74>;
+			status = "disabled";
+		};
+
+		ohci3: usb@490600 {
+			compatible = "brcm,bcm7346-ohci", "generic-ohci";
+			reg = <0x490600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <76>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7360.dtsi b/arch/mips/boot/dts/bcm7360.dtsi
new file mode 100644
index 000000000000..33fa02df0767
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7360.dtsi
@@ -0,0 +1,129 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7360";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <375000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips3300";
+			device_type = "cpu";
+			reg = <0>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@411400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x411400 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>;
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406600 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406600 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <56>;
+		};
+
+		uart0: serial@406800 {
+			compatible = "ns16550a";
+			reg = <0x406800 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@430000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v2";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0x430000 0x4c8c>;
+			interrupts = <24>, <25>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v2";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,40nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@480300 {
+			compatible = "brcm,bcm7360-ehci", "generic-ehci";
+			reg = <0x480300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <65>;
+			status = "disabled";
+		};
+
+		ohci0: usb@480400 {
+			compatible = "brcm,bcm7360-ohci", "generic-ohci";
+			reg = <0x480400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <66>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7420.dtsi b/arch/mips/boot/dts/bcm7420.dtsi
new file mode 100644
index 000000000000..e100da00f93b
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7420.dtsi
@@ -0,0 +1,151 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7420";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <93750000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@441400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x441400 0x30>, <0x441600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <18>;
+		};
+
+		uart0: serial@406b00 {
+			compatible = "ns16550a";
+			reg = <0x406b00 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <21>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@468000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v1";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0x468000 0x3c8c>;
+			interrupts = <69>, <79>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v1";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,65nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@488300 {
+			compatible = "brcm,bcm7420-ehci", "generic-ehci";
+			reg = <0x488300 0x100>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <60>;
+			status = "disabled";
+		};
+
+		ohci0: usb@488400 {
+			compatible = "brcm,bcm7420-ohci", "generic-ohci";
+			reg = <0x488400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			status = "disabled";
+		};
+
+		ehci1: usb@488500 {
+			compatible = "brcm,bcm7420-ehci", "generic-ehci";
+			reg = <0x488500 0x100>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <55>;
+			status = "disabled";
+		};
+
+		ohci1: usb@488600 {
+			compatible = "brcm,bcm7420-ohci", "generic-ohci";
+			reg = <0x488600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <62>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm7425.dtsi b/arch/mips/boot/dts/bcm7425.dtsi
new file mode 100644
index 000000000000..6ea448a13879
--- /dev/null
+++ b/arch/mips/boot/dts/bcm7425.dtsi
@@ -0,0 +1,191 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm7425";
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		mips-hpt-frequency = <163125000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		uart_clk: uart_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <81000000>;
+		};
+	};
+
+	rdb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "simple-bus";
+		ranges = <0 0x10000000 0x01000000>;
+
+		periph_intc: periph_intc@41a400 {
+			compatible = "brcm,bcm7038-l1-intc";
+			reg = <0x41a400 0x30>, <0x41a600 0x30>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <2>, <3>;
+		};
+
+		upg_irq0_intc: upg_irq0_intc@406780 {
+			compatible = "brcm,bcm7120-l2-intc";
+			reg = <0x406780 0x8>;
+
+			brcm,int-map-mask = <0x44>;
+			brcm,int-fwd-mask = <0x70000>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <55>;
+		};
+
+		uart0: serial@406b00 {
+			compatible = "ns16550a";
+			reg = <0x406b00 0x20>;
+			reg-io-width = <0x4>;
+			reg-shift = <0x2>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <61>;
+			clocks = <&uart_clk>;
+			status = "disabled";
+		};
+
+		enet0: ethernet@b80000 {
+			phy-mode = "internal";
+			phy-handle = <&phy1>;
+			mac-address = [ 00 10 18 36 23 1a ];
+			compatible = "brcm,genet-v3";
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+			reg = <0xb80000 0x11c88>;
+			interrupts = <17>, <18>;
+			interrupt-parent = <&periph_intc>;
+			status = "disabled";
+
+			mdio@e14 {
+				compatible = "brcm,genet-mdio-v3";
+				#address-cells = <0x1>;
+				#size-cells = <0x0>;
+				reg = <0xe14 0x8>;
+
+				phy1: ethernet-phy@1 {
+					max-speed = <100>;
+					reg = <0x1>;
+					compatible = "brcm,40nm-ephy",
+						"ethernet-phy-ieee802.3-c22";
+				};
+			};
+		};
+
+		ehci0: usb@480300 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x480300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <65>;
+			status = "disabled";
+		};
+
+		ohci0: usb@480400 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x480400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <67>;
+			status = "disabled";
+		};
+
+		ehci1: usb@480500 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x480500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <66>;
+			status = "disabled";
+		};
+
+		ohci1: usb@480600 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x480600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <68>;
+			status = "disabled";
+		};
+
+		ehci2: usb@490300 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x490300 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <70>;
+			status = "disabled";
+		};
+
+		ohci2: usb@490400 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x490400 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <72>;
+			status = "disabled";
+		};
+
+		ehci3: usb@490500 {
+			compatible = "brcm,bcm7425-ehci", "generic-ehci";
+			reg = <0x490500 0x100>;
+			native-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <71>;
+			status = "disabled";
+		};
+
+		ohci3: usb@490600 {
+			compatible = "brcm,bcm7425-ohci", "generic-ohci";
+			reg = <0x490600 0x100>;
+			native-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <73>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/bcm93384wvg.dts b/arch/mips/boot/dts/bcm93384wvg.dts
new file mode 100644
index 000000000000..d1e44a17d41a
--- /dev/null
+++ b/arch/mips/boot/dts/bcm93384wvg.dts
@@ -0,0 +1,25 @@
+/dts-v1/;
+
+/include/ "bcm3384_zephyr.dtsi"
+
+/ {
+	compatible = "brcm,bcm93384wvg", "brcm,bcm3384";
+	model = "Broadcom BCM93384WVG";
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm93384wvg_viper.dts b/arch/mips/boot/dts/bcm93384wvg_viper.dts
new file mode 100644
index 000000000000..1ecb2696aca8
--- /dev/null
+++ b/arch/mips/boot/dts/bcm93384wvg_viper.dts
@@ -0,0 +1,25 @@
+/dts-v1/;
+
+/include/ "bcm3384_viper.dtsi"
+
+/ {
+	compatible = "brcm,bcm93384wvg-viper", "brcm,bcm3384-viper";
+	model = "Broadcom BCM93384WVG-viper";
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm96368mvwg.dts b/arch/mips/boot/dts/bcm96368mvwg.dts
new file mode 100644
index 000000000000..0e890c28fe5c
--- /dev/null
+++ b/arch/mips/boot/dts/bcm96368mvwg.dts
@@ -0,0 +1,31 @@
+/dts-v1/;
+
+/include/ "bcm6368.dtsi"
+
+/ {
+	compatible = "brcm,bcm96368mvwg", "brcm,bcm6368";
+	model = "Broadcom BCM96368MVWG";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x04000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+/* FIXME: need to set up USB_CTRL registers first */
+&ehci0 {
+	status = "disabled";
+};
+
+&ohci0 {
+	status = "disabled";
+};
diff --git a/arch/mips/boot/dts/bcm97125cbmb.dts b/arch/mips/boot/dts/bcm97125cbmb.dts
new file mode 100644
index 000000000000..e046b1109eab
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97125cbmb.dts
@@ -0,0 +1,31 @@
+/dts-v1/;
+
+/include/ "bcm7125.dtsi"
+
+/ {
+	compatible = "brcm,bcm97125cbmb", "brcm,bcm7125";
+	model = "Broadcom BCM97125CBMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+/* FIXME: USB is wonky; disable it for now */
+&ehci0 {
+	status = "disabled";
+};
+
+&ohci0 {
+	status = "disabled";
+};
diff --git a/arch/mips/boot/dts/bcm97346dbsmb.dts b/arch/mips/boot/dts/bcm97346dbsmb.dts
new file mode 100644
index 000000000000..70f196d89d26
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97346dbsmb.dts
@@ -0,0 +1,58 @@
+/dts-v1/;
+
+/include/ "bcm7346.dtsi"
+
+/ {
+	compatible = "brcm,bcm97346dbsmb", "brcm,bcm7346";
+	model = "Broadcom BCM97346DBSMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>, <0x20000000 0x30000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&enet0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
+
+&ehci1 {
+	status = "okay";
+};
+
+&ohci1 {
+	status = "okay";
+};
+
+&ehci2 {
+	status = "okay";
+};
+
+&ohci2 {
+	status = "okay";
+};
+
+&ehci3 {
+	status = "okay";
+};
+
+&ohci3 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm97360svmb.dts b/arch/mips/boot/dts/bcm97360svmb.dts
new file mode 100644
index 000000000000..4fe515500102
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97360svmb.dts
@@ -0,0 +1,34 @@
+/dts-v1/;
+
+/include/ "bcm7360.dtsi"
+
+/ {
+	compatible = "brcm,bcm97360svmb", "brcm,bcm7360";
+	model = "Broadcom BCM97360SVMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&enet0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm97420c.dts b/arch/mips/boot/dts/bcm97420c.dts
new file mode 100644
index 000000000000..67fe1f3a3891
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97420c.dts
@@ -0,0 +1,45 @@
+/dts-v1/;
+
+/include/ "bcm7420.dtsi"
+
+/ {
+	compatible = "brcm,bcm97420c", "brcm,bcm7420";
+	model = "Broadcom BCM97420C";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>,
+		      <0x20000000 0x30000000>,
+		      <0x60000000 0x10000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+/* FIXME: MAC driver comes up but cannot attach to PHY */
+&enet0 {
+	status = "disabled";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
+
+&ehci1 {
+	status = "okay";
+};
+
+&ohci1 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm97425svmb.dts b/arch/mips/boot/dts/bcm97425svmb.dts
new file mode 100644
index 000000000000..689c68a4f9c8
--- /dev/null
+++ b/arch/mips/boot/dts/bcm97425svmb.dts
@@ -0,0 +1,60 @@
+/dts-v1/;
+
+/include/ "bcm7425.dtsi"
+
+/ {
+	compatible = "brcm,bcm97425svmb", "brcm,bcm7425";
+	model = "Broadcom BCM97425SVMB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>,
+		      <0x20000000 0x30000000>,
+		      <0x90000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&enet0 {
+	status = "okay";
+};
+
+&ehci0 {
+	status = "okay";
+};
+
+&ohci0 {
+	status = "okay";
+};
+
+&ehci1 {
+	status = "okay";
+};
+
+&ohci1 {
+	status = "okay";
+};
+
+&ehci2 {
+	status = "okay";
+};
+
+&ohci2 {
+	status = "okay";
+};
+
+&ehci3 {
+	status = "okay";
+};
+
+&ohci3 {
+	status = "okay";
+};
diff --git a/arch/mips/boot/dts/bcm9ejtagprb.dts b/arch/mips/boot/dts/bcm9ejtagprb.dts
new file mode 100644
index 000000000000..1da4608680aa
--- /dev/null
+++ b/arch/mips/boot/dts/bcm9ejtagprb.dts
@@ -0,0 +1,22 @@
+/dts-v1/;
+
+/include/ "bcm6328.dtsi"
+
+/ {
+	compatible = "brcm,bcm9ejtagprb", "brcm,bcm6328";
+	model = "Broadcom BCM9EJTAGPRB";
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x08000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200";
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
diff --git a/arch/mips/configs/bmips_be_defconfig b/arch/mips/configs/bmips_be_defconfig
new file mode 100644
index 000000000000..7ab31664dcb1
--- /dev/null
+++ b/arch/mips/configs/bmips_be_defconfig
@@ -0,0 +1,86 @@
+CONFIG_BMIPS_MULTIPLATFORM=y
+CONFIG_HIGHMEM=y
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+# CONFIG_SECCOMP is not set
+CONFIG_MIPS_O32_FP64_SUPPORT=y
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_NO_HZ=y
+CONFIG_BLK_DEV_INITRD=y
+# CONFIG_RD_GZIP is not set
+CONFIG_EXPERT=y
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+# CONFIG_IOSCHED_CFQ is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_PACKET_DIAG=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+CONFIG_CFG80211=y
+CONFIG_NL80211_TESTMODE=y
+CONFIG_MAC80211=y
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_STANDALONE is not set
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+CONFIG_MTD=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP=y
+# CONFIG_BLK_DEV is not set
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+# CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_NETDEVICES=y
+CONFIG_BCMGENET=y
+CONFIG_USB_USBNET=y
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_PXA=y
+CONFIG_SERIAL_PXA_CONSOLE=y
+CONFIG_SERIAL_BCM63XX=y
+CONFIG_SERIAL_BCM63XX_CONSOLE=y
+# CONFIG_SERIAL_BCM63XX_TTYS is not set
+# CONFIG_HW_RANDOM is not set
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_SYSCON=y
+# CONFIG_HWMON is not set
+CONFIG_USB=y
+CONFIG_USB_EHCI_HCD=y
+# CONFIG_USB_EHCI_TT_NEWSCHED is not set
+CONFIG_USB_EHCI_HCD_PLATFORM=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_OHCI_HCD_PLATFORM=y
+CONFIG_USB_STORAGE=y
+CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
+# CONFIG_DNOTIFY is not set
+CONFIG_FUSE_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_TMPFS=y
+CONFIG_NFS_FS=y
+CONFIG_CIFS=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ASCII=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_DEBUG_FS=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_CMDLINE_BOOL=y
+CONFIG_CMDLINE="earlycon"
+# CONFIG_CRYPTO_HW is not set
diff --git a/arch/mips/configs/bmips_stb_defconfig b/arch/mips/configs/bmips_stb_defconfig
new file mode 100644
index 000000000000..c119d678f362
--- /dev/null
+++ b/arch/mips/configs/bmips_stb_defconfig
@@ -0,0 +1,86 @@
+CONFIG_BMIPS_MULTIPLATFORM=y
+CONFIG_CPU_LITTLE_ENDIAN=y
+CONFIG_HIGHMEM=y
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+# CONFIG_SECCOMP is not set
+CONFIG_MIPS_O32_FP64_SUPPORT=y
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_NO_HZ=y
+CONFIG_BLK_DEV_INITRD=y
+# CONFIG_RD_GZIP is not set
+CONFIG_EXPERT=y
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+# CONFIG_IOSCHED_CFQ is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_PACKET_DIAG=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+CONFIG_CFG80211=y
+CONFIG_NL80211_TESTMODE=y
+CONFIG_MAC80211=y
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_STANDALONE is not set
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+CONFIG_MTD=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP=y
+# CONFIG_BLK_DEV is not set
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+# CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_NETDEVICES=y
+CONFIG_BCMGENET=y
+CONFIG_USB_USBNET=y
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
+# CONFIG_HW_RANDOM is not set
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_SYSCON=y
+# CONFIG_HWMON is not set
+CONFIG_USB=y
+CONFIG_USB_EHCI_HCD=y
+# CONFIG_USB_EHCI_TT_NEWSCHED is not set
+CONFIG_USB_EHCI_HCD_PLATFORM=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_OHCI_HCD_PLATFORM=y
+CONFIG_USB_STORAGE=y
+CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
+# CONFIG_DNOTIFY is not set
+CONFIG_FUSE_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_TMPFS=y
+CONFIG_NFS_FS=y
+CONFIG_CIFS=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ASCII=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_DEBUG_FS=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_CMDLINE_BOOL=y
+CONFIG_CMDLINE="earlycon"
+# CONFIG_CRYPTO_HW is not set
diff --git a/arch/mips/include/asm/mach-bmips/dma-coherence.h b/arch/mips/include/asm/mach-bmips/dma-coherence.h
new file mode 100644
index 000000000000..5481a4d1bbbf
--- /dev/null
+++ b/arch/mips/include/asm/mach-bmips/dma-coherence.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2006 Ralf Baechle <ralf@linux-mips.org>
+ * Copyright (C) 2009-2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ASM_MACH_BMIPS_DMA_COHERENCE_H
+#define __ASM_MACH_BMIPS_DMA_COHERENCE_H
+
+struct device;
+
+extern dma_addr_t plat_map_dma_mem(struct device *dev, void *addr, size_t size);
+extern dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page);
+extern unsigned long plat_dma_addr_to_phys(struct device *dev,
+	dma_addr_t dma_addr);
+extern void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction);
+
+static inline int plat_dma_supported(struct device *dev, u64 mask)
+{
+	/*
+	 * we fall back to GFP_DMA when the mask isn't all 1s,
+	 * so we can't guarantee allocations that must be
+	 * within a tighter range than GFP_DMA..
+	 */
+	if (mask < DMA_BIT_MASK(24))
+		return 0;
+
+	return 1;
+}
+
+static inline int plat_device_is_coherent(struct device *dev)
+{
+	return 0;
+}
+
+#endif /* __ASM_MACH_BMIPS_DMA_COHERENCE_H */
diff --git a/arch/mips/include/asm/mach-bmips/spaces.h b/arch/mips/include/asm/mach-bmips/spaces.h
new file mode 100644
index 000000000000..1f7bc6cb6160
--- /dev/null
+++ b/arch/mips/include/asm/mach-bmips/spaces.h
@@ -0,0 +1,17 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994 - 1999, 2000, 03, 04 Ralf Baechle
+ * Copyright (C) 2000, 2002  Maciej W. Rozycki
+ * Copyright (C) 1990, 1999, 2000 Silicon Graphics, Inc.
+ */
+#ifndef _ASM_BMIPS_SPACES_H
+#define _ASM_BMIPS_SPACES_H
+
+#define FIXADDR_TOP		((unsigned long)(long)(int)0xff000000)
+
+#include <asm/mach-generic/spaces.h>
+
+#endif /* __ASM_BMIPS_SPACES_H */
diff --git a/arch/mips/include/asm/mach-bmips/war.h b/arch/mips/include/asm/mach-bmips/war.h
new file mode 100644
index 000000000000..65af1096cd6f
--- /dev/null
+++ b/arch/mips/include/asm/mach-bmips/war.h
@@ -0,0 +1,24 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
+ */
+#ifndef __ASM_MIPS_MACH_BMIPS_WAR_H
+#define __ASM_MIPS_MACH_BMIPS_WAR_H
+
+#define R4600_V1_INDEX_ICACHEOP_WAR	0
+#define R4600_V1_HIT_CACHEOP_WAR	0
+#define R4600_V2_HIT_CACHEOP_WAR	0
+#define R5432_CP0_INTERRUPT_WAR		0
+#define BCM1250_M3_WAR			0
+#define SIBYTE_1956_WAR			0
+#define MIPS4K_ICACHE_REFILL_WAR	0
+#define MIPS_CACHE_SYNC_WAR		0
+#define TX49XX_ICACHE_INDEX_INV_WAR	0
+#define ICACHE_REFILLS_WORKAROUND_WAR	0
+#define R10000_LLSC_WAR			0
+#define MIPS34K_MISSED_ITLB_WAR		0
+
+#endif /* __ASM_MIPS_MACH_BMIPS_WAR_H */
-- 
2.1.1

