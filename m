Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3KDLHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:07:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3KDLGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:06:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf tools: Check maximum frequency rate for record/top
Date: Mon,  4 Nov 2013 12:06:13 +0100
Message-Id: <1383563173-17466-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the check for maximum allowed frequency rate
defined in following file:
  /proc/sys/kernel/perf_event_max_sample_rate

When we cross the maximum value we fail and display
detailed error message with advise.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |  3 +++
 tools/perf/builtin-top.c    |  3 +++
 tools/perf/util/evlist.h    |  1 +
 tools/perf/util/record.c    | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ab8d15e..f300034 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -201,6 +201,9 @@ static int perf_record__open(struct perf_record *rec)
 	struct perf_record_opts *opts = &rec->opts;
 	int rc = 0;
 
+	if (perf_opts__check(opts))
+		return -1;
+
 	perf_evlist__config(evlist, opts);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 04f5bf2..9c17af8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -879,6 +879,9 @@ static int perf_top__start_counters(struct perf_top *top)
 	struct perf_evlist *evlist = top->evlist;
 	struct perf_record_opts *opts = &top->record_opts;
 
+	if (perf_opts__check(opts))
+		return -1;
+
 	perf_evlist__config(evlist, opts);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 6e8acc9..3acadd9 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -99,6 +99,7 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist);
 bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
+int perf_opts__check(struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 18d73aa..d881209 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -2,6 +2,8 @@
 #include "evsel.h"
 #include "cpumap.h"
 #include "parse-events.h"
+#include "fs.h"
+#include "util.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
 
@@ -106,3 +108,36 @@ void perf_evlist__config(struct perf_evlist *evlist,
 
 	perf_evlist__set_id_pos(evlist);
 }
+
+static int get_max_rate(unsigned int *rate)
+{
+	const char *procfs;
+	char path[PATH_MAX];
+
+	procfs = procfs_find_mountpoint();
+	if (!procfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/sys/kernel/perf_event_max_sample_rate", procfs);
+
+	return filename__read_int(path, (int *) rate);
+}
+
+int perf_opts__check(struct perf_record_opts *opts)
+{
+	unsigned int max_rate;
+
+	if (get_max_rate(&max_rate))
+		return 0;
+
+	if (max_rate < opts->freq) {
+		pr_err("Maximum rate (%u) for frequency reached.\n"
+		   "Please use -F freq option with lower value or consider\n"
+		   "tweaking /proc/sys/kernel/perf_event_max_sample_rate.\n",
+		   max_rate);
+		return -1;
+	}
+
+	return 0;
+}
-- 
1.7.11.7

