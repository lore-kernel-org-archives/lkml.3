Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3BFOq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:46:28 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61182 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3BFOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:46:22 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 2/2] perf stat: add per processor socket count aggregation
Date: Wed,  6 Feb 2013 15:46:02 +0100
Message-Id: <1360161962-9675-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360161962-9675-1-git-send-email-eranian@google.com>
References: <1360161962-9675-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds per-processor socket count aggregation
for system-wide mode measurements. This is a useful
mode to detect imbalance between sockets.

To enable this mode, use --aggr-socket in addition
to -a. (system-wide).

The output includes the socket number and the number
of online processors on that socket. This is useful
to gauge the amount of aggregation.

 # ./perf stat -I 1000 -a --aggr-socket -e cycles sleep 2
 #           time socket cpus             counts events
      1.000097680 S0        4          5,788,785 cycles
      2.000379943 S0        4         27,361,546 cycles
      2.001167808 S0        4            818,275 cycles

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c |  126 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 115 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0368a10..9984876 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -68,6 +68,7 @@
 static void print_stat(int argc, const char **argv);
 static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
 static void print_counter(struct perf_evsel *counter, char *prefix);
+static void print_aggr_socket(char *prefix);
 
 static struct perf_evlist	*evsel_list;
 
@@ -79,6 +80,7 @@ static int			run_count			=  1;
 static bool			no_inherit			= false;
 static bool			scale				=  true;
 static bool			no_aggr				= false;
+static bool			aggr_socket			= false;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
@@ -93,6 +95,7 @@ static const char		*post_cmd			= NULL;
 static bool			sync_run			= false;
 static unsigned int		interval			= 0;
 static struct timespec		ref_time;
+static struct cpu_map		*sock_map;
 
 static volatile int done = 0;
 
@@ -312,7 +315,9 @@ static void print_interval(void)
 	sprintf(prefix, "%6lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
 
 	if (num_print_interval == 0 && !csv_output) {
-		if (no_aggr)
+		if (aggr_socket)
+			fprintf(output, "#           time socket cpus             counts events\n");
+		else if (no_aggr)
 			fprintf(output, "#           time CPU                 counts events\n");
 		else
 			fprintf(output, "#           time             counts events\n");
@@ -321,7 +326,9 @@ static void print_interval(void)
 	if (++num_print_interval == 25)
 		num_print_interval = 0;
 
-	if (no_aggr) {
+	if (aggr_socket)
+		print_aggr_socket(prefix);
+	else if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter(counter, prefix);
 	} else {
@@ -349,6 +356,12 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 		ts.tv_nsec = 0;
 	}
 
+	if (aggr_socket
+	    && cpu_map__build_socket_map(evsel_list->cpus, &sock_map)) {
+		perror("cannot build socket map");
+		return -1;
+	}
+
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		return -1;
@@ -529,13 +542,21 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
-static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
+static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
 	const char *fmt = csv_output ? "%s%.6f%s%s" : "%s%18.6f%s%-25s";
 
-	if (no_aggr)
+	if (aggr_socket)
+		sprintf(cpustr, "S%*d%s%*d%s",
+			csv_output ? 0 : -5,
+			cpu,
+			csv_sep,
+			csv_output ? 0 : 4,
+			nr,
+			csv_sep);
+	else if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
 			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
@@ -734,7 +755,7 @@ static void print_ll_cache_misses(int cpu,
 	fprintf(output, " of all LL-cache hits   ");
 }
 
-static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
+static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
@@ -747,7 +768,15 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		fmt = "%s%18.0f%s%-25s";
 
-	if (no_aggr)
+	if (aggr_socket)
+		sprintf(cpustr, "S%*d%s%*d%s",
+			csv_output ? 0 : -5,
+			cpu,
+			csv_sep,
+			csv_output ? 0 : 4,
+			nr,
+			csv_sep);
+	else if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
 			csv_output ? 0 : -4,
 			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
@@ -853,6 +882,70 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	}
 }
 
+static void print_aggr_socket(char *prefix)
+{
+	struct perf_evsel *counter;
+	u64 ena, run, val;
+	int cpu, s, s2, sock, nr;
+
+	if (!sock_map)
+		return;
+
+	for (s = 0; s < sock_map->nr; s++) {
+		sock = cpu_map__socket(sock_map, s);
+		list_for_each_entry(counter, &evsel_list->entries, node) {
+			val = ena = run = 0;
+			nr = 0;
+			for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
+				s2 = cpu_map__get_socket(evsel_list->cpus, cpu);
+				if (s2 != sock)
+					continue;
+				val += counter->counts->cpu[cpu].val;
+				ena += counter->counts->cpu[cpu].ena;
+				run += counter->counts->cpu[cpu].run;
+				nr++;
+			}
+			if (prefix)
+				fprintf(output, "%s", prefix);
+
+			if (run == 0 || ena == 0) {
+				fprintf(output, "S%*d%s%*d%s%*s%s%*s",
+					csv_output ? 0 : -5,
+					s,
+					csv_sep,
+					csv_output ? 0 : 4,
+					nr,
+					csv_sep,
+					csv_output ? 0 : 18,
+					counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
+					csv_sep,
+					csv_output ? 0 : -24,
+					perf_evsel__name(counter));
+				if (counter->cgrp)
+					fprintf(output, "%s%s",
+						csv_sep, counter->cgrp->name);
+
+				fputc('\n', output);
+				continue;
+			}
+
+			if (nsec_counter(counter))
+				nsec_printout(sock, nr, counter, val);
+			else
+				abs_printout(sock, nr, counter, val);
+
+			if (!csv_output) {
+				print_noise(counter, 1.0);
+
+				if (run != ena)
+					fprintf(output, "  (%.2f%%)",
+						100.0 * run / ena);
+			}
+			fputc('\n', output);
+		}
+	}
+}
+
 /*
  * Print out the results of a single counter:
  * aggregated counts in system-wide mode
@@ -882,9 +975,9 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(-1, counter, avg);
+		nsec_printout(-1, 0, counter, avg);
 	else
-		abs_printout(-1, counter, avg);
+		abs_printout(-1, 0, counter, avg);
 
 	print_noise(counter, avg);
 
@@ -940,9 +1033,9 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 		}
 
 		if (nsec_counter(counter))
-			nsec_printout(cpu, counter, val);
+			nsec_printout(cpu, 0, counter, val);
 		else
-			abs_printout(cpu, counter, val);
+			abs_printout(cpu, 0, counter, val);
 
 		if (!csv_output) {
 			print_noise(counter, 1.0);
@@ -980,7 +1073,9 @@ static void print_stat(int argc, const char **argv)
 		fprintf(output, ":\n\n");
 	}
 
-	if (no_aggr) {
+	if (aggr_socket)
+		print_aggr_socket(NULL);
+	else if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter(counter, NULL);
 	} else {
@@ -1228,6 +1323,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 			"command to run after to the measured command"),
 	OPT_UINTEGER('I', "interval-print", &interval,
 		    "print counts at regular interval in ms (>= 100)"),
+	OPT_BOOLEAN(0, "aggr-socket", &aggr_socket, "aggregate counts per processor socket"),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
@@ -1314,6 +1410,14 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(stat_usage, options);
 	}
 
+	if (aggr_socket) {
+		if (!perf_target__has_cpu(&target)) {
+			fprintf(stderr, "--aggr-socket only available in system-wide mode (-a)\n");
+			usage_with_options(stat_usage, options);
+		}
+		no_aggr = true;
+	}
+
 	if (add_default_attributes())
 		goto out;
 
-- 
1.7.9.5

