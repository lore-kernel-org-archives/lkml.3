Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaCDQnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:43:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaCDQnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:43:37 -0500
Date: Tue, 4 Mar 2014 08:42:59 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-1aec169673d7db113c37367bbc371c2ba8109f06@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, devel@linuxdriverproject.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        kys@microsoft.com, gregkh@linuxfoundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, devel@linuxdriverproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, kys@microsoft.com,
        peterz@infradead.org, gregkh@linuxfoundation.org, tglx@linutronix.de
In-Reply-To: <20140223212739.028307673@linutronix.de>
References: <20140223212739.028307673@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Hyperv: Cleanup the irq mess
Git-Commit-ID: 1aec169673d7db113c37367bbc371c2ba8109f06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1aec169673d7db113c37367bbc371c2ba8109f06
Gitweb:     http://git.kernel.org/tip/1aec169673d7db113c37367bbc371c2ba8109f06
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:22 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:54 +0100

x86: Hyperv: Cleanup the irq mess

The vmbus/hyperv interrupt handling is another complete trainwreck and
probably the worst of all currently in tree.

If CONFIG_HYPERV=y then the interrupt delivery to the vmbus happens
via the direct HYPERVISOR_CALLBACK_VECTOR. So far so good, but:

  The driver requests first a normal device interrupt. The only reason
  to do so is to increment the interrupt stats of that device
  interrupt. For no reason it also installs a private flow handler.

  We have proper accounting mechanisms for direct vectors, but of
  course it's too much effort to add that 5 lines of code.

  Aside of that the alloc_intr_gate() is not protected against
  reallocation which makes module reload impossible.

Solution to the problem is simple to rip out the whole mess and
implement it correctly.

First of all move all that code to arch/x86/kernel/cpu/mshyperv.c and
merily install the HYPERVISOR_CALLBACK_VECTOR with proper reallocation
protection and use the proper direct vector accounting mechanism.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linuxdrivers <devel@linuxdriverproject.org>
Cc: x86 <x86@kernel.org>
Link: http://lkml.kernel.org/r/20140223212739.028307673@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/mshyperv.h |  4 ++-
 arch/x86/kernel/cpu/mshyperv.c  | 78 +++++++++++++++++++++--------------------
 drivers/hv/vmbus_drv.c          | 39 +++------------------
 3 files changed, 47 insertions(+), 74 deletions(-)

diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index cd9c419..e98f66f 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_MSHYPER_H
 
 #include <linux/types.h>
