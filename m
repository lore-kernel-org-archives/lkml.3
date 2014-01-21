Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaAUUoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:44:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37259 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAUUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/8] perf stat: Fix memory corruption of xyarray when cpumask is used
Date: Tue, 21 Jan 2014 17:43:03 -0300
Message-Id: <1390336984-1553-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390336984-1553-1-git-send-email-acme@infradead.org>
References: <1390336984-1553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch fixes a memory corruption problem with the xyarray when the
evsel fds get closed at the end of the run_perf_stat() call.

It could be triggered with:

 # perf stat -a -e power/energy-cores/ ls

When cpumask are used by events (.e.g, RAPL or uncores) then the evsel
fds are allocated based on the actual number of CPUs monitored. That
number can be smaller than the total number of CPUs on the system.

The problem arises at the end by perf stat closes the fds twice. When
fds are closed, their entry in the xyarray are set to -1.

The first close() on the evsel is made from __run_perf_stat() and it
uses the actual number of CPUS for the event which is how the xyarray
was allocated for.

The second is from perf_evlist_close() but that one is on the total
number of CPUs in the system, so it assume the xyarray was allocated to
cover it. However it was not, and some writes corrupt memory.

The fix is in perf_evlist_close() is to first try with the evsel->cpus
if present, if not use the evlist->cpus. That fixes the problem.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389972846-6566-3-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 40bd2c04df8a..59ef2802fcf6 100644
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
-- 
1.8.1.4

