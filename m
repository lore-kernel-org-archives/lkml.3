Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935981Ab3DHUZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:25:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935708Ab3DHUZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:25:38 -0400
Date: Mon, 8 Apr 2013 13:24:54 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ccf8e78fe2a7e92b6d43de8023786b9dd199aab1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215234.217235264@linutronix.de>
References: <20130321215234.217235264@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] frv: Use generic idle loop
Git-Commit-ID: ccf8e78fe2a7e92b6d43de8023786b9dd199aab1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:24:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccf8e78fe2a7e92b6d43de8023786b9dd199aab1
Gitweb:     http://git.kernel.org/tip/ccf8e78fe2a7e92b6d43de8023786b9dd199aab1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:44 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:25 +0200

frv: Use generic idle loop

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20130321215234.217235264@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/Kconfig          |  1 +
 arch/frv/kernel/process.c | 27 +++++----------------------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 2ce731f..0d998db 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -8,6 +8,7 @@ config FRV
 	select HAVE_GENERIC_HARDIRQS
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IDLE_LOOP
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 23916b2..5d40aeb77 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -59,29 +59,12 @@ static void core_sleep_idle(void)
 	mb();
 }
 
-void (*idle)(void) = core_sleep_idle;
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched()) {
-			check_pgt_cache();
-
-			if (!frv_dma_inprogress && idle)
-				idle();
-		}
-		rcu_idle_exit();
-
-		schedule_preempt_disabled();
-	}
+	if (!frv_dma_inprogress)
+		core_sleep_idle();
+	else
+		local_irq_enable();
 }
 
 void machine_restart(char * __unused)
