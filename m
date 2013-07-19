Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935390Ab3GSHsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:48:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935322Ab3GSHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:48:26 -0400
Date: Fri, 19 Jul 2013 00:48:09 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f36f83f947ede547833e462696893f866df77324@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1370324779-16921-1-git-send-email-namhyung@kernel.org>
References: <1370324779-16921-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched:
  Move struct perf_sched definition out of cmd_sched()
Git-Commit-ID: f36f83f947ede547833e462696893f866df77324
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:48:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f36f83f947ede547833e462696893f866df77324
Gitweb:     http://git.kernel.org/tip/f36f83f947ede547833e462696893f866df77324
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:46:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:35 -0300

perf sched: Move struct perf_sched definition out of cmd_sched()

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
