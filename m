Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaFRO7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbaFRO7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:59:49 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/18] perf tools: Add ordered_events_queue_free function
Date: Wed, 18 Jun 2014 16:58:54 +0200
Message-Id: <1403103539-16807-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ordered_events_queue_free function to release all
the struct ordered_events_queue data. It's replacement
for former perf_session_free_sample_buffers function.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/ordered-events.c | 11 +++++++++++
 tools/perf/util/ordered-events.h |  1 +
 tools/perf/util/session.c        | 17 ++---------------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 42b1bbc..946619c 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -201,3 +201,14 @@ void ordered_events_queue_init(struct ordered_events_queue *q)
 	q->max_alloc_size = (u64) -1;
 	q->cur_alloc_size = 0;
 }
+
+void ordered_events_queue_free(struct ordered_events_queue *q)
+{
+	while (!list_empty(&q->to_free)) {
+		struct ordered_event *event;
+
+		event = list_entry(q->to_free.next, struct ordered_event, list);
+		list_del(&event->list);
+		free(event);
+	}
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 0633b09..25ec273 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -41,4 +41,5 @@ void ordered_event_put(struct ordered_events_queue *q,
 int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			 enum oeq_flush how);
 void ordered_events_queue_init(struct ordered_events_queue *q);
+void ordered_events_queue_free(struct ordered_events_queue *q);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 59d13a7..28fe6a1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -444,19 +444,6 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
-static void perf_session_free_sample_buffers(struct perf_session *session)
-{
-	struct ordered_events_queue *q = &session->ordered_events;
-
-	while (!list_empty(&q->to_free)) {
-		struct ordered_event *sq;
-
-		sq = list_entry(q->to_free.next, struct ordered_event, list);
-		list_del(&sq->list);
-		free(sq);
-	}
-}
-
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
@@ -1092,7 +1079,7 @@ done:
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events_queue_free(&session->ordered_events);
 	return err;
 }
 
@@ -1227,7 +1214,7 @@ out:
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events_queue_free(&session->ordered_events);
 	return err;
 }
 
-- 
1.8.3.1

