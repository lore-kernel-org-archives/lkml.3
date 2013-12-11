Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3LKMkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:40:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:5186 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3LKMj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442368718"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 27/71] perf evlist: Add 'system_wide' option
Date: Wed, 11 Dec 2013 14:36:39 +0200
Message-Id: <1386765443-26966-28-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an option to cause a selected event
to be opened always without a pid when
configured by perf_evsel__config().

This is needed when using the sched_switch
tracepoint to follow object code execution.
sched_switch occurs before the task
switch and so it cannot record it in a
context limited to that task.  Note
that also means that sched_switch is
useless when capturing data per-thread,
as is the 'context-switches' software
event for the same reason.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 45 +++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/evsel.c  | 31 ++++++++++++++++++++++++++-----
 tools/perf/util/evsel.h  |  1 +
 3 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ae9cbe6..3959978 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -261,17 +261,27 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
 	return 0;
 }
 
+static int perf_evlist__nr_threads(struct perf_evlist *evlist,
+				   struct perf_evsel *evsel)
+{
+	if (evsel->system_wide)
+		return 1;
+	else
+		return thread_map__nr(evlist->threads);
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
 	struct perf_evsel *pos;
 	int nr_cpus = cpu_map__nr(evlist->cpus);
-	int nr_threads = thread_map__nr(evlist->threads);
+	int nr_threads;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
+			nr_threads = perf_evlist__nr_threads(evlist, pos);
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_DISABLE, 0);
@@ -284,12 +294,13 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	int cpu, thread;
 	struct perf_evsel *pos;
 	int nr_cpus = cpu_map__nr(evlist->cpus);
-	int nr_threads = thread_map__nr(evlist->threads);
+	int nr_threads;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
+			nr_threads = perf_evlist__nr_threads(evlist, pos);
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_ENABLE, 0);
@@ -301,12 +312,14 @@ int perf_evlist__disable_event(struct perf_evlist *evlist,
 			       struct perf_evsel *evsel)
 {
 	int cpu, thread, err;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = perf_evlist__nr_threads(evlist, evsel);
 
 	if (!evsel->fd)
 		return 0;
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		for (thread = 0; thread < evlist->threads->nr; thread++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		for (thread = 0; thread < nr_threads; thread++) {
 			err = ioctl(FD(evsel, cpu, thread),
 				    PERF_EVENT_IOC_DISABLE, 0);
 			if (err)
@@ -320,12 +333,14 @@ int perf_evlist__enable_event(struct perf_evlist *evlist,
 			      struct perf_evsel *evsel)
 {
 	int cpu, thread, err;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = perf_evlist__nr_threads(evlist, evsel);
 
 	if (!evsel->fd)
 		return -EINVAL;
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		for (thread = 0; thread < evlist->threads->nr; thread++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		for (thread = 0; thread < nr_threads; thread++) {
 			err = ioctl(FD(evsel, cpu, thread),
 				    PERF_EVENT_IOC_ENABLE, 0);
 			if (err)
@@ -339,7 +354,16 @@ static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nr_cpus = cpu_map__nr(evlist->cpus);
 	int nr_threads = thread_map__nr(evlist->threads);
-	int nfds = nr_cpus * nr_threads * evlist->nr_entries;
+	int nfds = 0;
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->system_wide)
+			nfds += nr_cpus;
+		else
+			nfds += nr_cpus * nr_threads;
+	}
+
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
 	return evlist->pollfd != NULL ? 0 : -ENOMEM;
 }
@@ -630,7 +654,12 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 	struct perf_evsel *evsel;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		int fd = FD(evsel, cpu, thread);
+		int fd;
+
+		if (evsel->system_wide && thread)
+			continue;
+
+		fd = FD(evsel, cpu, thread);
 
 		if (*output == -1) {
 			*output = fd;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5fcd7cb..4e92a22 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -671,6 +671,10 @@ void perf_evsel__config(struct perf_evsel *evsel,
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
+
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
 
 	if (evsel->fd) {
@@ -689,6 +693,9 @@ static int perf_evsel__run_ioctl(struct perf_evsel *evsel, int ncpus, int nthrea
 {
 	int cpu, thread;
 
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	for (cpu = 0; cpu < ncpus; cpu++) {
 		for (thread = 0; thread < nthreads; thread++) {
 			int fd = FD(evsel, cpu, thread),
@@ -719,6 +726,9 @@ int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	evsel->sample_id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
 	if (evsel->sample_id == NULL)
 		return -ENOMEM;
@@ -764,6 +774,9 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
 
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	for (cpu = 0; cpu < ncpus; cpu++)
 		for (thread = 0; thread < nthreads; ++thread) {
 			close(FD(evsel, cpu, thread));
@@ -852,6 +865,9 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	int cpu, thread;
 	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
 
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	aggr->val = aggr->ena = aggr->run = 0;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
@@ -974,13 +990,18 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
-	int cpu, thread;
+	int cpu, thread, nthreads;
 	unsigned long flags = 0;
 	int pid = -1, err;
 	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
+	if (evsel->system_wide)
+		nthreads = 1;
+	else
+		nthreads = threads->nr;
+
 	if (evsel->fd == NULL &&
-	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
+	    perf_evsel__alloc_fd(evsel, cpus->nr, nthreads) < 0)
 		return -ENOMEM;
 
 	if (evsel->cgrp) {
@@ -1002,10 +1023,10 @@ retry_sample_id:
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
-		for (thread = 0; thread < threads->nr; thread++) {
+		for (thread = 0; thread < nthreads; thread++) {
 			int group_fd;
 
-			if (!evsel->cgrp)
+			if (!evsel->cgrp && !evsel->system_wide)
 				pid = threads->map[thread];
 
 			group_fd = get_group_fd(evsel, cpu, thread);
@@ -1075,7 +1096,7 @@ out_close:
 			close(FD(evsel, cpu, thread));
 			FD(evsel, cpu, thread) = -1;
 		}
-		thread = threads->nr;
+		thread = nthreads;
 	} while (--cpu >= 0);
 	return err;
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index de1b36e..7b8795d 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -85,6 +85,7 @@ struct perf_evsel {
 	bool 			needs_swap;
 	bool			no_aux_samples;
 	bool			immediate;
+	bool			system_wide;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
-- 
1.8.5.1

