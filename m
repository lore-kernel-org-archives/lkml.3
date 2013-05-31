Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3EaLmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:42:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3EaLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:42:31 -0400
Date: Fri, 31 May 2013 04:42:11 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-fa5df94350510571cbe825f333996f57223b3cd2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, penberg@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1368497347-9628-8-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Add --percent-limit option
Git-Commit-ID: fa5df94350510571cbe825f333996f57223b3cd2
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

Commit-ID:  fa5df94350510571cbe825f333996f57223b3cd2
Gitweb:     http://git.kernel.org/tip/fa5df94350510571cbe825f333996f57223b3cd2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 14 May 2013 11:09:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:01 +0300

perf top: Add --percent-limit option

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
