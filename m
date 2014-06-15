Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaFONQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:16:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaFONME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:12:04 -0400
Message-Id: <20140615130154.213923590@chello.nl>
User-Agent: quilt/0.61-1
Date: Sun, 15 Jun 2014 14:47:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 10/11] qspinlock: Paravirt support
References: <20140615124657.264658593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-qspinlock-pv.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add minimal paravirt support.

The code aims for minimal impact on the native case.

On the lock side we add one jump label (asm_goto) and 4 paravirt
callee saved calls that default to NOPs. The only effects are the
extra NOPs and some pointless MOVs to accomodate the calling
convention. No register spills happen because of this (x86_64).

On the unlock side we have one paravirt callee saved call, which
defaults to the actual unlock sequence: "movb $0, (%rdi)" and a NOP.

The actual paravirt code comes in 3 parts;

 - init_node; this initializes the extra data members required for PV
   state. PV state data is kept 1 cacheline ahead of the regular data.

 - link_and_wait_node/kick_node; these are paired with the regular MCS
   queueing and are placed resp. before/after the paired MCS ops.

 - wait_head/queue_unlock; the interesting part here is finding the
   head node to kick.

Tracking the head is done in two parts, firstly the pv_wait_head will
store its cpu number in whichever node is pointed to by the tail part
of the lock word. Secondly, pv_link_and_wait_node() will propagate the
existing head from the old to the new tail node.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/paravirt.h       |   39 +++++++
 arch/x86/include/asm/paravirt_types.h |   15 ++
 arch/x86/include/asm/qspinlock.h      |   25 ++++
 arch/x86/kernel/paravirt-spinlocks.c  |   22 ++++
 arch/x86/kernel/paravirt_patch_32.c   |    7 +
 arch/x86/kernel/paravirt_patch_64.c   |    7 +
 include/asm-generic/qspinlock.h       |   11 ++
 kernel/locking/qspinlock.c            |  179 +++++++++++++++++++++++++++++++++-
 8 files changed, 302 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6/arch/x86/include/asm/paravirt.h
@@ -712,6 +712,44 @@ static inline void __set_fixmap(unsigned
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+
+static __always_inline void pv_init_node(struct mcs_spinlock *node)
+{
+	PVOP_VCALLEE1(pv_lock_ops.init_node, node);
+}
+
+static __always_inline void pv_link_and_wait_node(u32 old, struct mcs_spinlock *node)
+{
+	PVOP_VCALLEE2(pv_lock_ops.link_and_wait_node, old, node);
+}
+
+static __always_inline void pv_kick_node(struct mcs_spinlock *node)
+{
+	PVOP_VCALLEE1(pv_lock_ops.kick_node, node);
+}
+
+static __always_inline void pv_wait_head(struct qspinlock *lock)
+{
+	PVOP_VCALLEE1(pv_lock_ops.wait_head, lock);
+}
+
+static __always_inline void pv_queue_unlock(struct qspinlock *lock)
+{
+	PVOP_VCALLEE1(pv_lock_ops.queue_unlock, lock);
+}
+
+static __always_inline void pv_wait(int *ptr, int val)
+{
+	PVOP_VCALL2(pv_lock_ops.wait, ptr, val);
+}
+
+static __always_inline void pv_kick(int cpu)
+{
+	PVOP_VCALL1(pv_lock_ops.kick, cpu);
+}
+
+#else
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
 							__ticket_t ticket)
 {
@@ -723,6 +761,7 @@ static __always_inline void __ticket_unl
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
+#endif
 
 #endif
 
Index: linux-2.6/arch/x86/include/asm/paravirt_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/paravirt_types.h
+++ linux-2.6/arch/x86/include/asm/paravirt_types.h
@@ -326,6 +326,9 @@ struct pv_mmu_ops {
 			   phys_addr_t phys, pgprot_t flags);
 };
 
+struct mcs_spinlock;
+struct qspinlock;
+
 struct arch_spinlock;
 #ifdef CONFIG_SMP
 #include <asm/spinlock_types.h>
