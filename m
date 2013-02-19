Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab3BSPlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:41:35 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52889 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3BSPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:41:32 -0500
Date: Tue, 19 Feb 2013 16:41:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.9
Message-ID: <20130219154128.GA15608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: 7d0291256ca99cbb6124f63228003329e7a64b21 x86: Add TS-5500 platform support

 * Support for the Technologic Systems TS-5500 platform,
   by Vivien Didelot

 * Improved NUMA support on AMD systems:

    Add support for federated systems where multiple memory
    controllers can exist and see each other over multiple PCI 
    domains. This basically means that AMD node ids can be more 
    than 8 now and the code handling this is taught to 
    incorporate PCI domain into those IDs.

 * Support for the Goldfish virtual Android emulator,
   by Jun Nakajima, Intel, Google, et al.

 * Misc fixlets.

out-of-topic modifications in x86-platform-for-linus:
-----------------------------------------------------
MAINTAINERS                        # 7d02912: x86: Add TS-5500 platform support
drivers/edac/amd64_edac.c          # c7e5301: amd64_edac: Fix type usage in NB 
                                   # e2c0bff: amd64_edac: Fix PCI function look
                                   # 8b84c8d: x86, AMD, NB: Use u16 for northbr
                                   # 772c3ff: x86, AMD, NB: Add multi-domain su
drivers/edac/amd64_edac.h          # c7e5301: amd64_edac: Fix type usage in NB 
                                   # 772c3ff: x86, AMD, NB: Add multi-domain su

 Thanks,

	Ingo

------------------>
Cong Ding (1):
      x86/apb/timer: Remove unnecessary "if"

Daniel J Blueman (4):
      x86, AMD, NB: Add multi-domain support
      x86, AMD, NB: Use u16 for northbridge IDs in amd_get_nb_id
      amd64_edac: Fix PCI function lookup
      amd64_edac: Fix type usage in NB IDs and memory ranges

Davidlohr Bueso (1):
      x86/srat: Simplify memory affinity init error handling

Jun Nakajima (1):
      goldfish: platform device for x86

Vivien Didelot (1):
      x86: Add TS-5500 platform support


 Documentation/ABI/testing/sysfs-platform-ts5500 |  47 ++++
 MAINTAINERS                                     |   5 +
 arch/x86/Kconfig                                |  21 ++
 arch/x86/include/asm/amd_nb.h                   |  17 ++
 arch/x86/include/asm/processor.h                |   2 +-
 arch/x86/kernel/apb_timer.c                     |   2 +-
 arch/x86/kernel/cpu/amd.c                       |   4 +-
 arch/x86/mm/srat.c                              |  29 +-
 arch/x86/platform/Makefile                      |   2 +
 arch/x86/platform/goldfish/Makefile             |   1 +
 arch/x86/platform/goldfish/goldfish.c           |  51 ++++
 arch/x86/platform/ts5500/Makefile               |   1 +
 arch/x86/platform/ts5500/ts5500.c               | 339 ++++++++++++++++++++++++
 drivers/edac/amd64_edac.c                       | 109 ++++----
 drivers/edac/amd64_edac.h                       |  12 +-
 15 files changed, 563 insertions(+), 79 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ts5500
 create mode 100644 arch/x86/platform/goldfish/Makefile
 create mode 100644 arch/x86/platform/goldfish/goldfish.c
 create mode 100644 arch/x86/platform/ts5500/Makefile
 create mode 100644 arch/x86/platform/ts5500/ts5500.c

diff --git a/Documentation/ABI/testing/sysfs-platform-ts5500 b/Documentation/ABI/testing/sysfs-platform-ts5500
new file mode 100644
index 0000000..c88375a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-ts5500
@@ -0,0 +1,47 @@
+What:		/sys/devices/platform/ts5500/adc
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of an A/D Converter. If it is present,
+		it will display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/ereset
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of an external reset. If it is present,
+		it will display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/id
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Product ID of the TS board. TS-5500 ID is 0x60.
+
+What:		/sys/devices/platform/ts5500/jumpers
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Bitfield showing the jumpers' state. If a jumper is present,
+		the corresponding bit is set. For instance, 0x0e means jumpers
+		2, 3 and 4 are set.
+
+What:		/sys/devices/platform/ts5500/rs485
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of the RS485 option. If it is present,
+		it will display "1", otherwise "0".
+
+What:		/sys/devices/platform/ts5500/sram
+Date:		January 2013
+KernelVersion:	3.7
+Contact:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
+Description:
+		Indicates the presence of the SRAM option. If it is present,
+		it will display "1", otherwise "0".
diff --git a/MAINTAINERS b/MAINTAINERS
index 3105c48..2617040 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7543,6 +7543,11 @@ F:	drivers/net/team/
 F:	include/linux/if_team.h
 F:	include/uapi/linux/if_team.h
 
