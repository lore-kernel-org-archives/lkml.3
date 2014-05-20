Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaETVje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:39:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:62483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaETVjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:39:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,876,1392192000"; 
   d="scan'208";a="543852342"
Subject: Re: [PATCH] sched: Reduce the rate of needless idle load balancing
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Russ Anderson <rja@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGQ1y=4z69iNRAM8eZFhh=kjRYQgwDxyMjyNG4XJ0b1xOxLURA@mail.gmail.com>
References: <1400617046.2970.270.camel@schen9-DESK>
	 <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
	 <1400619550.2970.274.camel@schen9-DESK>
	 <CAGQ1y=4z69iNRAM8eZFhh=kjRYQgwDxyMjyNG4XJ0b1xOxLURA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 May 2014 14:39:27 -0700
Message-ID: <1400621967.2970.280.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 14:09 -0700, Jason Low wrote:

> Hi Tim, Rik
> 
> Yes, that makes sense that we want to balance if they are equal. We
> may also consider using "if (time_after_eq(jiffies,
> rq->next_balance)".
> 
> Reviewed-by: Jason Low <jason.low2@hp.com>

Jason & Rik,

Thanks for reviewing the patch.  I've updated the patch below as
suggested.

Tim

---

From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH v2] sched: Reduce the rate of needless idle load balancing


The current no_hz idle load balancer do load balancing for *all* idle cpus,
even though the time due to load balance for a particular
idle cpu could be still a while in the future.  This introduces a much
higher load balancing rate than what is necessary.  The patch
changes the behavior by only doing idle load balancing on
behalf of an idle cpu only when it is due for load balancing.

On SGI's systems with over 3000 cores, the cpu responsible for idle balancing
got overwhelmed with idle balancing, and introduces a lot of OS noise
to workloads.  This patch fixes the issue.

Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/fair.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b4c4f3..b826c3a 100644
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
+		if (time_after_eq(jiffies, rq->next_balance)) {
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




