Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaLIPGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:06:19 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53363 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaLIPGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:06:17 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>,
        LEROY Christophe <christophe.leroy@c-s.fr>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: powerpc32: missing accessors to pgprot_t objects
In-Reply-To: <20141209101841.7D9241400D2@ozlabs.org>
References: <20141209101841.7D9241400D2@ozlabs.org>
User-Agent: Notmuch/0.19+2~g32855b9 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Dec 2014 20:36:08 +0530
Message-ID: <87bnncq2vz.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120915-0033-0000-0000-0000033C8876
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:

> On Mon, 2014-08-12 at 14:16:29 UTC, LEROY Christophe wrote:
>> Compilation with #define STRICT_MM_TYPECHECKS in arch/powerpc/include/asm/page.h
>> fails due to missing use of pgprot_val() when using pgprot_t objects.
>
> Hmm, looks like 64 bit doesn't build either.
>
> Aneesh I think you added this, mind fixing it up?
>
> In file included from ../arch/powerpc/include/asm/thread_info.h:34:0,
>                  from ../include/linux/thread_info.h:54,
>                  from ../include/asm-generic/preempt.h:4,
>                  from arch/powerpc/include/generated/asm/preempt.h:1,
>                  from ../include/linux/preempt.h:18,
>                  from ../include/linux/spinlock.h:50,
>                  from ../include/linux/mmzone.h:7,
>                  from ../include/linux/gfp.h:5,
>                  from ../include/linux/mm.h:9,
>                  from ../arch/powerpc/mm/tlb_hash64.c:25:
> ../arch/powerpc/mm/tlb_hash64.c: In function ‘__flush_hash_table_range’:
> ../arch/powerpc/include/asm/page.h:286:24: error: request for member ‘pte’ in something not a structure or union
>  #define pte_val(x) ((x).pte)
>                         ^    
> ../arch/powerpc/mm/tlb_hash64.c:219:37: note: in expansion of macro ‘pte_val’
>     trace_hugepage_invalidate(start, pte_val(pte));
>                                      ^    
> make[2]: *** [arch/powerpc/mm/tlb_hash64.o] Error 1
>

Will send a proper patch after compile testing with other configs. The
kvm hunk is really ugly, will try to rework. 

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 0aa8179..cd0ff37 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -291,11 +291,11 @@ static inline pte_t kvmppc_read_update_linux_pte(pte_t *ptep, int writing,
 	pte_t old_pte, new_pte = __pte(0);
 
 	while (1) {
-		old_pte = pte_val(*ptep);
+		old_pte = *ptep;
 		/*
 		 * wait until _PAGE_BUSY is clear then set it atomically
 		 */
-		if (unlikely(old_pte & _PAGE_BUSY)) {
+		if (unlikely(pte_val(old_pte) & _PAGE_BUSY)) {
 			cpu_relax();
 			continue;
 		}
@@ -306,16 +306,18 @@ static inline pte_t kvmppc_read_update_linux_pte(pte_t *ptep, int writing,
 			return __pte(0);
 #endif
 		/* If pte is not present return None */
-		if (unlikely(!(old_pte & _PAGE_PRESENT)))
+		if (unlikely(!(pte_val(old_pte) & _PAGE_PRESENT)))
 			return __pte(0);
 
 		new_pte = pte_mkyoung(old_pte);
 		if (writing && pte_write(old_pte))
 			new_pte = pte_mkdirty(new_pte);
 
-		if (old_pte == __cmpxchg_u64((unsigned long *)ptep, old_pte,
-					     new_pte))
+		if (pte_val(old_pte) == __cmpxchg_u64((unsigned long *)ptep,
+						      pte_val(old_pte),
+						      pte_val(new_pte))) {
 			break;
+		}
 	}
 	return new_pte;
 }
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index 26fe1ae..cc62ab9 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -278,7 +278,7 @@ extern long long virt_phys_offset;
 
 #ifndef __ASSEMBLY__
 
-#undef STRICT_MM_TYPECHECKS
+#define STRICT_MM_TYPECHECKS 1
 
 #ifdef STRICT_MM_TYPECHECKS
 /* These are used to make use of C type-checking. */
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 316f9a5..3e29088 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -77,8 +77,8 @@ static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
  * which was inherited from x86. For the purposes of powerpc pte_basic_t and
  * pmd_t are equivalent
  */
-#define pteval_t pte_basic_t
-#define pmdval_t pmd_t
+typedef unsigned long pteval_t;
+typedef unsigned long pmdval_t;
 static inline pteval_t ptenuma_flags(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_NUMA_MASK;
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index c8d709a..5162936 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -714,7 +714,7 @@ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	assert_spin_locked(&mm->page_table_lock);
 	WARN_ON(!pmd_trans_huge(pmd));
 #endif
-	trace_hugepage_set_pmd(addr, pmd);
+	trace_hugepage_set_pmd(addr, pmd_val(pmd));
 	return set_pte_at(mm, addr, pmdp_ptep(pmdp), pmd_pte(pmd));
 }
 
diff --git a/arch/powerpc/mm/tlb_hash64.c b/arch/powerpc/mm/tlb_hash64.c
index d2a94b8..c522969 100644
--- a/arch/powerpc/mm/tlb_hash64.c
+++ b/arch/powerpc/mm/tlb_hash64.c
@@ -216,7 +216,7 @@ void __flush_hash_table_range(struct mm_struct *mm, unsigned long start,
 			continue;
 		pte = pte_val(*ptep);
 		if (hugepage_shift)
-			trace_hugepage_invalidate(start, pte_val(pte));
+			trace_hugepage_invalidate(start, pte);
 		if (!(pte & _PAGE_HASHPTE))
 			continue;
 		if (unlikely(hugepage_shift && pmd_trans_huge(*(pmd_t *)pte)))

