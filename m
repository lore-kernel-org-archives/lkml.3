Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaIXOEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:04:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:51419 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaIXOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:04:26 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/11] perf tools: Parse event per-package info files
Date: Wed, 24 Sep 2014 15:04:07 +0100
Message-Id: <1411567455-31264-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

In preparation for upcoming PMU drivers that support system-wide,
per-package counters and hence report duplicate values, add support for
parsing the .per-pkg file.

An event can export this info file to indicate that all but one value
per socket should be discarded.

The discarding is much easier to do in userspace than inside the kernel
because the kernel cannot infer what userspace is going to do with the
reported values, what order it will read them in, etc.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 tools/perf/builtin-stat.c      | 79 +++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evsel.c        |  6 +++-
 tools/perf/util/evsel.h        |  8 +++--
 tools/perf/util/parse-events.c |  1 +
 tools/perf/util/pmu.c          | 28 +++++++++++++++
 tools/perf/util/pmu.h          |  1 +
 6 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7c30fbd2d9b7..c5dd11fbbd7c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -388,17 +388,89 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 }
 
 /*
+ * If 'evsel' is a per-socket event we may get duplicate values
+ * reported. We need to discard all but one per-socket value.
+ */
+static bool counter_per_socket_skip(struct perf_evsel *evsel, int cpu, u64 val)
+{
+	struct cpu_map *map;
+	int i, ncpus;
+	int s1, s2;
+
+	map = perf_evsel__cpus(evsel);
+	ncpus = map->nr;
+
+	s1 = cpu_map__get_socket(evsel_list->cpus, map->map[cpu]);
+
+	/*
+	 * Read all CPUs for this socket and see if any already have
+	 * value assigned.
+	 */
+	for (i = 0; i < ncpus; i++) {
+		s2 = cpu_map__get_socket(evsel_list->cpus, map->map[i]);
+		if (s1 != s2)
+			continue;
+
+		if (evsel->counts->cpu[i].val)
+			return true;
+	}
+
+	/* Stash the counter value in unused ->counts */
+	evsel->counts->cpu[cpu].val = val;
+	return false;
+}
+
+static bool aggr_per_socket_skip(struct perf_evsel *evsel, int cpu)
+{
+	struct cpu_map *map;
+	int leader_cpu = -1;
+	int i, ncpus;
+	int s1, s2;
+
+	map = perf_evsel__cpus(evsel);
+	ncpus = map->nr;
+
+	s1 = cpu_map__get_socket(evsel_list->cpus, map->map[cpu]);
+
+	/*
+	 * Find the first enabled counter for this socket and skip
+	 * everything else.
+	 */
+	for (i = 0; i < ncpus; i++) {
+		s2 = cpu_map__get_socket(evsel_list->cpus, map->map[i]);
+		if (s1 != s2)
+			continue;
+
+		if (!evsel->counts->cpu[i].ena)
+			continue;
+
+		leader_cpu = i;
+		break;
+	}
+
+	if (cpu == leader_cpu)
+		return false;
+
+	return true;
+}
+
+/*
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
 static int read_counter_aggr(struct perf_evsel *counter)
 {
 	struct perf_stat *ps = counter->priv;
+	bool (*f_skip)(struct perf_evsel *evsel, int cpu, u64 val) = NULL;
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
+	if (counter->per_pkg)
+		f_skip = counter_per_socket_skip;
+
 	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
-			       thread_map__nr(evsel_list->threads), scale) < 0)
+			       thread_map__nr(evsel_list->threads),
+			       scale, f_skip) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -1128,6 +1200,11 @@ static void print_aggr(char *prefix)
 			val = ena = run = 0;
 			nr = 0;
 			for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
+				if (counter->per_pkg) {
+					if (aggr_per_socket_skip(counter, cpu))
+						continue;
+				}
+
 				cpu2 = perf_evsel__cpus(counter)->map[cpu];
 				s2 = aggr_get_id(evsel_list->cpus, cpu2);
 				if (s2 != id)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b38de5819323..e7693b59e081 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -883,7 +883,8 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 }
 
 int __perf_evsel__read(struct perf_evsel *evsel,
-		       int ncpus, int nthreads, bool scale)
+		       int ncpus, int nthreads, bool scale,
+		       bool (*f_skip)(struct perf_evsel *evsel, int cpu, u64 val))
 {
 	size_t nv = scale ? 3 : 1;
 	int cpu, thread;
@@ -903,6 +904,9 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 				  &count, nv * sizeof(u64)) < 0)
 				return -errno;
 
+			if (f_skip && f_skip(evsel, cpu, count.val))
+				continue;
+
 			aggr->val += count.val;
 			if (scale) {
 				aggr->ena += count.ena;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7bc314be6a7b..c5441e547b28 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -87,6 +87,7 @@ struct perf_evsel {
 	bool			immediate;
 	bool			system_wide;
 	bool			tracking;
+	bool			per_pkg;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
@@ -253,7 +254,8 @@ static inline int perf_evsel__read_on_cpu_scaled(struct perf_evsel *evsel,
 }
 
 int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
-		       bool scale);
+		       bool scale,
+		       bool (*f_skip)(struct perf_evsel *evsel, int cpu, u64 val));
 
 /**
  * perf_evsel__read - Read the aggregate results on all CPUs
@@ -265,7 +267,7 @@ int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
 static inline int perf_evsel__read(struct perf_evsel *evsel,
 				    int ncpus, int nthreads)
 {
-	return __perf_evsel__read(evsel, ncpus, nthreads, false);
+	return __perf_evsel__read(evsel, ncpus, nthreads, false, NULL);
 }
 
 /**
@@ -278,7 +280,7 @@ static inline int perf_evsel__read(struct perf_evsel *evsel,
 static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 					  int ncpus, int nthreads)
 {
-	return __perf_evsel__read(evsel, ncpus, nthreads, true);
+	return __perf_evsel__read(evsel, ncpus, nthreads, true, NULL);
 }
 
 void hists__init(struct hists *hists);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9522cf22ad81..e1d8025c46bc 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -672,6 +672,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	if (evsel) {
 		evsel->unit = info.unit;
 		evsel->scale = info.scale;
+		evsel->per_pkg = info.per_pkg;
 	}
 
 	return evsel ? 0 : -ENOMEM;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 93a41ca96b8e..a08e8893b2e1 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -20,6 +20,7 @@ struct perf_pmu_alias {
 	struct list_head list;  /* ELEM */
 	char unit[UNIT_MAX_LEN+1];
 	double scale;
