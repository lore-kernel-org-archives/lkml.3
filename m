Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaD1Bcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42874 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Haiyang Zhang" <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Jason Wang" <jasowang@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.751965476@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 60/94] x86, hyperv: Bypass the timer_irq_works() check
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/mshyperv.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -18,6 +18,7 @@
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
 #include <asm/mshyperv.h>
+#include <asm/timer.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -70,6 +71,11 @@ static void __init ms_hyperv_init_platfo
 
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+
+#ifdef CONFIG_X86_IO_APIC
+	no_timer_check = 1;
+#endif
+
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {

