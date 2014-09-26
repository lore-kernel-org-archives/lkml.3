Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaIZJU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:20:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaIZJUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:20:53 -0400
Date: Fri, 26 Sep 2014 02:20:23 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-o2mzsjl7taumsoc35ryol00i@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Allow growing pollfd on add method
Git-Commit-ID: ad6765dd3b2f043e819bdec565db8f5a2f781e06
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

Commit-ID:  ad6765dd3b2f043e819bdec565db8f5a2f781e06
Gitweb:     http://git.kernel.org/tip/ad6765dd3b2f043e819bdec565db8f5a2f781e06
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 18 Aug 2014 16:44:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:54 -0300

perf evlist: Allow growing pollfd on add method

This way we will be able to add more file descriptors to be polled,
like stdin or some timer fd.

At this point we might as well yank the pollfd class from evlist so that
it can be used in other places.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-o2mzsjl7taumsoc35ryol00i@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 38 +++++++++++++++++++++++++++++++++-----
 tools/perf/util/evlist.h |  5 +++--
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6b13bfa..bcf157c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -402,7 +402,21 @@ int perf_evlist__enable_event_idx(struct perf_evlist *evlist,
 		return perf_evlist__enable_event_thread(evlist, evsel, idx);
 }
 
-static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
+static int perf_evlist__grow_pollfd(struct perf_evlist *evlist, int hint)
+{
+	int nr_fds_alloc = evlist->nr_fds_alloc + hint;
+	size_t size = sizeof(struct pollfd) * nr_fds_alloc;
+	struct pollfd *pollfd = realloc(evlist->pollfd, size);
+
+	if (pollfd == NULL)
+		return -ENOMEM;
+
+	evlist->nr_fds_alloc = nr_fds_alloc;
+	evlist->pollfd	     = pollfd;
+	return 0;
+}
+
+int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nr_cpus = cpu_map__nr(evlist->cpus);
 	int nr_threads = thread_map__nr(evlist->threads);
@@ -416,16 +430,28 @@ static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 			nfds += nr_cpus * nr_threads;
 	}
 
-	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
-	return evlist->pollfd != NULL ? 0 : -ENOMEM;
+	if (evlist->nr_fds_alloc - evlist->nr_fds < nfds &&
+	    perf_evlist__grow_pollfd(evlist, nfds) < 0)
+		return -ENOMEM;
+
+	return 0;
 }
 
-void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
+int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 {
+	/*
+	 * XXX: 64 is arbitrary, just not to call realloc at each fd.
+	 *	Find a better autogrowing heuristic
+	 */
+	if (evlist->nr_fds == evlist->nr_fds_alloc &&
+	    perf_evlist__grow_pollfd(evlist, 64) < 0)
+		return -ENOMEM;
+
 	fcntl(fd, F_SETFL, O_NONBLOCK);
 	evlist->pollfd[evlist->nr_fds].fd = fd;
 	evlist->pollfd[evlist->nr_fds].events = POLLIN | POLLERR | POLLHUP;
 	evlist->nr_fds++;
+	return 0;
 }
 
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
@@ -717,6 +743,7 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 		evlist->mmap[idx].base = NULL;
 		return -1;
 	}
+
 	return 0;
 }
 
@@ -743,7 +770,8 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 				return -1;
 		}
 
-		perf_evlist__add_pollfd(evlist, fd);
+		if (perf_evlist__add_pollfd(evlist, fd) < 0)
+			return -1;
 
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 1082420..bbc2fd0 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -30,6 +30,7 @@ struct perf_evlist {
 	int		 nr_entries;
 	int		 nr_groups;
 	int		 nr_fds;
+	int		 nr_fds_alloc;
 	int		 nr_mmaps;
 	size_t		 mmap_len;
 	int		 id_pos;
@@ -82,8 +83,8 @@ perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
-void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
-
+int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
+int perf_evlist__alloc_pollfd(struct perf_evlist *evlist);
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
