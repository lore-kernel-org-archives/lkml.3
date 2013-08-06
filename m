Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3HFBmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:42:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55823 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3HFBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:41:46 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 1/5] perf session: Export queue_event function
Date: Mon,  5 Aug 2013 21:41:33 -0400
Message-Id: <1375753297-69645-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taking a lesson from perf-trace and bringing in control of event
processing to perf-kvm-stat-live: parse the sample to get access the
time leaving just the need to queue it to the ordered samples list.
For that the queue_event function needs to be exported.

Unexport perf_session__process_event.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/util/session.c |   10 +++++-----
 tools/perf/util/session.h |    6 ++----
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
1.7.10.1

