Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965875Ab3GSHug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:50:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965829Ab3GSHua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:30 -0400
Date: Fri, 19 Jul 2013 00:49:53 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-93edcbd91d888c7530c7fc749176fc935b8e2287@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1372944040-32690-8-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Tidy duplicated munmap code
Git-Commit-ID: 93edcbd91d888c7530c7fc749176fc935b8e2287
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:49:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93edcbd91d888c7530c7fc749176fc935b8e2287
Gitweb:     http://git.kernel.org/tip/93edcbd91d888c7530c7fc749176fc935b8e2287
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 4 Jul 2013 16:20:26 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:54 -0300

perf evlist: Tidy duplicated munmap code

The same lines of code are used in three places.  Make it a new function
'__perf_evlist__munmap()'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372944040-32690-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d8f34e0..42ea4e9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -403,16 +403,20 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 	return event;
 }
 
+static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
+{
+	if (evlist->mmap[idx].base != NULL) {
+		munmap(evlist->mmap[idx].base, evlist->mmap_len);
+		evlist->mmap[idx].base = NULL;
+	}
+}
+
 void perf_evlist__munmap(struct perf_evlist *evlist)
 {
 	int i;
 
-	for (i = 0; i < evlist->nr_mmaps; i++) {
-		if (evlist->mmap[i].base != NULL) {
-			munmap(evlist->mmap[i].base, evlist->mmap_len);
-			evlist->mmap[i].base = NULL;
-		}
-	}
+	for (i = 0; i < evlist->nr_mmaps; i++)
+		__perf_evlist__munmap(evlist, i);
 
 	free(evlist->mmap);
 	evlist->mmap = NULL;
@@ -477,12 +481,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	return 0;
 
 out_unmap:
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
-		}
-	}
+	for (cpu = 0; cpu < nr_cpus; cpu++)
+		__perf_evlist__munmap(evlist, cpu);
 	return -1;
 }
 
@@ -517,12 +517,8 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 	return 0;
 
 out_unmap:
-	for (thread = 0; thread < nr_threads; thread++) {
-		if (evlist->mmap[thread].base != NULL) {
-			munmap(evlist->mmap[thread].base, evlist->mmap_len);
-			evlist->mmap[thread].base = NULL;
-		}
-	}
+	for (thread = 0; thread < nr_threads; thread++)
+		__perf_evlist__munmap(evlist, thread);
 	return -1;
 }
 
