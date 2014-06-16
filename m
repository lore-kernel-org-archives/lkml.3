Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbaFPSPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:19 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:50993 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaFPSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:15 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] perf bench: sched-messaging: Redo runtime output
Date: Mon, 16 Jun 2014 11:14:20 -0700
Message-Id: <1402942467-10671-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of printing sec and usec individually, simplify
into a 'runtime' variable to later use accordingly. This
is particularly helpful when later adding multiple runs
and collecting statistics.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/bench/sched-messaging.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index cc1190a..df0828a 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -269,9 +269,9 @@ static const char * const bench_sched_message_usage[] = {
 int bench_sched_messaging(int argc, const char **argv,
 		    const char *prefix __maybe_unused)
 {
-	unsigned int i, total_children;
+	unsigned int i, total_children, num_fds = 20;
 	struct timeval start, stop, diff;
-	unsigned int num_fds = 20;
+	unsigned long runtime;
 	int readyfds[2], wakefds[2];
 	char dummy;
 	pthread_t *pth_tab;
@@ -307,8 +307,8 @@ int bench_sched_messaging(int argc, const char **argv,
 		reap_worker(pth_tab[i]);
 
 	gettimeofday(&stop, NULL);
-
 	timersub(&stop, &start, &diff);
+	runtime = (diff.tv_sec * 1e3) + (diff.tv_usec/1e3);
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
@@ -317,13 +317,10 @@ int bench_sched_messaging(int argc, const char **argv,
 		printf("# %d groups == %d %s run\n\n",
 		       num_groups, num_groups * 2 * num_fds,
 		       thread_mode ? "threads" : "processes");
-		printf(" %14s: %lu.%03lu [sec]\n", "Total time",
-		       diff.tv_sec,
-		       (unsigned long) (diff.tv_usec/1000));
+		printf(" %14s: %.3f [sec]\n", "Total time", runtime/1e3);
 		break;
 	case BENCH_FORMAT_SIMPLE:
-		printf("%lu.%03lu\n", diff.tv_sec,
-		       (unsigned long) (diff.tv_usec/1000));
+		printf("%.3f\n", runtime/1e3);
 		break;
 	default:
 		/* reaching here is something disaster */
-- 
1.8.1.4

