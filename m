Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935677Ab3IEK4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:56:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57765 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934151Ab3IEK4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:56:05 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>
Subject: [PATCH] ARM: OMAP2+: wakeupgen: AM43x adaptation
Date: Thu, 5 Sep 2013 16:25:35 +0530
Message-ID: <1378378535-2967-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM43x has 224 interrupts and 7 banks, make it as maximum values. Keep
default values as earlier, if am43x is detected, update interrupts and
banks to maximum.

Also AM43x has only one cpu, ensure that clearing bitmask at wakeupgen
is done only for the single existing cpu, existing code assumes that
there are two cpu's.

If bitmask is cleared in wakeupgen for the nonexistent second cpu,
an imprecise abort happens as soon as Kernel switches to user space.
It was rootcaused by Sekhar Nori <nsekhar@ti.com>.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/omap-wakeupgen.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-wakeupgen.c b/arch/arm/mach-omap2/omap-wakeupgen.c
index 813c615..899d4946 100644
--- a/arch/arm/mach-omap2/omap-wakeupgen.c
+++ b/arch/arm/mach-omap2/omap-wakeupgen.c
@@ -33,8 +33,11 @@
 #include "omap4-sar-layout.h"
 #include "common.h"
 
-#define MAX_NR_REG_BANKS	5
-#define MAX_IRQS		160
+/* maximum value correspond to that of AM43x */
+#define MAX_NR_REG_BANKS	7
+#define MAX_IRQS		224
+#define DEFAULT_NR_REG_BANKS	5
+#define DEFAULT_IRQS		160
 #define WKG_MASK_ALL		0x00000000
 #define WKG_UNMASK_ALL		0xffffffff
 #define CPU_ENA_OFFSET		0x400
@@ -47,8 +50,8 @@ static void __iomem *wakeupgen_base;
 static void __iomem *sar_base;
 static DEFINE_RAW_SPINLOCK(wakeupgen_lock);
 static unsigned int irq_target_cpu[MAX_IRQS];
-static unsigned int irq_banks = MAX_NR_REG_BANKS;
-static unsigned int max_irqs = MAX_IRQS;
+static unsigned int irq_banks = DEFAULT_NR_REG_BANKS;
+static unsigned int max_irqs = DEFAULT_IRQS;
 static unsigned int omap_secure_apis;
 
 /*
@@ -402,6 +405,7 @@ int __init omap_wakeupgen_init(void)
 {
 	int i;
 	unsigned int boot_cpu = smp_processor_id();
+	bool am43x = soc_is_am43xx() ? true : false;
 
 	/* Not supported on OMAP4 ES1.0 silicon */
 	if (omap_rev() == OMAP4430_REV_ES1_0) {
@@ -418,12 +422,16 @@ int __init omap_wakeupgen_init(void)
 		irq_banks = OMAP4_NR_BANKS;
 		max_irqs = OMAP4_NR_IRQS;
 		omap_secure_apis = 1;
+	} else if (am43x) {
+		irq_banks = MAX_NR_REG_BANKS;
+		max_irqs = MAX_IRQS;
 	}
 
 	/* Clear all IRQ bitmasks at wakeupGen level */
 	for (i = 0; i < irq_banks; i++) {
 		wakeupgen_writel(0, i, CPU0_ID);
-		wakeupgen_writel(0, i, CPU1_ID);
+		if (!am43x)
+			wakeupgen_writel(0, i, CPU1_ID);
 	}
 
 	/*
-- 
1.8.3.4

