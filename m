Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaDUEfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:35:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaDUEem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.13 03/32] x86, hyperv: Bypass the timer_irq_works() check
Date: Sun, 20 Apr 2014 19:13:20 -0700
Message-Id: <20140421021134.341569976@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mshyperv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -26,6 +26,7 @@
 #include <asm/irq_regs.h>
 #include <asm/i8259.h>
 #include <asm/apic.h>
+#include <asm/timer.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -105,6 +106,11 @@ static void __init ms_hyperv_init_platfo
 
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+
+#ifdef CONFIG_X86_IO_APIC
+	no_timer_check = 1;
+#endif
+
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {


