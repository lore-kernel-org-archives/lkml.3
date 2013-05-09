Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3EIEe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:34:29 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63133 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3EIEcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:32:08 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 04/13] perf session: export a few functions for event processing
Date: Wed,  8 May 2013 22:31:40 -0600
Message-Id: <1368073909-8825-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows kvm live mode to reuse the event processing and ordered samples
processing used by the perf-report path.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/util/session.c |   14 +++++++-------
 tools/perf/util/session.h |    9 +++++++++
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7e2c4c7..355b01f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -248,7 +248,7 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
 
-static void perf_tool__fill_defaults(struct perf_tool *tool)
+void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
 		tool->sample = process_event_sample_stub;
@@ -494,8 +494,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static int flush_sample_queue(struct perf_session *s,
-			       struct perf_tool *tool)
+int flush_sample_queue(struct perf_session *s,
+		       struct perf_tool *tool)
 {
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
@@ -948,10 +948,10 @@ static void event_swap(union perf_event *event, bool sample_id_all)
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
index 6b51d47..864db2b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -58,6 +58,15 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_tool *tool);
 
+int perf_session__process_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_tool *tool,
+				u64 file_offset);
+
+int flush_sample_queue(struct perf_session *s, struct perf_tool *tool);
+
+void perf_tool__fill_defaults(struct perf_tool *tool);
+
 int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel *evsel,
 				    struct thread *thread,
 				    struct ip_callchain *chain,
-- 
1.7.10.1

