Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaIJOK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:10:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:38766 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaIJOKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:55 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/14] perf evlist: Unmap ring buffer when fd is nuked
Date: Wed, 10 Sep 2014 11:08:49 -0300
Message-Id: <1410358129-9965-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As noticed by receiving a POLLHUP for its pollfd entry.

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
Link: http://lkml.kernel.org/n/tip-4p3ledwt3ra9ak8e5yu3y928@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6d2499cfd789..fdb755f6e299 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -25,6 +25,8 @@
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
+static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
+
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
@@ -424,14 +426,35 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int __perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd, int idx)
+{
+	int pos = fdarray__add(&evlist->pollfd, fd, POLLIN | POLLERR | POLLHUP);
+	/*
+	 * Save the idx so that when we filter out fds POLLHUP'ed we can
+	 * close the associated evlist->mmap[] entry.
+	 */
+	if (pos >= 0)
+		evlist->pollfd.priv[pos] = idx;
+
+	return pos;
+}
+
 int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 {
-	return fdarray__add(&evlist->pollfd, fd, POLLIN | POLLERR | POLLHUP);
+	return __perf_evlist__add_pollfd(evlist, fd, -1);
+}
+
+static void perf_evlist__munmap_filtered(struct fdarray *fda, int fd)
+{
+	struct perf_evlist *evlist = container_of(fda, struct perf_evlist, pollfd);
+
+	perf_evlist__mmap_put(evlist, fda->priv[fd]);
 }
 
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
 {
-	return fdarray__filter(&evlist->pollfd, revents_and_mask, NULL);
+	return fdarray__filter(&evlist->pollfd, revents_and_mask,
+			       perf_evlist__munmap_filtered);
 }
 
 int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
@@ -751,7 +774,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 			perf_evlist__mmap_get(evlist, idx);
 		}
 
-		if (perf_evlist__add_pollfd(evlist, fd) < 0) {
+		if (__perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
 			perf_evlist__mmap_put(evlist, idx);
 			return -1;
 		}
-- 
1.9.3

