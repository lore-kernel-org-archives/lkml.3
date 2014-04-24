Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaDXITU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:19:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:6922 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaDXITR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:19:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,917,1389772800"; 
   d="scan'208";a="423030763"
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, John Stultz <john.stultz@linaro.org>,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 2/2] x86: Add quirk to disable HPET for baytrail platform
Date: Thu, 24 Apr 2014 16:18:18 +0800
Message-Id: <1398327498-13163-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398327498-13163-1-git-send-email-feng.tang@intel.com>
References: <1398327498-13163-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPET on current Baytrail platform has accuracy problem to be used as
reliable clocksource/clockevent, so add a early quirk to disable it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/early-quirks.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 6e2537c..67c33fd 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -17,6 +17,7 @@
 #include <asm/dma.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
+#include <asm/hpet.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/irq_remapping.h>
@@ -530,6 +531,15 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
 	}
 }
 
+static void __init force_disable_hpet(int num, int slot, int func)
+{
+#ifdef CONFIG_HPET_TIMER
+	boot_hpet_disable = 1;
+	pr_info("Will Disable HPET for this platform\n");
+#endif
+}
+
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -567,6 +577,12 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
 	  QFLAG_APPLY_ONCE, intel_graphics_stolen },
+	/*
+	 * HPET on current version of Baytrail platform has accuracy
+	 * problem, disable it for now
+	 */
+	{ PCI_VENDOR_ID_INTEL, 0x0f00,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{}
 };
 
-- 
1.7.9.5

