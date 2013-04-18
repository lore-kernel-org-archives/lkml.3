Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967172Ab3DRPMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:12:43 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:33655
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966861Ab3DRPMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:12:41 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, JBeulich@suse.com, hpa@zytor.com, mst@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] X86: Handle Xen emulation of Hyper-V more gracefully
Date: Thu, 18 Apr 2013 08:44:46 -0700
Message-Id: <1366299886-6399-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Install the Hyper-V specific interrupt handler only when needed. This would
permit us to get rid of the Xen check. Note that when the vmbus drivers invokes
the call to register its handler, we are sure to be running on Hyper-V.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index a7d26d8..8f4be53 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -35,13 +35,6 @@ static bool __init ms_hyperv_platform(void)
 	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return false;
 
-	/*
-	 * Xen emulates Hyper-V to support enlightened Windows.
-	 * Check to see first if we are on a Xen Hypervisor.
-	 */
-	if (xen_cpuid_base())
-		return false;
-
 	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
 	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
 
@@ -82,12 +75,6 @@ static void __init ms_hyperv_init_platform(void)
 
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
-#if IS_ENABLED(CONFIG_HYPERV)
-	/*
-	 * Setup the IDT for hypervisor callback.
-	 */
-	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
-#endif
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
@@ -103,6 +90,11 @@ static irq_handler_t vmbus_isr;
 
 void hv_register_vmbus_handler(int irq, irq_handler_t handler)
 {
+	/*
+	 * Setup the IDT for hypervisor callback.
+	 */
+	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
+
 	vmbus_irq = irq;
 	vmbus_isr = handler;
 }
-- 
1.7.4.1

