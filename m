Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaD1Mo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbaD1Mo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:44:27 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/7] perf tests: Add a test case for hists filtering
Date: Mon, 28 Apr 2014 14:00:00 +0200
Message-Id: <1398686405-31951-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398686405-31951-1-git-send-email-jolsa@kernel.org>
References: <1398686405-31951-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Now we have changed how hists stats are accounted especially when
filter(s) applied.  So add a test case to verify it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398396494-12811-2-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf        |   1 +
 tools/perf/tests/builtin-test.c |   4 +
 tools/perf/tests/hists_filter.c | 315 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 321 insertions(+)
 create mode 100644 tools/perf/tests/hists_filter.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index a4aad78..0807e4c 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -399,6 +399,7 @@ LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_common.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
+LIB_OBJS += $(OUTPUT)tests/hists_filter.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b11bf8a..ceb9dae 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -124,6 +124,10 @@ static struct test {
 #endif
 #endif
 	{
+		.desc = "Test filtering hist entries",
+		.func = test__hists_filter,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
new file mode 100644
index 0000000..23dc2f4
--- /dev/null
+++ b/tools/perf/tests/hists_filter.c
@@ -0,0 +1,315 @@
+#include "perf.h"
+#include "util/debug.h"
+#include "util/symbol.h"
+#include "util/sort.h"
+#include "util/evsel.h"
+#include "util/evlist.h"
+#include "util/machine.h"
+#include "util/thread.h"
+#include "util/parse-events.h"
+#include "tests/tests.h"
+#include "tests/hists_common.h"
+
+struct sample {
+	u32 pid;
+	u64 ip;
+	struct thread *thread;
+	struct map *map;
+	struct symbol *sym;
+};
+
+/* For the numbers, see hists_common.c */
+static struct sample fake_samples[] = {
+	/* perf [kernel] schedule() */
+	{ .pid = 100, .ip = 0xf0000 + 700, },
+	/* perf [perf]   main() */
+	{ .pid = 100, .ip = 0x40000 + 700, },
+	/* perf [libc]   malloc() */
+	{ .pid = 100, .ip = 0x50000 + 700, },
+	/* perf [perf]   main() */
+	{ .pid = 200, .ip = 0x40000 + 700, }, /* will be merged */
+	/* perf [perf]   cmd_record() */
+	{ .pid = 200, .ip = 0x40000 + 900, },
+	/* perf [kernel] page_fault() */
+	{ .pid = 200, .ip = 0xf0000 + 800, },
+	/* bash [bash]   main() */
+	{ .pid = 300, .ip = 0x40000 + 700, },
+	/* bash [bash]   xmalloc() */
+	{ .pid = 300, .ip = 0x40000 + 800, },
+	/* bash [libc]   malloc() */
+	{ .pid = 300, .ip = 0x50000 + 700, },
+	/* bash [kernel] page_fault() */
+	{ .pid = 300, .ip = 0xf0000 + 800, },
+};
+
+static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
+{
+	struct perf_evsel *evsel;
+	struct addr_location al;
+	struct hist_entry *he;
+	struct perf_sample sample = { .cpu = 0, };
+	size_t i;
+
+	/*
+	 * each evsel will have 10 samples but the 4th sample
+	 * (perf [perf] main) will be collapsed to an existing entry
+	 * so total 9 entries will be in the tree.
+	 */
+	evlist__for_each(evlist, evsel) {
+		for (i = 0; i < ARRAY_SIZE(fake_samples); i++) {
+			const union perf_event event = {
+				.header = {
+					.misc = PERF_RECORD_MISC_USER,
+				},
+			};
+
+			/* make sure it has no filter at first */
+			evsel->hists.thread_filter = NULL;
+			evsel->hists.dso_filter = NULL;
+			evsel->hists.symbol_filter_str = NULL;
+
+			sample.pid = fake_samples[i].pid;
+			sample.ip = fake_samples[i].ip;
+
+			if (perf_event__preprocess_sample(&event, machine, &al,
+							  &sample) < 0)
+				goto out;
+
+			he = __hists__add_entry(&evsel->hists, &al, NULL,
+						NULL, NULL, 100, 1, 0);
+			if (he == NULL)
+				goto out;
+
+			fake_samples[i].thread = al.thread;
+			fake_samples[i].map = al.map;
+			fake_samples[i].sym = al.sym;
+
+			hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
+			if (!he->filtered)
+				he->hists->stats.nr_non_filtered_samples++;
+		}
+	}
+
+	return 0;
+
+out:
+	pr_debug("Not enough memory for adding a hist entry\n");
+	return TEST_FAIL;
+}
+
+static void print_hists(struct hists *hists)
+{
+	int i = 0;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	root = &hists->entries;
+
+	pr_info("----- %s --------\n", __func__);
+	node = rb_first(root);
+	while (node) {
+		struct hist_entry *he;
+
+		he = rb_entry(node, struct hist_entry, rb_node);
+
+		if (!he->filtered) {
+			pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
+				i, thread__comm_str(he->thread),
+				he->ms.map->dso->short_name,
+				he->ms.sym->name, he->stat.period);
+		}
+
+		i++;
+		node = rb_next(node);
+	}
+}
+
+int test__hists_filter(void)
+{
+	int err = TEST_FAIL;
+	struct machines machines;
+	struct machine *machine;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist = perf_evlist__new();
+
+	TEST_ASSERT_VAL("No memory", evlist);
+
+	err = parse_events(evlist, "cpu-clock");
+	if (err)
+		goto out;
+	err = parse_events(evlist, "task-clock");
+	if (err)
+		goto out;
+
+	/* default sort order (comm,dso,sym) will be used */
+	if (setup_sorting() < 0)
+		goto out;
+
+	machines__init(&machines);
+
+	/* setup threads/dso/map/symbols also */
+	machine = setup_fake_machine(&machines);
+	if (!machine)
+		goto out;
+
+	if (verbose > 1)
+		machine__fprintf(machine, stderr);
+
+	/* process sample events */
+	err = add_hist_entries(evlist, machine);
+	if (err < 0)
+		goto out;
+
+	evlist__for_each(evlist, evsel) {
+		struct hists *hists = &evsel->hists;
+
+		hists__collapse_resort(hists, NULL);
+		hists__output_resort(hists);
+
+		if (verbose > 2) {
+			pr_info("Normal histogram\n");
+			print_hists(hists);
+		}
+
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+		TEST_ASSERT_VAL("Unmatched nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] ==
+				hists->stats.nr_non_filtered_samples);
+		TEST_ASSERT_VAL("Unmatched nr hist entries",
+				hists->nr_entries == hists->nr_non_filtered_entries);
+		TEST_ASSERT_VAL("Unmatched total period",
+				hists->stats.total_period ==
+				hists->stats.total_non_filtered_period);
+
+		/* now applying thread filter for 'bash' */
+		evsel->hists.thread_filter = fake_samples[9].thread;
+		hists__filter_by_thread(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for thread filter\n");
+			print_hists(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for thread filter",
+				hists->stats.nr_non_filtered_samples == 4);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for thread filter",
+				hists->nr_non_filtered_entries == 4);
+		TEST_ASSERT_VAL("Unmatched total period for thread filter",
+				hists->stats.total_non_filtered_period == 400);
+
+		/* remove thread filter first */
+		evsel->hists.thread_filter = NULL;
+		hists__filter_by_thread(hists);
+
+		/* now applying dso filter for 'kernel' */
+		evsel->hists.dso_filter = fake_samples[0].map->dso;
+		hists__filter_by_dso(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for dso filter\n");
+			print_hists(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for dso filter",
+				hists->stats.nr_non_filtered_samples == 3);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for dso filter",
+				hists->nr_non_filtered_entries == 3);
+		TEST_ASSERT_VAL("Unmatched total period for dso filter",
+				hists->stats.total_non_filtered_period == 300);
+
+		/* remove dso filter first */
+		evsel->hists.dso_filter = NULL;
+		hists__filter_by_dso(hists);
+
+		/*
+		 * now applying symbol filter for 'main'.  Also note that
+		 * there's 3 samples that have 'main' symbol but the 4th
+		 * entry of fake_samples was collapsed already so it won't
+		 * be counted as a separate entry but the sample count and
+		 * total period will be remained.
+		 */
+		evsel->hists.symbol_filter_str = "main";
+		hists__filter_by_symbol(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for symbol filter\n");
+			print_hists(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for symbol filter",
+				hists->stats.nr_non_filtered_samples == 3);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for symbol filter",
+				hists->nr_non_filtered_entries == 2);
+		TEST_ASSERT_VAL("Unmatched total period for symbol filter",
+				hists->stats.total_non_filtered_period == 300);
+
+		/* now applying all filters at once. */
+		evsel->hists.thread_filter = fake_samples[1].thread;
+		evsel->hists.dso_filter = fake_samples[1].map->dso;
+		hists__filter_by_thread(hists);
+		hists__filter_by_dso(hists);
+
+		if (verbose > 2) {
+			pr_info("Histogram for all filters\n");
+			print_hists(hists);
+		}
+
+		/* normal stats should be invariant */
+		TEST_ASSERT_VAL("Invalid nr samples",
+				hists->stats.nr_events[PERF_RECORD_SAMPLE] == 10);
+		TEST_ASSERT_VAL("Invalid nr hist entries",
+				hists->nr_entries == 9);
+		TEST_ASSERT_VAL("Invalid total period",
+				hists->stats.total_period == 1000);
+
+		/* but filter stats are changed */
+		TEST_ASSERT_VAL("Unmatched nr samples for all filter",
+				hists->stats.nr_non_filtered_samples == 2);
+		TEST_ASSERT_VAL("Unmatched nr hist entries for all filter",
+				hists->nr_non_filtered_entries == 1);
+		TEST_ASSERT_VAL("Unmatched total period for all filter",
+				hists->stats.total_non_filtered_period == 200);
+	}
+
+
+	err = TEST_OK;
+
+out:
+	/* tear down everything */
+	perf_evlist__delete(evlist);
+	machines__exit(&machines);
+
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index a24795c..fe39163 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -41,6 +41,7 @@ int test__sample_parsing(void);
 int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
+int test__hists_filter(void);
 
 #if defined(__x86_64__) || defined(__i386__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.8.3.1

