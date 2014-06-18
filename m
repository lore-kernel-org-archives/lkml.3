Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaFRO77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:59:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaFRO74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:59:56 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 16/18] perf tools: Add debug prints for ordered events queue
Date: Wed, 18 Jun 2014 16:58:57 +0200
Message-Id: <1403103539-16807-17-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some prints for ordered events queue, to help
debug issues.

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
 tools/perf/builtin-report.c      |  4 +++
 tools/perf/util/ordered-events.c | 54 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ordered-events.h |  2 ++
 3 files changed, 60 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 09b9d0c..130ab5c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -82,6 +82,10 @@ static int report__config(const char *var, const char *value, void *cb)
 		rep->queue_size = perf_config_u64(var, value);
 		return 0;
 	}
+	if (!strcmp(var, "report.queue-debug")) {
+		debug_sample_queue = perf_config_int(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index 946619c..662ee0c 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -4,6 +4,37 @@
 #include "session.h"
 #include "asm/bug.h"
 
+int debug_sample_queue;
+
+static int pr_level(int level, const char *fmt, ...)
+{
+	int ret = 0;
+
+	if (unlikely(debug_sample_queue >= level)) {
+		va_list args;
+
+		va_start(args, fmt);
+		ret = vfprintf(stderr, fmt, args);
+		va_end(args);
+	}
+
+	return ret;
+}
+
+#define pr_N(n, fmt, ...) \
+	pr_level(n, fmt, ##__VA_ARGS__)
+#define pr(fmt, ...)  pr_N(1, pr_fmt(fmt), ##__VA_ARGS__)
+
+static int pr_time(const char *str, u64 time)
+{
+	u64 secs, usecs, nsecs = time;
+
+	secs = nsecs / NSECS_PER_SEC;
+	nsecs -= secs * NSECS_PER_SEC;
+	usecs = nsecs / NSECS_PER_USEC;
+	return fprintf(stderr, "\t[%13lu.%06lu] %s\n", secs, usecs, str);
+}
+
 static void queue_event(struct ordered_events_queue *q, struct ordered_event *new)
 {
 	struct ordered_event *last = q->last;
@@ -68,6 +99,9 @@ static struct ordered_event *alloc_event(struct ordered_events_queue *q)
 		if (!q->buffer)
 			return NULL;
 
+		pr("alloc size %" PRIu64 "B, max %" PRIu64 "B\n",
+		   q->cur_alloc_size, q->max_alloc_size);
+
 		q->cur_alloc_size += size;
 		list_add(&q->buffer->list, &q->to_free);
 
@@ -183,6 +217,19 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 		break;
 	};
 
+	if (unlikely(debug_sample_queue)) {
+		static const char * const str[] = {
+			"FINAL",
+			"ROUND",
+			"HALF ",
+		};
+
+		fprintf(stderr, "ordered_events_flush %s, nr_events %u\n",
+			str[how], q->nr_events);
+		pr_time("next_flush",    q->next_flush);
+		pr_time("max_timestamp", q->max_timestamp);
+	}
+
 	err = __ordered_events_flush(s, tool);
 
 	if (!err) {
@@ -190,6 +237,13 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			q->next_flush = q->max_timestamp;
 	}
 
+	if (unlikely(debug_sample_queue)) {
+		fprintf(stderr, "ordered_events_flush nr_events %u\n",
+			q->nr_events);
+		pr_time("next_flush", q->next_flush);
+		pr_time("last_flush", q->last_flush);
+	}
+
 	return err;
 }
 
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 04cb295..8a717de 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -48,4 +48,6 @@ ordered_events_queue_alloc_size(struct ordered_events_queue *q, u64 size)
 {
 	q->max_alloc_size = size;
 }
+
+extern int debug_sample_queue;
 #endif /* __ORDERED_EVENTS_H */
-- 
1.8.3.1

