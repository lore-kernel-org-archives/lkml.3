Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbaFIWqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:46:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907AbaFIWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Shaun Ruffell <sruffell@digium.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.10 02/40] sched: Sanitize irq accounting madness
Date: Mon,  9 Jun 2014 15:48:33 -0700
Message-Id: <20140609224839.290900497@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 2d513868e2a33e1d5315490ef4c861ee65babd65 upstream.

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
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1405022307000.6261@ionos.tec.linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cputime.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -326,50 +326,50 @@ out:
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
@@ -464,7 +464,7 @@ void account_process_tick(struct task_st
 		return;
 
 	if (sched_clock_irqtime) {
-		irqtime_account_process_tick(p, user_tick, rq);
+		irqtime_account_process_tick(p, user_tick, rq, 1);
 		return;
 	}
 


