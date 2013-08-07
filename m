Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab3HGVWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:22:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47020 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933387Ab3HGVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/47] perf session: Export a few functions for event processing
Date: Wed,  7 Aug 2013 18:10:45 -0300
Message-Id: <1375909874-22073-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows kvm live mode to reuse the event processing and ordered samples
processing used by the perf-report path.

v2: removed flush_sample_queue as noticed by Jiri

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375473947-64285-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 12 ++++++------
 tools/perf/util/session.h |  7 +++++++
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
1.8.1.4

