Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965329Ab3GRUGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:06:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41533 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420Ab3GRTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/76] perf sched: Move struct perf_sched definition out of cmd_sched()
Date: Thu, 18 Jul 2013 16:49:21 -0300
Message-Id: <1374177003-3706-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For some reason it consumed quite amount of compile time when declared
as local variable, and it disappeared when moved out of the function.
Moving other variables/tables didn't help.

On my system this single-file-change build time reduced from 11s to 3s.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1370324779-16921-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index fed9ae4..fba4a94 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1662,28 +1662,29 @@ static int __cmd_record(int argc, const char **argv)
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
1.8.1.4

