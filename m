Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaJOKFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:05:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaJOKFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:05:19 -0400
Date: Wed, 15 Oct 2014 03:04:15 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-usjx2la743f10ippj7p1b20x@git.kernel.org>
Cc: namhyung@kernel.org, fweisbec@gmail.com, hpa@zytor.com,
        jean.pihet@linaro.org, dzickus@redhat.com, efault@gmx.de,
        mingo@kernel.org, acme@redhat.com, bp@suse.de,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        eranian@google.com, paulus@samba.org
Reply-To: dsahern@gmail.com, paulus@samba.org, eranian@google.com,
        tglx@linutronix.de, adrian.hunter@intel.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, bp@suse.de, peterz@infradead.org,
        efault@gmx.de, acme@redhat.com, mingo@kernel.org, hpa@zytor.com,
        namhyung@kernel.org, fweisbec@gmail.com, dzickus@redhat.com,
        jean.pihet@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Remove hists from evsel
Git-Commit-ID: a635fc511e05774298153e3ddfef7c4cd51a1bb4
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

Commit-ID:  a635fc511e05774298153e3ddfef7c4cd51a1bb4
Gitweb:     http://git.kernel.org/tip/a635fc511e05774298153e3ddfef7c4cd51a1bb4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 9 Oct 2014 16:16:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:52 -0300

perf tools: Remove hists from evsel

Now tools that deals want to have an hists per evsel need to call
hists__init() before creating any evsels, which can be as early as when
parsing the command line, so do it before calling parse_options().

The current tools using hists/hist_entries are report, top and annotate,
change them to request per evsel hists.

This is in preparation for making evsels usable by 3rd party tools, that
not necessarily live in perf's source code repository.

Acked-by: Borislav Petkov <bp@suse.de>
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
Link: http://lkml.kernel.org/n/tip-usjx2la743f10ippj7p1b20x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c   |  5 ++++-
 tools/perf/builtin-report.c     |  5 ++++-
 tools/perf/builtin-top.c        |  5 ++++-
 tools/perf/tests/builtin-test.c |  5 +++++
 tools/perf/util/evsel.c         | 11 -----------
 tools/perf/util/evsel.h         | 11 -----------
 tools/perf/util/hist.c          | 28 ++++++++++++++++++++++++++++
 tools/perf/util/hist.h          | 20 ++++++++++++++++++++
 8 files changed, 65 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index a5969fa..e7417fe 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -326,7 +326,10 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show event group information together"),
 	OPT_END()
 	};
-	int ret;
+	int ret = hists__init();
+
+	if (ret < 0)
+		return ret;
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8043b5a..2cfc4b93 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -568,7 +568,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct stat st;
 	bool has_br_stack = false;
 	int branch_mode = -1;
-	int ret = -1;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
 		"perf report [<options>]",
@@ -695,6 +694,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_data_file file = {
 		.mode  = PERF_DATA_MODE_READ,
 	};
+	int ret = hists__init();
+
+	if (ret < 0)
+		return ret;
 
 	perf_config(report__config, &report);
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8ab9716..0aa7747 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1047,7 +1047,6 @@ parse_percent_limit(const struct option *opt, const char *arg,
 
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	int status = -1;
 	char errbuf[BUFSIZ];
 	struct perf_top top = {
 		.count_filter	     = 5,
@@ -1165,6 +1164,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf top [<options>]",
 		NULL
 	};
+	int status = hists__init();
+
+	if (status < 0)
+		return status;
 
 	top.evlist = perf_evlist__new();
 	if (top.evlist == NULL)
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index ac655b0..162c978 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -6,6 +6,7 @@
 #include <unistd.h>
 #include <string.h>
 #include "builtin.h"
+#include "hist.h"
 #include "intlist.h"
 #include "tests.h"
 #include "debug.h"
@@ -302,6 +303,10 @@ int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 	struct intlist *skiplist = NULL;
+        int ret = hists__init();
+
+        if (ret < 0)
+                return ret;
 
 	argc = parse_options(argc, argv, test_options, test_usage, 0);
 	if (argc >= 1 && !strcmp(argv[0], "list"))
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a083764..7a3c4c4 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -159,16 +159,6 @@ void perf_evsel__calc_id_pos(struct perf_evsel *evsel)
 	evsel->is_pos = __perf_evsel__calc_is_pos(evsel->attr.sample_type);
 }
 
