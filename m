Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaIJOKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:10:43 -0400
Received: from mail.kernel.org ([198.145.19.201]:38683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaIJOKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:37 -0400
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
Subject: [PATCH 12/14] perf evlist: Refcount mmaps
Date: Wed, 10 Sep 2014 11:08:47 -0300
Message-Id: <1410358129-9965-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need to know how many fds are using a perf mmap via
PERF_EVENT_IOC_SET_OUTPUT, so that we can know when to ditch an mmap,
refcount it.

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
Link: http://lkml.kernel.org/n/tip-9ymfcxmk52sb7u1g0i3aiovh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 21 ++++++++++++++++++++-
 tools/perf/util/evlist.h |  6 ++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 477ede5367ee..662057a44126 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -664,6 +664,7 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
 	if (evlist->mmap[idx].base != NULL) {
 		munmap(evlist->mmap[idx].base, evlist->mmap_len);
 		evlist->mmap[idx].base = NULL;
+		evlist->mmap[idx].nfds = 0;
 	}
 }
 
@@ -697,6 +698,7 @@ struct mmap_params {
 static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 			       struct mmap_params *mp, int fd)
 {
+	evlist->mmap[idx].nfds = 1;
 	evlist->mmap[idx].prev = 0;
 	evlist->mmap[idx].mask = mp->mask;
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, mp->prot,
@@ -711,6 +713,19 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 	return 0;
 }
 
+static void perf_evlist__mmap_get(struct perf_evlist *evlist, int idx)
+{
+	++evlist->mmap[idx].nfds;
+}
+
+static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx)
+{
+	BUG_ON(evlist->mmap[idx].nfds == 0);
+
+	if (--evlist->mmap[idx].nfds == 0)
+		__perf_evlist__munmap(evlist, idx);
+}
+
 static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 				       struct mmap_params *mp, int cpu,
 				       int thread, int *output)
@@ -732,10 +747,14 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
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
index fc013704d903..19bbe0410827 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -18,9 +18,15 @@ struct record_opts;
 #define PERF_EVLIST__HLIST_BITS 8
 #define PERF_EVLIST__HLIST_SIZE (1 << PERF_EVLIST__HLIST_BITS)
 
+/**
+ * struct perf_mmap - perf's ring buffer mmap details
+ *
+ * @nfds - file descriptors pointing here via PERF_EVENT_IOC_SET_OUTPUT
+ */
 struct perf_mmap {
 	void		 *base;
 	int		 mask;
+	int		 nfds;
 	unsigned int	 prev;
 	char		 event_copy[PERF_SAMPLE_MAX_SIZE];
 };
-- 
1.9.3

