Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaHMFRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:17:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45008 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHMFRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:17:22 -0400
Date: Tue, 12 Aug 2014 22:17:04 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8q8794a8nlmpd1u8xrqmcyd2@git.kernel.org>
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
  Allow out of order messages in forced flush
Git-Commit-ID: b0a45203a75a800015828ac89f2945981019b65b
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

Commit-ID:  b0a45203a75a800015828ac89f2945981019b65b
Gitweb:     http://git.kernel.org/tip/b0a45203a75a800015828ac89f2945981019b65b
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 12 Jun 2014 09:50:11 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:02 -0300

perf tools: Allow out of order messages in forced flush

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
index 8a8aeab..706ce1a 100644
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
index 2ce847f..3b2f205 100644
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
index 462be27..7e27f1e 100644
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
