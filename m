Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3F1NR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:17:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:2642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab3F1NQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:16:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="361090228"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 4/5] perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE
Date: Fri, 28 Jun 2013 16:22:20 +0300
Message-Id: <1372425741-1676-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to disable an event but continue to receive
"tracking" events i.e. continue to receive mmap, comm, task events.
The flag is updated by both PERF_EVENT_IOC_DISABLE and
PERF_EVENT_IOC_ENABLE.  The flag is cleared by prctl
PR_TASK_PERF_EVENTS_DISABLE.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 include/linux/perf_event.h      |  1 +
 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 21 +++++++++++++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 50b3efd..789eeeb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -436,6 +436,7 @@ struct perf_event {
 	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
 	int				cgrp_defer_enabled;
 #endif
+	int				keep_tracking;
 
 #endif /* CONFIG_PERF_EVENTS */
 };
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 663be3f..7b4ecfb 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -324,6 +324,7 @@ struct perf_event_attr {
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
+	PERF_IOC_KEEP_TRACKING		= 1U << 1,
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1db3af9..0c1fbe9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3495,6 +3495,16 @@ static inline int perf_fget_light(int fd, struct fd *p)
 	return 0;
 }
 
+static void perf_event_keep_tracking(struct perf_event *event, u32 flags)
+{
+	int keep_tracking = !!(flags & PERF_IOC_KEEP_TRACKING);
+
+	if (flags & PERF_IOC_FLAG_GROUP)
+		event->group_leader->keep_tracking = keep_tracking;
+	else
+		event->keep_tracking = keep_tracking;
+}
+
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
@@ -3510,6 +3520,7 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		func = perf_event_enable;
 		break;
 	case PERF_EVENT_IOC_DISABLE:
+		perf_event_keep_tracking(event, flags);
 		func = perf_event_disable;
 		break;
 	case PERF_EVENT_IOC_RESET:
@@ -3552,6 +3563,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	else
 		perf_event_for_each_child(event, func);
 
+	if (cmd == PERF_EVENT_IOC_ENABLE)
+		perf_event_keep_tracking(event, flags);
+
 	return 0;
 }
 
@@ -3572,8 +3586,10 @@ int perf_event_task_disable(void)
 	struct perf_event *event;
 
 	mutex_lock(&current->perf_event_mutex);
-	list_for_each_entry(event, &current->perf_event_list, owner_entry)
+	list_for_each_entry(event, &current->perf_event_list, owner_entry) {
 		perf_event_for_each_child(event, perf_event_disable);
+		event->keep_tracking = 0;
+	}
 	mutex_unlock(&current->perf_event_mutex);
 
 	return 0;
@@ -4670,7 +4686,8 @@ perf_event_aux_ctx(struct perf_event_context *ctx,
 	struct perf_event *event;
 
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (event->state < PERF_EVENT_STATE_INACTIVE)
+		if (event->state < PERF_EVENT_STATE_INACTIVE &&
+		    !event->keep_tracking)
 			continue;
 		if (!event_filter_match(event))
 			continue;
-- 
1.7.11.7

