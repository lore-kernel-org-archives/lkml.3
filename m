Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbbAUUjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:39:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbbAUUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:38:56 -0500
Message-Id: <20150121203744.461447675@redhat.com>
User-Agent: quilt/0.60-1
Date: Wed, 21 Jan 2015 18:36:01 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: Luiz Capitulino <lcapitulino@redhat.com>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch -rt 1/2] KVM: use simple waitqueue for vcpu->wq
References: <20150121203600.745949083@redhat.com>
Content-Disposition: inline; filename=kvm-wq-use-simple-waitqueue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem:

On -RT, an emulated LAPIC timer instances has the following path:

1) hard interrupt
2) ksoftirqd is scheduled
3) ksoftirqd wakes up vcpu thread
4) vcpu thread is scheduled

This extra context switch introduces unnecessary latency in the 
LAPIC path for a KVM guest.

The solution:

Allow waking up vcpu thread from hardirq context,
thus avoiding the need for ksoftirqd to be scheduled.

Normal waitqueues make use of spinlocks, which on -RT 
are sleepable locks. Therefore, waking up a waitqueue 
waiter involves locking a sleeping lock, which 
is not allowed from hard interrupt context.

cyclictest command line:
# cyclictest -m -n -q -p99 -l 1000000 -h60  -D 1m

This patch reduces the average latency in my tests from 14us to 11us.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 arch/arm/kvm/arm.c                  |    4 ++--
 arch/arm/kvm/psci.c                 |    4 ++--
 arch/mips/kvm/kvm_mips.c            |    8 ++++----
 arch/powerpc/include/asm/kvm_host.h |    4 ++--
 arch/powerpc/kvm/book3s_hv.c        |   20 ++++++++++----------
 arch/s390/include/asm/kvm_host.h    |    2 +-
 arch/s390/kvm/interrupt.c           |   22 ++++++++++------------
 arch/s390/kvm/sigp.c                |   16 ++++++++--------
 arch/x86/kvm/lapic.c                |    6 +++---
 include/linux/kvm_host.h            |    4 ++--
 virt/kvm/async_pf.c                 |    4 ++--
 virt/kvm/kvm_main.c                 |   16 ++++++++--------
 12 files changed, 54 insertions(+), 56 deletions(-)

Index: linux-stable-rt/arch/arm/kvm/arm.c
===================================================================
--- linux-stable-rt.orig/arch/arm/kvm/arm.c	2014-11-25 14:13:39.188899952 -0200
+++ linux-stable-rt/arch/arm/kvm/arm.c	2014-11-25 14:14:38.620810092 -0200
@@ -495,9 +495,9 @@
 
 static void vcpu_pause(struct kvm_vcpu *vcpu)
 {
-	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
+	struct swait_head *wq = kvm_arch_vcpu_wq(vcpu);
 
-	wait_event_interruptible(*wq, !vcpu->arch.pause);
+	swait_event_interruptible(*wq, !vcpu->arch.pause);
 }
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
Index: linux-stable-rt/arch/arm/kvm/psci.c
===================================================================
--- linux-stable-rt.orig/arch/arm/kvm/psci.c	2014-11-25 14:13:39.189899951 -0200
+++ linux-stable-rt/arch/arm/kvm/psci.c	2014-11-25 14:14:38.620810092 -0200
@@ -36,7 +36,7 @@
 {
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL, *tmp;
-	wait_queue_head_t *wq;
+	struct swait_head *wq;
 	unsigned long cpu_id;
 	unsigned long mpidr;
 	phys_addr_t target_pc;
@@ -80,7 +80,7 @@
 	smp_mb();		/* Make sure the above is visible */
 
 	wq = kvm_arch_vcpu_wq(vcpu);
-	wake_up_interruptible(wq);
+	swait_wake_interruptible(wq);
 
 	return KVM_PSCI_RET_SUCCESS;
 }
