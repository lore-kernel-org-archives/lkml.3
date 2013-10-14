Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3JNUUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39018 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 085/161] perf tools: Check mmap pages value early
Date: Mon, 14 Oct 2013 17:01:14 -0300
Message-Id: <1381780950-25642-86-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Move the check of the mmap_pages value to the options parsing time, so
we could rely on this value on other parts of code.

Related changes come in the next patches.

Also changes perf_evlist::mmap_len to proper size_t type.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378031796-17892-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c    |  5 +++--
 tools/perf/builtin-record.c |  9 +++------
 tools/perf/builtin-top.c    |  5 +++--
 tools/perf/builtin-trace.c  |  5 +++--
 tools/perf/util/evlist.c    | 46 ++++++++++++++++++++++++++++++++++++---------
 tools/perf/util/evlist.h    |  6 +++++-
 6 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 935d52216c89..cfa0b7979914 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1426,8 +1426,9 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	const struct option live_options[] = {
 		OPT_STRING('p', "pid", &kvm->opts.target.pid, "pid",
 			"record events on existing process id"),
-		OPT_UINTEGER('m', "mmap-pages", &kvm->opts.mmap_pages,
-			"number of mmap data pages"),
+		OPT_CALLBACK('m', "mmap-pages", &kvm->opts.mmap_pages, "pages",
+			"number of mmap data pages",
+			perf_evlist__parse_mmap_pages),
 		OPT_INCR('v', "verbose", &verbose,
 			"be more verbose (show counter open errors, etc)"),
 		OPT_BOOLEAN('a', "all-cpus", &kvm->opts.target.system_wide,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0aacd6295fe6..92ca5419073b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -233,10 +233,6 @@ try_again:
 			       "or try again with a smaller value of -m/--mmap_pages.\n"
 			       "(current value: %d)\n", opts->mmap_pages);
 			rc = -errno;
-		} else if (!is_power_of_2(opts->mmap_pages) &&
-			   (opts->mmap_pages != UINT_MAX)) {
-			pr_err("--mmap_pages/-m value must be a power of two.");
-			rc = -EINVAL;
 		} else {
 			pr_err("failed to mmap with %d (%s)\n", errno, strerror(errno));
 			rc = -errno;
@@ -854,8 +850,9 @@ const struct option record_options[] = {
 	OPT_BOOLEAN('i', "no-inherit", &record.opts.no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
-	OPT_UINTEGER('m', "mmap-pages", &record.opts.mmap_pages,
-		     "number of mmap data pages"),
+	OPT_CALLBACK('m', "mmap-pages", &record.opts.mmap_pages, "pages",
+		     "number of mmap data pages",
+		     perf_evlist__parse_mmap_pages),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b3e0229ee38f..e8466956adbe 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1075,8 +1075,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
-	OPT_UINTEGER('m', "mmap-pages", &opts->mmap_pages,
-		     "number of mmap data pages"),
+	OPT_CALLBACK('m', "mmap-pages", &opts->mmap_pages, "pages",
+		     "number of mmap data pages",
+		     perf_evlist__parse_mmap_pages),
 	OPT_INTEGER('r', "realtime", &top.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_INTEGER('d', "delay", &top.delay_secs,
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index be658433d3bb..f3ddbb008fb4 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1528,8 +1528,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "list of cpus to monitor"),
 	OPT_BOOLEAN(0, "no-inherit", &trace.opts.no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_UINTEGER('m', "mmap-pages", &trace.opts.mmap_pages,
-		     "number of mmap data pages"),
+	OPT_CALLBACK('m', "mmap-pages", &trace.opts.mmap_pages, "pages",
+		     "number of mmap data pages",
+		     perf_evlist__parse_mmap_pages),
 	OPT_STRING('u', "uid", &trace.opts.target.uid_str, "user",
 		   "user to profile"),
 	OPT_CALLBACK(0, "duration", &trace, "float",
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f9f77bee0b1b..4283f49ca0ab 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -18,6 +18,7 @@
 #include <unistd.h>
 
 #include "parse-events.h"
+#include "parse-options.h"
 
 #include <sys/mman.h>
 
@@ -672,6 +673,40 @@ out_unmap:
 	return -1;
 }
 
+static size_t perf_evlist__mmap_size(unsigned long pages)
+{
+	/* 512 kiB: default amount of unprivileged mlocked memory */
+	if (pages == UINT_MAX)
+		pages = (512 * 1024) / page_size;
+	else if (!is_power_of_2(pages))
+		return 0;
+
+	return (pages + 1) * page_size;
+}
+
+int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
+				  int unset __maybe_unused)
+{
+	unsigned int pages, *mmap_pages = opt->value;
+	size_t size;
+	char *eptr;
+
+	pages = strtoul(str, &eptr, 10);
+	if (*eptr != '\0') {
+		pr_err("failed to parse --mmap_pages/-m value\n");
+		return -1;
+	}
+
+	size = perf_evlist__mmap_size(pages);
+	if (!size) {
+		pr_err("--mmap_pages/-m value must be a power of two.");
+		return -1;
+	}
+
+	*mmap_pages = pages;
+	return 0;
+}
+
 /** perf_evlist__mmap - Create per cpu maps to receive events
  *
  * @evlist - list of events
@@ -695,14 +730,6 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	const struct thread_map *threads = evlist->threads;
 	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
 
-        /* 512 kiB: default amount of unprivileged mlocked memory */
-        if (pages == UINT_MAX)
-                pages = (512 * 1024) / page_size;
-	else if (!is_power_of_2(pages))
-		return -EINVAL;
-
-	mask = pages * page_size - 1;
-
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
 
@@ -710,7 +737,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		return -ENOMEM;
 
 	evlist->overwrite = overwrite;
-	evlist->mmap_len = (pages + 1) * page_size;
+	evlist->mmap_len = perf_evlist__mmap_size(pages);
+	mask = evlist->mmap_len - page_size - 1;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 880d7139d2fb..4edb5008fd36 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -31,7 +31,7 @@ struct perf_evlist {
 	int		 nr_groups;
 	int		 nr_fds;
 	int		 nr_mmaps;
-	int		 mmap_len;
+	size_t		 mmap_len;
 	int		 id_pos;
 	int		 is_pos;
 	u64		 combined_sample_type;
@@ -103,6 +103,10 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  bool want_signal);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
+int perf_evlist__parse_mmap_pages(const struct option *opt,
+				  const char *str,
+				  int unset);
+
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		      bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
-- 
1.8.1.4

