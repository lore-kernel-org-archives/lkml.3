Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab3CUWBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:01:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:33063 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3CUVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:04 -0400
Message-Id: <20130321215233.826238797@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 08/34] arm: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=arm-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic idle loop and replace enable/disable_hlt with the
respective core functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig                   |    2 
 arch/arm/include/asm/system_misc.h |    3 -
 arch/arm/kernel/process.c          |   96 ++++++++++---------------------------
 arch/arm/kernel/smp.c              |    2 
 arch/arm/mach-gemini/idle.c        |    4 +
 arch/arm/mach-gemini/irq.c         |    2 
 arch/arm/mach-ixp4xx/common.c      |    2 
 arch/arm/mach-omap1/pm.c           |    5 -
 arch/arm/mach-omap2/omap_hwmod.c   |    6 +-
 arch/arm/mach-omap2/pm.c           |    5 -
 arch/arm/mach-orion5x/board-dt.c   |    2 
 arch/arm/mach-orion5x/common.c     |    2 
 arch/arm/mach-shark/core.c         |    2 
 arch/arm/mach-shmobile/suspend.c   |    4 -
 arch/arm/mach-w90x900/dev.c        |    2 
 15 files changed, 47 insertions(+), 92 deletions(-)

Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -15,6 +15,8 @@ config ARM
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
+	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HARDIRQS_SW_RESEND
Index: linux-2.6/arch/arm/include/asm/system_misc.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/system_misc.h
+++ linux-2.6/arch/arm/include/asm/system_misc.h
@@ -21,9 +21,6 @@ extern void (*arm_pm_idle)(void);
 
 extern unsigned int user_debug;
 
-extern void disable_hlt(void);
-extern void enable_hlt(void);
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_ARM_SYSTEM_MISC_H */
Index: linux-2.6/arch/arm/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/process.c
+++ linux-2.6/arch/arm/kernel/process.c
@@ -57,34 +57,6 @@ static const char *isa_modes[] = {
   "ARM" , "Thumb" , "Jazelle", "ThumbEE"
 };
 
-static volatile int hlt_counter;
-
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-	BUG_ON(hlt_counter < 0);
-}
-
-static int __init nohlt_setup(char *__unused)
-{
-	hlt_counter = 1;
-	return 1;
-}
-
-static int __init hlt_setup(char *__unused)
-{
-	hlt_counter = 0;
-	return 1;
-}
-
-__setup("nohlt", nohlt_setup);
-__setup("hlt", hlt_setup);
-
 extern void call_with_stack(void (*fn)(void *), void *arg, void *sp);
 typedef void (*phys_reset_t)(unsigned long);
 
@@ -168,54 +140,38 @@ static void default_idle(void)
 	local_irq_enable();
 }
 
-/*
- * The idle thread.
- * We always respect 'hlt_counter' to prevent low power idle.
- */
-void cpu_idle(void)
+void arch_cpu_idle_prepare(void)
 {
 	local_fiq_enable();
+}
 
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		ledtrig_cpu(CPU_LED_IDLE_START);
-		while (!need_resched()) {
-#ifdef CONFIG_HOTPLUG_CPU
-			if (cpu_is_offline(smp_processor_id()))
-				cpu_die();
+void arch_cpu_idle_enter(void)
+{
+	ledtrig_cpu(CPU_LED_IDLE_START);
+#ifdef CONFIG_PL310_ERRATA_769419
+	wmb();
 #endif
+}
 
-			/*
-			 * We need to disable interrupts here
-			 * to ensure we don't miss a wakeup call.
-			 */
-			local_irq_disable();
-#ifdef CONFIG_PL310_ERRATA_769419
-			wmb();
+void arch_cpu_idle_exit(void)
+{
+	ledtrig_cpu(CPU_LED_IDLE_END);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
+}
 #endif
-			if (hlt_counter) {
-				local_irq_enable();
-				cpu_relax();
-			} else if (!need_resched()) {
-				stop_critical_timings();
-				if (cpuidle_idle_call())
-					default_idle();
-				start_critical_timings();
-				/*
-				 * default_idle functions must always
-				 * return with IRQs enabled.
-				 */
-				WARN_ON(irqs_disabled());
-			} else
-				local_irq_enable();
-		}
-		ledtrig_cpu(CPU_LED_IDLE_END);
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
+
+/*
+ * Called from the core idle loop.
+ */
+void arch_cpu_idle(void)
+{
+	if (cpuidle_idle_call())
+		default_idle();
 }
 
 static char reboot_mode = 'h';
Index: linux-2.6/arch/arm/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/smp.c
+++ linux-2.6/arch/arm/kernel/smp.c
@@ -336,7 +336,7 @@ asmlinkage void __cpuinit secondary_star
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
Index: linux-2.6/arch/arm/mach-gemini/idle.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-gemini/idle.c
+++ linux-2.6/arch/arm/mach-gemini/idle.c
@@ -13,9 +13,11 @@ static void gemini_idle(void)
 	 * will never wakeup... Acctualy it is not very good to enable
 	 * interrupts first since scheduler can miss a tick, but there is
 	 * no other way around this. Platforms that needs it for power saving
-	 * should call enable_hlt() in init code, since by default it is
+	 * should enable it in init code, since by default it is
 	 * disabled.
 	 */
+
+	/* FIXME: Enabling interrupts here is racy! */
 	local_irq_enable();
 	cpu_do_idle();
 }
