Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbbAWSrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:47:07 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61750 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbbAWSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:46:07 -0500
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] perf/x86/intel: Support task events with Intel CQM
Date: Fri, 23 Jan 2015 18:45:46 +0000
Message-Id: <1422038748-21397-8-git-send-email-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
References: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Add support for task events as well as system-wide events. This change
has a big impact on the way that we gather LLC occupancy values in
intel_cqm_event_read().

Currently, for system-wide (per-cpu) events we defer processing to
userspace which knows how to discard all but one cpu result per package.

Things aren't so simple for task events because we need to do the value
aggregation ourselves. To do this, we defer updating the LLC occupancy
value in event->count from intel_cqm_event_read() and do an SMP
cross-call to read values for all packages in intel_cqm_event_count().
We need to ensure that we only do this for one task event per cache
group, otherwise we'll report duplicate values.

If we're a system-wide event we want to fallback to the default
perf_event_count() implementation. Refactor this into a common function
so that we don't duplicate the code.

Also, introduce PERF_TYPE_INTEL_CQM, since we need a way to track an
event's task (if the event isn't per-cpu) inside of the Intel CQM PMU
driver.  This task information is only availble in the upper layers of
the perf infrastructure.

Other perf backends stash the target task in event->hw.*target so we
need to do something similar. The task is used to determine whether
events should share a cache group and an RMID.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 195 +++++++++++++++++++++++++----
 include/linux/perf_event.h                 |   1 +
 include/uapi/linux/perf_event.h            |   1 +
 kernel/events/core.c                       |   2 +
 4 files changed, 178 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_cqm.c b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
index 6a1e0a0c1076..a85f1d6b387d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_cqm.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
@@ -182,23 +182,124 @@ fail:
 
 /*
  * Determine if @a and @b measure the same set of tasks.
+ *
+ * If @a and @b measure the same set of tasks then we want to share a
+ * single RMID.
  */
 static bool __match_event(struct perf_event *a, struct perf_event *b)
 {
+	/* Per-cpu and task events don't mix */
 	if ((a->attach_state & PERF_ATTACH_TASK) !=
 	    (b->attach_state & PERF_ATTACH_TASK))
 		return false;
 
-	/* not task */
+#ifdef CONFIG_CGROUP_PERF
+	if (a->cgrp != b->cgrp)
+		return false;
+#endif
+
+	/* If not task event, we're machine wide */
+	if (!(b->attach_state & PERF_ATTACH_TASK))
+		return true;
+
+	/*
+	 * Events that target same task are placed into the same cache group.
+	 */
+	if (a->hw.cqm_target == b->hw.cqm_target)
+		return true;
+
+	/*
+	 * Are we an inherited event?
+	 */
+	if (b->parent == a)
+		return true;
+
+	return false;
+}
+
+#ifdef CONFIG_CGROUP_PERF
+static inline struct perf_cgroup *event_to_cgroup(struct perf_event *event)
+{
+	if (event->attach_state & PERF_ATTACH_TASK)
+		return perf_cgroup_from_task(event->hw.cqm_target);
 
-	return true; /* if not task, we're machine wide */
+	return event->cgrp;
 }
