Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3JPFBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:01:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52946 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3JPFAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:00:30 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-3c-525e1d68394f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 16/18] perf ftrace: Show leaf-functions as oneliner
Date: Wed, 16 Oct 2013 14:00:19 +0900
Message-Id: <1381899621-14638-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
References: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Detect leaf functions and print them in a same line.

Note that it only converts leaf-functions that doesn't have any other
records between entry and exit even in other cpus.  I left other leaf
functions as is.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 87 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 2a7acdbd6985..94f911946ef8 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -893,34 +893,77 @@ function_handler(struct trace_seq *s, struct pevent_record *record,
 
 #define TRACE_GRAPH_INDENT  2
 
+static struct pevent_record *peek_ordered_record(struct perf_ftrace *ftrace);
+static struct pevent_record *get_ordered_record(struct perf_ftrace *ftrace);
+
+static struct event_format *fgraph_exit_event;
+
 static int
 fgraph_ent_handler(struct trace_seq *s, struct pevent_record *record,
-		   struct event_format *event, void *context __maybe_unused)
+		   struct event_format *event, void *context)
 {
 	unsigned long long depth;
 	unsigned long long val;
 	const char *func;
+	struct perf_ftrace *ftrace = context;
+	struct pevent_record *next;
+	bool is_leaf = false;
+	bool needs_free = false;
+	void *data;
+	int ret = -1;
 	int i;
 
+	/*
+	 * record->data can be invalidated after calling peek_ordered_record()
+	 * because it can unmap the current kbuffer page.  Make a copy.
+	 */
+	data = malloc(record->size);
+	if (data == NULL)
+		goto nested;
+
+	memcpy(data, record->data, record->size);
+	record->data = data;
+	needs_free = true;
+
+	/* detect leaf function and make it one-liner */
+	next = peek_ordered_record(ftrace);
+	if (next && next->cpu == record->cpu &&
+	    pevent_data_type(event->pevent, next) == fgraph_exit_event->id) {
+		is_leaf = true;
+		/* consume record */
+		get_ordered_record(ftrace);
+		free(next);
+	}
+
+nested:
 	if (pevent_get_field_val(s, event, "depth", record, &depth, 1))
-		return trace_seq_putc(s, '!');
+		goto out;
 
 	/* Function */
 	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
 		trace_seq_putc(s, ' ');
 
 	if (pevent_get_field_val(s, event, "func", record, &val, 1))
-		return trace_seq_putc(s, '!');
+		goto out;
 
 	func = pevent_find_function(event->pevent, val);
 
 	if (func)
-		trace_seq_printf(s, "%s() {", func);
+		trace_seq_printf(s, "%s()", func);
 	else
-		trace_seq_printf(s, "%llx() {", val);
+		trace_seq_printf(s, "%llx()", val);
 
-	trace_seq_putc(s, '\n');
-	return 0;
+	if (is_leaf)
+		trace_seq_puts(s, ";\n");
+	else
+		trace_seq_puts(s, " {\n");
+
+	ret = 0;
+out:
+	if (needs_free)
+		free(record->data);
+
+	return ret;
 }
 
 static int
@@ -1122,7 +1165,8 @@ get_ftrace_event_record(struct perf_ftrace *ftrace,
 	return fra->record;
 }
 
-static struct pevent_record *get_ordered_record(struct perf_ftrace *ftrace)
+static struct ftrace_report_arg *
+__get_ordered_record(struct perf_ftrace *ftrace)
 {
 	struct ftrace_report_arg *fra = NULL;
 	struct ftrace_report_arg *tmp;
@@ -1136,9 +1180,26 @@ static struct pevent_record *get_ordered_record(struct perf_ftrace *ftrace)
 			fra = tmp;
 		}
 	}
+	return fra;
+}
+
+static struct pevent_record *peek_ordered_record(struct perf_ftrace *ftrace)
+{
+	struct ftrace_report_arg *fra = __get_ordered_record(ftrace);
+
+	if (fra)
+		return fra->record;
+
+	return NULL;
+}
+
+static struct pevent_record *get_ordered_record(struct perf_ftrace *ftrace)
+{
+	struct ftrace_report_arg *fra = __get_ordered_record(ftrace);
 
 	if (fra) {
-		record = fra->record;
+		struct pevent_record *record = fra->record;
+
 		fra->record = NULL;
 		return record;
 	}
@@ -1194,10 +1255,10 @@ static int do_ftrace_show(struct perf_ftrace *ftrace)
 				      function_handler, NULL);
 	pevent_register_event_handler(ftrace->pevent, -1,
 				      "ftrace", "funcgraph_entry",
-				      fgraph_ent_handler, NULL);
+				      fgraph_ent_handler, ftrace);
 	pevent_register_event_handler(ftrace->pevent, -1,
 				      "ftrace", "funcgraph_exit",
-				      fgraph_ret_handler, NULL);
+				      fgraph_ret_handler, ftrace);
 
 	if (perf_session__process_events(session, &show.tool) < 0) {
 		pr_err("failed to process events\n");
@@ -1205,6 +1266,10 @@ static int do_ftrace_show(struct perf_ftrace *ftrace)
 		goto out;
 	}
 
+	fgraph_exit_event = pevent_find_event_by_name(ftrace->pevent, "ftrace",
+						     "funcgraph_exit");
+	BUG_ON(fgraph_exit_event == NULL);
+
 	trace_seq_init(&seq);
 
 	record = get_ordered_record(ftrace);
-- 
1.7.11.7

