Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbbA2I7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:59:48 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754271AbbA2I7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Pan Jacob jun <jacob.jun.pan@intel.com>, LKP <lkp@01.org>,
        Peter Zijlstra <peterz@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/176] tick/powerclamp: Remove tick_nohz_idle abuse
Date: Wed, 28 Jan 2015 15:28:32 +0100
Message-Id: <1ff5b9fb934888276864a6cd98c98d0b07741f78.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a5fd9733a30d18d7ac23f17080e7e07bb3205b69 upstream.

commit 4dbd27711cd9 "tick: export nohz tick idle symbols for module
use" was merged via the thermal tree without an explicit ack from the
relevant maintainers.

The exports are abused by the intel powerclamp driver which implements
a fake idle state from a sched FIFO task. This causes all kinds of
wreckage in the NOHZ core code which rightfully assumes that
tick_nohz_idle_enter/exit() are only called from the idle task itself.

Recent changes in the NOHZ core lead to a failure of the powerclamp
driver and now people try to hack completely broken and backwards
workarounds into the NOHZ core code. This is completely unacceptable
and just papers over the real problem. There are way more subtle
issues lurking around the corner.

The real solution is to fix the powerclamp driver by rewriting it with
a sane concept, but that's beyond the scope of this.

So the only solution for now is to remove the calls into the core NOHZ
code from the powerclamp trainwreck along with the exports.

Fixes: d6d71ee4a14a "PM: Introduce Intel PowerClamp Driver"
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Pan Jacob jun <jacob.jun.pan@intel.com>
Cc: LKP <lkp@01.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412181110110.17382@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/thermal/intel_powerclamp.c | 2 --
 kernel/time/tick-sched.c           | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index b40b37cd25e0..d54388a53637 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -426,7 +426,6 @@ static int clamp_thread(void *arg)
 		 * allowed. thus jiffies are updated properly.
 		 */
 		preempt_disable();
-		tick_nohz_idle_enter();
 		/* mwait until target jiffies is reached */
 		while (time_before(jiffies, target_jiffies)) {
 			unsigned long ecx = 1;
@@ -444,7 +443,6 @@ static int clamp_thread(void *arg)
 			start_critical_timings();
 			atomic_inc(&idle_wakeup_counter);
 		}
-		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 	}
 	del_timer_sync(&wakeup_timer);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 29b063b32ff0..67673ca12a19 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -806,7 +806,6 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
 
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
@@ -934,7 +933,6 @@ void tick_nohz_idle_exit(void)
 
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
 
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {
-- 
2.2.2

