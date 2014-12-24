Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaLXHW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:22:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39623 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaLXHOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:53 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/37] perf record: Add -M/--multi option for multi file recording
Date: Wed, 24 Dec 2014 16:15:05 +0900
Message-Id: <1419405333-27952-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new -M/--multi option enables multi file storage recording.  Now
sample data in separate mmap are saved in different files and other
events will be recorded in the perf.header file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-record.txt |  5 +++++
 tools/perf/builtin-record.c              | 27 ++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index af9a54ece024..14247ccd7965 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -220,6 +220,11 @@ Capture machine state (registers) at interrupt, i.e., on counter overflows for
 each sample. List of captured registers depends on the architecture. This option
 is off by default.
 
+-M::
+--multi::
+Record data in multi-file storage instead of a single data file (perf.data).
+This will speed up perf report by parallel processing.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4f97657f14e7..7f7a4725d080 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -58,6 +58,19 @@ static int record__write(struct record *rec, void *bf, size_t size)
 	return 0;
 }
 
+static int record__write_multi(struct record *rec, void *bf, size_t size, int idx)
+{
+	if (rec->file.is_multi && idx >= 0) {
+		int ret = perf_data_file__write_multi(rec->session->file,
+						      bf, size, idx);
+		if (ret < 0)
+			pr_err("failed to write perf data, error: %m\n");
+
+		return ret;
+	}
+	return record__write(rec, bf, size);
+}
+
 static int process_synthesized_event(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_sample *sample __maybe_unused,
@@ -89,7 +102,7 @@ static int record__mmap_read(struct record *rec, int idx)
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		if (record__write(rec, buf, size) < 0) {
+		if (record__write_multi(rec, buf, size, idx) < 0) {
 			rc = -1;
 			goto out;
 		}
@@ -99,7 +112,7 @@ static int record__mmap_read(struct record *rec, int idx)
 	size = head - old;
 	old += size;
 
-	if (record__write(rec, buf, size) < 0) {
+	if (record__write_multi(rec, buf, size, idx) < 0) {
 		rc = -1;
 		goto out;
 	}
@@ -186,6 +199,10 @@ static int record__open(struct record *rec)
 		goto out;
 	}
 
+	rc = perf_data_file__prepare_write(session->file, evlist->nr_mmaps);
+	if (rc < 0)
+		goto out;
+
 	session->evlist = evlist;
 	perf_session__set_id_hdr_size(session);
 out:
@@ -822,6 +839,8 @@ struct option __record_options[] = {
 		    "use per-thread mmaps"),
 	OPT_BOOLEAN('I', "intr-regs", &record.opts.sample_intr_regs,
 		    "Sample machine registers on interrupt"),
+	OPT_BOOLEAN('M', "multi", &record.opts.multi_file,
+		    "use multi-file storage"),
 	OPT_END()
 };
 
@@ -871,8 +890,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		goto out_symbol_exit;
 	}
 
-	if (rec->opts.multi_file)
+	if (rec->opts.multi_file) {
+		rec->file.is_multi = true;
 		perf_evlist__prepend_dummy(rec->evlist);
+	}
 
 	if (rec->opts.target.tid && !rec->opts.no_inherit_set)
 		rec->opts.no_inherit = true;
-- 
2.1.3

