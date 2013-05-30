Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686Ab3E3QOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:14:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50935 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934531Ab3E3QCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/66] perf top: Add --percent-limit option
Date: Thu, 30 May 2013 19:00:57 +0300
Message-Id: <1369929699-8724-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The --percent-limit option is for not showing small overhead entries in
the output.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368497347-9628-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt |  4 ++++
 tools/perf/builtin-top.c              | 17 +++++++++++++++--
 tools/perf/ui/browsers/hists.c        | 16 ++++++++++++++--
 tools/perf/util/top.h                 |  1 +
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 9f1a2fe..7fdd190 100644
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
index 19fe25f..f036af9 100644
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
index 9dfde61..fc0bd38 100644
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
index f0a8625..df46be9 100644
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
1.8.1.4

