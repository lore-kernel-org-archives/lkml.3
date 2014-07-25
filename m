Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbaGYO4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbaGYO4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:56:50 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/19] perf tools: Factor ordered_events_flush to be more generic
Date: Fri, 25 Jul 2014 16:56:04 +0200
Message-Id: <1406300177-31805-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
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
index 12b72bc90125..f94ec7e55749 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -453,6 +453,11 @@ struct ordered_event {
 	struct list_head	list;
 };
 
+enum oe_flush {
+	OE_FLUSH__FINAL,
+	OE_FLUSH__ROUND,
+};
+
 static void perf_session_free_sample_buffers(struct perf_session *session)
 {
 	struct ordered_events *oe = &session->ordered_events;
@@ -566,8 +571,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static int ordered_events_flush(struct perf_session *s,
-		       struct perf_tool *tool)
+static int __ordered_events_flush(struct perf_session *s,
+				  struct perf_tool *tool)
 {
 	struct ordered_events *oe = &s->ordered_events;
 	struct list_head *head = &oe->events;
@@ -617,6 +622,32 @@ static int ordered_events_flush(struct perf_session *s,
 	return 0;
 }
 
+static int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
+				enum oe_flush how)
+{
+	struct ordered_events *oe = &s->ordered_events;
+	int err;
+
+	switch (how) {
+	case OE_FLUSH__FINAL:
+		oe->next_flush = ULLONG_MAX;
+		break;
+
+	case OE_FLUSH__ROUND:
+	default:
+		break;
+	};
+
+	err = __ordered_events_flush(s, tool);
+
+	if (!err) {
+		if (how == OE_FLUSH__ROUND)
+			oe->next_flush = oe->max_timestamp;
+	}
+
+	return err;
+}
+
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
@@ -660,11 +691,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = ordered_events_flush(session, tool);
-	if (!ret)
-		session->ordered_events.next_flush = session->ordered_events.max_timestamp;
-
-	return ret;
+	return ordered_events_flush(session, tool, OE_FLUSH__ROUND);
 }
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
@@ -1247,8 +1274,7 @@ more:
 		goto more;
 done:
 	/* do the final flush for ordered samples */
-	session->ordered_events.next_flush = ULLONG_MAX;
-	err = ordered_events_flush(session, tool);
+	err = ordered_events_flush(session, tool, OE_FLUSH__FINAL);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
@@ -1389,8 +1415,7 @@ more:
 
 out:
 	/* do the final flush for ordered samples */
-	session->ordered_events.next_flush = ULLONG_MAX;
-	err = ordered_events_flush(session, tool);
+	err = ordered_events_flush(session, tool, OE_FLUSH__FINAL);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-- 
1.8.3.1