+#endif
 
 /*
  * Determine if @a's tasks intersect with @b's tasks
+ *
+ * There are combinations of events that we explicitly prohibit,
+ *
+ *		   PROHIBITS
+ *     system-wide    -> 	cgroup and task
+ *     cgroup 	      ->	system-wide
+ *     		      ->	task in cgroup
+ *     task 	      -> 	system-wide
+ *     		      ->	task in cgroup
+ *
+ * Call this function before allocating an RMID.
  */
 static bool __conflict_event(struct perf_event *a, struct perf_event *b)
 {
+#ifdef CONFIG_CGROUP_PERF
+	/*
+	 * We can have any number of cgroups but only one system-wide
+	 * event at a time.
+	 */
+	if (a->cgrp && b->cgrp) {
+		struct perf_cgroup *ac = a->cgrp;
+		struct perf_cgroup *bc = b->cgrp;
+
+		/*
+		 * This condition should have been caught in
+		 * __match_event() and we should be sharing an RMID.
+		 */
+		WARN_ON_ONCE(ac == bc);
+
+		if (cgroup_is_descendant(ac->css.cgroup, bc->css.cgroup) ||
+		    cgroup_is_descendant(bc->css.cgroup, ac->css.cgroup))
+			return true;
+
+		return false;
+	}
+
+	if (a->cgrp || b->cgrp) {
+		struct perf_cgroup *ac, *bc;
+
+		/*
+		 * cgroup and system-wide events are mutually exclusive
+		 */
+		if ((a->cgrp && !(b->attach_state & PERF_ATTACH_TASK)) ||
+		    (b->cgrp && !(a->attach_state & PERF_ATTACH_TASK)))
+			return true;
+
+		/*
+		 * Ensure neither event is part of the other's cgroup
+		 */
+		ac = event_to_cgroup(a);
+		bc = event_to_cgroup(b);
+		if (ac == bc)
+			return true;
+
+		/*
+		 * Must have cgroup and non-intersecting task events.
+		 */
+		if (!ac || !bc)
+			return false;
+
+		/*
+		 * We have cgroup and task events, and the task belongs
+		 * to a cgroup. Check for for overlap.
+		 */
+		if (cgroup_is_descendant(ac->css.cgroup, bc->css.cgroup) ||
+		    cgroup_is_descendant(bc->css.cgroup, ac->css.cgroup))
+			return true;
+
+		return false;
+	}
+#endif
 	/*
 	 * If one of them is not a task, same story as above with cgroups.
 	 */
@@ -245,9 +346,16 @@ static int intel_cqm_setup_event(struct perf_event *event,
 
 static void intel_cqm_event_read(struct perf_event *event)
 {
-	unsigned long rmid = event->hw.cqm_rmid;
+	unsigned long rmid;
 	u64 val;
 
+	/*
+	 * Task events are handled by intel_cqm_event_count().
+	 */
+	if (event->cpu == -1)
+		return;
+
+	rmid = event->hw.cqm_rmid;
 	val = __rmid_read(rmid);
 
 	/*
@@ -259,6 +367,63 @@ static void intel_cqm_event_read(struct perf_event *event)
 	local64_set(&event->count, val);
 }
 
+struct rmid_read {
+	unsigned int rmid;
+	atomic64_t value;
+};
+
+static void __intel_cqm_event_count(void *info)
+{
+	struct rmid_read *rr = info;
+	u64 val;
+
+	val = __rmid_read(rr->rmid);
+
+	if (val & (RMID_VAL_ERROR | RMID_VAL_UNAVAIL))
+		return;
+
+	atomic64_add(val, &rr->value);
+}
+
+static inline bool cqm_group_leader(struct perf_event *event)
+{
+	return !list_empty(&event->hw.cqm_groups_entry);
+}
+
+static u64 intel_cqm_event_count(struct perf_event *event)
+{
+	struct rmid_read rr = {
+		.rmid = event->hw.cqm_rmid,
+		.value = ATOMIC64_INIT(0),
+	};
+
+	/*
+	 * We only need to worry about task events. System-wide events
+	 * are handled like usual, i.e. entirely with
+	 * intel_cqm_event_read().
+	 */
+	if (event->cpu != -1)
+		return __perf_event_count(event);
+
+	/*
+	 * Only the group leader gets to report values. This stops us
+	 * reporting duplicate values to userspace, and gives us a clear
+	 * rule for which task gets to report the values.
+	 *
+	 * Note that it is impossible to attribute these values to
+	 * specific packages - we forfeit that ability when we create
+	 * task events.
+	 */
+	if (!cqm_group_leader(event))
+		return 0;
+
+	on_each_cpu_mask(&cqm_cpumask, __intel_cqm_event_count, &rr, 1);
+
+	local64_set(&event->count, atomic64_read(&rr.value));
+
+	return __perf_event_count(event);
+}
+
 static void intel_cqm_event_start(struct perf_event *event, int mode)
 {
 	struct intel_cqm_state *state = this_cpu_ptr(&cqm_state);
@@ -344,7 +509,7 @@ static void intel_cqm_event_destroy(struct perf_event *event)
 	/*
 	 * And we're the group leader..
 	 */
-	if (!list_empty(&event->hw.cqm_groups_entry)) {
+	if (cqm_group_leader(event)) {
 		/*
 		 * If there was a group_other, make that leader, otherwise
 		 * destroy the group and return the RMID.
@@ -364,17 +529,6 @@ static void intel_cqm_event_destroy(struct perf_event *event)
 
 static struct pmu intel_cqm_pmu;
 
-/*
- * XXX there's a bit of a problem in that we cannot simply do the one
- * event per node as one would want, since that one event would one get
- * scheduled on the one cpu. But we want to 'schedule' the RMID on all
- * CPUs.
- *
- * This means we want events for each CPU, however, that generates a lot
- * of duplicate values out to userspace -- this is not to be helped
- * unless we want to change the core code in some way. Fore more info,
- * see intel_cqm_event_read().
- */
 static int intel_cqm_event_init(struct perf_event *event)
 {
 	struct perf_event *group = NULL;
@@ -386,9 +540,6 @@ static int intel_cqm_event_init(struct perf_event *event)
 	if (event->attr.config & ~QOS_EVENT_MASK)
 		return -EINVAL;
 
-	if (event->cpu == -1)
-		return -EINVAL;
-
 	/* unsupported modes and filters */
 	if (event->attr.exclude_user   ||
 	    event->attr.exclude_kernel ||
@@ -406,7 +557,8 @@ static int intel_cqm_event_init(struct perf_event *event)
 
 	mutex_lock(&cache_mutex);
 
-	err = intel_cqm_setup_event(event, &group); /* will also set rmid */
+	/* Will also set rmid */
+	err = intel_cqm_setup_event(event, &group);
 	if (err)
 		goto out;
 
@@ -469,6 +621,7 @@ static struct pmu intel_cqm_pmu = {
 	.start		= intel_cqm_event_start,
 	.stop		= intel_cqm_event_stop,
 	.read		= intel_cqm_event_read,
+	.count		= intel_cqm_event_count,
 };
 
 static inline void cqm_pick_event_reader(int cpu)
@@ -597,8 +750,8 @@ static int __init intel_cqm_init(void)
 
 	__perf_cpu_notifier(intel_cqm_cpu_notifier);
 
-	ret = perf_pmu_register(&intel_cqm_pmu, "intel_cqm", -1);
-
+	ret = perf_pmu_register(&intel_cqm_pmu, "intel_cqm",
+				PERF_TYPE_INTEL_CQM);
 	if (ret)
 		pr_err("Intel CQM perf registration failed: %d\n", ret);
 	else
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d0df0e0ff1d1..5075cb673aaa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -129,6 +129,7 @@ struct hw_perf_event {
 			struct list_head	cqm_events_entry;
 			struct list_head	cqm_groups_entry;
 			struct list_head	cqm_group_entry;
+			struct task_struct	*cqm_target;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		struct { /* breakpoint */
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9b79abbd1ab8..4613ce8354c4 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -32,6 +32,7 @@ enum perf_type_id {
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
 	PERF_TYPE_BREAKPOINT			= 5,
+	PERF_TYPE_INTEL_CQM			= 6,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bc7c2f42c7cb..3a86c911a2f6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6999,6 +6999,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		else if (attr->type == PERF_TYPE_BREAKPOINT)
 			event->hw.bp_target = task;
 #endif
+		else if (attr->type == PERF_TYPE_INTEL_CQM)
+			event->hw.cqm_target = task;
 	}
 
 	if (!overflow_handler && parent_event) {
-- 
1.9.3

