Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3KFFow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:44:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3KFFoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:44:44 -0500
Date: Tue, 5 Nov 2013 21:44:19 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-714647bdc516330e4405b39677d7f763e016c685@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1383660887-1734-4-git-send-email-jolsa@redhat.com>
References: <1383660887-1734-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Check maximum frequency rate for record/top
Git-Commit-ID: 714647bdc516330e4405b39677d7f763e016c685
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 05 Nov 2013 21:44:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  714647bdc516330e4405b39677d7f763e016c685
Gitweb:     http://git.kernel.org/tip/714647bdc516330e4405b39677d7f763e016c685
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 5 Nov 2013 15:14:47 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Nov 2013 15:15:08 -0300

perf tools: Check maximum frequency rate for record/top

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
index 8b45fce..ea4c04f 100644
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
index 21897f0..9acca88 100644
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
index 6e8acc9..0617ce2 100644
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
index 18d73aa..c8845b1 100644
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
