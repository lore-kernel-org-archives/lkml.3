Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3KSSIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:08:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSSH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:07:57 -0500
Date: Tue, 19 Nov 2013 10:07:23 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d689fe222a858c767cb8594faf280048e532b53f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tedheadster@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tedheadster@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] NOHZ:
  Check for nohz active instead of nohz enabled
Git-Commit-ID: d689fe222a858c767cb8594faf280048e532b53f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 10:07:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d689fe222a858c767cb8594faf280048e532b53f
Gitweb:     http://git.kernel.org/tip/d689fe222a858c767cb8594faf280048e532b53f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 13 Nov 2013 21:01:57 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 19 Nov 2013 14:59:50 +0100

NOHZ: Check for nohz active instead of nohz enabled

RCU and the fine grained idle time accounting functions check
tick_nohz_enabled. But that variable is merily telling that NOHZ has
been enabled in the config and not been disabled on the command line.

But it does not tell anything about nohz being active. That's what all
this should check for.

Matthew reported, that the idle accounting on his old P1 machine
showed bogus values, when he enabled NOHZ in the config and did not
disable it on the kernel command line. The reason is that his machine
uses (refined) jiffies as a clocksource which explains why the "fine"
grained accounting went into lala land, because it depends on when the
system goes and leaves idle relative to the jiffies increment.

Provide a tick_nohz_active indicator and let RCU and the accounting
code use this instead of tick_nohz_enable.

Reported-and-tested-by: Matthew Whitehead <tedheadster@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: john.stultz@linaro.org
Cc: mwhitehe@redhat.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de
---
 kernel/rcu/tree_plugin.h |  4 ++--
 kernel/time/tick-sched.c | 21 +++++++++------------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6abb03d..08a7652 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1632,7 +1632,7 @@ module_param(rcu_idle_gp_delay, int, 0644);
 static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
 module_param(rcu_idle_lazy_gp_delay, int, 0644);
 
-extern int tick_nohz_enabled;
+extern int tick_nohz_active;
 
 /*
  * Try to advance callbacks for all flavors of RCU on the current CPU, but
@@ -1729,7 +1729,7 @@ static void rcu_prepare_for_idle(int cpu)
 	int tne;
 
 	/* Handle nohz enablement switches conservatively. */
-	tne = ACCESS_ONCE(tick_nohz_enabled);
+	tne = ACCESS_ONCE(tick_nohz_active);
 	if (tne != rdtp->tick_nohz_enabled_snap) {
 		if (rcu_cpu_has_callbacks(cpu, NULL))
 			invoke_rcu_core(); /* force nohz to see update. */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..a12df5a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -361,8 +361,8 @@ void __init tick_nohz_init(void)
 /*
  * NO HZ enabled ?
  */
-int tick_nohz_enabled __read_mostly  = 1;
-
+static int tick_nohz_enabled __read_mostly  = 1;
+int tick_nohz_active  __read_mostly;
 /*
  * Enable / Disable tickless mode
  */
@@ -465,7 +465,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_active)
 		return -1;
 
 	now = ktime_get();
@@ -506,7 +506,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, iowait;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_active)
 		return -1;
 
 	now = ktime_get();
@@ -799,11 +799,6 @@ void tick_nohz_idle_enter(void)
 	local_irq_disable();
 
 	ts = &__get_cpu_var(tick_cpu_sched);
-	/*
-	 * set ts->inidle unconditionally. even if the system did not
-	 * switch to nohz mode the cpu frequency governers rely on the
-	 * update of the idle time accounting in tick_nohz_start_idle().
-	 */
 	ts->inidle = 1;
 	__tick_nohz_idle_enter(ts);
 
@@ -973,7 +968,7 @@ static void tick_nohz_switch_to_nohz(void)
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t next;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_active)
 		return;
 
 	local_irq_disable();
@@ -981,7 +976,7 @@ static void tick_nohz_switch_to_nohz(void)
 		local_irq_enable();
 		return;
 	}
-
+	tick_nohz_active = 1;
 	ts->nohz_mode = NOHZ_MODE_LOWRES;
 
 	/*
@@ -1139,8 +1134,10 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ_COMMON
-	if (tick_nohz_enabled)
+	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
+		tick_nohz_active = 1;
+	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
