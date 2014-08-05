Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaHEOos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:44:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaHEOoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:44:46 -0400
Date: Tue, 5 Aug 2014 15:44:39 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
Message-ID: <20140805144439.GW10819@suse.de>
References: <53DD5F20.8010507@oracle.com>
 <alpine.LSU.2.11.1408040418500.3406@eggly.anvils>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408040418500.3406@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Mon, Aug 04, 2014 at 04:40:38AM -0700, Hugh Dickins wrote:
> On Sat, 2 Aug 2014, Sasha Levin wrote:
> 
> > Hi all,
> > 
> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > kernel, I've stumbled on the following spew:
> > 
> > [ 2957.087977] BUG: unable to handle kernel paging request at ffffea0003480008
> > [ 2957.088008] IP: unmap_page_range (mm/memory.c:1132 mm/memory.c:1256 mm/memory.c:1277 mm/memory.c:1301)
> > [ 2957.088024] PGD 7fffc6067 PUD 7fffc5067 PMD 0
> > [ 2957.088041] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [ 2957.088087] Dumping ftrace buffer:
> > [ 2957.088266]    (ftrace buffer empty)
> > [ 2957.088279] Modules linked in:
> > [ 2957.088293] CPU: 2 PID: 15417 Comm: trinity-c200 Not tainted 3.16.0-rc7-next-20140801-sasha-00047-gd6ce559 #990
> > [ 2957.088301] task: ffff8807a8c50000 ti: ffff880739fb4000 task.ti: ffff880739fb4000
> > [ 2957.088320] RIP: unmap_page_range (mm/memory.c:1132 mm/memory.c:1256 mm/memory.c:1277 mm/memory.c:1301)
> > [ 2957.088328] RSP: 0018:ffff880739fb7c58  EFLAGS: 00010246
> > [ 2957.088336] RAX: 0000000000000000 RBX: ffff880eb2bdbed8 RCX: dfff971b42800000
> > [ 2957.088343] RDX: 1ffff100e73f6fc4 RSI: 00007f00e85db000 RDI: ffffea0003480008
> > [ 2957.088350] RBP: ffff880739fb7d58 R08: 0000000000000001 R09: 0000000000b6e000
> > [ 2957.088357] R10: 0000000000000000 R11: 0000000000000001 R12: ffffea0003480000
> > [ 2957.088365] R13: 00000000d2000700 R14: 00007f00e85dc000 R15: 00007f00e85db000
> > [ 2957.088374] FS:  00007f00e85d8700(0000) GS:ffff88177fa00000(0000) knlGS:0000000000000000
> > [ 2957.088381] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 2957.088387] CR2: ffffea0003480008 CR3: 00000007a802a000 CR4: 00000000000006a0
> > [ 2957.088406] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [ 2957.088413] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> > [ 2957.088416] Stack:
> > [ 2957.088432]  ffff88171726d570 0000000000000010 0000000000000008 00000000d2000730
> > [ 2957.088450]  0000000019d00250 00007f00e85dc000 ffff880f9d311900 ffff880739fb7e20
> > [ 2957.088466]  ffff8807a8c507a0 ffff8807a8c50000 ffff8807a75fe000 ffff8807ceaa7a10
> > [ 2957.088469] Call Trace:
> > [ 2957.088490] unmap_single_vma (mm/memory.c:1348)
> > [ 2957.088505] unmap_vmas (mm/memory.c:1375 (discriminator 3))
> > [ 2957.088520] unmap_region (mm/mmap.c:2386 (discriminator 4))
> > [ 2957.088542] ? vma_rb_erase (mm/mmap.c:454 include/linux/rbtree_augmented.h:219 include/linux/rbtree_augmented.h:227 mm/mmap.c:493)
> > [ 2957.088559] ? vmacache_update (mm/vmacache.c:61)
> > [ 2957.088572] do_munmap (mm/mmap.c:2581)
> > [ 2957.088583] vm_munmap (mm/mmap.c:2596)
> > [ 2957.088595] SyS_munmap (mm/mmap.c:2601)
> > [ 2957.088616] tracesys (arch/x86/kernel/entry_64.S:541)
> > [ 2957.088770] Code: ff ff e8 f9 5f 07 00 48 8b 45 90 80 48 18 01 4d 85 e4 0f 84 8b fe ff ff 45 84 ed 0f 85 fc 03 00 00 49 8d 7c 24 08 e8 b5 67 07 00 <41> f6 44 24 08 01 0f 84 29 02 00 00 83 6d c8 01 4c 89 e7 e8 bd
> > All code
> > ========
> >    0:	ff                   	(bad)
> >    1:	ff e8                	ljmpq  *<internal disassembler error>
> >    3:	f9                   	stc
> >    4:	5f                   	pop    %rdi
> >    5:	07                   	(bad)
> >    6:	00 48 8b             	add    %cl,-0x75(%rax)
> >    9:	45 90                	rex.RB xchg %eax,%r8d
> >    b:	80 48 18 01          	orb    $0x1,0x18(%rax)
> >    f:	4d 85 e4             	test   %r12,%r12
> >   12:	0f 84 8b fe ff ff    	je     0xfffffffffffffea3
> >   18:	45 84 ed             	test   %r13b,%r13b
> >   1b:	0f 85 fc 03 00 00    	jne    0x41d
> >   21:	49 8d 7c 24 08       	lea    0x8(%r12),%rdi
> >   26:	e8 b5 67 07 00       	callq  0x767e0
> >   2b:*	41 f6 44 24 08 01    	testb  $0x1,0x8(%r12)		<-- trapping instruction
> >   31:	0f 84 29 02 00 00    	je     0x260
> >   37:	83 6d c8 01          	subl   $0x1,-0x38(%rbp)
> >   3b:	4c 89 e7             	mov    %r12,%rdi
> >   3e:	e8                   	.byte 0xe8
> >   3f:	bd                   	.byte 0xbd
> 
> This differs in which functions got inlined (unmap_page_range showing up
> in place of zap_pte_range), but this is the same "if (PageAnon(page))"
> that Sasha reported in the "hang in shmem_fallocate" thread on June 26th.
> 
> I can see what it is now, and here is most of a patch (which I don't
> expect to satisfy Trinity yet); at this point I think I had better
> hand it over to Mel, to complete or to discard.
> 
> [INCOMPLETE PATCH] x86,mm: fix pte_special versus pte_numa
> 
> Sasha Levin has shown oopses on ffffea0003480048 and ffffea0003480008
> at mm/memory.c:1132, running Trinity on different 3.16-rc-next kernels:
> where zap_pte_range() checks page->mapping to see if PageAnon(page).
> 
> Those addresses fit struct pages for pfns d2001 and d2000, and in each
> dump a register or a stack slot showed d2001730 or d2000730: pte flags
> 0x730 are PCD ACCESSED PROTNONE SPECIAL IOMAP; and Sasha's e820 map has
> a hole between cfffffff and 100000000, which would need special access.
> 
> Commit c46a7c817e66 ("x86: define _PAGE_NUMA by reusing software bits on
> the PMD and PTE levels") has broken vm_normal_page(): a PROTNONE SPECIAL
> pte no longer passes the pte_special() test, so zap_pte_range() goes on
> to try to access a non-existent struct page.
> 

:(

> Fix this by refining pte_special() (SPECIAL with PRESENT or PROTNONE)
> to complement pte_numa() (SPECIAL with neither PRESENT nor PROTNONE).
> 
> It's unclear why c46a7c817e66 added pte_numa() test to vm_normal_page(),
> and moved its is_zero_pfn() test from slow to fast path: I suspect both
> were papering over PROT_NONE issues seen with inadequate pte_special().
> Revert vm_normal_page() to how it was before, relying on pte_special().
> 

Rather than answering directly I updated your changelog

    Fix this by refining pte_special() (SPECIAL with PRESENT or PROTNONE)
    to complement pte_numa() (SPECIAL with neither PRESENT nor PROTNONE).

    A hint that this was a problem was that c46a7c817e66 added pte_numa()
    test to vm_normal_page(), and moved its is_zero_pfn() test from slow to
    fast path: This was papering over a pte_special() snag when the zero
    page was encountered during zap. This patch reverts vm_normal_page()
    to how it was before, relying on pte_special().

> I find it confusing, that the only example of ARCH_USES_NUMA_PROT_NONE
> no longer uses PROTNONE for NUMA, but SPECIAL instead: update the
> asm-generic comment a little, but that config option remains unhelpful.
> 

ARCH_USES_NUMA_PROT_NONE should have been sent to the farm at the same time
as that patch and by rights unified with the powerpc helpers. With the new
_PAGE_NUMA bit, there is no reason they should have different implementations
of pte_numa and related functions. Unfortunately unifying them is a little
problematic due to differences in fundamental types. It could be done with
#defines but I'm attaching a preliminary prototype to illustrate the issue.

> But more seriously, I think this patch is incomplete: aren't there
> other places which need to be handling PROTNONE along with PRESENT?
> For example, pte_mknuma() clears _PAGE_PRESENT and sets _PAGE_NUMA,
> but on a PROT_NONE area, I think that will now make it pte_special()?
> So it ought to clear _PAGE_PROTNONE too.  Or maybe we can never
> pte_mknuma() on a PROT_NONE area - there would be no point?
> 

We are depending on the fact that inaccessible VMAs are skipped by the
NUMA hinting scanner.

> Around here I began to wonder if it was just a mistake to have deserted
> the PROTNONE for NUMA model: I know Linus had a strong reaction against
> it, and I've never delved into its drawbacks myself; but bringing yet
> another (SPECIAL) flag into the game is not an obvious improvement.
> Should we just revert c46a7c817e66, or would that be a mistake?
> 

It's replacing one type of complexity with another. The downside is that
_PAGE_NUMA == _PAGE_PROTNONE puts subtle traps all over the core for
powerpc to fall foul of.

I'm attaching a preliminary pair of patches. The first which deals with
ARCH_USES_NUMA_PROT_NONE and the second which is yours with a revised
changelog. I'm adding Aneesh to the cc to look at the powerpc portion of
the first patch.

-- 
Mel Gorman
SUSE Labs

--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename=0001

>From d0c77a2b497da46c52792ead066d461e5111a594 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mgorman@suse.de>
Date: Tue, 5 Aug 2014 12:06:50 +0100
Subject: [PATCH] mm: Remove misleading ARCH_USES_NUMA_PROT_NONE

ARCH_USES_NUMA_PROT_NONE was defined for architectures that implemented
_PAGE_NUMA using _PROT_NONE. This saved using an additional PTE bit and
relied on the fact that PROT_NONE vmas were skipped by the NUMA hinting
fault scanner. This was found to be conceptually confusing with a lot of
implicit assumptions and it was asked that an alternative be found.

Commit c46a7c81 "x86: define _PAGE_NUMA by reusing software bits on the
PMD and PTE levels" redefined _PAGE_NUMA on x86 to be one of the swap
PTE bits and shrunk the maximum possible swap size but it did not go far
enough. There are no architectures that reuse _PROT_NONE as _PROT_NUMA
but the relics still exist.

This patch removes ARCH_USES_NUMA_PROT_NONE and removes some unnecessary
duplication in powerpc vs the generic implementation by defining the types
the core NUMA helpers expected to exist from x86 with their ppc64 equivalent.
The unification for ppc64 is less than ideal because types do not exist
that the "generic" code expects to. This patch works around the problem
but it would be preferred if the powerpc people would look at this to see
if they have opinions on what might suit them better.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/powerpc/include/asm/pgtable.h | 55 ++++++++------------------------------
 arch/x86/Kconfig                   |  1 -
 include/asm-generic/pgtable.h      | 35 ++++++++++++------------
 init/Kconfig                       | 11 --------
 4 files changed, 29 insertions(+), 73 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index d98c1ec..47d3f8f 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -38,7 +38,6 @@ static inline int pte_none(pte_t pte)		{ return (pte_val(pte) & ~_PTE_NONE_MASK)
 static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PAGE_PROT_BITS); }
 
 #ifdef CONFIG_NUMA_BALANCING
-
 static inline int pte_present(pte_t pte)
 {
 	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
@@ -50,37 +49,6 @@ static inline int pte_present_nonuma(pte_t pte)
 	return pte_val(pte) & (_PAGE_PRESENT);
 }
 
-#define pte_numa pte_numa
-static inline int pte_numa(pte_t pte)
-{
-	return (pte_val(pte) &
-		(_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
-}
-
-#define pte_mknonnuma pte_mknonnuma
-static inline pte_t pte_mknonnuma(pte_t pte)
-{
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
-}
-
 #define ptep_set_numa ptep_set_numa
 static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
 				 pte_t *ptep)
@@ -92,12 +60,6 @@ static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
 	return;
 }
 
-#define pmd_numa pmd_numa
-static inline int pmd_numa(pmd_t pmd)
-{
-	return pte_numa(pmd_pte(pmd));
-}
-
 #define pmdp_set_numa pmdp_set_numa
 static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
 				 pmd_t *pmdp)