@@ -334,8 +337,20 @@ typedef u16 __ticket_t;
 #endif
 
 struct pv_lock_ops {
+#ifdef CONFIG_QUEUE_SPINLOCK
+	struct paravirt_callee_save init_node;
+	struct paravirt_callee_save link_and_wait_node;
+	struct paravirt_callee_save kick_node;
+
+	struct paravirt_callee_save wait_head;
+	struct paravirt_callee_save queue_unlock;
+
+	void (*wait)(int *ptr, int val);
+	void (*kick)(int cpu);
+#else
 	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
+#endif
 };
 
 /* This contains all the paravirt structures: we get a convenient
Index: linux-2.6/arch/x86/include/asm/qspinlock.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/qspinlock.h
+++ linux-2.6/arch/x86/include/asm/qspinlock.h
@@ -3,24 +3,45 @@
 
 #include <asm/cpufeature.h>
 #include <asm-generic/qspinlock_types.h>
+#include <asm/paravirt.h>
 
 #if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
 
-#define	queue_spin_unlock queue_spin_unlock
 /**
  * queue_spin_unlock - release a queue spinlock
  * @lock : Pointer to queue spinlock structure
  *
  * An effective smp_store_release() on the least-significant byte.
  */
-static inline void queue_spin_unlock(struct qspinlock *lock)
+static inline void native_queue_unlock(struct qspinlock *lock)
 {
 	barrier();
 	ACCESS_ONCE(*(u8 *)lock) = 0;
 }
 
+#else
+
+static inline void native_queue_unlock(struct qspinlock *lock)
+{
+	atomic_dec(&lock->val);
+}
+
 #endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */
 
+#define	queue_spin_unlock queue_spin_unlock
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+static inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	pv_queue_unlock(lock);
+}
+#else
+static inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	native_queue_unlock(lock);
+}
+#endif
+
 #define virt_queue_spin_lock virt_queue_spin_lock
 
 static inline bool virt_queue_spin_lock(struct qspinlock *lock)
Index: linux-2.6/arch/x86/kernel/paravirt-spinlocks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt-spinlocks.c
+++ linux-2.6/arch/x86/kernel/paravirt-spinlocks.c
@@ -8,11 +8,33 @@
 
 #include <asm/paravirt.h>
 
+#ifdef CONFIG_SMP
+#ifdef CONFIG_QUEUE_SPINLOCK
+void __native_queue_unlock(struct qspinlock *lock)
+{
+	native_queue_unlock(lock);
+}
+PV_CALLEE_SAVE_REGS_THUNK(__native_queue_unlock);
+#endif
+#endif
+
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
+#ifdef CONFIG_QUEUE_SPINLOCK
+	.init_node = __PV_IS_CALLEE_SAVE(paravirt_nop),
+	.link_and_wait_node = __PV_IS_CALLEE_SAVE(paravirt_nop),
+	.kick_node = __PV_IS_CALLEE_SAVE(paravirt_nop),
+
+	.wait_head = __PV_IS_CALLEE_SAVE(paravirt_nop),
+	.queue_unlock = PV_CALLEE_SAVE(__native_queue_unlock),
+
+	.wait = paravirt_nop,
+	.kick = paravirt_nop,
+#else
 	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
 	.unlock_kick = paravirt_nop,
 #endif
