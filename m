Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab3JOFZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:25:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3JOFZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:25:19 -0400
Date: Mon, 14 Oct 2013 22:24:55 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-994a1f78b191df0c9d6caca3f3afb03e247aff26@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1378031796-17892-2-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Check mmap pages value early
Git-Commit-ID: 994a1f78b191df0c9d6caca3f3afb03e247aff26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:25:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  994a1f78b191df0c9d6caca3f3afb03e247aff26
Gitweb:     http://git.kernel.org/tip/994a1f78b191df0c9d6caca3f3afb03e247aff26
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 1 Sep 2013 12:36:12 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:24:10 -0300

perf tools: Check mmap pages value early

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
index 935d522..cfa0b79 100644
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
index 0aacd62..92ca541 100644
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
index b3e0229..e846695 100644
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
index be65843..f3ddbb0 100644
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
index f9f77be..4283f49 100644
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
index 880d713..4edb500 100644
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
