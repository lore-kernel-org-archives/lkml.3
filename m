Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbaCDHhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:37:14 -0500
Received: from ni.piap.pl ([195.187.100.4]:45254 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbaCDHhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:37:12 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-arm-kernel@lists.infradead.org
Cc: lkml <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Yinghai Lu <yinghai@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
References: <m3eh2nqz7n.fsf@t19.piap.pl>
Date: Tue, 04 Mar 2014 08:37:10 +0100
In-Reply-To: <m3eh2nqz7n.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 28 Feb 2014 12:00:12 +0100")
MIME-Version: 1.0
Message-ID: <m3r46io1nd.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: [PATCH v2] CNS3xxx: Fix PCIe early iotable_init().
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140303 #7388596, check: 20140304 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following BUG:

> kernel BUG at mm/vmalloc.c:1132!
> PC is at vm_area_add_early+0x20/0x84
> LR is at add_static_vm_early+0xc/0x60
>
> The problem is cns3xxx_pcie_init() (device_initcall) calls the "early"
> iotable_init().

Instead of merely calling the PCIe iotable_init() from
machine_desc->map_io(), this patch adds the required mappings to the
main CNS3xxx mapping table. This means we don't convert .pfn back to
virtual addresses in pcie.c. The size of the address space consumed for
PCIe control is reduced from 96 MiB (6 * 16 MiB) to about 32 MiB (this
doesn't include MMIO address space required by PCI devices):

- Size of the PCIe "host" mapping is reduced from 16 MiB to 4 KiB.
  It's a PCI configuration address space for the local (on-chip) PCIe
  bridge.

- Size of the "CFG0" mapping is reduced from 16 MiB to 64 KiB. It's for
  Type 0 Configuration accesses, i.e., accesses to the single device
  (with possible "functions") on the other end of the PCIe link.
  We really only need a 4 KiB page at 0x8000 (see the offset
  calculation in cns3xxx_pci_cfg_base()). There is still a potential
  problem with PCI bus numbers > 0xF, are they supported?

- The code in cns3xxx_pci_cfg_base() and cns3xxx_pcie_hw_init() should
  be clearer now.

- The maximum address space allocated for PCI MMIO is now correctly
  shown in /proc/iomem as 176 MiB (per each of the two PCI "domains"
  - previously only 16 MiB were reserved).

This patch has been tested on Gateworks Laguna board, masqueraded as
CNS3420VB.

--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -47,6 +47,38 @@ static struct map_desc cns3xxx_io_desc[] __initdata = {
 		.pfn		= __phys_to_pfn(CNS3XXX_PM_BASE),
 		.length		= SZ_4K,
 		.type		= MT_DEVICE,
+#ifdef CONFIG_PCI
+	}, {
+		.virtual	= CNS3XXX_PCIE0_HOST_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_PCIE0_HOST_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= CNS3XXX_PCIE0_CFG0_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_PCIE0_CFG0_BASE),
+		.length		= SZ_64K, /* really 4 KiB at offset 32 KiB */
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= CNS3XXX_PCIE0_CFG1_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_PCIE0_CFG1_BASE),
+		.length		= SZ_16M,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= CNS3XXX_PCIE1_HOST_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_PCIE1_HOST_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= CNS3XXX_PCIE1_CFG0_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_PCIE1_CFG0_BASE),
+		.length		= SZ_64K, /* really 4 KiB at offset 32 KiB */
+		.type		= MT_DEVICE,
+	}, {
+		.virtual	= CNS3XXX_PCIE1_CFG1_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_PCIE1_CFG1_BASE),
+		.length		= SZ_16M,
+		.type		= MT_DEVICE,
+#endif
 	},
 };
 
--- a/arch/arm/mach-cns3xxx/pcie.c
+++ b/arch/arm/mach-cns3xxx/pcie.c
@@ -23,15 +23,10 @@
 #include "cns3xxx.h"
 #include "core.h"
 
