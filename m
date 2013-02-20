Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab3BTGmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:42:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41696 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab3BTGmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:42:10 -0500
Date: Wed, 20 Feb 2013 01:42:08 -0500 (EST)
Message-Id: <20130220.014208.192394677215729680.davem@davemloft.net>
To: mroos@ut.ee
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, rientjes@google.com, hannes@cmpxchg.org
Subject: [PATCH 3/3] sparc64: Fix tsb_grow() in atomic context.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 22:42:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If our first THP installation for an MM is via the set_pmd_at() done
during khugepaged's collapsing we'll end up in tsb_grow() trying to do
a GFP_KERNEL allocation with several locks held.

Simply using GFP_ATOMIC in this situation is not the best option
because we really can't have this fail, so we'd really like to keep
this an order 0 GFP_KERNEL allocation if possible.

Also, doing the TSB allocation from khugepaged is a really bad idea
because we'll allocate it potentially from the wrong NUMA node in that
context.

So what we do is defer the hugepage TSB allocation until the first TLB
miss we take on a hugepage.  This is slightly tricky because we have
to handle two unusual cases:

1) Taking the first hugepage TLB miss in the window trap handler.
   We'll call the winfix_trampoline when that is detected.

2) An initial TSB allocation via TLB miss races with a hugetlb
   fault on another cpu running the same MM.  We handle this by
   unconditionally loading the TSB we see into the current cpu
   even if it's non-NULL at hugetlb_setup time.

Reported-by: Meelis Roos <mroos@ut.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/hugetlb.h |  1 -
 arch/sparc/include/asm/page_64.h |  4 ++--
 arch/sparc/kernel/tsb.S          | 39 +++++++++++++++++++++++++++++++++++----
 arch/sparc/mm/fault_64.c         |  9 +++++++--
 arch/sparc/mm/init_64.c          | 24 +++++++++++++++++++-----
 arch/sparc/mm/tlb.c              | 11 +++++++++--
 6 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/include/asm/hugetlb.h b/arch/sparc/include/asm/hugetlb.h
index 9661e9b..7eb57d2 100644
--- a/arch/sparc/include/asm/hugetlb.h
+++ b/arch/sparc/include/asm/hugetlb.h
@@ -12,7 +12,6 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 
 static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
 {
-	hugetlb_setup(mm);
 }
 
 static inline int is_hugepage_only_range(struct mm_struct *mm,
diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index 4b39f74..e155388 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -27,8 +27,8 @@
 #ifndef __ASSEMBLY__
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
-struct mm_struct;
-extern void hugetlb_setup(struct mm_struct *mm);
+struct pt_regs;
+extern void hugetlb_setup(struct pt_regs *regs);
 #endif
 
 #define WANT_PAGE_VIRTUAL
diff --git a/arch/sparc/kernel/tsb.S b/arch/sparc/kernel/tsb.S
index d4bdc7a..a313e4a 100644
--- a/arch/sparc/kernel/tsb.S
+++ b/arch/sparc/kernel/tsb.S
@@ -136,12 +136,43 @@ tsb_miss_page_table_walk_sun4v_fastpath:
 	 nop
 
 	/* It is a huge page, use huge page TSB entry address we
-	 * calculated above.
+	 * calculated above.  If the huge page TSB has not been
+	 * allocated, setup a trap stack and call hugetlb_setup()
+	 * to do so, then return from the trap to replay the TLB
+	 * miss.
+	 *
+	 * This is necessary to handle the case of transparent huge
+	 * pages where we don't really have a non-atomic context
+	 * in which to allocate the hugepage TSB hash table.  When
+	 * the 'mm' faults in the hugepage for the first time, we
+	 * thus handle it here.  This also makes sure that we can
+	 * allocate the TSB hash table on the correct NUMA node.
 	 */
 	TRAP_LOAD_TRAP_BLOCK(%g7, %g2)
-	ldx		[%g7 + TRAP_PER_CPU_TSB_HUGE_TEMP], %g2
-	cmp		%g2, -1
-	movne		%xcc, %g2, %g1
+	ldx		[%g7 + TRAP_PER_CPU_TSB_HUGE_TEMP], %g1
+	cmp		%g1, -1
+	bne,pt		%xcc, 60f
+	 nop
+
+661:	rdpr		%pstate, %g5
+	wrpr		%g5, PSTATE_AG | PSTATE_MG, %pstate
+	.section	.sun4v_2insn_patch, "ax"
+	.word		661b
+	SET_GL(1)
+	nop
+	.previous
+
+	rdpr	%tl, %g3
+	cmp	%g3, 1
+	bne,pn	%xcc, winfix_trampoline
+	 nop
+	ba,pt	%xcc, etrap
+	 rd	%pc, %g7
+	call	hugetlb_setup
+	 add	%sp, PTREGS_OFF, %o0
+	ba,pt	%xcc, rtrap
+	 nop
+
 60:
 #endif
 
diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index 097aee7..5062ff3 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -472,8 +472,13 @@ good_area:
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
 	mm_rss = mm->context.huge_pte_count;
 	if (unlikely(mm_rss >
-		     mm->context.tsb_block[MM_TSB_HUGE].tsb_rss_limit))
-		tsb_grow(mm, MM_TSB_HUGE, mm_rss);
+		     mm->context.tsb_block[MM_TSB_HUGE].tsb_rss_limit)) {
+		if (mm->context.tsb_block[MM_TSB_HUGE].tsb)
+			tsb_grow(mm, MM_TSB_HUGE, mm_rss);
+		else
+			hugetlb_setup(regs);
+
+	}
 #endif
 	return;
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 0d0bc39..82bbf04 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2718,14 +2718,28 @@ static void context_reload(void *__data)
 		load_secondary_context(mm);
 }
 
-void hugetlb_setup(struct mm_struct *mm)
+void hugetlb_setup(struct pt_regs *regs)
 {
-	struct tsb_config *tp = &mm->context.tsb_block[MM_TSB_HUGE];
+	struct mm_struct *mm = current->mm;
+	struct tsb_config *tp;
 
-	if (likely(tp->tsb != NULL))
-		return;
+	if (in_atomic() || !mm) {
+		const struct exception_table_entry *entry;
+
+		entry = search_exception_tables(regs->tpc);
+		if (entry) {
+			regs->tpc = entry->fixup;
+			regs->tnpc = regs->tpc + 4;
+			return;
+		}
+		pr_alert("Unexpected HugeTLB setup in atomic context.\n");
+		die_if_kernel("HugeTSB in atomic", regs);
+	}
+
+	tp = &mm->context.tsb_block[MM_TSB_HUGE];
+	if (likely(tp->tsb == NULL))
+		tsb_grow(mm, MM_TSB_HUGE, 0);
 
-	tsb_grow(mm, MM_TSB_HUGE, 0);
 	tsb_context_switch(mm);
 	smp_tsb_sync(mm);
 
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 3e8fec3..ba6ae7f 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -135,8 +135,15 @@ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			mm->context.huge_pte_count++;
 		else
 			mm->context.huge_pte_count--;
-		if (mm->context.huge_pte_count == 1)
-			hugetlb_setup(mm);
+
+		/* Do not try to allocate the TSB hash table if we
+		 * don't have one already.  We have various locks held
+		 * and thus we'll end up doing a GFP_KERNEL allocation
+		 * in an atomic context.
+		 *
+		 * Instead, we let the first TLB miss on a hugepage
+		 * take care of this.
+		 */
 	}
 
 	if (!pmd_none(orig)) {
-- 
1.8.1.2

