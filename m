Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab3BLOKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:10:39 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:59428 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917Ab3BLOKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:10:36 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 1/2] perf stat: refactor aggregation code
Date: Tue, 12 Feb 2013 15:09:27 +0100
Message-Id: <1360678168-6974-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360678168-6974-1-git-send-email-eranian@google.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor aggregation code by introducing
a single aggr_mode variable and an enum
for aggregation.

Also refactor cpumap code having to do
with cpu to socket mappings. All in preparation
for extended modes, such as cpu -> core.

Also fix socket aggregation and ensure
that sockets are printed in increasing order.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c |  208 ++++++++++++++++++++++++++-------------------
 tools/perf/util/cpumap.c  |   40 ++++++---
 2 files changed, 148 insertions(+), 100 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9984876..a19f8d5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -68,7 +68,7 @@
 static void print_stat(int argc, const char **argv);
 static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
 static void print_counter(struct perf_evsel *counter, char *prefix);
-static void print_aggr_socket(char *prefix);
+static void print_aggr(char *prefix);
 
 static struct perf_evlist	*evsel_list;
 
@@ -76,11 +76,16 @@ static struct perf_target	target = {
 	.uid	= UINT_MAX,
 };
 
+enum aggr_mode {
+	AGGR_NONE,
+	AGGR_GLOBAL,
+	AGGR_SOCKET,
+};
+
 static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
-static bool			no_aggr				= false;
-static bool			aggr_socket			= false;
+static enum aggr_mode		aggr_mode			= AGGR_GLOBAL;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
@@ -95,7 +100,8 @@ static const char		*post_cmd			= NULL;
 static bool			sync_run			= false;
 static unsigned int		interval			= 0;
 static struct timespec		ref_time;
-static struct cpu_map		*sock_map;
+static struct cpu_map		*aggr_map;
+static int			(*aggr_get_id)(struct cpu_map *m, int cpu);
 
 static volatile int done = 0;
 
@@ -297,41 +303,51 @@ static void print_interval(void)
 	struct timespec ts, rs;
 	char prefix[64];
 
-	if (no_aggr) {
+	if (aggr_mode == AGGR_GLOBAL) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			ps = counter->priv;
 			memset(ps->res_stats, 0, sizeof(ps->res_stats));
-			read_counter(counter);
+			read_counter_aggr(counter);
 		}
-	} else {
+	} else	{
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			ps = counter->priv;
 			memset(ps->res_stats, 0, sizeof(ps->res_stats));
-			read_counter_aggr(counter);
+			read_counter(counter);
 		}
 	}
+
 	clock_gettime(CLOCK_MONOTONIC, &ts);
 	diff_timespec(&rs, &ts, &ref_time);
 	sprintf(prefix, "%6lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
 
 	if (num_print_interval == 0 && !csv_output) {
-		if (aggr_socket)
+		switch (aggr_mode) {
+		case AGGR_SOCKET:
 			fprintf(output, "#           time socket cpus             counts events\n");
-		else if (no_aggr)
+			break;
+		case AGGR_NONE:
 			fprintf(output, "#           time CPU                 counts events\n");
-		else
+			break;
+		case AGGR_GLOBAL:
+		default:
 			fprintf(output, "#           time             counts events\n");
+		}
 	}
 
 	if (++num_print_interval == 25)
 		num_print_interval = 0;
 
-	if (aggr_socket)
-		print_aggr_socket(prefix);
-	else if (no_aggr) {
+	switch (aggr_mode) {
+	case AGGR_SOCKET:
+		print_aggr(prefix);
+		break;
+	case AGGR_NONE:
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter(counter, prefix);
-	} else {
+		break;
+	case AGGR_GLOBAL:
+	default:
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter_aggr(counter, prefix);
 	}
@@ -356,12 +372,6 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 		ts.tv_nsec = 0;
 	}
 
-	if (aggr_socket
-	    && cpu_map__build_socket_map(evsel_list->cpus, &sock_map)) {
-		perror("cannot build socket map");
-		return -1;
-	}
-
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		return -1;
@@ -479,17 +489,18 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 
 	update_stats(&walltime_nsecs_stats, t1 - t0);
 
-	if (no_aggr) {
-		list_for_each_entry(counter, &evsel_list->entries, node) {
-			read_counter(counter);
-			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
-		}
-	} else {
+	if (aggr_mode == AGGR_GLOBAL) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter_aggr(counter);
 			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
 					     evsel_list->threads->nr);
 		}
+	} else {
+		list_for_each_entry(counter, &evsel_list->entries, node) {
+			read_counter(counter);
+			perf_evsel__close_fd(counter,
+					     perf_evsel__nr_cpus(counter), 1);
+		}
 	}
 
 	return WEXITSTATUS(status);
