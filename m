Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936043Ab3DHUUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:20:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40591 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935951Ab3DHUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:20:16 -0400
Date: Mon, 8 Apr 2013 13:17:41 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f7b861b7a6d9d1838cbbb5f4053e61578b86d134@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130321215233.826238797@linutronix.de>
References: <20130321215233.826238797@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] arm: Use generic idle loop
Git-Commit-ID: f7b861b7a6d9d1838cbbb5f4053e61578b86d134
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 13:17:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7b861b7a6d9d1838cbbb5f4053e61578b86d134
Gitweb:     http://git.kernel.org/tip/f7b861b7a6d9d1838cbbb5f4053e61578b86d134
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Mar 2013 22:49:38 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 8 Apr 2013 17:39:24 +0200

arm: Use generic idle loop

Use the generic idle loop and replace enable/disable_hlt with the
respective core functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Kevin Hilman <khilman@linaro.org> # OMAP
Link: http://lkml.kernel.org/r/20130321215233.826238797@linutronix.de
---
 arch/arm/Kconfig                   |  2 +
 arch/arm/include/asm/system_misc.h |  3 --
 arch/arm/kernel/process.c          | 96 +++++++++++---------------------------
 arch/arm/kernel/smp.c              |  2 +-
 arch/arm/mach-gemini/idle.c        |  4 +-
 arch/arm/mach-gemini/irq.c         |  4 +-
 arch/arm/mach-ixp4xx/common.c      |  3 +-
 arch/arm/mach-omap1/pm.c           |  6 +--
 arch/arm/mach-omap2/omap_hwmod.c   |  7 +--
 arch/arm/mach-omap2/pm.c           |  5 +-
 arch/arm/mach-orion5x/board-dt.c   |  3 +-
 arch/arm/mach-orion5x/common.c     |  2 +-
 arch/arm/mach-shark/core.c         |  3 +-
 arch/arm/mach-shmobile/suspend.c   |  6 ++-
 arch/arm/mach-w90x900/dev.c        |  3 +-
 15 files changed, 57 insertions(+), 92 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1cacda4..128551f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -15,6 +15,8 @@ config ARM
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IDLE_LOOP
+	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HARDIRQS_SW_RESEND
diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
index 5a85f14..21a23e3 100644
--- a/arch/arm/include/asm/system_misc.h
+++ b/arch/arm/include/asm/system_misc.h
@@ -21,9 +21,6 @@ extern void (*arm_pm_idle)(void);
 
 extern unsigned int user_debug;
 
-extern void disable_hlt(void);
-extern void enable_hlt(void);
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_ARM_SYSTEM_MISC_H */
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92884c8..c9a5e2c 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
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
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 1f2cccc..4619177 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -336,7 +336,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	/*
 	 * OK, it's off to the idle thread for us
 	 */
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/arm/mach-gemini/idle.c b/arch/arm/mach-gemini/idle.c
index 92bbd6b..87dff4f 100644
--- a/arch/arm/mach-gemini/idle.c
+++ b/arch/arm/mach-gemini/idle.c
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
diff --git a/arch/arm/mach-gemini/irq.c b/arch/arm/mach-gemini/irq.c
index 020852d..6d8f6d1 100644
--- a/arch/arm/mach-gemini/irq.c
+++ b/arch/arm/mach-gemini/irq.c
@@ -15,6 +15,8 @@
 #include <linux/stddef.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/cpu.h>
+
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
 #include <asm/system_misc.h>
@@ -77,7 +79,7 @@ void __init gemini_init_irq(void)
 	 * Disable the idle handler by default since it is buggy
 	 * For more info see arch/arm/mach-gemini/idle.c
 	 */
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 
 	request_resource(&iomem_resource, &irq_resource);
 
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 1dbeb7c..6600cff 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <linux/gpio.h>
+#include <linux/cpu.h>
 
 #include <mach/udc.h>
 #include <mach/hardware.h>
@@ -239,7 +240,7 @@ void __init ixp4xx_init_irq(void)
 	 * ixp4xx does not implement the XScale PWRMODE register
 	 * so it must not call cpu_do_idle().
 	 */
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 
 	/* Route all sources to IRQ instead of FIQ */
 	*IXP4XX_ICLR = 0x0;
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 7a7690a..db37f49 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -43,6 +43,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/atomic.h>
+#include <linux/cpu.h>
 
 #include <asm/fncpy.h>
 #include <asm/system_misc.h>
@@ -584,8 +585,7 @@ static void omap_pm_init_proc(void)
 static int omap_pm_prepare(void)
 {
 	/* We cannot sleep in idle until we have resumed */
-	disable_hlt();
-
+	cpu_idle_poll_ctrl(true);
 	return 0;
 }
 