@@ -109,16 +71,21 @@ static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
 	return;
 }
 
-#define pmd_mknonnuma pmd_mknonnuma
-static inline pmd_t pmd_mknonnuma(pmd_t pmd)
+/*
+ * Generic NUMA pte helpers expect pteval_t and pmdval_t types to exist
+ * which was inherited from x86. For the purposes of powerpc pte_basic_t is
+ * equivalent
+ */
+#define pteval_t pte_basic_t
+#define pmdval_t pmd_t
+static inline pteval_t pte_flags(pte_t pte)
 {
-	return pte_pmd(pte_mknonnuma(pmd_pte(pmd)));
+	return pte_val(pte) & PAGE_PROT_BITS;
 }
 
-#define pmd_mknuma pmd_mknuma
-static inline pmd_t pmd_mknuma(pmd_t pmd)
+static inline pteval_t pmd_flags(pte_t pte)
 {
-	return pte_pmd(pte_mknuma(pmd_pte(pmd)));
+	return pmd_val(pte) & PAGE_PROT_BITS;
 }
 
 # else
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d24887b..0a3f32b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -28,7 +28,6 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
 	select ARCH_SUPPORTS_INT128 if X86_64
-	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_PCSPKR_PLATFORM
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 53b2acc..53294fb 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -660,12 +660,21 @@ static inline int pmd_trans_unstable(pmd_t *pmd)
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-#ifdef CONFIG_ARCH_USES_NUMA_PROT_NONE
+
+/*
+ * _PAGE_NUMA distinguishes between an unmapped page table entry, an entry that
+ * is protected for PROT_NONE and a NUMA hinting fault entry. If the
+ * architecture defines __PAGE_PROTNONE then take it into account. As this is
+ * not universally the case we are relying on the NUMA hinting scanner to skip
+ * inaccessible VMAs.
+ */
+#ifdef _PAGE_PROTNONE
+#define _PAGE_NUMA_PROTNONE _PAGE_PROTNONE
+#else
+#define _PAGE_NUMA_PROTNONE 0
+#endif
+
 /*
- * _PAGE_NUMA works identical to _PAGE_PROTNONE (it's actually the
- * same bit too). It's set only when _PAGE_PRESET is not set and it's
- * never set if _PAGE_PRESENT is set.
- *
  * pte/pmd_present() returns true if pte/pmd_numa returns true. Page
  * fault triggers on those regions if pte/pmd_numa returns true
  * (because _PAGE_PRESENT is not set).
@@ -674,7 +683,7 @@ static inline int pmd_trans_unstable(pmd_t *pmd)
 static inline int pte_numa(pte_t pte)
 {
 	return (pte_flags(pte) &
-		(_PAGE_NUMA|_PAGE_PROTNONE|_PAGE_PRESENT)) == _PAGE_NUMA;
+		(_PAGE_NUMA|_PAGE_NUMA_PROTNONE|_PAGE_PRESENT)) == _PAGE_NUMA;
 }
 #endif
 
@@ -682,7 +691,7 @@ static inline int pte_numa(pte_t pte)
 static inline int pmd_numa(pmd_t pmd)
 {
 	return (pmd_flags(pmd) &
-		(_PAGE_NUMA|_PAGE_PROTNONE|_PAGE_PRESENT)) == _PAGE_NUMA;
+		(_PAGE_NUMA|_PAGE_NUMA_PROTNONE|_PAGE_PRESENT)) == _PAGE_NUMA;
 }
 #endif
 
@@ -722,6 +731,8 @@ static inline pte_t pte_mknuma(pte_t pte)
 {
 	pteval_t val = pte_val(pte);
 
+	VM_BUG_ON(!pte_present(pte));
+
 	val &= ~_PAGE_PRESENT;
 	val |= _PAGE_NUMA;
 
@@ -765,16 +776,6 @@ static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
 }
 #endif
 #else
-extern int pte_numa(pte_t pte);
-extern int pmd_numa(pmd_t pmd);
-extern pte_t pte_mknonnuma(pte_t pte);
-extern pmd_t pmd_mknonnuma(pmd_t pmd);
-extern pte_t pte_mknuma(pte_t pte);
-extern pmd_t pmd_mknuma(pmd_t pmd);
-extern void ptep_set_numa(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-extern void pmdp_set_numa(struct mm_struct *mm, unsigned long addr, pmd_t *pmdp);
-#endif /* CONFIG_ARCH_USES_NUMA_PROT_NONE */
-#else
 static inline int pmd_numa(pmd_t pmd)
 {
 	return 0;
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99..60fa415 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -844,17 +844,6 @@ config ARCH_SUPPORTS_INT128
 config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	bool
 
-#
-# For architectures that are willing to define _PAGE_NUMA as _PAGE_PROTNONE
-config ARCH_WANTS_PROT_NUMA_PROT_NONE
-	bool
-
-config ARCH_USES_NUMA_PROT_NONE
-	bool
-	default y
-	depends on ARCH_WANTS_PROT_NUMA_PROT_NONE
-	depends on NUMA_BALANCING
-
 config NUMA_BALANCING_DEFAULT_ENABLED
 	bool "Automatically enable NUMA aware memory/task placement"
 	default y

--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename=0002

>From aacf36ad7b4bbe6d9f0afac83e8ca9b0666cb9f0 Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd@google.com>
Date: Tue, 5 Aug 2014 11:33:59 +0100
Subject: [PATCH] x86,mm: fix pte_special versus pte_numa

Sasha Levin has shown oopses on ffffea0003480048 and ffffea0003480008
at mm/memory.c:1132, running Trinity on different 3.16-rc-next kernels:
where zap_pte_range() checks page->mapping to see if PageAnon(page).

Those addresses fit struct pages for pfns d2001 and d2000, and in each
dump a register or a stack slot showed d2001730 or d2000730: pte flags
0x730 are PCD ACCESSED PROTNONE SPECIAL IOMAP; and Sasha's e820 map has
a hole between cfffffff and 100000000, which would need special access.

Commit c46a7c817e66 ("x86: define _PAGE_NUMA by reusing software bits on
the PMD and PTE levels") has broken vm_normal_page(): a PROTNONE SPECIAL
pte no longer passes the pte_special() test, so zap_pte_range() goes on
to try to access a non-existent struct page.

Fix this by refining pte_special() (SPECIAL with PRESENT or PROTNONE)
to complement pte_numa() (SPECIAL with neither PRESENT nor PROTNONE).
A hint that this was a problem was that c46a7c817e66 added pte_numa()
test to vm_normal_page(), and moved its is_zero_pfn() test from slow to
fast path: This was papering over a pte_special() snag when the zero page
was encountered during zap. This patch reverts vm_normal_page() to how it
was before, relying on pte_special().

It still appears that this patch may be incomplete: aren't there other
places which need to be handling PROTNONE along with PRESENT?  For example,
pte_mknuma() clears _PAGE_PRESENT and sets _PAGE_NUMA, but on a PROT_NONE
area, that would make it it pte_special(). This is side-stepped by the fact
that NUMA hinting faults skiped PROT_NONE VMAs and there are no grounds
where a NUMA hinting fault on a PROT_NONE VMA would be interesting.

Partially-Fixes: c46a7c817e66 ("x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels")
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Not-yet-Signed-off-by: Hugh Dickins <hughd@google.com>
Not-yet-Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: stable@vger.kernel.org [3.16]
---
 arch/x86/include/asm/pgtable.h | 9 +++++++--
 mm/memory.c                    | 7 +++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 0ec0560..230b811 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -131,8 +131,13 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	return (pte_flags(pte) & (_PAGE_PRESENT|_PAGE_SPECIAL)) ==
-				 (_PAGE_PRESENT|_PAGE_SPECIAL);
+	/*
+	 * See CONFIG_NUMA_BALANCING CONFIG_ARCH_USES_NUMA_PROT_NONE pte_numa()
+	 * in include/asm-generic/pgtable.h: on x86 we have _PAGE_BIT_NUMA ==
+	 * _PAGE_BIT_GLOBAL+1 == __PAGE_BIT_SOFTW1 == _PAGE_BIT_SPECIAL.
+	 */
+	return (pte_flags(pte) & _PAGE_SPECIAL) &&
+		(pte_flags(pte) & (_PAGE_PRESENT|_PAGE_PROTNONE));
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
diff --git a/mm/memory.c b/mm/memory.c
index 8b44f76..0a21f3d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -751,7 +751,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long pfn = pte_pfn(pte);
 
 	if (HAVE_PTE_SPECIAL) {
-		if (likely(!pte_special(pte) || pte_numa(pte)))
+		if (likely(!pte_special(pte)))
 			goto check_pfn;
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
@@ -777,15 +777,14 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		}
 	}
 
+	if (is_zero_pfn(pfn))
+		return NULL;
 check_pfn:
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
 
-	if (is_zero_pfn(pfn))
-		return NULL;
-
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
 	 * eg. VDSO mappings can cause them to exist.

--XvKFcGCOAo53UbWW--
