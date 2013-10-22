Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3JVO3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:29:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53876 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3JVO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/26] perf evlist: Factor out duplicated mmap code
Date: Tue, 22 Oct 2013 11:28:25 -0300
Message-Id: <1382452114-1243-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The same code is used in perf_evlist__mmap_per_cpu() and
perf_evlist__mmap_per_thread().

Factor it out into a separate function perf_evlist__mmap_per_evsel().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382099356-4918-17-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 73 ++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index acef94a5ff9e..85c4c80bcac8 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -608,9 +608,36 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
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
@@ -620,23 +647,9 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
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
 
@@ -648,9 +661,9 @@ out_unmap:
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, int mask)
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
+					int mask)
 {
-	struct perf_evsel *evsel;
 	int thread;
 	int nr_threads = thread_map__nr(evlist->threads);
 
@@ -658,23 +671,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
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
1.8.1.4

