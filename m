Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3H0Dwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:52:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49057 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3H0Dw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:52:29 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf trace: Honor target pid / tid options when analyzing a file
Date: Mon, 26 Aug 2013 21:52:15 -0600
Message-Id: <1377575535-43544-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1377575535-43544-1-git-send-email-dsahern@gmail.com>
References: <1377575535-43544-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows capture of raw_syscall events for all processes or threads in a task
and then analyzing specific ones.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-trace.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a0a1540..ef957a1 100644
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
@@ -649,6 +652,18 @@ out_dump:
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
@@ -660,6 +675,9 @@ static int trace__process_sample(struct perf_tool *tool,
 
 	tracepoint_handler handler = evsel->handler.func;
 
+	if (skip_sample(trace, sample))
+		return 0;
+
 	if (trace->base_time == 0)
 		trace->base_time = sample->time;
 
@@ -679,6 +697,27 @@ perf_session__has_tp(struct perf_session *session, const char *name)
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
@@ -861,6 +900,10 @@ static int trace__replay(struct trace *trace)
 		goto out;
 	}
 
+	err = parse_target_str(trace);
+	if (err != 0)
+		goto out;
+
 	setup_pager();
 
 	err = perf_session__process_events(session, &trace->tool);
-- 
1.7.10.1

