Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3KRUem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:34:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50296 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3KRUdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:13 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 7/8] perf sched timehist: Add support for context-switch event
Date: Mon, 18 Nov 2013 13:32:50 -0700
Message-Id: <1384806771-2945-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context switch events are 64 bytes; sched_switch events are 136 bytes.  Both
indicate scheduling changes, so allow user to leverage the smaller event. If
both events exist in a data file, then context-switch event is ignored.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/builtin-sched.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ffe11067083c..79a94655d3ed 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -180,6 +180,7 @@ struct perf_sched {
 	unsigned int	max_stack;
 	bool		show_cpu_visual;
 	bool		show_wakeups;
+	bool		have_traces;
 	/* process and task id's of interest */
 	struct target target;
 	struct intlist  *pid, *tid;
@@ -2070,6 +2071,15 @@ out:
 	return rc;
 }
 
+static int timehist_cs_event(struct perf_tool *tool __maybe_unused,
+			     union perf_event *event,
+			     struct perf_evsel *evsel,
+			     struct perf_sample *sample,
+			     struct machine *machine __maybe_unused)
+{
+	return timehist_sched_change_event(tool, event, evsel, sample, machine);
+}
+
 static int timehist_sched_switch_event(struct perf_tool *tool,
 				       union perf_event *event,
 				       struct perf_evsel *evsel,
@@ -2293,10 +2303,25 @@ static int parse_target_str(struct perf_sched *sched)
 static int timehist_check_attr(struct perf_sched *sched,
 			       struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel, *cs_evsel = NULL;
 	struct evsel_runtime *er;
+	const char *evname;
+	bool have_cs_event = false, have_sched_event = false;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->attr.type == PERF_TYPE_TRACEPOINT)
+			sched->have_traces = true;
+
+		evname = perf_evsel__name(evsel);
+		if (strcmp(evname, "cs") == 0 ||
+		    strcmp(evname, "context-switch") == 0) {
+			cs_evsel = evsel;
+			have_cs_event = true;
+		} else if (strcmp(evname, "sched:sched_switch") == 0) {
+			have_sched_event = true;
+		}
+
+
 		er = perf_evsel__get_runtime(evsel);
 		if (er == NULL) {
 			pr_err("Failed to allocate memory for evsel runtime data\n");
@@ -2311,6 +2336,13 @@ static int timehist_check_attr(struct perf_sched *sched,
 		}
 	}
 
+	if (have_cs_event && have_sched_event) {
+		pr_debug("Both schedule change events exist. Ignoring context-switch event\n");
+	} else if (have_cs_event) {
+		pr_debug("Using context-switch events.\n");
+		cs_evsel->handler = timehist_cs_event;
+	}
+
 	return 0;
 }
 
@@ -2367,10 +2399,8 @@ static int perf_sched__timehist(struct perf_sched *sched)
 	setup_pager();
 
 	/* setup per-evsel handlers */
-	if (perf_session__set_tracepoints_handlers(session, handlers))
-		goto out;
-
-	if (!perf_session__has_traces(session, "record -R"))
+	if (sched->have_traces &&
+	    perf_session__set_tracepoints_handlers(session, handlers))
 		goto out;
 
 	/* pre-allocate struct for per-CPU idle stats */
-- 
1.8.3.4 (Apple Git-47)

