Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3LBOiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:38:17 -0500
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:54682 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab3LBOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:38:05 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, stfomichev@yandex-team.ru,
        namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Subject: [PATCH 4/5] perf timechart: add support for topology
Date: Mon,  2 Dec 2013 18:37:36 +0400
Message-Id: <1385995056-20158-5-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -t switch to sort CPUs topologically.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt |   3 +
 tools/perf/builtin-timechart.c              |  17 +++-
 tools/perf/util/svghelper.c                 | 132 +++++++++++++++++++++++++++-
 tools/perf/util/svghelper.h                 |   2 +
 4 files changed, 151 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 271dd4ed5b05..367c1be0551c 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -59,6 +59,9 @@ $ perf timechart
 -n::
 --proc-num::
         Print task info for at least given number of tasks.
+-t::
+--topology::
+        Sort CPUs according to topology.
 
 RECORD OPTIONS
 --------------
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index db9c4c172587..8bde57c5c908 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -58,7 +58,8 @@ struct timechart {
 				first_time, last_time;
 	bool			power_only,
 				tasks_only,
-				with_backtrace;
+				with_backtrace,
+				topology;
 };
 
 struct per_pidcomm;
@@ -1077,6 +1078,18 @@ static int process_header(struct perf_file_section *section __maybe_unused,
 	case HEADER_NRCPUS:
 		tchart->numcpus = ph->env.nr_cpus_avail;
 		break;
+
+	case HEADER_CPU_TOPOLOGY:
+		if (!tchart->topology)
+			break;
+
+		if (svg_build_topology_map(ph->env.sibling_cores,
+					   ph->env.nr_sibling_cores,
+					   ph->env.sibling_threads,
+					   ph->env.nr_sibling_threads))
+			fprintf(stderr, "problem building topology\n");
+		break;
+
 	default:
 		break;
 	}
@@ -1267,6 +1280,8 @@ int cmd_timechart(int argc, const char **argv,
 		    "Look for files with symbols relative to this directory"),
 	OPT_INTEGER('n', "proc-num", &tchart.proc_num,
 		    "min. number of tasks to print"),
+	OPT_BOOLEAN('t', "topology", &tchart.topology,
+		    "sort CPUs according to topology"),
 	OPT_END()
 	};
 	const char * const timechart_usage[] = {
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 927851d05d03..9468136735ca 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -17,8 +17,11 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
+#include <linux/bitops.h>
 
+#include "perf.h"
 #include "svghelper.h"
+#include "cpumap.h"
 
 static u64 first_time, last_time;
 static u64 turbo_frequency, max_freq;
@@ -39,9 +42,14 @@ static double cpu2slot(int cpu)
 	return 2 * cpu + 1;
 }
 
+static int *topology_map;
+
 static double cpu2y(int cpu)
 {
-	return cpu2slot(cpu) * SLOT_MULT;
+	if (topology_map)
+		return cpu2slot(topology_map[cpu]) * SLOT_MULT;
+	else
+		return cpu2slot(cpu) * SLOT_MULT;
 }
 
 static double time2pixels(u64 __time)
@@ -275,7 +283,7 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 		time2pixels(last_time)-time2pixels(first_time),
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
 
-	sprintf(cpu_string, "CPU %i", (int)cpu+1);
+	sprintf(cpu_string, "CPU %i", (int)cpu);
 	fprintf(svgfile, "<text x=\"%4.8f\" y=\"%4.8f\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
 
@@ -568,3 +576,123 @@ void svg_close(void)
 		svgfile = NULL;
 	}
 }
+
+#define cpumask_bits(maskp) ((maskp)->bits)
+typedef struct { DECLARE_BITMAP(bits, MAX_NR_CPUS); } cpumask_t;
+
+struct topology {
+	cpumask_t *sib_core;
+	int sib_core_nr;
+	cpumask_t *sib_thr;
+	int sib_thr_nr;
+};
+
+static void scan_thread_topology(int *map, struct topology *t, int cpu, int *pos)
+{
+	int i;
+	int thr;
+
+	for (i = 0; i < t->sib_thr_nr; i++) {
+		if (!test_bit(cpu, cpumask_bits(&t->sib_thr[i])))
+			continue;
+
+		for_each_set_bit(thr,
+				 cpumask_bits(&t->sib_thr[i]),
+				 MAX_NR_CPUS)
+			if (map[thr] == -1)
+				map[thr] = (*pos)++;
+	}
+}
+
+static void scan_core_topology(int *map, struct topology *t)
+{
+	int pos = 0;
+	int i;
+	int cpu;
+
+	for (i = 0; i < t->sib_core_nr; i++)
+		for_each_set_bit(cpu,
+				 cpumask_bits(&t->sib_core[i]),
+				 MAX_NR_CPUS)
+			scan_thread_topology(map, t, cpu, &pos);
+}
+
+static int str_to_bitmap(char *s, cpumask_t *b)
+{
+	int i;
+	int ret = 0;
+	struct cpu_map *m;
+	int c;
+
+	m = cpu_map__new(s);
+	if (!m)
+		return -1;
+
+	for (i = 0; i < m->nr; i++) {
+		c = m->map[i];
+		if (c >= MAX_NR_CPUS) {
+			ret = -1;
+			break;
+		}
+
+		set_bit(c, cpumask_bits(b));
+	}
+
+	cpu_map__delete(m);
+
+	return ret;
+}
+
+int svg_build_topology_map(char *sib_core, int sib_core_nr,
+			   char *sib_thr, int sib_thr_nr)
+{
+	int i;
+	struct topology t;
+
+	t.sib_core_nr = sib_core_nr;
+	t.sib_thr_nr = sib_thr_nr;
+	t.sib_core = calloc(sib_core_nr, sizeof(cpumask_t));
+	t.sib_thr = calloc(sib_thr_nr, sizeof(cpumask_t));
+
+	if (!t.sib_core || !t.sib_thr) {
+		fprintf(stderr, "topology: no memory\n");
+		goto exit;
+	}
+
+	for (i = 0; i < sib_core_nr; i++) {
+		if (str_to_bitmap(sib_core, &t.sib_core[i])) {
+			fprintf(stderr, "topology: can't parse siblings map\n");
+			goto exit;
+		}
+
+		sib_core += strlen(sib_core) + 1;
+	}
+
+	for (i = 0; i < sib_thr_nr; i++) {
+		if (str_to_bitmap(sib_thr, &t.sib_thr[i])) {
+			fprintf(stderr, "topology: can't parse siblings map\n");
+			goto exit;
+		}
+
+		sib_thr += strlen(sib_thr) + 1;
+	}
+
+	topology_map = malloc(sizeof(int) * MAX_NR_CPUS);
+	if (!topology_map) {
+		fprintf(stderr, "topology: no memory\n");
+		goto exit;
+	}
+
+	for (i = 0; i < MAX_NR_CPUS; i++)
+		topology_map[i] = -1;
+
+	scan_core_topology(topology_map, &t);
+
+	return 0;
+
+exit:
+	free(t.sib_core);
+	free(t.sib_thr);
+
+	return -1;
+}
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index 8b77ca631686..1df4fb6c3a4a 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -23,6 +23,8 @@ extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, cha
 extern void svg_interrupt(u64 start, int row, const char *backtrace);
 extern void svg_text(int Yslot, u64 start, const char *text);
 extern void svg_close(void);
+extern int svg_build_topology_map(char *sib_core, int sib_core_nr,
+				  char *sib_thr, int sib_thr_nr);
 
 extern int svg_page_width;
 
-- 
1.8.3.2

