Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3GIQvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:51:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab3GIQvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:51:03 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 4/4] perf tools: Remove event types framework completely
Date: Tue,  9 Jul 2013 18:48:59 +0200
Message-Id: <1373388539-9347-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing event types framework completely. The only remainder
(apart from few comments) is following enum:

  enum perf_user_event_type {
    ...
    PERF_RECORD_HEADER_EVENT_TYPE           = 65, /* depreceated */
    ...
  }

It's kept as depreceated, resulting in error when processed
in perf_session__process_user_event function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>
---
 tools/perf/builtin-inject.c |  7 ----
 tools/perf/builtin-record.c |  7 ----
 tools/perf/builtin-report.c |  1 -
 tools/perf/builtin-script.c |  1 -
 tools/perf/util/event.h     |  2 +-
 tools/perf/util/header.c    | 90 ---------------------------------------------
 tools/perf/util/header.h    | 13 -------
 tools/perf/util/session.c   | 11 ------
 tools/perf/util/tool.h      |  3 --
 9 files changed, 1 insertion(+), 134 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ad1296c..1d8de2e 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -67,12 +67,6 @@ static int perf_event__repipe_op2_synth(struct perf_tool *tool,
 	return perf_event__repipe_synth(tool, event);
 }
 
-static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
-					       union perf_event *event)
-{
-	return perf_event__repipe_synth(tool, event);
-}
-
 static int perf_event__repipe_attr(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_evlist **pevlist)
@@ -402,7 +396,6 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.throttle	= perf_event__repipe,
 			.unthrottle	= perf_event__repipe,
 			.attr		= perf_event__repipe_attr,
-			.event_type	= perf_event__repipe_event_type_synth,
 			.tracing_data	= perf_event__repipe_op2_synth,
 			.finished_round	= perf_event__repipe_op2_synth,
 			.build_id	= perf_event__repipe_op2_synth,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1f5243c..a41ac415 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -474,13 +474,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			goto out_delete_session;
 		}
 
