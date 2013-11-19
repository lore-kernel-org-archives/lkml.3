Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3KSPNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:13:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40583 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KSPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:13:51 -0500
Date: Tue, 19 Nov 2013 16:13:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
Message-ID: <20131119151338.GF3694@twins.programming.kicks-ass.net>
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
 <20131119090859.GC3694@twins.programming.kicks-ass.net>
 <20131119113153.GD3694@twins.programming.kicks-ass.net>
 <528B7433.7020507@linux.intel.com>
 <20131119145143.GK10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119145143.GK10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 03:51:43PM +0100, Peter Zijlstra wrote:
> That said, that drive is completely wrecked. It uses
> preempt_enable_no_resched() wrong too, it has uncommented barriers..
> 
> Dude, wtf are you guys smoking?

---
Subject: sched: Take away preempt_enable_no_resched() and friends from modules

There is no way in hell modules are going to play preemption tricks like
this.

Cc: eliezer.tamir@linux.intel.com
Cc: arjan@linux.intel.com
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 drivers/thermal/intel_powerclamp.c |  2 +-
 include/linux/preempt.h            |  8 +++++++-
 include/net/busy_poll.h            | 15 +++------------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 8f181b3f842b..0a12ddc2eb4c 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -445,7 +445,7 @@ static int clamp_thread(void *arg)
 			atomic_inc(&idle_wakeup_counter);
 		}
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
+		preempt_enable();
 	}
 	del_timer_sync(&wakeup_timer);
 	clear_bit(cpunr, cpu_clamping_mask);
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index a3d9dc8c2c00..3ed2b5335ab4 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -64,7 +64,7 @@ do { \
 } while (0)
 
 #else
-#define preempt_enable() preempt_enable_no_resched()
+#define preempt_enable() sched_preempt_enable_no_resched()
 #define preempt_check_resched() do { } while (0)
 #endif
 
@@ -116,6 +116,12 @@ do { \
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
+#ifdef MODULE
+#undef preempt_enable_no_resched
+#undef preempt_enable_no_resched_notrace
+#undef preempt_check_resched
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 struct preempt_notifier;
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 829627d7b846..756827a86c2d 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -42,27 +42,18 @@ static inline bool net_busy_loop_on(void)
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
 
+	/* XXX with interrupts enabled sched_clock() can return utter garbage */
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