+	bool per_pkg;
 };
 
 struct perf_pmu_format {
@@ -173,6 +174,24 @@ error:
 	return -1;
 }
 
+static int
+perf_pmu__parse_per_pkg(struct perf_pmu_alias *alias, char *dir, char *name)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf(path, PATH_MAX, "%s/%s.per-pkg", dir, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	close(fd);
+
+	alias->per_pkg = true;
+	return 0;
+}
+
 static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FILE *file)
 {
 	struct perf_pmu_alias *alias;
@@ -191,6 +210,7 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	INIT_LIST_HEAD(&alias->terms);
 	alias->scale = 1.0;
 	alias->unit[0] = '\0';
+	alias->per_pkg = false;
 
 	ret = parse_events_terms(&alias->terms, buf);
 	if (ret) {
@@ -204,6 +224,7 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	 */
 	perf_pmu__parse_unit(alias, dir, name);
 	perf_pmu__parse_scale(alias, dir, name);
+	perf_pmu__parse_per_pkg(alias, dir, name);
 
 	list_add_tail(&alias->list, list);
 
@@ -219,6 +240,8 @@ static inline bool pmu_alias_info_file(char *name)
 		return true;
 	if (len > 6 && !strcmp(name + len - 6, ".scale"))
 		return true;
+	if (len > 8 && !strcmp(name + len - 8, ".per-pkg"))
+		return true;
 
 	return false;
 }
@@ -659,6 +682,8 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 	struct perf_pmu_alias *alias;
 	int ret;
 
+	info->per_pkg = false;
+
 	/*
 	 * Mark unit and scale as not set
 	 * (different from default values, see below)
@@ -678,6 +703,9 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		if (ret)
 			return ret;
 
+		if (alias->per_pkg)
+			info->per_pkg = true;
+
 		list_del(&term->list);
 		free(term);
 	}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index fe90a012c003..82262eb90de8 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -28,6 +28,7 @@ struct perf_pmu {
 struct perf_pmu_info {
 	const char *unit;
 	double scale;
+	bool per_pkg;
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
-- 
1.9.3

