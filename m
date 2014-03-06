Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaCFR4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:56:55 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:44009 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaCFR4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:56:53 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 5/6] sched: Remove needless round trip nsecs <-> tick conversion of steal time
Date: Thu,  6 Mar 2014 18:56:40 +0100
Message-Id: <1394128601-26034-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When update_rq_clock_task() accounts the pending steal time for a task,
it converts the steal delta from nsecs to tick then from tick to nsecs.

There is no apparent good reason for doing that though because both
the task clock and the prev steal delta are u64 and store values
in nsecs.

So lets remove the needless conversion.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c  |  6 ------
 kernel/sched/sched.h | 10 ----------
 2 files changed, 16 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..b14a188 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -823,19 +823,13 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
 	if (static_key_false((&paravirt_steal_rq_enabled))) {
-		u64 st;
-
 		steal = paravirt_steal_clock(cpu_of(rq));
 		steal -= rq->prev_steal_time_rq;
 
 		if (unlikely(steal > delta))
 			steal = delta;
 
-		st = steal_ticks(steal);
-		steal = st * TICK_NSEC;
-
 		rq->prev_steal_time_rq += steal;
-
 		delta -= steal;
 	}
 #endif
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2119fd..5ec9910 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1214,16 +1214,6 @@ extern void update_idle_cpu_load(struct rq *this_rq);
 
 extern void init_task_runnable_average(struct task_struct *p);
 
-#ifdef CONFIG_PARAVIRT
-static inline u64 steal_ticks(u64 steal)
-{
-	if (unlikely(steal > NSEC_PER_SEC))
-		return div_u64(steal, TICK_NSEC);
-
-	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
-}
-#endif
-
 static inline void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
-- 
1.8.3.1

