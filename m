Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080AbaKND7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:59:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42483 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512AbaKND7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:59:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, PCI: support mmio more than 44 bit on 32bit/PAE mode
Date: Thu, 13 Nov 2014 19:59:27 -0800
Message-Id: <1415937567-14510-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron reported 32bit/PAE mode, has problem with 64bit resource.

[    6.610012] pci 0000:03:00.0: reg 0x10: [mem 0x383fffc00000-0x383fffdfffff 64bit pref]
[    6.622195] pci 0000:03:00.0: reg 0x20: [mem 0x383fffe04000-0x383fffe07fff 64bit pref]
[    6.656112] pci 0000:03:00.1: reg 0x10: [mem 0x383fffa00000-0x383fffbfffff 64bit pref]
[    6.668293] pci 0000:03:00.1: reg 0x20: [mem 0x383fffe00000-0x383fffe03fff 64bit pref]
...
[   12.374143] calling  ixgbe_init_module+0x0/0x51 @ 1
[   12.378130] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   12.385318] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   12.390578] ixgbe 0000:03:00.0: Adapter removed
[   12.394247] ixgbe: probe of 0000:03:00.0 failed with error -5
[   12.399369] ixgbe 0000:03:00.1: Adapter removed
[   12.403036] ixgbe: probe of 0000:03:00.1 failed with error -5
[   12.408017] initcall ixgbe_init_module+0x0/0x51 returned 0 after 29200 usecs

root cause is ioremap can not handle mmio range that is more than 44bits on
32bit PAE mode.

We are using pfn with unsigned long like pfn_pte(), so those 0x383fffc00000 will
overflow in pfn format with unsigned long (that is 32bits in 32bit x86 kernel,
and pfn only can support 44bits).

| static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
| {
|        return __pte(((phys_addr_t)page_nr << PAGE_SHIFT) |
|                     massage_pgprot(pgprot));
| }

We could limit iomem to 44 bits so we can reject them early from root bus.
but xhci is not happy with resource allocation (hang ?)

Change phys_addr_t for pfn_pte, and add overflow check to skip ram checking,
as the mmio is too big to be ram.
At last, can not use PHYSICAL_PAGE_MASK to get aligned phys_addr.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=88131
Reported-by: Aaron Ma <mapengyu@gmail.com>
Tested-by: Aaron Ma <mapengyu@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/page.h    |    8 ++++++++
 arch/x86/include/asm/pgtable.h |    4 ++--
 arch/x86/mm/ioremap.c          |    6 ++++--
 arch/x86/mm/pat.c              |    3 +++
 4 files changed, 17 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/include/asm/page.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page.h
+++ linux-2.6/arch/x86/include/asm/page.h
@@ -15,6 +15,14 @@
 
 #ifndef __ASSEMBLY__
 
+static inline int pfn_overflow(dma_addr_t phy_addr)
+{
+	dma_addr_t real_pfn = phy_addr >> PAGE_SHIFT;
+	unsigned long pfn = (unsigned long)real_pfn;
+
+	return pfn != real_pfn;
+}
+
 struct page;
 
 #include <linux/range.h>
Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h
+++ linux-2.6/arch/x86/include/asm/pgtable.h
@@ -354,9 +354,9 @@ static inline pgprotval_t massage_pgprot
 	return protval;
 }
 
-static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
+static inline pte_t pfn_pte(phys_addr_t page_nr, pgprot_t pgprot)
 {
-	return __pte(((phys_addr_t)page_nr << PAGE_SHIFT) |
+	return __pte((page_nr << PAGE_SHIFT) |
 		     massage_pgprot(pgprot));
 }
 
Index: linux-2.6/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/ioremap.c
+++ linux-2.6/arch/x86/mm/ioremap.c
@@ -122,7 +122,9 @@ static void __iomem *__ioremap_caller(re
 	if (ram_region < 0) {
 		pfn      = phys_addr >> PAGE_SHIFT;
 		last_pfn = last_addr >> PAGE_SHIFT;
-		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
+		/* pfn overflow, don't need to check */
+		if (!pfn_overflow(last_addr) &&
+		    walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
 					  __ioremap_check_ram) == 1)
 			return NULL;
 	}
@@ -130,7 +132,7 @@ static void __iomem *__ioremap_caller(re
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PHYSICAL_PAGE_MASK;
+	phys_addr -= offset;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
 	retval = reserve_memtype(phys_addr, (u64)phys_addr + size,
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c
+++ linux-2.6/arch/x86/mm/pat.c
@@ -183,6 +183,9 @@ static int pat_pagerange_is_ram(resource
 	unsigned long end_pfn = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct pagerange_state state = {start_pfn, 0, 0};
 
+	/* pfn overflow, don't need to check */
+	if (pfn_overflow(end + PAGE_SIZE - 1))
+		return 0;
 	/*
 	 * For legacy reasons, physical address range in the legacy ISA
 	 * region is tracked as non-RAM. This will allow users of
