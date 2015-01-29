Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbbA2IUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:20:30 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51126 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbA2IKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:04 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/42] perf tools: Introduce perf_evlist__mmap_track()
Date: Thu, 29 Jan 2015 17:06:52 +0900
Message-Id: <1422518843-25818-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_evlist__mmap_track function creates data mmaps and optionally
tracking mmaps for events.  It'll be used for perf record to save events
in a separate files and build an index table.  Checking dummy tracking
event in perf_evlist__mmap() alone is not enough as users can specify a
dummy event (like in keep tracking testcase) without the index option.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c |  3 ++-
 tools/perf/util/evlist.c    | 15 +++++++++------
 tools/perf/util/evlist.h    | 10 ++++++++--
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index adb3eefb51ed..56118d8cf74a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -169,7 +169,8 @@ static int record__open(struct record *rec)
 		goto out;
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap_track(evlist, opts->mmap_pages, false,
+				    false) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ac31edecffaf..fb27b468427d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -835,6 +835,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist, bool track_mmap)
 
 struct mmap_params {
 	int	prot;
+	bool	track;
 	size_t	len;
 };
 
@@ -884,7 +885,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 
 		fd = FD(evsel, cpu, thread);
 
-		if (perf_evsel__is_dummy_tracking(evsel)) {
+		if (mp->track && perf_evsel__is_dummy_tracking(evsel)) {
 			struct mmap_params track_mp = {
 				.prot	= mp->prot,
 				.len	= TRACK_MMAP_SIZE,
@@ -937,7 +938,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 						 thread);
 		}
 
-		if (perf_evsel__is_dummy_tracking(evsel)) {
+		if (mp->track && perf_evsel__is_dummy_tracking(evsel)) {
 			/* restore idx as normal idx (positive) */
 			idx = track_mmap_idx(idx);
 		}
@@ -1088,10 +1089,11 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 }
 
 /**
- * perf_evlist__mmap - Create mmaps to receive events.
+ * perf_evlist__mmap_track - Create mmaps to receive events.
  * @evlist: list of events
  * @pages: map length in pages
  * @overwrite: overwrite older events?
+ * @use_track_mmap: use another mmaps to track meta events
  *
  * If @overwrite is %false the user needs to signal event consumption using
  * perf_mmap__write_tail().  Using perf_evlist__mmap_read() does this
@@ -1099,17 +1101,18 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
  *
  * Return: %0 on success, negative error code otherwise.
  */
-int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-		      bool overwrite)
+int perf_evlist__mmap_track(struct perf_evlist *evlist, unsigned int pages,
+			    bool overwrite, bool use_track_mmap)
 {
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
 	struct mmap_params mp = {
 		.prot = PROT_READ | (overwrite ? 0 : PROT_WRITE),
+		.track = use_track_mmap,
 	};
 
-	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist, true) < 0)
+	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist, mp.track) < 0)
 		return -ENOMEM;
 
 	if (evlist->pollfd.entries == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index bf697632458d..c3b7b3428cbb 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -127,10 +127,16 @@ int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
 
-int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
-		      bool overwrite);
+int perf_evlist__mmap_track(struct perf_evlist *evlist, unsigned int pages,
+			    bool overwrite, bool use_track_mmap);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
+static inline int perf_evlist__mmap(struct perf_evlist *evlist,
+				    unsigned int pages, bool overwrite)
+{
+	return perf_evlist__mmap_track(evlist, pages, overwrite, false);
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist);
 void perf_evlist__enable(struct perf_evlist *evlist);
 
-- 
2.2.2

