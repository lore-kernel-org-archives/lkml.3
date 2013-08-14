Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3HNKsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:48:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34592 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab3HNKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        Ingo Molnar <mingo@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 38/75] perf: Fix event group context move
Date: Wed, 14 Aug 2013 11:36:27 +0100
Message-Id: <1376476624-10011-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

commit 0231bb5336758426b44ccd798ccd3c5419c95d58 upstream.

When we have group with mixed events (hw/sw) we want to end up
with group leader being in hw context. So if group leader is
initialy sw event, we move all the events under hw context.

The move is done for each event by removing it from its context
and adding it back into proper one. As a part of the removal the
event is automatically disabled, which is not what we want at
this stage of creating groups.

The fix is to initialize event state after removal from sw
context.

This fix resulted from the following discussion:

  http://thread.gmane.org/gmane.linux.kernel.perf.user/1144

Reported-by: Andreas Hollmann <hollmann@in.tum.de>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vince@deater.net>
Link: http://lkml.kernel.org/r/1359714225-4231-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 00aa7e3..dd815c3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -915,6 +915,15 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
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
@@ -6061,8 +6070,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->overflow_handler	= overflow_handler;
 	event->overflow_handler_context = context;
 
-	if (attr->disabled)
-		event->state = PERF_EVENT_STATE_OFF;
+	perf_event__state_init(event);
 
 	pmu = NULL;
 
@@ -6484,9 +6492,17 @@ SYSCALL_DEFINE5(perf_event_open,
 
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
1.8.3.2

