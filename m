Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaESMb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbaESMbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:31:23 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/8] perf sched: Remove nr_state_machine_bugs in perf latency
Date: Mon, 19 May 2014 14:30:50 +0200
Message-Id: <1400502656-20751-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
References: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

As we do not use .success in sched_wakeup event any more, then
we can not guarantee that the task when wakeup event happen is
out of run queue. So the message of nr_state_machine_bugs is
not correct.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/1399945101-21736-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-sched.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a3320f1..0b4fe53 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -149,7 +149,6 @@ struct perf_sched {
 	unsigned long	 nr_runs;
 	unsigned long	 nr_timestamps;
 	unsigned long	 nr_unordered_timestamps;
-	unsigned long	 nr_state_machine_bugs;
 	unsigned long	 nr_context_switch_bugs;
 	unsigned long	 nr_events;
 	unsigned long	 nr_lost_chunks;
@@ -1032,12 +1031,18 @@ static int latency_wakeup_event(struct perf_sched *sched,
 	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
 
 	/*
+	 * As we do not guarantee the wakeup event happens when
+	 * task is out of run queue, also may happen when task is
+	 * on run queue and wakeup only change ->state to TASK_RUNNING,
+	 * then we should not set the ->wake_up_time when wake up a
+	 * task which is on run queue.
+	 *
 	 * You WILL be missing events if you've recorded only
 	 * one CPU, or are only looking at only one, so don't
-	 * make useless noise.
+	 * skip in this case.
 	 */
 	if (sched->profile_cpu == -1 && atom->state != THREAD_SLEEPING)
-		sched->nr_state_machine_bugs++;
+		return 0;
 
 	sched->nr_timestamps++;
 	if (atom->sched_out_time > timestamp) {
@@ -1496,14 +1501,6 @@ static void print_bad_events(struct perf_sched *sched)
 			(double)sched->nr_lost_events/(double)sched->nr_events * 100.0,
 			sched->nr_lost_events, sched->nr_events, sched->nr_lost_chunks);
 	}
-	if (sched->nr_state_machine_bugs && sched->nr_timestamps) {
-		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
-			(double)sched->nr_state_machine_bugs/(double)sched->nr_timestamps*100.0,
-			sched->nr_state_machine_bugs, sched->nr_timestamps);
-		if (sched->nr_lost_events)
-			printf(" (due to lost events?)");
-		printf("\n");
-	}
 	if (sched->nr_context_switch_bugs && sched->nr_timestamps) {
 		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
 			(double)sched->nr_context_switch_bugs/(double)sched->nr_timestamps*100.0,
-- 
1.8.3.1

