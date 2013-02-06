Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3BFO63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:58:29 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56822
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab3BFO6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:58:25 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for delivering VMBUS interrupts
Date: Wed,  6 Feb 2013 07:25:59 -0800
Message-Id: <1360164359-12273-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the infrastructure for delivering VMBUS interrupts using a
special vector. With this patch, we can now properly handle
the VMBUS interrupts that can be delivered on any CPU. Also,
turn on interrupt load balancing as well.

This patch requires the infrastructure that was implemented in the patch:
X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel_mgmt.c |    2 +-
 drivers/hv/hv.c           |    5 ++---
 drivers/hv/vmbus_drv.c    |   11 +++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 53a8600..ff1be16 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -318,7 +318,7 @@ static u32 get_vp_index(uuid_le *type_guid)
 		return 0;
 	}
 	cur_cpu = (++next_vp % max_cpus);
-	return 0;
+	return cur_cpu;
 }
 
 /*
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 1c5481d..7311589 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -272,7 +272,7 @@ u16 hv_signal_event(void *con_id)
  * retrieve the initialized message and event pages.  Otherwise, we create and
  * initialize the message and event pages.
  */
-void hv_synic_init(void *irqarg)
+void hv_synic_init(void *arg)
 {
 	u64 version;
 	union hv_synic_simp simp;
@@ -281,7 +281,6 @@ void hv_synic_init(void *irqarg)
 	union hv_synic_scontrol sctrl;
 	u64 vp_index;
 
-	u32 irq_vector = *((u32 *)(irqarg));
 	int cpu = smp_processor_id();
 
 	if (!hv_context.hypercall_page)
@@ -335,7 +334,7 @@ void hv_synic_init(void *irqarg)
 	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	shared_sint.as_uint64 = 0;
-	shared_sint.vector = irq_vector; /* HV_SHARED_SINT_IDT_VECTOR + 0x20; */
+	shared_sint.vector = HYPERVISOR_CALLBACK_VECTOR;
 	shared_sint.masked = false;
 	shared_sint.auto_eoi = true;
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index cf19dfa..bf421e0 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -36,6 +36,7 @@
 #include <linux/kernel_stat.h>
 #include <asm/hyperv.h>
 #include <asm/hypervisor.h>
+#include <asm/mshyperv.h>
 #include "hyperv_vmbus.h"
 
 
@@ -528,7 +529,6 @@ static void vmbus_flow_handler(unsigned int irq, struct irq_desc *desc)
 static int vmbus_bus_init(int irq)
 {
 	int ret;
-	unsigned int vector;
 
 	/* Hypervisor initialization...setup hypercall page..etc */
 	ret = hv_init();
@@ -558,13 +558,16 @@ static int vmbus_bus_init(int irq)
 	 */
 	irq_set_handler(irq, vmbus_flow_handler);
 
-	vector = IRQ0_VECTOR + irq;
+	/*
+	 * Register our interrupt handler.
+	 */
+	hv_register_vmbus_handler(irq, vmbus_isr);
 
 	/*
-	 * Notify the hypervisor of our irq and
+	 * Initialize the per-cpu interrupt state and
 	 * connect to the host.
 	 */
-	on_each_cpu(hv_synic_init, (void *)&vector, 1);
+	on_each_cpu(hv_synic_init, NULL, 1);
 	ret = vmbus_connect();
 	if (ret)
 		goto err_irq;
-- 
1.7.4.1

