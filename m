Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936074Ab3DHU05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:26:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936007Ab3DHU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:26:55 -0400
Date: Mon, 8 Apr 2013 13:26:06 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-0d24260c9e27fc1de20c72669bcc387767a1c170@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        ysato@users.sourceforge.jp, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, magnus.damm@gmail.com,
        ysato@users.sourceforge.jp
In-Reply-To: <20130321215234.277153345@linutronix.de>
References: <20130321215234.277153345@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] h8300: Use generic idle loop
Git-Commit-ID: 0d24260c9e27fc1de20c72669bcc387767a1c170
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:26:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d24260c9e27fc1de20c72669bcc387767a1c170
Gitweb:     http://git.kernel.org/tip/0d24260c9e27fc1de20c72669bcc387767a1c170
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:45 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:25 +0200

h8300: Use generic idle loop

Use the core idle poll function instead of the private one

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Link: http://lkml.kernel.org/r/20130321215234.277153345@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/h8300/Kconfig          |  1 +
 arch/h8300/kernel/process.c | 35 ++++-------------------------------
 2 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 79250de..5374975 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -8,6 +8,7 @@ config H8300
 	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IDLE_LOOP
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index b609f63..a17d2cd 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -53,40 +53,13 @@ asmlinkage void ret_from_kernel_thread(void);
  * The idle loop on an H8/300..
  */
 #if !defined(CONFIG_H8300H_SIM) && !defined(CONFIG_H8S_SIM)
-static void default_idle(void)
+void arch_cpu_idle(void)
 {
-	local_irq_disable();
-	if (!need_resched()) {
-		local_irq_enable();
-		/* XXX: race here! What if need_resched() gets set now? */
-		__asm__("sleep");
-	} else
-		local_irq_enable();
-}
-#else
-static void default_idle(void)
-{
-	cpu_relax();
+	local_irq_enable();
+	/* XXX: race here! What if need_resched() gets set now? */
+	__asm__("sleep");
 }
 #endif
-void (*idle)(void) = default_idle;
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
 
 void machine_restart(char * __unused)
 {
