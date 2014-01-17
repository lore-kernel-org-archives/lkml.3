Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaAQPfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:35:05 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54327 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaAQPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:34:48 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        dsahern@gmail.com, Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf stat: fix memory corruption of xyarray when cpumask is used
Date: Fri, 17 Jan 2014 16:34:06 +0100
Message-Id: <1389972846-6566-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389972846-6566-1-git-send-email-eranian@google.com>
References: <1389972846-6566-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a memory corruption problem with the xyarray when
the evsel fds get closed at the end of the run_perf_stat() call.

It could be triggered with:
 # perf stat -a -e power/energy-cores/ ls

When cpumask are used by events (.e.g, RAPL or uncores) then
the evsel fds are allocated based on the actual number of CPUs
monitored. That number can be smaller than the total number of
CPUs on the system. The problem arises at the end by perf stat
closes the fds twice. When fds are closed, their entry in the
xyarray are set to -1. The first close() on the evsel is made
from __run_perf_stat() and it uses the actual number of CPUS
for the event which is how the xyarray was allocated for. The
second is from perf_evlist_close() but that one is on the
total number of CPUs in the system, so it assume the xyarray
was allocated to cover it. However it was not, and some writes
corrupt memory.

The fix is in perf_evlist_close() is to first try with the
evsel->cpus if present, if not use the evlist->cpus. That
fixes the problem.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/evlist.c |    7 +++++--
 tools/perf/util/evsel.c  |    2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 40bd2c0..59ef280 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1003,9 +1003,12 @@ void perf_evlist__close(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int ncpus = cpu_map__nr(evlist->cpus);
 	int nthreads = thread_map__nr(evlist->threads);
+	int n;
 
-	evlist__for_each_reverse(evlist, evsel)
-		perf_evsel__close(evsel, ncpus, nthreads);
+	evlist__for_each_reverse(evlist, evsel) {
+		n = evsel->cpus ? evsel->cpus->nr : ncpus;
+		perf_evsel__close(evsel, n, nthreads);
+	}
 }
 
 int perf_evlist__open(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22e18a2..0a878db 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -667,7 +667,6 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
 	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
-
 	if (evsel->fd) {
 		for (cpu = 0; cpu < ncpus; cpu++) {
 			for (thread = 0; thread < nthreads; thread++) {
@@ -1081,7 +1080,6 @@ void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 	perf_evsel__close_fd(evsel, ncpus, nthreads);
 	perf_evsel__free_fd(evsel);
-	evsel->fd = NULL;
 }
 
 static struct {
-- 
1.7.9.5

