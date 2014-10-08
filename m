Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaJHKh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:37:56 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43248 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaJHKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:37:54 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: pipe/page fault oddness.
In-Reply-To: <CA+55aFyt8euKZv8O-DMY7LE+467a_RQ38YOgF0Xh73+TseM=kQ@mail.gmail.com>
References: <20140930160510.GA15903@redhat.com> <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com> <20140930162201.GC15903@redhat.com> <20140930164047.GA18354@redhat.com> <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com> <20140930182059.GA24431@redhat.com> <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com> <alpine.LSU.2.11.1410010031070.1902@eggly.anvils> <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com> <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com> <20141002124537.GL17501@suse.de> <87d2a5f1m4.fsf@linux.vnet.ibm.com> <CA+55aFyt8euKZv8O-DMY7LE+467a_RQ38YOgF0Xh73+TseM=kQ@mail.gmail.com>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Wed, 08 Oct 2014 16:07:38 +0530
Message-ID: <87lhoq3kzx.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100810-5140-0000-0000-00000063131D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Oct 6, 2014 at 3:18 PM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>
>> Are we still looking at these options ? I could look at implementing the
>> first option which will also enable us to free up one pte bit.
>
> We definitely are. If you can test my patch (with the small follow-up
> fix), and do the necessary changes for ppc64, that would be good.
>
> I looked quickly at the ppc64 side, and it didn't look too painful.
> Using pte_protnone() instead of pte_numa() should remove move lines
> than it adds there too..
>

This is a quick hack and gets it running. With perf bench numa mem

-bash-4.2# grep numa /proc/vmstat                                                                                                                                                                                                              
numa_hit 3310633
numa_miss 0
numa_foreign 0
numa_interleave 6451
numa_local 3162369
numa_other 148264
numa_pte_updates 27708982
numa_huge_pte_updates 76987
numa_hint_faults 268439275
numa_hint_faults_local 5359216
numa_pages_migrated 3349573
-bash-4.2# 

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index d98c1ecc3266..2a9bbe4d2364 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -41,7 +41,7 @@ static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PA
 
 static inline int pte_present(pte_t pte)
 {
-	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
+	return pte_val(pte) & _PAGE_PRESENT;
 }
 
 #define pte_present_nonuma pte_present_nonuma
@@ -50,78 +50,20 @@ static inline int pte_present_nonuma(pte_t pte)
 	return pte_val(pte) & (_PAGE_PRESENT);
 }
 
-#define pte_numa pte_numa
-static inline int pte_numa(pte_t pte)
+#define pte_protnone pte_protnone
+static inline int pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) &
-		(_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
+		(_PAGE_PRESENT | _PAGE_USER)) == _PAGE_PRESENT;
 }
 
-#define pte_mknonnuma pte_mknonnuma
-static inline pte_t pte_mknonnuma(pte_t pte)
+#define pmd_protnone pmd_protnone
+static inline int pmd_protnone(pmd_t pmd)
 {
-	pte_val(pte) &= ~_PAGE_NUMA;
-	pte_val(pte) |=  _PAGE_PRESENT | _PAGE_ACCESSED;
-	return pte;
-}
-
-#define pte_mknuma pte_mknuma
-static inline pte_t pte_mknuma(pte_t pte)
-{
-	/*
-	 * We should not set _PAGE_NUMA on non present ptes. Also clear the
-	 * present bit so that hash_page will return 1 and we collect this
-	 * as numa fault.
-	 */
-	if (pte_present(pte)) {
-		pte_val(pte) |= _PAGE_NUMA;
-		pte_val(pte) &= ~_PAGE_PRESENT;
-	} else
-		VM_BUG_ON(1);
-	return pte;
+	return pte_protnone(pmd_pte(pmd));
 }
 
-#define ptep_set_numa ptep_set_numa
-static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pte_t *ptep)
-{
-	if ((pte_val(*ptep) & _PAGE_PRESENT) == 0)
-		VM_BUG_ON(1);
-
-	pte_update(mm, addr, ptep, _PAGE_PRESENT, _PAGE_NUMA, 0);
-	return;
-}
-
-#define pmd_numa pmd_numa
-static inline int pmd_numa(pmd_t pmd)
-{
-	return pte_numa(pmd_pte(pmd));
-}
-
-#define pmdp_set_numa pmdp_set_numa
-static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
-				 pmd_t *pmdp)
-{
-	if ((pmd_val(*pmdp) & _PAGE_PRESENT) == 0)
-		VM_BUG_ON(1);
-
-	pmd_hugepage_update(mm, addr, pmdp, _PAGE_PRESENT, _PAGE_NUMA);
-	return;
-}
-
-#define pmd_mknonnuma pmd_mknonnuma
-static inline pmd_t pmd_mknonnuma(pmd_t pmd)
-{
-	return pte_pmd(pte_mknonnuma(pmd_pte(pmd)));
-}
-
-#define pmd_mknuma pmd_mknuma
-static inline pmd_t pmd_mknuma(pmd_t pmd)
-{
-	return pte_pmd(pte_mknuma(pmd_pte(pmd)));
-}
-
-# else
+#else
 
 static inline int pte_present(pte_t pte)
 {
diff --git a/arch/powerpc/include/asm/pte-hash64.h b/arch/powerpc/include/asm/pte-hash64.h
index 2505d8eab15c..68d0a5d01dc3 100644
--- a/arch/powerpc/include/asm/pte-hash64.h
+++ b/arch/powerpc/include/asm/pte-hash64.h
@@ -30,7 +30,7 @@
 /*
  * Used for tracking numa faults
  */
-#define _PAGE_NUMA	0x00000010 /* Gather numa placement stats */
+//#define _PAGE_NUMA	0x00000010 /* Gather numa placement stats */
 
 
 /* No separate kernel read-only */
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 084ad54c73cd..27004431b576 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -235,7 +235,11 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 		pte_size = psize;
 		pte = lookup_linux_pte_and_update(pgdir, hva, writing,
 						  &pte_size);
-		if (pte_present(pte) && !pte_numa(pte)) {
+		/*
+		 * Skip the ptes marked for numa fault tracking in
+		 * host page table.
+		 */
+		if (pte_present(pte) && !pte_protnone(pte)) {
 			if (writing && !pte_write(pte))
 				/* make the actual HPTE be read-only */
 				ptel = hpte_make_readonly(ptel);
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 51ab9e7e6c39..b77ecac7e61f 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -393,8 +393,6 @@ good_area:
 		 * processors use the same I/D cache coherency mechanism
 		 * as embedded.
 		 */
-		if (error_code & DSISR_PROTFAULT)
-			goto bad_area;
 #endif /* CONFIG_PPC_STD_MMU */
 
 		/*
@@ -418,9 +416,6 @@ good_area:
 		flags |= FAULT_FLAG_WRITE;
 	/* a read */
 	} else {
-		/* protection fault */
-		if (error_code & 0x08000000)
-			goto bad_area;
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
 			goto bad_area;
 	}
diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index d8746684f606..89f8568bf0b5 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -39,7 +39,7 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		/*
 		 * Similar to the PMD case, NUMA hinting must take slow path
 		 */
-		if (pte_numa(pte))
+		if (pte_protnone(pte))
 			return 0;
 
 		if ((pte_val(pte) & mask) != result)
@@ -85,7 +85,7 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 			 * slowpath for accounting purposes and so that they
 			 * can be serialised against THP migration.
 			 */
-			if (pmd_numa(pmd))
+			if (pmd_protnone(pmd))
 				return 0;
 
 			if (!gup_hugepte((pte_t *)pmdp, PMD_SIZE, addr, next,

