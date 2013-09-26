Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3IZI2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:28:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:34651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3IZI2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:28:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,983,1371106800"; 
   d="scan'208";a="401278477"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 6/7] perf, x86: Use LBR call stack to get user callchain
Date: Thu, 26 Sep 2013 16:28:12 +0800
Message-Id: <1380184093-8838-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
References: <1380184093-8838-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Try enabling the LBR call stack feature if event request recording
callchain. Try utilizing the LBR call stack to get user callchain
in case of there is no frame pointer.

This patch also adds a cpu pmu attribute to enable/disable this
feature.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c           | 128 +++++++++++++++++++++--------
 arch/x86/kernel/cpu/perf_event.h           |   7 ++
 arch/x86/kernel/cpu/perf_event_intel.c     |  20 ++---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   3 +
 include/linux/perf_event.h                 |   6 ++
 kernel/events/core.c                       |  11 ++-
 6 files changed, 126 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index aff0832..119e0af 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -399,37 +399,49 @@ int x86_pmu_hw_config(struct perf_event *event)
 
 		if (event->attr.precise_ip > precise)
 			return -EOPNOTSUPP;
+	}
+	/*
+	 * check that PEBS LBR correction does not conflict with
+	 * whatever the user is asking with attr->branch_sample_type
+	 */
+	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
+		u64 *br_type = &event->attr.branch_sample_type;
+
+		if (has_branch_stack(event)) {
+			if (!precise_br_compat(event))
+				return -EOPNOTSUPP;
+
+			/* branch_sample_type is compatible */
+
+		} else {
+			/*
+			 * user did not specify  branch_sample_type
+			 *
+			 * For PEBS fixups, we capture all
+			 * the branches at the priv level of the
+			 * event.
+			 */
+			*br_type = PERF_SAMPLE_BRANCH_ANY;
+
+			if (!event->attr.exclude_user)
+				*br_type |= PERF_SAMPLE_BRANCH_USER;
+
+			if (!event->attr.exclude_kernel)
+				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
+		}
+	} else if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+		   !has_branch_stack(event) &&
+		   x86_pmu.attr_lbr_callstack &&
+		   !event->attr.exclude_user &&
+		   (event->attach_state & PERF_ATTACH_TASK)) {
 		/*
-		 * check that PEBS LBR correction does not conflict with
-		 * whatever the user is asking with attr->branch_sample_type
+		 * user did not specify branch_sample_type,
+		 * try using the LBR call stack facility to
+		 * record call chains of user program.
 		 */
-		if (event->attr.precise_ip > 1 &&
-		    x86_pmu.intel_cap.pebs_format < 2) {
-			u64 *br_type = &event->attr.branch_sample_type;
-
-			if (has_branch_stack(event)) {
-				if (!precise_br_compat(event))
-					return -EOPNOTSUPP;
-
-				/* branch_sample_type is compatible */
-
-			} else {
-				/*
-				 * user did not specify  branch_sample_type
-				 *
-				 * For PEBS fixups, we capture all
-				 * the branches at the priv level of the
-				 * event.
-				 */
-				*br_type = PERF_SAMPLE_BRANCH_ANY;
-
-				if (!event->attr.exclude_user)
-					*br_type |= PERF_SAMPLE_BRANCH_USER;
-
-				if (!event->attr.exclude_kernel)
-					*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
-			}
-		}
+		event->attr.branch_sample_type =
+			PERF_SAMPLE_BRANCH_USER |
+			PERF_SAMPLE_BRANCH_CALL_STACK;
 	}
 
 	/*
@@ -1828,10 +1840,34 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	return count;
 }
 
+static ssize_t get_attr_lbr_callstack(struct device *cdev,
+				      struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, 40, "%d\n", x86_pmu.attr_lbr_callstack);
+}
+
+static ssize_t set_attr_lbr_callstack(struct device *cdev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	unsigned long val = simple_strtoul(buf, NULL, 0);
+
+	if (x86_pmu.attr_lbr_callstack != !!val) {
+		if (val && !x86_pmu_has_lbr_callstack())
+			return -EOPNOTSUPP;
+		x86_pmu.attr_lbr_callstack = !!val;
+	}
+	return count;
+}
+
 static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
+static DEVICE_ATTR(lbr_callstack, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+		   get_attr_lbr_callstack, set_attr_lbr_callstack);
+
 
 static struct attribute *x86_pmu_attrs[] = {
 	&dev_attr_rdpmc.attr,
+	&dev_attr_lbr_callstack.attr,
 	NULL,
 };
 
@@ -1970,12 +2006,29 @@ static unsigned long get_segment_base(unsigned int segment)
 	return get_desc_base(desc + idx);
 }
 
+static inline void
+perf_callchain_lbr_callstack(struct perf_callchain_entry *entry,
+			     struct perf_sample_data *data)
+{
+	struct perf_branch_stack *br_stack = data->br_stack;
+
+	if (br_stack && br_stack->user_callstack &&
+	    x86_pmu.attr_lbr_callstack) {
+		int i = 0;
+		while (i < br_stack->nr && entry->nr < PERF_MAX_STACK_DEPTH) {
+			perf_callchain_store(entry, br_stack->entries[i].from);
+			i++;
+		}
+	}
+}
+
 #ifdef CONFIG_COMPAT
 
 #include <asm/compat.h>
 
 static inline int
-perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
+perf_callchain_user32(struct perf_callchain_entry *entry,
+		      struct pt_regs *regs, struct perf_sample_data *data)
 {
 	/* 32-bit process in 64-bit kernel. */
 	unsigned long ss_base, cs_base;
