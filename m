Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbaETURl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:17:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:33470 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaETURk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:17:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,875,1392192000"; 
   d="scan'208";a="543815942"
Subject: [PATCH] sched: Reduce the rate of needless idle load balancing
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Hedi Berriche <hedi@sgi.com>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 May 2014 13:17:26 -0700
Message-ID: <1400617046.2970.270.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current no_hz idle load balancer do load balancing on *all* idle cpus,
even though the time due to load balance for a particular
idle cpu could be still a while in future.  This introduces a much
higher load balancing rate than what is necessary.  The patch
changes the behavior by only doing idle load balancing on
behalf of an idle cpu only when time is due for load balancing.

On SGI's systems with over 3000 cores, the cpu responsible for idle balancing
got overwhelmed with idle balancing, and introduces a lot of OS noise
to workloads.  This patch fixes the issue.

Thanks.

Tim

Acked-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b4c4f3..97132db 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6764,12 +6764,17 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 
 		rq = cpu_rq(balance_cpu);
 
-		raw_spin_lock_irq(&rq->lock);
-		update_rq_clock(rq);
-		update_idle_cpu_load(rq);
-		raw_spin_unlock_irq(&rq->lock);
-
-		rebalance_domains(rq, CPU_IDLE);
+		/*
+		 * If time for next balance is due,
+		 * do the balance.
+		 */
+		if (time_after(jiffies + 1, rq->next_balance)) {
+			raw_spin_lock_irq(&rq->lock);
+			update_rq_clock(rq);
+			update_idle_cpu_load(rq);
+			raw_spin_unlock_irq(&rq->lock);
+			rebalance_domains(rq, CPU_IDLE);
+		}
 
 		if (time_after(this_rq->next_balance, rq->next_balance))
 			this_rq->next_balance = rq->next_balance;
-- 
1.7.11.7


