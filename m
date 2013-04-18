Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967783Ab3DRRCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:02:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936055Ab3DRRC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:02:27 -0400
Date: Thu, 18 Apr 2013 10:02:12 -0700
From: "tip-bot for K. Y. Srinivasan" <tipbot@zytor.com>
Message-ID: <tip-7eff7ded02d1b15ba8321664839b353fa6c0c1e4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mst@redhat.com, kys@microsoft.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, kys@microsoft.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1366299886-6399-1-git-send-email-kys@microsoft.com>
References: <1366299886-6399-1-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hyperv:
  Handle Xen emulation of Hyper-V more gracefully
Git-Commit-ID: 7eff7ded02d1b15ba8321664839b353fa6c0c1e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 18 Apr 2013 10:02:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7eff7ded02d1b15ba8321664839b353fa6c0c1e4
Gitweb:     http://git.kernel.org/tip/7eff7ded02d1b15ba8321664839b353fa6c0c1e4
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Thu, 18 Apr 2013 08:44:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 18 Apr 2013 08:59:20 -0700

x86, hyperv: Handle Xen emulation of Hyper-V more gracefully

Install the Hyper-V specific interrupt handler only when needed. This would
permit us to get rid of the Xen check. Note that when the vmbus drivers invokes
the call to register its handler, we are sure to be running on Hyper-V.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Link: http://lkml.kernel.org/r/1366299886-6399-1-git-send-email-kys@microsoft.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

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
