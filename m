Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbaGYO5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933324AbaGYO5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:57:23 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 19/19] perf tools: Allow out of order messages in forced flush
Date: Fri, 25 Jul 2014 16:56:17 +0200
Message-Id: <1406300177-31805-20-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In forced flush (OE_FLUSH__HALF) we break the rules of the
flush timestamp via PERF_RECORD_FINISHED_ROUND event, so
we could get out of order event.

Do not force error in this case plus changing the
output warning to use WARN_ONCE.

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
 tools/perf/util/ordered-events.c |  4 ++++
 tools/perf/util/ordered-events.h |  2 ++
 tools/perf/util/session.c        | 12 +++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 292cb627e51a..a62c6a8cd24d 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -169,6 +169,7 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 {
 	struct ordered_events *oe = &s->ordered_events;
 	static const char * const str[] = {
+		"NONE",
 		"FINAL",
 		"ROUND",
 		"HALF ",
@@ -198,6 +199,7 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 	}
 
 	case OE_FLUSH__ROUND:
+	case OE_FLUSH__NONE:
 	default:
 		break;
 	};
@@ -211,6 +213,8 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 	if (!err) {
 		if (how == OE_FLUSH__ROUND)
 			oe->next_flush = oe->max_timestamp;
+
+		oe->last_flush_type = how;
 	}
 
 	pr_oe_time(oe->next_flush, "next_flush - ordered_events_flush POST %s, nr_events %u\n",
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index a4fc435f0fc6..6dd36dd01be6 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -14,6 +14,7 @@ struct ordered_event {
 };
 
 enum oe_flush {
+	OE_FLUSH__NONE,
 	OE_FLUSH__FINAL,
 	OE_FLUSH__ROUND,
 	OE_FLUSH__HALF,
@@ -32,6 +33,7 @@ struct ordered_events {
 	struct ordered_event	*last;
 	int			buffer_idx;
 	unsigned int		nr_events;
+	enum oe_flush		last_flush_type;
 };
 
 struct ordered_event *ordered_events_new(struct ordered_events *oe, u64 timestamp);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fe868abd6c87..02dd6c65d8b8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "cpumap.h"
 #include "perf_regs.h"
 #include "vdso.h"
+#include "asm/bug.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -502,10 +503,15 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -ETIME;
 
 	if (timestamp < oe->last_flush) {
-		printf("Warning: Timestamp below last timeslice flush\n");
+		WARN_ONCE(1, "Timestamp below last timeslice flush\n");
+
 		pr_oe_time(timestamp,      "out of order event");
-		pr_oe_time(oe->last_flush, "last flush");
-		return -EINVAL;
+		pr_oe_time(oe->last_flush, "last flush, last_flush_type %d\n",
+			   oe->last_flush_type);
+
+		/* We could get out of order messages after forced flush. */
+		if (oe->last_flush_type != OE_FLUSH__HALF)
+			return -EINVAL;
 	}
 
 	new = ordered_events_new(oe, timestamp);
-- 
1.8.3.1

