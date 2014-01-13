Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaAMQq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:46:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaAMQqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:46:21 -0500
Date: Mon, 13 Jan 2014 08:45:45 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-37089834528be3ef8cbf927e47c753b3e272a856@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        peterz@infradead.org, bitbucket@online.de, davem@davemloft.net,
        eliezer.tamir@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, torvalds@linux-foundation.org,
        peterz@infradead.org, bitbucket@online.de, davem@davemloft.net,
        eliezer.tamir@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20131119151338.GF3694@twins.programming.kicks-ass.net>
References: <20131119151338.GF3694@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, net: Fixup busy_loop_us_clock()
Git-Commit-ID: 37089834528be3ef8cbf927e47c753b3e272a856
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 08:45:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37089834528be3ef8cbf927e47c753b3e272a856
Gitweb:     http://git.kernel.org/tip/37089834528be3ef8cbf927e47c753b3e272a856
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 19 Nov 2013 16:13:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 17:39:11 +0100

sched, net: Fixup busy_loop_us_clock()

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

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131119151338.GF3694@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/net/busy_poll.h | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 829627d..1d67fb6 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -42,27 +42,10 @@ static inline bool net_busy_loop_on(void)
 	return sysctl_net_busy_poll;
 }
 
-/* a wrapper to make debug_smp_processor_id() happy
- * we can use sched_clock() because we don't care much about precision
- * we only care that the average is bounded
- */
-#ifdef CONFIG_DEBUG_PREEMPT
-static inline u64 busy_loop_us_clock(void)
-{
-	u64 rc;
-
-	preempt_disable_notrace();
-	rc = sched_clock();
-	preempt_enable_no_resched_notrace();
-
-	return rc >> 10;
-}
-#else /* CONFIG_DEBUG_PREEMPT */
 static inline u64 busy_loop_us_clock(void)
 {
-	return sched_clock() >> 10;
+	return local_clock() >> 10;
 }
-#endif /* CONFIG_DEBUG_PREEMPT */
 
 static inline unsigned long sk_busy_loop_end_time(struct sock *sk)
 {
