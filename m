Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144Ab3DBJe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:34:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50747 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab3DBJeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:34:24 -0400
Date: Tue, 2 Apr 2013 02:33:36 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-86ee6e18f6cb43ab0cb67347bda5b6f5b016121d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1360846649-6411-2-git-send-email-eranian@google.com>
References: <1360846649-6411-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Refactor aggregation code
Git-Commit-ID: 86ee6e18f6cb43ab0cb67347bda5b6f5b016121d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:33:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86ee6e18f6cb43ab0cb67347bda5b6f5b016121d
Gitweb:     http://git.kernel.org/tip/86ee6e18f6cb43ab0cb67347bda5b6f5b016121d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 14 Feb 2013 13:57:27 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Mar 2013 15:29:53 -0300

perf stat: Refactor aggregation code

Refactor aggregation code by introducing a single aggr_mode variable and an
enum for aggregation.

Also refactor cpumap code having to do with cpu to socket mappings. All in
preparation for extended modes, such as cpu -> core.

Also fix socket aggregation and ensure that sockets are printed in increasing
order.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1360846649-6411-2-git-send-email-eranian@google.com
[ committer note: Fixup conflicts with a7e191c "--repeat forever" and
  acf2892 "Use perf_evlist__prepare/start_workload()" ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 207 ++++++++++++++++++++++++++--------------------
 tools/perf/util/cpumap.c  |  40 ++++++---
 2 files changed, 147 insertions(+), 100 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ba0bdd8..ded34fc 100644
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
@@ -96,7 +101,8 @@ static bool			sync_run			= false;
 static unsigned int		interval			= 0;
 static bool			forever				= false;
 static struct timespec		ref_time;
-static struct cpu_map		*sock_map;
+static struct cpu_map		*aggr_map;
+static int			(*aggr_get_id)(struct cpu_map *m, int cpu);
 
 static volatile int done = 0;
 
@@ -355,41 +361,51 @@ static void print_interval(void)
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
@@ -412,12 +428,6 @@ static int __run_perf_stat(int argc, const char **argv)
 		ts.tv_nsec = 0;
 	}
 
-	if (aggr_socket
-	    && cpu_map__build_socket_map(evsel_list->cpus, &sock_map)) {
-		perror("cannot build socket map");
-		return -1;
-	}
-
 	if (forks) {
 		if (perf_evlist__prepare_workload(evsel_list, &target, argv,
 						  false, false) < 0) {
@@ -493,17 +503,17 @@ static int __run_perf_stat(int argc, const char **argv)
 
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
 					     thread_map__nr(evsel_list->threads));
 		}
+	} else {
+		list_for_each_entry(counter, &evsel_list->entries, node) {
+			read_counter(counter);
+			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter), 1);
+		}
 	}
 
 	return WEXITSTATUS(status);
@@ -556,26 +566,37 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
-static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+static void aggr_printout(struct perf_evsel *evsel, int cpu, int nr)
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
+
+	aggr_printout(evsel, cpu, nr);
 
-	fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, msecs, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -772,32 +793,21 @@ static void print_ll_cache_misses(int cpu,
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
+	aggr_printout(evsel, cpu, nr);
+
+	if (aggr_mode == AGGR_GLOBAL)
 		cpu = 0;
 
-	fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, avg, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -896,23 +906,23 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
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
@@ -923,18 +933,15 @@ static void print_aggr_socket(char *prefix)
 				fprintf(output, "%s", prefix);
 
 			if (run == 0 || ena == 0) {
-				fprintf(output, "S%*d%s%*d%s%*s%s%*s",
-					csv_output ? 0 : -5,
-					s,
-					csv_sep,
-					csv_output ? 0 : 4,
-					nr,
-					csv_sep,
+				aggr_printout(counter, cpu, nr);
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
@@ -944,9 +951,9 @@ static void print_aggr_socket(char *prefix)
 			}
 
 			if (nsec_counter(counter))
-				nsec_printout(sock, nr, counter, val);
+				nsec_printout(id, nr, counter, val);
 			else
-				abs_printout(sock, nr, counter, val);
+				abs_printout(id, nr, counter, val);
 
 			if (!csv_output) {
 				print_noise(counter, 1.0);
@@ -1087,14 +1094,20 @@ static void print_stat(int argc, const char **argv)
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
@@ -1140,6 +1153,25 @@ static int stat__set_big_num(const struct option *opt __maybe_unused,
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
@@ -1322,7 +1354,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			   stat__set_big_num),
 	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
-	OPT_BOOLEAN('A', "no-aggr", &no_aggr, "disable CPU count aggregation"),
+	OPT_SET_UINT('A', "no-aggr", &aggr_mode,
+		    "disable CPU count aggregation", AGGR_NONE),
 	OPT_STRING('x', "field-separator", &csv_sep, "separator",
 		   "print counts with custom separator"),
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
@@ -1337,7 +1370,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run after to the measured command"),
 	OPT_UINTEGER('I', "interval-print", &interval,
 		    "print counts at regular interval in ms (>= 100)"),
-	OPT_BOOLEAN(0, "aggr-socket", &aggr_socket, "aggregate counts per processor socket"),
+	OPT_SET_UINT(0, "aggr-socket", &aggr_mode,
+		     "aggregate counts per processor socket", AGGR_SOCKET),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
@@ -1420,19 +1454,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
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
@@ -1458,6 +1486,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (perf_evlist__alloc_stats(evsel_list, interval))
 		goto out_free_maps;
 
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
