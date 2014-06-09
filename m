Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaFIUD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:03:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbaFIUDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:09 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 15/15] perf tools: Support spark lines in perf stat
Date: Mon,  9 Jun 2014 22:02:30 +0200
Message-Id: <1402344150-14860-16-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

perf stat -rX prints the stddev for multiple measurements.
Just looking at the stddev for judging the quality of the data
is a bit dangerous The simplest sanity check is to just look
at a simple plot. This patchs add a sparkline to the end
of the measurements to make it simple to judge the data.

The sparkline only uses UTF-8, so should be readable
in all modern tools and terminals.

The sparkline is between the minimum and maximum of the data,
so it's mainly a indicator of variance. To keep the code
simple and make the output not too wide only the first
8 values are printed. If more values are there it adds '..'

The code is inspired by Zach Holman's spark shell script.

Example output (view in non-proportial font):

 Performance counter stats for 'true' (10 runs):

          0.175672      task-clock (msec)         #    0.555 CPUs utilized            ( +-  1.77% ) █▄▁▁▁▁▁▁..
                 0      context-switches          #    0.000 K/sec
                 0      cpu-migrations            #    0.000 K/sec
               114      page-faults               #    0.647 M/sec                    ( +-  0.14% ) ▁█▁▁████..
           520,798      cycles                    #    2.965 GHz                      ( +-  1.75% ) █▄▁▁▁▁▁▁..
           433,525      instructions              #    0.83  insns per cycle          ( +-  0.28% ) ▅▇▅▄▇█▁▆..
            83,012      branches                  #  472.537 M/sec                    ( +-  0.31% ) ▅▇▆▄▇█▁▆..
             3,157      branch-misses             #    3.80% of all branches          ( +-  2.55% ) ▇█▃▅▁▃▁▂..

       0.000316660 seconds time elapsed                                          ( +-  1.78% ) █▅▁▁▁▁▁▁..

As you can see even in the most simple run there are quite interesting
patterns. The time sparkline suggests it would be also useful to have an option
to throw the first measurement away.

Known issues:
- Makes the perf stat output wider. Could be adjust by shrinking
some white space. Not done so far.
- No output for -A/--per-socket/--per-core with -rX. This code
is missing the basic noise detection code. Once it's added there
sparklines could be shown too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1401838086-17750-1-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-stat.txt |  4 ++++
 tools/perf/Makefile.perf               |  1 +
 tools/perf/builtin-stat.c              | 12 ++++++++++++
 tools/perf/util/spark.c                | 31 +++++++++++++++++++++++++++++++
 tools/perf/util/spark.h                |  4 ++++
 tools/perf/util/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
 tools/perf/util/stat.h                 | 10 ++++++++++
 7 files changed, 96 insertions(+)
 create mode 100644 tools/perf/util/spark.c
 create mode 100644 tools/perf/util/spark.h

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 29ee857..840c1db 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -53,6 +53,10 @@ OPTIONS
 -r::
 --repeat=<n>::
 	repeat command and print average + stddev (max: 100). 0 means forever.
+	In addition it prints a spark line (when not in CSV mode), which visualizes the
+	variance between minimum and maximum of the measurements. This allows a simple sanity
+	check of the measurements. Only 8 values are printed, when more are available
+	it adds ..
 
 -B::
 --big-num::
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..90b3aa7 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -359,6 +359,7 @@ LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
 LIB_OBJS += $(OUTPUT)util/trace-event.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
+LIB_OBJS += $(OUTPUT)util/spark.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/util.o
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 65a151e..cb0f7c5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1176,6 +1176,9 @@ static void print_aggr(char *prefix)
 				if (run != ena)
 					fprintf(output, "  (%.2f%%)",
 						100.0 * run / ena);
+
+				fputc(' ', output);
+				print_stat_spark(output, counter->priv);
 			}
 			fputc('\n', output);
 		}
@@ -1229,6 +1232,9 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 		return;
 	}
 
+	fputc(' ', output);
+	print_stat_spark(output, counter->priv);
+
 	if (scaled) {
 		double avg_enabled, avg_running;
 
@@ -1295,6 +1301,9 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 			if (run != ena)
 				fprintf(output, "  (%.2f%%)",
 					100.0 * run / ena);
+
+			fputc(' ', output);
+			print_stat_spark(output, counter->priv);
 		}
 		fputc('\n', output);
 	}