-void hists__init(struct hists *hists)
-{
-	memset(hists, 0, sizeof(*hists));
-	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
-	hists->entries_in = &hists->entries_in_array[0];
-	hists->entries_collapsed = RB_ROOT;
-	hists->entries = RB_ROOT;
-	pthread_mutex_init(&hists->lock, NULL);
-}
-
 void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
 				  enum perf_event_sample_format bit)
 {
@@ -211,7 +201,6 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->unit	   = "";
 	evsel->scale	   = 1.0;
 	INIT_LIST_HEAD(&evsel->node);
-	hists__init(&evsel->hists);
 	perf_evsel__object.init(evsel);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
 	perf_evsel__calc_id_pos(evsel);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index d632510..fee9274 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -8,7 +8,6 @@
 #include <linux/types.h>
 #include "xyarray.h"
 #include "cgroup.h"
-#include "hist.h"
 #include "symbol.h"
 
 struct perf_counts_values {
@@ -66,7 +65,6 @@ struct perf_evsel {
 	struct perf_counts	*prev_raw_counts;
 	int			idx;
 	u32			ids;
-	struct hists		hists;
 	char			*name;
 	double			scale;
 	const char		*unit;
@@ -100,13 +98,6 @@ union u64_swap {
 	u32 val32[2];
 };
 
-#define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
-
-static inline struct hists *evsel__hists(struct perf_evsel *evsel)
-{
-	return &evsel->hists;
-}
-
 struct cpu_map;
 struct thread_map;
 struct perf_evlist;
@@ -290,8 +281,6 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read(evsel, ncpus, nthreads, true);
 }
 
-void hists__init(struct hists *hists);
-
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample);
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b143e40..6e88b9e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1447,3 +1447,31 @@ int perf_hist_config(const char *var, const char *value)
 
 	return 0;
 }
+
+static int hists_evsel__init(struct perf_evsel *evsel)
+{
+	struct hists *hists = evsel__hists(evsel);
+
+	memset(hists, 0, sizeof(*hists));
+	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
+	hists->entries_in = &hists->entries_in_array[0];
+	hists->entries_collapsed = RB_ROOT;
+	hists->entries = RB_ROOT;
+	pthread_mutex_init(&hists->lock, NULL);
+	return 0;
+}
+
+/*
+ * XXX We probably need a hists_evsel__exit() to free the hist_entries
+ * stored in the rbtree...
+ */
+
+int hists__init(void)
+{
+	int err = perf_evsel__object_config(sizeof(struct hists_evsel),
+					    hists_evsel__init, NULL);
+	if (err)
+		fputs("FATAL ERROR: Couldn't setup hists class\n", stderr);
+
+	return err;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ebfc258..d0ef9a1 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <pthread.h>
 #include "callchain.h"
+#include "evsel.h"
 #include "header.h"
 #include "color.h"
 #include "ui/progress.h"
@@ -158,6 +159,25 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *he);
 void hists__match(struct hists *leader, struct hists *other);
 int hists__link(struct hists *leader, struct hists *other);
 
+struct hists_evsel {
+	struct perf_evsel evsel;
+	struct hists	  hists;
+};
+
+static inline struct perf_evsel *hists_to_evsel(struct hists *hists)
+{
+	struct hists_evsel *hevsel = container_of(hists, struct hists_evsel, hists);
+	return &hevsel->evsel;
+}
+
+static inline struct hists *evsel__hists(struct perf_evsel *evsel)
+{
+	struct hists_evsel *hevsel = (struct hists_evsel *)evsel;
+	return &hevsel->hists;
+}
+
+int hists__init(void);
+
 struct perf_hpp {
 	char *buf;
 	size_t size;
