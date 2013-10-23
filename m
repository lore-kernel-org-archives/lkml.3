Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3JWHyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:54:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3JWHyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:54:41 -0400
Date: Wed, 23 Oct 2013 00:54:21 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-04e213148c434544e3aa88d227b5375fd375738b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382099356-4918-17-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-17-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Factor out duplicated mmap code
Git-Commit-ID: 04e213148c434544e3aa88d227b5375fd375738b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:54:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04e213148c434544e3aa88d227b5375fd375738b
Gitweb:     http://git.kernel.org/tip/04e213148c434544e3aa88d227b5375fd375738b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 18 Oct 2013 15:29:13 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 11:19:43 -0300

perf evlist: Factor out duplicated mmap code

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
index acef94a..85c4c80 100644
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
