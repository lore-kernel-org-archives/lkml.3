Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaLXHX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:23:27 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39567 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaLXHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:52 -0500
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
Subject: [PATCH 06/37] perf tools: Introduce perf_evlist__mmap_multi()
Date: Wed, 24 Dec 2014 16:15:02 +0900
Message-Id: <1419405333-27952-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_evlist__mmap_multi function creates data mmaps and optionally
tracking mmaps for events.  It'll be used for perf record to save
tracking events in a separate files.  Checking dummy tracking event in
perf_evlist__mmap() alone is not enough as users can specify the dummy
event at first (like in keep tracking testcase) without the multi-file
option.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c |  3 ++-
 tools/perf/util/evlist.c    | 11 +++++++----
 tools/perf/util/evlist.h    | 10 ++++++++--
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 129fab35fdc5..8c91f25b81f6 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -169,7 +169,8 @@ static int record__open(struct record *rec)
 		goto out;
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap_multi(evlist, opts->mmap_pages, false,
+				    opts->multi_file) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d99343b988fe..010188939104 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -841,6 +841,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist, bool track_mmap)
 
 struct mmap_params {
 	int	prot;
+	bool	track;
 	size_t	len;
 };
 
@@ -889,7 +890,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 
 		fd = FD(evsel, cpu, thread);
 
-		if (perf_evsel__is_dummy_tracking(evsel)) {
+		if (mp->track && perf_evsel__is_dummy_tracking(evsel)) {
 			struct mmap_params track_mp = {
 				.prot	= mp->prot,
 				.len	= TRACK_MMAP_SIZE,
@@ -1068,10 +1069,11 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 }
 
 /**
- * perf_evlist__mmap - Create mmaps to receive events.
+ * perf_evlist__mmap_multi - Create mmaps to receive events.
  * @evlist: list of events
  * @pages: map length in pages
  * @overwrite: overwrite older events?
+ * @use_track_mmap: use another mmaps to track meta events
  *
  * If @overwrite is %false the user needs to signal event consumption using
  * perf_mmap__write_tail().  Using perf_evlist__mmap_read() does this
@@ -1079,14 +1081,15 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
  *
  * Return: %0 on success, negative error code otherwise.
  */
-int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-		      bool overwrite)
+int perf_evlist__mmap_multi(struct perf_evlist *evlist, unsigned int pages,
+			    bool overwrite, bool use_track_mmap)
 {
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
 	struct mmap_params mp = {
 		.prot = PROT_READ | (overwrite ? 0 : PROT_WRITE),
+		.track = use_track_mmap,
 	};
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist, use_track_mmap) < 0)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b7f54b8577f7..65c1aea6a3a4 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -127,10 +127,16 @@ int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
 
-int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-		      bool overwrite);
+int perf_evlist__mmap_multi(struct perf_evlist *evlist, unsigned int pages,
+			    bool overwrite, bool use_track_mmap);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
+static inline int perf_evlist__mmap(struct perf_evlist *evlist,
+				    unsigned int pages, bool overwrite)
+{
+	return perf_evlist__mmap_multi(evlist, pages, overwrite, false);
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist);
 void perf_evlist__enable(struct perf_evlist *evlist);
 
-- 
2.1.3

