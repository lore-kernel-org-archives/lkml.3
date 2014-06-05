Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaFEOfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:35:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaFEOfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:35:50 -0400
Date: Thu, 5 Jun 2014 07:34:33 -0700
From: tip-bot for Tim Chen <tipbot@zytor.com>
Message-ID: <tip-ed61bbc69c773465782476c7e5869fa5607fa73a@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        peter@hurleysoftware.com, jason.low2@hp.com, sivanich@sgi.com,
        riel@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        andi@firstfloor.org, tim.c.chen@linux.intel.com, hedi@sgi.com,
        rja@sgi.com, walken@google.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, jason.low2@hp.com, peter@hurleysoftware.com,
        sivanich@sgi.com, riel@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, len.brown@intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, andi@firstfloor.org, tim.c.chen@linux.intel.com,
        hedi@sgi.com, rja@sgi.com, walken@google.com
In-Reply-To: <1400621967.2970.280.camel@schen9-DESK>
References: <1400621967.2970.280.camel@schen9-DESK>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/balancing:
  Reduce the rate of needless idle load balancing
Git-Commit-ID: ed61bbc69c773465782476c7e5869fa5607fa73a
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

Commit-ID:  ed61bbc69c773465782476c7e5869fa5607fa73a
Gitweb:     http://git.kernel.org/tip/ed61bbc69c773465782476c7e5869fa5607fa73a
Author:     Tim Chen <tim.c.chen@linux.intel.com>
AuthorDate: Tue, 20 May 2014 14:39:27 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:01 +0200

sched/balancing: Reduce the rate of needless idle load balancing

The current no_hz idle load balancer do load balancing for *all* idle cpus,
even though the time due to load balance for a particular
idle cpu could be still a while in the future.  This introduces a much
higher load balancing rate than what is necessary.  The patch
changes the behavior by only doing idle load balancing on
behalf of an idle cpu only when it is due for load balancing.

On SGI's systems with over 3000 cores, the cpu responsible for idle balancing
got overwhelmed with idle balancing, and introduces a lot of OS noise
to workloads.  This patch fixes the issue.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: MichelLespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1400621967.2970.280.camel@schen9-DESK
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b71d8c3..7a0c000 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7193,12 +7193,17 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
 
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
