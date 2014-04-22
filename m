Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbaDVUn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:43:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbaDVUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 092/133] x86, hyperv: Bypass the timer_irq_works() check
Date: Tue, 22 Apr 2014 13:13:50 -0700
Message-Id: <1398197671-12786-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit ca3ba2a2f4a49a308e7d78c784d51b2332064f15 upstream.

This patch bypass the timer_irq_works() check for hyperv guest since:

- It was guaranteed to work.
- timer_irq_works() may fail sometime due to the lpj calibration were inaccurate
  in a hyperv guest or a buggy host.

In the future, we should get the tsc frequency from hypervisor and use preset
lpj instead.

[ hpa: I would prefer to not defer things to "the future" in the future... ]

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: http://lkml.kernel.org/r/1393558229-14755-1-git-send-email-jasowang@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 646d192..1a3cf6e 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -18,6 +18,7 @@
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
 #include <asm/mshyperv.h>
+#include <asm/timer.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -70,6 +71,11 @@ static void __init ms_hyperv_init_platform(void)
 
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
1.9.1