@@ -2004,11 +2057,16 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		perf_callchain_store(entry, cs_base + frame.return_address);
 		fp = compat_ptr(ss_base + frame.next_frame);
 	}
+
+	if (fp == compat_ptr(regs->bp))
+		perf_callchain_lbr_callstack(entry, data);
+
 	return 1;
 }
 #else
 static inline int
-perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
+perf_callchain_user32(struct perf_callchain_entry *entry,
+		      struct pt_regs *regs, struct perf_sample_data *data)
 {
     return 0;
 }
@@ -2038,12 +2096,12 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
 	if (!current->mm)
 		return;
 
-	if (perf_callchain_user32(regs, entry))
+	if (perf_callchain_user32(entry, regs, data))
 		return;
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
 		unsigned long bytes;
-		frame.next_frame	     = NULL;
+		frame.next_frame = NULL;
 		frame.return_address = 0;
 
 		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
@@ -2056,6 +2114,10 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
+
+	/* try LBR callstack if there is no frame pointer */
+	if (fp == (void __user *)regs->bp)
+		perf_callchain_lbr_callstack(entry, data);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b1d2fa9..940f43b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -401,6 +401,7 @@ struct x86_pmu {
 	 * sysfs attrs
 	 */
 	int		attr_rdpmc;
+	int		attr_lbr_callstack;
 	struct attribute **format_attrs;
 	struct attribute **event_attrs;
 
@@ -504,6 +505,12 @@ static struct perf_pmu_events_attr event_attr_##v = {			\
 
 extern struct x86_pmu x86_pmu __read_mostly;
 
+static inline bool x86_pmu_has_lbr_callstack(void)
+{
+	return  x86_pmu.lbr_sel_map &&
+		x86_pmu.lbr_sel_map[PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT] > 0;
+}
+
 DECLARE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
 int x86_perf_event_set_period(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 92b132e..238c5fc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1030,15 +1030,10 @@ static __initconst const u64 slm_hw_cache_event_ids
  },
 };
 
