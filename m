Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaGTV6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:58:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaGTV5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:57:07 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 16/19] perf tools: Add debug prints for ordered events queue
Date: Sun, 20 Jul 2014 23:56:00 +0200
Message-Id: <1405893363-21967-17-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some prints for ordered events queue, to help
debug issues.

Adding debug_ordered_events debug variable to be able
to enable ordered events debug messages using:
  $ perf --debug ordered-events=2 report ...

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
 tools/perf/util/debug.c          |  4 +++-
 tools/perf/util/debug.h          |  1 +
 tools/perf/util/ordered-events.c | 44 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 71d419362634..5c30f80f6295 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -15,6 +15,7 @@
 
 int verbose;
 bool dump_trace = false, quiet = false;
+int debug_ordered_events;
 
 static int _eprintf(int level, int var, const char *fmt, va_list args)
 {
@@ -110,7 +111,8 @@ static struct debug_variable {
 	const char *name;
 	int *ptr;
 } debug_variables[] = {
-	{ .name = "verbose", .ptr = &verbose },
+	{ .name = "verbose",		.ptr = &verbose },
+	{ .name = "ordered-events",	.ptr = &debug_ordered_events},
 	{ .name = NULL, }
 };
 
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 89fb6b0f7ab2..69340d3408e2 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -10,6 +10,7 @@
 
 extern int verbose;
 extern bool quiet, dump_trace;
+extern int debug_ordered_events;
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 6c48dfe24dc4..1a699fc16b92 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -1,10 +1,27 @@
 #include <linux/list.h>
+#include <linux/compiler.h>
 #include "ordered-events.h"
 #include "evlist.h"
 #include "session.h"
 #include "asm/bug.h"
 #include "debug.h"
 
+#define pr_N(n, fmt, ...) \
+	eprintf(n, debug_ordered_events, fmt, ##__VA_ARGS__)
+
+#define pr(fmt, ...)   pr_N(1, pr_fmt(fmt), ##__VA_ARGS__)
+
+static int pr_time(const char *str, u64 t)
+{
+	u64 secs, usecs, nsecs = t;
+
+	secs   = nsecs / NSECS_PER_SEC;
+	nsecs -= secs * NSECS_PER_SEC;
+	usecs  = nsecs / NSECS_PER_USEC;
+	return fprintf(stderr, "\t[%13" PRIu64 ".%06" PRIu64 "] %s\n",
+		       secs, usecs, str);
+}
+
 static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 {
 	struct ordered_event *last = oe->last;
@@ -14,6 +31,9 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 	++oe->nr_events;
 	oe->last = new;
 
+	if (unlikely(debug_ordered_events > 1))
+		pr_time("queue_event", timestamp);
+
 	if (!last) {
 		list_add(&new->list, &oe->events);
 		oe->max_timestamp = timestamp;
@@ -69,12 +89,17 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
 		if (!oe->buffer)
 			return NULL;
 
+		pr("alloc size %" PRIu64 "B (+%zu), max %" PRIu64 "B\n",
+		   oe->cur_alloc_size, size, oe->max_alloc_size);
+
 		oe->cur_alloc_size += size;
 		list_add(&oe->buffer->list, &oe->to_free);
 
 		/* First entry is abused to maintain the to_free list. */
 		oe->buffer_idx = 2;
 		new = oe->buffer + 1;
+	} else {
+		pr("allocation limit reached %" PRIu64 "B\n", oe->max_alloc_size);
 	}
 
 	return new;
@@ -155,6 +180,11 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			 enum oe_flush how)
 {
 	struct ordered_events *oe = &s->ordered_events;
+	static const char * const str[] = {
+		"FINAL",
+		"ROUND",
+		"HALF ",
+	};
 	int err;
 
 	switch (how) {
@@ -184,6 +214,13 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 		break;
 	};
 
+	if (unlikely(debug_ordered_events)) {
+		fprintf(stderr, "ordered_events_flush PRE  %s, nr_events %u\n",
+			str[how], oe->nr_events);
+		pr_time("next_flush",    oe->next_flush);
+		pr_time("max_timestamp", oe->max_timestamp);
+	}
+
 	err = __ordered_events_flush(s, tool);
 
 	if (!err) {
@@ -191,6 +228,13 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			oe->next_flush = oe->max_timestamp;
 	}
 
+	if (unlikely(debug_ordered_events)) {
+		fprintf(stderr, "ordered_events_flush POST %s, nr_events %u\n",
+			str[how], oe->nr_events);
+		pr_time("next_flush", oe->next_flush);
+		pr_time("last_flush", oe->last_flush);
+	}
+
 	return err;
 }
 
-- 
1.8.3.1

