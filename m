Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaEUNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:16:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaEUNNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:05 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 09/22] perf tools: Consolidate management of default sort orders
Date: Wed, 21 May 2014 15:12:31 +0200
Message-Id: <1400677964-25160-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The perf uses different default sort orders for different use-cases,
and this was scattered throughout the code.  Add get_default_sort_
order() function to handle this and change initial value of sort_order
to NULL to distinguish it from user-given one.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1400480762-22852-10-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-diff.c   |  4 ++--
 tools/perf/builtin-report.c | 18 ------------------
 tools/perf/builtin-top.c    |  3 +--
 tools/perf/util/sort.c      | 28 ++++++++++++++++++++++++++--
 tools/perf/util/sort.h      |  2 ++
 5 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b60c711..8bff543 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -60,7 +60,6 @@ static int data__files_cnt;
 #define data__for_each_file(i, d) data__for_each_file_start(i, d, 0)
 #define data__for_each_file_new(i, d) data__for_each_file_start(i, d, 1)
 
-static char diff__default_sort_order[] = "dso,symbol";
 static bool force;
 static bool show_period;
 static bool show_formula;
@@ -1142,7 +1141,6 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	perf_config(perf_default_config, NULL);
 
-	sort_order = diff__default_sort_order;
 	argc = parse_options(argc, argv, options, diff_usage, 0);
 
 	if (symbol__init() < 0)
@@ -1153,6 +1151,8 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	ui_init();
 
+	sort__mode = SORT_MODE__DIFF;
+
 	if (setup_sorting() < 0)
 		usage_with_options(diff_usage, options);
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d0180d5..f4d640cf 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -805,30 +805,12 @@ repeat:
 	if (branch_mode == -1 && has_br_stack)
 		sort__mode = SORT_MODE__BRANCH;
 
-	/* sort__mode could be NORMAL if --no-branch-stack */
-	if (sort__mode == SORT_MODE__BRANCH) {
-		/*
-		 * if no sort_order is provided, then specify
-		 * branch-mode specific order
-		 */
-		if (sort_order == default_sort_order)
-			sort_order = "comm,dso_from,symbol_from,"
-				     "dso_to,symbol_to";
-
-	}
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
 			pr_err("branch and mem mode incompatible\n");
 			goto error;
 		}
 		sort__mode = SORT_MODE__MEMORY;
-
-		/*
-		 * if no sort_order is provided, then specify
-		 * branch-mode specific order
-		 */
-		if (sort_order == default_sort_order)
-			sort_order = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
 	}
 
 	if (setup_sorting() < 0) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4fef1e4..34764b6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1137,8 +1137,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (argc)
 		usage_with_options(top_usage, options);
 
-	if (sort_order == default_sort_order)
-		sort_order = "dso,symbol";
+	sort__mode = SORT_MODE__TOP;
 
 	if (setup_sorting() < 0) {
 		parse_options_usage(top_usage, options, "s", 1);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 916652a..d64c1e5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,7 +8,11 @@ regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
 const char	*parent_pattern = default_parent_pattern;
 const char	default_sort_order[] = "comm,dso,symbol";
-const char	*sort_order = default_sort_order;
+const char	default_branch_sort_order[] = "comm,dso_from,symbol_from,dso_to,symbol_to";
+const char	default_mem_sort_order[] = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
+const char	default_top_sort_order[] = "dso,symbol";
+const char	default_diff_sort_order[] = "dso,symbol";
+const char	*sort_order;
 regex_t		ignore_callees_regex;
 int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
@@ -1218,11 +1222,31 @@ int sort_dimension__add(const char *tok)
 	return -ESRCH;
 }
 
+static const char *get_default_sort_order(void)
+{
+	const char *default_sort_orders[] = {
+		default_sort_order,
+		default_branch_sort_order,
+		default_mem_sort_order,
+		default_top_sort_order,
+		default_diff_sort_order,
+	};
+
+	BUG_ON(sort__mode >= ARRAY_SIZE(default_sort_orders));
+
+	return default_sort_orders[sort__mode];
+}
+
 int setup_sorting(void)
 {
-	char *tmp, *tok, *str = strdup(sort_order);
+	char *tmp, *tok, *str;
+	const char *sort_keys = sort_order;
 	int ret = 0;
 
+	if (sort_keys == NULL)
+		sort_keys = get_default_sort_order();
+
+	str = strdup(sort_keys);
 	if (str == NULL) {
 		error("Not enough memory to setup sort keys");
 		return -ENOMEM;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff4..1a72952 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -133,6 +133,8 @@ enum sort_mode {
 	SORT_MODE__NORMAL,
 	SORT_MODE__BRANCH,
 	SORT_MODE__MEMORY,
+	SORT_MODE__TOP,
+	SORT_MODE__DIFF,
 };
 
 enum sort_type {
-- 
1.8.3.1

