Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3LKMmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:19672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab3LKMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450498905"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 59/71] perf record: Add Instruction Tracing Snapshot Mode support
Date: Wed, 11 Dec 2013 14:37:11 +0200
Message-Id: <1386765443-26966-60-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a new option and support for Instruction
Tracing Snapshot Mode.  When the new option is
selected, no Instruction Tracing data is
captured until a signal (SIGUSR2) is received.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt |  7 +++
 tools/perf/builtin-record.c              | 90 +++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 58bd3c1..279c808 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -216,6 +216,13 @@ if combined with -a or -C options.
 Enable Instruction Trace sampling. Each sample captures the specified number of
 bytes (default 4096) of trace. Instruction Tracing config can also be specified.
 
+-S::
+--snapshot::
+Select Instruction Tracing Snapshot Mode. This option is valid only with an
+Instruction Tracing event. Optionally the number of bytes to capture per
+snapshot can be specified. In Snapshot Mode, trace data is captured only when
+signal SIGUSR2 is received.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e75a15e..46c451c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -188,9 +188,29 @@ static int perf_record__itrace_mmap_read(struct perf_record *rec,
 	return 0;
 }
 
+static int perf_record__itrace_mmap_read_snapshot(struct perf_record *rec,
+						  struct itrace_mmap *mm)
+{
+	int ret;
+
+	ret = itrace_mmap__read_snapshot(mm, rec->itr, &rec->tool,
+					 perf_record__process_itrace,
+					 rec->opts.itrace_snapshot_size);
+	if (ret < 0)
+		return ret;
+
+	if (ret)
+		rec->samples++;
+
+	return 0;
+}
+
 static volatile int done = 0;
 static volatile int signr = -1;
 static volatile int child_finished = 0;
+static volatile int itrace_snapshot_enabled;
+static volatile int itrace_snapshot_err;
+static volatile int itrace_record__snapshot_started;
 
 static void sig_handler(int sig)
 {
@@ -258,7 +278,7 @@ try_again:
 
 	if (perf_evlist__mmap_ex(evlist, opts->mmap_pages, false,
 				 opts->itrace_mmap_pages,
-				 false) < 0) {
+				 opts->itrace_snapshot_mode) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
@@ -368,7 +388,7 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 			}
 		}
 
-		if (mm->base &&
+		if (mm->base && !rec->opts.itrace_snapshot_mode &&
 		    perf_record__itrace_mmap_read(rec, mm) != 0) {
 			rc = -1;
 			goto out;
@@ -405,6 +425,41 @@ static void perf_record__init_features(struct perf_record *rec)
 		perf_header__clear_feat(&session->header, HEADER_ITRACE);
 }
 
+static int perf_record__itrace_read_snapshot_all(struct perf_record *rec)
+{
+	int i;
+	int rc = 0;
+
+	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
+		struct itrace_mmap *mm =
+				&rec->evlist->mmap[i].itrace_mmap;
+
+		if (!mm->base)
+			continue;
+
+		if (perf_record__itrace_mmap_read_snapshot(rec, mm) != 0) {
+			rc = -1;
+			goto out;
+		}
+	}
+out:
+	return rc;
+}
+
+static void perf_record__read_itrace_snapshot(struct perf_record *rec)
+{
+	pr_debug("Recording instruction tracing snapshot\n");
+	if (perf_record__itrace_read_snapshot_all(rec) < 0) {
+		itrace_snapshot_err = -1;
+	} else {
+		itrace_snapshot_err = itrace_record__snapshot_finish(rec->itr);
+		if (!itrace_snapshot_err)
+			itrace_snapshot_enabled = 1;
+	}
+}
+
+static void snapshot_sig_handler(int sig);
+
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	int err;
@@ -425,6 +480,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGTERM, sig_handler);
+	if (rec->opts.itrace_snapshot_mode)
+		signal(SIGUSR2, snapshot_sig_handler);
+	else
+		signal(SIGUSR2, SIG_IGN);
 
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
@@ -574,14 +633,27 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (forks)
 		perf_evlist__start_workload(evsel_list);
 
+	itrace_snapshot_enabled = 1;
 	for (;;) {
 		int hits = rec->samples;
 
 		if (perf_record__mmap_read_all(rec) < 0) {
+			itrace_snapshot_enabled = 0;
 			err = -1;
 			goto out_delete_session;
 		}
 
+		if (itrace_record__snapshot_started) {
+			itrace_record__snapshot_started = 0;
+			if (!itrace_snapshot_err)
+				perf_record__read_itrace_snapshot(rec);
+			if (itrace_snapshot_err) {
+				pr_err("Instruction tracing snapshot failed\n");
+				err = -1;
+				goto out_delete_session;
+			}
+		}
+
 		if (hits == rec->samples) {
 			if (done)
 				break;
@@ -595,10 +667,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		 * disable events in this case.
 		 */
 		if (done && !disabled && !target__none(&opts->target)) {
+			itrace_snapshot_enabled = 0;
 			perf_evlist__disable(evsel_list);
 			disabled = true;
 		}
 	}
+	itrace_snapshot_enabled = 0;
 
 	if (quiet || signr == SIGUSR1)
 		return 0;
@@ -998,6 +1072,9 @@ const struct option record_options[] = {
 	OPT_CALLBACK_OPTARG('I', "itrace", &record.opts, &record.itr, "opts",
 			    "sample Instruction Trace",
 			    itrace_parse_sample_options),
+	OPT_CALLBACK_OPTARG('S', "snapshot", &record.opts, &record.itr, "opts",
+			    "Instruction Tracing Snapshot Mode",
+			    itrace_parse_snapshot_options),
 	OPT_END()
 };
 
@@ -1096,3 +1173,12 @@ out_itrace_free:
 	itrace_record__free(rec->itr);
 	return err;
 }
+
+static void snapshot_sig_handler(int sig __maybe_unused)
+{
+	if (!itrace_snapshot_enabled)
+		return;
+	itrace_snapshot_enabled = 0;
+	itrace_snapshot_err = itrace_record__snapshot_start(record.itr);
+	itrace_record__snapshot_started = 1;
+}
-- 
1.8.5.1

