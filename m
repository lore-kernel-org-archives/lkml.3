Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab3CDSFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:05:21 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:59359 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab3CDSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:05:17 -0500
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Date: Mon, 04 Mar 2013 23:31:46 +0530
Message-Id: <20130304180146.31281.33540.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC 0/2] kvm: Better yield_to candidate using preemption notifiers
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030417-9264-0000-0000-00000342B796
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch series further filters better vcpu candidate to yield to
in PLE handler. The main idea is to record the preempted vcpus using
preempt notifiers and iterate only those preempted vcpus in the
handler. Note that the vcpus which were in spinloop during pause loop
exit are already filtered.

Thanks Jiannan, Avi for bringing the idea and Gleb, PeterZ for
precious suggestions during the discussion. 
Thanks Srikar for suggesting to avoid rcu lock while checking task state
that has improved overcommit cases.

There are basically two approches for the implementation.

Method 1: Uses per vcpu preempt flag (this series).

Method 2: We keep a bitmap of preempted vcpus. using this we can easily
iterate over preempted vcpus.

Note that method 2 needs an extra index variable to identify/map bitmap to
vcpu and it also needs static vcpu allocation.

I am also posting Method 2 approach for reference in case it interests.

Result: decent improvement for kernbench and ebizzy.

base = 3.8.0 + undercommit patches 
patched = base + preempt patches

Tested on 32 core (no HT) mx3850 machine with 32 vcpu guest 8GB RAM

--+-----------+-----------+-----------+------------+-----------+
               kernbench (exec time in sec lower is beter) 
--+-----------+-----------+-----------+------------+-----------+
      base       stdev       patched       stdev      %improve 
--+-----------+-----------+-----------+------------+-----------+
1x    47.0383     4.6977     44.2584     1.2899	    5.90986
2x    96.0071     7.1873     91.2605     7.3567	    4.94401
3x   164.0157    10.3613    156.6750    11.4267	    4.47561
4x   212.5768    23.7326    204.4800    13.2908	    3.80888
--+-----------+-----------+-----------+------------+-----------+
no ple kernbench 1x result for reference: 46.056133

--+-----------+-----------+-----------+------------+-----------+
               ebizzy (record/sec higher is better)
--+-----------+-----------+-----------+------------+-----------+
      base       stdev       patched       stdev      %improve 
--+-----------+-----------+-----------+------------+-----------+
1x  5609.2000    56.9343    6263.7000    64.7097     11.66833
2x  2071.9000   108.4829    2653.5000   181.8395     28.07085
3x  1557.4167   109.7141    1993.5000   166.3176     28.00043
4x  1254.7500    91.2997    1765.5000   237.5410     40.70532
--+-----------+-----------+-----------+------------+-----------+
no ple ebizzy 1x result for reference : 7394.9 rec/sec

Please let me know if you have any suggestions and comments.

Raghavendra K T (2):
   kvm: Record the preemption status of vcpus using preempt notifiers
   kvm: Iterate over only vcpus that are preempted
	
----
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 7 +++++++
 2 files changed, 8 insertions(+)
 
Reference patch for Method 2
---8<---
Use preempt bitmap and optimize vcpu iteration using preempt notifiers

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Record the preempted vcpus in a bit map using preempt notifiers.
Add the logic of iterating over only preempted vcpus thus making
vcpu iteration fast.
Thanks Jiannan, Avi for initially proposing patch. Gleb, Peter for
precious suggestions.
Thanks srikar for suggesting to remove rcu lock while checking
task state that helped in reducing overcommit overhead

Not-yet-signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |    7 +++++++
 virt/kvm/kvm_main.c      |   15 ++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cad77fe..8c4a2409 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -252,6 +252,7 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
+	int idx;
 	struct kvm_vcpu_arch arch;
 };
 
@@ -385,6 +386,7 @@ struct kvm {
 	long mmu_notifier_count;
 #endif
 	long tlbs_dirty;
+	DECLARE_BITMAP(preempt_bitmap, KVM_MAX_VCPUS);
 };
 
 #define kvm_err(fmt, ...) \
@@ -413,6 +415,11 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
 	     idx++)
 
+#define kvm_for_each_preempted_vcpu(idx, vcpup, kvm, n) \
+	for (idx = find_first_bit(kvm->preempt_bitmap, KVM_MAX_VCPUS); \
+	     idx < n && (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
+	     idx = find_next_bit(kvm->preempt_bitmap, KVM_MAX_VCPUS, idx+1))
+
 #define kvm_for_each_memslot(memslot, slots)	\
 	for (memslot = &slots->memslots[0];	\
 	      memslot < slots->memslots + KVM_MEM_SLOTS_NUM && memslot->npages;\
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index adc68fe..1db16b3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1770,10 +1770,12 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	struct kvm_vcpu *vcpu;
 	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
 	int yielded = 0;
+	int num_vcpus;
 	int try = 3;
 	int pass;
 	int i;
-
+
+	num_vcpus = atomic_read(&kvm->online_vcpus);
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -1783,7 +1785,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	 * We approximate round-robin by starting at the last boosted VCPU.
 	 */
 	for (pass = 0; pass < 2 && !yielded && try; pass++) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
+		kvm_for_each_preempted_vcpu(i, vcpu, kvm, num_vcpus) {
 			if (!pass && i <= last_boosted_vcpu) {
 				i = last_boosted_vcpu;
 				continue;
@@ -1878,6 +1880,7 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 {
 	int r;
+	int curr_idx;
 	struct kvm_vcpu *vcpu, *v;
 
 	vcpu = kvm_arch_vcpu_create(kvm, id);
@@ -1916,7 +1919,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
+	curr_idx = atomic_read(&kvm->online_vcpus);
+	kvm->vcpus[curr_idx] = vcpu;
+	vcpu->idx = curr_idx;
 	smp_wmb();
 	atomic_inc(&kvm->online_vcpus);
 
@@ -2902,6 +2907,7 @@ struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
 static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
+	clear_bit(vcpu->idx, vcpu->kvm->preempt_bitmap);
 
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
@@ -2911,6 +2917,9 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	if (current->state == TASK_RUNNING)
+		set_bit(vcpu->idx, vcpu->kvm->preempt_bitmap);
+
 	kvm_arch_vcpu_put(vcpu);
 }
 

