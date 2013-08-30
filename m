Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3H3TBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:01:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45596 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3H3S7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/15] perf trace: Honor target pid / tid options when analyzing a file
Date: Fri, 30 Aug 2013 15:58:57 -0300
Message-Id: <1377889138-8793-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377889138-8793-1-git-send-email-acme@infradead.org>
References: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows capture of raw_syscall events for all processes or threads in a
task and then analyzing specific ones.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377750593-48046-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2a6ebe1..845facc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -8,6 +8,7 @@
 #include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/strlist.h"
+#include "util/intlist.h"
 #include "util/thread_map.h"
 
 #include <libaudit.h>
@@ -259,6 +260,8 @@ struct trace {
 	unsigned long		nr_events;
 	struct strlist		*ev_qualifier;
 	bool			not_ev_qualifier;
+	struct intlist		*tid_list;
+	struct intlist		*pid_list;
 	bool			sched;
 	bool			multiple_threads;
 	double			duration_filter;
@@ -653,6 +656,18 @@ out_dump:
 	return 0;
 }
 
+static bool skip_sample(struct trace *trace, struct perf_sample *sample)
+{
+	if ((trace->pid_list && intlist__find(trace->pid_list, sample->pid)) ||
+	    (trace->tid_list && intlist__find(trace->tid_list, sample->tid)))
+		return false;
+
+	if (trace->pid_list || trace->tid_list)
+		return true;
+
+	return false;
+}
+
 static int trace__process_sample(struct perf_tool *tool,
 				 union perf_event *event __maybe_unused,
 				 struct perf_sample *sample,
@@ -664,6 +679,9 @@ static int trace__process_sample(struct perf_tool *tool,
 
 	tracepoint_handler handler = evsel->handler.func;
 
+	if (skip_sample(trace, sample))
+		return 0;
+
 	if (trace->base_time == 0)
 		trace->base_time = sample->time;
 
@@ -683,6 +701,27 @@ perf_session__has_tp(struct perf_session *session, const char *name)
 	return evsel != NULL;
 }
 
+static int parse_target_str(struct trace *trace)
+{
+	if (trace->opts.target.pid) {
+		trace->pid_list = intlist__new(trace->opts.target.pid);
+		if (trace->pid_list == NULL) {
+			pr_err("Error parsing process id string\n");
+			return -EINVAL;
+		}
+	}
+
+	if (trace->opts.target.tid) {
+		trace->tid_list = intlist__new(trace->opts.target.tid);
+		if (trace->tid_list == NULL) {
+			pr_err("Error parsing thread id string\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -869,6 +908,10 @@ static int trace__replay(struct trace *trace)
 		goto out;
 	}
 
+	err = parse_target_str(trace);
+	if (err != 0)
+		goto out;
+
 	setup_pager();
 
 	err = perf_session__process_events(session, &trace->tool);
-- 
1.8.1.4

