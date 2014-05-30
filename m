Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaE3BMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:12:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:5208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbaE3BMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:12:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,937,1392192000"; 
   d="scan'208";a="519983921"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] perf: Allow guest PEBS for KVM owned counters
Date: Thu, 29 May 2014 18:12:05 -0700
Message-Id: <1401412327-14810-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Currently perf unconditionally disables PEBS for guest.

Now that we have the infrastructure in place to handle
it we can allow it for KVM owned guest events. For
the perf needs to know that a event is owned by
a guest. Add a new state bit in the perf_event for that.

The bit is only set by KVM and cannot be selected
by anyone else.

Then change the MSR entry/exit list to allow
PEBS for these counters.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h       |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c | 14 +++++++++++---
 arch/x86/kvm/pmu.c                     |  1 +
 include/linux/perf_event.h             | 15 ++++++++++++++-
 kernel/events/core.c                   |  7 ++++---
 5 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6ab8fdd..422bca5 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -163,6 +163,7 @@ struct cpu_hw_events {
 	 */
 	u64				intel_ctrl_guest_mask;
 	u64				intel_ctrl_host_mask;
+	u64				intel_ctrl_guest_owned;
 	struct perf_guest_switch_msr	guest_switch_msrs[X86_PMC_IDX_MAX];
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 86ccb81..3bcfda0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1202,6 +1202,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
+	cpuc->intel_ctrl_guest_owned &= ~(1ull << hwc->idx);
 	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
 
 	/*
@@ -1274,6 +1275,8 @@ static void intel_pmu_enable_event(struct perf_event *event)
 
 	if (event->attr.exclude_host)
 		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
+	if (event->guest_owned)
+		cpuc->intel_ctrl_guest_owned |= (1ull << hwc->idx);
 	if (event->attr.exclude_guest)
 		cpuc->intel_ctrl_host_mask |= (1ull << hwc->idx);
 
@@ -1775,18 +1778,23 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	u64 mask;
 
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
+
+	arr[1].msr = MSR_IA32_PEBS_ENABLE;
+	arr[1].host = cpuc->pebs_enabled;
 	/*
+	 * For PEBS virtualization only allow guest owned counters.
+	 *
 	 * If PMU counter has PEBS enabled it is not enough to disable counter
 	 * on a guest entry since PEBS memory write can overshoot guest entry
 	 * and corrupt guest memory. Disabling PEBS solves the problem.
 	 */
-	arr[1].msr = MSR_IA32_PEBS_ENABLE;
-	arr[1].host = cpuc->pebs_enabled;
-	arr[1].guest = 0;
+	mask = cpuc->intel_ctrl_guest_owned;
+	arr[1].guest = cpuc->pebs_enabled & (mask | (mask << 32));
 
 	*nr = 2;
 	return arr;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5c4f631..4c6f417 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -188,6 +188,7 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				PTR_ERR(event));
 		return;
 	}
+	event->guest_owned = true;
 
 	pmc->perf_event = event;
 	clear_bit(pmc->idx, (unsigned long*)&pmc->vcpu->arch.pmu.reprogram_pmi);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3356abc..ad2b3f6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -437,6 +437,8 @@ struct perf_event {
 	int				cgrp_defer_enabled;
 #endif
 
+	bool				guest_owned;	/* Owned by a guest */
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -550,11 +552,22 @@ extern int perf_event_refresh(struct perf_event *event, int refresh);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
+__perf_event_create_kernel_counter(struct perf_event_attr *attr,
+				int cpu,
+				struct task_struct *task,
+				perf_overflow_handler_t callback,
+				void *context, bool guest_owned);
+static inline struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				struct task_struct *task,
 				perf_overflow_handler_t callback,
-				void *context);
+				void *context)
+{
+	return __perf_event_create_kernel_counter(attr, cpu, task, callback,
+						  context, false);
+}
+
 extern void perf_pmu_migrate_context(struct pmu *pmu,
 				int src_cpu, int dst_cpu);
 extern u64 perf_event_read_value(struct perf_event *event,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a..3450ba7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7249,10 +7249,10 @@ err_fd:
  * @task: task to profile (NULL for percpu)
  */
 struct perf_event *
-perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
+__perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 				 struct task_struct *task,
 				 perf_overflow_handler_t overflow_handler,
-				 void *context)
+				 void *context, bool guest_owned)
 {
 	struct perf_event_context *ctx;
 	struct perf_event *event;
@@ -7268,6 +7268,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		err = PTR_ERR(event);
 		goto err;
 	}
+	event->guest_owned = guest_owned;
 
 	account_event(event);
 
@@ -7290,7 +7291,7 @@ err_free:
 err:
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
+EXPORT_SYMBOL_GPL(__perf_event_create_kernel_counter);
 
 void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 {
-- 
1.9.0

