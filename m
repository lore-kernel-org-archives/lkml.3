Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaFLWKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbaFLWKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:10:04 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/17] perf tools: Allow out of order messages in forced flush
Date: Fri, 13 Jun 2014 00:08:33 +0200
Message-Id: <1402610913-19059-18-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
References: <1402610913-19059-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In forced flush (OEQ_FLUSH__HALF) we break the rules of the
flush timestamp via PERF_RECORD_FINISHED_ROUND event, so
we could get out of order event.

Do not force error in this case and also changing the
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
 tools/perf/util/ordered-events.c | 4 ++++
 tools/perf/util/ordered-events.h | 2 ++
 tools/perf/util/session.c        | 8 ++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index c47475e..f92c2d0 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -212,12 +212,14 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 	}
 
 	case OEQ_FLUSH__ROUND:
+	case OEQ_FLUSH__NONE:
 	default:
 		break;
 	};
 
 	if (unlikely(debug_sample_queue)) {
 		static const char * const str[] = {
+			"NONE",
 			"FINAL",
 			"ROUND",
 			"HALF ",
@@ -234,6 +236,8 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 	if (!err) {
 		if (how == OEQ_FLUSH__ROUND)
 			q->next_flush = q->max_timestamp;
+
+		q->last_flush_type = how;
 	}
 
 	if (unlikely(debug_sample_queue)) {
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 8a717de..7e92688 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -14,6 +14,7 @@ struct ordered_event {
 };
 
 enum oeq_flush {
+	OEQ_FLUSH__NONE,
 	OEQ_FLUSH__FINAL,
 	OEQ_FLUSH__ROUND,
 	OEQ_FLUSH__HALF,
@@ -32,6 +33,7 @@ struct ordered_events_queue {
 	struct ordered_event	*last;
 	int			buffer_idx;
 	unsigned int		nr_events;
+	enum oeq_flush		last_flush_type;
 };
 
 struct ordered_event *ordered_events_get(struct ordered_events_queue *q,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 26bedac..a954702 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "cpumap.h"
 #include "perf_regs.h"
 #include "vdso.h"
+#include "asm/bug.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -502,8 +503,11 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 		return -ETIME;
 
 	if (timestamp < s->ordered_events.last_flush) {
-		printf("Warning: Timestamp below last timeslice flush\n");
-		return -EINVAL;
+		WARN_ONCE(1, "Timestamp below last timeslice flush\n");
+
+		/* We could get out of order messages after forced flush. */
+		if (q->last_flush_type != OEQ_FLUSH__HALF)
+			return -EINVAL;
 	}
 
 	new = ordered_events_get(q, timestamp);
-- 
1.8.3.1

