Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab3CLU3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:29:51 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:40815 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3CLU3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:29:49 -0400
Date: Tue, 12 Mar 2013 17:24:38 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Make perf stat -I ... CSV output flat
Message-ID: <20130312202438.GA15702@infradead.org>
References: <1362624201-6161-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1362624201-6161-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Wed, Mar 06, 2013 at 06:43:21PM -0800, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The new perf stat interval code is quite useful, especially when the
> data is post processed. Unfortunately the default -x, output is not
> very friendly to programs when it contains more than one event.

I made it apply on my perf/core branch, works as advertised, Stephane,
can I have your acked-by?

Updated patch attached.

- Arnaldo

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-stat-Make-I-.-CSV-output-flat.patch"

>From 6ce26baeb07e5b802410febfc0b8a58d0d04b847 Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@linux.intel.com>
Date: Wed, 6 Mar 2013 18:43:21 -0800
Subject: [PATCH] perf stat: Make -I ... CSV output flat
Content-Type: text/plain; charset="utf-8"

The new perf stat interval code is quite useful, especially when the
data is post processed. Unfortunately the default -x, output is not very
friendly to programs when it contains more than one event.

Each event is printed on its own line, each keyed with the time.

You cannot directly feed it to gnuplot or into R to compare different
events at a specific point in time.

This patch normalizes the output so that a single line contains all the
events for a given time period. Each event is an own column.

With that it's quite easy to do plots and other analysis, as this is the
normalized format many data processing programs expect.

This is not fully normalized yet, as per cpu counts also end up on the
same line (fixing this would be more intrusive) But good enough for most
purposes.

The non CSV output is not changed.

Example:

$ perf stat -o /tmp/x.csv -I 100 -x, bc  <<< 2^400000 > /dev/null
$ gnuplot
gnuplot> set datafile separator ","
gnuplot> set terminal dumb
gnuplot> plot "/tmp/x.csv" every ::3 using 1:3

  110 ++--------+---------+---------+--------+---------+---------+--------++
      +         +         +        "/tmp/x.csv" every ::3 using 1:3   A    +
  100 ++   A    A    A    A    A    A    A    A   A    A    A    A        ++
   90 ++                                                                  ++
      |                                                                    |
   80 ++                                                                  ++
      |                                                                    |
   70 ++                                                                  ++
      |                                                                    |
   60 ++                                                                  ++
   50 ++                                                                  ++
      |                                                                    |
   40 ++                                                                  ++
      |                                                                    |
   30 ++                                                                  ++
      |                                                                    |
   20 ++                                                                  ++
   10 ++                                                                  ++
      +         +         +         +        +         +         +A        +
    0 ++--------+---------+---------+--------+---------+---------+--------++
     0.2       0.4       0.6       0.8       1        1.2       1.4       1.6

Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1362624201-6161-1-git-send-email-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |  118 +++++++++++++++++++++++++++++++--------------
 1 files changed, 82 insertions(+), 36 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 69fe6ed..2d4058c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -66,8 +66,10 @@
 #define CNTR_NOT_COUNTED	"<not counted>"
 
 static void print_stat(int argc, const char **argv);
-static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
-static void print_counter(struct perf_evsel *counter, char *prefix);
+static void print_counter_aggr(struct perf_evsel *counter, char *prefix, int delim,
+			       int name);
+static void print_counter(struct perf_evsel *counter, char *prefix, int delim,
+			  int name);
 static void print_aggr_socket(char *prefix);
 
 static struct perf_evlist	*evsel_list;
@@ -296,6 +298,7 @@ static void print_interval(void)
 	struct perf_stat *ps;
 	struct timespec ts, rs;
 	char prefix[64];
+	int delim = '\n';
 
 	if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
@@ -326,15 +329,23 @@ static void print_interval(void)
 	if (++num_print_interval == 25)
 		num_print_interval = 0;
 
+	if (csv_output) {
+		delim = ',';
+		fprintf(output, "%s,", prefix);
+		prefix[0] = 0;
+	}
+
 	if (aggr_socket)
 		print_aggr_socket(prefix);
 	else if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter(counter, prefix);
