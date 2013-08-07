Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab3HGVRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:17:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab3HGVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 39/47] perf session: Export queue_event function
Date: Wed,  7 Aug 2013 18:11:06 -0300
Message-Id: <1375909874-22073-40-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Taking a lesson from perf-trace and bringing in control of event
processing to perf-kvm-stat-live: parse the sample to get access the
time leaving just the need to queue it to the ordered samples list.  For
that the queue_event function needs to be exported.

Unexport perf_session__process_event.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375753297-69645-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 10 +++++-----
 tools/perf/util/session.h |  6 ++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b5ebd47..dedaeb2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -643,7 +643,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 
 #define MAX_SAMPLE_BUFFER	(64 * 1024 / sizeof(struct sample_queue))
 
-static int perf_session_queue_event(struct perf_session *s, union perf_event *event,
+int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 				    struct perf_sample *sample, u64 file_offset)
 {
 	struct ordered_samples *os = &s->ordered_samples;
@@ -1049,10 +1049,10 @@ static void event_swap(union perf_event *event, bool sample_id_all)
 		swap(event, sample_id_all);
 }
 
-int perf_session__process_event(struct perf_session *session,
-				union perf_event *event,
-				struct perf_tool *tool,
-				u64 file_offset)
+static int perf_session__process_event(struct perf_session *session,
+				       union perf_event *event,
+				       struct perf_tool *tool,
+				       u64 file_offset)
 {
 	struct perf_sample sample;
 	int ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9818fc2..8bed17e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -56,10 +56,8 @@ int __perf_session__process_events(struct perf_session *self,
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_tool *tool);
 
-int perf_session__process_event(struct perf_session *session,
-				union perf_event *event,
-				struct perf_tool *tool,
-				u64 file_offset);
+int perf_session_queue_event(struct perf_session *s, union perf_event *event,
+			     struct perf_sample *sample, u64 file_offset);
 
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
-- 
1.8.1.4

