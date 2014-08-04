Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaHDQTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:19:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:38919 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbaHDQTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:19:01 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/33] perf tools: Factor ordered_events__flush to be more generic
Date: Mon,  4 Aug 2014 13:17:21 -0300
Message-Id: <1407169064-25625-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Centralizing the next_flush calculation under the ordered_events__flush
function.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-srwunsy7o5wl17vpt4a10oxp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ff0188c65783..72c7b0d3d0dc 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -451,6 +451,11 @@ struct ordered_event {
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
@@ -564,8 +569,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static int ordered_events__flush(struct perf_session *s,
-				 struct perf_tool *tool)
+static int __ordered_events__flush(struct perf_session *s,
+				   struct perf_tool *tool)
 {
 	struct ordered_events *oe = &s->ordered_events;
 	struct list_head *head = &oe->events;
@@ -615,6 +620,32 @@ static int ordered_events__flush(struct perf_session *s,
 	return 0;
 }
 
+static int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
+				 enum oe_flush how)
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
+	err = __ordered_events__flush(s, tool);
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
@@ -658,11 +689,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = ordered_events__flush(session, tool);
-	if (!ret)
-		session->ordered_events.next_flush = session->ordered_events.max_timestamp;
-
-	return ret;
+	return ordered_events__flush(session, tool, OE_FLUSH__ROUND);
 }
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
@@ -1247,8 +1274,7 @@ more:
 		goto more;
 done:
 	/* do the final flush for ordered samples */
-	session->ordered_events.next_flush = ULLONG_MAX;
-	err = ordered_events__flush(session, tool);
+	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
@@ -1393,8 +1419,7 @@ more:
 
 out:
 	/* do the final flush for ordered samples */
-	session->ordered_events.next_flush = ULLONG_MAX;
-	err = ordered_events__flush(session, tool);
+	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-- 
1.9.3

