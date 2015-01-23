Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbbAWSqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:46:03 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33799 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbbAWSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:45:54 -0500
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
Subject: [PATCH 1/9] perf: Make perf_cgroup_from_task() global
Date: Fri, 23 Jan 2015 18:45:40 +0000
Message-Id: <1422038748-21397-2-git-send-email-matt@codeblueprint.co.uk>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
References: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Move perf_cgroup_from_task() from kernel/events/ to include/linux/ along
with the necessary struct definitions, so that it can be used by the PMU
code.

When the upcoming Intel Cache Monitoring PMU driver assigns monitoring
IDs to perf events, it needs to be able to check whether any two
monitoring events overlap (say, a cgroup and task event), which means we
need to be able to lookup the cgroup associated with a task (if any).

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 include/linux/perf_event.h | 30 ++++++++++++++++++++++++++++++
 kernel/events/core.c       | 28 +---------------------------
 2 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3a7bd80b4db8..72482f06401c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -53,6 +53,7 @@ struct perf_guest_info_callbacks {
 #include <linux/sysfs.h>
 #include <linux/perf_regs.h>
 #include <linux/workqueue.h>
+#include <linux/cgroup.h>
 #include <asm/local.h>
 
 struct perf_callchain_entry {
@@ -539,6 +540,35 @@ struct perf_output_handle {
 	int				page;
 };
 
+#ifdef CONFIG_CGROUP_PERF
+
+/*
+ * perf_cgroup_info keeps track of time_enabled for a cgroup.
+ * This is a per-cpu dynamically allocated data structure.
+ */
+struct perf_cgroup_info {
+	u64				time;
+	u64				timestamp;
+};
+
+struct perf_cgroup {
+	struct cgroup_subsys_state	css;
+	struct perf_cgroup_info	__percpu *info;
+};
+
+/*
+ * Must ensure cgroup is pinned (css_get) before calling
+ * this function. In other words, we cannot call this function
+ * if there is no cgroup event for the current CPU context.
+ */
+static inline struct perf_cgroup *
+perf_cgroup_from_task(struct task_struct *task)
+{
+	return container_of(task_css(task, perf_event_cgrp_id),
+			    struct perf_cgroup, css);
+}
+#endif /* CONFIG_CGROUP_PERF */
+
 #ifdef CONFIG_PERF_EVENTS
 
 extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c10124b772c4..dcb292a14127 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -34,11 +34,11 @@
 #include <linux/syscalls.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
+#include <linux/cgroup.h>
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
-#include <linux/cgroup.h>
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/compat.h>
@@ -351,32 +351,6 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 
 #ifdef CONFIG_CGROUP_PERF
 
-/*
- * perf_cgroup_info keeps track of time_enabled for a cgroup.
- * This is a per-cpu dynamically allocated data structure.
- */
-struct perf_cgroup_info {
-	u64				time;
-	u64				timestamp;
-};
-
-struct perf_cgroup {
-	struct cgroup_subsys_state	css;
-	struct perf_cgroup_info	__percpu *info;
-};
-
-/*
- * Must ensure cgroup is pinned (css_get) before calling
- * this function. In other words, we cannot call this function
- * if there is no cgroup event for the current CPU context.
- */
-static inline struct perf_cgroup *
-perf_cgroup_from_task(struct task_struct *task)
-{
-	return container_of(task_css(task, perf_event_cgrp_id),
-			    struct perf_cgroup, css);
-}
-
 static inline bool
 perf_cgroup_match(struct perf_event *event)
 {
-- 
1.9.3

