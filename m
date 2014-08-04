Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaHDQUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:20:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:39385 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaHDQUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:31 -0400
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
Subject: [PATCH 21/33] perf tools: Allow out of order messages in forced flush
Date: Mon,  4 Aug 2014 13:17:32 -0300
Message-Id: <1407169064-25625-22-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

In forced flush (OE_FLUSH__HALF) we break the rules of the flush
timestamp via PERF_RECORD_FINISHED_ROUND event, so we could get out of
order event.

Do not force error in this case plus changing the output warning to use
WARN_ONCE.

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
Link: http://lkml.kernel.org/n/tip-8q8794a8nlmpd1u8xrqmcyd2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ordered-events.c |  4 ++++
 tools/perf/util/ordered-events.h |  2 ++
 tools/perf/util/session.c        | 12 +++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 8a8aeab8e7ec..706ce1a66169 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -169,6 +169,7 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 {
 	struct ordered_events *oe = &s->ordered_events;
 	static const char * const str[] = {
+		"NONE",
 		"FINAL",
 		"ROUND",
 		"HALF ",
@@ -198,6 +199,7 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 	}
 
 	case OE_FLUSH__ROUND:
+	case OE_FLUSH__NONE:
 	default:
 		break;
 	};
@@ -211,6 +213,8 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 	if (!err) {
 		if (how == OE_FLUSH__ROUND)
 			oe->next_flush = oe->max_timestamp;
+
+		oe->last_flush_type = how;
 	}
 
 	pr_oe_time(oe->next_flush, "next_flush - ordered_events__flush POST %s, nr_events %u\n",
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 2ce847fb48a5..3b2f20542a01 100644
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
 
 struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timestamp);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 462be2749462..7e27f1eb260c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,6 +14,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "perf_regs.h"
+#include "asm/bug.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -500,10 +501,15 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
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
 
 	new = ordered_events__new(oe, timestamp);
-- 
1.9.3

