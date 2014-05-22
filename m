Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaEVMYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:24:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaEVMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:24:31 -0400
Date: Thu, 22 May 2014 05:24:17 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f21d1815295ee79ce0767cb08d6f3ffa3a3b5cfe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-21-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-21-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add a testcase for histogram output sorting
Git-Commit-ID: f21d1815295ee79ce0767cb08d6f3ffa3a3b5cfe
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

Commit-ID:  f21d1815295ee79ce0767cb08d6f3ffa3a3b5cfe
Gitweb:     http://git.kernel.org/tip/f21d1815295ee79ce0767cb08d6f3ffa3a3b5cfe
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 12 May 2014 14:43:18 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:37 +0200

perf tests: Add a testcase for histogram output sorting

With new output fields option, its internal implementation was changed
so add a new testcase to verify whether it breaks things.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-21-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf        |   1 +
 tools/perf/tests/builtin-test.c |   4 +
 tools/perf/tests/hists_common.c |   4 +-
 tools/perf/tests/hists_filter.c |   1 +
 tools/perf/tests/hists_link.c   |   1 +
 tools/perf/tests/hists_output.c | 618 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 7 files changed, 628 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index dea2d633..02f0a4d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -399,6 +399,7 @@ LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_common.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/hists_filter.o
+LIB_OBJS += $(OUTPUT)tests/hists_output.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 5e0764b..831f52c 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -136,6 +136,10 @@ static struct test {
 		.func = test__thread_mg_share,
 	},
 	{
+		.desc = "Test output sorting of hist entries",
+		.func = test__hists_output,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/hists_common.c b/tools/perf/tests/hists_common.c
index 040a85b..e4e01aad 100644
--- a/tools/perf/tests/hists_common.c
+++ b/tools/perf/tests/hists_common.c
@@ -193,8 +193,8 @@ void print_hists_out(struct hists *hists)
 		he = rb_entry(node, struct hist_entry, rb_node);
 
 		if (!he->filtered) {
-			pr_info("%2d: entry: %-8s [%-8s] %20s: period = %"PRIu64"\n",
-				i, thread__comm_str(he->thread),
+			pr_info("%2d: entry: %8s:%5d [%-8s] %20s: period = %"PRIu64"\n",
+				i, thread__comm_str(he->thread), he->thread->tid,
 				he->ms.map->dso->short_name,
 				he->ms.sym->name, he->stat.period);
 		}
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 13c8cf4..c5ba924 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -283,6 +283,7 @@ int test__hists_filter(void)
 out:
 	/* tear down everything */
 	perf_evlist__delete(evlist);
+	reset_output_field();
 	machines__exit(&machines);
 
 	return err;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 4e783db..5ffa2c3 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -332,6 +332,7 @@ int test__hists_link(void)
 out:
 	/* tear down everything */
 	perf_evlist__delete(evlist);
+	reset_output_field();
 	machines__exit(&machines);
 
 	return err;
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
new file mode 100644
index 0000000..a168505
--- /dev/null
+++ b/tools/perf/tests/hists_output.c
@@ -0,0 +1,618 @@
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
+	u32 cpu;
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
+	{ .cpu = 0, .pid = 100, .ip = 0xf0000 + 700, },
+	/* perf [perf]   main() */
+	{ .cpu = 1, .pid = 100, .ip = 0x40000 + 700, },
+	/* perf [perf]   cmd_record() */
+	{ .cpu = 1, .pid = 100, .ip = 0x40000 + 900, },
+	/* perf [libc]   malloc() */
+	{ .cpu = 1, .pid = 100, .ip = 0x50000 + 700, },
+	/* perf [libc]   free() */
+	{ .cpu = 2, .pid = 100, .ip = 0x50000 + 800, },
+	/* perf [perf]   main() */
+	{ .cpu = 2, .pid = 200, .ip = 0x40000 + 700, },
+	/* perf [kernel] page_fault() */
+	{ .cpu = 2, .pid = 200, .ip = 0xf0000 + 800, },
+	/* bash [bash]   main() */
+	{ .cpu = 3, .pid = 300, .ip = 0x40000 + 700, },
+	/* bash [bash]   xmalloc() */
+	{ .cpu = 0, .pid = 300, .ip = 0x40000 + 800, },
+	/* bash [kernel] page_fault() */
+	{ .cpu = 1, .pid = 300, .ip = 0xf0000 + 800, },
+};
+
+static int add_hist_entries(struct hists *hists, struct machine *machine)
+{
+	struct addr_location al;
+	struct hist_entry *he;
+	struct perf_sample sample = { .period = 100, };
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(fake_samples); i++) {
+		const union perf_event event = {
+			.header = {
+				.misc = PERF_RECORD_MISC_USER,
+			},
+		};
+
+		sample.cpu = fake_samples[i].cpu;
+		sample.pid = fake_samples[i].pid;
+		sample.tid = fake_samples[i].pid;
+		sample.ip = fake_samples[i].ip;
+
+		if (perf_event__preprocess_sample(&event, machine, &al,
+						  &sample) < 0)
+			goto out;
+
+		he = __hists__add_entry(hists, &al, NULL, NULL, NULL,
+					sample.period, 1, 0);
+		if (he == NULL)
+			goto out;
+
+		fake_samples[i].thread = al.thread;
+		fake_samples[i].map = al.map;
+		fake_samples[i].sym = al.sym;
+	}
+
+	return TEST_OK;
+
+out:
+	pr_debug("Not enough memory for adding a hist entry\n");
+	return TEST_FAIL;
+}
+
+static void del_hist_entries(struct hists *hists)
+{
+	struct hist_entry *he;
+	struct rb_root *root_in;
+	struct rb_root *root_out;
+	struct rb_node *node;
+
+	if (sort__need_collapse)
+		root_in = &hists->entries_collapsed;
+	else
+		root_in = hists->entries_in;
+
+	root_out = &hists->entries;
+
+	while (!RB_EMPTY_ROOT(root_out)) {
+		node = rb_first(root_out);
+
+		he = rb_entry(node, struct hist_entry, rb_node);
+		rb_erase(node, root_out);
+		rb_erase(&he->rb_node_in, root_in);
+		hist_entry__free(he);
+	}
+}
+
+typedef int (*test_fn_t)(struct perf_evsel *, struct machine *);
+
+#define COMM(he)  (thread__comm_str(he->thread))
+#define DSO(he)   (he->ms.map->dso->short_name)
+#define SYM(he)   (he->ms.sym->name)
+#define CPU(he)   (he->cpu)
+#define PID(he)   (he->thread->tid)
+
+/* default sort keys (no field) */
+static int test1(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = NULL;
+	sort_order = NULL; /* equivalent to sort_order = "comm,dso,sym" */
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Overhead  Command  Shared Object          Symbol
+	 * ========  =======  =============  ==============
+	 *   20.00%     perf  perf           [.] main
+	 *   10.00%     bash  [kernel]       [k] page_fault
+	 *   10.00%     bash  bash           [.] main
+	 *   10.00%     bash  bash           [.] xmalloc
+	 *   10.00%     perf  [kernel]       [k] page_fault
+	 *   10.00%     perf  [kernel]       [k] schedule
+	 *   10.00%     perf  libc           [.] free
+	 *   10.00%     perf  libc           [.] malloc
+	 *   10.00%     perf  perf           [.] cmd_record
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "xmalloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "schedule") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "free") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "malloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "cmd_record") && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* mixed fields and sort keys */
+static int test2(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "overhead,cpu";
+	sort_order = "pid";
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Overhead  CPU  Command:  Pid
+	 * ========  ===  =============
+	 *   30.00%    1  perf   :  100
+	 *   10.00%    0  perf   :  100
+	 *   10.00%    2  perf   :  100
+	 *   20.00%    2  perf   :  200
+	 *   10.00%    0  bash   :  300
+	 *   10.00%    1  bash   :  300
+	 *   10.00%    3  bash   :  300
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 && he->stat.period == 300);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 0 && PID(he) == 100 && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* fields only (no sort key) */
+static int test3(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "comm,overhead,dso";
+	sort_order = NULL;
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Command  Overhead  Shared Object
+	 * =======  ========  =============
+	 *    bash    20.00%  bash
+	 *    bash    10.00%  [kernel]
+	 *    perf    30.00%  perf
+	 *    perf    20.00%  [kernel]
+	 *    perf    20.00%  libc
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "[kernel]") &&
+			he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			he->stat.period == 300);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			he->stat.period == 200);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* handle duplicate 'dso' field */
+static int test4(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "dso,sym,comm,overhead,dso";
+	sort_order = "sym";
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * Shared Object          Symbol  Command  Overhead
+	 * =============  ==============  =======  ========
+	 *          perf  [.] cmd_record     perf    10.00%
+	 *          libc  [.] free           perf    10.00%
+	 *          bash  [.] main           bash    10.00%
+	 *          perf  [.] main           perf    20.00%
+	 *          libc  [.] malloc         perf    10.00%
+	 *      [kernel]  [k] page_fault     bash    10.00%
+	 *      [kernel]  [k] page_fault     perf    10.00%
+	 *      [kernel]  [k] schedule       perf    10.00%
+	 *          bash  [.] xmalloc        bash    10.00%
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "perf") && !strcmp(SYM(he), "cmd_record") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "libc") && !strcmp(SYM(he), "free") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "bash") && !strcmp(SYM(he), "main") &&
+			!strcmp(COMM(he), "bash") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "perf") && !strcmp(SYM(he), "main") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 200);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "libc") && !strcmp(SYM(he), "malloc") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "[kernel]") && !strcmp(SYM(he), "page_fault") &&
+			!strcmp(COMM(he), "bash") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "[kernel]") && !strcmp(SYM(he), "page_fault") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "[kernel]") && !strcmp(SYM(he), "schedule") &&
+			!strcmp(COMM(he), "perf") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			!strcmp(DSO(he), "bash") && !strcmp(SYM(he), "xmalloc") &&
+			!strcmp(COMM(he), "bash") && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+/* full sort keys w/o overhead field */
+static int test5(struct perf_evsel *evsel, struct machine *machine)
+{
+	int err;
+	struct hists *hists = &evsel->hists;
+	struct hist_entry *he;
+	struct rb_root *root;
+	struct rb_node *node;
+
+	field_order = "cpu,pid,comm,dso,sym";
+	sort_order = "dso,pid";
+
+	setup_sorting();
+
+	/*
+	 * expected output:
+	 *
+	 * CPU  Command:  Pid  Command  Shared Object          Symbol
+	 * ===  =============  =======  =============  ==============
+	 *   0     perf:  100     perf       [kernel]  [k] schedule
+	 *   2     perf:  200     perf       [kernel]  [k] page_fault
+	 *   1     bash:  300     bash       [kernel]  [k] page_fault
+	 *   0     bash:  300     bash           bash  [.] xmalloc
+	 *   3     bash:  300     bash           bash  [.] main
+	 *   1     perf:  100     perf           libc  [.] malloc
+	 *   2     perf:  100     perf           libc  [.] free
+	 *   1     perf:  100     perf           perf  [.] cmd_record
+	 *   1     perf:  100     perf           perf  [.] main
+	 *   2     perf:  200     perf           perf  [.] main
+	 */
+	err = add_hist_entries(hists, machine);
+	if (err < 0)
+		goto out;
+
+	hists__collapse_resort(hists, NULL);
+	hists__output_resort(hists);
+
+	if (verbose > 2) {
+		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
+		print_hists_out(hists);
+	}
+
+	root = &evsel->hists.entries;
+	node = rb_first(root);
+	he = rb_entry(node, struct hist_entry, rb_node);
+
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 0 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "schedule") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 2 && PID(he) == 200 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 300 &&
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "[kernel]") &&
+			!strcmp(SYM(he), "page_fault") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 0 && PID(he) == 300 &&
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "xmalloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 3 && PID(he) == 300 &&
+			!strcmp(COMM(he), "bash") && !strcmp(DSO(he), "bash") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "malloc") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 2 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "libc") &&
+			!strcmp(SYM(he), "free") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "cmd_record") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 1 && PID(he) == 100 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+	node = rb_next(node);
+	he = rb_entry(node, struct hist_entry, rb_node);
+	TEST_ASSERT_VAL("Invalid hist entry",
+			CPU(he) == 2 && PID(he) == 200 &&
+			!strcmp(COMM(he), "perf") && !strcmp(DSO(he), "perf") &&
+			!strcmp(SYM(he), "main") && he->stat.period == 100);
+
+out:
+	del_hist_entries(hists);
+	reset_output_field();
+	return err;
+}
+
+int test__hists_output(void)
+{
+	int err = TEST_FAIL;
+	struct machines machines;
+	struct machine *machine;
+	struct perf_evsel *evsel;
+	struct perf_evlist *evlist = perf_evlist__new();
+	size_t i;
+	test_fn_t testcases[] = {
+		test1,
+		test2,
+		test3,
+		test4,
+		test5,
+	};
+
+	TEST_ASSERT_VAL("No memory", evlist);
+
+	err = parse_events(evlist, "cpu-clock");
+	if (err)
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
+	evsel = perf_evlist__first(evlist);
+
+	for (i = 0; i < ARRAY_SIZE(testcases); i++) {
+		err = testcases[i](evsel, machine);
+		if (err < 0)
+			break;
+	}
+
+out:
+	/* tear down everything */
+	perf_evlist__delete(evlist);
+	machines__exit(&machines);
+
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 8f91fb0..d76c0e2 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -44,6 +44,7 @@ int test__dwarf_unwind(void);
 int test__hists_filter(void);
 int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
+int test__hists_output(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