+#endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
Index: linux-2.6/arch/x86/kernel/paravirt_patch_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt_patch_32.c
+++ linux-2.6/arch/x86/kernel/paravirt_patch_32.c
@@ -12,6 +12,10 @@ DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %c
 DEF_NATIVE(pv_cpu_ops, clts, "clts");
 DEF_NATIVE(pv_cpu_ops, read_tsc, "rdtsc");
 
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) && defined(CONFIG_QUEUE_SPINLOCK)
+DEF_NATIVE(pv_lock_ops, queue_unlock, "movb $0, (%eax)");
+#endif
+
 unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len)
 {
 	/* arg in %eax, return in %eax */
@@ -47,6 +51,9 @@ unsigned native_patch(u8 type, u16 clobb
 		PATCH_SITE(pv_mmu_ops, write_cr3);
 		PATCH_SITE(pv_cpu_ops, clts);
 		PATCH_SITE(pv_cpu_ops, read_tsc);
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) && defined(CONFIG_QUEUE_SPINLOCK)
+		PATCH_SITE(pv_lock_ops, queue_unlock);
+#endif
 
 	patch_site:
 		ret = paravirt_patch_insns(ibuf, len, start, end);
Index: linux-2.6/arch/x86/kernel/paravirt_patch_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/paravirt_patch_64.c
+++ linux-2.6/arch/x86/kernel/paravirt_patch_64.c
@@ -22,6 +22,10 @@ DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs")
 DEF_NATIVE(, mov32, "mov %edi, %eax");
 DEF_NATIVE(, mov64, "mov %rdi, %rax");
 
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) && defined(CONFIG_QUEUE_SPINLOCK)
+DEF_NATIVE(pv_lock_ops, queue_unlock, "movb $0, (%rdi)");
+#endif
+
 unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len)
 {
 	return paravirt_patch_insns(insnbuf, len,
@@ -61,6 +65,9 @@ unsigned native_patch(u8 type, u16 clobb
 		PATCH_SITE(pv_cpu_ops, clts);
 		PATCH_SITE(pv_mmu_ops, flush_tlb_single);
 		PATCH_SITE(pv_cpu_ops, wbinvd);
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) && defined(CONFIG_QUEUE_SPINLOCK)
+		PATCH_SITE(pv_lock_ops, queue_unlock);
+#endif
 
 	patch_site:
 		ret = paravirt_patch_insns(ibuf, len, start, end);
Index: linux-2.6/include/asm-generic/qspinlock.h
===================================================================
--- linux-2.6.orig/include/asm-generic/qspinlock.h
+++ linux-2.6/include/asm-generic/qspinlock.h
@@ -105,6 +105,17 @@ static __always_inline bool virt_queue_s
 }
 #endif
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+struct mcs_spinlock;
+
+extern void __pv_init_node(struct mcs_spinlock *node);
+extern void __pv_link_and_wait_node(u32 old, struct mcs_spinlock *node);
+extern void __pv_kick_node(struct mcs_spinlock *node);
+
+extern void __pv_wait_head(struct qspinlock *lock);
+extern void __pv_queue_unlock(struct qspinlock *lock);
+#endif
+
 /*
  * Initializier
  */
Index: linux-2.6/kernel/locking/qspinlock.c
===================================================================
--- linux-2.6.orig/kernel/locking/qspinlock.c
+++ linux-2.6/kernel/locking/qspinlock.c
@@ -56,13 +56,33 @@
 
 #include "mcs_spinlock.h"
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+#define MAX_NODES	8
+
+static inline bool pv_enabled(void)
+{
+	return static_key_false(&paravirt_spinlocks_enabled);
+}
+#else /* !PARAVIRT_SPINLOCKS */
+
+#define MAX_NODES	4
+
+static inline bool pv_enabled(void)
+{
+	return false;
+}
+#endif /* PARAVIRT_SPINLOCKS */
+
 /*
  * Per-CPU queue node structures; we can never have more than 4 nested
  * contexts: task, softirq, hardirq, nmi.
  *
  * Exactly fits one cacheline.
+ *
+ * PV doubles the storage and uses the second cacheline for PV state.
  */
-static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[4]);
+static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[MAX_NODES]);
 
 /*
  * We must be able to distinguish between no-tail and the tail at 0:0,
@@ -218,6 +238,156 @@ static __always_inline void set_locked(s
 	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
 }
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+
+/*
+ * Write a comment about how all this works...
+ */
+
+#define _Q_LOCKED_SLOW	(2U << _Q_LOCKED_OFFSET)
+
+struct pv_node {
+	struct mcs_spinlock	mcs;
+	struct mcs_spinlock	__offset[3];
+	int cpu, head;
+};
+
+#define INVALID_HEAD	-1
+#define NO_HEAD		nr_cpu_ids
+
+void __pv_init_node(struct mcs_spinlock *node)
+{
+	struct pv_node *pn = (struct pv_node *)node;
+
+	BUILD_BUG_ON(sizeof(struct pv_node) > 5*sizeof(struct mcs_spinlock));
+
+	pn->cpu = smp_processor_id();
+	pn->head = INVALID_HEAD;
+}
+
+static inline struct pv_node *pv_decode_tail(u32 tail)
+{
+	return (struct pv_node *)decode_tail(tail);
+}
+
+void __pv_link_and_wait_node(u32 old, struct mcs_spinlock *node)
+{
+	struct pv_node *ppn, *pn = (struct pv_node *)node;
+	unsigned int count;
+
+	if (!(old & _Q_TAIL_MASK)) {
+		pn->head = NO_HEAD;
+		return;
+	}
+
+	ppn = pv_decode_tail(old);
+	ACCESS_ONCE(ppn->mcs.next) = node;
+
+	while (ppn->head == INVALID_HEAD)
+		cpu_relax();
+
+	pn->head = ppn->head;
+
+	for (;;) {
+		count = SPIN_THRESHOLD;
+
+		do {
+			if (smp_load_acquire(&node->locked))
+				return;
+
+			cpu_relax();
+		} while (--count);
+
+		pv_wait(&node->locked, 1);
+	}
+}
+
+void __pv_kick_node(struct mcs_spinlock *node)
+{
+	struct pv_node *pn = (struct pv_node *)node;
+
+	pv_kick(pn->cpu);
+}
+
+void __pv_wait_head(struct qspinlock *lock)
+{
+	unsigned int count;
+	struct pv_node *pn;
+	int val, old, new;
+
+	for (;;) {
+		count = SPIN_THRESHOLD;
+
+		do {
+			val = smp_load_acquire(&lock->val.counter);
+			if (!(val & _Q_LOCKED_PENDING_MASK))
+				return;
+		} while (--count);
+
+		do {
+			pn = pv_decode_tail(atomic_read(&lock->val));
+
+			while (pn->head == INVALID_HEAD)
+				cpu_relax();
+
+			pn->head = smp_processor_id();
+
+		} while (pn != pv_decode_tail(atomic_read(&lock->val)));
+
+		/*
+		 * Set _Q_LOCKED_SLOW; bail when the lock is free.
+		 */
+		val = atomic_read(&lock->val);
+		for (;;) {
+			if (!(val & _Q_LOCKED_PENDING_MASK))
+				return;
+			new = val | _Q_LOCKED_SLOW;
+			old = atomic_cmpxchg(&lock->val, val, new);
+			if (old == val)
+				break;
+			val = old;
+		}
+
+		/* XXX 16bit would be better */
+		pv_wait(&lock->val.counter, new);
+	}
+}
+
+static void ___pv_kick_head(struct qspinlock *lock)
+{
+	struct pv_node *pn;
+
+	pn = pv_decode_tail(atomic_read(&lock->val));
+
+	while (pn->head == INVALID_HEAD)
+		cpu_relax();
+
+	if (WARN_ON_ONCE(pn->head == NO_HEAD))
+		return;
+
+	pv_kick(pn->head);
+}
+
+void __pv_queue_unlock(struct qspinlock *lock)
+{
+	int val = atomic_read(&lock->val);
+
+	native_queue_unlock(lock);
+
+	if (val & _Q_LOCKED_SLOW)
+		___pv_kick_head(lock);
+}
+
+#else
+
+static inline void pv_init_node(struct mcs_spinlock *node) { }
+static inline void pv_link_and_wait_node(u32 old, struct mcs_spinlock *node) { }
+static inline void pv_kick_node(struct mcs_spinlock *node) { }
+
+static inline void pv_wait_head(struct qspinlock *lock) { }
+
+#endif
+
 /**
  * queue_spin_lock_slowpath - acquire the queue spinlock
  * @lock: Pointer to queue spinlock structure
@@ -247,6 +417,9 @@ void queue_spin_lock_slowpath(struct qsp
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
+	if (pv_enabled())
+		goto queue;
+
 	if (virt_queue_spin_lock(lock))
 		return;
 
@@ -323,6 +496,7 @@ void queue_spin_lock_slowpath(struct qsp
 	node += idx;
 	node->locked = 0;
 	node->next = NULL;
+	pv_init_node(node);
 
 	/*
 	 * We touched a (possibly) cold cacheline in the per-cpu queue node;
@@ -343,6 +517,7 @@ void queue_spin_lock_slowpath(struct qsp
 	/*
 	 * if there was a previous node; link it and wait.
 	 */
+	pv_link_and_wait_node(old, node);
 	if (old & _Q_TAIL_MASK) {
 		prev = decode_tail(old);
 		ACCESS_ONCE(prev->next) = node;
@@ -358,6 +533,7 @@ void queue_spin_lock_slowpath(struct qsp
 	 *
 	 * *,x,y -> *,0,0
 	 */
+	pv_wait_head(lock);
 	while ((val = smp_load_acquire(&lock->val.counter)) &
 			_Q_LOCKED_PENDING_MASK)
 		cpu_relax();
@@ -391,6 +567,7 @@ void queue_spin_lock_slowpath(struct qsp
 		cpu_relax();
 
 	arch_mcs_spin_unlock_contended(&next->locked);
+	pv_kick_node(next);
 
 release:
 	/*


