Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3BAKYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab3BAKYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:24:05 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        Andreas Hollmann <hollmann@in.tum.de>
Subject: [PATCH] perf: Fix event group context move
Date: Fri,  1 Feb 2013 11:23:45 +0100
Message-Id: <1359714225-4231-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this fix is related to following discussion:
http://thread.gmane.org/gmane.linux.kernel.perf.user/1144

The fix is straightforward, but I think we could have
same issue in perf_pmu_migrate_context function as well,
which is used so far only by uncore bits.

I think the perf_pmu_migrate_context function could be used
for the group move in syscall as well (after some tuning)
to have the group move on single place only.

I'm not sure if I get to this soon, so I'm sending
the fix for the original issue first.

thanks,
jirka


---
When we have group with mixed events (hw/sw) we want to endup
with group leader being in hw context. So if group leader is
initialy sw event, we move all the events under hw context.

The move is done for each event by removing it from its context
and adding it back into proper one. As a part of the removal the
event is automatically disabled, which is not what we want at
this stage of creating groups.

The fix is to initialize event state after removal from sw context.

Reported-by: Andreas Hollmann <hollmann@in.tum.de>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vince@deater.net>
Cc: Andreas Hollmann <hollmann@in.tum.de>
---
 kernel/events/core.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd1c130..1e295bb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -908,6 +908,15 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 }
 
 /*
+ * Initialize event state based on the perf_event_attr::disabled.
+ */
+static inline void perf_event__state_init(struct perf_event *event)
+{
+	event->state = event->attr.disabled ? PERF_EVENT_STATE_OFF :
+					      PERF_EVENT_STATE_INACTIVE;
+}
+
+/*
  * Called at perf_event creation and when events are attached/detached from a
  * group.
  */
@@ -6194,8 +6203,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->overflow_handler	= overflow_handler;
 	event->overflow_handler_context = context;
 
-	if (attr->disabled)
-		event->state = PERF_EVENT_STATE_OFF;
+	perf_event__state_init(event);
 
 	pmu = NULL;
 
@@ -6624,9 +6632,17 @@ SYSCALL_DEFINE5(perf_event_open,
 
 		mutex_lock(&gctx->mutex);
 		perf_remove_from_context(group_leader);
+
+		/*
+		 * Removing from the context ends up with disabled
+		 * event. What we want here is event in the initial
+		 * startup state, ready to be add into new context.
+		 */
+		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
 			perf_remove_from_context(sibling);
+			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
 		mutex_unlock(&gctx->mutex);
-- 
1.7.11.7

