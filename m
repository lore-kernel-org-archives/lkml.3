Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaHKIvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaHKIvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 20/20] perf tools: Remove pollfd stuff out of evlist object
Date: Mon, 11 Aug 2014 10:50:14 +0200
Message-Id: <1407747014-18394-21-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for evlist->pollfd data anymore.
All the perf events polling job is now done poller
object.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evlist.c | 22 ----------------------
 tools/perf/util/evlist.h |  4 ----
 2 files changed, 26 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a4c381c10c72..3cd5b711b762 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -102,7 +102,6 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 void perf_evlist__exit(struct perf_evlist *evlist)
 {
 	zfree(&evlist->mmap);
-	zfree(&evlist->pollfd);
 }
 
 void perf_evlist__delete(struct perf_evlist *evlist)
@@ -339,23 +338,6 @@ int perf_evlist__enable_event(struct perf_evlist *evlist,
 	return 0;
 }
 
-static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
-{
-	int nr_cpus = cpu_map__nr(evlist->cpus);
-	int nr_threads = thread_map__nr(evlist->threads);
-	int nfds = nr_cpus * nr_threads * evlist->nr_entries;
-	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
-	return evlist->pollfd != NULL ? 0 : -ENOMEM;
-}
-
-void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
-{
-	fcntl(fd, F_SETFL, O_NONBLOCK);
-	evlist->pollfd[evlist->nr_fds].fd = fd;
-	evlist->pollfd[evlist->nr_fds].events = POLLIN;
-	evlist->nr_fds++;
-}
-
 static void perf_evlist__id_hash(struct perf_evlist *evlist,
 				 struct perf_evsel *evsel,
 				 int cpu, int thread, u64 id)
@@ -625,7 +607,6 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 		return -1;
 	}
 
-	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
 
@@ -804,9 +785,6 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
 
-	if (evlist->pollfd == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
-		return -ENOMEM;
-
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
 	pr_debug("mmap size %zuB\n", evlist->mmap_len);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 7d03af1ce4f7..d9a55e79f8bb 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -9,7 +9,6 @@
 #include "util.h"
 #include <unistd.h>
 
-struct pollfd;
 struct thread_map;
 struct cpu_map;
 struct record_opts;
@@ -41,7 +40,6 @@ struct perf_evlist {
 	} workload;
 	bool		 overwrite;
 	struct perf_mmap *mmap;
-	struct pollfd	 *pollfd;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
 	struct perf_evsel *selected;
@@ -83,8 +81,6 @@ perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
-void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
-
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
-- 
1.8.3.1

