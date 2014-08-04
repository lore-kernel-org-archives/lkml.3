Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaHDQTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:19:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:39204 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaHDQTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:19:49 -0400
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
Subject: [PATCH 17/33] perf tools: Add ordered_events__free function
Date: Mon,  4 Aug 2014 13:17:28 -0300
Message-Id: <1407169064-25625-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding ordered_events__free function to release all the struct
ordered_events data. It's replacement for former
perf_session_free_sample_buffers function.

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
Link: http://lkml.kernel.org/n/tip-urraa8ccay4o14wambjraws7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ordered-events.c | 11 +++++++++++
 tools/perf/util/ordered-events.h |  1 +
 tools/perf/util/session.c        | 17 ++---------------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 7b8923e12dc7..381d5fea1131 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -202,3 +202,14 @@ void ordered_events__init(struct ordered_events *oe)
 	oe->max_alloc_size = (u64) -1;
 	oe->cur_alloc_size = 0;
 }
+
+void ordered_events__free(struct ordered_events *oe)
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
index 62f9945319b6..6036bd657073 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -39,4 +39,5 @@ void ordered_events__delete(struct ordered_events *oe, struct ordered_event *eve
 int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
 void ordered_events__init(struct ordered_events *oe);
+void ordered_events__free(struct ordered_events *oe);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7f5851e433bb..7d8dbf213d64 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -442,19 +442,6 @@ static perf_event__swap_op perf_event__swap_ops[] = {
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
@@ -1092,7 +1079,7 @@ done:
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events__free(&session->ordered_events);
 	return err;
 }
 
@@ -1237,7 +1224,7 @@ out:
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
-	perf_session_free_sample_buffers(session);
+	ordered_events__free(&session->ordered_events);
 	session->one_mmap = false;
 	return err;
 }
-- 
1.9.3

