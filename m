Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaJAOjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:39:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37566 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaJAOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:36:45 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/11] perf: Make perf_cgroup_from_task() global
Date: Wed,  1 Oct 2014 15:36:25 +0100
Message-Id: <1412174192-7010-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Move perf_cgroup_from_task() from kernel/events to include/ along with
the necessary struct definitions, so that it can be used by the PMU
code.

The upcoming Intel Cache Monitoring PMU driver assigns monitoring IDs
based on a task's association with a cgroup - all tasks in the same
cgroup share an ID. We can use perf_cgroup_from_task() to track this
association.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 include/linux/perf_event.h | 30 ++++++++++++++++++++++++++++++
 kernel/events/core.c       | 28 +---------------------------
 2 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 893a0d07986f..1a4e2846d6fb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -53,6 +53,7 @@ struct perf_guest_info_callbacks {
 #include <linux/sysfs.h>
 #include <linux/perf_regs.h>
 #include <linux/workqueue.h>
+#include <linux/cgroup.h>
 #include <asm/local.h>
 
 struct perf_callchain_entry {
@@ -544,6 +545,35 @@ struct perf_output_handle {
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
index b164cb07b30d..c0e0c39b785a 100644
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

