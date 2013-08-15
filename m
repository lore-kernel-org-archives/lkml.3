Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3HOJDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:03:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3HOJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:02:56 -0400
Message-ID: <1376557265.5798.29.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Date: Thu, 15 Aug 2013 11:01:05 +0200
In-Reply-To: <520BA590.2030808@zytor.com>
References: <20130814131539.790947874@chello.nl>
	 <520B8A81.1080405@zytor.com> <1376494751.7355.28.camel@marge.simpson.net>
	 <520BA590.2030808@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:3gnTLSfiMZ4CM/0wx4tXJi4wwSGEJlJ8RLxdHkYkOb9
 oNzctaXhPVn5D826F3ucBGDAHEgwmTeG0+4WxqXRPHesglRl1j
 5qIxpU13XYJ+T14oyekfZ7lNEJtl9l13RWmWOvnrQp05cHXex6
 B+FT6EE6xJDA5iNjRpqqg3jyVyJ0ul1wfFGKXuJ1YxrjOJsD6g
 nqDvdDk/6LnX4oUE4gvU1Wtl/IDiTiHVilDO5NCYlXhOa0R56r
 ozhUu2lsaVCCLzRqnvEkl88HOeFAa3lOVnB1KKTdHars1RGw+O
 CiJ6pfJbgBL2pheePATkohiKwbd1rnX27CrtDYGTCCLrX5+z3n
 Z2X1qCNY93l0N5X+5fczHtQPqMpMLspA5HE5I5O5NAgrDBtASQ
 BIxvIeQ1GrZtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 08:43 -0700, H. Peter Anvin wrote: 
> On 08/14/2013 08:39 AM, Mike Galbraith wrote:
> > 
> > ..so could the rq = cpu_rq(cpu) sequence be improved cycle expenditure
> > wise by squirreling rq pointer away in a percpu this_rq, and replacing
> > cpu_rq(cpu) above with a __this_cpu_read(this_rq) version of this_rq()?
> > 
> 
> Yes.

Oh darn, that worked out about as you'd expect.  Cycles are so far down
in the frog hair as to be invisible, so not be worth the space cost.

pinned sched_yield proggy, switches/sec, 3 boots/5 runs each:
                                                                            avg
pre:      1650522     1580422     1604430     1611697     1612928     1611999.8
          1682789     1609103     1603866     1559040     1607424     1612444.4
          1608265     1607513     1606730     1607079     1635914     1613100.2
                                                                      1612514.8  avg avg  1.000

post:     1649396     1595364     1621720     1643665     1641829     1630394.8
          1571322     1591638     1575406     1629960     1592129     1592091.0
          1641807     1622591     1620581     1651145     1663025     1639829.8
                                                                      1620771.8  avg avg  1.005

---
 kernel/sched/core.c  |    8 ++++----
 kernel/sched/sched.h |   12 +++++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -111,6 +111,7 @@ void start_bandwidth_timer(struct hrtime
 
 DEFINE_MUTEX(sched_domains_mutex);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rq *, runqueue);
 
 static void update_rq_clock_task(struct rq *rq, s64 delta);
 
@@ -2390,7 +2391,7 @@ static void __sched __schedule(void)
 need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
-	rq = cpu_rq(cpu);
+	rq = this_rq();
 	rcu_note_context_switch(cpu);
 	prev = rq->curr;
 
@@ -2447,8 +2448,7 @@ static void __sched __schedule(void)
 		 * this task called schedule() in the past. prev == current
 		 * is still correct, but it can be moved to another cpu/rq.
 		 */
-		cpu = smp_processor_id();
-		rq = cpu_rq(cpu);
+		rq = this_rq();
 	} else
 		raw_spin_unlock_irq(&rq->lock);
 
@@ -6470,7 +6470,7 @@ void __init sched_init(void)
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
-		rq = cpu_rq(i);
+		rq = per_cpu(runqueue, i) = &per_cpu(runqueues, i);
 		raw_spin_lock_init(&rq->lock);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -537,11 +537,17 @@ static inline int cpu_of(struct rq *rq)
 
 DECLARE_PER_CPU(struct rq, runqueues);
 
-#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
-#define this_rq()		(&__get_cpu_var(runqueues))
+/*
+ * Runqueue pointer for use by macros to avoid costly code generated
+ * by taking the address of percpu variables.
+ */
+DECLARE_PER_CPU(struct rq *, runqueue);
+
+#define cpu_rq(cpu)		(per_cpu(runqueue, (cpu)))
+#define this_rq()		(__this_cpu_read(runqueue))
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
-#define raw_rq()		(&__raw_get_cpu_var(runqueues))
+#define raw_rq()		(__raw_get_cpu_var(runqueue))
 
 static inline u64 rq_clock(struct rq *rq)
 {


