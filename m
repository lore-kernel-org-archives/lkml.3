Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3AXAvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:51:10 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:59730
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3AXAvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:51:00 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
Date: Wed, 23 Jan 2013 17:17:39 -0800
Message-Id: <1358990259-22551-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with win8, vmbus interrupts can be delivered on any VCPU in the guest
and furthermore can be concurrently active on multiple VCPUs. Support this
interrupt delivery model by setting up a separate IDT entry for Hyper-V vmbus.
interrupts. I would like to thank Jan Beulich <JBeulich@suse.com> and
Thomas Gleixner <tglx@linutronix.de>, for their help.

In this version of the patch, based on the feedback, I have merged the IDT vector
for Xen and Hyper-V and made the necessary adjustments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/include/asm/irq_vectors.h |    4 +-
 arch/x86/include/asm/mshyperv.h    |    4 +++
 arch/x86/kernel/cpu/mshyperv.c     |   39 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/entry_32.S         |    9 +++++++-
 arch/x86/kernel/entry_64.S         |    7 +++++-
 drivers/xen/events.c               |    6 ++--
 6 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 1508e51..d09850b 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -109,8 +109,8 @@
 
 #define UV_BAU_MESSAGE			0xf5
 
-/* Xen vector callback to receive events in a HVM domain */
-#define XEN_HVM_EVTCHN_CALLBACK		0xf3
+/* Vector on which hypervisor callbacks will be delivered */
+#define HYPERVISOR_CALLBACK_VECTOR 	0xf3
 
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
index 0a630dd..3689622 100644
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
@@ -69,6 +74,11 @@ static void __init ms_hyperv_init_platform(void)
 	       ms_hyperv.features, ms_hyperv.hints);
 
 	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+
+	/*
+	 * Setup the IDT for hypervisor callback.
+	 */
+	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
@@ -77,3 +87,32 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.init_platform		= ms_hyperv_init_platform,
 };
 EXPORT_SYMBOL(x86_hyper_ms_hyperv);
+
+static int vmbus_irq = -1;
+static irq_handler_t vmbus_isr;
+
+void hv_register_vmbus_handler(int irq, irq_handler_t handler)
+{
+	vmbus_irq = irq;
+	vmbus_isr = handler;
+}
+EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
+
+void hyperv_vector_handler(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct irq_desc *desc;
+
+	irq_enter();
+#ifdef CONFIG_X86
+	exit_idle();
+#endif
+
+	desc = irq_to_desc(vmbus_irq);
+
+	if (desc)
+		generic_handle_irq_desc(vmbus_irq, desc);
+
+	irq_exit();
+	set_irq_regs(old_regs);
+}
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index e9dd4c4..7d2bb62 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1047,11 +1047,18 @@ ENTRY(xen_failsafe_callback)
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
index 1975122..803ca69 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1446,11 +1446,16 @@ ENTRY(xen_failsafe_callback)
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
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4293c57..5c2e92e 100644
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
@@ -1798,8 +1798,8 @@ void xen_callback_vector(void)
 		printk(KERN_INFO "Xen HVM callback vector for event delivery is "
 				"enabled\n");
 		/* in the restore case the vector has already been allocated */
-		if (!test_bit(XEN_HVM_EVTCHN_CALLBACK, used_vectors))
-			alloc_intr_gate(XEN_HVM_EVTCHN_CALLBACK, xen_hvm_callback_vector);
+		if (!test_bit(HYPERVISOR_CALLBACK_VECTOR, used_vectors))
+			alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, xen_hvm_callback_vector);
 	}
 }
 #else
-- 
1.7.4.1

