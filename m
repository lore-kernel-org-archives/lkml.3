Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbaJ2OIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:08:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:41479 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbaJ2OIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:08:43 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/25] perf probe: Add --quiet option to suppress output result message
Date: Wed, 29 Oct 2014 12:06:34 -0200
Message-Id: <1414591597-2763-23-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add --quiet(-q) option to suppress output result message for --add, and
--del options (Note that --lines/funcs/vars are not affected). This
option is useful if you run the perf probe inside your scripts.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20141027203131.21219.35170.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c    | 11 +++++++++++
 tools/perf/util/probe-event.c | 18 +++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 2d3577d1009d..921bb6942503 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -55,6 +55,7 @@ static struct {
 	bool show_funcs;
 	bool mod_events;
 	bool uprobes;
+	bool quiet;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
@@ -315,6 +316,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
+	OPT_BOOLEAN('q', "quiet", &params.quiet,
+		    "be quiet (do not show any mesages)"),
 	OPT_BOOLEAN('l', "list", &params.list_events,
 		    "list up current probe events"),
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
@@ -404,6 +407,14 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 	}
 
+	if (params.quiet) {
+		if (verbose != 0) {
+			pr_err("  Error: -v and -q are exclusive.\n");
+			return -EINVAL;
+		}
+		verbose = -1;
+	}
+
 	if (params.max_probe_points == 0)
 		params.max_probe_points = MAX_PROBES;
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c150ca4343eb..28eb1417cb2a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1910,21 +1910,21 @@ static int show_perf_probe_event(struct perf_probe_event *pev,
 	if (ret < 0)
 		return ret;
 
-	printf("  %-20s (on %s", buf, place);
+	pr_info("  %-20s (on %s", buf, place);
 	if (module)
-		printf(" in %s", module);
+		pr_info(" in %s", module);
 
 	if (pev->nargs > 0) {
-		printf(" with");
+		pr_info(" with");
 		for (i = 0; i < pev->nargs; i++) {
 			ret = synthesize_perf_probe_arg(&pev->args[i],
 							buf, 128);
 			if (ret < 0)
 				break;
-			printf(" %s", buf);
+			pr_info(" %s", buf);
 		}
 	}
-	printf(")\n");
+	pr_info(")\n");
 	free(place);
 	return ret;
 }
@@ -2124,7 +2124,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	printf("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
+	pr_info("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
 	for (i = 0; i < ntevs; i++) {
 		tev = &tevs[i];
 		if (pev->event)
@@ -2179,8 +2179,8 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 
 	if (ret >= 0) {
 		/* Show how to use the event. */
-		printf("\nYou can now use it in all perf tools, such as:\n\n");
-		printf("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
+		pr_info("\nYou can now use it in all perf tools, such as:\n\n");
+		pr_info("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
 			 tev->event);
 	}
 
@@ -2444,7 +2444,7 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
 		goto error;
 	}
 
-	printf("Removed event: %s\n", ent->s);
+	pr_info("Removed event: %s\n", ent->s);
 	return 0;
 error:
 	pr_warning("Failed to delete event: %s\n",
-- 
1.9.3

