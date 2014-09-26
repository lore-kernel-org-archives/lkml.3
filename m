Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaIZJWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:22:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaIZJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:21:58 -0400
Date: Fri, 26 Sep 2014 02:21:35 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-cpv7v2lw0g74ucmxa39xdpms@git.kernel.org>
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
In-Reply-To: <20140908153824.GG2773@kernel.org>
References: <20140908153824.GG2773@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Refcount mmaps
Git-Commit-ID: 82396986032915c1572bfb74b224fcc2e4e8ba7c
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

Commit-ID:  82396986032915c1572bfb74b224fcc2e4e8ba7c
Gitweb:     http://git.kernel.org/tip/82396986032915c1572bfb74b224fcc2e4e8ba7c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 8 Sep 2014 13:26:35 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:55 -0300

perf evlist: Refcount mmaps

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
index 398dab1..efddee5 100644
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
index fc01370..bd312b0 100644
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
