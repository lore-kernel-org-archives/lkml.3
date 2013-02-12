Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364Ab3BLOKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:10:42 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:36525 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760153Ab3BLOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:10:39 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 2/2] perf stat: add per-core aggregation
Date: Tue, 12 Feb 2013 15:09:28 +0100
Message-Id: <1360678168-6974-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360678168-6974-1-git-send-email-eranian@google.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the --aggr-core option to perf stat.

This option is used to aggregate system-wide counts
on a per physical core basis. On processors with
hyperthreading, this means counts of all HT threads
running on a physical core are aggregated.

This mode is useful to find imblance between physical
cores running an uniform workload. Cores are identified
by socket: S0-C1, means physical core 1 on socket 0. Note
that cores are identified using their physical core id,
thus their numbering may not be continuous.

Per core aggregation can be combined with interval printing:

 # perf stat -a --aggr-core -I 1000 -e cycles sleep 1000
 #           time core         cpus             counts events
      1.000090030 S0-C0           1          4,765,747 cycles
      1.000090030 S0-C1           1          5,580,647 cycles
      1.000090030 S0-C2           1            221,181 cycles
      1.000090030 S0-C3           1            266,092 cycles

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-stat.txt |    6 +++++
 tools/perf/builtin-stat.c              |   37 ++++++++++++++++++++-----
 tools/perf/util/cpumap.c               |   46 ++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h               |   12 +++++++++
 4 files changed, 95 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index faf4f4f..d96408f 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -126,6 +126,12 @@ use --aggr-socket in addition to -a. (system-wide).  The output includes the
 socket number and the number of online processors on that socket. This is
 useful to gauge the amount of aggregation.
 
+--aggr-core::
+Aggregate counts per physical processor for system-wide mode measurements.  This
+is a useful mode to detect imbalance between physical cores.  To enable this mode,
+use --aggr-core in addition to -a. (system-wide).  The output includes the
+core number and the number of online logical processors on that physical processor.
+
 EXAMPLES
 --------
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a19f8d5..2a62ee7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -80,6 +80,7 @@ enum aggr_mode {
 	AGGR_NONE,
 	AGGR_GLOBAL,
 	AGGR_SOCKET,
+	AGGR_CORE,
 };
 
 static int			run_count			=  1;
@@ -326,6 +327,9 @@ static void print_interval(void)
 		case AGGR_SOCKET:
 			fprintf(output, "#           time socket cpus             counts events\n");
 			break;
+		case AGGR_CORE:
+			fprintf(output, "#           time core         cpus             counts events\n");
+			break;
 		case AGGR_NONE:
 			fprintf(output, "#           time CPU                 counts events\n");
 			break;
