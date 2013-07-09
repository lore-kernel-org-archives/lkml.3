Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3GIE5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 00:57:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33239 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3GIE5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 00:57:32 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: viro@zeniv.linux.org.uk, swarren@nvidia.com, geert@linux-m68k.org,
        johnstul@us.ibm.com, dhowells@redhat.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        adam.buchbinder@gmail.com, jkosina@suse.cz, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] cris: remove deprecated IRQF_DISABLED
Date: Tue,  9 Jul 2013 06:57:27 +0200
Message-Id: <1373345847-5214-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from CRIS
architecture code. It's a NOOP since 2.6.35 and it will be removed
one day.

Comments mentioning IRQF_DISABLED are also updated, knowing
that all interrupts are now "fast interrupts", their handlers
running with interrupts disabled.

Don't hesitate to let me know if you have other ways of
rephrasing the comments!

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/cris/arch-v10/drivers/gpio.c         |  4 ++--
 arch/cris/arch-v10/drivers/sync_serial.c  |  4 ++--
 arch/cris/arch-v10/kernel/time.c          |  6 ++----
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |  2 +-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |  4 ++--
 arch/cris/arch-v32/kernel/fasttimer.c     |  2 +-
 arch/cris/arch-v32/kernel/irq.c           | 10 +++++-----
 arch/cris/arch-v32/kernel/smp.c           |  2 +-
 arch/cris/arch-v32/kernel/time.c          |  6 ++----
 arch/cris/arch-v32/mach-a3/arbiter.c      |  4 ++--
 arch/cris/arch-v32/mach-fs/arbiter.c      |  2 +-
 arch/cris/include/arch-v10/arch/irq.h     |  6 +++---
 arch/cris/include/arch-v32/arch/irq.h     |  6 +++---
 arch/cris/kernel/irq.c                    |  3 ---
 14 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 609d551..f4374ba 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -838,13 +838,13 @@ static int __init gpio_init(void)
 	 * in some tests.
 	 */
 	res = request_irq(TIMER0_IRQ_NBR, gpio_poll_timer_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio poll", gpio_name);
+		IRQF_SHARED, "gpio poll", gpio_name);
 	if (res) {
 		printk(KERN_CRIT "err: timer0 irq for gpio\n");
 		return res;
 	}
 	res = request_irq(PA_IRQ_NBR, gpio_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio PA", gpio_name);
+		IRQF_SHARED, "gpio PA", gpio_name);
 	if (res)
 		printk(KERN_CRIT "err: PA irq for gpio\n");
 
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index a1c498d..04d39e0 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -580,7 +580,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 			if (port == &ports[0]) {
 				if (request_irq(8,
 						manual_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED,
 						"synchronous serial manual irq",
 						&ports[0])) {
 					printk(KERN_CRIT "Can't alloc "
@@ -590,7 +590,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 			} else if (port == &ports[1]) {
 				if (request_irq(8,
 						manual_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED,
 						"synchronous serial manual irq",
 						&ports[1])) {
 					printk(KERN_CRIT "Can't alloc "
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index fce7c54..e6a7227 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -178,13 +178,11 @@ timer_interrupt(int irq, void *dev_id)
         return IRQ_HANDLED;
 }
 
-/* timer is IRQF_SHARED so drivers can add stuff to the timer irq chain
- * it needs to be IRQF_DISABLED to make the jiffies update work properly
- */
+/* timer is IRQF_SHARED so drivers can add stuff to the timer irq chain */
 
 static struct irqaction irq2  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_SHARED | IRQF_DISABLED,
+	.flags = IRQF_SHARED,
 	.name = "timer",
 };
 
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index 0b86dee..74f9fe8 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -978,7 +978,7 @@ static int __init gpio_init(void)
 	CRIS_LED_DISK_WRITE(0);
 
 	int res2 = request_irq(GIO_INTR_VECT, gpio_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio", &alarmlist);
+		IRQF_SHARED, "gpio", &alarmlist);
 	if (res2) {
 		printk(KERN_ERR "err: irq for gpio\n");
 		return res2;
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index a2ac091..9e54273 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -964,11 +964,11 @@ gpio_init(void)
 	 * in some tests.
 	 */
 	if (request_irq(TIMER0_INTR_VECT, gpio_poll_timer_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, "gpio poll", &alarmlist))
+			IRQF_SHARED, "gpio poll", &alarmlist))
 		printk(KERN_ERR "timer0 irq for gpio\n");
 
 	if (request_irq(GIO_INTR_VECT, gpio_pa_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, "gpio PA", &alarmlist))
+			IRQF_SHARED, "gpio PA", &alarmlist))
 		printk(KERN_ERR "PA irq for gpio\n");
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index f664453..b130c2c 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -786,7 +786,7 @@ int fast_timer_init(void)
     proc_create("fasttimer", 0, NULL, &proc_fasttimer_fops);
 #endif /* PROC_FS */
 		if (request_irq(TIMER0_INTR_VECT, timer_trig_interrupt,
-				IRQF_SHARED | IRQF_DISABLED,
+				IRQF_SHARED,
 				"fast timer int", &fast_timer_list))
 			printk(KERN_ERR "err: fasttimer irq\n");
     fast_timer_is_init = 1;
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index 5ebe6e8..25437ae 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -331,11 +331,11 @@ extern void do_IRQ(int irq, struct pt_regs * regs);
 void
 crisv32_do_IRQ(int irq, int block, struct pt_regs* regs)
 {
-	/* Interrupts that may not be moved to another CPU and
-         * are IRQF_DISABLED may skip blocking. This is currently
-         * only valid for the timer IRQ and the IPI and is used
-         * for the timer interrupt to avoid watchdog starvation.
-         */
+	/* Interrupts that may not be moved to another CPU may
+	 * skip blocking. This is currently only valid for the
+	 * timer IRQ and the IPI and is used for the timer
+	 * interrupt to avoid watchdog starvation.
+	 */
 	if (!block) {
 		do_IRQ(irq, regs);
 		return;
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index cdd1202..cc7ab44 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -64,7 +64,7 @@ static irqreturn_t crisv32_ipi_interrupt(int irq, void *dev_id);
 static int send_ipi(int vector, int wait, cpumask_t cpu_mask);
 static struct irqaction irq_ipi  = {
 	.handler = crisv32_ipi_interrupt,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.name = "ipi",
 };
 
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index 8c4b45e..ee66866 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -216,12 +216,10 @@ static inline irqreturn_t timer_interrupt(int irq, void *dev_id)
         return IRQ_HANDLED;
 }
 
-/* Timer is IRQF_SHARED so drivers can add stuff to the timer irq chain.
- * It needs to be IRQF_DISABLED to make the jiffies update work properly.
- */
+/* Timer is IRQF_SHARED so drivers can add stuff to the timer irq chain. */
 static struct irqaction irq_timer = {
 	.handler = timer_interrupt,
-	.flags = IRQF_SHARED | IRQF_DISABLED,
+	.flags = IRQF_SHARED,
 	.name = "timer"
 };
 
diff --git a/arch/cris/arch-v32/mach-a3/arbiter.c b/arch/cris/arch-v32/mach-a3/arbiter.c
index 15f5c9d..ab5c421 100644
--- a/arch/cris/arch-v32/mach-a3/arbiter.c
+++ b/arch/cris/arch-v32/mach-a3/arbiter.c
@@ -256,11 +256,11 @@ static void crisv32_arbiter_init(void)
 	crisv32_arbiter_config(1, EXT_REGION, 0);
 
 	if (request_irq(MEMARB_FOO_INTR_VECT, crisv32_foo_arbiter_irq,
-			IRQF_DISABLED, "arbiter", NULL))
+			0, "arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
 	if (request_irq(MEMARB_BAR_INTR_VECT, crisv32_bar_arbiter_irq,
-			IRQF_DISABLED, "arbiter", NULL))
+			0, "arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
 #ifndef CONFIG_ETRAX_KGDB
diff --git a/arch/cris/arch-v32/mach-fs/arbiter.c b/arch/cris/arch-v32/mach-fs/arbiter.c
index 3f8ebb5..c97f4d8 100644
--- a/arch/cris/arch-v32/mach-fs/arbiter.c
+++ b/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -184,7 +184,7 @@ static void crisv32_arbiter_init(void)
 	crisv32_arbiter_config(EXT_REGION, 0);
 	crisv32_arbiter_config(INT_REGION, 0);
 
-	if (request_irq(MEMARB_INTR_VECT, crisv32_arbiter_irq, IRQF_DISABLED,
+	if (request_irq(MEMARB_INTR_VECT, crisv32_arbiter_irq, 0,
 			"arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
diff --git a/arch/cris/include/arch-v10/arch/irq.h b/arch/cris/include/arch-v10/arch/irq.h
index ca2675a..6aecb83 100644
--- a/arch/cris/include/arch-v10/arch/irq.h
+++ b/arch/cris/include/arch-v10/arch/irq.h
@@ -141,9 +141,9 @@ __asm__ ( \
  * handler is run and it prioritizes the timer interrupt. However if we had BLOCK'ed
  * it here, we would not get the multiple_irq at all.
  *
- * The non-blocking here is based on the knowledge that the timer interrupt is 
- * registered as a fast interrupt (IRQF_DISABLED) so that we _know_ there will not
- * be an sti() before the timer irq handler is run to acknowledge the interrupt.
+ * The non-blocking here is based on the knowledge that the timer interrupt runs
+ * with interrupts disabled, and therefore there will not be an sti() before the
+ * timer irq handler is run to acknowledge the interrupt.
  */
 
 #define BUILD_TIMER_IRQ(nr,mask) \
diff --git a/arch/cris/include/arch-v32/arch/irq.h b/arch/cris/include/arch-v32/arch/irq.h
index fe3cdd2..0c1b4d3 100644
--- a/arch/cris/include/arch-v32/arch/irq.h
+++ b/arch/cris/include/arch-v32/arch/irq.h
@@ -102,9 +102,9 @@ __asm__ (				\
  * multiple_irq handler is run and it prioritizes the timer interrupt. However
  * if we had BLOCK'edit here, we would not get the multiple_irq at all.
  *
- * The non-blocking here is based on the knowledge that the timer interrupt is
- * registered as a fast interrupt (IRQF_DISABLED) so that we _know_ there will not
- * be an sti() before the timer irq handler is run to acknowledge the interrupt.
+ * The non-blocking here is based on the knowledge that the timer interrupt runs
+ * with interrupts disabled, and therefore there will not be an sti() before the
+ * timer irq handler is run to acknowledge the interrupt.
  */
 #define BUILD_TIMER_IRQ(nr, mask) 	\
 void IRQ_NAME(nr);			\
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index d36836d..dd0be5d 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -40,9 +40,6 @@
 
 /* called by the assembler IRQ entry functions defined in irq.h
  * to dispatch the interrupts to registered handlers
- * interrupts are disabled upon entry - depending on if the
- * interrupt was registered with IRQF_DISABLED or not, interrupts
- * are re-enabled or not.
  */
 
 asmlinkage void do_IRQ(int irq, struct pt_regs * regs)
-- 
1.8.1.2

