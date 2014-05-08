Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaEHKnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:43:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaEHKnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:43:11 -0400
Date: Thu, 8 May 2014 03:41:04 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-2d513868e2a33e1d5315490ef4c861ee65babd65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, rmk+kernel@arm.linux.org.uk, sruffell@digium.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, venki@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, peterz@infradead.org, sruffell@digium.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, venki@google.com
In-Reply-To: <alpine.DEB.2.02.1405022307000.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1405022307000.6261@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Sanitize irq accounting madness
Git-Commit-ID: 2d513868e2a33e1d5315490ef4c861ee65babd65
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

Commit-ID:  2d513868e2a33e1d5315490ef4c861ee65babd65
Gitweb:     http://git.kernel.org/tip/2d513868e2a33e1d5315490ef4c861ee65babd65
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 2 May 2014 23:26:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:51:30 +0200

sched: Sanitize irq accounting madness

Russell reported, that irqtime_account_idle_ticks() takes ages due to:

       for (i = 0; i < ticks; i++)
               irqtime_account_process_tick(current, 0, rq);

It's sad, that this code was written way _AFTER_ the NOHZ idle
functionality was available. I charge myself guitly for not paying
attention when that crap got merged with commit abb74cefa ("sched:
Export ns irqtimes through /proc/stat")

So instead of looping nr_ticks times just apply the whole thing at
once.

As a side note: The whole cputime_t vs. u64 business in that context
wants to be cleaned up as well. There is no point in having all these
back and forth conversions. Lets standardise on u64 nsec for all
kernel internal accounting and be done with it. Everything else does
not make sense at all for fine grained accounting. Frederic, can you
please take care of that?

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Shaun Ruffell <sruffell@digium.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1405022307000.6261@ionos.tec.linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index a95097c..72fdf06 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -332,50 +332,50 @@ out:
  * softirq as those do not count in task exec_runtime any more.
  */
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq)
+					 struct rq *rq, int ticks)
 {
-	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	cputime_t scaled = cputime_to_scaled(cputime_one_jiffy);
+	u64 cputime = (__force u64) cputime_one_jiffy;
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
+	cputime *= ticks;
+	scaled *= ticks;
+
 	if (irqtime_account_hi_update()) {
-		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
+		cpustat[CPUTIME_IRQ] += cputime;
 	} else if (irqtime_account_si_update()) {
-		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
+		cpustat[CPUTIME_SOFTIRQ] += cputime;
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
 		 * So, we have to handle it separately here.
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					CPUTIME_SOFTIRQ);
+		__account_system_time(p, cputime, scaled, CPUTIME_SOFTIRQ);
 	} else if (user_tick) {
-		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+		account_user_time(p, cputime, scaled);
 	} else if (p == rq->idle) {
-		account_idle_time(cputime_one_jiffy);
+		account_idle_time(cputime);
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
-		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
+		account_guest_time(p, cputime, scaled);
 	} else {
-		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
-					CPUTIME_SYSTEM);
+		__account_system_time(p, cputime, scaled,	CPUTIME_SYSTEM);
 	}
 }
 
 static void irqtime_account_idle_ticks(int ticks)
 {
-	int i;
 	struct rq *rq = this_rq();
 
-	for (i = 0; i < ticks; i++)
-		irqtime_account_process_tick(current, 0, rq);
+	irqtime_account_process_tick(current, 0, rq, ticks);
 }
 #else /* CONFIG_IRQ_TIME_ACCOUNTING */
 static inline void irqtime_account_idle_ticks(int ticks) {}
 static inline void irqtime_account_process_tick(struct task_struct *p, int user_tick,
-						struct rq *rq) {}
+						struct rq *rq, int nr_ticks) {}
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
 /*
@@ -464,7 +464,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
 		return;
 
 	if (sched_clock_irqtime) {
-		irqtime_account_process_tick(p, user_tick, rq);
+		irqtime_account_process_tick(p, user_tick, rq, 1);
 		return;
 	}
 