@@ -542,26 +553,37 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
-static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+static void aggr_printout(int cpu, int nr)
 {
-	double msecs = avg / 1e6;
-	char cpustr[16] = { '\0', };
-	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-25s";
-
-	if (aggr_socket)
-		sprintf(cpustr, "S%*d%s%*d%s",
+	switch (aggr_mode) {
+	case AGGR_SOCKET:
+		fprintf(output, "S%*d%s%*d%s",
 			csv_output ? 0 : -5,
 			cpu,
 			csv_sep,
 			csv_output ? 0 : 4,
 			nr,
 			csv_sep);
-	else if (no_aggr)
-		sprintf(cpustr, "CPU%*d%s",
+			break;
+	case AGGR_NONE:
+		fprintf(output, "CPU%*d%s",
 			csv_output ? 0 : -4,
 			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
+		break;
+	case AGGR_GLOBAL:
+	default:
+		break;
+	}
+}
+
+static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+{
+	double msecs = avg / 1e6;
+	const char *fmt = csv_output ? "%.6f%s%s" : "%18.6f%s%-25s";
 
-	fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
+	aggr_printout(cpu, nr);
+
+	fprintf(output, fmt, msecs, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -758,32 +780,21 @@ static void print_ll_cache_misses(int cpu,
 static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
-	char cpustr[16] = { '\0', };
 	const char *fmt;
 
 	if (csv_output)
-		fmt = "%s%.0f%s%s";
+		fmt = "%.0f%s%s";
 	else if (big_num)
-		fmt = "%s%'18.0f%s%-25s";
+		fmt = "%'18.0f%s%-25s";
 	else
-		fmt = "%s%18.0f%s%-25s";
+		fmt = "%18.0f%s%-25s";
 
-	if (aggr_socket)
-		sprintf(cpustr, "S%*d%s%*d%s",
-			csv_output ? 0 : -5,
-			cpu,
-			csv_sep,
-			csv_output ? 0 : 4,
-			nr,
-			csv_sep);
-	else if (no_aggr)
-		sprintf(cpustr, "CPU%*d%s",
-			csv_output ? 0 : -4,
-			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
-	else
+	aggr_printout(cpu, nr);
+
+	if (aggr_mode == AGGR_GLOBAL)
 		cpu = 0;
 
-	fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, avg, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -882,23 +893,23 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	}
 }
 
-static void print_aggr_socket(char *prefix)
+static void print_aggr(char *prefix)
 {
 	struct perf_evsel *counter;
+	int cpu, s, s2, id, nr;
 	u64 ena, run, val;
-	int cpu, s, s2, sock, nr;
 
-	if (!sock_map)
+	if (!(aggr_map || aggr_get_id))
 		return;
 
-	for (s = 0; s < sock_map->nr; s++) {
-		sock = cpu_map__socket(sock_map, s);
+	for (s = 0; s < aggr_map->nr; s++) {
+		id = aggr_map->map[s];
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			val = ena = run = 0;
 			nr = 0;
 			for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-				s2 = cpu_map__get_socket(evsel_list->cpus, cpu);
-				if (s2 != sock)
+				s2 = aggr_get_id(evsel_list->cpus, cpu);
+				if (s2 != id)
 					continue;
 				val += counter->counts->cpu[cpu].val;
 				ena += counter->counts->cpu[cpu].ena;
@@ -909,18 +920,15 @@ static void print_aggr_socket(char *prefix)
 				fprintf(output, "%s", prefix);
 
 			if (run == 0 || ena == 0) {
-				fprintf(output, "S%*d%s%*d%s%*s%s%*s",
-					csv_output ? 0 : -5,
-					s,
-					csv_sep,
-					csv_output ? 0 : 4,
-					nr,
-					csv_sep,
+				aggr_printout(cpu, nr);
+
+				fprintf(output, "%*s%s%*s",
 					csv_output ? 0 : 18,
 					counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 					csv_sep,
 					csv_output ? 0 : -24,
 					perf_evsel__name(counter));
+
 				if (counter->cgrp)
 					fprintf(output, "%s%s",
 						csv_sep, counter->cgrp->name);
@@ -930,9 +938,9 @@ static void print_aggr_socket(char *prefix)
 			}
 
 			if (nsec_counter(counter))
-				nsec_printout(sock, nr, counter, val);
+				nsec_printout(id, nr, counter, val);
 			else
-				abs_printout(sock, nr, counter, val);
+				abs_printout(id, nr, counter, val);
 
 			if (!csv_output) {
 				print_noise(counter, 1.0);
@@ -1073,14 +1081,20 @@ static void print_stat(int argc, const char **argv)
 		fprintf(output, ":\n\n");
 	}
 
-	if (aggr_socket)
-		print_aggr_socket(NULL);
-	else if (no_aggr) {
-		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter(counter, NULL);
-	} else {
+	switch (aggr_mode) {
+	case AGGR_SOCKET:
+		print_aggr(NULL);
+		break;
+	case AGGR_GLOBAL:
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter_aggr(counter, NULL);
+		break;
+	case AGGR_NONE:
+		list_for_each_entry(counter, &evsel_list->entries, node)
+			print_counter(counter, NULL);
+		break;
+	default:
+		break;
 	}
 
 	if (!csv_output) {
@@ -1126,6 +1140,25 @@ static int stat__set_big_num(const struct option *opt __maybe_unused,
 	return 0;
 }
 
+static int perf_stat_init_aggr_mode(void)
+{
+	switch (aggr_mode) {
+	case AGGR_SOCKET:
+		if (cpu_map__build_socket_map(evsel_list->cpus, &aggr_map)) {
+			perror("cannot build socket map");
+			return -1;
+		}
+		aggr_get_id = cpu_map__get_socket;
+		break;
+	case AGGR_NONE:
+	case AGGR_GLOBAL:
+	default:
+		break;
+	}
+	return 0;
+}
+
+
 /*
  * Add default attributes, if there were no attributes specified or
  * if -d/--detailed, -d -d or -d -d -d is used:
@@ -1308,7 +1341,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			   stat__set_big_num),
 	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
-	OPT_BOOLEAN('A', "no-aggr", &no_aggr, "disable CPU count aggregation"),
+	OPT_SET_UINT('A', "no-aggr", &aggr_mode,
+		    "disable CPU count aggregation", AGGR_NONE),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
 		   "print counts with custom separator"),
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
@@ -1323,7 +1357,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run after to the measured command"),
 	OPT_UINTEGER('I', "interval-print", &interval,
 		    "print counts at regular interval in ms (>= 100)"),
-	OPT_BOOLEAN(0, "aggr-socket", &aggr_socket, "aggregate counts per processor socket"),
+	OPT_SET_UINT(0, "aggr-socket", &aggr_mode,
+		     "aggregate counts per processor socket", AGGR_SOCKET),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
@@ -1403,19 +1438,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(stat_usage, options);
 
 	/* no_aggr, cgroup are for system-wide only */
-	if ((no_aggr || nr_cgroups) && !perf_target__has_cpu(&target)) {
+	if ((aggr_mode != AGGR_GLOBAL || nr_cgroups)
+	     && !perf_target__has_cpu(&target)) {
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
 		usage_with_options(stat_usage, options);
-	}
-
-	if (aggr_socket) {
-		if (!perf_target__has_cpu(&target)) {
-			fprintf(stderr, "--aggr-socket only available in system-wide mode (-a)\n");
-			usage_with_options(stat_usage, options);
-		}
-		no_aggr = true;
+		return -1;
 	}
 
 	if (add_default_attributes())
@@ -1450,6 +1479,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 	}
 
+	if (perf_stat_init_aggr_mode())
+		goto out;
+
 	/*
 	 * We dont want to block the signals - that would cause
 	 * child tasks to inherit that and Ctrl-C would not work.
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index f817046..7bb8e87 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -4,6 +4,7 @@
 #include "cpumap.h"
 #include <assert.h>
 #include <stdio.h>
+#include <stdlib.h>
 
 static struct cpu_map *cpu_map__default_new(void)
 {
@@ -219,7 +220,7 @@ int cpu_map__get_socket(struct cpu_map *map, int idx)
 	if (!mnt)
 		return -1;
 
-	sprintf(path,
+	snprintf(path, PATH_MAX,
 		"%s/devices/system/cpu/cpu%d/topology/physical_package_id",
 		mnt, cpu);
 
@@ -231,27 +232,42 @@ int cpu_map__get_socket(struct cpu_map *map, int idx)
 	return ret == 1 ? cpu : -1;
 }
 
-int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp)
+static int cmp_ids(const void *a, const void *b)
 {
-	struct cpu_map *sock;
+	return *(int *)a - *(int *)b;
+}
+
+static int cpu_map__build_map(struct cpu_map *cpus, struct cpu_map **res,
+			      int (*f)(struct cpu_map *map, int cpu))
+{
+	struct cpu_map *c;
 	int nr = cpus->nr;
 	int cpu, s1, s2;
 
-	sock = calloc(1, sizeof(*sock) + nr * sizeof(int));
-	if (!sock)
+	/* allocate as much as possible */
+	c = calloc(1, sizeof(*c) + nr * sizeof(int));
+	if (!c)
 		return -1;
 
 	for (cpu = 0; cpu < nr; cpu++) {
-		s1 = cpu_map__get_socket(cpus, cpu);
-		for (s2 = 0; s2 < sock->nr; s2++) {
-			if (s1 == sock->map[s2])
+		s1 = f(cpus, cpu);
+		for (s2 = 0; s2 < c->nr; s2++) {
+			if (s1 == c->map[s2])
 				break;
 		}
-		if (s2 == sock->nr) {
-			sock->map[sock->nr] = s1;
-			sock->nr++;
+		if (s2 == c->nr) {
+			c->map[c->nr] = s1;
+			c->nr++;
 		}
 	}
-	*sockp = sock;
+	/* ensure we process id in increasing order */
+	qsort(c->map, c->nr, sizeof(int), cmp_ids);
+
+	*res = c;
 	return 0;
 }
+
+int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp)
+{
+	return cpu_map__build_map(cpus, sockp, cpu_map__get_socket);
+}
-- 
1.7.9.5

