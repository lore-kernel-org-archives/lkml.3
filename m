Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3HLKUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:20:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3HLKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:20:15 -0400
Date: Mon, 12 Aug 2013 03:19:57 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-e2407bef968d64a28465561832686636d3380bf9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1375490473-1503-3-git-send-email-andi@firstfloor.org>
References: <1375490473-1503-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Add support for enabling counters
Git-Commit-ID: e2407bef968d64a28465561832686636d3380bf9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:20:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2407bef968d64a28465561832686636d3380bf9
Gitweb:     http://git.kernel.org/tip/e2407bef968d64a28465561832686636d3380bf9
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 2 Aug 2013 17:41:10 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:28 -0300

perf evsel: Add support for enabling counters

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
