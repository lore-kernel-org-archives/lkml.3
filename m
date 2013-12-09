Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab3LITl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:41:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54997 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761385Ab3LIThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/21] perf script: Add an option to print the source line number
Date: Mon,  9 Dec 2013 16:36:54 -0300
Message-Id: <1386617830-18926-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add field 'srcline' that displays the source file name and line number
associated with the sample ip.  The information displayed is the same as
from addr2line.

 $ perf script -f comm,tid,pid,time,ip,sym,dso,symoff,srcline
            grep 10701/10701 2497321.421013:  ffffffff81043ffa native_write_msr_safe+0xa ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/arch/x86/include/asm/msr.h:95
            grep 10701/10701 2497321.421984:  ffffffff8165b6b3 _raw_spin_lock+0x13 ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/arch/x86/include/asm/spinlock.h:54
            grep 10701/10701 2497321.421990:  ffffffff810b64b3 tick_sched_timer+0x53 ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/kernel/time/tick-sched.c:840
            grep 10701/10701 2497321.421992:  ffffffff8106f63f run_timer_softirq+0x2f ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/kernel/timer.c:1372

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386315778-11633-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |  2 +-
 tools/perf/builtin-script.c              | 10 ++++++++++
 tools/perf/util/map.c                    | 17 +++++++++++++++++
 tools/perf/util/map.h                    |  2 ++
 tools/perf/util/session.c                |  8 ++++++++
 tools/perf/util/session.h                |  1 +
 6 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index cfdbb1e045b5..c2a5071cf8f8 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff.
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff, srcline.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4484886dcf08..7a571fb7eb8a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -43,6 +43,7 @@ enum perf_output_field {
 	PERF_OUTPUT_DSO             = 1U << 9,
 	PERF_OUTPUT_ADDR            = 1U << 10,
 	PERF_OUTPUT_SYMOFFSET       = 1U << 11,
+	PERF_OUTPUT_SRCLINE         = 1U << 12,
 };
 
 struct output_option {
@@ -61,6 +62,7 @@ struct output_option {
 	{.str = "dso",   .field = PERF_OUTPUT_DSO},
 	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
 	{.str = "symoff", .field = PERF_OUTPUT_SYMOFFSET},
+	{.str = "srcline", .field = PERF_OUTPUT_SRCLINE},
 };
 
 /* default set to maintain compatibility with current format */
@@ -210,6 +212,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		       "to DSO.\n");
 		return -EINVAL;
 	}
+	if (PRINT_FIELD(SRCLINE) && !PRINT_FIELD(IP)) {
+		pr_err("Display of source line number requested but sample IP is not\n"
+		       "selected. Hence, no address to lookup the source line number.\n");
+		return -EINVAL;
+	}
 
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
 		perf_evsel__check_stype(evsel, PERF_SAMPLE_TID, "TID",
@@ -245,6 +252,9 @@ static void set_print_ip_opts(struct perf_event_attr *attr)
 
 	if (PRINT_FIELD(SYMOFFSET))
 		output[type].print_ip_opts |= PRINT_IP_OPT_SYMOFFSET;
+
+	if (PRINT_FIELD(SRCLINE))
+		output[type].print_ip_opts |= PRINT_IP_OPT_SRCLINE;
 }
 
 /*
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ef5bc913ca7a..9b9bd719aa19 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -11,6 +11,7 @@
 #include "strlist.h"
 #include "vdso.h"
 #include "build-id.h"
+#include "util.h"
 #include <linux/string.h>
 
 const char *map_type__name[MAP__NR_TYPES] = {
@@ -252,6 +253,22 @@ size_t map__fprintf_dsoname(struct map *map, FILE *fp)
 	return fprintf(fp, "%s", dsoname);
 }
 
+int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
+			 FILE *fp)
+{
+	char *srcline;
+	int ret = 0;
+
+	if (map && map->dso) {
+		srcline = get_srcline(map->dso,
+				      map__rip_2objdump(map, addr));
+		if (srcline != SRCLINE_UNKNOWN)
+			ret = fprintf(fp, "%s%s", prefix, srcline);
+		free_srcline(srcline);
+	}
+	return ret;
+}
+
 /**
  * map__rip_2objdump - convert symbol start address to objdump address.
  * @map: memory map
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index e4e259c3ba16..18068c6b71c1 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -103,6 +103,8 @@ struct map *map__clone(struct map *map);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *map, FILE *fp);
 size_t map__fprintf_dsoname(struct map *map, FILE *fp);
+int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
+			 FILE *fp);
 
 int map__load(struct map *map, symbol_filter_t filter);
 struct symbol *map__find_symbol(struct map *map,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c236b38ed02b..e748f29c53cf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1497,6 +1497,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
 	int print_dso = print_opts & PRINT_IP_OPT_DSO;
 	int print_symoffset = print_opts & PRINT_IP_OPT_SYMOFFSET;
 	int print_oneline = print_opts & PRINT_IP_OPT_ONELINE;
+	int print_srcline = print_opts & PRINT_IP_OPT_SRCLINE;
 	char s = print_oneline ? ' ' : '\t';
 
 	if (symbol_conf.use_callchain && sample->callchain) {
@@ -1546,6 +1547,10 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
 				printf(")");
 			}
 
+			if (print_srcline)
+				map__fprintf_srcline(node->map, addr, "\n  ",
+						     stdout);
+
 			if (!print_oneline)
 				printf("\n");
 
@@ -1575,6 +1580,9 @@ next:
 			map__fprintf_dsoname(al->map, stdout);
 			printf(")");
 		}
+
+		if (print_srcline)
+			map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
 	}
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 004d3e8116aa..2a3955ea4fd8 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -45,6 +45,7 @@ struct perf_session {
 #define PRINT_IP_OPT_DSO		(1<<2)
 #define PRINT_IP_OPT_SYMOFFSET	(1<<3)
 #define PRINT_IP_OPT_ONELINE	(1<<4)
+#define PRINT_IP_OPT_SRCLINE	(1<<5)
 
 struct perf_tool;
 
-- 
1.8.1.4

