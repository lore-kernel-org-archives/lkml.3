Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaHMWvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:51:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:55606 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaHMWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:51:01 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/41] perf evlist: Add 'system_wide' option
Date: Wed, 13 Aug 2014 19:48:19 -0300
Message-Id: <1407970107-24540-34-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an option to cause a selected event to be opened always without a
pid when configured by perf_evsel__config().

This is needed when using the sched_switch tracepoint to follow object
code execution.

sched_switch occurs before the task switch and so it cannot record it in
a context limited to that task.  Note that also means that sched_switch
is useless when capturing data per-thread, as is the 'context-switches'
software event for the same reason.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 45 +++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/evsel.c  | 31 ++++++++++++++++++++++++++-----
 tools/perf/util/evsel.h  |  1 +
 3 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3b366c085021..c74d8ecc9c70 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -265,17 +265,27 @@ int perf_evlist__add_newtp(struct perf_evlist *evlist,
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
 		evlist__for_each(evlist, pos) {
 			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
+			nr_threads = perf_evlist__nr_threads(evlist, pos);
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_DISABLE, 0);
@@ -288,12 +298,13 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	int cpu, thread;
 	struct perf_evsel *pos;
 	int nr_cpus = cpu_map__nr(evlist->cpus);
-	int nr_threads = thread_map__nr(evlist->threads);
+	int nr_threads;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		evlist__for_each(evlist, pos) {
 			if (!perf_evsel__is_group_leader(pos) || !pos->fd)
 				continue;
+			nr_threads = perf_evlist__nr_threads(evlist, pos);
 			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_ENABLE, 0);
@@ -305,12 +316,14 @@ int perf_evlist__disable_event(struct perf_evlist *evlist,
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
@@ -324,12 +337,14 @@ int perf_evlist__enable_event(struct perf_evlist *evlist,
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
@@ -343,7 +358,16 @@ static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
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
@@ -636,7 +660,12 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 	struct perf_evsel *evsel;
 
 	evlist__for_each(evlist, evsel) {
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
index 0c8919decac8..66de9a708163 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -695,6 +695,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
+
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	evsel->fd = xyarray__new(ncpus, nthreads, sizeof(int));
 
 	if (evsel->fd) {
@@ -713,6 +717,9 @@ static int perf_evsel__run_ioctl(struct perf_evsel *evsel, int ncpus, int nthrea
 {
 	int cpu, thread;
 
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	for (cpu = 0; cpu < ncpus; cpu++) {
 		for (thread = 0; thread < nthreads; thread++) {
 			int fd = FD(evsel, cpu, thread),
@@ -743,6 +750,9 @@ int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	evsel->sample_id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
 	if (evsel->sample_id == NULL)
 		return -ENOMEM;
@@ -787,6 +797,9 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
 
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	for (cpu = 0; cpu < ncpus; cpu++)
 		for (thread = 0; thread < nthreads; ++thread) {
 			close(FD(evsel, cpu, thread));
@@ -875,6 +888,9 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	int cpu, thread;
 	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
 
+	if (evsel->system_wide)
+		nthreads = 1;
+
 	aggr->val = aggr->ena = aggr->run = 0;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
@@ -997,13 +1013,18 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
-	int cpu, thread;
+	int cpu, thread, nthreads;
 	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
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
@@ -1027,10 +1048,10 @@ retry_sample_id:
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
-		for (thread = 0; thread < threads->nr; thread++) {
+		for (thread = 0; thread < nthreads; thread++) {
 			int group_fd;
 
-			if (!evsel->cgrp)
+			if (!evsel->cgrp && !evsel->system_wide)
 				pid = threads->map[thread];
 
 			group_fd = get_group_fd(evsel, cpu, thread);
@@ -1103,7 +1124,7 @@ out_close:
 			close(FD(evsel, cpu, thread));
 			FD(evsel, cpu, thread) = -1;
 		}
-		thread = threads->nr;
+		thread = nthreads;
 	} while (--cpu >= 0);
 	return err;
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index d7f93ce0ebc1..dbb2a0d20907 100644
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
1.9.3

