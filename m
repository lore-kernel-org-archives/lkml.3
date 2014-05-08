Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaEHKqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:46:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaEHKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:46:33 -0400
Date: Thu, 8 May 2014 03:45:58 -0700
From: tip-bot for Feng Tang <tipbot@zytor.com>
Message-ID: <tip-62187910b0fc7a75cfec9c30fda58ce2f39d689b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, john.stultz@linaro.org,
        tglx@linutronix.de, feng.tang@intel.com, clemens@ladisch.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, john.stultz@linaro.org,
        tglx@linutronix.de, feng.tang@intel.com, clemens@ladisch.de
In-Reply-To: <1398327498-13163-2-git-send-email-feng.tang@intel.com>
References: <1398327498-13163-2-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/intel:
  Add quirk to disable HPET for the Baytrail platform
Git-Commit-ID: 62187910b0fc7a75cfec9c30fda58ce2f39d689b
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

Commit-ID:  62187910b0fc7a75cfec9c30fda58ce2f39d689b
Gitweb:     http://git.kernel.org/tip/62187910b0fc7a75cfec9c30fda58ce2f39d689b
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 24 Apr 2014 16:18:18 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 08:15:34 +0200

x86/intel: Add quirk to disable HPET for the Baytrail platform

HPET on current Baytrail platform has accuracy problem to be
used as reliable clocksource/clockevent, so add a early quirk to
disable it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1398327498-13163-2-git-send-email-feng.tang@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/early-quirks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 6e2537c..6cda0ba 100644
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
+	pr_info("x86/hpet: Will disable the HPET for this platform because it's not reliable\n");
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
+	 * problems, disable it for now:
+	 */
+	{ PCI_VENDOR_ID_INTEL, 0x0f00,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{}
 };
 