@@ -621,7 +621,7 @@ static int omap_pm_enter(suspend_state_t state)
 
 static void omap_pm_finish(void)
 {
-	enable_hlt();
+	cpu_idle_poll_ctrl(false);
 }
 
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index a202a47..e512253 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -138,6 +138,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
+#include <linux/cpu.h>
 
 #include <asm/system_misc.h>
 
@@ -2157,7 +2158,7 @@ static int _enable(struct omap_hwmod *oh)
 	if (soc_ops.enable_module)
 		soc_ops.enable_module(oh);
 	if (oh->flags & HWMOD_BLOCK_WFI)
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 
 	if (soc_ops.update_context_lost)
 		soc_ops.update_context_lost(oh);
@@ -2221,7 +2222,7 @@ static int _idle(struct omap_hwmod *oh)
 	_del_initiator_dep(oh, mpu_oh);
 
 	if (oh->flags & HWMOD_BLOCK_WFI)
-		enable_hlt();
+		cpu_idle_poll_ctrl(false);
 	if (soc_ops.disable_module)
 		soc_ops.disable_module(oh);
 
@@ -2331,7 +2332,7 @@ static int _shutdown(struct omap_hwmod *oh)
 		_del_initiator_dep(oh, mpu_oh);
 		/* XXX what about the other system initiators here? dma, dsp */
 		if (oh->flags & HWMOD_BLOCK_WFI)
-			enable_hlt();
+			cpu_idle_poll_ctrl(false);
 		if (soc_ops.disable_module)
 			soc_ops.disable_module(oh);
 		_disable_clocks(oh);
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 673a4c1..dec5533 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -218,7 +218,7 @@ static int omap_pm_enter(suspend_state_t suspend_state)
 
 static int omap_pm_begin(suspend_state_t state)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	if (cpu_is_omap34xx())
 		omap_prcm_irq_prepare();
 	return 0;
@@ -226,8 +226,7 @@ static int omap_pm_begin(suspend_state_t state)
 
 static void omap_pm_end(void)
 {
-	enable_hlt();
-	return;
+	cpu_idle_poll_ctrl(false);
 }
 
 static void omap_pm_finish(void)
diff --git a/arch/arm/mach-orion5x/board-dt.c b/arch/arm/mach-orion5x/board-dt.c
index 35a8014..94fbb81 100644
--- a/arch/arm/mach-orion5x/board-dt.c
+++ b/arch/arm/mach-orion5x/board-dt.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/cpu.h>
 #include <asm/system_misc.h>
 #include <asm/mach/arch.h>
 #include <mach/orion5x.h>
@@ -52,7 +53,7 @@ static void __init orion5x_dt_init(void)
 	 */
 	if (dev == MV88F5281_DEV_ID && rev == MV88F5281_REV_D0) {
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 	}
 
 	if (of_machine_is_compatible("lacie,ethernet-disk-mini-v2"))
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index d068f14..ad71c8a 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -293,7 +293,7 @@ void __init orion5x_init(void)
 	 */
 	if (dev == MV88F5281_DEV_ID && rev == MV88F5281_REV_D0) {
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
-		disable_hlt();
+		cpu_idle_poll_ctrl(true);
 	}
 
 	/*
diff --git a/arch/arm/mach-shark/core.c b/arch/arm/mach-shark/core.c
index b63dec8..1535557 100644
--- a/arch/arm/mach-shark/core.c
+++ b/arch/arm/mach-shark/core.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/serial_8250.h>
 #include <linux/io.h>
+#include <linux/cpu.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -130,7 +131,7 @@ static void __init shark_timer_init(void)
 
 static void shark_init_early(void)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 }
 
 MACHINE_START(SHARK, "Shark")
diff --git a/arch/arm/mach-shmobile/suspend.c b/arch/arm/mach-shmobile/suspend.c
index 47d83f7..5d92b5d 100644
--- a/arch/arm/mach-shmobile/suspend.c
+++ b/arch/arm/mach-shmobile/suspend.c
@@ -12,6 +12,8 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/cpu.h>
+
 #include <asm/io.h>
 #include <asm/system_misc.h>
 
@@ -23,13 +25,13 @@ static int shmobile_suspend_default_enter(suspend_state_t suspend_state)
 
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
diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 7abdb96..e65a80a 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/mtd.h>
@@ -531,7 +532,7 @@ static struct platform_device *nuc900_public_dev[] __initdata = {
 
 void __init nuc900_board_init(struct platform_device **device, int size)
 {
-	disable_hlt();
+	cpu_idle_poll_ctrl(true);
 	platform_add_devices(device, size);
 	platform_add_devices(nuc900_public_dev, ARRAY_SIZE(nuc900_public_dev));
 	spi_register_board_info(nuc900_spi_board_info,
