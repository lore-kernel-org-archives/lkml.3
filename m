Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaIYV6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:58:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:44085 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaIYV6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:58:52 -0400
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
Subject: [PATCH 10/14] perf evlist: Refcount mmaps
Date: Thu, 25 Sep 2014 18:57:47 -0300
Message-Id: <1411682271-3771-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411682271-3771-1-git-send-email-acme@kernel.org>
References: <1411682271-3771-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need to know how many fds are using a perf mmap via
PERF_EVENT_IOC_SET_OUTPUT, so that we can know when to ditch an mmap,
refcount it.

v2: Automatically unmap it when the refcount hits one, which will happen
when all fds are filtered by perf_evlist__filter_pollfd(), in later
patches.

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
Link: http://lkml.kernel.org/r/20140908153824.GG2773@kernel.org
Link: http://lkml.kernel.org/n/tip-cpv7v2lw0g74ucmxa39xdpms@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evlist.h |  6 ++++++
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 398dab1a08cc..efddee5a23e9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -28,6 +28,8 @@
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
+static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
+
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
 {
@@ -651,14 +653,36 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 	return event;
 }
 
+static bool perf_mmap__empty(struct perf_mmap *md)
+{
+	return perf_mmap__read_head(md) != md->prev;
+}
+
+static void perf_evlist__mmap_get(struct perf_evlist *evlist, int idx)
+{
+	++evlist->mmap[idx].refcnt;
+}
+
+static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx)
+{
+	BUG_ON(evlist->mmap[idx].refcnt == 0);
+
+	if (--evlist->mmap[idx].refcnt == 0)
+		__perf_evlist__munmap(evlist, idx);
+}
+
 void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx)
 {
+	struct perf_mmap *md = &evlist->mmap[idx];
+
 	if (!evlist->overwrite) {
-		struct perf_mmap *md = &evlist->mmap[idx];
 		unsigned int old = md->prev;
 
 		perf_mmap__write_tail(md, old);
 	}
+
+	if (md->refcnt == 1 && perf_mmap__empty(md))
+		perf_evlist__mmap_put(evlist, idx);
 }
 
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
@@ -666,6 +690,7 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
 	if (evlist->mmap[idx].base != NULL) {
 		munmap(evlist->mmap[idx].base, evlist->mmap_len);
 		evlist->mmap[idx].base = NULL;
+		evlist->mmap[idx].refcnt = 0;
 	}
 }
 
@@ -699,6 +724,20 @@ struct mmap_params {
 static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 			       struct mmap_params *mp, int fd)
 {
+	/*
+	 * The last one will be done at perf_evlist__mmap_consume(), so that we
+	 * make sure we don't prevent tools from consuming every last event in
+	 * the ring buffer.
+	 *
+	 * I.e. we can get the POLLHUP meaning that the fd doesn't exist
+	 * anymore, but the last events for it are still in the ring buffer,
+	 * waiting to be consumed.
+	 *
+	 * Tools can chose to ignore this at their own discretion, but the
+	 * evlist layer can't just drop it when filtering events in
+	 * perf_evlist__filter_pollfd().
+	 */
+	evlist->mmap[idx].refcnt = 2;
 	evlist->mmap[idx].prev = 0;
 	evlist->mmap[idx].mask = mp->mask;
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, mp->prot,
@@ -734,10 +773,14 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 		} else {
 			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
 				return -1;
+
+			perf_evlist__mmap_get(evlist, idx);
 		}
 
-		if (perf_evlist__add_pollfd(evlist, fd) < 0)
+		if (perf_evlist__add_pollfd(evlist, fd) < 0) {
+			perf_evlist__mmap_put(evlist, idx);
 			return -1;
+		}
 
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index fc013704d903..bd312b01e876 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -18,9 +18,15 @@ struct record_opts;
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
+/**
+ * struct perf_mmap - perf's ring buffer mmap details
+ *
+ * @refcnt - e.g. code using PERF_EVENT_IOC_SET_OUTPUT to share this
+ */
 struct perf_mmap {
 	void		 *base;
 	int		 mask;
+	int		 refcnt;
 	unsigned int	 prev;
 	char		 event_copy[PERF_SAMPLE_MAX_SIZE];
 };
-- 
1.9.3

