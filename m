Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaIZJW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:22:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaIZJWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:22:23 -0400
Date: Fri, 26 Sep 2014 02:22:01 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-t10w1xk4myp7ca7m9fvip6a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, bp@suse.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Unmap when all refcounts to fd are gone and events drained
Git-Commit-ID: e4b356b56cfe77b800a9bc2e6efefa6a069b8a78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4b356b56cfe77b800a9bc2e6efefa6a069b8a78
Gitweb:     http://git.kernel.org/tip/e4b356b56cfe77b800a9bc2e6efefa6a069b8a78
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 8 Sep 2014 11:27:49 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:55 -0300

perf evlist: Unmap when all refcounts to fd are gone and events drained

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
index 61d18dc..3cebc9a 100644
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
