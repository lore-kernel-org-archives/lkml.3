Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaELXBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:01:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:27565 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaELXBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:01:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1039,1389772800"; 
   d="scan'208";a="530758731"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Support spark lines in perf stat v2
Date: Mon, 12 May 2014 16:01:26 -0700
Message-Id: <1399935686-26940-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
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

v2: Address review feedback. Use all_zero() and remove len.
Remove test code. Rebased to perf/core
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf  |  1 +
 tools/perf/builtin-stat.c | 12 ++++++++++++
 tools/perf/util/spark.c   | 29 +++++++++++++++++++++++++++++
 tools/perf/util/spark.h   |  3 +++
 tools/perf/util/stat.c    | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/stat.h    | 10 ++++++++++
 6 files changed, 88 insertions(+)
 create mode 100644 tools/perf/util/spark.c
 create mode 100644 tools/perf/util/spark.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2baf61c..2f83f43 100644
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
index 65a151e..6bf7b6c 100644
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
@@ -1224,6 +1227,9 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 
 	print_noise(counter, avg);
 
+	fputc(' ', output);
+	print_stat_spark(output, counter->priv);
+
 	if (csv_output) {
 		fputc('\n', output);
 		return;
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
index 0000000..c43b614
--- /dev/null
+++ b/tools/perf/util/spark.c
@@ -0,0 +1,29 @@
+#include <stdio.h>
+#include <limits.h>
+#include "spark.h"
+
+#define NUM_SPARKS 8
+#define SPARK_SHIFT 8
+
+/* Print spark lines on outf for numval values in val. */
+void print_spark(FILE *outf, unsigned long *val, int numval)
+{
+	static const char *ticks[NUM_SPARKS] = {
+		"▁",  "▂", "▃", "▄", "▅", "▆", "▇", "█"
+	};
+	int i;
+	unsigned long min = LONG_MAX, max = 0, f;
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
+		fputs(ticks[((val[i] - min) << SPARK_SHIFT) / f], outf);
+	}
+}
diff --git a/tools/perf/util/spark.h b/tools/perf/util/spark.h
new file mode 100644
index 0000000..f2d5ac5
--- /dev/null
+++ b/tools/perf/util/spark.h
@@ -0,0 +1,3 @@
+#pragma once
+void print_spark(FILE *outf, unsigned long *val, int numval);
+
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index 6506b3d..ecb8d3e 100644
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
@@ -61,3 +67,30 @@ double rel_stddev_stats(double stddev, double avg)
 
 	return pct;
 }
+
+static int all_zero(unsigned long *vals, int len)
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
+	int n = stat->n;
+
+	if (n <= 1)
+		return;
+
+	if (n > NUM_SPARK_VALS)
+		n = NUM_SPARK_VALS;
+	if (all_zero(stat->svals, n))
+		return;
+
+	print_spark(f, stat->svals, n);
+	if (stat->n > NUM_SPARK_VALS)
+		fputs("..", f);
+}
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
index 5667fc3..38c085c 100644
--- a/tools/perf/util/stat.h
+++ b/tools/perf/util/stat.h
@@ -2,11 +2,15 @@
 #define __PERF_STATS_H
 
 #include <linux/types.h>
+#include <stdio.h>
+
+#define NUM_SPARK_VALS 8 /* support spark line on first N items */
 
 struct stats
 {
 	double n, mean, M2;
 	u64 max, min;
+	unsigned long svals[NUM_SPARK_VALS];
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
1.9.0

