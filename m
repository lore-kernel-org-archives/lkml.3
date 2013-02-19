Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3BSPbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:31:49 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:32780 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3BSPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:31:48 -0500
Date: Tue, 19 Feb 2013 16:31:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/hyperv changes for v3.9
Message-ID: <20130219153143.GA15327@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-hyperv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-hyperv-for-linus

   HEAD: cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78 x86, hyperv: HYPERV depends on X86_LOCAL_APIC

The biggest change is support for Windows 8's improved 
hypervisor interrupt model on the Linux Hyper-V guest subsystem 
code side.

Smallish fixes otherwise.

out-of-topic modifications in x86-hyperv-for-linus:
---------------------------------------------------
drivers/hv/Kconfig                 # cb20e5f: x86, hyperv: HYPERV depends on X8

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, hyperv: HYPERV depends on X86_LOCAL_APIC

K. Y. Srinivasan (2):
      X86: Add a check to catch Xen emulation of Hyper-V
      X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts

Olaf Hering (1):
      x86: Hyper-V: register clocksource only if its advertised


 arch/x86/include/asm/irq_vectors.h |  4 +--
 arch/x86/include/asm/mshyperv.h    |  4 +++
 arch/x86/kernel/cpu/mshyperv.c     | 54 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/entry_32.S         |  9 ++++++-
 arch/x86/kernel/entry_64.S         |  7 ++++-
 drivers/hv/Kconfig                 |  2 +-
 drivers/xen/events.c               |  7 ++---
 7 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 1508e51..aac5fa6 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -109,8 +109,8 @@
 
 #define UV_BAU_MESSAGE			0xf5
 
-/* Xen vector callback to receive events in a HVM domain */
-#define XEN_HVM_EVTCHN_CALLBACK		0xf3
+/* Vector on which hypervisor callbacks will be delivered */
+#define HYPERVISOR_CALLBACK_VECTOR	0xf3
 
 /*
  * Local APIC timer IRQ vector is on a different priority level,
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 79ce568..c2934be 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -11,4 +11,8 @@ struct ms_hyperv_info {
 
 extern struct ms_hyperv_info ms_hyperv;
 
+void hyperv_callback_vector(void);
+void hyperv_vector_handler(struct pt_regs *regs);
+void hv_register_vmbus_handler(int irq, irq_handler_t handler);
+
 #endif
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 0a630dd..a7d26d8 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -14,10 +14,15 @@
 #include <linux/time.h>
 #include <linux/clocksource.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
+#include <linux/interrupt.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
 #include <asm/mshyperv.h>
+#include <asm/desc.h>
+#include <asm/idle.h>
+#include <asm/irq_regs.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -30,6 +35,13 @@ static bool __init ms_hyperv_platform(void)
 	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return false;
 
+	/*
+	 * Xen emulates Hyper-V to support enlightened Windows.
+	 * Check to see first if we are on a Xen Hypervisor.
+	 */
+	if (xen_cpuid_base())
+		return false;
+
 	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
 	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
 
@@ -68,7 +80,14 @@ static void __init ms_hyperv_init_platform(void)
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
 
-	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
+		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+#if IS_ENABLED(CONFIG_HYPERV)
+	/*
+	 * Setup the IDT for hypervisor callback.
+	 */
+	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
+#endif
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
@@ -77,3 +96,36 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.init_platform		= ms_hyperv_init_platform,
 };
 EXPORT_SYMBOL(x86_hyper_ms_hyperv);
+
+#if IS_ENABLED(CONFIG_HYPERV)
+static int vmbus_irq = -1;
+static irq_handler_t vmbus_isr;
+
+void hv_register_vmbus_handler(int irq, irq_handler_t handler)
+{
+	vmbus_irq = irq;
+	vmbus_isr = handler;
+}
+
+void hyperv_vector_handler(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct irq_desc *desc;
+
+	irq_enter();
+	exit_idle();
+
+	desc = irq_to_desc(vmbus_irq);
+
+	if (desc)
+		generic_handle_irq_desc(vmbus_irq, desc);
+
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+#else
+void hv_register_vmbus_handler(int irq, irq_handler_t handler)
+{
+}
+#endif
+EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 6ed91d9..8831176 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1091,11 +1091,18 @@ ENTRY(xen_failsafe_callback)
 	_ASM_EXTABLE(4b,9b)
 ENDPROC(xen_failsafe_callback)
 
-BUILD_INTERRUPT3(xen_hvm_callback_vector, XEN_HVM_EVTCHN_CALLBACK,
+BUILD_INTERRUPT3(xen_hvm_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
 		xen_evtchn_do_upcall)
 
 #endif	/* CONFIG_XEN */
 
+#if IS_ENABLED(CONFIG_HYPERV)
+
+BUILD_INTERRUPT3(hyperv_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
+	hyperv_vector_handler)
+
+#endif /* CONFIG_HYPERV */
+
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index cb3c591..048f224 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1454,11 +1454,16 @@ ENTRY(xen_failsafe_callback)
 	CFI_ENDPROC
 END(xen_failsafe_callback)
 
-apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
+apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
 	xen_hvm_callback_vector xen_evtchn_do_upcall
 
 #endif /* CONFIG_XEN */
 
+#if IS_ENABLED(CONFIG_HYPERV)
+apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
+	hyperv_callback_vector hyperv_vector_handler
+#endif /* CONFIG_HYPERV */
+
 /*
  * Some functions should be protected against kprobes
  */
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index b38ef6d..64630f1 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -2,7 +2,7 @@ menu "Microsoft Hyper-V guest support"
 
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && PCI
+	depends on X86 && ACPI && PCI && X86_LOCAL_APIC
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 74d77df..22f77c5 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1787,7 +1787,7 @@ void xen_callback_vector(void)
 	int rc;
 	uint64_t callback_via;
 	if (xen_have_vector_callback) {
-		callback_via = HVM_CALLBACK_VECTOR(XEN_HVM_EVTCHN_CALLBACK);
+		callback_via = HVM_CALLBACK_VECTOR(HYPERVISOR_CALLBACK_VECTOR);
 		rc = xen_set_callback_via(callback_via);
 		if (rc) {
 			printk(KERN_ERR "Request for Xen HVM callback vector"
@@ -1798,8 +1798,9 @@ void xen_callback_vector(void)
 		printk(KERN_INFO "Xen HVM callback vector for event delivery is "
 				"enabled\n");
 		/* in the restore case the vector has already been allocated */
-		if (!test_bit(XEN_HVM_EVTCHN_CALLBACK, used_vectors))
-			alloc_intr_gate(XEN_HVM_EVTCHN_CALLBACK, xen_hvm_callback_vector);
+		if (!test_bit(HYPERVISOR_CALLBACK_VECTOR, used_vectors))
+			alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
+					xen_hvm_callback_vector);
 	}
 }
 #else
