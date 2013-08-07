Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab3HGVS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:18:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47040 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab3HGVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/47] perf evsel: Add support for enabling counters
Date: Wed,  7 Aug 2013 18:10:48 -0300
Message-Id: <1375909874-22073-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for enabling already set up counters by using an
ioctl. I share some code with the filter setup.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375490473-1503-3-git-send-email-andi@firstfloor.org
[ Fixed up 'err' variable indentation ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 21 ++++++++++++++++++---
 tools/perf/util/evsel.h |  1 +
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8f10161..960394e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -634,15 +634,15 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
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
+			    err = ioctl(fd, ioc, arg);
 
 			if (err)
 				return err;
@@ -652,6 +652,21 @@ int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
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
index 5edc625..532a5f9 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -146,6 +146,7 @@ void perf_evsel__set_sample_id(struct perf_evsel *evsel);
 
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
+int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 			     struct cpu_map *cpus);
-- 
1.8.1.4

