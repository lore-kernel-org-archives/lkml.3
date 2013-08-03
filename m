Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3HCAlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:41:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:62037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3HCAlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:41:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="356565989"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: eranian@google.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] tools, perf: Add support to evsel for enabling counters
Date: Fri,  2 Aug 2013 17:41:10 -0700
Message-Id: <1375490473-1503-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for enabling already set up counters by using an
ioctl. I share some code with the filter setup.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/evsel.c | 21 ++++++++++++++++++---
 tools/perf/util/evsel.h |  1 +
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c9c7494..60e0d84 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -605,16 +605,16 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return evsel->fd != NULL ? 0 : -ENOMEM;
 }
 
-int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
-			   const char *filter)
+static int perf_evsel__run_ioctl(struct perf_evsel *evsel, int ncpus, int nthreads,
+			  int ioc,  void *arg)
 {
 	int cpu, thread;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
 		for (thread = 0; thread < nthreads; thread++) {
 			int fd = FD(evsel, cpu, thread),
-			    err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
 
+			err = ioctl(fd, ioc, arg);
 			if (err)
 				return err;
 		}
@@ -623,6 +623,21 @@ int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 	return 0;
 }
 
+int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
+			   const char *filter)
+{
+	return perf_evsel__run_ioctl(evsel, ncpus, nthreads,
+				     PERF_EVENT_IOC_SET_FILTER,
+				     (void *)filter);
+}
+
+int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	return perf_evsel__run_ioctl(evsel, ncpus, nthreads,
+				     PERF_EVENT_IOC_ENABLE,
+				     0);
+}
+
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	evsel->sample_id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3f156cc..b057e9c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -142,6 +142,7 @@ void perf_evsel__set_sample_id(struct perf_evsel *evsel);
 
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
+int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 			     struct cpu_map *cpus);
-- 
1.8.3.1

