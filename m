Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3KTQd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:33:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46543 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab3KTQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:32:59 -0500
Message-Id: <20131120162736.691879744@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 20 Nov 2013 17:04:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
References: <20131120160450.072555619@infradead.org>
Content-Disposition: inline; filename=peterz-fixup-weird-preempt_enable_no_resched-usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only valid use of preempt_enable_no_resched() is if the very next
line is schedule() or if we know preemption cannot actually be enabled
by that statement due to known more preempt_count 'refs'.

As to the busy_poll mess; that looks to be completely and utterly
broken, sched_clock() can return utter garbage with interrupts enabled
(rare but still), it can drift unbounded between CPUs, so if you get
preempted/migrated and your new CPU is years behind on the previous
CPU we get to busy spin for a _very_ long time. There is a _REASON_
sched_clock() warns about preemptability - papering over it with a
preempt_disable()/preempt_enable_no_resched() is just terminal brain
damage on so many levels.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/net/busy_poll.h |   20 ++++++++------------
 net/ipv4/tcp.c          |    4 ++--
 2 files changed, 10 insertions(+), 14 deletions(-)

--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -42,27 +42,23 @@ static inline bool net_busy_loop_on(void
 	return sysctl_net_busy_poll;
 }
 
-/* a wrapper to make debug_smp_processor_id() happy
- * we can use sched_clock() because we don't care much about precision
- * we only care that the average is bounded
- */
-#ifdef CONFIG_DEBUG_PREEMPT
 static inline u64 busy_loop_us_clock(void)
 {
 	u64 rc;
 
+	/*
+	 * XXX with interrupts enabled sched_clock() can return utter garbage
+	 * Futhermore, it can have unbounded drift between CPUs, so the below
+	 * usage is terminally broken and only serves to shut up a valid debug
+	 * warning.
+	 */
+
 	preempt_disable_notrace();
 	rc = sched_clock();
-	preempt_enable_no_resched_notrace();
+	preempt_enable_notrace();
 
 	return rc >> 10;
 }
-#else /* CONFIG_DEBUG_PREEMPT */
-static inline u64 busy_loop_us_clock(void)
-{
-	return sched_clock() >> 10;
-}
-#endif /* CONFIG_DEBUG_PREEMPT */
 
 static inline unsigned long sk_busy_loop_end_time(struct sock *sk)
 {
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1623,11 +1623,11 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 		    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
 		    !sysctl_tcp_low_latency &&
 		    net_dma_find_channel()) {
-			preempt_enable_no_resched();
+			preempt_enable();
 			tp->ucopy.pinned_list =
 					dma_pin_iovec_pages(msg->msg_iov, len);
 		} else {
-			preempt_enable_no_resched();
+			preempt_enable();
 		}
 	}
 #endif