-static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
+static inline bool intel_pmu_needs_lbr_callstack(struct perf_event *event)
 {
-	/* user explicitly requested branch sampling */
-	if (has_branch_stack(event))
-		return true;
-
-	/* implicit branch sampling to correct PEBS skid */
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
-	    x86_pmu.intel_cap.pebs_format < 2)
+	if ((event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+	    (event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK))
 		return true;
 
 	return false;
@@ -1208,7 +1203,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 	 * must disable before any actual event
 	 * because any event may be combined with LBR
 	 */
-	if (intel_pmu_needs_lbr_smpl(event))
+	if (needs_branch_stack(event))
 		intel_pmu_lbr_disable(event);
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
@@ -1269,7 +1264,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	 * must enabled before any actual event
 	 * because any event may be combined with LBR
 	 */
-	if (intel_pmu_needs_lbr_smpl(event))
+	if (needs_branch_stack(event))
 		intel_pmu_lbr_enable(event);
 
 	if (event->attr.exclude_host)
@@ -1412,7 +1407,8 @@ again:
 
 		perf_sample_data_init(&data, 0, event->hw.last_period);
 
-		if (has_branch_stack(event))
+		if (has_branch_stack(event) ||
+		    (event->ctx->task && intel_pmu_needs_lbr_callstack(event)))
 			data.br_stack = &cpuc->lbr_stack;
 
 		if (perf_event_overflow(event, &data, regs))
@@ -1741,7 +1737,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
 		x86_pmu.pebs_aliases(event);
 
-	if (intel_pmu_needs_lbr_smpl(event)) {
+	if (needs_branch_stack(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
 		if (ret)
 			return ret;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index a160891..7f42d25 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -702,6 +702,8 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 	int i, j, type;
 	bool compress = false;
 
+	cpuc->lbr_stack.user_callstack = branch_user_callstack(br_sel);
+
 	/* if sampling all branches, then nothing to filter */
 	if ((br_sel & X86_BR_ALL) == X86_BR_ALL)
 		return;
@@ -854,6 +856,7 @@ void intel_pmu_lbr_init_hsw(void)
 
 	x86_pmu.lbr_sel_mask = LBR_SEL_MASK;
 	x86_pmu.lbr_sel_map  = hsw_lbr_sel_map;
+	x86_pmu.attr_lbr_callstack = 1;
 
 	pr_cont("16-deep LBR, ");
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ca3463c..86ebaa5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -74,6 +74,7 @@ struct perf_raw_record {
  * recent branch.
  */
 struct perf_branch_stack {
+	unsigned			user_callstack:1;
 	__u64				nr;
 	struct perf_branch_entry	entries[0];
 };
@@ -737,6 +738,11 @@ static inline bool has_branch_stack(struct perf_event *event)
 	return event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK;
 }
 
+static inline bool needs_branch_stack(struct perf_event *event)
+{
+	return event->attr.branch_sample_type != 0;
+}
+
 extern int perf_output_begin(struct perf_output_handle *handle,
 			     struct perf_event *event, unsigned int size);
 extern void perf_output_end(struct perf_output_handle *handle);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ccd0f54..438c29c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1137,7 +1137,7 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (is_cgroup_event(event))
 		ctx->nr_cgroups++;
 
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		ctx->nr_branch_stack++;
 
 	list_add_rcu(&event->event_entry, &ctx->event_list);
@@ -1297,7 +1297,7 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 			cpuctx->cgrp = NULL;
 	}
 
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		ctx->nr_branch_stack--;
 
 	ctx->nr_events--;
@@ -3177,7 +3177,7 @@ static void unaccount_event(struct perf_event *event)
 		atomic_dec(&nr_freq_events);
 	if (is_cgroup_event(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
 
 	unaccount_event_cpu(event, event->cpu);
@@ -6566,7 +6566,7 @@ static void account_event(struct perf_event *event)
 		if (atomic_inc_return(&nr_freq_events) == 1)
 			tick_nohz_full_kick_all();
 	}
-	if (has_branch_stack(event))
+	if (needs_branch_stack(event))
 		static_key_slow_inc(&perf_sched_events.key);
 	if (is_cgroup_event(event))
 		static_key_slow_inc(&perf_sched_events.key);
@@ -6673,6 +6673,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto err_ns;
 
+	if (!has_branch_stack(event))
+		event->attr.branch_sample_type = 0;
+
 	pmu = perf_init_event(event);
 	if (!pmu)
 		goto err_ns;
-- 
1.8.1.4

