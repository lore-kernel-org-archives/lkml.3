Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaLSNKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:10:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaLSNKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:10:42 -0500
Date: Fri, 19 Dec 2014 05:09:37 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a5fd9733a30d18d7ac23f17080e7e07bb3205b69@git.kernel.org>
Cc: frederic@kernel.org, preeti@linux.vnet.ibm.com, rui.zhang@intel.com,
        tglx@linutronix.de, fweisbec@gmail.com, fengguang.wu@intel.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org, lkp@01.org,
        hpa@zytor.com, mingo@kernel.org, jacob.jun.pan@intel.com,
        viresh.kumar@linaro.org
Reply-To: preeti@linux.vnet.ibm.com, frederic@kernel.org,
        fengguang.wu@intel.com, fweisbec@gmail.com, rui.zhang@intel.com,
        tglx@linutronix.de, hpa@zytor.com, lkp@01.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        jacob.jun.pan@intel.com, viresh.kumar@linaro.org, mingo@kernel.org
In-Reply-To: <alpine.DEB.2.11.1412181110110.17382@nanos>
References: <alpine.DEB.2.11.1412181110110.17382@nanos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick/powerclamp: Remove tick_nohz_idle abuse
Git-Commit-ID: a5fd9733a30d18d7ac23f17080e7e07bb3205b69
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

Commit-ID:  a5fd9733a30d18d7ac23f17080e7e07bb3205b69
Gitweb:     http://git.kernel.org/tip/a5fd9733a30d18d7ac23f17080e7e07bb3205b69
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 18 Dec 2014 11:51:01 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 19 Dec 2014 14:05:52 +0100

tick/powerclamp: Remove tick_nohz_idle abuse

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412181110110.17382@nanos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/thermal/intel_powerclamp.c | 2 --
 kernel/time/tick-sched.c           | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 95cb7fc..6cb7849 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -435,7 +435,6 @@ static int clamp_thread(void *arg)
 		 * allowed. thus jiffies are updated properly.
 		 */
 		preempt_disable();
-		tick_nohz_idle_enter();
 		/* mwait until target jiffies is reached */
 		while (time_before(jiffies, target_jiffies)) {
 			unsigned long ecx = 1;
@@ -451,7 +450,6 @@ static int clamp_thread(void *arg)
 			start_critical_timings();
 			atomic_inc(&idle_wakeup_counter);
 		}
-		tick_nohz_idle_exit();
 		preempt_enable();
 	}
 	del_timer_sync(&wakeup_timer);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1f43560..ff3ec34 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -847,7 +847,6 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
 
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
@@ -974,7 +973,6 @@ void tick_nohz_idle_exit(void)
 
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
 
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {
