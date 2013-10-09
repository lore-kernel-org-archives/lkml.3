Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3JIR0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:26:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3JIR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:26:42 -0400
Date: Wed, 9 Oct 2013 10:26:02 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-19a78d110d7a8045aeb90d38ee8fe9743ce88c2d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-14-git-send-email-mgorman@suse.de>
References: <1381141781-10992-14-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Mitigate chance that same task always updates PTEs
Git-Commit-ID: 19a78d110d7a8045aeb90d38ee8fe9743ce88c2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:26:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19a78d110d7a8045aeb90d38ee8fe9743ce88c2d
Gitweb:     http://git.kernel.org/tip/19a78d110d7a8045aeb90d38ee8fe9743ce88c2d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 7 Oct 2013 11:28:51 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:56 +0200

sched/numa: Mitigate chance that same task always updates PTEs

With a trace_printk("working\n"); right after the cmpxchg in
task_numa_work() we can see that of a 4 thread process, its always the
same task winning the race and doing the protection change.

This is a problem since the task doing the protection change has a
penalty for taking faults -- it is busy when marking the PTEs. If its
always the same task the ->numa_faults[] get severely skewed.

Avoid this by delaying the task doing the protection change such that
it is unlikely to win the privilege again.

Before:

root@interlagos:~# grep "thread 0/.*working" /debug/tracing/trace | tail -15
      thread 0/0-3232  [022] ....   212.787402: task_numa_work: working
      thread 0/0-3232  [022] ....   212.888473: task_numa_work: working
      thread 0/0-3232  [022] ....   212.989538: task_numa_work: working
      thread 0/0-3232  [022] ....   213.090602: task_numa_work: working
      thread 0/0-3232  [022] ....   213.191667: task_numa_work: working
      thread 0/0-3232  [022] ....   213.292734: task_numa_work: working
      thread 0/0-3232  [022] ....   213.393804: task_numa_work: working
      thread 0/0-3232  [022] ....   213.494869: task_numa_work: working
      thread 0/0-3232  [022] ....   213.596937: task_numa_work: working
      thread 0/0-3232  [022] ....   213.699000: task_numa_work: working
      thread 0/0-3232  [022] ....   213.801067: task_numa_work: working
      thread 0/0-3232  [022] ....   213.903155: task_numa_work: working
      thread 0/0-3232  [022] ....   214.005201: task_numa_work: working
      thread 0/0-3232  [022] ....   214.107266: task_numa_work: working
      thread 0/0-3232  [022] ....   214.209342: task_numa_work: working

After:

root@interlagos:~# grep "thread 0/.*working" /debug/tracing/trace | tail -15
      thread 0/0-3253  [005] ....   136.865051: task_numa_work: working
      thread 0/2-3255  [026] ....   136.965134: task_numa_work: working
      thread 0/3-3256  [024] ....   137.065217: task_numa_work: working
      thread 0/3-3256  [024] ....   137.165302: task_numa_work: working
      thread 0/3-3256  [024] ....   137.265382: task_numa_work: working
      thread 0/0-3253  [004] ....   137.366465: task_numa_work: working
      thread 0/2-3255  [026] ....   137.466549: task_numa_work: working
      thread 0/0-3253  [004] ....   137.566629: task_numa_work: working
      thread 0/0-3253  [004] ....   137.666711: task_numa_work: working
      thread 0/1-3254  [028] ....   137.766799: task_numa_work: working
      thread 0/0-3253  [004] ....   137.866876: task_numa_work: working
      thread 0/2-3255  [026] ....   137.966960: task_numa_work: working
      thread 0/1-3254  [028] ....   138.067041: task_numa_work: working
      thread 0/2-3255  [026] ....   138.167123: task_numa_work: working
      thread 0/3-3256  [024] ....   138.267207: task_numa_work: working

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1381141781-10992-14-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 817cd7b..573d815e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -946,6 +946,12 @@ void task_numa_work(struct callback_head *work)
 		return;
 
 	/*
+	 * Delay this task enough that another task of this mm will likely win
+	 * the next time around.
+	 */
+	p->node_stamp += 2 * TICK_NSEC;
+
+	/*
 	 * Do not set pte_numa if the current running node is rate-limited.
 	 * This loses statistics on the fault but if we are unwilling to
 	 * migrate to this node, it is less likely we can do useful work
@@ -1026,7 +1032,7 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	if (now - curr->node_stamp > period) {
 		if (!curr->node_stamp)
 			curr->numa_scan_period = sysctl_numa_balancing_scan_period_min;
-		curr->node_stamp = now;
+		curr->node_stamp += period;
 
 		if (!time_before(jiffies, curr->mm->numa_next_scan)) {
 			init_task_work(work, task_numa_work); /* TODO: move this into sched_fork() */
