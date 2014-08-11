Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaHKIur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKIup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:45 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/20] perf tools: Add evlist/evsel poller object support
Date: Mon, 11 Aug 2014 10:50:00 +0200
Message-Id: <1407747014-18394-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing perf_evsel fd (xyarray) entry to carry poller_item
object. The reason for this is to source polling data with
file descriptor, because we need them both.

Adding following helper functions to go through the event's
descriptors and initialize poller object:

  perf_evlist__set_poller
  perf_evsel__set_poller

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evlist.c | 14 ++++++++++++++
 tools/perf/util/evlist.h |  3 +++
 tools/perf/util/evsel.c  | 19 ++++++++++++++++++-
 tools/perf/util/evsel.h  |  7 ++++++-
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4e0f0670b655..a4c381c10c72 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1266,3 +1266,17 @@ void perf_evlist__to_front(struct perf_evlist *evlist,
 
 	list_splice(&move, &evlist->entries);
 }
+
+int perf_evlist__set_poller(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	int err = -1;
+
+	evlist__for_each(evlist, evsel) {
+		err = perf_evsel__set_poller(evsel, &evlist->poller);
+		if (err)
+			break;
+	}
+
+	return err;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f5173cd63693..7d03af1ce4f7 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -45,6 +45,7 @@ struct perf_evlist {
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
 	struct perf_evsel *selected;
+	struct poller	 poller;
 };
 
 struct perf_evsel_str_handler {
@@ -196,6 +197,8 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
 void perf_evlist__to_front(struct perf_evlist *evlist,
 			   struct perf_evsel *move_evsel);
 
+int perf_evlist__set_poller(struct perf_evlist *evlist);
+
 /**
  * __evlist__for_each - iterate thru all the evsels
  * @list: list_head instance to iterate
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1ec1a7ec1cfb..580061d16e4a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -695,7 +695,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
-	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
+	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(struct poller_item));
 
 	if (evsel->fd) {
 		for (cpu = 0; cpu < ncpus; cpu++) {
@@ -2055,3 +2055,20 @@ int perf_evsel__open_strerror(struct perf_evsel *evsel, struct target *target,
 	"No CONFIG_PERF_EVENTS=y kernel support configured?\n",
 			 err, strerror(err), perf_evsel__name(evsel));
 }
+
+int perf_evsel__set_poller(struct perf_evsel *evsel, struct poller *poller)
+{
+	struct poller_item *p;
+	int err = -1;
+
+	xyarray__for_each(evsel->fd, p) {
+		if (p->fd == -1)
+			continue;
+
+		err = poller__add(poller, p);
+		if (err)
+			break;
+	}
+
+	return err;
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index fe8794fa73ed..4c6cd9185710 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -10,6 +10,7 @@
 #include "cgroup.h"
 #include "hist.h"
 #include "symbol.h"
+#include "poller.h"
 
 struct perf_counts_values {
 	union {
@@ -366,7 +367,11 @@ for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); 	\
 
 static inline int *perf_evsel__fd(struct perf_evsel *evsel, int cpu, int thread)
 {
-	return (int *) xyarray__entry(evsel->fd, cpu, thread);
+	struct poller_item *p;
+
+	p = xyarray__entry(evsel->fd, cpu, thread);
+	return &p->fd;
 }
 
+int perf_evsel__set_poller(struct perf_evsel *evsel, struct poller *poller);
 #endif /* __PERF_EVSEL_H */
-- 
1.8.3.1

