Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbaGYO5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:57:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760736AbaGYO5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:57:06 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/19] perf tools: Add ordered_events_free function
Date: Fri, 25 Jul 2014 16:56:11 +0200
Message-Id: <1406300177-31805-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding ordered_events_free function to release all the
struct ordered_events data. It's replacement for former
perf_session_free_sample_buffers function.

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
index 42d63396600c..6c48dfe24dc4 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -202,3 +202,14 @@ void ordered_events_init(struct ordered_events *oe)
 	oe->max_alloc_size = (u64) -1;
 	oe->cur_alloc_size = 0;
 }
+
+void ordered_events_free(struct ordered_events *oe)
+{
+	while (!list_empty(&oe->to_free)) {
+		struct ordered_event *event;
+
+		event = list_entry(oe->to_free.next, struct ordered_event, list);
+		list_del(&event->list);
+		free(event);
+	}
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index ce3f7f37b188..de40a8bb6466 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -39,4 +39,5 @@ void ordered_events_delete(struct ordered_events *oe, struct ordered_event *even
 int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			 enum oe_flush how);
 void ordered_events_init(struct ordered_events *oe);
+void ordered_events_free(struct ordered_events *oe);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 40956a3164e8..4e748142a13f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -444,19 +444,6 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
-static void perf_session_free_sample_buffers(struct perf_session *session)
-{
-	struct ordered_events *oe = &session->ordered_events;
-
-	while (!list_empty(&oe->to_free)) {
-		struct ordered_event *event;
-
-		event = list_entry(oe->to_free.next, struct ordered_event, list);
-		list_del(&event->list);
-		free(event);
-	}
-}
-
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
@@ -1093,7 +1080,7 @@ done:
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events_free(&session->ordered_events);
 	return err;
 }
 
@@ -1234,7 +1221,7 @@ out:
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events_free(&session->ordered_events);
 	session->one_mmap = false;
 	return err;
 }
-- 
1.8.3.1