+TECHNOLOGIC SYSTEMS TS-5500 PLATFORM SUPPORT
+M:	Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>
+S:	Maintained
+F:	arch/x86/platform/ts5500/
+
 TECHNOTREND USB IR RECEIVER
 M:	Sean Young <sean@mess.org>
 L:	linux-media@vger.kernel.org
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..0709e34 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -320,6 +320,10 @@ config X86_BIGSMP
 	---help---
 	  This option is needed for the systems that have more than 8 CPUs
 
+config GOLDFISH
+       def_bool y
+       depends on X86_GOLDFISH
+
 if X86_32
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
@@ -402,6 +406,14 @@ config X86_UV
 # Following is an alphabetically sorted list of 32 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 
+config X86_GOLDFISH
+       bool "Goldfish (Virtual Platform)"
+       depends on X86_32
+       ---help---
+	 Enable support for the Goldfish virtual platform used primarily
+	 for Android development. Unless you are building for the Android
+	 Goldfish emulator say N here.
+
 config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
@@ -2187,6 +2199,15 @@ config GEOS
 	---help---
 	  This option enables system support for the Traverse Technologies GEOS.
 
+config TS5500
+	bool "Technologic Systems TS-5500 platform support"
+	depends on MELAN
+	select CHECK_SIGNATURE
+	select NEW_LEDS
+	select LEDS_CLASS
+	---help---
+	  This option enables system support for the Technologic Systems TS-5500.
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b3341e9..a54ee1d 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -81,6 +81,23 @@ static inline struct amd_northbridge *node_to_amd_nb(int node)
 	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
 }
 
+static inline u16 amd_get_node_id(struct pci_dev *pdev)
+{
+	struct pci_dev *misc;
+	int i;
+
+	for (i = 0; i != amd_nb_num(); i++) {
+		misc = node_to_amd_nb(i)->misc;
+
+		if (pci_domain_nr(misc->bus) == pci_domain_nr(pdev->bus) &&
+		    PCI_SLOT(misc->devfn) == PCI_SLOT(pdev->devfn))
+			return i;
+	}
+
+	WARN(1, "Unable to find AMD Northbridge id for %s\n", pci_name(pdev));
+	return 0;
+}
+
 #else
 
 #define amd_nb_num(x)		0
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 888184b..cf50054 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -943,7 +943,7 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
-extern int amd_get_nb_id(int cpu);
+extern u16 amd_get_nb_id(int cpu);
 
 struct aperfmperf {
 	u64 aperf, mperf;
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index afdc3f75..cf92735 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -240,7 +240,7 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 		dw_apb_clockevent_pause(adev->timer);
 		if (system_state == SYSTEM_RUNNING) {
 			pr_debug("skipping APBT CPU %lu offline\n", cpu);
-		} else if (adev) {
+		} else {
 			pr_debug("APBT clockevent for cpu %lu offline\n", cpu);
 			dw_apb_clockevent_stop(adev->timer);
 		}
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 15239ff..782c456 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -364,9 +364,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
-int amd_get_nb_id(int cpu)
+u16 amd_get_nb_id(int cpu)
 {
-	int id = 0;
+	u16 id = 0;
 #ifdef CONFIG_SMP
 	id = per_cpu(cpu_llc_id, cpu);
 #endif
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 4ddf497..cdd0da9 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -149,39 +149,40 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	int node, pxm;
 
 	if (srat_disabled())
-		return -1;
-	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
-		bad_srat();
-		return -1;
-	}
+		goto out_err;
+	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
+		goto out_err_bad_srat;
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
-		return -1;
-
+		goto out_err;
 	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
-		return -1;
+		goto out_err;
+
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
 	if (acpi_srat_revision <= 1)
 		pxm &= 0xff;
+
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		bad_srat();
-		return -1;
+		goto out_err_bad_srat;
 	}
 
