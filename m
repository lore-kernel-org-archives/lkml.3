Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaJTTJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:09:30 -0400
Received: from mail-qg0-f73.google.com ([209.85.192.73]:41350 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaJTTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:10 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/19] MIPS: Malta: Stop using GIC REG macros
Date: Mon, 20 Oct 2014 12:03:51 -0700
Message-Id: <1413831846-32100-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using the REG macros from gic.h and instead use proper iomem
accessors.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/mti-malta/malta-int.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index bcab0b1..864d482 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -37,7 +37,7 @@
 #include <asm/setup.h>
 #include <asm/rtlx.h>
 
-static unsigned long _msc01_biu_base;
+static void __iomem *_msc01_biu_base;
 
 static DEFINE_RAW_SPINLOCK(mips_irq_lock);
 
@@ -293,10 +293,9 @@ void __init arch_init_irq(void)
 		gic_present = 1;
 	} else {
 		if (mips_revision_sconid == MIPS_REVISION_SCON_ROCIT) {
-			_msc01_biu_base = (unsigned long)
-					ioremap_nocache(MSC01_BIU_REG_BASE,
+			_msc01_biu_base = ioremap_nocache(MSC01_BIU_REG_BASE,
 						MSC01_BIU_ADDRSPACE_SZ);
-			gic_present = (REG(_msc01_biu_base, MSC01_SC_CFG) &
+			gic_present = (readl(_msc01_biu_base + MSC01_SC_CFG_OFS) &
 					MSC01_SC_CFG_GICPRES_MSK) >>
 					MSC01_SC_CFG_GICPRES_SHF;
 		}
@@ -336,9 +335,9 @@ void __init arch_init_irq(void)
 			 MIPS_GIC_IRQ_BASE);
 		if (!mips_cm_present()) {
 			/* Enable the GIC */
-			i = REG(_msc01_biu_base, MSC01_SC_CFG);
-			REG(_msc01_biu_base, MSC01_SC_CFG) =
-				(i | (0x1 << MSC01_SC_CFG_GICENA_SHF));
+			i = readl(_msc01_biu_base + MSC01_SC_CFG_OFS);
+			writel(i | (0x1 << MSC01_SC_CFG_GICENA_SHF),
+				 _msc01_biu_base + MSC01_SC_CFG_OFS);
 			pr_debug("GIC Enabled\n");
 		}
 		i8259_irq = MIPS_GIC_IRQ_BASE + GIC_INT_I8259A;
-- 
2.1.0.rc2.206.gedb03e5

