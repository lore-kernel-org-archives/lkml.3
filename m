Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3LLOZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:25:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3LLOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:14 -0500
Message-Id: <20131212141654.940531026@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 06/15] sched, net: Fixup busy_loop_us_clock()
References: <20131212140835.729222186@infradead.org>
Content-Disposition: inline; filename=peterz-fixup-busy_poll.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only valid use of preempt_enable_no_resched() is if the very next
line is schedule() or if we know preemption cannot actually be enabled
by that statement due to known more preempt_count 'refs'.

This busy_poll stuff looks to be completely and utterly broken,
sched_clock() can return utter garbage with interrupts enabled (rare
but still) and it can drift unbounded between CPUs.

This means that if you get preempted/migrated and your new CPU is
years behind on the previous CPU we get to busy spin for a _very_ long
time.

There is a _REASON_ sched_clock() warns about preemptability -
papering over it with a preempt_disable()/preempt_enable_no_resched()
is just terminal brain damage on so many levels.

Replace sched_clock() usage with local_clock() which has a bounded
drift between CPUs (<2 jiffies).

There is a further problem with the entire busy wait poll thing in
that the spin time is additive to the syscall timeout, not inclusive.

Cc: David S. Miller <davem@davemloft.net>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/net/busy_poll.h |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -42,27 +42,10 @@ static inline bool net_busy_loop_on(void
 	return sysctl_net_busy_poll;
 }
 
-/* a wrapper to make debug_smp_processor_id() happy
- * we can use sched_clock() because we don't care much about precision
- * we only care that the average is bounded
- */
-#ifdef CONFIG_DEBUG_PREEMPT
 static inline u64 busy_loop_us_clock(void)
 {
-	u64 rc;
-
-	preempt_disable_notrace();
-	rc = sched_clock();
-	preempt_enable_no_resched_notrace();
-
-	return rc >> 10;
-}
-#else /* CONFIG_DEBUG_PREEMPT */
-static inline u64 busy_loop_us_clock(void)
-{
-	return sched_clock() >> 10;
+	return local_clock() >> 10;
 }
-#endif /* CONFIG_DEBUG_PREEMPT */
 
 static inline unsigned long sk_busy_loop_end_time(struct sock *sk)
 {


