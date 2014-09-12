Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaILLSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbaILLSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:18:43 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf: Do not POLLHUP event if it has children
Date: Fri, 12 Sep 2014 13:18:26 +0200
Message-Id: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we return POLLHUP in event polling if the monitored
process is done, but we didn't consider possible children,
that might be still running and producing data.

Before returning POLLHUP making sure that
   1) the monitored task has exited and that
   2) we don't have any children to monitor

Also adding parent wakeup when the child event is gone.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d8cb4d21a346..cf779eaaf624 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3586,6 +3586,19 @@ static int perf_event_read_one(struct perf_event *event,
 	return n * sizeof(u64);
 }
 
+static bool is_event_hup(struct perf_event *event)
+{
+	bool no_children;
+
+	if (event->state != PERF_EVENT_STATE_EXIT)
+		return false;
+
+	mutex_lock(&event->child_mutex);
+	no_children = list_empty(&event->child_list);
+	mutex_unlock(&event->child_mutex);
+	return no_children;
+}
+
 /*
  * Read the performance event - simple non blocking version for now
  */
@@ -3632,7 +3645,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &event->waitq, wait);
 
-	if (event->state == PERF_EVENT_STATE_EXIT)
+	if (is_event_hup(event))
 		return events;
 
 	/*
@@ -7560,6 +7573,12 @@ static void sync_child_event(struct perf_event *child_event,
 	mutex_unlock(&parent_event->child_mutex);
 
 	/*
+	 * Make sure user/parent get notified, that we just
+	 * lost one event.
+	 */
+	perf_event_wakeup(parent_event);
+
+	/*
 	 * Release the parent event, if this was the last
 	 * reference to it.
 	 */
-- 
1.8.3.1

