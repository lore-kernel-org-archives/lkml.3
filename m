Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab3HHCwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:52:08 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55341 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023Ab3HHCv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:59 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/19] perf sched timehist: Add pid/tid option
Date: Wed,  7 Aug 2013 22:51:01 -0400
Message-Id: <1375930261-77273-20-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows analysis of individual tasks within a file collected for the
entire system.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |   50 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1be9081..8e6ceee 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -17,6 +17,7 @@
 #include "util/debug.h"
 
 #include "util/strlist.h"
+#include "util/intlist.h"
 #include "asm/bug.h"
 #include <sys/prctl.h>
 #include <sys/resource.h>
@@ -178,6 +179,9 @@ struct perf_sched {
 	unsigned int	max_stack_depth;
 	bool		show_cpu_visual;
 	bool		skip_cs;
+	/* process and task id's of interest */
+	struct perf_target target;
+	struct intlist	*pid, *tid;
 };
 
 /* per thread run time data */
@@ -1897,6 +1901,18 @@ static struct thread *timehist_get_thread(struct perf_evsel *evsel,
 	return thread;
 }
 
+static bool timehist_skip_sample(struct perf_sched *sched,
+				       struct perf_sample *sample)
+{
+	if (sched->pid && intlist__find(sched->pid, sample->pid) == NULL)
+		return true;
+
+	if (sched->tid && intlist__find(sched->tid, sample->tid) == NULL)
+		return true;
+
+	return false;
+}
+
 static void timehist_print_sched_event(struct perf_tool *tool,
 			       struct perf_evsel *evsel,
 			       struct perf_sample *sample,
@@ -1908,6 +1924,9 @@ static void timehist_print_sched_event(struct perf_tool *tool,
 	const char *evname;
 	char tstr[64];
 
+	if (timehist_skip_sample(sched, sample))
+		return;
+
 	thread = machine__findnew_thread(machine, sample->tid);
 	if (thread == NULL)
 		return;
@@ -1969,6 +1988,9 @@ static int timehist_sched_change_event(struct perf_tool *tool,
 		}
 	}
 
+	if (timehist_skip_sample(sched, sample))
+		goto out;
+
 	tprev = perf_evsel__get_time(evsel, sample->cpu);
 	if (tprev)
 		dt_run = sample->time - tprev;
@@ -2167,6 +2189,27 @@ static int setup_excl_sym(void)
 	return 0;
 }
 
+static int parse_target_str(struct perf_sched *sched)
+{
+	if (sched->target.pid) {
+		sched->pid = intlist__new(sched->target.pid);
+		if (sched->pid == NULL) {
+			pr_err("Error parsing process id string\n");
+			return -EINVAL;
+		}
+	}
+
+	if (sched->target.tid) {
+		sched->tid = intlist__new(sched->target.tid);
+		if (sched->tid == NULL) {
+			pr_err("Error parsing thread id string\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int perf_sched__timehist(struct perf_sched *sched)
 {
 	const struct perf_evsel_str_handler handlers[] = {
@@ -2205,6 +2248,9 @@ static int perf_sched__timehist(struct perf_sched *sched)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (parse_target_str(sched) != 0)
+		goto out;
+
 	setup_pager();
 
 	if (timehist_check_attr(sched, session->evlist) != 0)
@@ -2484,6 +2530,10 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "file", "kallsyms pathname"),
 	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only display events for these comms"),
+	OPT_STRING('p', "pid", &sched.target.pid, "pid",
+		   "analyze events only for given process id(s)"),
+	OPT_STRING('t', "tid", &sched.target.tid, "tid",
+		   "analyze events only for given thread id(s)"),
 	OPT_UINTEGER('s', "stack-depth", &sched.max_stack_depth,
 		   "Maximum number of functions to display backtrace."),
 	OPT_STRING('x', "excl", &symbol_conf.excl_sym_list_str, "sym[,sym...]",
-- 
1.7.10.1

