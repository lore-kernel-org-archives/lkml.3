Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3EMIlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:41:55 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61465 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3EMIls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:41:48 -0400
X-AuditID: 9c93016f-b7b9bae000002df2-5c-5190a749c8c6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/2] perf top: Add --percent-limit option
Date: Mon, 13 May 2013 17:41:43 +0900
Message-Id: <1368434503-29373-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
References: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The --percent-limit option is for not showing small overheaded entries
in the output.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt |  4 ++++
 tools/perf/builtin-top.c              | 17 +++++++++++++++--
 tools/perf/ui/browsers/hists.c        | 16 ++++++++++++++--
 tools/perf/util/top.h                 |  1 +
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 9f1a2fe54757..7fdd1909e376 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -155,6 +155,10 @@ Default is to monitor all CPUS.
 
 	Default: fractal,0.5,callee.
 
+--percent-limit::
+	Do not show entries which have an overhead under that percent.
+	(Default: 0).
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 19fe25f6e4f0..f036af9b6f09 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -296,7 +296,8 @@ static void perf_top__print_sym_table(struct perf_top *top)
 				     top->print_entries - printed);
 	putchar('\n');
 	hists__fprintf(&top->sym_evsel->hists, false,
-		       top->print_entries - printed, win_width, 0, stdout);
+		       top->print_entries - printed, win_width,
+		       top->min_percent, stdout);
 }
 
 static void prompt_integer(int *target, const char *msg)
@@ -580,7 +581,7 @@ static void *display_thread_tui(void *arg)
 	list_for_each_entry(pos, &top->evlist->entries, node)
 		pos->hists.uid_filter_str = top->record_opts.target.uid_str;
 
-	perf_evlist__tui_browse_hists(top->evlist, help, &hbt, 0,
+	perf_evlist__tui_browse_hists(top->evlist, help, &hbt, top->min_percent,
 				      &top->session->header.env);
 
 	done = 1;
@@ -1021,6 +1022,16 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
+static int
+parse_percent_limit(const struct option *opt, const char *arg,
+		    int unset __maybe_unused)
+{
+	struct perf_top *top = opt->value;
+
+	top->min_percent = strtof(arg, NULL);
+	return 0;
+}
+
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int status;
@@ -1106,6 +1117,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
+	OPT_CALLBACK(0, "percent-limit", &top, "percent",
+		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 9dfde61505cc..fc0bd3843d34 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -310,6 +310,8 @@ static void ui_browser__warn_lost_events(struct ui_browser *browser)
 		"Or reduce the sampling frequency.");
 }
 
+static void hist_browser__update_pcnt_entries(struct hist_browser *hb);
+
 static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			     struct hist_browser_timer *hbt)
 {
@@ -333,9 +335,18 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 		key = ui_browser__run(&browser->b, delay_secs);
 
 		switch (key) {
-		case K_TIMER:
+		case K_TIMER: {
+			u64 nr_entries;
 			hbt->timer(hbt->arg);
-			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
+
+			if (browser->min_pcnt) {
+				hist_browser__update_pcnt_entries(browser);
+				nr_entries = browser->nr_pcnt_entries;
+			} else {
+				nr_entries = browser->hists->nr_entries;
+			}
+
+			ui_browser__update_nr_entries(&browser->b, nr_entries);
 
 			if (browser->hists->stats.nr_lost_warned !=
 			    browser->hists->stats.nr_events[PERF_RECORD_LOST]) {
@@ -347,6 +358,7 @@ static int hist_browser__run(struct hist_browser *browser, const char *ev_name,
 			hists__browser_title(browser->hists, title, sizeof(title), ev_name);
 			ui_browser__show_title(&browser->b, title);
 			continue;
+		}
 		case 'D': { /* Debug */
 			static int seq;
 			struct hist_entry *h = rb_entry(browser->b.top,
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index f0a862539ba9..df46be93d902 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -36,6 +36,7 @@ struct perf_top {
 	int		   realtime_prio;
 	int		   sym_pcnt_filter;
 	const char	   *sym_filter;
+	float		   min_percent;
 };
 
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
-- 
1.7.11.7

