Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161245Ab3DEKWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:22:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58723 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765935Ab3DEKWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:22:12 -0400
X-AuditID: 9c930197-b7b50ae00000018c-87-515ea5d28ddd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf sched: Move struct perf_sched definition out of cmd_sched()
Date: Fri,  5 Apr 2013 19:22:00 +0900
Message-Id: <1365157320-22586-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For some reason it consumed quite amount of compile time when declared
as local variable, and it disappeared when moved out of the function.
Moving other variables/tables didn't help.

On my system this single-file-change build time reduced from 11s to 3s.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-sched.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2da2a6ca22bf..2eddd71baa94 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1663,28 +1663,29 @@ static int __cmd_record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
+static const char default_sort_order[] = "avg, max, switch, runtime";
+static struct perf_sched sched = {
+	.tool = {
+		.sample		 = perf_sched__process_tracepoint_sample,
+		.comm		 = perf_event__process_comm,
+		.lost		 = perf_event__process_lost,
+		.fork		 = perf_event__process_fork,
+		.ordered_samples = true,
+	},
+	.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
+	.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
+	.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
+	.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
+	.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
+	.sort_order	      = default_sort_order,
+	.replay_repeat	      = 10,
+	.profile_cpu	      = -1,
+	.next_shortname1      = 'A',
+	.next_shortname2      = '0',
+};
+
 int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	const char default_sort_order[] = "avg, max, switch, runtime";
-	struct perf_sched sched = {
-		.tool = {
-			.sample		 = perf_sched__process_tracepoint_sample,
-			.comm		 = perf_event__process_comm,
-			.lost		 = perf_event__process_lost,
-			.fork		 = perf_event__process_fork,
-			.ordered_samples = true,
-		},
-		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
-		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
-		.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
-		.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
-		.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
-		.sort_order	      = default_sort_order,
-		.replay_repeat	      = 10,
-		.profile_cpu	      = -1,
-		.next_shortname1      = 'A',
-		.next_shortname2      = '0',
-	};
 	const struct option latency_options[] = {
 	OPT_STRING('s', "sort", &sched.sort_order, "key[,key2...]",
 		   "sort by key(s): runtime, switch, avg, max"),
-- 
1.7.11.7

