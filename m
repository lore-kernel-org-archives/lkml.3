Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaHDQTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:19:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:39022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaHDQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:19:12 -0400
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
Subject: [PATCH 12/33] perf tools: Flush ordered events in case of allocation failure
Date: Mon,  4 Aug 2014 13:17:23 -0300
Message-Id: <1407169064-25625-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

In previous patches we added a limit for ordered events queue allocation
size. If we reach this size we need to flush (part of) the queue to get
some free buffers.

The current functionality is not affected, because the limit is hard
coded to (u64) -1. The configuration code for size will come in
following patches.

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
Link: http://lkml.kernel.org/n/tip-ggcas0xdq847fi85bz73do2e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c  |  2 +-
 tools/perf/util/session.c | 29 +++++++++++++++++++++++++++--
 tools/perf/util/session.h |  3 ++-
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 258a5274099d..7ccceadcd9f8 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -732,7 +732,7 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
 			return -1;
 		}
 
-		err = perf_session_queue_event(kvm->session, event, &sample, 0);
+		err = perf_session_queue_event(kvm->session, event, &kvm->tool, &sample, 0);
 		/*
 		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
 		 *        point to it, and it'll get possibly overwritten by the kernel.
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8d4538c91076..bd2483b6b446 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,6 +14,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "perf_regs.h"
+#include "asm/bug.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -456,6 +457,7 @@ struct ordered_event {
 enum oe_flush {
 	OE_FLUSH__FINAL,
 	OE_FLUSH__ROUND,
+	OE_FLUSH__HALF,
 };
 
 static void perf_session_free_sample_buffers(struct perf_session *session)
@@ -637,6 +639,23 @@ static int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 		oe->next_flush = ULLONG_MAX;
 		break;
 
+	case OE_FLUSH__HALF:
+	{
+		struct ordered_event *first, *last;
+		struct list_head *head = &oe->events;
+
+		first = list_entry(head->next, struct ordered_event, list);
+		last = oe->last;
+
+		/* Warn if we are called before any event got allocated. */
+		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
+			return 0;
+
+		oe->next_flush  = first->timestamp;
+		oe->next_flush += (last->timestamp - first->timestamp) / 2;
+		break;
+	}
+
 	case OE_FLUSH__ROUND:
 	default:
 		break;
@@ -699,7 +718,8 @@ static int process_finished_round(struct perf_tool *tool,
 }
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
-				    struct perf_sample *sample, u64 file_offset)
+			     struct perf_tool *tool, struct perf_sample *sample,
+			     u64 file_offset)
 {
 	struct ordered_events *oe = &s->ordered_events;
 	u64 timestamp = sample->time;
@@ -714,6 +734,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 	}
 
 	new = ordered_events__new(oe, timestamp);
+	if (!new) {
+		ordered_events__flush(s, tool, OE_FLUSH__HALF);
+		new = ordered_events__new(oe, timestamp);
+	}
+
 	if (!new)
 		return -ENOMEM;
 
@@ -1121,7 +1146,7 @@ static s64 perf_session__process_event(struct perf_session *session,
 		return ret;
 
 	if (tool->ordered_events) {
-		ret = perf_session_queue_event(session, event, &sample,
+		ret = perf_session_queue_event(session, event, tool, &sample,
 					       file_offset);
 		if (ret != -ETIME)
 			return ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index e2fbaf2567e1..a09e3c8d825a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -67,7 +67,8 @@ int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool);
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
-			     struct perf_sample *sample, u64 file_offset);
+			     struct perf_tool *tool, struct perf_sample *sample,
+			     u64 file_offset);
 
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
-- 
1.9.3