+			print_counter(counter, prefix, delim, !csv_output);
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter_aggr(counter, prefix);
+			print_counter_aggr(counter, prefix, delim, !csv_output);
 	}
+	if (csv_output)
+		fputc('\n', output);
 }
 
 static int __run_perf_stat(int argc, const char **argv)
@@ -411,6 +422,21 @@ static int __run_perf_stat(int argc, const char **argv)
 	t0 = rdclock();
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
+	if (interval && csv_output) {
+		fprintf(output, "time,,");
+		list_for_each_entry (counter, &evsel_list->entries, node) {
+			if (aggr_socket)
+				fprintf(output, "socket%scpu-num%s",
+					csv_sep, csv_sep);
+			fprintf(output, "%s%s",
+				perf_evsel__name(counter), csv_sep);
+			if (counter->cgrp)
+				fprintf(output, "%s-cgroup%s",
+					perf_evsel__name(counter), csv_sep);
+		}
+		fputc('\n', output);
+	}
+
 	if (forks) {
 		perf_evlist__start_workload(evsel_list);
 
@@ -498,7 +524,8 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 	print_noise_pct(stddev_stats(&ps->res_stats[0]), avg);
 }
 
-static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg,
+		          int name)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
@@ -517,7 +544,9 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 			csv_output ? 0 : -4,
 			perf_evsel__cpus(evsel)->map[cpu], csv_sep);
 
-	fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, cpustr, msecs,
+			name ? csv_sep : "",
+			name ? perf_evsel__name(evsel) : "");
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -711,7 +740,8 @@ static void print_ll_cache_misses(int cpu,
 	fprintf(output, " of all LL-cache hits   ");
 }
 
-static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg,
+			 int name)
 {
 	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
@@ -739,7 +769,9 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	else
 		cpu = 0;
 
-	fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, cpustr, avg,
+			name ? csv_sep : "",
+			name ? perf_evsel__name(evsel) : "");
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -843,6 +875,7 @@ static void print_aggr_socket(char *prefix)
 	struct perf_evsel *counter;
 	u64 ena, run, val;
 	int cpu, s, s2, sock, nr;
+	bool cmode = csv_output && interval;
 
 	if (!sock_map)
 		return;
@@ -865,7 +898,7 @@ static void print_aggr_socket(char *prefix)
 				fprintf(output, "%s", prefix);
 
 			if (run == 0 || ena == 0) {
-				fprintf(output, "S%*d%s%*d%s%*s%s%*s",
+				fprintf(output, "S%*d%s%*d%s%*s",
 					csv_output ? 0 : -5,
 					s,
 					csv_sep,
@@ -873,22 +906,24 @@ static void print_aggr_socket(char *prefix)
 					nr,
 					csv_sep,
 					csv_output ? 0 : 18,
-					counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
-					csv_sep,
-					csv_output ? 0 : -24,
-					perf_evsel__name(counter));
+					counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED);
+				if (!cmode)
+					fprintf(output, "%s%*s",
+						csv_sep,
+						csv_output ? 0 : -24,
+						perf_evsel__name(counter));
 				if (counter->cgrp)
 					fprintf(output, "%s%s",
 						csv_sep, counter->cgrp->name);
 
-				fputc('\n', output);
+				fputs(cmode ? csv_sep : "\n", output);
 				continue;
 			}
 
 			if (nsec_counter(counter))
-				nsec_printout(sock, nr, counter, val);
+				nsec_printout(sock, nr, counter, val, !cmode);
 			else
-				abs_printout(sock, nr, counter, val);
+				abs_printout(sock, nr, counter, val, !cmode);
 
 			if (!csv_output) {
 				print_noise(counter, 1.0);
@@ -897,16 +932,19 @@ static void print_aggr_socket(char *prefix)
 					fprintf(output, "  (%.2f%%)",
 						100.0 * run / ena);
 			}
-			fputc('\n', output);
+			fputs(cmode ? csv_sep : "\n", output);
 		}
 	}