+#include <linux/interrupt.h>
 #include <asm/hyperv.h>
 
 struct ms_hyperv_info {
@@ -16,6 +17,7 @@ void hyperv_callback_vector(void);
 #define trace_hyperv_callback_vector hyperv_callback_vector
 #endif
 void hyperv_vector_handler(struct pt_regs *regs);
-void hv_register_vmbus_handler(int irq, irq_handler_t handler);
+int hv_setup_vmbus_irq(int irq, irq_handler_t handler, void *dev_id);
+void hv_remove_vmbus_irq(int irq, void *dev_id);
 
 #endif
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 9f7ca26..1bd316c 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/efi.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
@@ -30,6 +31,45 @@
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
 
+#ifdef CONFIG_HYPERV
+static irq_handler_t *vmbus_handler;
+
+void hyperv_vector_handler(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+	exit_idle();
+
+	inc_irq_stat(irq_hv_callback_count);
+	if (vmbus_handler)
+		vmbus_handler();
+
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+int hv_setup_vmbus_irq(int irq, irq_handler_t *handler, void *dev_id)
+{
+	vmbus_handler = handler;
+	/*
+	 * Setup the IDT for hypervisor callback. Prevent reallocation
+	 * at module reload.
+	 */
+	if (!test_bit(HYPERVISOR_CALLBACK_VECTOR, used_vectors))
+		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
+				hyperv_callback_vector);
+}
+
+void hv_remove_vmbus_irq(unsigned int irq, void *dev_id)
+{
+	/* We have no way to deallocate the interrupt gate */
+	vmbus_handler = NULL;
+}
+EXPORT_SYMBOL_GPL(hv_setup_vmbus_irq);
+EXPORT_SYMBOL_GPL(hv_remove_vmbus_irq);
+#endif
+
 static uint32_t  __init ms_hyperv_platform(void)
 {
 	u32 eax;
@@ -113,41 +153,3 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.init_platform		= ms_hyperv_init_platform,
 };
 EXPORT_SYMBOL(x86_hyper_ms_hyperv);
-
-#if IS_ENABLED(CONFIG_HYPERV)
-static int vmbus_irq = -1;
-static irq_handler_t vmbus_isr;
-
-void hv_register_vmbus_handler(int irq, irq_handler_t handler)
-{
-	/*
-	 * Setup the IDT for hypervisor callback.
-	 */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
-
-	vmbus_irq = irq;
-	vmbus_isr = handler;
-}
-
-void hyperv_vector_handler(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct irq_desc *desc;
-
-	irq_enter();
-	exit_idle();
-
-	desc = irq_to_desc(vmbus_irq);
-
-	if (desc)
-		generic_handle_irq_desc(vmbus_irq, desc);
-
-	irq_exit();
-	set_irq_regs(old_regs);
-}
-#else
-void hv_register_vmbus_handler(int irq, irq_handler_t handler)
-{
-}
-#endif
-EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 077bb1b..5a6909f 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
 #include <linux/slab.h>
@@ -558,9 +557,6 @@ static struct bus_type  hv_bus = {
 	.dev_groups =		vmbus_groups,
 };
 
-static const char *driver_name = "hyperv";
-
-
 struct onmessage_work_context {
 	struct work_struct work;
 	struct hv_message msg;
@@ -677,19 +673,6 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 }
 
 /*
- * vmbus interrupt flow handler:
- * vmbus interrupts can concurrently occur on multiple CPUs and
- * can be handled concurrently.
- */
-
-static void vmbus_flow_handler(unsigned int irq, struct irq_desc *desc)
-{
-	kstat_incr_irqs_this_cpu(irq, desc);
-
-	desc->action->handler(irq, desc->action->dev_id);
-}
-
-/*
  * vmbus_bus_init -Main vmbus driver initialization routine.
  *
  * Here, we
@@ -715,26 +698,13 @@ static int vmbus_bus_init(int irq)
 	if (ret)
 		goto err_cleanup;
 
-	ret = request_irq(irq, vmbus_isr, 0, driver_name, hv_acpi_dev);
+	ret = hv_setup_vmbus_irq(irq, vmbus_isr, hv_acpi_dev);
 
 	if (ret != 0) {
-		pr_err("Unable to request IRQ %d\n",
-			   irq);
+		pr_err("Unable to request IRQ %d\n", irq);
 		goto err_unregister;
 	}
 
-	/*
-	 * Vmbus interrupts can be handled concurrently on
-	 * different CPUs. Establish an appropriate interrupt flow
-	 * handler that can support this model.
-	 */
-	irq_set_handler(irq, vmbus_flow_handler);
-
-	/*
-	 * Register our interrupt handler.
-	 */
-	hv_register_vmbus_handler(irq, vmbus_isr);
-
 	ret = hv_synic_alloc();
 	if (ret)
 		goto err_alloc;
@@ -753,7 +723,7 @@ static int vmbus_bus_init(int irq)
 
 err_alloc:
 	hv_synic_free();
-	free_irq(irq, hv_acpi_dev);
+	hv_remove_vmbus_irq(irq, hv_acpi_dev);
 
 err_unregister:
 	bus_unregister(&hv_bus);
@@ -978,8 +948,7 @@ cleanup:
 
 static void __exit vmbus_exit(void)
 {
-
-	free_irq(irq, hv_acpi_dev);
+	hv_remove_vmbus_irq(irq, hv_acpi_dev);
 	vmbus_free_channels();
 	bus_unregister(&hv_bus);
 	hv_cleanup();
