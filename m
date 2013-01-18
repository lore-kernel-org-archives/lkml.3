Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3ARANT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:13:19 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:59065
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3ARANS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:13:18 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
Date: Thu, 17 Jan 2013 16:39:37 -0800
Message-Id: <1358469577-8794-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/include/asm/irq_vectors.h |    2 +
 arch/x86/include/asm/mshyperv.h    |    4 +++
 arch/x86/kernel/cpu/mshyperv.c     |   39 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/entry_32.S         |    7 ++++++
 arch/x86/kernel/entry_64.S         |    5 ++++
 5 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 1508e51..c2ff239 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -112,6 +112,8 @@
 /* Xen vector callback to receive events in a HVM domain */
 #define XEN_HVM_EVTCHN_CALLBACK		0xf3
 
+/* Hyper-V vector callback to receive vmbus interrupts*/
+#define HYPER_V_CALLBACK_VECTOR		0xf2
 /*
  * Local APIC timer IRQ vector is on a different priority level,
  * to work around the 'lost local interrupt if more than 2 IRQ
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
index 0a630dd..03be583 100644
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
+	alloc_intr_gate(HYPER_V_CALLBACK_VECTOR, hyperv_callback_vector);
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
@@ -77,3 +87,32 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.init_platform		= ms_hyperv_init_platform,
 };
 EXPORT_SYMBOL(x86_hyper_ms_hyperv);
+
+static int vmbus_irq;
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
index e9dd4c4..7743876 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1052,6 +1052,13 @@ BUILD_INTERRUPT3(xen_hvm_callback_vector, XEN_HVM_EVTCHN_CALLBACK,
 
 #endif	/* CONFIG_XEN */
 
+#if IS_ENABLED(CONFIG_HYPERV)
+
+BUILD_INTERRUPT3(hyperv_callback_vector, HYPER_V_CALLBACK_VECTOR,
+	hyperv_vector_handler)
+
+#endif /* CONFIG_HYPERV */
+
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1975122..a1cb724 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1451,6 +1451,11 @@ apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
 
 #endif /* CONFIG_XEN */
 
+#if IS_ENABLED(CONFIG_HYPERV)
+apicinterrupt HYPER_V_CALLBACK_VECTOR \
+	hyperv_callback_vector hyperv_vector_handler
+#endif /* CONFIG_HYPERV */
+
 /*
  * Some functions should be protected against kprobes
  */
-- 
1.7.4.1

