Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3BCT3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:29:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3BCT27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:28:59 -0500
Date: Sun, 3 Feb 2013 11:28:27 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0231bb5336758426b44ccd798ccd3c5419c95d58@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, hollmann@in.tum.de, namhyung@kernel.org,
        jolsa@redhat.com, vince@deater.net, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, hollmann@in.tum.de, namhyung@kernel.org,
        jolsa@redhat.com, vince@deater.net, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1359714225-4231-1-git-send-email-jolsa@redhat.com>
References: <1359714225-4231-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix event group context move
Git-Commit-ID: 0231bb5336758426b44ccd798ccd3c5419c95d58
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:28:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0231bb5336758426b44ccd798ccd3c5419c95d58
Gitweb:     http://git.kernel.org/tip/0231bb5336758426b44ccd798ccd3c5419c95d58
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 1 Feb 2013 11:23:45 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 3 Feb 2013 12:01:29 +0100

perf: Fix event group context move

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
---
 kernel/events/core.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 301079d..7b6646a 100644
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
@@ -6179,8 +6188,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	event->overflow_handler	= overflow_handler;
 	event->overflow_handler_context = context;
 
-	if (attr->disabled)
-		event->state = PERF_EVENT_STATE_OFF;
+	perf_event__state_init(event);
 
 	pmu = NULL;
 
@@ -6609,9 +6617,17 @@ SYSCALL_DEFINE5(perf_event_open,
 
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
