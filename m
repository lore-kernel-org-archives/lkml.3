Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaGTV5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:57:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbaGTV5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:57:16 -0400
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
Date: Sun, 20 Jul 2014 23:56:03 +0200
Message-Id: <1405893363-21967-20-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
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
 tools/perf/util/ordered-events.c | 4 ++++
 tools/perf/util/ordered-events.h | 2 ++
 tools/perf/util/session.c        | 8 ++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index d7ee387cad51..5dbde56d69f6 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -181,6 +181,7 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 {
 	struct ordered_events *oe = &s->ordered_events;
 	static const char * const str[] = {
+		"NONE",
 		"FINAL",
 		"ROUND",
 		"HALF ",
@@ -210,6 +211,7 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 	}
 
 	case OE_FLUSH__ROUND:
+	case OE_FLUSH__NONE:
 	default:
 		break;
 	};
@@ -226,6 +228,8 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 	if (!err) {
 		if (how == OE_FLUSH__ROUND)
 			oe->next_flush = oe->max_timestamp;
+
+		oe->last_flush_type = how;
 	}
 
 	if (unlikely(debug_ordered_events)) {
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
index 4e748142a13f..3db8ab12f12d 100644
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
+		if (oe->last_flush_type != OE_FLUSH__HALF)
+			return -EINVAL;
 	}
 
 	new = ordered_events_new(oe, timestamp);
-- 
1.8.3.1

