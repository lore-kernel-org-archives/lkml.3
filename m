Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaEHKpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:45:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaEHKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:45:36 -0400
Date: Thu, 8 May 2014 03:44:33 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-39a4d9ca77a31503c6317e49742341d0859d5cb2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, jason.low2@hp.com
In-Reply-To: <1398303035-18255-4-git-send-email-jason.low2@hp.com>
References: <1398303035-18255-4-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Stop searching for tasks in newidle balance if there are runnable tasks
Git-Commit-ID: 39a4d9ca77a31503c6317e49742341d0859d5cb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39a4d9ca77a31503c6317e49742341d0859d5cb2
Gitweb:     http://git.kernel.org/tip/39a4d9ca77a31503c6317e49742341d0859d5cb2
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Wed, 23 Apr 2014 18:30:35 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:53 +0200

sched/fair: Stop searching for tasks in newidle balance if there are runnable tasks

It was found that when running some workloads (such as AIM7) on large
systems with many cores, CPUs do not remain idle for long. Thus, tasks
can wake/get enqueued while doing idle balancing.

In this patch, while traversing the domains in idle balance, in
addition to checking for pulled_task, we add an extra check for
this_rq->nr_running for determining if we should stop searching for
tasks to pull. If there are runnable tasks on this rq, then we will
stop traversing the domains. This reduces the chance that idle balance
delays a task from running.

This patch resulted in approximately a 6% performance improvement when
running a Java Server workload on an 8 socket machine.

Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: daniel.lezcano@linaro.org
Cc: alex.shi@linaro.org
Cc: preeti@linux.vnet.ibm.com
Cc: efault@gmx.de
Cc: vincent.guittot@linaro.org
Cc: morten.rasmussen@arm.com
Cc: aswin@hp.com
Cc: chegu_vinod@hp.com
Link: http://lkml.kernel.org/r/1398303035-18255-4-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 051903f..28ccf50 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6713,7 +6713,6 @@ static int idle_balance(struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			t0 = sched_clock_cpu(this_cpu);
 
-			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance(this_cpu, this_rq,
 						   sd, CPU_NEWLY_IDLE,
 						   &continue_balancing);
@@ -6728,7 +6727,12 @@ static int idle_balance(struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task)
+
+		/*
+		 * Stop searching for tasks to pull if there are
+		 * now runnable tasks on this rq.
+		 */
+		if (pulled_task || this_rq->nr_running > 0)
 			break;
 	}
 	rcu_read_unlock();
