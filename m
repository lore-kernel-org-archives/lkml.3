Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaFLWJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:09:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaFLWJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:09:17 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/17] perf tools: Factor ordered_events_flush to be more generic
Date: Fri, 13 Jun 2014 00:08:22 +0200
Message-Id: <1402610913-19059-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralizing the next_flush calculation under the
ordered_events_flush function.

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
 tools/perf/util/session.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 966132d..76df5c9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -453,6 +453,11 @@ struct ordered_event {
 	struct list_head	list;
 };
 
+enum oeq_flush {
+	OEQ_FLUSH__FINAL,
+	OEQ_FLUSH__ROUND,
+};
+
 static void perf_session_free_sample_buffers(struct perf_session *session)
 {
 	struct ordered_events_queue *q = &session->ordered_events;
@@ -565,8 +570,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static int ordered_events_flush(struct perf_session *s,
-		       struct perf_tool *tool)
+static int __ordered_events_flush(struct perf_session *s,
+				  struct perf_tool *tool)
 {
 	struct ordered_events_queue *q = &s->ordered_events;
 	struct list_head *head = &q->events;
@@ -616,6 +621,32 @@ static int ordered_events_flush(struct perf_session *s,
 	return 0;
 }
 
+static int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
+				enum oeq_flush how)
+{
+	struct ordered_events_queue *q = &s->ordered_events;
+	int err;
+
+	switch (how) {
+	case OEQ_FLUSH__FINAL:
+		q->next_flush = ULLONG_MAX;
+		break;
+
+	case OEQ_FLUSH__ROUND:
+	default:
+		break;
+	};
+
+	err = __ordered_events_flush(s, tool);
+
+	if (!err) {
+		if (how == OEQ_FLUSH__ROUND)
+			q->next_flush = q->max_timestamp;
+	}
+
+	return err;
+}
+
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
@@ -659,11 +690,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = ordered_events_flush(session, tool);
-	if (!ret)
-		session->ordered_events.next_flush = session->ordered_events.max_timestamp;
-
-	return ret;
+	return ordered_events_flush(session, tool, OEQ_FLUSH__ROUND);
 }
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
@@ -1245,8 +1272,7 @@ more:
 		goto more;
 done:
 	/* do the final flush for ordered samples */
-	session->ordered_events.next_flush = ULLONG_MAX;
-	err = ordered_events_flush(session, tool);
+	err = ordered_events_flush(session, tool, OEQ_FLUSH__FINAL);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
@@ -1381,8 +1407,7 @@ more:
 
 out:
 	/* do the final flush for ordered samples */
-	session->ordered_events.next_flush = ULLONG_MAX;
-	err = ordered_events_flush(session, tool);
+	err = ordered_events_flush(session, tool, OEQ_FLUSH__FINAL);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-- 
1.8.3.1

