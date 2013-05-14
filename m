Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3ENKOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:14:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53910 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab3ENKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:05 -0400
X-AuditID: 9c930197-b7b76ae000003523-35-51920e690ee0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/15] perf ftrace: Add support for -a and -C option
Date: Tue, 14 May 2013 19:13:51 +0900
Message-Id: <1368526439-31966-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -a/--all-cpus and -C/--cpu option is for controlling tracing cpus.
To do that, add and use cpu_map__sprintf() function.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.c    | 45 +++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h    |  1 +
 3 files changed, 115 insertions(+)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 2025161bbaed..efe907e4bd56 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -18,6 +18,7 @@
 #include "util/evlist.h"
 #include "util/target.h"
 #include "util/thread_map.h"
+#include "util/cpumap.h"
 
 
 #define DEFAULT_TRACER  "function_graph"
@@ -79,6 +80,8 @@ static int append_tracing_file(const char *name, const char *val)
 	return __write_tracing_file(name, val, true);
 }
 
+static int reset_tracing_cpu(void);
+
 static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
 {
 	if (write_tracing_file("tracing_on", "0") < 0)
@@ -90,6 +93,9 @@ static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
 	if (write_tracing_file("set_ftrace_pid", " ") < 0)
 		return -1;
 
+	if (reset_tracing_cpu() < 0)
+		return -1;
+
 	return 0;
 }
 
@@ -110,6 +116,60 @@ static int set_tracing_pid(struct perf_ftrace *ftrace)
 	return 0;
 }
 
+static int set_tracing_cpu(struct perf_ftrace *ftrace)
+{
+	char *cpumask;
+	size_t mask_size;
+	int ret;
+	int last_cpu;
+	struct cpu_map *cpumap = ftrace->evlist->cpus;
+
+	if (!perf_target__has_cpu(&ftrace->target))
+		return 0;
+
+	last_cpu = cpumap->map[cpumap->nr - 1];
+	mask_size = (last_cpu + 3) / 4 + 1;
+	mask_size += last_cpu / 32; /* ',' is needed for every 32th cpus */
+
+	cpumask = malloc(mask_size);
+	if (cpumask == NULL) {
+		pr_debug("failed to allocate cpu mask\n");
+		return -1;
+	}
+
+	cpu_map__sprintf(cpumap, cpumask);
+
+	ret = write_tracing_file("tracing_cpumask", cpumask);
+
+	free(cpumask);
+	return ret;
+}
+
+static int reset_tracing_cpu(void)
+{
+	char *cpumask;
+	size_t mask_size;
+	int last_cpu;
+	struct cpu_map *cpumap = cpu_map__new(NULL);
+
+	last_cpu = cpumap->map[cpumap->nr - 1];
+	mask_size = (last_cpu + 3) / 4 + 1;
+	mask_size += last_cpu / 32; /* ',' is needed for every 32th cpus */
+
+	cpumask = malloc(mask_size);
+	if (cpumask == NULL) {
+		pr_debug("failed to allocate cpu mask\n");
+		return -1;
+	}
+
+	cpu_map__sprintf(cpumap, cpumask);
+
+	write_tracing_file("tracing_cpumask", cpumask);
+
+	free(cpumask);
+	return 0;
+}
+
 static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
 	char *trace_file;
@@ -146,6 +206,11 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 		goto out_reset;
 	}
 
+	if (set_tracing_cpu(ftrace) < 0) {
+		pr_err("failed to set tracing cpumask\n");
+		goto out_reset;
+	}
+
 	if (write_tracing_file("current_tracer", ftrace->tracer) < 0) {
 		pr_err("failed to set current_tracer to %s\n", ftrace->tracer);
 		goto out_reset;
@@ -226,6 +291,10 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "trace on existing process id"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose"),
+	OPT_BOOLEAN('a', "all-cpus", &ftrace.target.system_wide,
+		    "system-wide collection from all CPUs"),
+	OPT_STRING('C', "cpu", &ftrace.target.cpu_list, "cpu",
+		    "list of cpus to monitor"),
 	OPT_END()
 	};
 
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index beb8cf9f9976..7933839915ea 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -187,6 +187,51 @@ size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp)
 	return printed + fprintf(fp, "\n");
 }
 
+static char hex_char(char val)
+{
+	if (0 <= val && val <= 9)
+		return val + '0';
+	if (10 <= val && val < 16)
+		return val - 10 + 'a';
+	return '?';
+}
+
+size_t cpu_map__sprintf(struct cpu_map *map, char *buf)
+{
+	int i, cpu;
+	char *ptr = buf;
+	unsigned char *bitmap;
+	int last_cpu = map->map[map->nr - 1];
+
+	bitmap = zalloc((last_cpu + 7) / 8);
+	if (bitmap == NULL) {
+		buf[0] = '\0';
+		return 0;
+	}
+
+	for (i = 0; i < map->nr; i++) {
+		cpu = map->map[i];
+		bitmap[cpu / 8] |= 1 << (cpu % 8);
+	}
+
+	for (cpu = last_cpu / 4 * 4; cpu >= 0; cpu -= 4) {
+		unsigned char bits = bitmap[cpu / 8];
+
+		if (cpu % 8)
+			bits >>= 4;
+		else
+			bits &= 0xf;
+
+		*ptr++ = hex_char(bits);
+		if ((cpu % 32) == 0 && cpu > 0)
+			*ptr++ = ',';
+	}
+	*ptr++ = '\0';
+
+	free(bitmap);
+	return ptr - buf;
+}
+
 struct cpu_map *cpu_map__dummy_new(void)
 {
 	struct cpu_map *cpus = malloc(sizeof(*cpus) + sizeof(int));
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 9bed02e5fb3d..e2b85b9ebbf4 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -14,6 +14,7 @@ struct cpu_map *cpu_map__dummy_new(void);
 void cpu_map__delete(struct cpu_map *map);
 struct cpu_map *cpu_map__read(FILE *file);
 size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
+size_t cpu_map__sprintf(struct cpu_map *map, char *buf);
 int cpu_map__get_socket(struct cpu_map *map, int idx);
 int cpu_map__get_core(struct cpu_map *map, int idx);
 int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp);
-- 
1.7.11.7

