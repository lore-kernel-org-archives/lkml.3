Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab3KMIQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:16:47 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:35239 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759290Ab3KMIQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:16:31 -0500
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 2/2] s390/mm,tlb: race of lazy TLB flush vs. recreation of TLB entries
Date: Wed, 13 Nov 2013 09:16:14 +0100
Message-Id: <1384330574-18418-3-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111308-0542-0000-0000-0000070BD6B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git commit 050eef364ad70059 "[S390] fix tlb flushing vs. concurrent
/proc accesses" introduced the attach counter to avoid using the
mm_users value to decide between IPTE for every PTE and lazy TLB
flushing with IDTE. That fixed the problem with mm_users but it
introduced another subtle race, fortunately one that is very hard
to hit.
The background is the requirement of the architecture that a valid
PTE may not be changed while it can be used concurrently by another
cpu. The decision between IPTE and lazy TLB flushing needs to be
done while the PTE is still valid. Now if the virtual cpu is
temporarily stopped after the decision to use lazy TLB flushing but
before the invalid bit of the PTE has been set, another cpu can attach
the mm, find that flush_mm is set, do the IDTE, return to userspace,
and recreate a TLB that uses the PTE in question. When the first,
stopped cpu continues it will change the PTE while it is attached on
another cpu. The first cpu will do another IDTE shortly after the
modification of the PTE which makes the race window quite short.

To fix this race the CPU that wants to attach the address space of a
user space thread needs to wait for the end of the PTE modification.
To do that the number of concurrent TLB flushers for an mm is tracked
in the upper 16 bits of the attach_count and finish_switch_mm is used
to wait for the end of the flush operation if required.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/include/asm/mmu_context.h |   35 +++++++++++++++++---
 arch/s390/include/asm/pgtable.h     |   60 +++++++++++++++++++++--------------
 arch/s390/include/asm/thread_info.h |    2 ++
 3 files changed, 69 insertions(+), 28 deletions(-)

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 5d1f950..e91afeb 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -48,13 +48,38 @@ static inline void update_mm(struct mm_struct *mm, struct task_struct *tsk)
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
-	cpumask_set_cpu(smp_processor_id(), mm_cpumask(next));
-	update_mm(next, tsk);
+	int cpu = smp_processor_id();
+
+	if (prev == next)
+		return;
+	if (atomic_inc_return(&next->context.attach_count) >> 16) {
+		/* Delay update_mm until all TLB flushes are done. */
+		set_tsk_thread_flag(tsk, TIF_TLB_WAIT);
+	} else {
+		cpumask_set_cpu(cpu, mm_cpumask(next));
+		update_mm(next, tsk);
+		if (next->context.flush_mm)
+			/* Flush pending TLBs */
+			__tlb_flush_mm(next);
+	}
 	atomic_dec(&prev->context.attach_count);
 	WARN_ON(atomic_read(&prev->context.attach_count) < 0);