+	if (cmode)
+		fputc('\n', output);
 }
 
 /*
  * Print out the results of a single counter:
  * aggregated counts in system-wide mode
  */
-static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
+static void print_counter_aggr(struct perf_evsel *counter, char *prefix, int delim,
+			       int name)
 {
 	struct perf_stat *ps = counter->priv;
 	double avg = avg_stats(&ps->res_stats[0]);
@@ -926,19 +964,19 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 		if (counter->cgrp)
 			fprintf(output, "%s%s", csv_sep, counter->cgrp->name);
 
-		fputc('\n', output);
+		fputc(delim, output);
 		return;
 	}
 
 	if (nsec_counter(counter))
-		nsec_printout(-1, 0, counter, avg);
+		nsec_printout(-1, 0, counter, avg, name);
 	else
-		abs_printout(-1, 0, counter, avg);
+		abs_printout(-1, 0, counter, avg, name);
 
 	print_noise(counter, avg);
 
 	if (csv_output) {
-		fputc('\n', output);
+		fputc(delim, output);
 		return;
 	}
 
@@ -950,17 +988,19 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix)
 
 		fprintf(output, " [%5.2f%%]", 100 * avg_running / avg_enabled);
 	}
-	fprintf(output, "\n");
+	fputc(delim, output);
 }
 
 /*
  * Print out the results of a single counter:
  * does not use aggregated count in system-wide
  */
-static void print_counter(struct perf_evsel *counter, char *prefix)
+static void print_counter(struct perf_evsel *counter, char *prefix, int delim,
+			  int name)
 {
 	u64 ena, run, val;
 	int cpu;
+	bool cmode = interval && csv_output;
 
 	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
 		val = counter->counts->cpu[cpu].val;
@@ -971,27 +1011,33 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 			fprintf(output, "%s", prefix);
 
 		if (run == 0 || ena == 0) {
-			fprintf(output, "CPU%*d%s%*s%s%*s",
-				csv_output ? 0 : -4,
-				perf_evsel__cpus(counter)->map[cpu], csv_sep,
+			if (!cmode)
+				fprintf(output, "CPU%*d%s",
+					csv_output ? 0 : -4,
+					perf_evsel__cpus(counter)->map[cpu],
+					csv_sep);
+			fprintf(output, "%*s%s",
 				csv_output ? 0 : 18,
 				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
-				csv_sep,
-				csv_output ? 0 : -24,
-				perf_evsel__name(counter));
+				csv_sep);
+			if (!cmode)
+				fprintf(output, "%*s%s",
+					csv_output ? 0 : -24,
+					perf_evsel__name(counter),
+					csv_sep);
 
 			if (counter->cgrp)
 				fprintf(output, "%s%s",
 					csv_sep, counter->cgrp->name);
 
-			fputc('\n', output);
+			fputc(delim, output);
 			continue;
 		}
 
 		if (nsec_counter(counter))
-			nsec_printout(cpu, 0, counter, val);
+			nsec_printout(cpu, 0, counter, val, name);
 		else
-			abs_printout(cpu, 0, counter, val);
+			abs_printout(cpu, 0, counter, val, name);
 
 		if (!csv_output) {
 			print_noise(counter, 1.0);
@@ -1000,7 +1046,7 @@ static void print_counter(struct perf_evsel *counter, char *prefix)
 				fprintf(output, "  (%.2f%%)",
 					100.0 * run / ena);
 		}
-		fputc('\n', output);
+		fputc(delim, output);
 	}
 }
 
@@ -1033,10 +1079,10 @@ static void print_stat(int argc, const char **argv)
 		print_aggr_socket(NULL);
 	else if (no_aggr) {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter(counter, NULL);
+			print_counter(counter, NULL, '\n', 1);
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node)
-			print_counter_aggr(counter, NULL);
+			print_counter_aggr(counter, NULL, '\n', 1);
 	}
 
 	if (!csv_output) {
-- 
1.7.1


--X1bOJ3K7DJ5YkBrT--
