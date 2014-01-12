Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaALSgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:36:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALSfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:35:55 -0500
Date: Sun, 12 Jan 2014 10:35:14 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-28b21393fa0472501b5a2a85a0b008b4e3dc154c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <20131112113427.GA4053@ghostprotocols.net>
References: <20131112113427.GA4053@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Rename 'perf_report' to 'report'
Git-Commit-ID: 28b21393fa0472501b5a2a85a0b008b4e3dc154c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:35:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28b21393fa0472501b5a2a85a0b008b4e3dc154c
Gitweb:     http://git.kernel.org/tip/28b21393fa0472501b5a2a85a0b008b4e3dc154c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:53:53 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:19:01 -0300

perf report: Rename 'perf_report' to 'report'

Reduce typing, functions use class__method convention, so unlikely to
clash with other libraries.

This actually was discussed in the "Link:" referenced message below.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20131112113427.GA4053@ghostprotocols.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 73 +++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 42 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8424053..da156a4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -39,7 +39,7 @@
 #include <dlfcn.h>
 #include <linux/bitmap.h>
 
-struct perf_report {
+struct report {
 	struct perf_tool	tool;
 	struct perf_session	*session;
 	bool			force, use_tui, use_gtk, use_stdio;
@@ -60,14 +60,14 @@ struct perf_report {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static int perf_report_config(const char *var, const char *value, void *cb)
+static int report__config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "report.group")) {
 		symbol_conf.event_group = perf_config_bool(var, value);
 		return 0;
 	}
 	if (!strcmp(var, "report.percent-limit")) {
-		struct perf_report *rep = cb;
+		struct report *rep = cb;
 		rep->min_percent = strtof(value, NULL);
 		return 0;
 	}
@@ -75,7 +75,7 @@ static int perf_report_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static int report__resolve_callchain(struct perf_report *rep, struct symbol **parent,
+static int report__resolve_callchain(struct report *rep, struct symbol **parent,
 				     struct perf_evsel *evsel, struct addr_location *al,
 				     struct perf_sample *sample, struct machine *machine)
 {
@@ -93,14 +93,11 @@ static int hist_entry__append_callchain(struct hist_entry *he, struct perf_sampl
 	return callchain_append(he->callchain, &callchain_cursor, sample->period);
 }
 
-static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
-					   struct addr_location *al,
-					   struct perf_sample *sample,
-					   struct perf_evsel *evsel,
-					   struct machine *machine,
-					   union perf_event *event)
+static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
+				      struct perf_sample *sample, struct perf_evsel *evsel,
+				      struct machine *machine, union perf_event *event)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct hist_entry *he;
@@ -150,13 +147,11 @@ out:
 	return err;
 }
 
-static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
-					struct addr_location *al,
-					struct perf_sample *sample,
-					struct perf_evsel *evsel,
-				      struct machine *machine)
+static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_location *al,
+					 struct perf_sample *sample, struct perf_evsel *evsel,
+					 struct machine *machine)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	unsigned i;
 	struct hist_entry *he;
@@ -208,13 +203,11 @@ out:
 	return err;
 }
 
-static int perf_evsel__add_hist_entry(struct perf_tool *tool,
-				      struct perf_evsel *evsel,
-				      struct addr_location *al,
-				      struct perf_sample *sample,
-				      struct machine *machine)
+static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evsel,
+				  struct addr_location *al, struct perf_sample *sample,
+				  struct machine *machine)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	struct hist_entry *he;
 	int err = report__resolve_callchain(rep, &parent, evsel, al, sample, machine);
