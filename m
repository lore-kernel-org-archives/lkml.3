Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaIBQiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:38:46 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15703 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbaIBQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:38:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,450,1406592000"; 
   d="scan'208";a="168376007"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 3/3] x86: remove the Xen-specific _PAGE_IOMAP PTE flag
Date: Tue, 2 Sep 2014 17:37:45 +0100
Message-ID: <1409675865-11608-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409675865-11608-1-git-send-email-david.vrabel@citrix.com>
References: <1409675865-11608-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _PAGE_IO_MAP PTE flag was only used by Xen PV guests to mark PTEs
that were used to map I/O regions that are 1:1 in the p2m.  This
allowed Xen to obtain the correct PFN when converting the MFNs read
from a PTE back to their PFN.

Xen guests no longer use _PAGE_IOMAP for this. Instead mfn_to_pfn()
returns the correct PFN by using a combination of the m2p and p2m to
determine if an MFN corresponds to a 1:1 mapping in the the p2m.

Remove _PAGE_IOMAP, replacing it with _PAGE_UNUSED2 to allow for
future uses of the PTE flag.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/pgtable_types.h |   11 +++++------
 arch/x86/mm/init_32.c                |    2 +-
 arch/x86/mm/init_64.c                |    2 +-
 arch/x86/pci/i386.c                  |    2 --
 arch/x86/xen/enlighten.c             |    2 --
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index f216963..cee83b2 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -23,7 +23,6 @@
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_SPLITTING	_PAGE_BIT_SOFTW2 /* only valid on a PSE pmd */
-#define _PAGE_BIT_IOMAP		_PAGE_BIT_SOFTW2 /* flag used to indicate IO mapping */
 #define _PAGE_BIT_HIDDEN	_PAGE_BIT_SOFTW3 /* hidden by kmemcheck */
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
@@ -52,7 +51,7 @@
 #define _PAGE_PSE	(_AT(pteval_t, 1) << _PAGE_BIT_PSE)
 #define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
 #define _PAGE_SOFTW1	(_AT(pteval_t, 1) << _PAGE_BIT_SOFTW1)
-#define _PAGE_IOMAP	(_AT(pteval_t, 1) << _PAGE_BIT_IOMAP)
+#define _PAGE_SOFTW2	(_AT(pteval_t, 1) << _PAGE_BIT_SOFTW2)
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
 #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
@@ -168,10 +167,10 @@
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
-#define __PAGE_KERNEL_IO		(__PAGE_KERNEL | _PAGE_IOMAP)
-#define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE | _PAGE_IOMAP)
-#define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS | _PAGE_IOMAP)
-#define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO		(__PAGE_KERNEL)
+#define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE)
+#define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS)
+#define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC)
 
 #define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
 #define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 7d05565..c8140e1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -537,7 +537,7 @@ static void __init pagetable_init(void)
 	permanent_kmaps_init(pgd_base);
 }
 
-pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
+pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 /* user-defined highmem size */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5621c47..5d98476 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -151,7 +151,7 @@ early_param("gbpages", parse_direct_gbpages_on);
  * around without checking the pgd every time.
  */
 
-pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
+pteval_t __supported_pte_mask __read_mostly = ~0;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 int force_personality32;
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 2ae525e..37c1435 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -442,8 +442,6 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		 */
 		prot |= _PAGE_CACHE_UC_MINUS;
 
-	prot |= _PAGE_IOMAP;	/* creating a mapping for IO */
-
 	vma->vm_page_prot = __pgprot(prot);
 
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11f..be1cff5 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1559,8 +1559,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 #endif
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
-	__supported_pte_mask |= _PAGE_IOMAP;
-
 	/*
 	 * Prevent page tables from being allocated in highmem, even
 	 * if CONFIG_HIGHPTE is enabled.
-- 
1.7.10.4