Index: linux-2.6/arch/arm/mach-gemini/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-gemini/irq.c
+++ linux-2.6/arch/arm/mach-gemini/irq.c
@@ -77,7 +77,7 @@ void __init gemini_init_irq(void)
 	 * Disable the idle handler by default since it is buggy
 	 * For more info see arch/arm/mach-gemini/idle.c
 	 */
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 
 	request_resource(&iomem_resource, &irq_resource);
 
Index: linux-2.6/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6/arch/arm/mach-ixp4xx/common.c
@@ -239,7 +239,7 @@ void __init ixp4xx_init_irq(void)
 	 * ixp4xx does not implement the XScale PWRMODE register
 	 * so it must not call cpu_do_idle().
 	 */
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 
 	/* Route all sources to IRQ instead of FIQ */
 	*IXP4XX_ICLR = 0x0;
Index: linux-2.6/arch/arm/mach-omap1/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/pm.c
+++ linux-2.6/arch/arm/mach-omap1/pm.c
@@ -584,8 +584,7 @@ static void omap_pm_init_proc(void)
 static int omap_pm_prepare(void)
 {
 	/* We cannot sleep in idle until we have resumed */
-	disable_hlt();
-
+	cpu_idle_poll_ctrl(true);
 	return 0;
 }
 
@@ -621,7 +620,7 @@ static int omap_pm_enter(suspend_state_t
 
 static void omap_pm_finish(void)
 {
-	enable_hlt();
+	cpu_idle_poll_ctrl(false);
 }
 
 
Index: linux-2.6/arch/arm/mach-omap2/omap_hwmod.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/omap_hwmod.c
+++ linux-2.6/arch/arm/mach-omap2/omap_hwmod.c
@@ -2154,7 +2154,7 @@ static int _enable(struct omap_hwmod *oh
 	if (soc_ops.enable_module)
 		soc_ops.enable_module(oh);
 	if (oh->flags & HWMOD_BLOCK_WFI)
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 
 	if (soc_ops.update_context_lost)
 		soc_ops.update_context_lost(oh);
@@ -2218,7 +2218,7 @@ static int _idle(struct omap_hwmod *oh)
 	_del_initiator_dep(oh, mpu_oh);
 
 	if (oh->flags & HWMOD_BLOCK_WFI)
-		enable_hlt();
+		cpu_idle_poll_ctrl(false);
 	if (soc_ops.disable_module)
 		soc_ops.disable_module(oh);
 
@@ -2328,7 +2328,7 @@ static int _shutdown(struct omap_hwmod *
 		_del_initiator_dep(oh, mpu_oh);
 		/* XXX what about the other system initiators here? dma, dsp */
 		if (oh->flags & HWMOD_BLOCK_WFI)
-			enable_hlt();
+			cpu_idle_poll_ctrl(false);
 		if (soc_ops.disable_module)
 			soc_ops.disable_module(oh);
 		_disable_clocks(oh);
Index: linux-2.6/arch/arm/mach-omap2/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/pm.c
+++ linux-2.6/arch/arm/mach-omap2/pm.c
@@ -218,7 +218,7 @@ static int omap_pm_enter(suspend_state_t
 
 static int omap_pm_begin(suspend_state_t state)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	if (cpu_is_omap34xx())
 		omap_prcm_irq_prepare();
 	return 0;
@@ -226,8 +226,7 @@ static int omap_pm_begin(suspend_state_t
 
 static void omap_pm_end(void)
 {
-	enable_hlt();
-	return;
+	cpu_idle_poll_ctrl(false);
 }
 
 static void omap_pm_finish(void)
Index: linux-2.6/arch/arm/mach-orion5x/board-dt.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-orion5x/board-dt.c
+++ linux-2.6/arch/arm/mach-orion5x/board-dt.c
@@ -52,7 +52,7 @@ static void __init orion5x_dt_init(void)
 	 */
 	if (dev == MV88F5281_DEV_ID && rev == MV88F5281_REV_D0) {
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 	}
 
 	if (of_machine_is_compatible("lacie,ethernet-disk-mini-v2"))
Index: linux-2.6/arch/arm/mach-orion5x/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-orion5x/common.c
+++ linux-2.6/arch/arm/mach-orion5x/common.c
@@ -293,7 +293,7 @@ void __init orion5x_init(void)
 	 */
 	if (dev == MV88F5281_DEV_ID && rev == MV88F5281_REV_D0) {
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 	}
 
 	/*
Index: linux-2.6/arch/arm/mach-shark/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shark/core.c
+++ linux-2.6/arch/arm/mach-shark/core.c
@@ -130,7 +130,7 @@ static void __init shark_timer_init(void
 
 static void shark_init_early(void)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 }
 
 MACHINE_START(SHARK, "Shark")
Index: linux-2.6/arch/arm/mach-shmobile/suspend.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/suspend.c
+++ linux-2.6/arch/arm/mach-shmobile/suspend.c
@@ -23,13 +23,13 @@ static int shmobile_suspend_default_ente
 
 static int shmobile_suspend_begin(suspend_state_t state)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	return 0;
 }
 
 static void shmobile_suspend_end(void)
 {
-	enable_hlt();
+	cpu_idle_poll_ctrl(false);
 }
 
 struct platform_suspend_ops shmobile_suspend_ops = {
Index: linux-2.6/arch/arm/mach-w90x900/dev.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-w90x900/dev.c
+++ linux-2.6/arch/arm/mach-w90x900/dev.c
@@ -531,7 +531,7 @@ static struct platform_device *nuc900_pu
 
 void __init nuc900_board_init(struct platform_device **device, int size)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	platform_add_devices(device, size);
 	platform_add_devices(nuc900_public_dev, ARRAY_SIZE(nuc900_public_dev));
 	spi_register_board_info(nuc900_spi_board_info,


