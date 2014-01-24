Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaAXGDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 01:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaAXGDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:03:35 -0500
From: Jason Wang <jasowang@redhat.com>
To: kys@microsoft.com, haiyangz@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH] x86, hyperv: bypass the timer_irq_works() check
Date: Fri, 24 Jan 2014 14:02:51 +0800
Message-Id: <1390543371-10748-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch bypass the timer_irq_works() check for hyperv guest since:

- It was guaranteed to work.
- timer_irq_works() may fail sometime due to the lpj calibration were inaccurate
  in a hyperv guest or a buggy host.

In the future, we should get the tsc frequency from hypervisor and use preset
lpj instead.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 9f7ca26..832d05a 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -26,6 +26,7 @@
 #include <asm/irq_regs.h>
 #include <asm/i8259.h>
 #include <asm/apic.h>
+#include <asm/timer.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -105,6 +106,11 @@ static void __init ms_hyperv_init_platform(void)
 
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+
+#ifdef CONFIG_X86_IO_APIC
+	no_timer_check = 1;
+#endif
+
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
-- 
1.8.3.2

