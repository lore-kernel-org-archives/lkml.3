Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967005Ab3HIAYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:24:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:21987 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966987Ab3HIAYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:24:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,842,1367996400"; 
   d="scan'208";a="343801603"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Output running time and run/enabled ratio in CSV mode v2
Date: Thu,  8 Aug 2013 17:24:30 -0700
Message-Id: <1376007870-31416-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The information how much a counter ran in perf stat can be quite
interesting for other tools to judge how trustworthy a measurement is.

Currently it is only output in non CSV mode.

This patches make perf stat always output the running time and the
enabled/running ratio in CSV mode.

This adds two new fields at the end for each line. I assume that existing
tools ignore new fields at the end, so it's on by default.

Only CSV mode is affected, no difference otherwise.

v2: Add extra print_running function
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-stat.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f686d5f..bede863 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -570,6 +570,16 @@ static int run_perf_stat(int argc __maybe_unused, const char **argv)
 	return ret;
 }
 
+static void print_running(u64 run, u64 ena)
+{
+	if (csv_output)
+		fprintf(output, "%s%" PRIu64 "%s%.2f",
+					csv_sep,
+					run,
+					csv_sep,
+					100.0 * run / ena);
+}
+
 static void print_noise_pct(double total, double avg)
 {
 	double pct = rel_stddev_stats(total, avg);
@@ -982,6 +992,7 @@ static void print_aggr(char *prefix)
 					fprintf(output, "%s%s",
 						csv_sep, counter->cgrp->name);
 
+				print_running(run, ena);
 				fputc('\n', output);
 				continue;
 			}
@@ -997,6 +1008,8 @@ static void print_aggr(char *prefix)
 				if (run != ena)
 					fprintf(output, "  (%.2f%%)",
 						100.0 * run / ena);
+			} else {
+				print_running(run, ena);
 			}
 			fputc('\n', output);
 		}
@@ -1012,6 +1025,10 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 	struct perf_stat *ps = counter->priv;
 	double avg = avg_stats(&ps->res_stats[0]);
 	int scaled = counter->counts->scaled;
+	double avg_enabled, avg_running;
+
+	avg_enabled = avg_stats(&ps->res_stats[1]);
+	avg_running = avg_stats(&ps->res_stats[2]);
 
 	if (prefix)
 		fprintf(output, "%s", prefix);
@@ -1027,6 +1044,7 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 		if (counter->cgrp)
 			fprintf(output, "%s%s", csv_sep, counter->cgrp->name);
 
+		print_running(avg_running, avg_enabled);
 		fputc('\n', output);
 		return;
 	}
@@ -1038,19 +1056,9 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 
 	print_noise(counter, avg);
 
-	if (csv_output) {
-		fputc('\n', output);
-		return;
-	}
-
-	if (scaled) {
-		double avg_enabled, avg_running;
-
-		avg_enabled = avg_stats(&ps->res_stats[1]);
-		avg_running = avg_stats(&ps->res_stats[2]);
-
+	print_running(avg_running, avg_enabled);
+	if (!csv_output)
 		fprintf(output, " [%5.2f%%]", 100 * avg_running / avg_enabled);
-	}
 	fprintf(output, "\n");
 }
 
@@ -1085,6 +1093,7 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 				fprintf(output, "%s%s",
 					csv_sep, counter->cgrp->name);
 
+			print_running(run, ena);
 			fputc('\n', output);
 			continue;
 		}
@@ -1100,7 +1109,10 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 			if (run != ena)
 				fprintf(output, "  (%.2f%%)",
 					100.0 * run / ena);
+		} else {
+			print_running(run, ena);
 		}
+
 		fputc('\n', output);
 	}
 }
-- 
1.8.3.1

