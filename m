Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936011Ab3DHUR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:17:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935984Ab3DHUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:17:26 -0400
Date: Mon, 8 Apr 2013 13:16:27 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a123322d8afcfb5f86e0cc0062024084658aeeb2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, magnus.damm@gmail.com,
        rth@twiddle.net
In-Reply-To: <20130321215233.766017538@linutronix.de>
References: <20130321215233.766017538@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] alpha: Use generic idle loop
Git-Commit-ID: a123322d8afcfb5f86e0cc0062024084658aeeb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:16:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a123322d8afcfb5f86e0cc0062024084658aeeb2
Gitweb:     http://git.kernel.org/tip/a123322d8afcfb5f86e0cc0062024084658aeeb2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:37 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:23 +0200

alpha: Use generic idle loop

The core provides a generic idle poll loop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Link: http://lkml.kernel.org/r/20130321215233.766017538@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/Kconfig          |  1 +
 arch/alpha/kernel/process.c | 19 -------------------
 arch/alpha/kernel/smp.c     |  3 +--
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 8a33ba0..6046982 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -17,6 +17,7 @@ config ALPHA
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 63d27fb..a3fd8a2 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -46,25 +46,6 @@
 void (*pm_power_off)(void) = machine_power_off;
 EXPORT_SYMBOL(pm_power_off);
 
-void
-cpu_idle(void)
-{
-	current_thread_info()->status |= TS_POLLING;
-
-	while (1) {
-		/* FIXME -- EV6 and LCA45 know how to power down
-		   the CPU.  */
-
-		rcu_idle_enter();
-		while (!need_resched())
-			cpu_relax();
-
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
-
 struct halt_info {
 	int mode;
 	char *restart_cmd;
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 9603bc2..7b60834 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -167,8 +167,7 @@ smp_callin(void)
 	      cpuid, current, current->active_mm));
 
 	preempt_disable();
-	/* Do nothing.  */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 /* Wait until hwrpb->txrdy is clear for cpu.  Return -1 on timeout.  */
