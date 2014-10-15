Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaJOKDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:03:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54265 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaJOKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:03:35 -0400
Date: Wed, 15 Oct 2014 03:02:41 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-qlktkhe31w4mgtbd84035sr2@git.kernel.org>
Cc: jolsa@redhat.com, tglx@linutronix.de, efault@gmx.de, dzickus@redhat.com,
        adrian.hunter@intel.com, peterz@infradead.org, paulus@samba.org,
        mingo@kernel.org, namhyung@kernel.org, bp@suse.de, dsahern@gmail.com,
        jean.pihet@linaro.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        eranian@google.com, fweisbec@gmail.com, acme@redhat.com
Reply-To: jolsa@redhat.com, tglx@linutronix.de, efault@gmx.de,
        dzickus@redhat.com, adrian.hunter@intel.com, peterz@infradead.org,
        paulus@samba.org, mingo@kernel.org, namhyung@kernel.org, bp@suse.de,
        dsahern@gmail.com, jean.pihet@linaro.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, eranian@google.com, acme@redhat.com, fweisbec@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Add hists helper
Git-Commit-ID: 4ea062ed431d00153af0ac370cb6fef0620e5fa1
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

Commit-ID:  4ea062ed431d00153af0ac370cb6fef0620e5fa1
Gitweb:     http://git.kernel.org/tip/4ea062ed431d00153af0ac370cb6fef0620e5fa1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 9 Oct 2014 13:13:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Oct 2014 13:13:41 -0300

perf evsel: Add hists helper

Not all tools need a hists instance per perf_evsel, so lets pave the way
to remove evsel->hists while leaving a way to access the hists from a
specially allocated evsel, one that comes with space at the end where
lives the evsel.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qlktkhe31w4mgtbd84035sr2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |  8 +++---
 tools/perf/builtin-diff.c         | 21 ++++++++-------
 tools/perf/builtin-report.c       | 18 +++++++------
 tools/perf/builtin-top.c          | 55 +++++++++++++++++++++------------------
 tools/perf/tests/hists_cumulate.c |  8 +++---
 tools/perf/tests/hists_filter.c   | 23 ++++++++--------
 tools/perf/tests/hists_link.c     | 23 ++++++++++------
 tools/perf/tests/hists_output.c   | 20 +++++++-------
 tools/perf/ui/browsers/hists.c    | 20 ++++++++------
 tools/perf/ui/gtk/hists.c         |  2 +-
 tools/perf/util/evsel.h           |  5 ++++
 tools/perf/util/hist.c            | 22 +++++++++-------
 tools/perf/util/session.c         |  4 +--
 tools/perf/util/sort.c            |  4 +--
 14 files changed, 132 insertions(+), 101 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index be59394..c9a119e2 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -51,6 +51,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 				  struct addr_location *al,
 				  struct perf_annotate *ann)
 {
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	int ret;
 
@@ -66,13 +67,12 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0,
-				true);
+	he = __hists__add_entry(hists, al, NULL, NULL, NULL, 1, 1, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
 	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	hists__inc_nr_samples(&evsel->hists, true);
+	hists__inc_nr_samples(hists, true);
 	return ret;
 }
 
