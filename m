Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3K2Lqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:46:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab3K2Lp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:45:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/6] perf tools: Add PERF_EVLIST__ERRNO_MMAP internal error
Date: Fri, 29 Nov 2013 12:45:06 +0100
Message-Id: <1385725510-20118-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding internal error (PERF_EVLIST__ERRNO_MMAP) for case
when 'mmap' syscall fails.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 tools/perf/util/evlist.c | 28 ++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dfb72d4..d156f0a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -605,6 +605,28 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
+static void strerror_mmap(struct perf_evlist *evlist,
+			  char *buf, size_t size)
+{
+	int err_libc = evlist->err_libc;
+
+	switch (evlist->err_libc) {
+	case EPERM:
+		scnprintf(buf, size,
+			"Permission error mapping pages.\n"
+			"Consider increasing "
+			"/proc/sys/kernel/perf_event_mlock_kb,\n"
+			"or try again with a smaller value of -m/--mmap_pages.\n"
+			"(current size: %dB)\n", evlist->mmap_len);
+		break;
+	default:
+		scnprintf(buf, size,
+			"Failed to mmap events with error %d (%s)\n",
+			err_libc, strerror(err_libc));
+		break;
+	}
+}
+
 static void __perf_evlist__strerror(struct perf_evlist *evlist,
 				    char *buf, size_t size)
 {
@@ -614,6 +636,9 @@ static void __perf_evlist__strerror(struct perf_evlist *evlist,
 	switch (err) {
 	case PERF_EVLIST__ERRNO_SUCCESS:
 		break;
+	case PERF_EVLIST__ERRNO_MMAP:
+		strerror_mmap(evlist, buf, size);
+		return;
 	default:
 		scnprintf(buf, size, "Unknown error\n");
 		return;
@@ -642,6 +667,7 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 				      MAP_SHARED, fd, 0);
 
 	if (evlist->mmap[idx].base == MAP_FAILED) {
+		SET_ERR(MMAP);
 		pr_debug2("failed to mmap perf event ring buffer, error %d\n",
 			  errno);
 		evlist->mmap[idx].base = NULL;
@@ -821,6 +847,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	const struct thread_map *threads = evlist->threads;
 	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
 
+	SET_ERR(SUCCESS);
+
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9832fbd..02df99a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -19,6 +19,7 @@ struct perf_record_opts;
 
 enum {
 	PERF_EVLIST__ERRNO_SUCCESS		= 0,
+	PERF_EVLIST__ERRNO_MMAP			= 1,
 };
 
 struct perf_mmap {
-- 
1.8.3.1

