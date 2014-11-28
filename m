Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaK1Edu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:33:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35479 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaK1Ed3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:33:29 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 15/16] MIPS: Add Generic BMIPS target
Date: Thu, 27 Nov 2014 20:32:21 -0800
Message-Id: <1417149142-3756-16-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
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
 - Reboot sequences
 - GISB bus error catcher
 - Kernel command line

The DT-enabled bootloader and build instructions for 3384 are posted at
https://github.com/Broadcom/aeolus .

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../devicetree/bindings/mips/brcm/bmips.txt        |   8 +
 .../devicetree/bindings/mips/brcm/soc.txt          |  12 ++
 arch/mips/Kbuild.platforms                         |   1 +
 arch/mips/Kconfig                                  |  34 ++++
 arch/mips/bmips/Makefile                           |   1 +
 arch/mips/bmips/Platform                           |   7 +
 arch/mips/bmips/dma.c                              | 121 +++++++++++++
 arch/mips/bmips/irq.c                              |  38 ++++
 arch/mips/bmips/setup.c                            | 191 +++++++++++++++++++++
 arch/mips/configs/bmips_be_defconfig               |  88 ++++++++++
 arch/mips/configs/bmips_stb_defconfig              |  88 ++++++++++
 arch/mips/include/asm/mach-bmips/dma-coherence.h   |  48 ++++++
 arch/mips/include/asm/mach-bmips/spaces.h          |  18 ++
 13 files changed, 655 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/bmips.txt
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/soc.txt
 create mode 100644 arch/mips/bmips/Makefile
 create mode 100644 arch/mips/bmips/Platform
 create mode 100644 arch/mips/bmips/dma.c
 create mode 100644 arch/mips/bmips/irq.c
 create mode 100644 arch/mips/bmips/setup.c
 create mode 100644 arch/mips/configs/bmips_be_defconfig
 create mode 100644 arch/mips/configs/bmips_stb_defconfig
 create mode 100644 arch/mips/include/asm/mach-bmips/dma-coherence.h
 create mode 100644 arch/mips/include/asm/mach-bmips/spaces.h

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
index b4cdf722aeee..b10d5aaa6eb2 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -130,6 +130,40 @@ config ATH79
 	help
 	  Support for the Atheros AR71XX/AR724X/AR913X SoCs.
 
+config BMIPS_GENERIC
+	bool "Broadcom Generic BMIPS kernel"
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
+	  Build a generic DT-based kernel image that boots on select
+	  BCM33xx cable modem chips, BCM63xx DSL chips, and BCM7xxx set-top
+	  box chips.  Note that CONFIG_CPU_BIG_ENDIAN/CONFIG_CPU_LITTLE_ENDIAN
+	  must be set appropriately for your board.
+
 config BCM47XX
 	bool "Broadcom BCM47XX based boards"
 	select ARCH_WANT_OPTIONAL_GPIOLIB
diff --git a/arch/mips/bmips/Makefile b/arch/mips/bmips/Makefile
new file mode 100644
index 000000000000..a393955cba08
--- /dev/null
+++ b/arch/mips/bmips/Makefile
@@ -0,0 +1 @@
+obj-y		+= setup.o irq.o dma.o
diff --git a/arch/mips/bmips/Platform b/arch/mips/bmips/Platform
new file mode 100644
index 000000000000..5f127fd7f4b5
--- /dev/null
+++ b/arch/mips/bmips/Platform
@@ -0,0 +1,7 @@
+#
+# Broadcom Generic BMIPS kernel
+#
+platform-$(CONFIG_BMIPS_GENERIC)	+= bmips/
+cflags-$(CONFIG_BMIPS_GENERIC)		+=				\
+		-I$(srctree)/arch/mips/include/asm/mach-bmips/
+load-$(CONFIG_BMIPS_GENERIC)		:= 0xffffffff80010000
diff --git a/arch/mips/bmips/dma.c b/arch/mips/bmips/dma.c
new file mode 100644
index 000000000000..d4d115d02da5
--- /dev/null
+++ b/arch/mips/bmips/dma.c
@@ -0,0 +1,121 @@
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
index 000000000000..72793bfe6633
--- /dev/null
+++ b/arch/mips/bmips/setup.c
@@ -0,0 +1,191 @@
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
+	return "Generic BMIPS kernel";
+}
diff --git a/arch/mips/configs/bmips_be_defconfig b/arch/mips/configs/bmips_be_defconfig
new file mode 100644
index 000000000000..a0ee3f81f67c
--- /dev/null
+++ b/arch/mips/configs/bmips_be_defconfig
@@ -0,0 +1,88 @@
+CONFIG_BMIPS_GENERIC=y
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
+CONFIG_BRCMSTB_GISB_ARB=y
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
+CONFIG_POWER_RESET_BRCMSTB=y
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
index 000000000000..400a47ec1ef1
--- /dev/null
+++ b/arch/mips/configs/bmips_stb_defconfig
@@ -0,0 +1,88 @@
+CONFIG_BMIPS_GENERIC=y
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
+CONFIG_BRCMSTB_GISB_ARB=y
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
+CONFIG_POWER_RESET_BRCMSTB=y
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
index 000000000000..c8da8725f036
--- /dev/null
+++ b/arch/mips/include/asm/mach-bmips/dma-coherence.h
@@ -0,0 +1,48 @@
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
+
+static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
+{
+}
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
index 000000000000..1b05bddc8ec5
--- /dev/null
+++ b/arch/mips/include/asm/mach-bmips/spaces.h
@@ -0,0 +1,18 @@
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
+/* Avoid collisions with system base register (SBR) region on BMIPS3300 */
+#define FIXADDR_TOP		((unsigned long)(long)(int)0xff000000)
+
+#include <asm/mach-generic/spaces.h>
+
+#endif /* __ASM_BMIPS_SPACES_H */
-- 
2.1.0