@@ -246,7 +239,7 @@ static int process_sample_event(struct perf_tool *tool,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct report *rep = container_of(tool, struct report, tool);
 	struct addr_location al;
 	int ret;
 
@@ -263,21 +256,18 @@ static int process_sample_event(struct perf_tool *tool,
 		return 0;
 
 	if (sort__mode == SORT_MODE__BRANCH) {
-		ret = perf_report__add_branch_hist_entry(tool, &al, sample,
-							 evsel, machine);
+		ret = report__add_branch_hist_entry(tool, &al, sample, evsel, machine);
 		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
 	} else if (rep->mem_mode == 1) {
-		ret = perf_report__add_mem_hist_entry(tool, &al, sample,
-						      evsel, machine, event);
+		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, machine, event);
 		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		ret = perf_evsel__add_hist_entry(tool, evsel, &al, sample,
-						 machine);
+		ret = report__add_hist_entry(tool, evsel, &al, sample, machine);
 		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
 	}
@@ -290,7 +280,7 @@ static int process_read_event(struct perf_tool *tool,
 			      struct perf_evsel *evsel,
 			      struct machine *machine __maybe_unused)
 {
-	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct report *rep = container_of(tool, struct report, tool);
 
 	if (rep->show_threads) {
 		const char *name = evsel ? perf_evsel__name(evsel) : "unknown";
@@ -309,7 +299,7 @@ static int process_read_event(struct perf_tool *tool,
 }
 
 /* For pipe mode, sample_type is not currently set */
-static int perf_report__setup_sample_type(struct perf_report *rep)
+static int report__setup_sample_type(struct report *rep)
 {
 	struct perf_session *session = rep->session;
 	u64 sample_type = perf_evlist__combined_sample_type(session->evlist);
@@ -354,8 +344,7 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
-static size_t hists__fprintf_nr_sample_events(struct perf_report *rep,
-					      struct hists *hists,
+static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report *rep,
 					      const char *evname, FILE *fp)
 {
 	size_t ret;
@@ -392,7 +381,7 @@ static size_t hists__fprintf_nr_sample_events(struct perf_report *rep,
 }
 
 static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
-					 struct perf_report *rep,
+					 struct report *rep,
 					 const char *help)
 {
 	struct perf_evsel *pos;
@@ -405,7 +394,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		    !perf_evsel__is_group_leader(pos))
 			continue;
 
-		hists__fprintf_nr_sample_events(rep, hists, evname, stdout);
+		hists__fprintf_nr_sample_events(hists, rep, evname, stdout);
 		hists__fprintf(hists, true, 0, 0, rep->min_percent, stdout);
 		fprintf(stdout, "\n\n");
 	}
@@ -425,7 +414,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 	return 0;
 }
 
-static int __cmd_report(struct perf_report *rep)
+static int __cmd_report(struct report *rep)
 {
 	int ret = -EINVAL;
 	u64 nr_samples;
@@ -449,7 +438,7 @@ static int __cmd_report(struct perf_report *rep)
 	if (rep->show_threads)
 		perf_read_values_init(&rep->show_threads_values);
 
-	ret = perf_report__setup_sample_type(rep);
+	ret = report__setup_sample_type(rep);
 	if (ret)
 		return ret;
 
@@ -568,7 +557,7 @@ static int __cmd_report(struct perf_report *rep)
 static int
 parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	struct perf_report *rep = (struct perf_report *)opt->value;
+	struct report *rep = (struct report *)opt->value;
 	char *tok, *tok2;
 	char *endptr;
 
@@ -688,7 +677,7 @@ static int
 parse_percent_limit(const struct option *opt, const char *str,
 		    int unset __maybe_unused)
 {
-	struct perf_report *rep = opt->value;
+	struct report *rep = opt->value;
 
 	rep->min_percent = strtof(str, NULL);
 	return 0;
@@ -706,7 +695,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf report [<options>]",
 		NULL
 	};
-	struct perf_report report = {
+	struct report report = {
 		.tool = {
 			.sample		 = process_sample_event,
 			.mmap		 = perf_event__process_mmap,
@@ -822,7 +811,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		.mode  = PERF_DATA_MODE_READ,
 	};
 
-	perf_config(perf_report_config, &report);
+	perf_config(report__config, &report);
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
