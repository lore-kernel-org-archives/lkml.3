Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaKKOTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:19:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbaKKOTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:19:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151771"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/25] perf record: Extend -m option for Instruction Tracing mmap pages
Date: Tue, 11 Nov 2014 16:16:47 +0200
Message-Id: <1415715423-15563-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the -m option so that the number
of mmap pages for Instruction Tracing
can be specified.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt |  2 ++
 tools/perf/builtin-record.c              | 49 ++++++++++++++++++++++++++++++--
 tools/perf/util/evlist.c                 | 10 +++++--
 tools/perf/util/evlist.h                 |  1 +
 4 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 398f8d5..fe1c471 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -91,6 +91,8 @@ OPTIONS
 	Number of mmap data pages (must be a power of two) or size
 	specification with appended unit character - B/K/M/G. The
 	size is rounded up to have nearest pages power of two value.
+	Also, by adding a comma, the number of mmap pages for Instruction
+	Tracing can be specified.
 
 -g::
 	Enables call-graph (stack chain/backtrace) recording.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 783b5ba..1e65d38 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -751,6 +751,49 @@ static int perf_record_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static int record__parse_mmap_pages(const struct option *opt,
+				    const char *str,
+				    int unset __maybe_unused)
+{
+	struct record_opts *opts = opt->value;
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
+		ret = __perf_evlist__parse_mmap_pages(&mmap_pages, s);
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
+	ret = __perf_evlist__parse_mmap_pages(&mmap_pages, p + 1);
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
 static const char * const __record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -824,9 +867,9 @@ struct option __record_options[] = {
 			&record.opts.no_inherit_set,
 			"child tasks do not inherit counters"),
 	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
-	OPT_CALLBACK('m', "mmap-pages", &record.opts.mmap_pages, "pages",
-		     "number of mmap data pages",
-		     perf_evlist__parse_mmap_pages),
+	OPT_CALLBACK('m', "mmap-pages", &record.opts, "pages[,pages]",
+		     "number of mmap data pages and instruction tracing mmap pages",
+		     record__parse_mmap_pages),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
 	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2ee7f46..27d4de3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -984,10 +984,8 @@ static long parse_pages_arg(const char *str, unsigned long min,
 	return pages;
 }
 
-int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
-				  int unset __maybe_unused)
+int __perf_evlist__parse_mmap_pages(unsigned int *mmap_pages, const char *str)
 {
-	unsigned int *mmap_pages = opt->value;
 	unsigned long max = UINT_MAX;
 	long pages;
 
@@ -1004,6 +1002,12 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	return 0;
 }
 
+int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
+				  int unset __maybe_unused)
+{
+	return __perf_evlist__parse_mmap_pages(opt->value, str);
+}
+
 /**
  * perf_evlist__mmap_ex - Create mmaps to receive events.
  * @evlist: list of events
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f19d89c..fcf2975c 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -121,6 +121,7 @@ int perf_evlist__start_workload(struct perf_evlist *evlist);
 
 struct option;
 
+int __perf_evlist__parse_mmap_pages(unsigned int *mmap_pages, const char *str);
 int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
-- 
1.9.1

