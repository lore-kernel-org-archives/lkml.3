Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3HBUGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:06:03 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64578 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3HBUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:05:59 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 3/9] perf session: export a few functions for event processing
Date: Fri,  2 Aug 2013 14:05:41 -0600
Message-Id: <1375473947-64285-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375473947-64285-1-git-send-email-dsahern@gmail.com>
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows kvm live mode to reuse the event processing and ordered samples
processing used by the perf-report path.

v2: removed flush_sample_queue as noticed by Jiri

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/util/session.c |   12 ++++++------
 tools/perf/util/session.h |    7 +++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a0ce5a4..b5ebd47 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -250,7 +250,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
 
-static void perf_tool__fill_defaults(struct perf_tool *tool)
+void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
 		tool->sample = process_event_sample_stub;
@@ -495,7 +495,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      u64 file_offset);
 
 static int flush_sample_queue(struct perf_session *s,
-			       struct perf_tool *tool)
+		       struct perf_tool *tool)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
@@ -1049,10 +1049,10 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-static int perf_session__process_event(struct perf_session *session,
-				       union perf_event *event,
-				       struct perf_tool *tool,
-				       u64 file_offset)
+int perf_session__process_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_tool *tool,
+				u64 file_offset)
 {
 	struct perf_sample sample;
 	int ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ad8d3d4..9818fc2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -56,6 +56,13 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_tool *tool);
 
+int perf_session__process_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_tool *tool,
+				u64 file_offset);
+
+void perf_tool__fill_defaults(struct perf_tool *tool);
+
 int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
 				    struct thread *thread,
 				    struct ip_callchain *chain,
-- 
1.7.10.1

