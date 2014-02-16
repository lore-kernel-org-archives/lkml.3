Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBPDEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 22:04:11 -0500
Received: from tartarus.angband.pl ([89.206.35.136]:59297 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaBPDEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 22:04:09 -0500
From: Adam Borowski <kilobyte@angband.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Sun, 16 Feb 2014 04:03:42 +0100
Message-Id: <1392519822-17748-1-git-send-email-kilobyte@angband.pl>
X-Mailer: git-send-email 1.9.0.rc3
X-SA-Exim-Connect-IP: 2001:6a0:118::6
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH] perf: tools: fix missing casts for printf arguments.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of -Werror, they caused build failure at least on x32, as time_t
is of different size than "unsigned long".  In another place, __suseconds_t
is not compatible with "long int".

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 tools/perf/bench/sched-messaging.c | 4 ++--
 tools/perf/bench/sched-pipe.c      | 4 ++--
 tools/perf/builtin-kvm.c           | 2 +-
 tools/perf/builtin-stat.c          | 3 ++-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index cc1190a..6595e2f 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -318,11 +318,11 @@ int bench_sched_messaging(int argc, const char **argv,
 		       num_groups, num_groups * 2 * num_fds,
 		       thread_mode ? "threads" : "processes");
 		printf(" %14s: %lu.%03lu [sec]\n", "Total time",
-		       diff.tv_sec,
+		       (unsigned long) diff.tv_sec,
 		       (unsigned long) (diff.tv_usec/1000));
 		break;
 	case BENCH_FORMAT_SIMPLE:
-		printf("%lu.%03lu\n", diff.tv_sec,
+		printf("%lu.%03lu\n", (unsigned long) diff.tv_sec,
 		       (unsigned long) (diff.tv_usec/1000));
 		break;
 	default:
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 07a8d76..d7c1df4 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -157,7 +157,7 @@ int bench_sched_pipe(int argc, const char **argv, const char *prefix __maybe_unu
 		result_usec += diff.tv_usec;
 
 		printf(" %14s: %lu.%03lu [sec]\n\n", "Total time",
-		       diff.tv_sec,
+		       (unsigned long) diff.tv_sec,
 		       (unsigned long) (diff.tv_usec/1000));
 
 		printf(" %14lf usecs/op\n",
@@ -169,7 +169,7 @@ int bench_sched_pipe(int argc, const char **argv, const char *prefix __maybe_unu
 
 	case BENCH_FORMAT_SIMPLE:
 		printf("%lu.%03lu\n",
-		       diff.tv_sec,
+		       (unsigned long) diff.tv_sec,
 		       (unsigned long) (diff.tv_usec / 1000));
 		break;
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a735051..b470f0f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -730,7 +730,7 @@ static void show_timeofday(void)
 	gettimeofday(&tv, NULL);
 	if (localtime_r(&tv.tv_sec, &ltime)) {
 		strftime(date, sizeof(date), "%H:%M:%S", &ltime);
-		pr_info("%s.%06ld", date, tv.tv_usec);
+		pr_info("%s.%06ld", date, (long int) tv.tv_usec);
 	} else
 		pr_info("00:00:00.000000");
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8b0e1c9..26cfc12 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -455,7 +455,8 @@ static void print_interval(void)
 
 	clock_gettime(CLOCK_MONOTONIC, &ts);
 	diff_timespec(&rs, &ts, &ref_time);
-	sprintf(prefix, "%6lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
+	sprintf(prefix, "%6lu.%09lu%s", (unsigned long) rs.tv_sec,
+	                                (unsigned long) rs.tv_nsec, csv_sep);
 
 	if (num_print_interval == 0 && !csv_output) {
 		switch (aggr_mode) {
-- 
1.9.0.rc3

