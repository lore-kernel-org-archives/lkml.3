Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaH2PSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:18:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaH2PSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:18:00 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: [PATCH] x86/xen: Fix 64bit kernel pagetable setup of PV guests
Date: Fri, 29 Aug 2014 17:17:57 +0200
Message-Id: <1409325477-2186-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seemed to be one of those what-the-heck moments. When trying to
figure out why changing the kernel/module split (which enabling KASLR
does) causes vmalloc to run wild on boot of 64bit PV guests, after
much scratching my head, found that xen_setup_kernel_pagetable copies
the same L2 table not only to the level2_ident_pgt and level2_kernel_pgt,
but also (due to miscalculating the offset) to level2_fixmap_pgt.

This only worked because the normal kernel image size only covers the
first half of level2_kernel_pgt and module space starts after that.

L4[511]->level3_kernel_pgt[510]->level2_kernel_pgt[  0..255]->kernel
                                                  [256..511]->module
                          [511]->level2_fixmap_pgt[  0..505]->module

With the split changing, the kernel image uses the full PUD range of
1G and module space starts in the level2_fixmap_pgt. So basically:

L4[511]->level3_kernel_pgt[510]->level2_kernel_pgt[0..511]->kernel
                          [511]->level2_fixmap_pgt[0..505]->module

And now the incorrect copy of the kernel mapping in that range bites
(hard). Causing errors in vmalloc that start with the following:

WARNING: CPU: 0 PID: 494 at linux/mm/vmalloc.c:128
         vmap_page_range_noflush+0x2a1/0x360()

Which is caused by a freshly allocated PTE for an address in the module
vspace area that is not uninitialized (pte_none()).
The same would happen with the old layout when something causes the
initial mappings to cross the 512M boundary. I was told that someone
saw the same vmalloc warning with the old layout but 500M initrd.

This change might not be the fully correct approach as it basically
removes the pre-set page table entry for the fixmap that is compile
time set (level2_fixmap_pgt[506]->level1_fixmap_pgt). For one the
level1 page table is not yet declared in C headers (that might be
fixed). But also with the current bug, it was removed, too. Since
the Xen mappings for level2_kernel_pgt only covered kernel + initrd
and some Xen data this did never reach that far. And still, something
does create entries at level2_fixmap_pgt[506..507]. So it should be
ok. At least I was able to successfully boot a kernel with 1G kernel
image size without any vmalloc whinings.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@vger.kernel.org
---
 arch/x86/xen/mmu.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8a1201..145e50f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1902,8 +1902,22 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 		/* L3_i[0] -> level2_ident_pgt */
 		convert_pfn_mfn(level3_ident_pgt);
 		/* L3_k[510] -> level2_kernel_pgt
-		 * L3_i[511] -> level2_fixmap_pgt */
+		 * L3_k[511] -> level2_fixmap_pgt */
 		convert_pfn_mfn(level3_kernel_pgt);
+
+		/* level2_fixmap_pgt contains a single entry for the
+		 * fixmap area at offset 506. The correct way would
+		 * be to convert level2_fixmap_pgt to mfn and set the
+		 * level1_fixmap_pgt (which is completely empty) to RO,
+		 * too. But currently this page table is not declared,
+		 * so it would be a bit of voodoo to get its address.
+		 * And also the fixmap entry was never set due to using
+		 * the wrong l2 when getting Xen's tables. So let's just
+		 * just nuke it.
+		 * This orphans level1_fixmap_pgt, but that was basically
+		 * done before the change as well.
+		 */
+		memset(level2_fixmap_pgt, 0, 512*sizeof(long));
 	}
 	/* We get [511][511] and have Xen's version of level2_kernel_pgt */
 	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
@@ -1913,21 +1927,15 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	addr[1] = (unsigned long)l3;
 	addr[2] = (unsigned long)l2;
 	/* Graft it onto L4[272][0]. Note that we creating an aliasing problem:
-	 * Both L4[272][0] and L4[511][511] have entries that point to the same
+	 * Both L4[272][0] and L4[511][510] have entries that point to the same
 	 * L2 (PMD) tables. Meaning that if you modify it in __va space
 	 * it will be also modified in the __ka space! (But if you just
 	 * modify the PMD table to point to other PTE's or none, then you
 	 * are OK - which is what cleanup_highmap does) */
 	copy_page(level2_ident_pgt, l2);
-	/* Graft it onto L4[511][511] */
+	/* Graft it onto L4[511][510] */
 	copy_page(level2_kernel_pgt, l2);
 
-	/* Get [511][510] and graft that in level2_fixmap_pgt */
-	l3 = m2v(pgd[pgd_index(__START_KERNEL_map + PMD_SIZE)].pgd);
-	l2 = m2v(l3[pud_index(__START_KERNEL_map + PMD_SIZE)].pud);
-	copy_page(level2_fixmap_pgt, l2);
-	/* Note that we don't do anything with level1_fixmap_pgt which
-	 * we don't need. */
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 		/* Make pagetable pieces RO */
 		set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
-- 
1.9.1

