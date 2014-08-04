Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaHDQU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:20:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:39345 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaHDQUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:23 -0400
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
Subject: [PATCH 20/33] perf tools: Add debug prints for ordered events queue
Date: Mon,  4 Aug 2014 13:17:31 -0300
Message-Id: <1407169064-25625-21-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding some prints for ordered events queue, to help debug issues.

Adding debug_ordered_events debug variable to be able to enable ordered
events debug messages using:

  $ perf --debug ordered-events=2 report ...

Also using oe pointer in perf_session__queue_event instead of chained
session variable dereferencing.

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
Link: http://lkml.kernel.org/n/tip-7p3mnnopjvsp9nmk9msqcfkm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c          | 36 +++++++++++++++++++++++++++++++++++-
 tools/perf/util/debug.h          |  8 ++++++++
 tools/perf/util/ordered-events.c | 26 ++++++++++++++++++++++++++
 tools/perf/util/session.c        |  4 +++-
 4 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 71d419362634..ba357f3226c6 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -13,8 +13,12 @@
 #include "util.h"
 #include "target.h"
 
+#define NSECS_PER_SEC  1000000000ULL
+#define NSECS_PER_USEC 1000ULL
+
 int verbose;
 bool dump_trace = false, quiet = false;
+int debug_ordered_events;
 
 static int _eprintf(int level, int var, const char *fmt, va_list args)
 {
@@ -42,6 +46,35 @@ int eprintf(int level, int var, const char *fmt, ...)
 	return ret;
 }
 
+static int __eprintf_time(u64 t, const char *fmt, va_list args)
+{
+	int ret = 0;
+	u64 secs, usecs, nsecs = t;
+
+	secs   = nsecs / NSECS_PER_SEC;
+	nsecs -= secs  * NSECS_PER_SEC;
+	usecs  = nsecs / NSECS_PER_USEC;
+
+	ret = fprintf(stderr, "[%13" PRIu64 ".%06" PRIu64 "] ",
+		      secs, usecs);
+	ret += vfprintf(stderr, fmt, args);
+	return ret;
+}
+
+int eprintf_time(int level, int var, u64 t, const char *fmt, ...)
+{
+	int ret = 0;
+	va_list args;
+
+	if (var >= level) {
+		va_start(args, fmt);
+		ret = __eprintf_time(t, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
 /*
  * Overloading libtraceevent standard info print
  * function, display with -v in perf.
@@ -110,7 +143,8 @@ static struct debug_variable {
 	const char *name;
 	int *ptr;
 } debug_variables[] = {
-	{ .name = "verbose", .ptr = &verbose },
+	{ .name = "verbose",		.ptr = &verbose },
+	{ .name = "ordered-events",	.ptr = &debug_ordered_events},
 	{ .name = NULL, }
 };
 
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 89fb6b0f7ab2..6944ea3a119b 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -10,6 +10,7 @@
 
 extern int verbose;
 extern bool quiet, dump_trace;
+extern int debug_ordered_events;
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
@@ -29,6 +30,12 @@ extern bool quiet, dump_trace;
 #define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
 
+#define pr_time_N(n, var, t, fmt, ...) \
+	eprintf_time(n, var, t, fmt, ##__VA_ARGS__)
+
+#define pr_oe_time(t, fmt, ...)  pr_time_N(1, debug_ordered_events, t, pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_oe_time2(t, fmt, ...) pr_time_N(2, debug_ordered_events, t, pr_fmt(fmt), ##__VA_ARGS__)
+
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(union perf_event *event);
 
@@ -38,6 +45,7 @@ int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 void pr_stat(const char *fmt, ...);
 
 int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+int eprintf_time(int level, int var, u64 t, const char *fmt, ...) __attribute__((format(printf, 4, 5)));
 
 int perf_debug_option(const char *str);
 
diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 381d5fea1131..8a8aeab8e7ec 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -1,10 +1,16 @@
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
+#define pr(fmt, ...) pr_N(1, pr_fmt(fmt), ##__VA_ARGS__)
+
 static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 {
 	struct ordered_event *last = oe->last;
@@ -14,6 +20,8 @@ static void queue_event(struct ordered_events *oe, struct ordered_event *new)
 	++oe->nr_events;
 	oe->last = new;
 
+	pr_oe_time2(timestamp, "queue_event nr_events %u\n", oe->nr_events);
+
 	if (!last) {
 		list_add(&new->list, &oe->events);
 		oe->max_timestamp = timestamp;
@@ -69,12 +77,17 @@ static struct ordered_event *alloc_event(struct ordered_events *oe)
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
@@ -155,6 +168,11 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
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
@@ -184,6 +202,10 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 		break;
 	};
 
+	pr_oe_time(oe->next_flush, "next_flush - ordered_events__flush PRE  %s, nr_events %u\n",
+		   str[how], oe->nr_events);
+	pr_oe_time(oe->max_timestamp, "max_timestamp\n");
+
 	err = __ordered_events__flush(s, tool);
 
 	if (!err) {
@@ -191,6 +213,10 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			oe->next_flush = oe->max_timestamp;
 	}
 
+	pr_oe_time(oe->next_flush, "next_flush - ordered_events__flush POST %s, nr_events %u\n",
+		   str[how], oe->nr_events);
+	pr_oe_time(oe->last_flush, "last_flush\n");
+
 	return err;
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7d8dbf213d64..462be2749462 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -499,8 +499,10 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 	if (!timestamp || timestamp == ~0ULL)
 		return -ETIME;
 
-	if (timestamp < s->ordered_events.last_flush) {
+	if (timestamp < oe->last_flush) {
 		printf("Warning: Timestamp below last timeslice flush\n");
+		pr_oe_time(timestamp,      "out of order event");
+		pr_oe_time(oe->last_flush, "last flush");
 		return -EINVAL;
 	}
 
-- 
1.9.3

