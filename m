Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3LCNKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3LCNKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:10:36 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/28] perf tools: Add trace-event global object for tracepoint interface
Date: Tue,  3 Dec 2013 14:09:24 +0100
Message-Id: <1386076182-14484-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get the proper plugins processing we need to
use full trace-event interface when creating tracepoint
events. So far we were using shortcut to get the parsed
format.

Moving current 'event_format__new' function into trace-event
object as 'trace_event__tp_format'.

This function uses properly initialized global trace-event
object, ensuring proper plugins processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-trace.c    |  5 ++--
 tools/perf/util/evsel.c       | 44 ++-----------------------------
 tools/perf/util/trace-event.c | 61 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/trace-event.h |  2 ++
 4 files changed, 68 insertions(+), 44 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9f2a242..56afe33 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -11,6 +11,7 @@
 #include "util/intlist.h"
 #include "util/thread_map.h"
 #include "util/stat.h"
+#include "trace-event.h"
 
 #include <libaudit.h>
 #include <stdlib.h>
@@ -1430,11 +1431,11 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	sc->fmt  = syscall_fmt__find(sc->name);
 
 	snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->name);
-	sc->tp_format = event_format__new("syscalls", tp_name);
+	sc->tp_format = trace_event__tp_format("syscalls", tp_name);
 
 	if (sc->tp_format == NULL && sc->fmt && sc->fmt->alias) {
 		snprintf(tp_name, sizeof(tp_name), "sys_enter_%s", sc->fmt->alias);
-		sc->tp_format = event_format__new("syscalls", tp_name);
+		sc->tp_format = trace_event__tp_format("syscalls", tp_name);
 	}
 
 	if (sc->tp_format == NULL)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6a046ed..7b510fd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -23,6 +23,7 @@
 #include "target.h"
 #include "perf_regs.h"
 #include "debug.h"
+#include "trace-event.h"
 
 static struct {
 	bool sample_id_all;
@@ -180,47 +181,6 @@ struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
-struct event_format *event_format__new(const char *sys, const char *name)
-{
-	int fd, n;
-	char *filename;
-	void *bf = NULL, *nbf;
-	size_t size = 0, alloc_size = 0;
-	struct event_format *format = NULL;
-
-	if (asprintf(&filename, "%s/%s/%s/format", tracing_events_path, sys, name) < 0)
-		goto out;
-
-	fd = open(filename, O_RDONLY);
-	if (fd < 0)
-		goto out_free_filename;
-
-	do {
-		if (size == alloc_size) {
-			alloc_size += BUFSIZ;
-			nbf = realloc(bf, alloc_size);
-			if (nbf == NULL)
-				goto out_free_bf;
-			bf = nbf;
-		}
-
-		n = read(fd, bf + size, alloc_size - size);
-		if (n < 0)
-			goto out_free_bf;
-		size += n;
-	} while (n > 0);
-
-	pevent_parse_format(NULL, &format, bf, size, sys);
-
-out_free_bf:
-	free(bf);
-	close(fd);
-out_free_filename:
-	free(filename);
-out:
-	return format;
-}
-
 struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
@@ -235,7 +195,7 @@ struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int
 		if (asprintf(&evsel->name, "%s:%s", sys, name) < 0)
 			goto out_free;
 
-		evsel->tp_format = event_format__new(sys, name);
+		evsel->tp_format = trace_event__tp_format(sys, name);
 		if (evsel->tp_format == NULL)
 			goto out_free;
 
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index a155a77..d9f5f61 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -1,6 +1,24 @@
 
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <linux/kernel.h>
 #include <traceevent/event-parse.h>
 #include "trace-event.h"
+#include "util.h"
+
+/*
+ * global trace_event object used by trace_event__tp_format
+ *
+ * TODO There's no cleanup call for this. Add some sort of
+ * __exit function support and call trace_event__cleanup
+ * there.
+ */
+static struct trace_event tevent;
 
 int trace_event__init(struct trace_event *t)
 {
@@ -19,3 +37,46 @@ void trace_event__cleanup(struct trace_event *t)
 	pevent_free(t->pevent);
 	traceevent_unload_plugins(t->plugin_list);
 }
+
+static struct event_format*
+tp_format(const char *sys, const char *name)
+{
+	struct pevent *pevent = tevent.pevent;
+	struct event_format *event = NULL;
+	char path[PATH_MAX];
+	size_t size;
+	char *data;
+
+	scnprintf(path, PATH_MAX, "%s/%s/%s/format",
+		  tracing_events_path, sys, name);
+
+	if (filename__read_str(path, &data, &size))
+		return NULL;
+
+	pevent_parse_format(pevent, &event, data, size, sys);
+
+	free(data);
+	return event;
+}
+
+struct event_format*
+trace_event__tp_format(const char *sys, const char *name)
+{
+	static bool initialized;
+
+	if (!initialized) {
+		int be = traceevent_host_bigendian();
+		struct pevent *pevent;
+
+		if (trace_event__init(&tevent))
+			return NULL;
+
+		pevent = tevent.pevent;
+		pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
+		pevent_set_file_bigendian(pevent, be);
+		pevent_set_host_bigendian(pevent, be);
+		initialized = true;
+	}
+
+	return tp_format(sys, name);
+}
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 75dded3..3a01618 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -18,6 +18,8 @@ struct trace_event {
 
 int trace_event__init(struct trace_event *t);
 void trace_event__cleanup(struct trace_event *t);
+struct event_format*
+trace_event__tp_format(const char *sys, const char *name);
 
 int bigendian(void);
 
-- 
1.8.3.1

