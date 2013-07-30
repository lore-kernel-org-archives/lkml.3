Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3G3JTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:19:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47887 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3G3JTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:19:31 -0400
X-AuditID: 9c930179-b7c49ae000000e68-fe-51f7851b4c51
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 17/17] perf ftrace: Tidy up the function graph output of 'show' subcommand
Date: Tue, 30 Jul 2013 18:19:14 +0900
Message-Id: <1375175954-798-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375175954-798-1-git-send-email-namhyung@kernel.org>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now it doesn't call pevent_print_event() but prints context info in
itself using print_graph_duration().  Make it compact by only print
cpu number and duration:

  # perf ftrace show
  ...
   10)   0.065 us |  __fsnotify_parent();
   10)            |  fsnotify() {
   10)   0.060 us |    __srcu_read_lock();
   10)   0.040 us |    __srcu_read_unlock();
   10)   0.652 us |  }
   10)   0.040 us |  fput();
   10)            |  __audit_syscall_exit() {
   10)            |    path_put() {
   10)   0.037 us |      dput();
   10)   0.032 us |      mntput();
   10)   0.563 us |    }
   10)   0.035 us |    unroll_tree_refs();
   10)   0.035 us |    kfree();
   10)   1.284 us |  }
   10)            |  __audit_syscall_entry() {
   10)   0.029 us |    current_kernel_time();
   10)   0.239 us |  }

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 8d4ec20e3854..9e78ec19caeb 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -879,6 +879,27 @@ static struct pevent_record *get_ordered_record(struct perf_ftrace *ftrace);
 
 static struct event_format *fgraph_exit_event;
 
+static void
+print_graph_duration(struct trace_seq *s, struct event_format *event,
+		     struct pevent_record *record)
+{
+	unsigned long long duration;
+	unsigned long long rettime, calltime;
+	unsigned long usec, nsec;
+
+	if (pevent_get_field_val(s, event, "rettime", record, &rettime, 1))
+		return;
+
+	if (pevent_get_field_val(s, event, "calltime", record, &calltime, 1))
+		return;
+
+	duration = rettime - calltime;
+	usec = duration / 1000;
+	nsec = duration % 1000;
+
+	trace_seq_printf(s, "%3d) %3lu.%03lu us |  ", record->cpu, usec, nsec);
+}
+
 static int
 fgraph_ent_handler(struct trace_seq *s, struct pevent_record *record,
 		   struct event_format *event, void *context)
@@ -911,9 +932,14 @@ fgraph_ent_handler(struct trace_seq *s, struct pevent_record *record,
 	if (next && next->cpu == record->cpu &&
 	    pevent_data_type(event->pevent, next) == fgraph_exit_event->id) {
 		is_leaf = true;
+
+		print_graph_duration(s, fgraph_exit_event, next);
+
 		/* consume record */
 		get_ordered_record(ftrace);
 		free(next);
+	} else {
+		trace_seq_printf(s, "%3d) %*s |  ", record->cpu, 10, "");
 	}
 
 nested:
@@ -954,6 +980,8 @@ fgraph_ret_handler(struct trace_seq *s, struct pevent_record *record,
 	unsigned long long depth;
 	int i;
 
+	print_graph_duration(s, event, record);
+
 	if (pevent_get_field_val(s, event, "depth", record, &depth, 1))
 		return trace_seq_putc(s, '!');
 
@@ -1265,9 +1293,12 @@ static int do_ftrace_show(struct perf_ftrace *ftrace)
 			continue;
 		}
 
-		pevent_print_event(ftrace->pevent, &seq, record);
-		trace_seq_do_printf(&seq);
+		if (!strcmp(ftrace->tracer, "function_graph"))
+			pevent_event_info(&seq, event, record);
+		else
+			pevent_print_event(ftrace->pevent, &seq, record);
 
+		trace_seq_do_printf(&seq);
 		trace_seq_reset(&seq);
 
 		free(record);
-- 
1.7.11.7