@@ -225,7 +225,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 	total_nr_samples = 0;
 	evlist__for_each(session->evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 		u32 nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 		if (nr_samples > 0) {
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a3ce19f..8c5c11c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -327,6 +327,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 				      struct machine *machine)
 {
 	struct addr_location al;
+	struct hists *hists = evsel__hists(evsel);
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
@@ -334,7 +335,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period,
+	if (hists__add_entry(hists, &al, sample->period,
 			     sample->weight, sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
@@ -346,9 +347,9 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	 * hists__output_resort() and precompute needs the total
 	 * period in order to sort entries by percentage delta.
 	 */
-	evsel->hists.stats.total_period += sample->period;
+	hists->stats.total_period += sample->period;
 	if (!al.filtered)
-		evsel->hists.stats.total_non_filtered_period += sample->period;
+		hists->stats.total_non_filtered_period += sample->period;
 
 	return 0;
 }
@@ -382,7 +383,7 @@ static void perf_evlist__collapse_resort(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 
 	evlist__for_each(evlist, evsel) {
-		struct hists *hists = &evsel->hists;
+		struct hists *hists = evsel__hists(evsel);
 
 		hists__collapse_resort(hists, NULL);
 	}
@@ -631,24 +632,26 @@ static void data_process(void)
 	bool first = true;
 
 	evlist__for_each(evlist_base, evsel_base) {
+		struct hists *hists_base = evsel__hists(evsel_base);
 		struct data__file *d;
 		int i;
 
 		data__for_each_file_new(i, d) {
 			struct perf_evlist *evlist = d->session->evlist;
 			struct perf_evsel *evsel;
+			struct hists *hists;
 
 			evsel = evsel_match(evsel_base, evlist);
 			if (!evsel)
 				continue;
 
-			d->hists = &evsel->hists;
+			hists = evsel__hists(evsel);
+			d->hists = hists;
 
-			hists__match(&evsel_base->hists, &evsel->hists);
+			hists__match(hists_base, hists);
 
 			if (!show_baseline_only)
-				hists__link(&evsel_base->hists,
-					    &evsel->hists);
+				hists__link(hists_base, hists);
 		}
 
 		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
@@ -659,7 +662,7 @@ static void data_process(void)
 		if (verbose || data__files_cnt > 2)
 			data__fprintf();
 
-		hists__process(&evsel_base->hists);
+		hists__process(hists_base);
 	}
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ac145fa..3750d63 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -288,12 +288,14 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 		evname = buf;
 
 		for_each_group_member(pos, evsel) {
+			const struct hists *pos_hists = evsel__hists(pos);
+
 			if (symbol_conf.filter_relative) {
-				nr_samples += pos->hists.stats.nr_non_filtered_samples;
-				nr_events += pos->hists.stats.total_non_filtered_period;
+				nr_samples += pos_hists->stats.nr_non_filtered_samples;
+				nr_events += pos_hists->stats.total_non_filtered_period;
 			} else {
-				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-				nr_events += pos->hists.stats.total_period;
+				nr_samples += pos_hists->stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos_hists->stats.total_period;
 			}
 		}
 	}
@@ -318,7 +320,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 	struct perf_evsel *pos;
 
 	evlist__for_each(evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 		const char *evname = perf_evsel__name(pos);
 
 		if (symbol_conf.event_group &&
@@ -427,7 +429,7 @@ static void report__collapse_hists(struct report *rep)
 	ui_progress__init(&prog, rep->nr_entries, "Merging related events...");
 
 	evlist__for_each(rep->session->evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 
 		if (pos->idx == 0)
 			hists->symbol_filter_str = rep->symbol_filter_str;
@@ -437,7 +439,7 @@ static void report__collapse_hists(struct report *rep)
 		/* Non-group events are considered as leader */
 		if (symbol_conf.event_group &&
 		    !perf_evsel__is_group_leader(pos)) {
-			struct hists *leader_hists = &pos->leader->hists;
+			struct hists *leader_hists = evsel__hists(pos->leader);
 
 			hists__match(leader_hists, hists);
 			hists__link(leader_hists, hists);
@@ -500,7 +502,7 @@ static int __cmd_report(struct report *rep)
 	}
 
 	evlist__for_each(session->evlist, pos)
-		hists__output_resort(&pos->hists);
+		hists__output_resort(evsel__hists(pos));
 
 	return report__browse_hists(rep);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fc3d55f..8ab9716 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -251,6 +251,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	char bf[160];
 	int printed = 0;
 	const int win_width = top->winsize.ws_col - 1;
+	struct hists *hists = evsel__hists(top->sym_evsel);
 
 	puts(CONSOLE_CLEAR);
 
@@ -261,13 +262,13 @@ static void perf_top__print_sym_table(struct perf_top *top)
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
-	if (top->sym_evsel->hists.stats.nr_lost_warned !=
-	    top->sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST]) {
-		top->sym_evsel->hists.stats.nr_lost_warned =
-			top->sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST];
+	if (hists->stats.nr_lost_warned !=
+	    hists->stats.nr_events[PERF_RECORD_LOST]) {
+		hists->stats.nr_lost_warned =
+			      hists->stats.nr_events[PERF_RECORD_LOST];
 		color_fprintf(stdout, PERF_COLOR_RED,
 			      "WARNING: LOST %d chunks, Check IO/CPU overload",
-			      top->sym_evsel->hists.stats.nr_lost_warned);
+			      hists->stats.nr_lost_warned);
 		++printed;
 	}
 
@@ -277,21 +278,18 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	}
 
 	if (top->zero) {
-		hists__delete_entries(&top->sym_evsel->hists);
+		hists__delete_entries(hists);
 	} else {
-		hists__decay_entries(&top->sym_evsel->hists,
-				     top->hide_user_symbols,
+		hists__decay_entries(hists, top->hide_user_symbols,
 				     top->hide_kernel_symbols);
 	}
 
-	hists__collapse_resort(&top->sym_evsel->hists, NULL);
-	hists__output_resort(&top->sym_evsel->hists);
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
 
-	hists__output_recalc_col_len(&top->sym_evsel->hists,
-				     top->print_entries - printed);
+	hists__output_recalc_col_len(hists, top->print_entries - printed);
 	putchar('\n');
-	hists__fprintf(&top->sym_evsel->hists, false,
-		       top->print_entries - printed, win_width,
+	hists__fprintf(hists, false, top->print_entries - printed, win_width,
 		       top->min_percent, stdout);
 }
 
@@ -334,6 +332,7 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 {
 	char *buf = malloc(0), *p;
 	struct hist_entry *syme = top->sym_filter_entry, *n, *found = NULL;
+	struct hists *hists = evsel__hists(top->sym_evsel);
 	struct rb_node *next;
 	size_t dummy = 0;
 
@@ -351,7 +350,7 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 	if (p)
 		*p = 0;
 
-	next = rb_first(&top->sym_evsel->hists.entries);
+	next = rb_first(&hists->entries);
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		if (n->ms.sym && !strcmp(buf, n->ms.sym->name)) {
@@ -538,21 +537,24 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 static void perf_top__sort_new_samples(void *arg)
 {
 	struct perf_top *t = arg;
+	struct hists *hists;
+
 	perf_top__reset_sample_counters(t);
 
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
+	hists = evsel__hists(t->sym_evsel);
+
 	if (t->zero) {
-		hists__delete_entries(&t->sym_evsel->hists);
+		hists__delete_entries(hists);
 	} else {
-		hists__decay_entries(&t->sym_evsel->hists,
-				     t->hide_user_symbols,
+		hists__decay_entries(hists, t->hide_user_symbols,
 				     t->hide_kernel_symbols);
 	}
 
-	hists__collapse_resort(&t->sym_evsel->hists, NULL);
-	hists__output_resort(&t->sym_evsel->hists);
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
 }
 
 static void *display_thread_tui(void *arg)
@@ -573,8 +575,10 @@ static void *display_thread_tui(void *arg)
 	 * Zooming in/out UIDs. For now juse use whatever the user passed
 	 * via --uid.
 	 */
-	evlist__for_each(top->evlist, pos)
-		pos->hists.uid_filter_str = top->record_opts.target.uid_str;
+	evlist__for_each(top->evlist, pos) {
+		struct hists *hists = evsel__hists(pos);
+		hists->uid_filter_str = top->record_opts.target.uid_str;
+	}
 
 	perf_evlist__tui_browse_hists(top->evlist, help, &hbt, top->min_percent,
 				      &top->session->header.env);
@@ -768,6 +772,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	}
 
 	if (al.sym == NULL || !al.sym->ignore) {
+		struct hists *hists = evsel__hists(evsel);
 		struct hist_entry_iter iter = {
 			.add_entry_cb = hist_iter__top_callback,
 		};
@@ -777,14 +782,14 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		else
 			iter.ops = &hist_iter_normal;
 
-		pthread_mutex_lock(&evsel->hists.lock);
+		pthread_mutex_lock(&hists->lock);
 
 		err = hist_entry_iter__add(&iter, &al, evsel, sample,
 					   top->max_stack, top);
 		if (err < 0)
 			pr_err("Problem incrementing symbol period, skipping event\n");
 
-		pthread_mutex_unlock(&evsel->hists.lock);
+		pthread_mutex_unlock(&hists->lock);
 	}
 
 	return;
@@ -849,7 +854,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			perf_event__process_sample(&top->tool, event, evsel,
 						   &sample, machine);
 		} else if (event->header.type < PERF_RECORD_MAX) {
-			hists__inc_nr_events(&evsel->hists, event->header.type);
+			hists__inc_nr_events(evsel__hists(evsel), event->header.type);
 			machine__process_event(machine, event, &sample);
 		} else
 			++session->stats.nr_unknown_events;
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 0ac240d..614d5c4 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -245,7 +245,7 @@ static int do_test(struct hists *hists, struct result *expected, size_t nr_expec
 static int test1(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
@@ -295,7 +295,7 @@ out:
 static int test2(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
@@ -442,7 +442,7 @@ out:
 static int test3(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
@@ -498,7 +498,7 @@ out:
 static int test4(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	/*
 	 * expected output:
 	 *
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 821f581..5a31787 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -66,11 +66,12 @@ static int add_hist_entries(struct perf_evlist *evlist,
 				.ops = &hist_iter_normal,
 				.hide_unresolved = false,
 			};
+			struct hists *hists = evsel__hists(evsel);
 
 			/* make sure it has no filter at first */
-			evsel->hists.thread_filter = NULL;
-			evsel->hists.dso_filter = NULL;
-			evsel->hists.symbol_filter_str = NULL;
+			hists->thread_filter = NULL;
+			hists->dso_filter = NULL;
+			hists->symbol_filter_str = NULL;
 
 			sample.pid = fake_samples[i].pid;
 			sample.tid = fake_samples[i].pid;
@@ -134,7 +135,7 @@ int test__hists_filter(void)
 		goto out;
 
 	evlist__for_each(evlist, evsel) {
-		struct hists *hists = &evsel->hists;
+		struct hists *hists = evsel__hists(evsel);
 
 		hists__collapse_resort(hists, NULL);
 		hists__output_resort(hists);
@@ -160,7 +161,7 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period);
 
 		/* now applying thread filter for 'bash' */
-		evsel->hists.thread_filter = fake_samples[9].thread;
+		hists->thread_filter = fake_samples[9].thread;
 		hists__filter_by_thread(hists);
 
 		if (verbose > 2) {
@@ -185,11 +186,11 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period == 400);
 
 		/* remove thread filter first */
-		evsel->hists.thread_filter = NULL;
+		hists->thread_filter = NULL;
 		hists__filter_by_thread(hists);
 
 		/* now applying dso filter for 'kernel' */
-		evsel->hists.dso_filter = fake_samples[0].map->dso;
+		hists->dso_filter = fake_samples[0].map->dso;
 		hists__filter_by_dso(hists);
 
 		if (verbose > 2) {
@@ -214,7 +215,7 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period == 300);
 
 		/* remove dso filter first */
-		evsel->hists.dso_filter = NULL;
+		hists->dso_filter = NULL;
 		hists__filter_by_dso(hists);
 
 		/*
@@ -224,7 +225,7 @@ int test__hists_filter(void)
 		 * be counted as a separate entry but the sample count and
 		 * total period will be remained.
 		 */
-		evsel->hists.symbol_filter_str = "main";
+		hists->symbol_filter_str = "main";
 		hists__filter_by_symbol(hists);
 
 		if (verbose > 2) {
@@ -249,8 +250,8 @@ int test__hists_filter(void)
 				hists->stats.total_non_filtered_period == 300);
 
 		/* now applying all filters at once. */
-		evsel->hists.thread_filter = fake_samples[1].thread;
-		evsel->hists.dso_filter = fake_samples[1].map->dso;
+		hists->thread_filter = fake_samples[1].thread;
+		hists->dso_filter = fake_samples[1].map->dso;
 		hists__filter_by_thread(hists);
 		hists__filter_by_dso(hists);
 
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index d4b34b0..278ba834 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -73,6 +73,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 	 * "bash [libc] malloc" so total 9 entries will be in the tree.
 	 */
 	evlist__for_each(evlist, evsel) {
+		struct hists *hists = evsel__hists(evsel);
+
 		for (k = 0; k < ARRAY_SIZE(fake_common_samples); k++) {
 			const union perf_event event = {
 				.header = {
@@ -87,7 +89,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL,
+			he = __hists__add_entry(hists, &al, NULL,
 						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
@@ -111,7 +113,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL,
+			he = __hists__add_entry(hists, &al, NULL,
 						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
@@ -271,6 +273,7 @@ static int validate_link(struct hists *leader, struct hists *other)
 int test__hists_link(void)
 {
 	int err = -1;
+	struct hists *hists, *first_hists;
 	struct machines machines;
 	struct machine *machine = NULL;
 	struct perf_evsel *evsel, *first;
@@ -306,24 +309,28 @@ int test__hists_link(void)
 		goto out;
 
 	evlist__for_each(evlist, evsel) {
-		hists__collapse_resort(&evsel->hists, NULL);
+		hists = evsel__hists(evsel);
+		hists__collapse_resort(hists, NULL);
 
 		if (verbose > 2)
-			print_hists_in(&evsel->hists);
+			print_hists_in(hists);
 	}
 
 	first = perf_evlist__first(evlist);
 	evsel = perf_evlist__last(evlist);
 
+	first_hists = evsel__hists(first);
+	hists = evsel__hists(evsel);
+
 	/* match common entries */
-	hists__match(&first->hists, &evsel->hists);
-	err = validate_match(&first->hists, &evsel->hists);
+	hists__match(first_hists, hists);
+	err = validate_match(first_hists, hists);
 	if (err)
 		goto out;
 
 	/* link common and/or dummy entries */
-	hists__link(&first->hists, &evsel->hists);
-	err = validate_link(&first->hists, &evsel->hists);
+	hists__link(first_hists, hists);
+	err = validate_link(first_hists, hists);
 	if (err)
 		goto out;
 
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index e3bbd6c..a748f2b 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -122,7 +122,7 @@ typedef int (*test_fn_t)(struct perf_evsel *, struct machine *);
 static int test1(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -159,7 +159,7 @@ static int test1(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -224,7 +224,7 @@ out:
 static int test2(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -259,7 +259,7 @@ static int test2(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -280,7 +280,7 @@ out:
 static int test3(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -313,7 +313,7 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -354,7 +354,7 @@ out:
 static int test4(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -391,7 +391,7 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 	TEST_ASSERT_VAL("Invalid hist entry",
@@ -456,7 +456,7 @@ out:
 static int test5(struct perf_evsel *evsel, struct machine *machine)
 {
 	int err;
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he;
 	struct rb_root *root;
 	struct rb_node *node;
@@ -494,7 +494,7 @@ static int test5(struct perf_evsel *evsel, struct machine *machine)
 		print_hists_out(hists);
 	}
 
-	root = &evsel->hists.entries;
+	root = &hists->entries;
 	node = rb_first(root);
 	he = rb_entry(node, struct hist_entry, rb_node);
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 8f60a97..68eab9e 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1229,12 +1229,14 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 		ev_name = buf;
 
 		for_each_group_member(pos, evsel) {
+			struct hists *pos_hists = evsel__hists(pos);
+
 			if (symbol_conf.filter_relative) {
-				nr_samples += pos->hists.stats.nr_non_filtered_samples;
-				nr_events += pos->hists.stats.total_non_filtered_period;
+				nr_samples += pos_hists->stats.nr_non_filtered_samples;
+				nr_events += pos_hists->stats.total_non_filtered_period;
 			} else {
-				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-				nr_events += pos->hists.stats.total_period;
+				nr_samples += pos_hists->stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos_hists->stats.total_period;
 			}
 		}
 	}
@@ -1387,7 +1389,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    float min_pcnt,
 				    struct perf_session_env *env)
 {
-	struct hists *hists = &evsel->hists;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_browser *browser = hist_browser__new(hists);
 	struct branch_info *bi;
 	struct pstack *fstack;
@@ -1802,8 +1804,9 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	struct perf_evsel_menu *menu = container_of(browser,
 						    struct perf_evsel_menu, b);
 	struct perf_evsel *evsel = list_entry(entry, struct perf_evsel, node);
+	struct hists *hists = evsel__hists(evsel);
 	bool current_entry = ui_browser__is_current_entry(browser, row);
-	unsigned long nr_events = evsel->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+	unsigned long nr_events = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	const char *ev_name = perf_evsel__name(evsel);
 	char bf[256], unit;
 	const char *warn = " ";
@@ -1818,7 +1821,8 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 		ev_name = perf_evsel__group_name(evsel);
 
 		for_each_group_member(pos, evsel) {
-			nr_events += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+			struct hists *pos_hists = evsel__hists(pos);
+			nr_events += pos_hists->stats.nr_events[PERF_RECORD_SAMPLE];
 		}
 	}
 
@@ -1827,7 +1831,7 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 			   unit, unit == ' ' ? "" : " ", ev_name);
 	slsmg_printf("%s", bf);
 
-	nr_events = evsel->hists.stats.nr_events[PERF_RECORD_LOST];
+	nr_events = hists->stats.nr_events[PERF_RECORD_LOST];
 	if (nr_events != 0) {
 		menu->lost_events = true;
 		if (!current_entry)
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index f3fa425..fc654fb 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -319,7 +319,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 	gtk_container_add(GTK_CONTAINER(window), vbox);
 
 	evlist__for_each(evlist, pos) {
-		struct hists *hists = &pos->hists;
+		struct hists *hists = evsel__hists(pos);
 		const char *evname = perf_evsel__name(pos);
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7bc314b..ff72ce0 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -102,6 +102,11 @@ union u64_swap {
 
 #define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
 
+static inline struct hists *evsel__hists(struct perf_evsel *evsel)
+{
+	return &evsel->hists;
+}
+
 struct cpu_map;
 struct thread_map;
 struct perf_evlist;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b475956..f72ad9c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -509,6 +509,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 {
 	u64 cost;
 	struct mem_info *mi = iter->priv;
+	struct hists *hists = evsel__hists(iter->evsel);
 	struct hist_entry *he;
 
 	if (mi == NULL)
@@ -525,7 +526,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 	 * and this is indirectly achieved by passing period=weight here
 	 * and the he_stat__add_period() function.
 	 */
-	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
+	he = __hists__add_entry(hists, al, iter->parent, NULL, mi,
 				cost, cost, 0, true);
 	if (!he)
 		return -ENOMEM;
@@ -539,13 +540,14 @@ iter_finish_mem_entry(struct hist_entry_iter *iter,
 		      struct addr_location *al __maybe_unused)
 {
 	struct perf_evsel *evsel = iter->evsel;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he = iter->he;
 	int err = -EINVAL;
 
 	if (he == NULL)
 		goto out;
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(hists, he->filtered);
 
 	err = hist_entry__append_callchain(he, iter->sample);
 
@@ -611,6 +613,7 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 {
 	struct branch_info *bi;
 	struct perf_evsel *evsel = iter->evsel;
+	struct hists *hists = evsel__hists(evsel);
 	struct hist_entry *he = NULL;
 	int i = iter->curr;
 	int err = 0;
@@ -624,12 +627,12 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 	 * The report shows the percentage of total branches captured
 	 * and not events sampled. Thus we use a pseudo period of 1.
 	 */
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
+	he = __hists__add_entry(hists, al, iter->parent, &bi[i], NULL,
 				1, 1, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(hists, he->filtered);
 
 out:
 	iter->he = he;
@@ -661,7 +664,7 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, true);
 	if (he == NULL)
@@ -684,7 +687,7 @@ iter_finish_normal_entry(struct hist_entry_iter *iter,
 
 	iter->he = NULL;
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(evsel__hists(evsel), he->filtered);
 
 	return hist_entry__append_callchain(he, sample);
 }
@@ -717,12 +720,13 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 				 struct addr_location *al)
 {
 	struct perf_evsel *evsel = iter->evsel;
+	struct hists *hists = evsel__hists(evsel);
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 	int err = 0;
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, true);
 	if (he == NULL)
@@ -739,7 +743,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	 */
 	callchain_cursor_commit(&callchain_cursor);
 
-	hists__inc_nr_samples(&evsel->hists, he->filtered);
+	hists__inc_nr_samples(hists, he->filtered);
 
 	return err;
 }
@@ -795,7 +799,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		}
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, false);
 	if (he == NULL)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 883406f..1d42354 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -827,7 +827,7 @@ int perf_session__deliver_event(struct perf_session *session,
 		 * future probably it'll be a good idea to restrict event
 		 * processing via perf_session to files with both set.
 		 */
-		hists__inc_nr_events(&evsel->hists, event->header.type);
+		hists__inc_nr_events(evsel__hists(evsel), event->header.type);
 	}
 
 	machine = perf_session__find_machine_for_cpumode(session, event,
@@ -1398,7 +1398,7 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 
 	evlist__for_each(session->evlist, pos) {
 		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
-		ret += events_stats__fprintf(&pos->hists.stats, fp);
+		ret += events_stats__fprintf(&evsel__hists(pos)->stats, fp);
 	}
 
 	return ret;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 289df9d..4906cd8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1218,7 +1218,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 
 	if (!len)
-		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+		len = hists__col_len(evsel__hists(evsel), hse->se->se_width_idx);
 
 	return scnprintf(hpp->buf, hpp->size, "%-*.*s", len, len, fmt->name);
 }
@@ -1233,7 +1233,7 @@ static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 
 	if (!len)
-		len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+		len = hists__col_len(evsel__hists(evsel), hse->se->se_width_idx);
 
 	return len;
 }
