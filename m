Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3JaPAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:00:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40818 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab3JaPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:00:00 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: [PATCH v4 2/4] perf stat: add event unit and scale support
Date: Thu, 31 Oct 2013 15:59:40 +0100
Message-Id: <1383231582-15856-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383231582-15856-1-git-send-email-eranian@google.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds perf stat support fo rhandling event units and
scales as exported by the kernel.

The kernel can export PMU events actual unit and scaling factor
via sysfs:
$ ls -1 /sys/devices/power/events/energy-*
/sys/devices/power/events/energy-cores
/sys/devices/power/events/energy-cores.scale
/sys/devices/power/events/energy-cores.unit
/sys/devices/power/events/energy-pkg
/sys/devices/power/events/energy-pkg.scale
/sys/devices/power/events/energy-pkg.unit
$ cat /sys/devices/power/events/energy-cores.scale
2.3e-10
$ cat cat /sys/devices/power/events/energy-cores.unit
Joules

This patch modifies the pmu event alias code to check
for the presence of the .unit and .scale files to load
the corresponding values. They are then used by perf stat
transparentely:

 # perf stat -a -e power/energy-pkg/,power/energy-cores/,cycles -I 1000 sleep 1000
 #          time             counts   unit events
     1.000214717               3.07 Joules power/energy-pkg/         [100.00%]
     1.000214717               0.53 Joules power/energy-cores/
     1.000214717           12965028      ? cycles                    [100.00%]
     2.000749289               3.01 Joules power/energy-pkg/
     2.000749289               0.52 Joules power/energy-cores/
     2.000749289           15817043      ? cycles

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c      |   72 ++++++++++++-----
 tools/perf/util/evsel.c        |    2 +
 tools/perf/util/evsel.h        |    3 +
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/pmu.c          |  170 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/pmu.h          |    3 +
 6 files changed, 230 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1a9c95d..43dea3b 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -138,6 +138,7 @@ static const char		*post_cmd			= NULL;
 static bool			sync_run			= false;
 static unsigned int		interval			= 0;
 static unsigned int		initial_delay			= 0;
+static unsigned int		unit_width			= 4; /* strlen("unit") */
 static bool			forever				= false;
 static struct timespec		ref_time;
 static struct cpu_map		*aggr_map;
@@ -462,17 +463,17 @@ static void print_interval(void)
 	if (num_print_interval == 0 && !csv_output) {
 		switch (aggr_mode) {
 		case AGGR_SOCKET:
-			fprintf(output, "#           time socket cpus             counts events\n");
+			fprintf(output, "#           time socket cpus             counts  %*s events\n", unit_width, "unit");
 			break;
 		case AGGR_CORE:
-			fprintf(output, "#           time core         cpus             counts events\n");
+			fprintf(output, "#           time core         cpus             counts %*s events\n", unit_width, "unit");
 			break;
 		case AGGR_NONE:
-			fprintf(output, "#           time CPU                 counts events\n");
+			fprintf(output, "#           time CPU                counts %*s events\n", unit_width, "unit");
 			break;
 		case AGGR_GLOBAL:
 		default:
-			fprintf(output, "#           time             counts events\n");
+			fprintf(output, "#           time             counts %*s events\n", unit_width, "unit");
 		}
 	}
 
@@ -517,6 +518,7 @@ static int __run_perf_stat(int argc, const char **argv)
 	unsigned long long t0, t1;
 	struct perf_evsel *counter;
 	struct timespec ts;
+	size_t l;
 	int status = 0;
 	const bool forks = (argc > 0);
 
@@ -566,6 +568,10 @@ static int __run_perf_stat(int argc, const char **argv)
 			return -1;
 		}
 		counter->supported = true;
