Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3LRKeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:34:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3LRKeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:34:06 -0500
Date: Wed, 18 Dec 2013 02:33:36 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-e57a2dffbc7e28cef5f4659b98a9d5595010ab4d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, stfomichev@yandex-team.ru,
        artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, stfomichev@yandex-team.ru,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <20131217155349.GA13021@stfomichev-desktop>
References: <20131217155349.GA13021@stfomichev-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Add --highlight option
Git-Commit-ID: e57a2dffbc7e28cef5f4659b98a9d5595010ab4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:33:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e57a2dffbc7e28cef5f4659b98a9d5595010ab4d
Gitweb:     http://git.kernel.org/tip/e57a2dffbc7e28cef5f4659b98a9d5595010ab4d
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Tue, 17 Dec 2013 19:53:49 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 17 Dec 2013 16:33:55 -0300

perf timechart: Add --highlight option

This option highlights tasks (using different color) that run more than
given duration or tasks with given name.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/20131217155349.GA13021@stfomichev-desktop
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-timechart.txt | 13 +++++++++++++
 tools/perf/builtin-timechart.c              | 21 ++++++++++++++++++++-
 tools/perf/util/svghelper.c                 | 23 ++++++++++++++++++++---
 tools/perf/util/svghelper.h                 |  4 +++-
 4 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 367c1be..bc5990c 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -56,12 +56,25 @@ $ perf timechart
 
   Written 10.2 seconds of trace to output.svg.
 
+Record system-wide timechart:
+
+  $ perf timechart record
+
+  then generate timechart and highlight 'gcc' tasks:
+
+  $ perf timechart --highlight gcc
+
 -n::
 --proc-num::
         Print task info for at least given number of tasks.
 -t::
 --topology::
         Sort CPUs according to topology.
+--highlight=<duration_nsecs|task_name>::
+	Highlight tasks (using different color) that run more than given
+	duration or tasks with given name. If number is given it's interpreted
+	as number of nanoseconds. If non-numeric string is given it's
+	interpreted as task name.
 
 RECORD OPTIONS
 --------------
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 8bde57c..20d4212 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -841,7 +841,6 @@ static void draw_cpu_usage(struct timechart *tchart)
 						    sample->start_time,
 						    sample->end_time,
 						    p->pid,
-						    "sample",
 						    c->comm,
 						    sample->backtrace);
 				}
@@ -1252,6 +1251,23 @@ parse_process(const struct option *opt __maybe_unused, const char *arg,
 	return 0;
 }
 
+static int
+parse_highlight(const struct option *opt __maybe_unused, const char *arg,
+		int __maybe_unused unset)
+{
+	unsigned long duration = strtoul(arg, NULL, 0);
+
+	if (svg_highlight || svg_highlight_name)
+		return -1;
+
+	if (duration)
+		svg_highlight = duration;
+	else
+		svg_highlight_name = strdup(arg);
+
+	return 0;
+}
+
 int cmd_timechart(int argc, const char **argv,
 		  const char *prefix __maybe_unused)
 {
@@ -1270,6 +1286,9 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
 	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
+	OPT_CALLBACK(0, "highlight", NULL, "duration or task name",
+		      "highlight tasks. Pass duration in ns or process name.",
+		       parse_highlight),
 	OPT_BOOLEAN('P', "power-only", &tchart.power_only, "output power data only"),
 	OPT_BOOLEAN('T', "tasks-only", &tchart.tasks_only,
 		    "output processes data only"),
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 9468136..56a84f2 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -31,6 +31,8 @@ static u64 turbo_frequency, max_freq;
 #define SLOT_HEIGHT 25.0
 
 int svg_page_width = 1000;
+u64 svg_highlight;
+const char *svg_highlight_name;
 
 #define MIN_TEXT_SIZE 0.01
 
@@ -112,6 +114,7 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 	fprintf(svgfile, "      rect.process  { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:1;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.sample_hi{ fill:rgb(255,128,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.waiting  { fill:rgb(224,214,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
 	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
@@ -155,17 +158,24 @@ void svg_blocked(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace)
 {
 	double text_size;
+	const char *type;
+
 	if (!svgfile)
 		return;
 
+	if (svg_highlight && end - start > svg_highlight)
+		type = "sample_hi";
+	else
+		type = "sample";
 	fprintf(svgfile, "<g>\n");
 
 	fprintf(svgfile, "<title>#%d running %s</title>\n",
 		cpu, time_to_string(end - start));
 	if (backtrace)
 		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
-	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"sample\"/>\n",
-		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT);
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT,
+		type);
 
 	text_size = (time2pixels(end)-time2pixels(start));
 	if (cpu > 9)
@@ -293,13 +303,20 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_process(int cpu, u64 start, u64 end, int pid, const char *type, const char *name, const char *backtrace)
+void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const char *backtrace)
 {
 	double width;
+	const char *type;
 
 	if (!svgfile)
 		return;
 
+	if (svg_highlight && end - start >= svg_highlight)
+		type = "sample_hi";
+	else if (svg_highlight_name && strstr(name, svg_highlight_name))
+		type = "sample_hi";
+	else
+		type = "sample";
 
 	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), cpu2y(cpu));
 	fprintf(svgfile, "<title>%d %s running %s</title>\n", pid, name, time_to_string(end - start));
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index 1df4fb6..f7b4d6e 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -11,7 +11,7 @@ extern void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *back
 extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
 
 
-extern void svg_process(int cpu, u64 start, u64 end, int pid, const char *type, const char *name, const char *backtrace);
+extern void svg_process(int cpu, u64 start, u64 end, int pid, const char *name, const char *backtrace);
 extern void svg_cstate(int cpu, u64 start, u64 end, int type);
 extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
@@ -27,5 +27,7 @@ extern int svg_build_topology_map(char *sib_core, int sib_core_nr,
 				  char *sib_thr, int sib_thr_nr);
 
 extern int svg_page_width;
+extern u64 svg_highlight;
+extern const char *svg_highlight_name;
 
 #endif /* __PERF_SVGHELPER_H */
