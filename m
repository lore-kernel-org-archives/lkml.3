Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaC0SIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:08:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaC0SID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:08:03 -0400
Date: Thu, 27 Mar 2014 11:07:29 -0700
From: tip-bot for Jason Wang <tipbot@zytor.com>
Message-ID: <tip-ca3ba2a2f4a49a308e7d78c784d51b2332064f15@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jasowang@redhat.com, kys@microsoft.com, stable@vger.kernel.org,
        haiyangz@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, kys@microsoft.com, stable@vger.kernel.org,
        haiyangz@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1393558229-14755-1-git-send-email-jasowang@redhat.com>
References: <1393558229-14755-1-git-send-email-jasowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] x86, hyperv: Bypass the timer_irq_works() check
Git-Commit-ID: ca3ba2a2f4a49a308e7d78c784d51b2332064f15
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

Commit-ID:  ca3ba2a2f4a49a308e7d78c784d51b2332064f15
Gitweb:     http://git.kernel.org/tip/ca3ba2a2f4a49a308e7d78c784d51b2332064f15
Author:     Jason Wang <jasowang@redhat.com>
AuthorDate: Fri, 28 Feb 2014 11:30:29 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Mar 2014 11:02:45 -0700

x86, hyperv: Bypass the timer_irq_works() check

This patch bypass the timer_irq_works() check for hyperv guest since:

- It was guaranteed to work.
- timer_irq_works() may fail sometime due to the lpj calibration were inaccurate
  in a hyperv guest or a buggy host.

In the future, we should get the tsc frequency from hypervisor and use preset
lpj instead.

[ hpa: I would prefer to not defer things to "the future" in the future... ]

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: <stable@vger.kernel.org>
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: http://lkml.kernel.org/r/1393558229-14755-1-git-send-email-jasowang@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
