Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaJAOio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:38:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42179 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaJAOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:36:47 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/11] perf: Add ->count() function to read per-package counters
Date: Wed,  1 Oct 2014 15:36:26 +0100
Message-Id: <1412174192-7010-6-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

For PMU drivers that record per-package counters, the ->count variable
cannot be used to record an accurate aggregated value, since it's not
possible to perform SMP cross-calls to cpus on other packages from the
context in which we update ->count.

Introduce a new optional ->count() accessor function that can be used to
customize how values are collected. If a PMU driver doesn't provide a
->count() function, we fallback to the existing code.

There is necessarily a window of staleness with this approach because
the task that generated the counter value may not have been scheduled by
the cpu recently.

An alternative and more complex approach would be to use a hrtimer to
periodically refresh the values from a more permissive scheduling
context. So, we're trading off complexity for accuracy.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 include/linux/perf_event.h | 10 ++++++++++
 kernel/events/core.c       |  5 ++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1a4e2846d6fb..1bf06b6fd5dc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -264,6 +264,11 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * Return the count value for a counter.
+	 */
+	u64 (*count)			(struct perf_event *event); /*optional*/
 };
 
 /**
@@ -743,6 +748,11 @@ static inline void perf_event_task_sched_out(struct task_struct *prev,
 		__perf_event_task_sched_out(prev, next);
 }
 
+static inline u64 __perf_event_count(struct perf_event *event)
+{
+	return local64_read(&event->count) + atomic64_read(&event->child_count);
+}
+
 extern void perf_event_mmap(struct vm_area_struct *vma);
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c0e0c39b785a..2d5cde7af58f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3052,7 +3052,10 @@ static void __perf_event_read(void *info)
 
 static inline u64 perf_event_count(struct perf_event *event)
 {
-	return local64_read(&event->count) + atomic64_read(&event->child_count);
+	if (event->pmu->count)
+		return event->pmu->count(event);
+
+	return __perf_event_count(event);
 }
 
 static u64 perf_event_read(struct perf_event *event)
-- 
1.9.3

