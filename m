Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab3DHUin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:38:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936075Ab3DHUim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:38:42 -0400
Date: Mon, 8 Apr 2013 13:38:07 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-fad48ad63dd14656e3b571d42f700a1f2cadd036@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, jejb@parisc-linux.org, tglx@linutronix.de,
        deller@gmx.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, jejb@parisc-linux.org, tglx@linutronix.de,
        magnus.damm@gmail.com, deller@gmx.de
In-Reply-To: <20130321215234.956305981@linutronix.de>
References: <20130321215234.956305981@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] parisc: Use generic idle loop
Git-Commit-ID: fad48ad63dd14656e3b571d42f700a1f2cadd036
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:38:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fad48ad63dd14656e3b571d42f700a1f2cadd036
Gitweb:     http://git.kernel.org/tip/fad48ad63dd14656e3b571d42f700a1f2cadd036
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:55 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:27 +0200

parisc: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Link: http://lkml.kernel.org/r/20130321215234.956305981@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/parisc/Kconfig          |  1 +
 arch/parisc/kernel/process.c | 22 ----------------------
 arch/parisc/kernel/smp.c     |  2 +-
 3 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 0339181..0821e70 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -18,6 +18,7 @@ config PARISC
 	select GENERIC_PCI_IOMAP
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
 	select GENERIC_STRNCPY_FROM_USER
 	select SYSCTL_ARCH_UNALIGN_ALLOW
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d135072..55f92b6 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -59,28 +59,6 @@
 #include <asm/unwind.h>
 #include <asm/sections.h>
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			barrier();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-		check_pgt_cache();
-	}
-}
-
-
 #define COMMAND_GLOBAL  F_EXTEND(0xfffe0030)
 #define CMD_RESET       5       /* reset any module */
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 6266730..fd1bb15 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -329,7 +329,7 @@ void __init smp_callin(void)
 
 	local_irq_enable();  /* Interrupts have been off until now */
 
-	cpu_idle();      /* Wait for timer to schedule some work */
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	/* NOTREACHED */
 	panic("smp_callin() AAAAaaaaahhhh....\n");
