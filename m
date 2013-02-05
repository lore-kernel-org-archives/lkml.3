Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3BEVuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:50:04 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52669 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3BEVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:49:55 -0500
Subject: [PATCH 4/4] Add a timer to allow the separation of consigned from
 steal time.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Date: Tue, 05 Feb 2013 15:49:41 -0600
Message-ID: <20130205214941.4615.29852.stgit@lambeau>
In-Reply-To: <20130205214818.4615.12937.stgit@lambeau>
References: <20130205214818.4615.12937.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020521-4790-0000-0000-000006CC6B38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper routine to scheduler/core.c to allow the kvm module
to retrieve the cpu hardlimit settings.  The values will be used
to set up a timer that is used to separate the consigned from the
steal time.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    9 ++++++
 arch/x86/kvm/x86.c              |   62 ++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c             |   20 +++++++++++++
 3 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fe5a37b..9518613 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -355,6 +355,15 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 
 	/*
+	 * timer used to determine if the time should be counted as
+	 * steal time or consigned time.
+	 */
+	struct hrtimer steal_timer;
+	u64 current_consigned;
+	s64 consigned_quota;
+	s64 consigned_period;
+
+	/*
 	 * Paging state of the vcpu
 	 *
 	 * If the vcpu runs in guest mode with two level paging this still saves
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51b63d1..79d144d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1848,13 +1848,32 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 static void accumulate_steal_time(struct kvm_vcpu *vcpu)
 {
 	u64 delta;
+	u64 steal_delta;
+	u64 consigned_delta;
 
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
 	delta = current->sched_info.run_delay - vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
-	vcpu->arch.st.accum_steal = delta;
+
+	/* split the delta into steal and consigned */
+	if (vcpu->arch.current_consigned < vcpu->arch.consigned_quota) {
+		vcpu->arch.current_consigned += delta;
+		if (vcpu->arch.current_consigned > vcpu->arch.consigned_quota) {
+			steal_delta = vcpu->arch.current_consigned
+						-  vcpu->arch.consigned_quota;
+			consigned_delta = delta - steal_delta;
+		} else {
+			consigned_delta = delta;
+			steal_delta = 0;
+		}
+	} else {
+		consigned_delta = 0;
+		steal_delta = delta;
+	}
+	vcpu->arch.st.accum_steal = steal_delta;
+	vcpu->arch.st.accum_consigned = consigned_delta;
 }
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
@@ -2629,8 +2648,35 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 		!(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY);
 }
 
+extern int sched_use_hard_capping(int cpuid, int num_vcpus, s64 *quota,
+					s64 *period);
+enum hrtimer_restart steal_timer_fn(struct hrtimer *data)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm *kvm;
+	int num_vcpus;
+	ktime_t now;
+
+	vcpu = container_of(data, struct kvm_vcpu, arch.steal_timer);
+	kvm = vcpu->kvm;
+	num_vcpus = atomic_read(&kvm->online_vcpus);
+	sched_use_hard_capping(vcpu->cpu, num_vcpus,
+				&vcpu->arch.consigned_quota,
+				&vcpu->arch.consigned_period);
+	vcpu->arch.current_consigned = 0;
+	now = ktime_get();
+	hrtimer_forward(&vcpu->arch.steal_timer, now,
+			ktime_set(0, vcpu->arch.consigned_period));
+
+	return HRTIMER_RESTART;
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm *kvm;
+	int num_vcpus;
+	ktime_t ktime;
+
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
 		if (kvm_x86_ops->has_wbinvd_exit())
@@ -2670,6 +2716,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
+	/* Initialize and start a timer to capture steal and consigned time */
+	kvm = vcpu->kvm;
+	num_vcpus = atomic_read(&kvm->online_vcpus);
+	num_vcpus = (num_vcpus == 0) ? 1 : num_vcpus;
+	sched_use_hard_capping(vcpu->cpu, num_vcpus,
+				&vcpu->arch.consigned_quota,
+				&vcpu->arch.consigned_period);
+	hrtimer_init(&vcpu->arch.steal_timer, CLOCK_MONOTONIC,
+			HRTIMER_MODE_REL);
+	vcpu->arch.steal_timer.function = &steal_timer_fn;
+	ktime = ktime_set(0, vcpu->arch.consigned_period);
+	hrtimer_start(&vcpu->arch.steal_timer, ktime, HRTIMER_MODE_REL);
 
 	accumulate_steal_time(vcpu);
 	kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
@@ -2680,6 +2738,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	vcpu->arch.last_host_tsc = native_read_tsc();
+	hrtimer_cancel(&vcpu->arch.steal_timer);
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
@@ -6685,6 +6744,7 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
+	hrtimer_cancel(&vcpu->arch.steal_timer);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
 	kvm_free_lapic(vcpu);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index efc2652..133ee47 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8154,6 +8154,26 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	rcu_read_unlock();
 }
+/*
+ * return 1 if the scheduler is using some form of hard capping
+ * return 0 if there is no capping configured.
+ */
+int sched_use_hard_capping(int cpuid, int num_cpus, long *quota, long *period)
+{
+	struct rq *rq = cpu_rq(cpuid);
+	struct task_struct *curr = rq->curr;
+	struct task_group *tg = curr->sched_task_group;
+	long total_time;
+
+	*period = tg_get_cfs_period(tg);
+	if (*quota == RUNTIME_INF || *quota == -1)
+		return 0;
+	*quota = jiffies_to_usecs(tg_get_cfs_quota(tg)) / num_cpus;
+	total_time = jiffies_to_usecs(*period);
+	*quota = total_time - *quota;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(sched_use_hard_capping);
 
 struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",

