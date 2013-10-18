Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3JRMbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:31:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:2346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab3JRMbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936620"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/19] perf tools: factor out duplicated evlist mmap code
Date: Fri, 18 Oct 2013 15:29:13 +0300
Message-Id: <1382099356-4918-17-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same code is used in perf_evlist__mmap_per_cpu()
and perf_evlist__mmap_per_thread().  Factor it out
into a separate function perf_evlist__mmap_per_evsel().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 73 ++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a4529af..18784dc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,9 +609,36 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 	return 0;
 }
 
-static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
+				       int prot, int mask, int cpu, int thread,
+				       int *output)
 {
 	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		int fd = FD(evsel, cpu, thread);
+
+		if (*output == -1) {
+			*output = fd;
+			if (__perf_evlist__mmap(evlist, idx, prot, mask,
+						*output) < 0)
+				return -1;
+		} else {
+			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
+				return -1;
+		}
+
+		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot,
+				     int mask)
+{
 	int cpu, thread;
 	int nr_cpus = cpu_map__nr(evlist->cpus);
 	int nr_threads = thread_map__nr(evlist->threads);
@@ -621,23 +648,9 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 		int output = -1;
 
 		for (thread = 0; thread < nr_threads; thread++) {
-			list_for_each_entry(evsel, &evlist->entries, node) {
-				int fd = FD(evsel, cpu, thread);
-
-				if (output == -1) {
-					output = fd;
-					if (__perf_evlist__mmap(evlist, cpu,
-								prot, mask, output) < 0)
-						goto out_unmap;
-				} else {
-					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
-						goto out_unmap;
-				}
-
-				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-				    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
-					goto out_unmap;
-			}
+			if (perf_evlist__mmap_per_evsel(evlist, cpu, prot, mask,
+							cpu, thread, &output))
+				goto out_unmap;
 		}
 	}
 
@@ -649,9 +662,9 @@ out_unmap:
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
+					int mask)
 {
-	struct perf_evsel *evsel;
 	int thread;
 	int nr_threads = thread_map__nr(evlist->threads);
 
@@ -659,23 +672,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
-		list_for_each_entry(evsel, &evlist->entries, node) {
-			int fd = FD(evsel, 0, thread);
-
-			if (output == -1) {
-				output = fd;
-				if (__perf_evlist__mmap(evlist, thread,
-							prot, mask, output) < 0)
-					goto out_unmap;
-			} else {
-				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
-					goto out_unmap;
-			}
-
-			if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-			    perf_evlist__id_add_fd(evlist, evsel, 0, thread, fd) < 0)
-				goto out_unmap;
-		}
+		if (perf_evlist__mmap_per_evsel(evlist, thread, prot, mask, 0,
+						thread, &output))
+			goto out_unmap;
 	}
 
 	return 0;
-- 
1.7.11.7

