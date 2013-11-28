Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3K1LgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:36:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759094Ab3K1Lez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:34:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 27/29] perf tools: Add trace-event object
Date: Thu, 28 Nov 2013 12:33:26 +0100
Message-Id: <1385638408-23519-28-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace-event object to keep together 'struct pevent'
object with its loaded plugins with following interface:

int trace_event__init(struct trace_event *t);
  - initalizes 'struct pevent' object and loads plugins for it

void trace_event__cleanup(struct trace_event *t);
  - cleanups both 'struct pevent' and plugins

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
 tools/perf/Makefile.perf            |  1 +
 tools/perf/builtin-script.c         |  2 +-
 tools/perf/util/header.c            |  8 ++++----
 tools/perf/util/python-ext-sources  |  1 +
 tools/perf/util/session.h           |  3 ++-
 tools/perf/util/trace-event-parse.c | 13 -------------
 tools/perf/util/trace-event-read.c  | 20 +++++++++++---------
 tools/perf/util/trace-event.c       | 21 +++++++++++++++++++++
 tools/perf/util/trace-event.h       | 13 ++++++++++---
 9 files changed, 51 insertions(+), 31 deletions(-)
 create mode 100644 tools/perf/util/trace-event.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 4c894f4d..be336f8 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -353,6 +353,7 @@ LIB_OBJS += $(OUTPUT)util/pmu-bison.o
 LIB_OBJS += $(OUTPUT)util/trace-event-read.o
 LIB_OBJS += $(OUTPUT)util/trace-event-info.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
+LIB_OBJS += $(OUTPUT)util/trace-event.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 952dce9..715766d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1785,7 +1785,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			return -1;
 		}
 
-		err = scripting_ops->generate_script(session->pevent,
+		err = scripting_ops->generate_script(session->tevent.pevent,
 						     "perf-script");
 		goto out;
 	}
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1cd0357..0af4470 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2834,11 +2834,11 @@ int perf_session__read_header(struct perf_session *session)
 
 	symbol_conf.nr_events = nr_attrs;
 
-	perf_header__process_sections(header, fd, &session->pevent,
+	perf_header__process_sections(header, fd, &session->tevent,
 				      perf_file_section__process);
 
 	if (perf_evlist__prepare_tracepoint_events(session->evlist,
-						   session->pevent))
+						   session->tevent.pevent))
 		goto out_delete_evlist;
 
 	return 0;
@@ -3003,7 +3003,7 @@ int perf_event__process_tracing_data(struct perf_tool *tool __maybe_unused,
 	lseek(fd, offset + sizeof(struct tracing_data_event),
 	      SEEK_SET);
 
-	size_read = trace_report(fd, &session->pevent,
+	size_read = trace_report(fd, &session->tevent,
 				 session->repipe);
 	padding = PERF_ALIGN(size_read, sizeof(u64)) - size_read;
 
@@ -3025,7 +3025,7 @@ int perf_event__process_tracing_data(struct perf_tool *tool __maybe_unused,
 	}
 
 	perf_evlist__prepare_tracepoint_events(session->evlist,
-					       session->pevent);
+					       session->tevent.pevent);
 
 	return size_read + padding;
 }
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 239036f..595bfc7 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -18,4 +18,5 @@ util/cgroup.c
 util/rblist.c
 util/strlist.c
 util/fs.c
+util/trace-event.c
 ../../lib/rbtree.c
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 50f6409..83cba9b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_SESSION_H
 #define __PERF_SESSION_H
 
+#include "trace-event.h"
 #include "hist.h"
 #include "event.h"
 #include "header.h"