-	if (numa_add_memblk(node, start, end) < 0) {
-		bad_srat();
-		return -1;
-	}
+	if (numa_add_memblk(node, start, end) < 0)
+		goto out_err_bad_srat;
 
 	node_set(node, numa_nodes_parsed);
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
 	       node, pxm,
 	       (unsigned long long) start, (unsigned long long) end - 1);
+
 	return 0;
+out_err_bad_srat:
+	bad_srat();
+out_err:
+	return -1;
 }
 
 void __init acpi_numa_arch_fixup(void) {}
diff --git a/arch/x86/platform/Makefile b/arch/x86/platform/Makefile
index 8d87439..01e0231 100644
--- a/arch/x86/platform/Makefile
+++ b/arch/x86/platform/Makefile
@@ -2,10 +2,12 @@
 obj-y	+= ce4100/
 obj-y	+= efi/
 obj-y	+= geode/
+obj-y	+= goldfish/
 obj-y	+= iris/
 obj-y	+= mrst/
 obj-y	+= olpc/
 obj-y	+= scx200/
 obj-y	+= sfi/
+obj-y	+= ts5500/
 obj-y	+= visws/
 obj-y	+= uv/
diff --git a/arch/x86/platform/goldfish/Makefile b/arch/x86/platform/goldfish/Makefile
new file mode 100644
index 0000000..f030b53
--- /dev/null
+++ b/arch/x86/platform/goldfish/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_GOLDFISH)	+= goldfish.o
diff --git a/arch/x86/platform/goldfish/goldfish.c b/arch/x86/platform/goldfish/goldfish.c
new file mode 100644
index 0000000..1693107
--- /dev/null
+++ b/arch/x86/platform/goldfish/goldfish.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (C) 2011 Intel, Inc.
+ * Copyright (C) 2013 Intel, Inc.
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
+
+#include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+
+/*
+ * Where in virtual device memory the IO devices (timers, system controllers
+ * and so on)
+ */
+
+#define GOLDFISH_PDEV_BUS_BASE	(0xff001000)
+#define GOLDFISH_PDEV_BUS_END	(0xff7fffff)
+#define GOLDFISH_PDEV_BUS_IRQ	(4)
+
+#define GOLDFISH_TTY_BASE	(0x2000)
+
+static struct resource goldfish_pdev_bus_resources[] = {
+	{
+		.start  = GOLDFISH_PDEV_BUS_BASE,
+		.end    = GOLDFISH_PDEV_BUS_END,
+		.flags  = IORESOURCE_MEM,
+	},
+	{
+		.start	= GOLDFISH_PDEV_BUS_IRQ,
+		.end	= GOLDFISH_PDEV_BUS_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static int __init goldfish_init(void)
+{
+	platform_device_register_simple("goldfish_pdev_bus", -1,
+						goldfish_pdev_bus_resources, 2);
+	return 0;
+}
+device_initcall(goldfish_init);
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
new file mode 100644
index 0000000..c54e348
--- /dev/null
+++ b/arch/x86/platform/ts5500/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_TS5500)	+= ts5500.o
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
new file mode 100644
index 0000000..39febb2
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -0,0 +1,339 @@
+/*
+ * Technologic Systems TS-5500 Single Board Computer support
+ *
+ * Copyright (C) 2013 Savoir-faire Linux Inc.
+ *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free Software
+ * Foundation; either version 2 of the License, or (at your option) any later
+ * version.
+ *
+ *
+ * This driver registers the Technologic Systems TS-5500 Single Board Computer
+ * (SBC) and its devices, and exposes information to userspace such as jumpers'
+ * state or available options. For further information about sysfs entries, see
+ * Documentation/ABI/testing/sysfs-platform-ts5500.
+ *
+ * This code actually supports the TS-5500 platform, but it may be extended to
+ * support similar Technologic Systems x86-based platforms, such as the TS-5600.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/platform_data/gpio-ts5500.h>
+#include <linux/platform_data/max197.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* Product code register */
+#define TS5500_PRODUCT_CODE_ADDR	0x74
+#define TS5500_PRODUCT_CODE		0x60	/* TS-5500 product code */
+
+/* SRAM/RS-485/ADC options, and RS-485 RTS/Automatic RS-485 flags register */
+#define TS5500_SRAM_RS485_ADC_ADDR	0x75
+#define TS5500_SRAM			BIT(0)	/* SRAM option */
+#define TS5500_RS485			BIT(1)	/* RS-485 option */
+#define TS5500_ADC			BIT(2)	/* A/D converter option */
+#define TS5500_RS485_RTS		BIT(6)	/* RTS for RS-485 */
+#define TS5500_RS485_AUTO		BIT(7)	/* Automatic RS-485 */
+
+/* External Reset/Industrial Temperature Range options register */
+#define TS5500_ERESET_ITR_ADDR		0x76
+#define TS5500_ERESET			BIT(0)	/* External Reset option */
+#define TS5500_ITR			BIT(1)	/* Indust. Temp. Range option */
+
+/* LED/Jumpers register */
+#define TS5500_LED_JP_ADDR		0x77
+#define TS5500_LED			BIT(0)	/* LED flag */
+#define TS5500_JP1			BIT(1)	/* Automatic CMOS */
+#define TS5500_JP2			BIT(2)	/* Enable Serial Console */
+#define TS5500_JP3			BIT(3)	/* Write Enable Drive A */
+#define TS5500_JP4			BIT(4)	/* Fast Console (115K baud) */
+#define TS5500_JP5			BIT(5)	/* User Jumper */
+#define TS5500_JP6			BIT(6)	/* Console on COM1 (req. JP2) */
+#define TS5500_JP7			BIT(7)	/* Undocumented (Unused) */
+
+/* A/D Converter registers */
+#define TS5500_ADC_CONV_BUSY_ADDR	0x195	/* Conversion state register */
+#define TS5500_ADC_CONV_BUSY		BIT(0)
+#define TS5500_ADC_CONV_INIT_LSB_ADDR	0x196	/* Start conv. / LSB register */
+#define TS5500_ADC_CONV_MSB_ADDR	0x197	/* MSB register */
+#define TS5500_ADC_CONV_DELAY		12	/* usec */
+
+/**
+ * struct ts5500_sbc - TS-5500 board description
+ * @id:		Board product ID.
+ * @sram:	Flag for SRAM option.
+ * @rs485:	Flag for RS-485 option.
+ * @adc:	Flag for Analog/Digital converter option.
+ * @ereset:	Flag for External Reset option.
+ * @itr:	Flag for Industrial Temperature Range option.
+ * @jumpers:	Bitfield for jumpers' state.
+ */
+struct ts5500_sbc {
+	int	id;
+	bool	sram;
+	bool	rs485;
+	bool	adc;
+	bool	ereset;
+	bool	itr;
+	u8	jumpers;
+};
+
+/* Board signatures in BIOS shadow RAM */
+static const struct {
+	const char * const string;
+	const ssize_t offset;
+} ts5500_signatures[] __initdata = {
+	{ "TS-5x00 AMD Elan", 0xb14 },
+};
+
+static int __init ts5500_check_signature(void)
+{
+	void __iomem *bios;
+	int i, ret = -ENODEV;
+
+	bios = ioremap(0xf0000, 0x10000);
+	if (!bios)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(ts5500_signatures); i++) {
+		if (check_signature(bios + ts5500_signatures[i].offset,
+				    ts5500_signatures[i].string,
+				    strlen(ts5500_signatures[i].string))) {
+			ret = 0;
+			break;
+		}
+	}
+
+	iounmap(bios);
+	return ret;
+}
+
+static int __init ts5500_detect_config(struct ts5500_sbc *sbc)
+{
+	u8 tmp;
+	int ret = 0;
+
+	if (!request_region(TS5500_PRODUCT_CODE_ADDR, 4, "ts5500"))
+		return -EBUSY;
+
+	tmp = inb(TS5500_PRODUCT_CODE_ADDR);
+	if (tmp != TS5500_PRODUCT_CODE) {
+		pr_err("This platform is not a TS-5500 (found ID 0x%x)\n", tmp);
+		ret = -ENODEV;
+		goto cleanup;
+	}
+	sbc->id = tmp;
+
+	tmp = inb(TS5500_SRAM_RS485_ADC_ADDR);
+	sbc->sram = tmp & TS5500_SRAM;
+	sbc->rs485 = tmp & TS5500_RS485;
+	sbc->adc = tmp & TS5500_ADC;
+
+	tmp = inb(TS5500_ERESET_ITR_ADDR);
+	sbc->ereset = tmp & TS5500_ERESET;
+	sbc->itr = tmp & TS5500_ITR;
+
+	tmp = inb(TS5500_LED_JP_ADDR);
+	sbc->jumpers = tmp & ~TS5500_LED;
+
+cleanup:
+	release_region(TS5500_PRODUCT_CODE_ADDR, 4);
+	return ret;
+}
+
+static ssize_t ts5500_show_id(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "0x%.2x\n", sbc->id);
+}
+
+static ssize_t ts5500_show_jumpers(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct ts5500_sbc *sbc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "0x%.2x\n", sbc->jumpers >> 1);
+}
+
+#define TS5500_SHOW(field)					\
+	static ssize_t ts5500_show_##field(struct device *dev,	\
+			struct device_attribute *attr,		\
+			char *buf)				\
+	{							\
+		struct ts5500_sbc *sbc = dev_get_drvdata(dev);	\
+		return sprintf(buf, "%d\n", sbc->field);	\
+	}
+
+TS5500_SHOW(sram)
+TS5500_SHOW(rs485)
+TS5500_SHOW(adc)
+TS5500_SHOW(ereset)
+TS5500_SHOW(itr)
+
+static DEVICE_ATTR(id, S_IRUGO, ts5500_show_id, NULL);
+static DEVICE_ATTR(jumpers, S_IRUGO, ts5500_show_jumpers, NULL);
+static DEVICE_ATTR(sram, S_IRUGO, ts5500_show_sram, NULL);
+static DEVICE_ATTR(rs485, S_IRUGO, ts5500_show_rs485, NULL);
+static DEVICE_ATTR(adc, S_IRUGO, ts5500_show_adc, NULL);
+static DEVICE_ATTR(ereset, S_IRUGO, ts5500_show_ereset, NULL);
+static DEVICE_ATTR(itr, S_IRUGO, ts5500_show_itr, NULL);
+
+static struct attribute *ts5500_attributes[] = {
+	&dev_attr_id.attr,
+	&dev_attr_jumpers.attr,
+	&dev_attr_sram.attr,
+	&dev_attr_rs485.attr,
+	&dev_attr_adc.attr,
+	&dev_attr_ereset.attr,
+	&dev_attr_itr.attr,
+	NULL
+};
+
+static const struct attribute_group ts5500_attr_group = {
+	.attrs = ts5500_attributes,
+};
+
+static struct resource ts5500_dio1_resource[] = {
+	DEFINE_RES_IRQ_NAMED(7, "DIO1 interrupt"),
+};
+
+static struct platform_device ts5500_dio1_pdev = {
+	.name = "ts5500-dio1",
+	.id = -1,
+	.resource = ts5500_dio1_resource,
+	.num_resources = 1,
+};
+
+static struct resource ts5500_dio2_resource[] = {
+	DEFINE_RES_IRQ_NAMED(6, "DIO2 interrupt"),
+};
+
+static struct platform_device ts5500_dio2_pdev = {
+	.name = "ts5500-dio2",
+	.id = -1,
+	.resource = ts5500_dio2_resource,
+	.num_resources = 1,
+};
+
+static void ts5500_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness brightness)
+{
+	outb(!!brightness, TS5500_LED_JP_ADDR);
+}
+
+static enum led_brightness ts5500_led_get(struct led_classdev *led_cdev)
+{
+	return (inb(TS5500_LED_JP_ADDR) & TS5500_LED) ? LED_FULL : LED_OFF;
+}
+
+static struct led_classdev ts5500_led_cdev = {
+	.name = "ts5500:green:",
+	.brightness_set = ts5500_led_set,
+	.brightness_get = ts5500_led_get,
+};
+
+static int ts5500_adc_convert(u8 ctrl)
+{
+	u8 lsb, msb;
+
+	/* Start conversion (ensure the 3 MSB are set to 0) */
+	outb(ctrl & 0x1f, TS5500_ADC_CONV_INIT_LSB_ADDR);
+
+	/*
+	 * The platform has CPLD logic driving the A/D converter.
+	 * The conversion must complete within 11 microseconds,
+	 * otherwise we have to re-initiate a conversion.
+	 */
+	udelay(TS5500_ADC_CONV_DELAY);
+	if (inb(TS5500_ADC_CONV_BUSY_ADDR) & TS5500_ADC_CONV_BUSY)
+		return -EBUSY;
+
+	/* Read the raw data */
+	lsb = inb(TS5500_ADC_CONV_INIT_LSB_ADDR);
+	msb = inb(TS5500_ADC_CONV_MSB_ADDR);
+
+	return (msb << 8) | lsb;
+}
+
+static struct max197_platform_data ts5500_adc_pdata = {
+	.convert = ts5500_adc_convert,
+};
+
+static struct platform_device ts5500_adc_pdev = {
+	.name = "max197",
+	.id = -1,
+	.dev = {
+		.platform_data = &ts5500_adc_pdata,
+	},
+};
+
+static int __init ts5500_init(void)
+{
+	struct platform_device *pdev;
+	struct ts5500_sbc *sbc;
+	int err;
+
+	/*
+	 * There is no DMI available or PCI bridge subvendor info,
+	 * only the BIOS provides a 16-bit identification call.
+	 * It is safer to find a signature in the BIOS shadow RAM.
+	 */
+	err = ts5500_check_signature();
+	if (err)
+		return err;
+
+	pdev = platform_device_register_simple("ts5500", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	sbc = devm_kzalloc(&pdev->dev, sizeof(struct ts5500_sbc), GFP_KERNEL);
+	if (!sbc) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	err = ts5500_detect_config(sbc);
+	if (err)
+		goto error;
+
+	platform_set_drvdata(pdev, sbc);
+
+	err = sysfs_create_group(&pdev->dev.kobj, &ts5500_attr_group);
+	if (err)
+		goto error;
+
+	ts5500_dio1_pdev.dev.parent = &pdev->dev;
+	if (platform_device_register(&ts5500_dio1_pdev))
+		dev_warn(&pdev->dev, "DIO1 block registration failed\n");
+	ts5500_dio2_pdev.dev.parent = &pdev->dev;
+	if (platform_device_register(&ts5500_dio2_pdev))
+		dev_warn(&pdev->dev, "DIO2 block registration failed\n");
+
+	if (led_classdev_register(&pdev->dev, &ts5500_led_cdev))
+		dev_warn(&pdev->dev, "LED registration failed\n");
+
+	if (sbc->adc) {
+		ts5500_adc_pdev.dev.parent = &pdev->dev;
+		if (platform_device_register(&ts5500_adc_pdev))
+			dev_warn(&pdev->dev, "ADC registration failed\n");
+	}
+
+	return 0;
+error:
+	platform_device_unregister(pdev);
+	return err;
+}
+device_initcall(ts5500_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Technologic Systems TS-5500 platform driver");
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ad8bf2a..2d3f882 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -31,7 +31,7 @@ static struct ecc_settings **ecc_stngs;
  *
  *FIXME: Produce a better mapping/linearisation.
  */
-struct scrubrate {
+static const struct scrubrate {
        u32 scrubval;           /* bit pattern for scrub rate */
        u32 bandwidth;          /* bandwidth consumed (bytes/sec) */
 } scrubrates[] = {
@@ -239,7 +239,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
  * DRAM base/limit associated with node_id
  */
 static bool amd64_base_limit_match(struct amd64_pvt *pvt, u64 sys_addr,
-				   unsigned nid)
+				   u8 nid)
 {
 	u64 addr;
 
@@ -265,7 +265,7 @@ static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
 						u64 sys_addr)
 {
 	struct amd64_pvt *pvt;
-	unsigned node_id;
+	u8 node_id;
 	u32 intlv_en, bits;
 
 	/*
@@ -939,7 +939,8 @@ static u64 get_error_address(struct mce *m)
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
-		u8 mce_nid, intlv_en;
+		u16 mce_nid;
+		u8 intlv_en;
 
 		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
 			return addr;
@@ -979,10 +980,29 @@ static u64 get_error_address(struct mce *m)
 	return addr;
 }
 
+static struct pci_dev *pci_get_related_function(unsigned int vendor,
+						unsigned int device,
+						struct pci_dev *related)
+{
+	struct pci_dev *dev = NULL;
+
+	while ((dev = pci_get_device(vendor, device, dev))) {
+		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
+		    (dev->bus->number == related->bus->number) &&
+		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
+			break;
+	}
+
+	return dev;
+}
+
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
+	struct amd_northbridge *nb;
+	struct pci_dev *misc, *f1 = NULL;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	int off = range << 3;
+	u32 llim;
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
@@ -996,30 +1016,32 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_HI + off,  &pvt->ranges[range].base.hi);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
 
-	/* Factor in CC6 save area by reading dst node's limit reg */
-	if (c->x86 == 0x15) {
-		struct pci_dev *f1 = NULL;
-		u8 nid = dram_dst_node(pvt, range);
-		u32 llim;
+	/* F15h: factor in CC6 save area by reading dst node's limit reg */
+	if (c->x86 != 0x15)
+		return;
 
-		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
-		if (WARN_ON(!f1))
-			return;
+	nb = node_to_amd_nb(dram_dst_node(pvt, range));
+	if (WARN_ON(!nb))
+		return;
 
-		amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
+	misc = nb->misc;
+	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
+	if (WARN_ON(!f1))
+		return;
 
-		pvt->ranges[range].lim.lo &= GENMASK(0, 15);
+	amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
 
-					    /* {[39:27],111b} */
-		pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
+	pvt->ranges[range].lim.lo &= GENMASK(0, 15);
 
-		pvt->ranges[range].lim.hi &= GENMASK(0, 7);
+				    /* {[39:27],111b} */
+	pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
 
-					    /* [47:40] */
-		pvt->ranges[range].lim.hi |= llim >> 13;
+	pvt->ranges[range].lim.hi &= GENMASK(0, 7);
 
-		pci_dev_put(f1);
-	}
+				    /* [47:40] */
+	pvt->ranges[range].lim.hi |= llim >> 13;
+
+	pci_dev_put(f1);
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
@@ -1305,7 +1327,7 @@ static u8 f1x_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
 }
 
 /* Convert the sys_addr to the normalized DCT address */
-static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, unsigned range,
+static u64 f1x_get_norm_dct_addr(struct amd64_pvt *pvt, u8 range,
 				 u64 sys_addr, bool hi_rng,
 				 u32 dct_sel_base_addr)
 {
@@ -1381,7 +1403,7 @@ static int f10_process_possible_spare(struct amd64_pvt *pvt, u8 dct, int csrow)
  *	-EINVAL:  NOT FOUND
  *	0..csrow = Chip-Select Row
  */
-static int f1x_lookup_addr_in_dct(u64 in_addr, u32 nid, u8 dct)
+static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
@@ -1672,23 +1694,6 @@ static struct amd64_family_type amd64_family_types[] = {
 	},
 };
 
-static struct pci_dev *pci_get_related_function(unsigned int vendor,
-						unsigned int device,
-						struct pci_dev *related)
-{
-	struct pci_dev *dev = NULL;
-
-	dev = pci_get_device(vendor, device, dev);
-	while (dev) {
-		if ((dev->bus->number == related->bus->number) &&
-		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
-			break;
-		dev = pci_get_device(vendor, device, dev);
-	}
-
-	return dev;
-}
-
 /*
  * These are tables of eigenvectors (one per line) which can be used for the
  * construction of the syndrome tables. The modified syndrome search algorithm
@@ -1696,7 +1701,7 @@ static struct pci_dev *pci_get_related_function(unsigned int vendor,
  *
  * Algorithm courtesy of Ross LaFetra from AMD.
  */
-static u16 x4_vectors[] = {
+static const u16 x4_vectors[] = {
 	0x2f57, 0x1afe, 0x66cc, 0xdd88,
 	0x11eb, 0x3396, 0x7f4c, 0xeac8,
 	0x0001, 0x0002, 0x0004, 0x0008,
@@ -1735,7 +1740,7 @@ static u16 x4_vectors[] = {
 	0x19a9, 0x2efe, 0xb5cc, 0x6f88,
 };
 
-static u16 x8_vectors[] = {
+static const u16 x8_vectors[] = {
 	0x0145, 0x028a, 0x2374, 0x43c8, 0xa1f0, 0x0520, 0x0a40, 0x1480,
 	0x0211, 0x0422, 0x0844, 0x1088, 0x01b0, 0x44e0, 0x23c0, 0xed80,
 	0x1011, 0x0116, 0x022c, 0x0458, 0x08b0, 0x8c60, 0x2740, 0x4e80,
@@ -1757,7 +1762,7 @@ static u16 x8_vectors[] = {
 	0x0100, 0x0200, 0x0400, 0x0800, 0x1000, 0x2000, 0x4000, 0x8000,
 };
 
-static int decode_syndrome(u16 syndrome, u16 *vectors, unsigned num_vecs,
+static int decode_syndrome(u16 syndrome, const u16 *vectors, unsigned num_vecs,
 			   unsigned v_dim)
 {
 	unsigned int i, err_sym;
@@ -2181,7 +2186,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 }
 
 /* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, u16 nid)
 {
 	int cpu;
 
@@ -2191,7 +2196,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, unsigned nid)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(unsigned nid)
+static bool amd64_nb_mce_bank_enabled_on_node(u16 nid)
 {
 	cpumask_var_t mask;
 	int cpu, nbe;
@@ -2224,7 +2229,7 @@ out:
 	return ret;
 }
 
-static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2262,7 +2267,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 	return 0;
 }
 
-static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
@@ -2314,7 +2319,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 					struct pci_dev *F3)
 {
 	u32 value, mask = 0x3;		/* UECC/CECC enable */
@@ -2353,7 +2358,7 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static bool ecc_enabled(struct pci_dev *F3, u8 nid)
+static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 {
 	u32 value;
 	u8 ecc_en = 0;
@@ -2474,7 +2479,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = get_node_id(F2);
+	u16 nid = amd_get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2566,7 +2571,7 @@ err_ret:
 static int amd64_probe_one_instance(struct pci_dev *pdev,
 				    const struct pci_device_id *mc_type)
 {
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2616,7 +2621,7 @@ static void amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index e864f40..35637d8 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -292,12 +292,6 @@
 /* MSRs */
 #define MSR_MCGCTL_NBE			BIT(4)
 
-/* AMD sets the first MC device at device ID 0x18. */
-static inline u8 get_node_id(struct pci_dev *pdev)
-{
-	return PCI_SLOT(pdev->devfn) - 0x18;
-}
-
 enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
@@ -340,7 +334,7 @@ struct amd64_pvt {
 	/* pci_device handles which we utilize */
 	struct pci_dev *F1, *F2, *F3;
 
-	unsigned mc_node_id;	/* MC index of this MC node */
+	u16 mc_node_id;		/* MC index of this MC node */
 	int ext_model;		/* extended model value of this node */
 	int channel_count;
 
@@ -393,7 +387,7 @@ struct err_info {
 	u32 offset;
 };
 
-static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_base(struct amd64_pvt *pvt, u8 i)
 {
 	u64 addr = ((u64)pvt->ranges[i].base.lo & 0xffff0000) << 8;
 
@@ -403,7 +397,7 @@ static inline u64 get_dram_base(struct amd64_pvt *pvt, unsigned i)
 	return (((u64)pvt->ranges[i].base.hi & 0x000000ff) << 40) | addr;
 }
 
-static inline u64 get_dram_limit(struct amd64_pvt *pvt, unsigned i)
+static inline u64 get_dram_limit(struct amd64_pvt *pvt, u8 i)
 {
 	u64 lim = (((u64)pvt->ranges[i].lim.lo & 0xffff0000) << 8) | 0x00ffffff;
 
