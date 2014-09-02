Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaIBLCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:02:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27914 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaIBLCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:02:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,448,1406592000"; 
   d="scan'208";a="167290470"
Message-ID: <5405A3A7.2050406@citrix.com>
Date: Tue, 2 Sep 2014 12:01:59 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] x86/xen: Fix 64bit kernel pagetable setup
 of PV guests
References: <1409325477-2186-1-git-send-email-stefan.bader@canonical.com> <5404AE0F.1010207@citrix.com>
In-Reply-To: <5404AE0F.1010207@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/14 18:34, David Vrabel wrote:
> On 29/08/14 16:17, Stefan Bader wrote:
>>
>> This change might not be the fully correct approach as it basically
>> removes the pre-set page table entry for the fixmap that is compile
>> time set (level2_fixmap_pgt[506]->level1_fixmap_pgt). For one the
>> level1 page table is not yet declared in C headers (that might be
>> fixed). But also with the current bug, it was removed, too. Since
>> the Xen mappings for level2_kernel_pgt only covered kernel + initrd
>> and some Xen data this did never reach that far. And still, something
>> does create entries at level2_fixmap_pgt[506..507]. So it should be
>> ok. At least I was able to successfully boot a kernel with 1G kernel
>> image size without any vmalloc whinings.
> [...]
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -1902,8 +1902,22 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>>  		/* L3_i[0] -> level2_ident_pgt */
>>  		convert_pfn_mfn(level3_ident_pgt);
>>  		/* L3_k[510] -> level2_kernel_pgt
>> -		 * L3_i[511] -> level2_fixmap_pgt */
>> +		 * L3_k[511] -> level2_fixmap_pgt */
>>  		convert_pfn_mfn(level3_kernel_pgt);
>> +
>> +		/* level2_fixmap_pgt contains a single entry for the
>> +		 * fixmap area at offset 506. The correct way would
>> +		 * be to convert level2_fixmap_pgt to mfn and set the
>> +		 * level1_fixmap_pgt (which is completely empty) to RO,
>> +		 * too. But currently this page table is not declared,
>> +		 * so it would be a bit of voodoo to get its address.
>> +		 * And also the fixmap entry was never set due to using
>> +		 * the wrong l2 when getting Xen's tables. So let's just
>> +		 * just nuke it.
>> +		 * This orphans level1_fixmap_pgt, but that was basically
>> +		 * done before the change as well.
>> +		 */
>> +		memset(level2_fixmap_pgt, 0, 512*sizeof(long));
> 
> level2_fixmap_pgt etc. are defined for the benefit of Xen only so I
> think you should add an extern for level1_fixmap_pgt and fix this up
> properly.
> 
> It might not matter now, but it might in the future...

I found some time to look into this and test it.  Including without
enabling KSLAR, but reproing the vmalloc failure with a large (800 MiB
module).

I've clarified the change description, can you review my edits?

Thanks for investigating and fixing this!

David

8<------------------------------
x86/xen: don't copy junk into kernel page tables

When RANDOMIZE_BASE (KASLR) is enabled; or the sum of all loaded
modules exceeds 512 MiB, then loading modules fails with a warning
(and hence a vmalloc allocation failure) because the PTEs for the
newly-allocated vmalloc address space are not zero.

  WARNING: CPU: 0 PID: 494 at linux/mm/vmalloc.c:128
           vmap_page_range_noflush+0x2a1/0x360()

This is caused by xen_setup_kernel_pagetables() copying junk into the
page tables (to level2_fixmap_pgt), overwriting many non-present
entries.

Without KASLR, the normal kernel image size only covers the first half
of level2_kernel_pgt and module space starts after that.

L4[511]->level3_kernel_pgt[510]->level2_kernel_pgt[  0..255]->kernel
                                                  [256..511]->module
                          [511]->level2_fixmap_pgt[  0..505]->module

This allows 512 MiB of of module vmalloc space to be used before
having to use the corrupted level2_fixmap_pgt entries.

With KASLR enabled, the kernel image uses the full PUD range of 1G and
module space starts in the level2_fixmap_pgt. So basically:

L4[511]->level3_kernel_pgt[510]->level2_kernel_pgt[0..511]->kernel
                          [511]->level2_fixmap_pgt[0..505]->module

And now no module vmalloc space can be used without using the corrupt
level2_fixmap_pgt entries.

Fix this by properly converting the level2_fixmap_pgt entries to MFNs,
and setting level1_fixmap_pgt as read-only.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/pgtable_64.h |    1 +
 arch/x86/xen/mmu.c                |   27 ++++++++++++---------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 5be9063..3874693 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -19,6 +19,7 @@ extern pud_t level3_ident_pgt[512];
 extern pmd_t level2_kernel_pgt[512];
 extern pmd_t level2_fixmap_pgt[512];
 extern pmd_t level2_ident_pgt[512];
+extern pte_t level1_fixmap_pgt[512];
 extern pgd_t init_level4_pgt[];
 
 #define swapper_pg_dir init_level4_pgt
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8a1201..16fb009 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1866,12 +1866,11 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
  *
  * We can construct this by grafting the Xen provided pagetable into
  * head_64.S's preconstructed pagetables.  We copy the Xen L2's into
- * level2_ident_pgt, level2_kernel_pgt and level2_fixmap_pgt.  This
- * means that only the kernel has a physical mapping to start with -
- * but that's enough to get __va working.  We need to fill in the rest
- * of the physical mapping once some sort of allocator has been set
- * up.
- * NOTE: for PVH, the page tables are native.
+ * level2_ident_pgt, and level2_kernel_pgt.  This means that only the
+ * kernel has a physical mapping to start with - but that's enough to
+ * get __va working.  We need to fill in the rest of the physical
+ * mapping once some sort of allocator has been set up.  NOTE: for
+ * PVH, the page tables are native.
  */
 void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
@@ -1902,8 +1901,11 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 		/* L3_i[0] -> level2_ident_pgt */
 		convert_pfn_mfn(level3_ident_pgt);
 		/* L3_k[510] -> level2_kernel_pgt
-		 * L3_i[511] -> level2_fixmap_pgt */
+		 * L3_k[511] -> level2_fixmap_pgt */
 		convert_pfn_mfn(level3_kernel_pgt);
+
+		/* L3_k[511][506] -> level1_fixmap_pgt */
+		convert_pfn_mfn(level2_fixmap_pgt);
 	}
 	/* We get [511][511] and have Xen's version of level2_kernel_pgt */
 	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
@@ -1913,21 +1915,15 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
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
@@ -1937,6 +1933,7 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 		set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
 		set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
 		set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
+		set_page_prot(level1_fixmap_pgt, PAGE_KERNEL_RO);
 
 		/* Pin down new L4 */
 		pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE,
-- 
1.7.10.4