@@ -32,7 +33,7 @@ struct perf_session {
 	struct perf_header	header;
 	struct machines		machines;
 	struct perf_evlist	*evlist;
-	struct pevent		*pevent;
+	struct trace_event	tevent;
 	struct events_stats	stats;
 	bool			repipe;
 	struct ordered_samples	ordered_samples;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6681f71..e0d6d07f 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -28,19 +28,6 @@
 #include "util.h"
 #include "trace-event.h"
 
-struct pevent *read_trace_init(int file_bigendian, int host_bigendian)
-{
-	struct pevent *pevent = pevent_alloc();
-
-	if (pevent != NULL) {
-		pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
-		pevent_set_file_bigendian(pevent, file_bigendian);
-		pevent_set_host_bigendian(pevent, host_bigendian);
-	}
-
-	return pevent;
-}
-
 static int get_common_field(struct scripting_context *context,
 			    int *offset, int *size, const char *type)
 {
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index f211227..e113e18 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -343,7 +343,7 @@ static int read_event_files(struct pevent *pevent)
 	return 0;
 }
 
-ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
+ssize_t trace_report(int fd, struct trace_event *tevent, bool __repipe)
 {
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
@@ -356,11 +356,9 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	int host_bigendian;
 	int file_long_size;
 	int file_page_size;
-	struct pevent *pevent;
+	struct pevent *pevent = NULL;
 	int err;
 
-	*ppevent = NULL;
-
 	repipe = __repipe;
 	input_fd = fd;
 
@@ -390,12 +388,17 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	file_bigendian = buf[0];
 	host_bigendian = bigendian();
 
-	pevent = read_trace_init(file_bigendian, host_bigendian);
-	if (pevent == NULL) {
-		pr_debug("read_trace_init failed");
+	if (trace_event__init(tevent)) {
+		pr_debug("trace_event__init failed");
 		goto out;
 	}
 
+	pevent = tevent->pevent;
+
+	pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
+	pevent_set_file_bigendian(pevent, file_bigendian);
+	pevent_set_host_bigendian(pevent, host_bigendian);
+
 	if (do_read(buf, 1) < 0)
 		goto out;
 	file_long_size = buf[0];
@@ -432,11 +435,10 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 		pevent_print_printk(pevent);
 	}
 
-	*ppevent = pevent;
 	pevent = NULL;
 
 out:
 	if (pevent)
-		pevent_free(pevent);
+		trace_event__cleanup(tevent);
 	return size;
 }
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
new file mode 100644
index 0000000..a155a77
--- /dev/null
+++ b/tools/perf/util/trace-event.c
@@ -0,0 +1,21 @@
+
+#include <traceevent/event-parse.h>
+#include "trace-event.h"
+
+int trace_event__init(struct trace_event *t)
+{
+	struct pevent *pevent = pevent_alloc();
+
+	if (pevent) {
+		t->plugin_list = traceevent_load_plugins(pevent);
+		t->pevent  = pevent;
+	}
+
+	return pevent ? 0 : -1;
+}
+
+void trace_event__cleanup(struct trace_event *t)
+{
+	pevent_free(t->pevent);
+	traceevent_unload_plugins(t->plugin_list);
+}
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 04df631..75dded3 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -3,17 +3,24 @@
 
 #include <traceevent/event-parse.h>
 #include "parse-events.h"
-#include "session.h"
 
 struct machine;
 struct perf_sample;
 union perf_event;
 struct perf_tool;
 struct thread;
+struct plugin_list;
+
+struct trace_event {
+	struct pevent		*pevent;
+	struct plugin_list	*plugin_list;
+};
+
+int trace_event__init(struct trace_event *t);
+void trace_event__cleanup(struct trace_event *t);
 
 int bigendian(void);
 
-struct pevent *read_trace_init(int file_bigendian, int host_bigendian);
 void event_format__print(struct event_format *event,
 			 int cpu, void *data, int size);
 
@@ -27,7 +34,7 @@ raw_field_value(struct event_format *event, const char *name, void *data);
 void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size);
 void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size);
 
-ssize_t trace_report(int fd, struct pevent **pevent, bool repipe);
+ssize_t trace_report(int fd, struct trace_event *tevent, bool repipe);
 
 struct event_format *trace_find_next_event(struct pevent *pevent,
 					   struct event_format *event);
-- 
1.8.3.1

