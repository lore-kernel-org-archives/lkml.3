Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaFRO7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaFRO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:59:35 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/18] perf tools: Flush ordered events in case of allocation failure
Date: Wed, 18 Jun 2014 16:58:49 +0200
Message-Id: <1403103539-16807-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In previous patches we added a limit for ordered events
queue allocation size. If we reach this size we need to
flush (part of) the queue to get some free buffers.

The current functionality is not affected, because the
limit is hard coded to (u64) -1. The configuration code
for size will come in following patches.

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
 tools/perf/builtin-kvm.c  |  2 +-
 tools/perf/util/session.c | 28 ++++++++++++++++++++++++++--
 tools/perf/util/session.h |  3 ++-
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b2f0ddb..b4fd302 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -902,7 +902,7 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
 			return -1;
 		}
 
-		err = perf_session_queue_event(kvm->session, event, &sample, 0);
+		err = perf_session_queue_event(kvm->session, event, &kvm->tool, &sample, 0);
 		/*
 		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
 		 *        point to it, and it'll get possibly overwritten by the kernel.
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5c00d9b..a76cfcf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "cpumap.h"
 #include "perf_regs.h"
 #include "vdso.h"
+#include "asm/bug.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -458,6 +459,7 @@ struct ordered_event {
 enum oeq_flush {
 	OEQ_FLUSH__FINAL,
 	OEQ_FLUSH__ROUND,
+	OEQ_FLUSH__HALF,
 };
 
 static void perf_session_free_sample_buffers(struct perf_session *session)
@@ -640,6 +642,22 @@ static int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 		q->next_flush = ULLONG_MAX;
 		break;
 
+	case OEQ_FLUSH__HALF:
+	{
+		struct ordered_event *first, *last;
+		struct list_head *head = &q->events;
+
+		first = list_entry(head->next, struct ordered_event, list);
+		last = q->last;
+
+		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
+			return 0;
+
+		q->next_flush  = first->timestamp;
+		q->next_flush += (last->timestamp - first->timestamp) / 2;
+		break;
+	}
+
 	case OEQ_FLUSH__ROUND:
 	default:
 		break;
@@ -702,7 +720,8 @@ static int process_finished_round(struct perf_tool *tool,
 }
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
-				    struct perf_sample *sample, u64 file_offset)
+			     struct perf_tool *tool, struct perf_sample *sample,
+			     u64 file_offset)
 {
 	struct ordered_events_queue *q = &s->ordered_events;
 	u64 timestamp = sample->time;
@@ -717,6 +736,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 	}
 
 	new = ordered_events_get(q, timestamp);
+	if (!new) {
+		ordered_events_flush(s, tool, OEQ_FLUSH__HALF);
+		new = ordered_events_get(q, timestamp);
+	}
+
 	if (!new)
 		return -ENOMEM;
 
@@ -1122,7 +1146,7 @@ static int perf_session__process_event(struct perf_session *session,
 		return ret;
 
 	if (tool->ordered_events) {
-		ret = perf_session_queue_event(session, event, &sample,
+		ret = perf_session_queue_event(session, event, tool, &sample,
 					       file_offset);
 		if (ret != -ETIME)
 			return ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9f64ac9..af38954 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -64,7 +64,8 @@ int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool);
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
-			     struct perf_sample *sample, u64 file_offset);
+			     struct perf_tool *tool, struct perf_sample *sample,
+			     u64 file_offset);
 
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
-- 
1.8.3.1