-		err = perf_event__synthesize_event_types(tool, process_synthesized_event,
-							 machine);
-		if (err < 0) {
-			pr_err("Couldn't synthesize event_types.\n");
-			goto out_delete_session;
-		}
-
 		if (have_tracepoints(&evsel_list->entries)) {
 			/*
 			 * FIXME err <= 0 here actually means that
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d1bd252..73759ac 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -741,7 +741,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			.lost		 = perf_event__process_lost,
 			.read		 = process_read_event,
 			.attr		 = perf_event__process_attr,
-			.event_type	 = perf_event__process_event_type,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
 			.ordered_samples = true,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3de8979..ecb6979 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -524,7 +524,6 @@ static struct perf_tool perf_script = {
 	.exit		 = perf_event__process_exit,
 	.fork		 = perf_event__process_fork,
 	.attr		 = perf_event__process_attr,
-	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
 	.build_id	 = perf_event__process_build_id,
 	.ordered_samples = true,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1813895..1ebb8fb 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -116,7 +116,7 @@ struct build_id_event {
 enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_USER_TYPE_START		= 64,
 	PERF_RECORD_HEADER_ATTR			= 64,
-	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
+	PERF_RECORD_HEADER_EVENT_TYPE		= 65, /* depreceated */
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8862667..b28a65e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -25,41 +25,9 @@
 
 static bool no_buildid_cache = false;
 
-static int trace_event_count;
-static struct perf_trace_event_type *trace_events;
-
 static u32 header_argc;
 static const char **header_argv;
 
-int perf_header__push_event(u64 id, const char *name)
-{
-	struct perf_trace_event_type *nevents;
-
-	if (strlen(name) > MAX_EVENT_NAME)
-		pr_warning("Event %s will be truncated\n", name);
-
-	nevents = realloc(trace_events, (trace_event_count + 1) * sizeof(*trace_events));
-	if (nevents == NULL)
-		return -ENOMEM;
-	trace_events = nevents;
-
-	memset(&trace_events[trace_event_count], 0, sizeof(struct perf_trace_event_type));
-	trace_events[trace_event_count].event_id = id;
-	strncpy(trace_events[trace_event_count].name, name, MAX_EVENT_NAME - 1);
-	trace_event_count++;
-	return 0;
-}
-
-char *perf_header__find_event(u64 id)
-{
-	int i;
-	for (i = 0 ; i < trace_event_count; i++) {
-		if (trace_events[i].event_id == id)
-			return trace_events[i].name;
-	}
-	return NULL;
-}
-
 /*
  * magic2 = "PERFILE2"
  * must be a numerical value to let the endianness
@@ -2936,64 +2904,6 @@ int perf_event__process_attr(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-int perf_event__synthesize_event_type(struct perf_tool *tool,
-				      u64 event_id, char *name,
-				      perf_event__handler_t process,
-				      struct machine *machine)
-{
-	union perf_event ev;
-	size_t size = 0;
-	int err = 0;
-
-	memset(&ev, 0, sizeof(ev));
-
-	ev.event_type.event_type.event_id = event_id;
-	memset(ev.event_type.event_type.name, 0, MAX_EVENT_NAME);
-	strncpy(ev.event_type.event_type.name, name, MAX_EVENT_NAME - 1);
-
-	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
-	size = strlen(ev.event_type.event_type.name);
-	size = PERF_ALIGN(size, sizeof(u64));
-	ev.event_type.header.size = sizeof(ev.event_type) -
-		(sizeof(ev.event_type.event_type.name) - size);
-
-	err = process(tool, &ev, NULL, machine);
-
-	return err;
-}
-
-int perf_event__synthesize_event_types(struct perf_tool *tool,
-				       perf_event__handler_t process,
-				       struct machine *machine)
-{
-	struct perf_trace_event_type *type;
-	int i, err = 0;
-
-	for (i = 0; i < trace_event_count; i++) {
-		type = &trace_events[i];
-
-		err = perf_event__synthesize_event_type(tool, type->event_id,
-							type->name, process,
-							machine);
-		if (err) {
-			pr_debug("failed to create perf header event type\n");
-			return err;
-		}
-	}
-
-	return err;
-}
-
-int perf_event__process_event_type(struct perf_tool *tool __maybe_unused,
-				   union perf_event *event)
-{
-	if (perf_header__push_event(event->event_type.event_type.event_id,
-				    event->event_type.event_type.name) < 0)
-		return -ENOMEM;
-
-	return 0;
-}
-
 int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 					struct perf_evlist *evlist,
 					perf_event__handler_t process)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 298982f..669fda5 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -102,9 +102,6 @@ int perf_session__write_header(struct perf_session *session,
 			       int fd, bool at_exit);
 int perf_header__write_pipe(int fd);
 
-int perf_header__push_event(u64 id, const char *name);
-char *perf_header__find_event(u64 id);
-
 void perf_header__set_feat(struct perf_header *header, int feat);
 void perf_header__clear_feat(struct perf_header *header, int feat);
 bool perf_header__has_feat(const struct perf_header *header, int feat);
@@ -132,16 +129,6 @@ int perf_event__synthesize_attrs(struct perf_tool *tool,
 int perf_event__process_attr(struct perf_tool *tool, union perf_event *event,
 			     struct perf_evlist **pevlist);
 
-int perf_event__synthesize_event_type(struct perf_tool *tool,
-				      u64 event_id, char *name,
-				      perf_event__handler_t process,
-				      struct machine *machine);
-int perf_event__synthesize_event_types(struct perf_tool *tool,
-				       perf_event__handler_t process,
-				       struct machine *machine);
-int perf_event__process_event_type(struct perf_tool *tool,
-				   union perf_event *event);
-
 int perf_event__synthesize_tracing_data(struct perf_tool *tool,
 					int fd, struct perf_evlist *evlist,
 					perf_event__handler_t process);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1eb58ee..d0d9f94 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -241,13 +241,6 @@ static int process_finished_round_stub(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-static int process_event_type_stub(struct perf_tool *tool __maybe_unused,
-				   union perf_event *event __maybe_unused)
-{
-	dump_printf(": unhandled!\n");
-	return 0;
-}
-
 static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
@@ -274,8 +267,6 @@ static void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->unthrottle = process_event_stub;
 	if (tool->attr == NULL)
 		tool->attr = process_event_synth_attr_stub;
-	if (tool->event_type == NULL)
-		tool->event_type = process_event_type_stub;
 	if (tool->tracing_data == NULL)
 		tool->tracing_data = process_event_synth_tracing_data_stub;
 	if (tool->build_id == NULL)
@@ -928,8 +919,6 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		if (err == 0)
 			perf_session__set_id_hdr_size(session);
 		return err;
-	case PERF_RECORD_HEADER_EVENT_TYPE:
-		return tool->event_type(tool, event);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(session->fd, file_offset, SEEK_SET);
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 88f8cbd..62b16b6 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -22,8 +22,6 @@ typedef int (*event_attr_op)(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_evlist **pevlist);
 
-typedef int (*event_simple_op)(struct perf_tool *tool, union perf_event *event);
-
 typedef int (*event_op2)(struct perf_tool *tool, union perf_event *event,
 			 struct perf_session *session);
 
@@ -39,7 +37,6 @@ struct perf_tool {
 			unthrottle;
 	event_attr_op	attr;
 	event_op2	tracing_data;
-	event_simple_op	event_type;
 	event_op2	finished_round,
 			build_id;
 	bool		ordered_samples;
-- 
1.7.11.7

