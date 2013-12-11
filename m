Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3LKMla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:59750 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab3LKMlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422886751"
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
Subject: [PATCH v0 44/71] perf record: Extend -m option for Instruction Tracing mmap pages
Date: Wed, 11 Dec 2013 14:36:56 +0200
Message-Id: <1386765443-26966-45-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Extend the -m option so that the number
of mmap pages for Instruction Tracing
can be specified.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt |  2 ++
 tools/perf/builtin-record.c              | 49 ++++++++++++++++++++++++++++++--
 tools/perf/util/evlist.c                 | 16 +++++++----
 tools/perf/util/evlist.h                 |  2 ++
 4 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index c407897..bb01df7 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -92,6 +92,8 @@ OPTIONS
 	Number of mmap data pages (must be a power of two) or size
 	specification with appended unit character - B/K/M/G. The
 	size is rounded up to have nearest pages power of two value.
+	Also, by adding a comma, the number of mmap pages for Instruction
+	Tracing can be specified.
 
 -g::
 	Enables call-graph (stack chain/backtrace) recording.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4613f55..344603f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -828,6 +828,49 @@ int record_callchain_opt(const struct option *opt,
 	return 0;
 }
 
+static int perf_record__parse_mmap_pages(const struct option *opt,
+					 const char *str,
+					 int unset __maybe_unused)
+{
+	struct perf_record_opts	*opts = opt->value;
+	char *s, *p;
+	unsigned int mmap_pages;
+	int ret;
+
+	if (!str)
+		return -EINVAL;
+
+	s = strdup(str);
+	if (!s)
+		return -ENOMEM;
+
+	p = strchr(s, ',');
+	if (p)
+		*p = '\0';
+
+	if (*s) {
+		ret = __perf_evlist__parse_mmap_pages(&mmap_pages, s, true);
+		if (ret)
+			goto out_free;
+		opts->mmap_pages = mmap_pages;
+	}
+
+	if (!p) {
+		ret = 0;
+		goto out_free;
+	}
+
+	ret = __perf_evlist__parse_mmap_pages(&mmap_pages, p + 1, false);
+	if (ret)
+		goto out_free;
+
+	opts->itrace_mmap_pages = mmap_pages;
+
+out_free:
+	free(s);
+	return ret;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -899,9 +942,9 @@ const struct option record_options[] = {
 			&record.opts.no_inherit_set,
 			"child tasks do not inherit counters"),
 	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
-	OPT_CALLBACK('m', "mmap-pages", &record.opts.mmap_pages, "pages",
-		     "number of mmap data pages",
-		     perf_evlist__parse_mmap_pages),
+	OPT_CALLBACK('m', "mmap-pages", &record.opts, "pages[,pages]",
+		     "number of mmap data pages and instruction tracing mmap pages",
+		     perf_record__parse_mmap_pages),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
 	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c720c6c..dbb1898 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -843,7 +843,7 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 }
 
 static long parse_pages_arg(const char *str, unsigned long min,
-			    unsigned long max)
+			    unsigned long max, bool po2)
 {
 	unsigned long pages, val;
 	static struct parse_tag tags[] = {
@@ -871,7 +871,7 @@ static long parse_pages_arg(const char *str, unsigned long min,
 
 	if ((pages == 0) && (min == 0)) {
 		/* leave number of pages at 0 */
-	} else if (pages < (1UL << 31) && !is_power_of_2(pages)) {
+	} else if (po2 && pages < (1UL << 31) && !is_power_of_2(pages)) {
 		/* round pages up to next power of 2 */
 		pages = next_pow2(pages);
 		pr_info("rounding mmap pages size to %lu bytes (%lu pages)\n",
@@ -884,17 +884,15 @@ static long parse_pages_arg(const char *str, unsigned long min,
 	return pages;
 }
 
-int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
-				  int unset __maybe_unused)
+int __perf_evlist__parse_mmap_pages(unsigned int *mmap_pages, const char *str, bool po2)
 {
-	unsigned int *mmap_pages = opt->value;
 	unsigned long max = UINT_MAX;
 	long pages;
 
 	if (max < SIZE_MAX / page_size)
 		max = SIZE_MAX / page_size;
 
-	pages = parse_pages_arg(str, 1, max);
+	pages = parse_pages_arg(str, 1, max, po2);
 	if (pages < 0) {
 		pr_err("Invalid argument for --mmap_pages/-m\n");
 		return -1;
@@ -904,6 +902,12 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	return 0;
 }
 
+int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
+				  int unset __maybe_unused)
+{
+	return __perf_evlist__parse_mmap_pages(opt->value, str, true);
+}
+
 /**
  * perf_evlist__mmap_ex - Create mmaps to receive events.
  * @evlist: list of events
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 7f56fdc..c5ef575 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -109,6 +109,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  bool want_signal);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
+int __perf_evlist__parse_mmap_pages(unsigned int *mmap_pages, const char *str,
+				    bool po2);
 int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
-- 
1.8.5.1