Index: linux-stable-rt/arch/mips/kvm/kvm_mips.c
===================================================================
--- linux-stable-rt.orig/arch/mips/kvm/kvm_mips.c	2014-11-25 14:13:39.191899948 -0200
+++ linux-stable-rt/arch/mips/kvm/kvm_mips.c	2014-11-25 14:14:38.621810091 -0200
@@ -464,8 +464,8 @@
 
 	dvcpu->arch.wait = 0;
 
-	if (waitqueue_active(&dvcpu->wq)) {
-		wake_up_interruptible(&dvcpu->wq);
+	if (swaitqueue_active(&dvcpu->wq)) {
+		swait_wake_interruptible(&dvcpu->wq);
 	}
 
 	return 0;
@@ -971,8 +971,8 @@
 	kvm_mips_callbacks->queue_timer_int(vcpu);
 
 	vcpu->arch.wait = 0;
-	if (waitqueue_active(&vcpu->wq)) {
-		wake_up_interruptible(&vcpu->wq);
+	if (swaitqueue_active(&vcpu->wq)) {
+		swait_wake_interruptible(&vcpu->wq);
 	}
 }
 
Index: linux-stable-rt/arch/powerpc/include/asm/kvm_host.h
===================================================================
--- linux-stable-rt.orig/arch/powerpc/include/asm/kvm_host.h	2014-11-25 14:13:39.193899944 -0200
+++ linux-stable-rt/arch/powerpc/include/asm/kvm_host.h	2014-11-25 14:14:38.621810091 -0200
@@ -295,7 +295,7 @@
 	u8 in_guest;
 	struct list_head runnable_threads;
 	spinlock_t lock;
-	wait_queue_head_t wq;
+	struct swait_head wq;
 	u64 stolen_tb;
 	u64 preempt_tb;
 	struct kvm_vcpu *runner;
@@ -612,7 +612,7 @@
 	u8 prodded;
 	u32 last_inst;
 
-	wait_queue_head_t *wqp;
+	struct swait_head *wqp;
 	struct kvmppc_vcore *vcore;
 	int ret;
 	int trap;
Index: linux-stable-rt/arch/powerpc/kvm/book3s_hv.c
===================================================================
--- linux-stable-rt.orig/arch/powerpc/kvm/book3s_hv.c	2014-11-25 14:13:39.195899942 -0200
+++ linux-stable-rt/arch/powerpc/kvm/book3s_hv.c	2014-11-25 14:14:38.625810085 -0200
@@ -74,11 +74,11 @@
 {
 	int me;
 	int cpu = vcpu->cpu;
-	wait_queue_head_t *wqp;
+	struct swait_head *wqp;
 
 	wqp = kvm_arch_vcpu_wq(vcpu);
-	if (waitqueue_active(wqp)) {
-		wake_up_interruptible(wqp);
+	if (swaitqueue_active(wqp)) {
+		swait_wake_interruptible(wqp);
 		++vcpu->stat.halt_wakeup;
 	}
 
@@ -583,8 +583,8 @@
 		tvcpu->arch.prodded = 1;
 		smp_mb();
 		if (vcpu->arch.ceded) {
-			if (waitqueue_active(&vcpu->wq)) {
-				wake_up_interruptible(&vcpu->wq);
+			if (swaitqueue_active(&vcpu->wq)) {
+				swait_wake_interruptible(&vcpu->wq);
 				vcpu->stat.halt_wakeup++;
 			}
 		}
@@ -1199,7 +1199,7 @@
 		if (vcore) {
 			INIT_LIST_HEAD(&vcore->runnable_threads);
 			spin_lock_init(&vcore->lock);
-			init_waitqueue_head(&vcore->wq);
+			init_swait_head(&vcore->wq);
 			vcore->preempt_tb = TB_NIL;
 			vcore->lpcr = kvm->arch.lpcr;
 			vcore->first_vcpuid = core * threads_per_core;
@@ -1566,13 +1566,13 @@
  */
 static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 {
-	DEFINE_WAIT(wait);
+	DEFINE_SWAITER(wait);
 
-	prepare_to_wait(&vc->wq, &wait, TASK_INTERRUPTIBLE);
+	swait_prepare(&vc->wq, &wait, TASK_INTERRUPTIBLE);
 	vc->vcore_state = VCORE_SLEEPING;
 	spin_unlock(&vc->lock);
 	schedule();
-	finish_wait(&vc->wq, &wait);
+	swait_finish(&vc->wq, &wait);
 	spin_lock(&vc->lock);
 	vc->vcore_state = VCORE_INACTIVE;
 }
@@ -1613,7 +1613,7 @@
 			kvmppc_create_dtl_entry(vcpu, vc);
 			kvmppc_start_thread(vcpu);
 		} else if (vc->vcore_state == VCORE_SLEEPING) {
-			wake_up(&vc->wq);
+			swait_wake(&vc->wq);
 		}
 
 	}
Index: linux-stable-rt/arch/s390/include/asm/kvm_host.h
===================================================================
--- linux-stable-rt.orig/arch/s390/include/asm/kvm_host.h	2014-11-25 14:13:39.196899940 -0200
+++ linux-stable-rt/arch/s390/include/asm/kvm_host.h	2014-11-25 14:14:38.627810082 -0200
@@ -233,7 +233,7 @@
 	atomic_t active;
 	struct kvm_s390_float_interrupt *float_int;
 	int timer_due; /* event indicator for waitqueue below */
-	wait_queue_head_t *wq;
+	struct swait_head *wq;
 	atomic_t *cpuflags;
 	unsigned int action_bits;
 };
Index: linux-stable-rt/arch/s390/kvm/interrupt.c
===================================================================
--- linux-stable-rt.orig/arch/s390/kvm/interrupt.c	2014-11-25 14:13:39.197899939 -0200
+++ linux-stable-rt/arch/s390/kvm/interrupt.c	2014-11-25 14:14:38.630810077 -0200
@@ -403,7 +403,7 @@
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 {
 	u64 now, sltime;
-	DECLARE_WAITQUEUE(wait, current);
+	DECLARE_SWAITER(wait);
 
 	vcpu->stat.exit_wait_state++;
 	if (kvm_cpu_has_interrupt(vcpu))
@@ -440,12 +440,11 @@
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	spin_lock(&vcpu->arch.local_int.float_int->lock);
 	spin_lock_bh(&vcpu->arch.local_int.lock);
-	add_wait_queue(&vcpu->wq, &wait);
+	swait_prepare(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 	while (list_empty(&vcpu->arch.local_int.list) &&
 		list_empty(&vcpu->arch.local_int.float_int->list) &&
 		(!vcpu->arch.local_int.timer_due) &&
 		!signal_pending(current)) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock_bh(&vcpu->arch.local_int.lock);
 		spin_unlock(&vcpu->arch.local_int.float_int->lock);
 		schedule();
@@ -453,8 +452,7 @@
 		spin_lock_bh(&vcpu->arch.local_int.lock);
 	}
 	__unset_cpu_idle(vcpu);
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&vcpu->wq, &wait);
+	swait_finish(&vcpu->wq, &wait);
 	spin_unlock_bh(&vcpu->arch.local_int.lock);
 	spin_unlock(&vcpu->arch.local_int.float_int->lock);
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
@@ -469,8 +467,8 @@
 
 	spin_lock(&vcpu->arch.local_int.lock);
 	vcpu->arch.local_int.timer_due = 1;
-	if (waitqueue_active(&vcpu->wq))
-		wake_up_interruptible(&vcpu->wq);
+	if (swaitqueue_active(&vcpu->wq))
+		swait_wake_interruptible(&vcpu->wq);
 	spin_unlock(&vcpu->arch.local_int.lock);
 }
 
@@ -617,7 +615,7 @@
 	spin_lock_bh(&li->lock);
 	list_add(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
-	BUG_ON(waitqueue_active(li->wq));
+	BUG_ON(swaitqueue_active(li->wq));
 	spin_unlock_bh(&li->lock);
 	return 0;
 }
@@ -750,8 +748,8 @@
 	li = fi->local_int[sigcpu];
 	spin_lock_bh(&li->lock);
 	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
-	if (waitqueue_active(li->wq))
-		wake_up_interruptible(li->wq);
+	if (swaitqueue_active(li->wq))
+		swait_wake_interruptible(li->wq);
 	spin_unlock_bh(&li->lock);
 	spin_unlock(&fi->lock);
 	mutex_unlock(&kvm->lock);
@@ -836,8 +834,8 @@
 	if (inti->type == KVM_S390_SIGP_STOP)
 		li->action_bits |= ACTION_STOP_ON_STOP;
 	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
-	if (waitqueue_active(&vcpu->wq))
-		wake_up_interruptible(&vcpu->wq);
+	if (swaitqueue_active(&vcpu->wq))
+		swait_wake_interruptible(&vcpu->wq);
 	spin_unlock_bh(&li->lock);
 	mutex_unlock(&vcpu->kvm->lock);
 	return 0;
Index: linux-stable-rt/arch/s390/kvm/sigp.c
===================================================================
--- linux-stable-rt.orig/arch/s390/kvm/sigp.c	2014-11-25 14:13:39.198899937 -0200
+++ linux-stable-rt/arch/s390/kvm/sigp.c	2014-11-25 14:14:38.633810073 -0200
@@ -79,8 +79,8 @@
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
 	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
-	if (waitqueue_active(li->wq))
-		wake_up_interruptible(li->wq);
+	if (swaitqueue_active(li->wq))
+		swait_wake_interruptible(li->wq);
 	spin_unlock_bh(&li->lock);
 	rc = SIGP_CC_ORDER_CODE_ACCEPTED;
 	VCPU_EVENT(vcpu, 4, "sent sigp emerg to cpu %x", cpu_addr);
@@ -148,8 +148,8 @@
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
 	atomic_set_mask(CPUSTAT_EXT_INT, li->cpuflags);
-	if (waitqueue_active(li->wq))
-		wake_up_interruptible(li->wq);
+	if (swaitqueue_active(li->wq))
+		swait_wake_interruptible(li->wq);
 	spin_unlock_bh(&li->lock);
 	rc = SIGP_CC_ORDER_CODE_ACCEPTED;
 	VCPU_EVENT(vcpu, 4, "sent sigp ext call to cpu %x", cpu_addr);
@@ -179,8 +179,8 @@
 	atomic_set(&li->active, 1);
 	atomic_set_mask(CPUSTAT_STOP_INT, li->cpuflags);
 	li->action_bits |= action;
-	if (waitqueue_active(li->wq))
-		wake_up_interruptible(li->wq);
+	if (swaitqueue_active(li->wq))
+		swait_wake_interruptible(li->wq);
 out:
 	spin_unlock_bh(&li->lock);
 
@@ -288,8 +288,8 @@
 
 	list_add_tail(&inti->list, &li->list);
 	atomic_set(&li->active, 1);
-	if (waitqueue_active(li->wq))
-		wake_up_interruptible(li->wq);
+	if (swaitqueue_active(li->wq))
+		swait_wake_interruptible(li->wq);
 	rc = SIGP_CC_ORDER_CODE_ACCEPTED;
 
 	VCPU_EVENT(vcpu, 4, "set prefix of cpu %02x to %x", cpu_addr, address);
Index: linux-stable-rt/arch/x86/kvm/lapic.c
===================================================================
--- linux-stable-rt.orig/arch/x86/kvm/lapic.c	2014-11-25 14:13:39.199899935 -0200
+++ linux-stable-rt/arch/x86/kvm/lapic.c	2015-01-14 15:02:41.135771065 -0200
@@ -1533,7 +1533,7 @@
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
 	struct kvm_vcpu *vcpu = apic->vcpu;
-	wait_queue_head_t *q = &vcpu->wq;
+	struct swait_head *q = &vcpu->wq;
 
 	/*
 	 * There is a race window between reading and incrementing, but we do
@@ -1547,8 +1547,8 @@
 		kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
 	}
 
-	if (waitqueue_active(q))
-		wake_up_interruptible(q);
+	if (swaitqueue_active(q))
+		swait_wake_interruptible(q);
 
 	if (lapic_is_periodic(apic)) {
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
Index: linux-stable-rt/include/linux/kvm_host.h
===================================================================
--- linux-stable-rt.orig/include/linux/kvm_host.h	2014-11-25 14:13:39.201899932 -0200
+++ linux-stable-rt/include/linux/kvm_host.h	2014-11-25 14:14:38.638810065 -0200
@@ -231,7 +231,7 @@
 
 	int fpu_active;
 	int guest_fpu_loaded, guest_xcr0_loaded;
-	wait_queue_head_t wq;
+	struct swait_head wq;
 	struct pid *pid;
 	int sigset_active;
 	sigset_t sigset;
@@ -677,7 +677,7 @@
 }
 #endif
 
-static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
+static inline struct swait_head *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
 {
 #ifdef __KVM_HAVE_ARCH_WQP
 	return vcpu->arch.wqp;
Index: linux-stable-rt/virt/kvm/async_pf.c
===================================================================
--- linux-stable-rt.orig/virt/kvm/async_pf.c	2014-11-25 14:13:39.202899931 -0200
+++ linux-stable-rt/virt/kvm/async_pf.c	2014-11-25 14:14:38.639810063 -0200
@@ -82,8 +82,8 @@
 
 	trace_kvm_async_pf_completed(addr, gva);
 
-	if (waitqueue_active(&vcpu->wq))
-		wake_up_interruptible(&vcpu->wq);
+	if (swaitqueue_active(&vcpu->wq))
+		swait_wake_interruptible(&vcpu->wq);
 
 	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
Index: linux-stable-rt/virt/kvm/kvm_main.c
===================================================================
--- linux-stable-rt.orig/virt/kvm/kvm_main.c	2014-11-25 14:13:39.204899928 -0200
+++ linux-stable-rt/virt/kvm/kvm_main.c	2014-11-25 14:14:38.641810060 -0200
@@ -219,7 +219,7 @@
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
-	init_waitqueue_head(&vcpu->wq);
+	init_swait_head(&vcpu->wq);
 	kvm_async_pf_vcpu_init(vcpu);
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
@@ -1675,10 +1675,10 @@
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
-	DEFINE_WAIT(wait);
+	DEFINE_SWAITER(wait);
 
 	for (;;) {
-		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+		swait_prepare(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
 		if (kvm_arch_vcpu_runnable(vcpu)) {
 			kvm_make_request(KVM_REQ_UNHALT, vcpu);
@@ -1692,7 +1692,7 @@
 		schedule();
 	}
 
-	finish_wait(&vcpu->wq, &wait);
+	swait_finish(&vcpu->wq, &wait);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 
@@ -1704,11 +1704,11 @@
 {
 	int me;
 	int cpu = vcpu->cpu;
-	wait_queue_head_t *wqp;
+	struct swait_head *wqp;
 
 	wqp = kvm_arch_vcpu_wq(vcpu);
-	if (waitqueue_active(wqp)) {
-		wake_up_interruptible(wqp);
+	if (swaitqueue_active(wqp)) {
+		swait_wake_interruptible(wqp);
 		++vcpu->stat.halt_wakeup;
 	}
 
@@ -1814,7 +1814,7 @@
 				continue;
 			if (vcpu == me)
 				continue;
-			if (waitqueue_active(&vcpu->wq))
+			if (swaitqueue_active(&vcpu->wq))
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;


