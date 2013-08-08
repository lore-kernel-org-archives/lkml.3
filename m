Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032Ab3HHCwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:52:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64712 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016Ab3HHCvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:53 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/19] perf sched timehist: Add support for context-switch event
Date: Wed,  7 Aug 2013 22:50:59 -0400
Message-Id: <1375930261-77273-18-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context switch events are 64 bytes; sched_switch events are 136 bytes.
Both indicate scheduling changes, so allow user to leverage the smaller
event. If both events exist in a data file, then context-switch event is
ignored.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |   67 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a45a40f..f5e98f1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -177,6 +177,7 @@ struct perf_sched {
 	bool		no_callchain;
 	unsigned int	max_stack_depth;
 	bool		show_cpu_visual;
+	bool		skip_cs;
 };
 
 /* per thread run time data */
@@ -1674,8 +1675,17 @@ static int timehist_check_attr(struct perf_sched *sched,
 {
 	struct perf_evsel *evsel;
 	struct evsel_runtime *er;
+	const char *evname;
+	bool have_cs_event = false, have_sched_event = false;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
+		evname = perf_evsel__name(evsel);
+		if (strcmp(evname, "cs") == 0 ||
+		    strcmp(evname, "context-switch") == 0)
+			have_cs_event = true;
+		else if (strcmp(evname, "sched:sched_switch") == 0)
+			have_sched_event = true;
+
 		er = perf_evsel__get_runtime(evsel);
 		if (er == NULL) {
 			pr_err("Failed to allocate memory for evsel runtime data\n");
@@ -1689,6 +1699,11 @@ static int timehist_check_attr(struct perf_sched *sched,
 		}
 	}
 
+	if (have_cs_event && have_sched_event) {
+		pr_debug("Both schedule change events exist. Ignoring context-switch event\n");
+		sched->skip_cs = true;
+	}
+
 	return 0;
 }
 
@@ -1926,6 +1941,30 @@ out:
 	return rc;
 }
 
+static int timehist_cs_event(struct perf_tool *tool __maybe_unused,
+			       struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct machine *machine __maybe_unused)
+{
+	return timehist_sched_change_event(tool, evsel, sample, machine);
+}
+
+static void timehist_set_cs_handler(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	const char *evname;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		evname = perf_evsel__name(evsel);
+		if (strcmp(evname, "cs") == 0 ||
+		    strcmp(evname, "context-switch") == 0) {
+			evsel->handler.func = timehist_cs_event;
+		}
+	}
+
+	return;
+}
+
 static int timehist_sched_switch_event(struct perf_tool *tool,
 			       struct perf_evsel *evsel,
 			       struct perf_sample *sample,
@@ -2132,24 +2171,26 @@ static int perf_sched__timehist(struct perf_sched *sched)
 	}
 
 	/* setup per-evsel handlers */
-	if (perf_session__set_tracepoints_handlers(session, handlers))
-		goto out;
+	if (!sched->skip_cs)
+		timehist_set_cs_handler(session->evlist);
 
-	if (perf_session__has_traces(session, "record -R")) {
-		if (sched->show_events)
-			timehist_header(sched);
+	if (perf_session__has_traces(session, "sched record") &&
+	    perf_session__set_tracepoints_handlers(session, handlers))
+		goto out;
 
-		err = perf_session__process_events(session, &sched->tool);
-		if (err) {
-			pr_err("Failed to process events, error %d", err);
-			goto out;
-		}
+	if (sched->show_events)
+		timehist_header(sched);
 
-		sched->nr_events      = session->stats.nr_events[0];
-		sched->nr_lost_events = session->stats.total_lost;
-		sched->nr_lost_chunks = session->stats.nr_events[PERF_RECORD_LOST];
+	err = perf_session__process_events(session, &sched->tool);
+	if (err) {
+		pr_err("Failed to process events, error %d", err);
+		goto out;
 	}
 
+	sched->nr_events      = session->stats.nr_events[0];
+	sched->nr_lost_events = session->stats.total_lost;
+	sched->nr_lost_chunks = session->stats.nr_events[PERF_RECORD_LOST];
+
 	timehist_print_summary(session);
 
 out:
-- 
1.7.10.1

