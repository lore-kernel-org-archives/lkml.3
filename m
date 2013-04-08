Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935809Ab3DHUXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:23:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762769Ab3DHUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:23:09 -0400
Date: Mon, 8 Apr 2013 13:22:29 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-e46746cd5542b74f1e34bb1b8a997c5c0a6e69ea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        msalter@redhat.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        msalter@redhat.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.087033904@linutronix.de>
References: <20130321215234.087033904@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] c6x: Use generic idle loop
Git-Commit-ID: e46746cd5542b74f1e34bb1b8a997c5c0a6e69ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:22:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e46746cd5542b74f1e34bb1b8a997c5c0a6e69ea
Gitweb:     http://git.kernel.org/tip/e46746cd5542b74f1e34bb1b8a997c5c0a6e69ea
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:42 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:24 +0200

c6x: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Link: http://lkml.kernel.org/r/20130321215234.087033904@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/c6x/Kconfig          |  1 +
 arch/c6x/kernel/process.c | 28 +---------------------------
 2 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index f6a3648..af2aa4b 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -18,6 +18,7 @@ config C6X
 	select OF_EARLY_FLATTREE
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select GENERIC_IDLE_LOOP
 
 config MMU
 	def_bool n
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 6434df4..57d2ea8 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -33,7 +33,7 @@ extern asmlinkage void ret_from_kernel_thread(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-static void c6x_idle(void)
+void arch_cpu_idle(void)
 {
 	unsigned long tmp;
 
@@ -49,32 +49,6 @@ static void c6x_idle(void)
 		      : "=b"(tmp));
 }
 
-/*
- * The idle loop for C64x
- */
-void cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (1) {
-			local_irq_disable();
-			if (need_resched()) {
-				local_irq_enable();
-				break;
-			}
-			c6x_idle(); /* enables local irqs */
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
-
 static void halt_loop(void)
 {
 	printk(KERN_EMERG "System Halted, OK to turn off power\n");