-enum cns3xxx_access_type {
-	CNS3XXX_HOST_TYPE = 0,
-	CNS3XXX_CFG0_TYPE,
-	CNS3XXX_CFG1_TYPE,
-	CNS3XXX_NUM_ACCESS_TYPES,
-};
-
 struct cns3xxx_pcie {
-	struct map_desc cfg_bases[CNS3XXX_NUM_ACCESS_TYPES];
+	void __iomem *host_regs; /* PCI config registers for host bridge */
+	void __iomem *cfg0_regs; /* PCI Type 0 config registers */
+	void __iomem *cfg1_regs; /* PCI Type 1 config registers */
 	unsigned int irqs[2];
 	struct resource res_io;
 	struct resource res_mem;
@@ -66,7 +61,6 @@ static void __iomem *cns3xxx_pci_cfg_base(struct pci_bus *bus,
 	int busno = bus->number;
 	int slot = PCI_SLOT(devfn);
 	int offset;
-	enum cns3xxx_access_type type;
 	void __iomem *base;
 
 	/* If there is no link, just show the CNS PCI bridge. */
@@ -78,17 +72,21 @@ static void __iomem *cns3xxx_pci_cfg_base(struct pci_bus *bus,
 	 * we still want to access it. For this to work, we must place
 	 * the first device on the same bus as the CNS PCI bridge.
 	 */
-	if (busno == 0) {
-		if (slot > 1)
-			return NULL;
-		type = slot;
-	} else {
-		type = CNS3XXX_CFG1_TYPE;
-	}
+	if (busno == 0) { /* directly connected PCIe bus */
+		switch (slot) {
+		case 0: /* host bridge device, function 0 only */
+			base = cnspci->host_regs;
+			break;
+		case 1: /* directly connected device */
+			base = cnspci->cfg0_regs;
+			break;
+		default:
+			return NULL; /* no such device */
+		}
+	} else /* remote PCI bus */
+		base = cnspci->cfg1_regs;
 
-	base = (void __iomem *)cnspci->cfg_bases[type].virtual;
 	offset = ((busno & 0xf) << 20) | (devfn << 12) | (where & 0xffc);
-
 	return base + offset;
 }
 
@@ -180,36 +178,19 @@ static int cns3xxx_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 
 static struct cns3xxx_pcie cns3xxx_pcie[] = {
 	[0] = {
-		.cfg_bases = {
-			[CNS3XXX_HOST_TYPE] = {
-				.virtual = CNS3XXX_PCIE0_HOST_BASE_VIRT,
-				.pfn = __phys_to_pfn(CNS3XXX_PCIE0_HOST_BASE),
-				.length = SZ_16M,
-				.type = MT_DEVICE,
-			},
-			[CNS3XXX_CFG0_TYPE] = {
-				.virtual = CNS3XXX_PCIE0_CFG0_BASE_VIRT,
-				.pfn = __phys_to_pfn(CNS3XXX_PCIE0_CFG0_BASE),
-				.length = SZ_16M,
-				.type = MT_DEVICE,
-			},
-			[CNS3XXX_CFG1_TYPE] = {
-				.virtual = CNS3XXX_PCIE0_CFG1_BASE_VIRT,
-				.pfn = __phys_to_pfn(CNS3XXX_PCIE0_CFG1_BASE),
-				.length = SZ_16M,
-				.type = MT_DEVICE,
-			},
-		},
+		.host_regs = (void __iomem *)CNS3XXX_PCIE0_HOST_BASE_VIRT,
+		.cfg0_regs = (void __iomem *)CNS3XXX_PCIE0_CFG0_BASE_VIRT,
+		.cfg1_regs = (void __iomem *)CNS3XXX_PCIE0_CFG1_BASE_VIRT,
 		.res_io = {
 			.name = "PCIe0 I/O space",
 			.start = CNS3XXX_PCIE0_IO_BASE,
-			.end = CNS3XXX_PCIE0_IO_BASE + SZ_16M - 1,
+			.end = CNS3XXX_PCIE0_CFG0_BASE - 1, /* 16 MiB */
 			.flags = IORESOURCE_IO,
 		},
 		.res_mem = {
 			.name = "PCIe0 non-prefetchable",
 			.start = CNS3XXX_PCIE0_MEM_BASE,
-			.end = CNS3XXX_PCIE0_MEM_BASE + SZ_16M - 1,
+			.end = CNS3XXX_PCIE0_HOST_BASE - 1, /* 176 MiB */
 			.flags = IORESOURCE_MEM,
 		},
 		.irqs = { IRQ_CNS3XXX_PCIE0_RC, IRQ_CNS3XXX_PCIE0_DEVICE, },
@@ -222,36 +203,19 @@ static struct cns3xxx_pcie cns3xxx_pcie[] = {
 		},
 	},
 	[1] = {
-		.cfg_bases = {
-			[CNS3XXX_HOST_TYPE] = {
-				.virtual = CNS3XXX_PCIE1_HOST_BASE_VIRT,
-				.pfn = __phys_to_pfn(CNS3XXX_PCIE1_HOST_BASE),
-				.length = SZ_16M,
-				.type = MT_DEVICE,
-			},
-			[CNS3XXX_CFG0_TYPE] = {
-				.virtual = CNS3XXX_PCIE1_CFG0_BASE_VIRT,
-				.pfn = __phys_to_pfn(CNS3XXX_PCIE1_CFG0_BASE),
-				.length = SZ_16M,
-				.type = MT_DEVICE,
-			},
-			[CNS3XXX_CFG1_TYPE] = {
-				.virtual = CNS3XXX_PCIE1_CFG1_BASE_VIRT,
-				.pfn = __phys_to_pfn(CNS3XXX_PCIE1_CFG1_BASE),
-				.length = SZ_16M,
-				.type = MT_DEVICE,
-			},
-		},
+		.host_regs = (void __iomem *)CNS3XXX_PCIE1_HOST_BASE_VIRT,
+		.cfg0_regs = (void __iomem *)CNS3XXX_PCIE1_CFG0_BASE_VIRT,
+		.cfg1_regs = (void __iomem *)CNS3XXX_PCIE1_CFG1_BASE_VIRT,
 		.res_io = {
 			.name = "PCIe1 I/O space",
 			.start = CNS3XXX_PCIE1_IO_BASE,
-			.end = CNS3XXX_PCIE1_IO_BASE + SZ_16M - 1,
+			.end = CNS3XXX_PCIE1_CFG0_BASE - 1, /* 16 MiB */
 			.flags = IORESOURCE_IO,
 		},
 		.res_mem = {
 			.name = "PCIe1 non-prefetchable",
 			.start = CNS3XXX_PCIE1_MEM_BASE,
-			.end = CNS3XXX_PCIE1_MEM_BASE + SZ_16M - 1,
+			.end = CNS3XXX_PCIE1_HOST_BASE - 1, /* 176 MiB */
 			.flags = IORESOURCE_MEM,
 		},
 		.irqs = { IRQ_CNS3XXX_PCIE1_RC, IRQ_CNS3XXX_PCIE1_DEVICE, },
@@ -307,18 +271,15 @@ static void __init cns3xxx_pcie_hw_init(struct cns3xxx_pcie *cnspci)
 		.ops = &cns3xxx_pcie_ops,
 		.sysdata = &sd,
 	};
-	u32 io_base = cnspci->res_io.start >> 16;
-	u32 mem_base = cnspci->res_mem.start >> 16;
-	u32 host_base = cnspci->cfg_bases[CNS3XXX_HOST_TYPE].pfn;
-	u32 cfg0_base = cnspci->cfg_bases[CNS3XXX_CFG0_TYPE].pfn;
+	u16 mem_base  = cnspci->res_mem.start >> 16;
+	u16 mem_limit = cnspci->res_mem.end   >> 16;
+	u16 io_base   = cnspci->res_io.start  >> 16;
+	u16 io_limit  = cnspci->res_io.end    >> 16;
 	u32 devfn = 0;
 	u8 tmp8;
 	u16 pos;
 	u16 dc;
 
-	host_base = (__pfn_to_phys(host_base) - 1) >> 16;
-	cfg0_base = (__pfn_to_phys(cfg0_base) - 1) >> 16;
-
 	pci_bus_write_config_byte(&bus, devfn, PCI_PRIMARY_BUS, 0);
 	pci_bus_write_config_byte(&bus, devfn, PCI_SECONDARY_BUS, 1);
 	pci_bus_write_config_byte(&bus, devfn, PCI_SUBORDINATE_BUS, 1);
@@ -328,9 +289,9 @@ static void __init cns3xxx_pcie_hw_init(struct cns3xxx_pcie *cnspci)
 	pci_bus_read_config_byte(&bus, devfn, PCI_SUBORDINATE_BUS, &tmp8);
 
 	pci_bus_write_config_word(&bus, devfn, PCI_MEMORY_BASE, mem_base);
-	pci_bus_write_config_word(&bus, devfn, PCI_MEMORY_LIMIT, host_base);
+	pci_bus_write_config_word(&bus, devfn, PCI_MEMORY_LIMIT, mem_limit);
 	pci_bus_write_config_word(&bus, devfn, PCI_IO_BASE_UPPER16, io_base);
-	pci_bus_write_config_word(&bus, devfn, PCI_IO_LIMIT_UPPER16, cfg0_base);
+	pci_bus_write_config_word(&bus, devfn, PCI_IO_LIMIT_UPPER16, io_limit);
 
 	if (!cnspci->linked)
 		return;
@@ -368,8 +329,6 @@ static int __init cns3xxx_pcie_init(void)
 			"imprecise external abort");
 
 	for (i = 0; i < ARRAY_SIZE(cns3xxx_pcie); i++) {
-		iotable_init(cns3xxx_pcie[i].cfg_bases,
-			     ARRAY_SIZE(cns3xxx_pcie[i].cfg_bases));
 		cns3xxx_pwr_clk_en(0x1 << PM_CLK_GATE_REG_OFFSET_PCIE(i));
 		cns3xxx_pwr_soft_rst(0x1 << PM_SOFT_RST_REG_OFFST_PCIE(i));
 		cns3xxx_pcie_check_link(&cns3xxx_pcie[i]);

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
