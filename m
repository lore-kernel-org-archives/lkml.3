Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3KEUKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:10:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38829 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3KEUKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/10] perf tools: Check maximum frequency rate for record/top
Date: Tue,  5 Nov 2013 17:10:00 -0300
Message-Id: <1383682201-19399-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383682201-19399-1-git-send-email-acme@infradead.org>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding the check for maximum allowed frequency rate defined in following
file:

  /proc/sys/kernel/perf_event_max_sample_rate

When we cross the maximum value we fail and display detailed error
message with advise.

  $ perf record -F 3000 ls
  Maximum frequency rate (2000) reached.
  Please use -F freq option with lower value or consider
  tweaking /proc/sys/kernel/perf_event_max_sample_rate.

In case user does not specify the frequency and the default value cross
the maximum, we display warning and set the frequency value to the
current maximum.

  $ perf record ls
  Lowering default frequency rate to 2000.
  Please consider tweaking /proc/sys/kernel/perf_event_max_sample_rate.

Same messages are used for 'perf top'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383660887-1734-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 15 +---------
 tools/perf/builtin-top.c    | 15 +---------
 tools/perf/util/evlist.h    |  1 +
 tools/perf/util/record.c    | 71 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8b45fcead5f6..ea4c04f7437e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -958,20 +958,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
-	if (rec->opts.user_interval != ULLONG_MAX)
-		rec->opts.default_interval = rec->opts.user_interval;
-	if (rec->opts.user_freq != UINT_MAX)
-		rec->opts.freq = rec->opts.user_freq;
-
-	/*
-	 * User specified count overrides default frequency.
-	 */
-	if (rec->opts.default_interval)
-		rec->opts.freq = 0;
-	else if (rec->opts.freq) {
-		rec->opts.default_interval = rec->opts.freq;
-	} else {
-		ui__error("frequency and count are zero, aborting\n");
+	if (perf_record_opts__config(&rec->opts)) {
 		err = -EINVAL;
 		goto out_free_fd;
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 21897f0ffcd3..9acca8856ccb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1209,20 +1209,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.delay_secs < 1)
 		top.delay_secs = 1;
 
-	if (opts->user_interval != ULLONG_MAX)
-		opts->default_interval = opts->user_interval;
-	if (opts->user_freq != UINT_MAX)
-		opts->freq = opts->user_freq;
-
-	/*
-	 * User specified count overrides default frequency.
-	 */
-	if (opts->default_interval)
-		opts->freq = 0;
-	else if (opts->freq) {
-		opts->default_interval = opts->freq;
-	} else {
-		ui__error("frequency and count are zero, aborting\n");
+	if (perf_record_opts__config(opts)) {
 		status = -EINVAL;
 		goto out_delete_maps;
 	}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 6e8acc9abe38..0617ce2a0679 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -99,6 +99,7 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist);
 bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
+int perf_record_opts__config(struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 18d73aa2f0f8..c8845b107f60 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -2,6 +2,8 @@
 #include "evsel.h"
 #include "cpumap.h"
 #include "parse-events.h"
+#include "fs.h"
+#include "util.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
 
@@ -106,3 +108,72 @@ void perf_evlist__config(struct perf_evlist *evlist,
 
 	perf_evlist__set_id_pos(evlist);
 }
+
+static int get_max_rate(unsigned int *rate)
+{
+	char path[PATH_MAX];
+	const char *procfs = procfs__mountpoint();
+
+	if (!procfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/sys/kernel/perf_event_max_sample_rate", procfs);
+
+	return filename__read_int(path, (int *) rate);
+}
+
+static int perf_record_opts__config_freq(struct perf_record_opts *opts)
+{
+	bool user_freq = opts->user_freq != UINT_MAX;
+	unsigned int max_rate;
+
+	if (opts->user_interval != ULLONG_MAX)
+		opts->default_interval = opts->user_interval;
+	if (user_freq)
+		opts->freq = opts->user_freq;
+
+	/*
+	 * User specified count overrides default frequency.
+	 */
+	if (opts->default_interval)
+		opts->freq = 0;
+	else if (opts->freq) {
+		opts->default_interval = opts->freq;
+	} else {
+		pr_err("frequency and count are zero, aborting\n");
+		return -1;
+	}
+
+	if (get_max_rate(&max_rate))
+		return 0;
+
+	/*
+	 * User specified frequency is over current maximum.
+	 */
+	if (user_freq && (max_rate < opts->freq)) {
+		pr_err("Maximum frequency rate (%u) reached.\n"
+		   "Please use -F freq option with lower value or consider\n"
+		   "tweaking /proc/sys/kernel/perf_event_max_sample_rate.\n",
+		   max_rate);
+		return -1;
+	}
+
+	/*
+	 * Default frequency is over current maximum.
+	 */
+	if (max_rate < opts->freq) {
+		pr_warning("Lowering default frequency rate to %u.\n"
+			   "Please consider tweaking "
+			   "/proc/sys/kernel/perf_event_max_sample_rate.\n",
+			   max_rate);
+		opts->freq = max_rate;
+	}
+
+	return 0;
+}
+
+int perf_record_opts__config(struct perf_record_opts *opts)
+{
+	return perf_record_opts__config_freq(opts);
+}
-- 
1.8.1.4

