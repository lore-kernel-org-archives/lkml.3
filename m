Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaEHKnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:43:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33146 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaEHKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:43:15 -0400
Date: Thu, 8 May 2014 03:42:14 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-0e5b5337f0da073e1f17aec3c322ea7826975d0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        jason.low2@hp.com
In-Reply-To: <1398725155-7591-2-git-send-email-jason.low2@hp.com>
References: <1398725155-7591-2-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix updating rq->
 max_idle_balance_cost and rq->next_balance in idle_balance()
Git-Commit-ID: 0e5b5337f0da073e1f17aec3c322ea7826975d0d
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

Commit-ID:  0e5b5337f0da073e1f17aec3c322ea7826975d0d
Gitweb:     http://git.kernel.org/tip/0e5b5337f0da073e1f17aec3c322ea7826975d0d
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Mon, 28 Apr 2014 15:45:54 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:51:36 +0200

sched: Fix updating rq->max_idle_balance_cost and rq->next_balance in idle_balance()

The following commit:

  e5fc66119ec9 ("sched: Fix race in idle_balance()")

can potentially cause rq->max_idle_balance_cost to not be updated,
even when load_balance(NEWLY_IDLE) is attempted and the per-sd
max cost value is updated.

Preeti noticed a similar issue with updating rq->next_balance.

In this patch, we fix this by making sure we still check/update those values
even if a task gets enqueued while browsing the domains.

Signed-off-by: Jason Low <jason.low2@hp.com>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: morten.rasmussen@arm.com
Cc: aswin@hp.com
Cc: daniel.lezcano@linaro.org
Cc: alex.shi@linaro.org
Cc: efault@gmx.de
Cc: vincent.guittot@linaro.org
Link: http://lkml.kernel.org/r/1398725155-7591-2-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..0fdb96d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6653,6 +6653,7 @@ static int idle_balance(struct rq *this_rq)
 	int this_cpu = this_rq->cpu;
 
 	idle_enter_fair(this_rq);
+
 	/*
 	 * We must set idle_stamp _before_ calling idle_balance(), such that we
 	 * measure the duration of idle_balance() as idle time.
@@ -6705,14 +6706,16 @@ static int idle_balance(struct rq *this_rq)
 
 	raw_spin_lock(&this_rq->lock);
 
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
+
 	/*
-	 * While browsing the domains, we released the rq lock.
-	 * A task could have be enqueued in the meantime
+	 * While browsing the domains, we released the rq lock, a task could
+	 * have been enqueued in the meantime. Since we're not going idle,
+	 * pretend we pulled a task.
 	 */
-	if (this_rq->cfs.h_nr_running && !pulled_task) {
+	if (this_rq->cfs.h_nr_running && !pulled_task)
 		pulled_task = 1;
-		goto out;
-	}
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6722,9 +6725,6 @@ static int idle_balance(struct rq *this_rq)
 		this_rq->next_balance = next_balance;
 	}
 
-	if (curr_cost > this_rq->max_idle_balance_cost)
-		this_rq->max_idle_balance_cost = curr_cost;
-
 out:
 	/* Is there a task of a high priority class? */
 	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
