Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaHLQau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:30:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54752 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753521AbaHLQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:26:54 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 06/12] ARM: integrator: Correct usage of of_pci_range_to_resource()
Date: Tue, 12 Aug 2014 17:25:19 +0100
Message-Id: <1407860725-25202-7-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, of_pci_range_to_resource() would return a resource
that contained physical addresses of the IO space even if the
IORESOURCE_IO flags mandate a logical port set of values. Now
that the function has been fixed we need to update the drivers
that were taking advantage of the old behaviour.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm/mach-integrator/pci_v3.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 05e1f73..193b7f8 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -660,6 +660,7 @@ static void __init pci_v3_preinit(void)
 {
 	unsigned long flags;
 	unsigned int temp;
+	phys_addr_t io_address = pci_pio_to_address(io_mem.start);
 
 	pcibios_min_mem = 0x00100000;
 
@@ -701,7 +702,7 @@ static void __init pci_v3_preinit(void)
 	/*
 	 * Setup window 2 - PCI IO
 	 */
-	v3_writel(V3_LB_BASE2, v3_addr_to_lb_base2(io_mem.start) |
+	v3_writel(V3_LB_BASE2, v3_addr_to_lb_base2(io_address) |
 			V3_LB_BASE_ENABLE);
 	v3_writew(V3_LB_MAP2, v3_addr_to_lb_map2(0));
 
@@ -742,6 +743,7 @@ static void __init pci_v3_preinit(void)
 static void __init pci_v3_postinit(void)
 {
 	unsigned int pci_cmd;
+	phys_addr_t io_address = pci_pio_to_address(io_mem.start);
 
 	pci_cmd = PCI_COMMAND_MEMORY |
 		  PCI_COMMAND_MASTER | PCI_COMMAND_INVALIDATE;
@@ -758,7 +760,7 @@ static void __init pci_v3_postinit(void)
 		       "interrupt: %d\n", ret);
 #endif
 
-	register_isa_ports(non_mem.start, io_mem.start, 0);
+	register_isa_ports(non_mem.start, io_address, 0);
 }
 
 /*
@@ -867,33 +869,33 @@ static int __init pci_v3_probe(struct platform_device *pdev)
 
 	for_each_of_pci_range(&parser, &range) {
 		if (!range.flags) {
-			of_pci_range_to_resource(&range, np, &conf_mem);
+			ret = of_pci_range_to_resource(&range, np, &conf_mem);
 			conf_mem.name = "PCIv3 config";
 		}
 		if (range.flags & IORESOURCE_IO) {
-			of_pci_range_to_resource(&range, np, &io_mem);
+			ret = of_pci_range_to_resource(&range, np, &io_mem);
+			dev_info(&pdev->dev, "IO PCI range converted\n");
 			io_mem.name = "PCIv3 I/O";
 		}
 		if ((range.flags & IORESOURCE_MEM) &&
 			!(range.flags & IORESOURCE_PREFETCH)) {
 			non_mem_pci = range.pci_addr;
 			non_mem_pci_sz = range.size;
-			of_pci_range_to_resource(&range, np, &non_mem);
+			ret = of_pci_range_to_resource(&range, np, &non_mem);
 			non_mem.name = "PCIv3 non-prefetched mem";
 		}
 		if ((range.flags & IORESOURCE_MEM) &&
 			(range.flags & IORESOURCE_PREFETCH)) {
 			pre_mem_pci = range.pci_addr;
 			pre_mem_pci_sz = range.size;
-			of_pci_range_to_resource(&range, np, &pre_mem);
+			ret = of_pci_range_to_resource(&range, np, &pre_mem);
 			pre_mem.name = "PCIv3 prefetched mem";
 		}
-	}
 
-	if (!conf_mem.start || !io_mem.start ||
-	    !non_mem.start || !pre_mem.start) {
-		dev_err(&pdev->dev, "missing ranges in device node\n");
-		return -EINVAL;
+		if (ret < 0) {
+			dev_err(&pdev->dev, "missing ranges in device node\n");
+			return -EINVAL;
+		}
 	}
 
 	pci_v3.map_irq = of_irq_parse_and_map_pci;
-- 
2.0.4

