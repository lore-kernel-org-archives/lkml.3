Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaDPDGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:06:30 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60053 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaDPDF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/17] perf tools: Consolidate management of default sort orders
Date: Wed, 16 Apr 2014 12:05:46 +0900
Message-Id: <1397617554-26319-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf uses different default sort orders for different use-cases,
and this was scattered throughout the code.  Add get_default_sort_
order() function to handle this and change initial value of sort_order
to NULL to distinguish it from user-given one.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 18 ------------------
 tools/perf/builtin-top.c    |  3 +--
 tools/perf/util/sort.c      | 25 +++++++++++++++++++++++--
 tools/perf/util/sort.h      |  1 +
 4 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 76e2bb6cf571..26de5c14369b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -809,30 +809,12 @@ repeat:
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
index 37d30460bada..bb2aa6645a7e 100644
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
index 916652af8304..2f83965ab2c0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,7 +8,10 @@ regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
 const char	*parent_pattern = default_parent_pattern;
 const char	default_sort_order[] = "comm,dso,symbol";
-const char	*sort_order = default_sort_order;
+const char	default_branch_sort_order[] = "comm,dso_from,symbol_from,dso_to,symbol_to";
+const char	default_mem_sort_order[] = "local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
+const char	default_top_sort_order[] = "dso,symbol";
+const char	*sort_order;
 regex_t		ignore_callees_regex;
 int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
@@ -1218,11 +1221,29 @@ int sort_dimension__add(const char *tok)
 	return -ESRCH;
 }
 
+static const char *get_default_sort_order(void)
+{
+	const char *default_sort_orders[] = {
+		default_sort_order,
+		default_branch_sort_order,
+		default_mem_sort_order,
+		default_top_sort_order,
+	};
+
+	BUG_ON(sort__mode > ARRAY_SIZE(default_sort_orders));
+
+	return default_sort_orders[sort__mode];
+}
+
 int setup_sorting(void)
 {
-	char *tmp, *tok, *str = strdup(sort_order);
+	char *tmp, *tok, *str;
 	int ret = 0;
 
+	if (sort_order == NULL)
+		sort_order = get_default_sort_order();
+
+	str = strdup(sort_order);
 	if (str == NULL) {
 		error("Not enough memory to setup sort keys");
 		return -ENOMEM;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff42a609..35b53cc56feb 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -133,6 +133,7 @@ enum sort_mode {
 	SORT_MODE__NORMAL,
 	SORT_MODE__BRANCH,
 	SORT_MODE__MEMORY,
+	SORT_MODE__TOP,
 };
 
 enum sort_type {
-- 
1.9.2

