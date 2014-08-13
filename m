Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaHMFPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:15:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaHMFPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:15:19 -0400
Date: Tue, 12 Aug 2014 22:14:57 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ggcas0xdq847fi85bz73do2e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Flush ordered events in case of allocation failure
Git-Commit-ID: d40b4a15ab2bfcfa7d946b69ca1f12c93b22d169
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d40b4a15ab2bfcfa7d946b69ca1f12c93b22d169
Gitweb:     http://git.kernel.org/tip/d40b4a15ab2bfcfa7d946b69ca1f12c93b22d169
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 1 Aug 2014 13:01:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:57 -0300

perf tools: Flush ordered events in case of allocation failure

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
index 258a527..7cccead 100644
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
index 8d4538c..bd2483b 100644
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
index e2fbaf2..a09e3c8 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -67,7 +67,8 @@ int perf_session__process_events(struct perf_session *session,
 				 struct perf_tool *tool);
 
 int perf_session_queue_event(struct perf_session *s, union perf_event *event,
-			     struct perf_sample *sample, u64 file_offset);
+			     struct perf_tool *tool, struct perf_sample *sample,
+			     u64 file_offset);
 
 void perf_tool__fill_defaults(struct perf_tool *tool);
 
