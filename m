Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab3IHDn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:43:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56219 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652Ab3IHDTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Jiri Olsa" <jolsa@redhat.com>, "Vince Weaver" <vince@deater.net>,
        "Stephane Eranian" <eranian@google.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Corey Ashford" <cjashfor@linux.vnet.ibm.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andreas Hollmann" <hollmann@in.tum.de>,
        "Paul Mackerras" <paulus@samba.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.494945706@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [006/121] perf: Fix event group context move
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -900,6 +900,15 @@ list_add_event(struct perf_event *event,
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
@@ -6050,8 +6059,7 @@ perf_event_alloc(struct perf_event_attr
 	event->overflow_handler	= overflow_handler;
 	event->overflow_handler_context = context;
 
-	if (attr->disabled)
-		event->state = PERF_EVENT_STATE_OFF;
+	perf_event__state_init(event);
 
 	pmu = NULL;
 
@@ -6433,9 +6441,17 @@ SYSCALL_DEFINE5(perf_event_open,
 
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