-	atomic_inc(&next->context.attach_count);
-	/* Check for TLBs not flushed yet */
-	__tlb_flush_mm_lazy(next);
+}
+
+#define finish_switch_mm finish_switch_mm
+static inline void finish_switch_mm(struct mm_struct *mm,
+				    struct task_struct *tsk)
+{
+	if (!test_and_clear_tsk_thread_flag(tsk, TIF_TLB_WAIT))
+		return;
+
+	while (atomic_read(&mm->context.attach_count) >> 16)
+		cpu_relax();
+
+	cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
+	update_mm(mm, tsk);
+	if (mm->context.flush_mm)
+		__tlb_flush_mm(mm);
 }
 
 #define enter_lazy_tlb(mm,tsk)	do { } while (0)
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2204400..fc4bb82 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1034,30 +1034,41 @@ static inline int ptep_test_and_clear_user_young(struct mm_struct *mm,
 
 static inline void __ptep_ipte(unsigned long address, pte_t *ptep)
 {
-	if (!(pte_val(*ptep) & _PAGE_INVALID)) {
+	unsigned long pto = (unsigned long) ptep;
+
 #ifndef CONFIG_64BIT
-		/* pto must point to the start of the segment table */
-		pte_t *pto = (pte_t *) (((unsigned long) ptep) & 0x7ffffc00);
-#else
-		/* ipte in zarch mode can do the math */
-		pte_t *pto = ptep;
+	/* pto in ESA mode must point to the start of the segment table */
+	pto &= 0x7ffffc00;
 #endif
-		asm volatile(
-			"	ipte	%2,%3"
-			: "=m" (*ptep) : "m" (*ptep),
-			  "a" (pto), "a" (address));
-	}
+	/* Invalidation + global TLB flush for the pte */
+	asm volatile(
+		"	ipte	%2,%3"
+		: "=m" (*ptep) : "m" (*ptep), "a" (pto), "a" (address));
+}
+
+static inline void ptep_flush_direct(struct mm_struct *mm,
+				     unsigned long address, pte_t *ptep)
+{
+	if (pte_val(*ptep) & _PAGE_INVALID)
+		return;
+	__ptep_ipte(address, ptep);
 }
 
 static inline void ptep_flush_lazy(struct mm_struct *mm,
 				   unsigned long address, pte_t *ptep)
 {
-	int active = (mm == current->active_mm) ? 1 : 0;
+	int active, count;
 
-	if (atomic_read(&mm->context.attach_count) > active)
-		__ptep_ipte(address, ptep);
-	else
+	if (pte_val(*ptep) & _PAGE_INVALID)
+		return;
+	active = (mm == current->active_mm) ? 1 : 0;
+	count = atomic_add_return(0x10000, &mm->context.attach_count);
+	if ((count & 0xffff) <= active) {
+		pte_val(*ptep) |= _PAGE_INVALID;
 		mm->context.flush_mm = 1;
+	} else
+		__ptep_ipte(address, ptep);
+	atomic_sub(0x10000, &mm->context.attach_count);
 }
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
@@ -1074,7 +1085,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 	}
 
 	pte = *ptep;
-	__ptep_ipte(addr, ptep);
+	ptep_flush_direct(vma->vm_mm, addr, ptep);
 	young = pte_young(pte);
 	pte = pte_mkold(pte);
 
@@ -1145,7 +1156,6 @@ static inline pte_t ptep_modify_prot_start(struct mm_struct *mm,
 
 	pte = *ptep;
 	ptep_flush_lazy(mm, address, ptep);
-	pte_val(*ptep) |= _PAGE_INVALID;
 
 	if (mm_has_pgste(mm)) {
 		pgste = pgste_update_all(&pte, pgste);
@@ -1182,7 +1192,7 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	}
 
 	pte = *ptep;
-	__ptep_ipte(address, ptep);
+	ptep_flush_direct(vma->vm_mm, address, ptep);
 	pte_val(*ptep) = _PAGE_INVALID;
 
 	if (mm_has_pgste(vma->vm_mm)) {
@@ -1263,7 +1273,7 @@ static inline int ptep_set_access_flags(struct vm_area_struct *vma,
 		pgste = pgste_ipte_notify(vma->vm_mm, address, ptep, pgste);
 	}
 
-	__ptep_ipte(address, ptep);
+	ptep_flush_direct(vma->vm_mm, address, ptep);
 
 	if (mm_has_pgste(vma->vm_mm)) {
 		pgste_set_pte(ptep, entry);
@@ -1447,12 +1457,16 @@ static inline pmd_t pmd_mkwrite(pmd_t pmd)
 static inline void pmdp_flush_lazy(struct mm_struct *mm,
 				   unsigned long address, pmd_t *pmdp)
 {
-	int active = (mm == current->active_mm) ? 1 : 0;
+	int active, count;
 
-	if ((atomic_read(&mm->context.attach_count) & 0xffff) > active)
-		__pmd_idte(address, pmdp);
-	else
+	active = (mm == current->active_mm) ? 1 : 0;
+	count = atomic_add_return(0x10000, &mm->context.attach_count);
+	if ((count & 0xffff) <= active) {
+		pmd_val(*pmdp) |= _SEGMENT_ENTRY_INVALID;
 		mm->context.flush_mm = 1;
+	} else
+		__pmd_idte(address, pmdp);
+	atomic_sub(0x10000, &mm->context.attach_count);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index eb5f64d..7991a11 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -81,6 +81,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_TLB_WAIT		4	/* wait for TLB flush completion */
 #define TIF_PER_TRAP		6	/* deliver sigtrap on return to user */
 #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
@@ -96,6 +97,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_TLB_WAIT		(1<<TIF_TLB_WAIT)
 #define _TIF_PER_TRAP		(1<<TIF_PER_TRAP)
 #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-- 
1.7.9.5

