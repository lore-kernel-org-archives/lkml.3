Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaIYV7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:59:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:44130 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbaIYV7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:59:00 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/14] perf evlist: Unmap when all refcounts to fd are gone and events drained
Date: Thu, 25 Sep 2014 18:57:49 -0300
Message-Id: <1411682271-3771-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411682271-3771-1-git-send-email-acme@kernel.org>
References: <1411682271-3771-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As noticed by receiving a POLLHUP for all its pollfd entries.

That will remove the refcount taken in perf_evlist__mmap_per_evsel(),
and when all events are consumed via perf_evlist__mmap_read() +
perf_evlist__mmap_consume(), the ring buffer will be unmap'ed.

Thanks to Jiri Olsa for pointing out that we must wait till all events
are consumed, not being ok to unmmap just when receiving all the
POLLHUPs.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-t10w1xk4myp7ca7m9fvip6a0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 61d18dc83e8e..3cebc9a8d52e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -25,11 +25,12 @@
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
+static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
+static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
+
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
-static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
-
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
 {
@@ -426,16 +427,38 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int __perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd, int idx)
+{
+	int pos = fdarray__add(&evlist->pollfd, fd, POLLIN | POLLERR | POLLHUP);
+	/*
+	 * Save the idx so that when we filter out fds POLLHUP'ed we can
+	 * close the associated evlist->mmap[] entry.
+	 */
+	if (pos >= 0) {
+		evlist->pollfd.priv[pos].idx = idx;
+
+		fcntl(fd, F_SETFL, O_NONBLOCK);
+	}
+
+	return pos;
+}
+
 int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 {
-	fcntl(fd, F_SETFL, O_NONBLOCK);
+	return __perf_evlist__add_pollfd(evlist, fd, -1);
+}
+
+static void perf_evlist__munmap_filtered(struct fdarray *fda, int fd)
+{
+	struct perf_evlist *evlist = container_of(fda, struct perf_evlist, pollfd);
 
-	return fdarray__add(&evlist->pollfd, fd, POLLIN | POLLERR | POLLHUP);
+	perf_evlist__mmap_put(evlist, fda->priv[fd].idx);
 }
 
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
 {
-	return fdarray__filter(&evlist->pollfd, revents_and_mask, NULL);
+	return fdarray__filter(&evlist->pollfd, revents_and_mask,
+			       perf_evlist__munmap_filtered);
 }
 
 int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
@@ -777,7 +800,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 			perf_evlist__mmap_get(evlist, idx);
 		}
 
-		if (perf_evlist__add_pollfd(evlist, fd) < 0) {
+		if (__perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
 			perf_evlist__mmap_put(evlist, idx);
 			return -1;
 		}
-- 
1.9.3