+
+		l = strlen(counter->unit);
+		if (l > unit_width)
+			unit_width = l;
 	}
 
 	if (perf_evlist__apply_filters(evsel_list)) {
@@ -911,19 +917,32 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	double total, ratio = 0.0, total2;
 	const char *fmt;
 
-	if (csv_output)
-		fmt = "%.0f%s%s";
-	else if (big_num)
-		fmt = "%'18.0f%s%-25s";
-	else
-		fmt = "%18.0f%s%-25s";
+	if (csv_output) {
+		if (evsel->scale != 1.0)
+			fmt = "%.2f%s%s%s%s";
+		else
+			fmt = "%.0f%s%s%s%s";
+	} else if (big_num)
+		if (evsel->scale != 1.0)
+			fmt = "%'18.2f%s%-*s%s%-25s";
+		else
+			fmt = "%'18.0f%s%-*s%s%-25s";
+	else {
+		if (evsel->scale != 1.0)
+			fmt = "%18.2f%s%-*s%s%-25s";
+		else
+			fmt = "%18.0f%s%-*s%s%-25s";
+	}
 
 	aggr_printout(evsel, cpu, nr);
 
 	if (aggr_mode == AGGR_GLOBAL)
 		cpu = 0;
 
-	fprintf(output, fmt, avg, csv_sep, perf_evsel__name(evsel));
+	if (csv_output)
+		fprintf(output, fmt, avg, csv_sep, evsel->unit, csv_sep, perf_evsel__name(evsel));
+	else
+		fprintf(output, fmt, avg, csv_sep, unit_width, evsel->unit, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -1062,6 +1081,7 @@ static void print_aggr(char *prefix)
 {
 	struct perf_evsel *counter;
 	int cpu, cpu2, s, s2, id, nr;
+	double uval;
 	u64 ena, run, val;
 
 	if (!(aggr_map || aggr_get_id))
@@ -1088,9 +1108,13 @@ static void print_aggr(char *prefix)
 			if (run == 0 || ena == 0) {
 				aggr_printout(counter, id, nr);
 
-				fprintf(output, "%*s%s%*s",
+				fprintf(output, "%*s%s%*s%s%*s",
 					csv_output ? 0 : 18,
 					counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
+
+					csv_sep,
+					csv_output ? 0 : -10,
+					counter->unit,
 					csv_sep,
 					csv_output ? 0 : -24,
 					perf_evsel__name(counter));
@@ -1102,11 +1126,12 @@ static void print_aggr(char *prefix)
 				fputc('\n', output);
 				continue;
 			}
+			uval = val * counter->scale;
 
 			if (nsec_counter(counter))
-				nsec_printout(id, nr, counter, val);
+				nsec_printout(id, nr, counter, uval);
 			else
-				abs_printout(id, nr, counter, val);
+				abs_printout(id, nr, counter, uval);
 
 			if (!csv_output) {
 				print_noise(counter, 1.0);
@@ -1129,6 +1154,7 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 	struct perf_stat *ps = counter->priv;
 	double avg = avg_stats(&ps->res_stats[0]);
 	int scaled = counter->counts->scaled;
+	double uval;
 
 	if (prefix)
 		fprintf(output, "%s", prefix);
@@ -1148,10 +1174,12 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 		return;
 	}
 
+	uval = avg * counter->scale;
+
 	if (nsec_counter(counter))
-		nsec_printout(-1, 0, counter, avg);
+		nsec_printout(-1, 0, counter, uval);
 	else
-		abs_printout(-1, 0, counter, avg);
+		abs_printout(-1, 0, counter, uval);
 
 	print_noise(counter, avg);
 
@@ -1178,6 +1206,7 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 static void print_counter(struct perf_evsel *counter, char *prefix)
 {
 	u64 ena, run, val;
+	double uval;
 	int cpu;
 
 	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
@@ -1189,12 +1218,15 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 			fprintf(output, "%s", prefix);
 
 		if (run == 0 || ena == 0) {
-			fprintf(output, "CPU%*d%s%*s%s%*s",
+			fprintf(output, "CPU%*d%s%*s%s%*s%s%*s",
 				csv_output ? 0 : -4,
 				perf_evsel__cpus(counter)->map[cpu], csv_sep,
 				csv_output ? 0 : 18,
 				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 				csv_sep,
+				csv_output ? 0 : -10,
+				counter->unit,
+				csv_sep,
 				csv_output ? 0 : -24,
 				perf_evsel__name(counter));
 
@@ -1206,10 +1238,12 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 			continue;
 		}
 
+		uval = val * counter->scale;
+
 		if (nsec_counter(counter))
-			nsec_printout(cpu, 0, counter, val);
+			nsec_printout(cpu, 0, counter, uval);
 		else
-			abs_printout(cpu, 0, counter, val);
+			abs_printout(cpu, 0, counter, uval);
 
 		if (!csv_output) {
 			print_noise(counter, 1.0);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3a334f0..867971b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -162,6 +162,8 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
 	evsel->leader	   = evsel;
+	evsel->unit	   = "?";
+	evsel->scale	   = 1.0;
 	INIT_LIST_HEAD(&evsel->node);
 	hists__init(&evsel->hists);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 5aa68cd..d5c6606 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -68,6 +68,8 @@ struct perf_evsel {
 	u32			ids;
 	struct hists		hists;
 	char			*name;
+	double			scale;
+	const char		*unit;
 	struct event_format	*tp_format;
 	union {
 		void		*priv;
@@ -130,6 +132,7 @@ extern const char *perf_evsel__sw_names[PERF_COUNT_SW_MAX];
 int __perf_evsel__hw_cache_type_op_res_name(u8 type, u8 op, u8 result,
 					    char *bf, size_t size);
 const char *perf_evsel__name(struct perf_evsel *evsel);
+
 const char *perf_evsel__group_name(struct perf_evsel *evsel);
 int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c90e55c..be7eba8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -838,6 +838,7 @@ int parse_events_name(struct list_head *list, char *name)
 	list_for_each_entry(evsel, list, node) {
 		if (!evsel->name)
 			evsel->name = strdup(name);
+		pmu_get_event_unit_scale(evsel);
 	}
 
 	return 0;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 64362fe..e18ef87 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -4,6 +4,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <dirent.h>
+#include <locale.h>
 #include "sysfs.h"
 #include "util.h"
 #include "pmu.h"
@@ -14,6 +15,8 @@ struct perf_pmu_alias {
 	char *name;
 	struct list_head terms;
 	struct list_head list;
+	char *unit;
+	double scale;
 };
 
 struct perf_pmu_format {
@@ -95,7 +98,89 @@ static int pmu_format(const char *name, struct list_head *format)
 	return 0;
 }
 
-static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
+static int perf_pmu__parse_scale(struct perf_pmu_alias *alias, char *dir, char *name)
+{
+	struct stat st;
+	ssize_t sret;
+	char scale[128];
+	int fd, ret = -1;
+	char path[PATH_MAX];
+	char *lc;
+
+	snprintf(path, PATH_MAX, "%s/%s.scale", dir, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	if (fstat(fd, &st) < 0)
+		goto error;
+
+	sret = read(fd, scale, sizeof(scale)-1);
+	if (sret < 0)
+		goto error;
+
+	scale[sret] = '\0';
+	/*
+	 * save current locale
+	 */
+	lc = setlocale(LC_NUMERIC, NULL);
+
+	/*
+	 * force to C locale to ensure kernel
+	 * scale string is converted correctly.
+	 * kernel uses default C locale.
+	 */
+	setlocale(LC_NUMERIC, "C");
+
+	alias->scale = strtod(scale, NULL);
+
+	/* restore locale */
+	setlocale(LC_NUMERIC, lc);
+
+	ret = 0;
+error:
+	close(fd);
+	return ret;
+}
+
+static int perf_pmu__parse_unit(struct perf_pmu_alias *alias, char *dir, char *name)
+{
+	struct stat st;
+	ssize_t sret;
+	int fd;
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "%s/%s.unit", dir, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	if (fstat(fd, &st) < 0)
+		goto error;
+
+	alias->unit = malloc(st.st_size + 1);
+	if (!alias->unit)
+		goto error;
+
+	sret = read(fd, alias->unit, st.st_size);
+	if (sret < 0)
+		goto error;
+
+	close(fd);
+
+	alias->unit[sret] = '\0';
+
+	return 0;
+error:
+	close(fd);
+	free(alias->unit);
+	alias->unit = NULL;
+	return -1;
+}
+
+static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FILE *file)
 {
 	struct perf_pmu_alias *alias;
 	char buf[256];
@@ -111,6 +196,9 @@ static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&alias->terms);
+	alias->scale = 1.0;
+	alias->unit = NULL;
+
 	ret = parse_events_terms(&alias->terms, buf);
 	if (ret) {
 		free(alias);
@@ -118,7 +206,14 @@ static int perf_pmu__new_alias(struct list_head *list, char *name, FILE *file)
 	}
 
 	alias->name = strdup(name);
+	/*
+	 * load unit name and scale if available
+	 */
+	perf_pmu__parse_unit(alias, dir, name);
+	perf_pmu__parse_scale(alias, dir, name);
+
 	list_add_tail(&alias->list, list);
+
 	return 0;
 }
 
@@ -130,6 +225,7 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 {
 	struct dirent *evt_ent;
 	DIR *event_dir;
+	size_t len;
 	int ret = 0;
 
 	event_dir = opendir(dir);
@@ -144,13 +240,24 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 		if (!strcmp(name, ".") || !strcmp(name, ".."))
 			continue;
 
+		/*
+		 * skip .unit and .scale info files
+		 * parsed in perf_pmu__new_alias()
+		 */
+		len = strlen(name);
+		if (len > 5 && !strcmp(name + len - 5, ".unit"))
+			continue;
+		if (len > 6 && !strcmp(name + len - 6, ".scale"))
+			continue;
+
 		snprintf(path, PATH_MAX, "%s/%s", dir, name);
 
 		ret = -EINVAL;
 		file = fopen(path, "r");
 		if (!file)
 			break;
-		ret = perf_pmu__new_alias(head, name, file);
+
+		ret = perf_pmu__new_alias(head, dir, name, file);
 		fclose(file);
 	}
 
@@ -653,3 +760,62 @@ bool pmu_have_event(const char *pname, const char *name)
 	}
 	return false;
 }
+
+static const char *pmu_event_unit(struct perf_pmu *pmu, const char *name)
+{
+	struct perf_pmu_alias *alias;
+	char buf[1024];
+	char *fname;
+	const char *unit = "?";
+
+	if (!name)
+		return unit;
+
+	list_for_each_entry(alias, &pmu->aliases, list) {
+		fname = format_alias(buf, sizeof(buf), pmu, alias);
+		if (!strcmp(fname, name)) {
+			unit = alias->unit;
+			break;
+		}
+	}
+	return unit;
+}
+
+static double pmu_event_scale(struct perf_pmu *pmu, const char *name)
+{
+	struct perf_pmu_alias *alias;
+	char buf[1024];
+	char *fname;
+	double scale = 1.0;
+
+	if (!name)
+		return 1.0;
+
+	list_for_each_entry(alias, &pmu->aliases, list) {
+		fname = format_alias(buf, sizeof(buf), pmu, alias);
+		if (!strcmp(fname, name)) {
+			scale = alias->scale;
+			break;
+		}
+	}
+	return scale;
+}
+
+int pmu_get_event_unit_scale(struct perf_evsel *evsel)
+{
+	__u32 type = evsel->attr.type;
+	struct perf_pmu *pmu;
+
+	if (!evsel->name)
+		return -1;
+
+	list_for_each_entry(pmu, &pmus, list) {
+		if (pmu->type == type)
+			goto found;
+	}
+	return -1;
+found:
+	evsel->unit  = pmu_event_unit(pmu, evsel->name);
+	evsel->scale = pmu_event_scale(pmu, evsel->name);
+	return 0;
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 1179b26..6bf23b2 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -4,6 +4,7 @@
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
 #include <stdbool.h>
+#include "util/evsel.h"
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
@@ -45,4 +46,6 @@ void print_pmu_events(const char *event_glob, bool name_only);
 bool pmu_have_event(const char *pname, const char *name);
 
 int perf_pmu__test(void);
+
+int pmu_get_event_unit_scale(struct perf_evsel *evsel);
 #endif /* __PMU_H */
-- 
1.7.9.5

