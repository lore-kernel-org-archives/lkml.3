Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaDRHum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:50:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:14928 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaDRHuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,883,1389772800"; 
   d="scan'208";a="495211228"
Date: Fri, 18 Apr 2014 15:49:55 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@kernel.org>, tglx@lintronix.de
Cc: Clemens Ladisch <clemens@ladisch.de>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH] x86, hpet: Add quirk to disable HPET for baytrail
 platform
Message-ID: <20140418074955.GA3482@feng-snb>
References: <20140328071716.GC30107@gmail.com>
 <20140328073718.GA12762@feng-snb>
 <53352DE5.2090600@ladisch.de>
 <20140328081117.GA32308@gmail.com>
 <20140415074443.GA10911@feng-snb>
 <20140415090025.GA31244@gmail.com>
 <20140415095539.GA19271@feng-snb>
 <20140415104206.GA31656@gmail.com>
 <20140415141206.GA12076@feng-snb>
 <20140416065148.GB1193@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416065148.GB1193@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please help to review this RFC patch, if you are ok with it. I'll separte them into
2 and repost.
	1. make the boot_hpet_disable extern
	2. add quirk for baytrail HPET.
thanks!

- Feng



>From 4b8c370649f1d2b320aa46a005b8b61eb59a539e Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Fri, 18 Apr 2014 15:43:22 +0800
Subject: [PATCH] x86, hpet: Add quirk to disable HPET for baytrail platform

HPET on current baytrail platform has accuracy problem to be used as
reliable clocksource/clockevent, so add a early quirk to disable it.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/include/asm/hpet.h    |    1 +
 arch/x86/kernel/early-quirks.c |   14 ++++++++++++++
 arch/x86/kernel/hpet.c         |    2 +-
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index b18df57..36f7125 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -63,6 +63,7 @@
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
 extern unsigned long force_hpet_address;
+extern int boot_hpet_disable;
 extern u8 hpet_blockid;
 extern int hpet_force_user;
 extern u8 hpet_msi_disable;
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..1e5f6bc 100644
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
@@ -380,6 +381,13 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
 	}
 }
 
+static void __init force_disable_hpet(int num, int slot, int func)
+{
+	boot_hpet_disable = 1;
+	pr_info("Will Disable HPET for this platform\n");
+}
+
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -417,6 +425,12 @@ static struct chipset early_qrk[] __initdata = {
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
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..913e207 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -88,7 +88,7 @@ static inline void hpet_clear_mapping(void)
 /*
  * HPET command line enable / disable
  */
-static int boot_hpet_disable;
+int boot_hpet_disable;
 int hpet_force_user;
 static int hpet_verbose;
 
-- 
1.7.0.4

