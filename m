Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753Ab3FSNCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:02:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:55016 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833Ab3FSNCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:02:21 -0400
Date: Wed, 19 Jun 2013 15:02:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] core fixes for 3.10
Message-ID: <alpine.DEB.2.02.1306191454210.4013@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

 * Add a missing irq enable. Fallout of the idle conversion
 * Fix stackprotector wreckage caused by the idle conversion

Thanks,

	tglx

------------------>
James Bottomley (1):
      idle: Enable interrupts in the weak arch_cpu_idle() implementation

Thomas Gleixner (1):
      idle: Add the stack canary init to cpu_startup_entry()


 arch/x86/kernel/process.c |   12 ------------
 kernel/cpu/idle.c         |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4e7a37f..81a5f5e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -277,18 +277,6 @@ void exit_idle(void)
 }
 #endif
 
-void arch_cpu_idle_prepare(void)
-{
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-}
-
 void arch_cpu_idle_enter(void)
 {
 	local_touch_nmi();
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index d5585f5..e695c0a 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -5,6 +5,7 @@
 #include <linux/cpu.h>
 #include <linux/tick.h>
 #include <linux/mm.h>
+#include <linux/stackprotector.h>
 
 #include <asm/tlb.h>
 
@@ -58,6 +59,7 @@ void __weak arch_cpu_idle_dead(void) { }
 void __weak arch_cpu_idle(void)
 {
 	cpu_idle_force_poll = 1;
+	local_irq_enable();
 }
 
 /*
@@ -112,6 +114,21 @@ static void cpu_idle_loop(void)
 
 void cpu_startup_entry(enum cpuhp_state state)
 {
+	/*
+	 * This #ifdef needs to die, but it's too late in the cycle to
+	 * make this generic (arm and sh have never invoked the canary
+	 * init for the non boot cpus!). Will be fixed in 3.11
+	 */
+#ifdef CONFIG_X86
+	/*
+	 * If we're the non-boot CPU, nothing set the stack canary up
+	 * for us. The boot CPU already has it initialized but no harm
+	 * in doing it again. This is a good place for updating it, as
+	 * we wont ever return from this function (so the invalid
+	 * canaries already on the stack wont ever trigger).
+	 */
+	boot_init_stack_canary();
+#endif
 	current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