@@ -1355,6 +1364,9 @@ static void print_stat(int argc, const char **argv)
 			fprintf(output, "                                        ");
 			print_noise_pct(stddev_stats(&walltime_nsecs_stats),
 					avg_stats(&walltime_nsecs_stats));
+
+			fputc(' ', output);
+			print_stat_spark(output, &walltime_nsecs_stats);
 		}
 		fprintf(output, "\n\n");
 	}
diff --git a/tools/perf/util/spark.c b/tools/perf/util/spark.c
new file mode 100644
index 0000000..5a1033f
--- /dev/null
+++ b/tools/perf/util/spark.c
@@ -0,0 +1,31 @@
+#include <stdio.h>
+#include <limits.h>
+#include "spark.h"
+
+#define NUM_SPARKS 8
+#define SPARK_SHIFT 8
+
+/* Print spark lines on outf for numval values in val. */
+void print_spark(FILE *outf, unsigned long long *val, int numval)
+{
+	static const char *ticks[NUM_SPARKS] = {
+		"▁",  "▂", "▃", "▄", "▅", "▆", "▇", "█"
+	};
+	int i;
+	unsigned long long min = ULLONG_MAX, max = 0, f;
+
+	for (i = 0; i < numval; i++) {
+		if (val[i] < min)
+			min = val[i];
+		if (val[i] > max)
+			max = val[i];
+	}
+	f = ((max - min) << SPARK_SHIFT) / (NUM_SPARKS - 1);
+	if (f < 1)
+		f = 1;
+	for (i = 0; i < numval; i++) {
+		int index = ((val[i] - min) << SPARK_SHIFT) / f;
+		if (index >= 0 && index < NUM_SPARKS)
+			fputs(ticks[index], outf);
+	}
+}
diff --git a/tools/perf/util/spark.h b/tools/perf/util/spark.h
new file mode 100644
index 0000000..d9ebc94
--- /dev/null
+++ b/tools/perf/util/spark.h
@@ -0,0 +1,4 @@
+#ifndef SPARK_H
+#define SPARK_H 1
+void print_spark(FILE *outf, unsigned long long *val, int numval);
+#endif
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 6506b3d..a7c02c5 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -1,10 +1,16 @@
 #include <math.h>
+#include <stdio.h>
 
 #include "stat.h"
+#include "spark.h"
 
 void update_stats(struct stats *stats, u64 val)
 {
 	double delta;
+	int n = stats->n;
+
+	if (n < NUM_SPARK_VALS)
+		stats->svals[n] = val;
 
 	stats->n++;
 	delta = val - stats->mean;
@@ -61,3 +67,31 @@ double rel_stddev_stats(double stddev, double avg)
 
 	return pct;
 }
+
+static int all_zero(unsigned long long *vals, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		if (vals[i] != 0)
+			return 0;
+	return 1;
+}
+
+void print_stat_spark(FILE *f, struct stats *stat)
+{
+	int len;
+
+	if (stat->n <= 1)
+		return;
+
+	len = stat->n;
+	if (len > NUM_SPARK_VALS)
+		len = NUM_SPARK_VALS;
+	if (all_zero(stat->svals, len))
+		return;
+
+	print_spark(f, stat->svals, len);
+	if (stat->n > NUM_SPARK_VALS)
+		fputs("..", f);
+}
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 5667fc3..a049f03 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -1,12 +1,16 @@
 #ifndef __PERF_STATS_H
 #define __PERF_STATS_H
 
+#include <stdio.h>
 #include <linux/types.h>
 
+#define NUM_SPARK_VALS 8 /* support spark line on first N items */
+
 struct stats
 {
 	double n, mean, M2;
 	u64 max, min;
+	unsigned long long svals[NUM_SPARK_VALS];
 };
 
 void update_stats(struct stats *stats, u64 val);
@@ -14,12 +18,18 @@ double avg_stats(struct stats *stats);
 double stddev_stats(struct stats *stats);
 double rel_stddev_stats(double stddev, double avg);
 
+void print_stat_spark(FILE *f, struct stats *stat);
+
 static inline void init_stats(struct stats *stats)
 {
+	int i;
+
 	stats->n    = 0.0;
 	stats->mean = 0.0;
 	stats->M2   = 0.0;
 	stats->min  = (u64) -1;
 	stats->max  = 0;
+	for (i = 0; i < NUM_SPARK_VALS; i++)
+		stats->svals[i] = 0;
 }
 #endif
-- 
1.8.3.1

