Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbbAZQtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:49:46 -0500
Received: from mail.kernel.org ([198.145.29.136]:49896 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbbAZQtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:49:43 -0500
Date: Mon, 26 Jan 2015 13:49:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Yan@infradead.org,
        Zheng <zheng.z.yan@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC/PATCH 1/1] perf evsel: Set evsel->cpus to the evlist->cpus when
 not constrained
Message-ID: <20150126164943.GA10207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

	Following up on that private discussion, can you take a look?

- Arnaldo

>From 9ecdd9b9bf0a7fd5645957ba4e6a98b6ee526109 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 26 Jan 2015 13:43:42 -0300
Subject: [PATCH 1/1] perf evsel: Set evsel->cpus to the evlist->cpus when not
 constrained

So that we don't need to know about the evlist all the time and can cope
with cases where evsel->cpus were set because it was for an event on a
PMU with a cpumask.

Reported-by: Stephane Eranian <eranian@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 36 ++++++++++------------------
 tools/perf/util/evlist.c  | 61 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 66 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e598e4e98170..ddf41bede0b8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -163,16 +163,6 @@ static inline void diff_timespec(struct timespec *r, struct timespec *a,
 	}
 }
 
-static inline struct cpu_map *perf_evsel__cpus(struct perf_evsel *evsel)
-{
-	return (evsel->cpus && !target.cpu_list) ? evsel->cpus : evsel_list->cpus;
-}
-
-static inline int perf_evsel__nr_cpus(struct perf_evsel *evsel)
-{
-	return perf_evsel__cpus(evsel)->nr;
-}
-
 static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
 {
 	int i;
@@ -202,7 +192,7 @@ static int perf_evsel__alloc_prev_raw_counts(struct perf_evsel *evsel)
 	size_t sz;
 
 	sz = sizeof(*evsel->counts) +
-	     (perf_evsel__nr_cpus(evsel) * sizeof(struct perf_counts_values));
+	     (cpu_map__nr(evsel->cpus) * sizeof(struct perf_counts_values));
 
 	addr = zalloc(sz);
 	if (!addr)
@@ -235,7 +225,7 @@ static int perf_evlist__alloc_stats(struct perf_evlist *evlist, bool alloc_raw)
 
 	evlist__for_each(evlist, evsel) {
 		if (perf_evsel__alloc_stat_priv(evsel) < 0 ||
-		    perf_evsel__alloc_counts(evsel, perf_evsel__nr_cpus(evsel)) < 0 ||
+		    perf_evsel__alloc_counts(evsel, cpu_map__nr(evsel->cpus)) < 0 ||
 		    (alloc_raw && perf_evsel__alloc_prev_raw_counts(evsel) < 0))
 			goto out_free;
 	}
@@ -269,7 +259,7 @@ static void perf_stat__reset_stats(struct perf_evlist *evlist)
 
 	evlist__for_each(evlist, evsel) {
 		perf_evsel__reset_stat_priv(evsel);
-		perf_evsel__reset_counts(evsel, perf_evsel__nr_cpus(evsel));
+		perf_evsel__reset_counts(evsel, cpu_map__nr(evsel->cpus));
 	}
 
 	memset(runtime_nsecs_stats, 0, sizeof(runtime_nsecs_stats));
@@ -302,7 +292,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 	attr->inherit = !no_inherit;
 
 	if (target__has_cpu(&target))
-		return perf_evsel__open_per_cpu(evsel, perf_evsel__cpus(evsel));
+		return perf_evsel__open_per_cpu(evsel, evsel->cpus);
 
 	if (!target__has_task(&target) && perf_evsel__is_group_leader(evsel)) {
 		attr->disabled = 1;
@@ -397,7 +387,7 @@ static void zero_per_pkg(struct perf_evsel *counter)
 static int check_per_pkg(struct perf_evsel *counter, int cpu, bool *skip)
 {
 	unsigned long *mask = counter->per_pkg_mask;
-	struct cpu_map *cpus = perf_evsel__cpus(counter);
+	struct cpu_map *cpus = counter->cpus;
 	int s;
 
 	*skip = false;
@@ -507,7 +497,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 static int read_counter(struct perf_evsel *counter)
 {
 	int nthreads = thread_map__nr(evsel_list->threads);
-	int ncpus = perf_evsel__nr_cpus(counter);
+	int ncpus = cpu_map__nr(counter->cpus);
 	int cpu, thread;
 
 	if (counter->system_wide)
@@ -727,13 +717,13 @@ static int __run_perf_stat(int argc, const char **argv)
 	if (aggr_mode == AGGR_GLOBAL) {
 		evlist__for_each(evsel_list, counter) {
 			read_counter_aggr(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
+			perf_evsel__close_fd(counter, cpu_map__nr(counter->cpus),
 					     thread_map__nr(evsel_list->threads));
 		}
 	} else {
 		evlist__for_each(evsel_list, counter) {
 			read_counter(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
+			perf_evsel__close_fd(counter, cpu_map__nr(counter->cpus), 1);
 		}
 	}
 
@@ -812,7 +802,7 @@ static void aggr_printout(struct perf_evsel *evsel, int id, int nr)
 	case AGGR_NONE:
 		fprintf(output, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			perf_evsel__cpus(evsel)->map[id], csv_sep);
+			evsel->cpus->map[id], csv_sep);
 		break;
 	case AGGR_GLOBAL:
 	default:
@@ -1216,8 +1206,8 @@ static void print_aggr(char *prefix)
 		evlist__for_each(evsel_list, counter) {
 			val = ena = run = 0;
 			nr = 0;
-			for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-				cpu2 = perf_evsel__cpus(counter)->map[cpu];
+			for (cpu = 0; cpu < cpu_map__nr(counter->cpus); cpu++) {
+				cpu2 = counter->cpus->map[cpu];
 				s2 = aggr_get_id(evsel_list->cpus, cpu2);
 				if (s2 != id)
 					continue;
@@ -1339,7 +1329,7 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 	double uval;
 	int cpu;
 
-	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
+	for (cpu = 0; cpu < cpu_map__nr(counter->cpus); cpu++) {
 		val = counter->counts->cpu[cpu].val;
 		ena = counter->counts->cpu[cpu].ena;
 		run = counter->counts->cpu[cpu].run;
@@ -1350,7 +1340,7 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 		if (run == 0 || ena == 0) {
 			fprintf(output, "CPU%*d%s%*s%s",
 				csv_output ? 0 : -4,
-				perf_evsel__cpus(counter)->map[cpu], csv_sep,
+				counter->cpus->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 				csv_sep);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 28b8ce86bf12..202d1e9842e7 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -111,13 +111,45 @@ void perf_evlist__exit(struct perf_evlist *evlist)
 	fdarray__exit(&evlist->pollfd);
 }
 
+static void perf_evlist__reset_cpus(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	evlist__for_each(evlist, evsel) {
+		if (evsel->cpus == evlist->cpus)
+			evsel->cpus = NULL;
+	}
+
+	evlist->cpus = NULL;
+}
+
+static void perf_evlist__set_cpus(struct perf_evlist *evlist, struct cpu_map *cpus)
+{
+	struct perf_evsel *evsel;
+
+	if (evlist->cpus != NULL)
+		perf_evlist__reset_cpus(evlist);
+	/*
+	 * If, when parsing events, the evsel->cpus wasn't constrained to a
+	 * cpulist, say, because it is on a PMU that has a cpumask, then set it
+	 * to the evlist cpu_map, so that we can access evsel->cpus and get the
+	 * cpu_map this evsel works with.
+	 */
+	evlist__for_each(evlist, evsel) {
+		if (evsel->cpus == NULL)
+			evsel->cpus = cpus;
+	}
+
+	evlist->cpus = cpus;
+}
+
 void perf_evlist__delete(struct perf_evlist *evlist)
 {
 	perf_evlist__munmap(evlist);
 	perf_evlist__close(evlist);
 	cpu_map__delete(evlist->cpus);
+	perf_evlist__reset_cpus(evlist);
 	thread_map__delete(evlist->threads);
-	evlist->cpus = NULL;
 	evlist->threads = NULL;
 	perf_evlist__purge(evlist);
 	perf_evlist__exit(evlist);
@@ -129,6 +161,14 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 	list_add_tail(&entry->node, &evlist->entries);
 	entry->idx = evlist->nr_entries;
 	entry->tracking = !entry->idx;
+	/*
+	 * If, when parsing events, the evsel->cpus wasn't constrained to a
+	 * cpulist, say, because it is on a PMU that has a cpumask, then set it
+	 * to the evlist cpu_map, so that we can access evsel->cpus and get the
+	 * cpu_map this evsel works with.
+	 */
+	if (entry->cpus == NULL)
+		entry->cpus = evlist->cpus;
 
 	if (!evlist->nr_entries++)
 		perf_evlist__set_id_pos(evlist);
@@ -1029,6 +1069,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 {
+	struct cpu_map *cpus;
+
 	evlist->threads = thread_map__new_str(target->pid, target->tid,
 					      target->uid);
 
@@ -1036,13 +1078,15 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 		return -1;
 
 	if (target__uses_dummy_map(target))
-		evlist->cpus = cpu_map__dummy_new();
+		cpus = cpu_map__dummy_new();
 	else
-		evlist->cpus = cpu_map__new(target->cpu_list);
+		cpus = cpu_map__new(target->cpu_list);
 
-	if (evlist->cpus == NULL)
+	if (cpus == NULL)
 		goto out_delete_threads;
 
+	perf_evlist__set_cpus(evlist, cpus);
+
 	return 0;
 
 out_delete_threads:
@@ -1222,6 +1266,7 @@ void perf_evlist__close(struct perf_evlist *evlist)
 
 static int perf_evlist__create_syswide_maps(struct perf_evlist *evlist)
 {
+	struct cpu_map *cpus;
 	int err = -ENOMEM;
 
 	/*
@@ -1233,20 +1278,20 @@ static int perf_evlist__create_syswide_maps(struct perf_evlist *evlist)
 	 * error, and we may not want to do that fallback to a
 	 * default cpu identity map :-\
 	 */
-	evlist->cpus = cpu_map__new(NULL);
-	if (evlist->cpus == NULL)
+	cpus = cpu_map__new(NULL);
+	if (cpus == NULL)
 		goto out;
 
 	evlist->threads = thread_map__new_dummy();
 	if (evlist->threads == NULL)
 		goto out_free_cpus;
 
+	perf_evlist__set_cpus(evlist, cpus);
 	err = 0;
 out:
 	return err;
 out_free_cpus:
-	cpu_map__delete(evlist->cpus);
-	evlist->cpus = NULL;
+	cpu_map__delete(cpus);
 	goto out;
 }
 
-- 
1.8.3.1

