Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaGPUDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:03:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaGPUDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 13/13] perf tools: Add a --no-desc flag to perf list
Date: Wed, 16 Jul 2014 22:02:49 +0200
Message-Id: <1405540969-18975-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a --no-desc flag to perf list to not print the event descriptions
that were earlier added for JSON events. This may be useful to
get a less crowded listing.

It's still default to print descriptions as that is the more useful
default for most users.

Before:

% perf list
...
  baclears.any                                       [Counts the total number when the front end is
                                                      resteered, mainly when the BPU cannot provide a
                                                      correct prediction and this is corrected by other
                                                      branch handling mechanisms at the front end]
  br_inst_exec.all_branches                          [Speculative and retired branches]

After:

% perf list --no-desc
...
  baclears.any                                       [Kernel PMU event]
  br_inst_exec.all_branches                          [Kernel PMU event]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/n/1405123165-22666-12-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-list.txt |  5 ++++-
 tools/perf/builtin-list.c              | 14 +++++++++-----
 tools/perf/util/parse-events.c         |  4 ++--
 tools/perf/util/parse-events.h         |  2 +-
 tools/perf/util/pmu.c                  |  4 ++--
 tools/perf/util/pmu.h                  |  2 +-
 6 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index d241b5c8708f..7a6b25d14afa 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -8,7 +8,7 @@ perf-list - List all symbolic event types
 SYNOPSIS
 --------
 [verse]
-'perf list' [hw|sw|cache|tracepoint|pmu|event_glob]
+'perf list' [--no-desc] [hw|sw|cache|tracepoint|pmu|event_glob]
 
 DESCRIPTION
 -----------
@@ -23,6 +23,9 @@ automatically downloaded with perf download.
 The JSON event file can be also specified with the EVENTMAP environment
 variable.
 
+--no-desc::
+Don't print descriptions.
+
 
 [[EVENT_MODIFIERS]] EVENT MODIFIERS
 ---------------
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 086c96fa959b..68752a1bac71 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -16,16 +16,20 @@
 #include "util/pmu.h"
 #include "util/parse-options.h"
 
+static bool desc_flag = true;
+
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
 	const struct option list_options[] = {
 		OPT_STRING(0, "events-file", &json_file, "json file",
 			   "Read event json file"),
+		OPT_BOOLEAN('d', "desc", &desc_flag,
+			    "Print extra event descriptions. --no-desc to not print."),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
-		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
+		"perf list [--events-file FILE] [--no-desc] [hw|sw|cache|tracepoint|pmu|event_glob]",
 		NULL
 	};
 
@@ -35,7 +39,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 	setup_pager();
 
 	if (argc == 0) {
-		print_events(NULL, false);
+		print_events(NULL, false, !desc_flag);
 		return 0;
 	}
 
@@ -54,15 +58,15 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			 strcmp(argv[i], "hwcache") == 0)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
-			print_pmu_events(NULL, false);
+			print_pmu_events(NULL, false, !desc_flag);
 		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
+			print_events(NULL, true, !desc_flag);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
 
 			if (sep == NULL) {
-				print_events(argv[i], false);
+				print_events(argv[i], false, !desc_flag);
 				continue;
 			}
 			sep_idx = sep - argv[i];
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1e15df10a88c..e2badf35a0ea 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1231,7 +1231,7 @@ static void print_symbol_events(const char *event_glob, unsigned type,
 /*
  * Print the help text for the event symbols:
  */
-void print_events(const char *event_glob, bool name_only)
+void print_events(const char *event_glob, bool name_only, bool quiet)
 {
 	if (!name_only) {
 		printf("\n");
@@ -1246,7 +1246,7 @@ void print_events(const char *event_glob, bool name_only)
 
 	print_hwcache_events(event_glob, name_only);
 
-	print_pmu_events(event_glob, name_only);
+	print_pmu_events(event_glob, name_only, quiet);
 
 	if (event_glob != NULL)
 		return;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4ed5ed..f3ef0dc94cb7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -100,7 +100,7 @@ void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(void *data, void *scanner, char const *msg);
 
-void print_events(const char *event_glob, bool name_only);
+void print_events(const char *event_glob, bool name_only, bool quiet);
 void print_events_type(u8 type);
 void print_tracepoint_events(const char *subsys_glob, const char *event_glob,
 			     bool name_only);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 397e4004fcdf..b10393267b1f 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -790,7 +790,7 @@ static void wordwrap(char *s, int start, int max, int corr)
 	}
 }
 
-void print_pmu_events(const char *event_glob, bool name_only)
+void print_pmu_events(const char *event_glob, bool name_only, bool quiet_flag)
 {
 	struct perf_pmu *pmu;
 	struct perf_pmu_alias *alias;
@@ -838,7 +838,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			printf("%s ", aliases[j].name);
 			continue;
 		}
-		if (aliases[j].desc) {
+		if (aliases[j].desc && !quiet_flag) {
 			if (numdesc++ == 0 && printed)
 				printf("\n");
 			printf("  %-50s [", aliases[j].name);
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 87a1da471686..9b22d0f8be24 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -42,7 +42,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
-void print_pmu_events(const char *event_glob, bool name_only);
+void print_pmu_events(const char *event_glob, bool name_only, bool quiet);
 bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
-- 
1.8.3.1