@@ -339,6 +343,7 @@ static void print_interval(void)
 		num_print_interval = 0;
 
 	switch (aggr_mode) {
+	case AGGR_CORE:
 	case AGGR_SOCKET:
 		print_aggr(prefix);
 		break;
@@ -553,13 +558,23 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
-static void aggr_printout(int cpu, int nr)
+static void aggr_printout(struct perf_evsel *evsel, int id, int nr)
 {
 	switch (aggr_mode) {
+	case AGGR_CORE:
+		fprintf(output, "S%d-C%*d%s%*d%s",
+			cpu_map__id_to_socket(id),
+			csv_output ? 0 : -8,
+			cpu_map__id_to_cpu(id),
+			csv_sep,
+			csv_output ? 0 : 4,
+			nr,
+			csv_sep);
+		break;
 	case AGGR_SOCKET:
 		fprintf(output, "S%*d%s%*d%s",
 			csv_output ? 0 : -5,
-			cpu,
+			id,
 			csv_sep,
 			csv_output ? 0 : 4,
 			nr,
@@ -568,7 +583,7 @@ static void aggr_printout(int cpu, int nr)
 	case AGGR_NONE:
 		fprintf(output, "CPU%*d%s",
 			csv_output ? 0 : -4,
-			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
+			perf_evsel__cpus(evsel)->map[id], csv_sep);
 		break;
 	case AGGR_GLOBAL:
 	default:
@@ -581,7 +596,7 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	double msecs = avg / 1e6;
 	const char *fmt = csv_output ? "%.6f%s%s" : "%18.6f%s%-25s";
 
-	aggr_printout(cpu, nr);
+	aggr_printout(evsel, cpu, nr);
 
 	fprintf(output, fmt, msecs, csv_sep, perf_evsel__name(evsel));
 
@@ -789,7 +804,7 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	else
 		fmt = "%18.0f%s%-25s";
 
-	aggr_printout(cpu, nr);
+	aggr_printout(evsel, cpu, nr);
 
 	if (aggr_mode == AGGR_GLOBAL)
 		cpu = 0;
@@ -920,7 +935,7 @@ static void print_aggr(char *prefix)
 				fprintf(output, "%s", prefix);
 
 			if (run == 0 || ena == 0) {
-				aggr_printout(cpu, nr);
+				aggr_printout(counter, cpu, nr);
 
 				fprintf(output, "%*s%s%*s",
 					csv_output ? 0 : 18,
@@ -1082,6 +1097,7 @@ static void print_stat(int argc, const char **argv)
 	}
 
 	switch (aggr_mode) {
+	case AGGR_CORE:
 	case AGGR_SOCKET:
 		print_aggr(NULL);
 		break;
@@ -1150,6 +1166,13 @@ static int perf_stat_init_aggr_mode(void)
 		}
 		aggr_get_id = cpu_map__get_socket;
 		break;
+	case AGGR_CORE:
+		if (cpu_map__build_core_map(evsel_list->cpus, &aggr_map)) {
+			perror("cannot build core map");
+			return -1;
+		}
+		aggr_get_id = cpu_map__get_core;
+		break;
 	case AGGR_NONE:
 	case AGGR_GLOBAL:
 	default:
@@ -1359,6 +1382,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "print counts at regular interval in ms (>= 100)"),
 	OPT_SET_UINT(0, "aggr-socket", &aggr_mode,
 		     "aggregate counts per processor socket", AGGR_SOCKET),
+	OPT_SET_UINT(0, "aggr-core", &aggr_mode,
+		     "aggregate counts per physical processor core", AGGR_CORE),
 	OPT_END()
 	};
 	const char * const stat_usage[] = {
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 7bb8e87..beb8cf9 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -267,7 +267,53 @@ static int cpu_map__build_map(struct cpu_map *cpus, struct cpu_map **res,
 	return 0;
 }
 
+int cpu_map__get_core(struct cpu_map *map, int idx)
+{
+	FILE *fp;
+	const char *mnt;
+	char path[PATH_MAX];
+	int cpu, ret, s;
+
+	if (idx > map->nr)
+		return -1;
+
+	cpu = map->map[idx];
+
+	mnt = sysfs_find_mountpoint();
+	if (!mnt)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		"%s/devices/system/cpu/cpu%d/topology/core_id",
+		mnt, cpu);
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -1;
+	ret = fscanf(fp, "%d", &cpu);
+	fclose(fp);
+	if (ret != 1)
+		return -1;
+
+	s = cpu_map__get_socket(map, idx);
+	if (s == -1)
+		return -1;
+
+	/*
+	 * encode socket in upper 16 bits
+	 * core_id is relative to socket, and
+	 * we need a global id. So we combine
+	 * socket + core id
+	 */
+	return (s << 16) | (cpu & 0xffff);
+}
+
 int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp)
 {
 	return cpu_map__build_map(cpus, sockp, cpu_map__get_socket);
 }
+
+int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep)
+{
+	return cpu_map__build_map(cpus, corep, cpu_map__get_core);
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 161b007..9bed02e 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -15,7 +15,9 @@ void cpu_map__delete(struct cpu_map *map);
 struct cpu_map *cpu_map__read(FILE *file);
 size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
 int cpu_map__get_socket(struct cpu_map *map, int idx);
+int cpu_map__get_core(struct cpu_map *map, int idx);
 int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp);
+int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep);
 
 static inline int cpu_map__socket(struct cpu_map *sock, int s)
 {
@@ -24,6 +26,16 @@ static inline int cpu_map__socket(struct cpu_map *sock, int s)
 	return sock->map[s];
 }
 
+static inline int cpu_map__id_to_socket(int id)
+{
+	return id >> 16;
+}
+
+static inline int cpu_map__id_to_cpu(int id)
+{
+	return id & 0xffff;
+}
+
 static inline int cpu_map__nr(const struct cpu_map *map)
 {
 	return map ? map->nr : 1;
-- 
1.7.9.5

