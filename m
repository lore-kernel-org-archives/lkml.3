Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3EaLSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:18:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56446 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3EaLSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:18:10 -0400
Date: Fri, 31 May 2013 04:17:47 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-55369fc179b0572d0b4a06a9be1d2779b3ac22e0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1364816125-12212-5-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Introduce sort__mode variable
Git-Commit-ID: 55369fc179b0572d0b4a06a9be1d2779b3ac22e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55369fc179b0572d0b4a06a9be1d2779b3ac22e0
Gitweb:     http://git.kernel.org/tip/55369fc179b0572d0b4a06a9be1d2779b3ac22e0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 1 Apr 2013 20:35:20 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:53 +0300

perf sort: Introduce sort__mode variable

It's used for determining current sort mode which can be one of
NORMAL, BRANCH and new MEMORY.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1364816125-12212-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c    | 23 +++++++++++++----------
 tools/perf/ui/browsers/hists.c |  4 ++--
 tools/perf/util/sort.c         |  4 ++--
 tools/perf/util/sort.h         |  8 +++++++-
 4 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d9f2de3..c877982 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -311,7 +311,7 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
-	if (sort__branch_mode == 1) {
+	if (sort__mode == SORT_MODE__BRANCH) {
 		if (perf_report__add_branch_hist_entry(tool, &al, sample,
 						       evsel, machine)) {
 			pr_debug("problem adding lbr entry, skipping event\n");
@@ -387,7 +387,7 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 			}
 	}
 
-	if (sort__branch_mode == 1) {
+	if (sort__mode == SORT_MODE__BRANCH) {
 		if (!self->fd_pipe &&
 		    !(sample_type & PERF_SAMPLE_BRANCH_STACK)) {
 			ui__error("Selected -b but no branch data. "
@@ -694,7 +694,9 @@ static int
 parse_branch_mode(const struct option *opt __maybe_unused,
 		  const char *str __maybe_unused, int unset)
 {
-	sort__branch_mode = !unset;
+	int *branch_mode = opt->value;
+
+	*branch_mode = !unset;
 	return 0;
 }
 
@@ -703,6 +705,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_session *session;
 	struct stat st;
 	bool has_br_stack = false;
+	int branch_mode = -1;
 	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
@@ -799,7 +802,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show a column with the sum of periods"),
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
-	OPT_CALLBACK_NOOPT('b', "branch-stack", &sort__branch_mode, "",
+	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
@@ -849,11 +852,11 @@ repeat:
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (sort__branch_mode == -1 && has_br_stack)
-		sort__branch_mode = 1;
+	if (branch_mode == -1 && has_br_stack)
+		sort__mode = SORT_MODE__BRANCH;
 
-	/* sort__branch_mode could be 0 if --no-branch-stack */
-	if (sort__branch_mode == 1) {
+	/* sort__mode could be NORMAL if --no-branch-stack */
+	if (sort__mode == SORT_MODE__BRANCH) {
 		/*
 		 * if no sort_order is provided, then specify
 		 * branch-mode specific order
@@ -864,7 +867,7 @@ repeat:
 
 	}
 	if (report.mem_mode) {
-		if (sort__branch_mode == 1) {
+		if (sort__mode == SORT_MODE__BRANCH) {
 			fprintf(stderr, "branch and mem mode incompatible\n");
 			goto error;
 		}
@@ -934,7 +937,7 @@ repeat:
 
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 
-	if (sort__branch_mode == 1) {
+	if (sort__mode == SORT_MODE__BRANCH) {
 		sort_entry__setup_elide(&sort_dso_from, symbol_conf.dso_from_list, "dso_from", stdout);
 		sort_entry__setup_elide(&sort_dso_to, symbol_conf.dso_to_list, "dso_to", stdout);
 		sort_entry__setup_elide(&sort_sym_from, symbol_conf.sym_from_list, "sym_from", stdout);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d88a2d0..cad8e37 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1155,7 +1155,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		browser->b.refresh = hist_browser__refresh;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
-		if (sort__branch_mode == 1)
+		if (sort__mode == SORT_MODE__BRANCH)
 			browser->has_symbols = sort_sym_from.list.next != NULL;
 		else
 			browser->has_symbols = sort_sym.list.next != NULL;
@@ -1488,7 +1488,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (!browser->has_symbols)
 			goto add_exit_option;
 
-		if (sort__branch_mode == 1) {
+		if (sort__mode == SORT_MODE__BRANCH) {
 			bi = browser->he_selection->branch_info;
 			if (browser->selection != NULL &&
 			    bi &&
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 16d5e38..a6ddad4 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -9,7 +9,7 @@ const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
-int		sort__branch_mode = -1; /* -1 = means not set */
+enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
 enum sort_type	sort__first_dimension;
 
@@ -943,7 +943,7 @@ int sort_dimension__add(const char *tok)
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sort__branch_mode != 1)
+		if (sort__mode != SORT_MODE__BRANCH)
 			return -EINVAL;
 
 		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f24bdf6..39ff4b8 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -32,7 +32,7 @@ extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__has_sym;
-extern int sort__branch_mode;
+extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
@@ -123,6 +123,12 @@ static inline void hist_entry__add_pair(struct hist_entry *he,
 	list_add_tail(&he->pairs.head, &pair->pairs.node);
 }
 
+enum sort_mode {
+	SORT_MODE__NORMAL,
+	SORT_MODE__BRANCH,
+	SORT_MODE__MEMORY,
+};
+
 enum sort_type {
 	/* common sort keys */
 	SORT_PID,
