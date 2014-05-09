Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaEILBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:01:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44700 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673AbaEILBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:01:40 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Roszko <mark.roszko@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [PATCH v3] ARM: at91: fix startup rtc irq mask for sam9g25 and sam9g35 SoCs
Date: Fri,  9 May 2014 13:01:37 +0200
Message-Id: <1399633297-6813-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sam9g25 and sam9g35 have the following errata:
"RTC: Interrupt Mask Register cannot be used
 Interrupt Mask Register read always returns 0."

Hence we should not rely on what IMR claims about already masked irqs
and just disable all the IRQs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # v3.10+
Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
Hello,

Sorry for the noise, I just forgot to remove the mask variable in my
previous version.

Best Regards,

Boris

Changes since v2:
- removed unused variable 'mask'
Changes since v1:
- use a macro to define IRQs bitmask
- read IMR register to ensure the write to IDR has been flushed
- quote atmel's datasheet errata in commit message
- comment the code to describe why we're not using IMR to disable
  the interrupts

 arch/arm/mach-at91/sysirq_mask.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
index 2ba694f..1527dda 100644
--- a/arch/arm/mach-at91/sysirq_mask.c
+++ b/arch/arm/mach-at91/sysirq_mask.c
@@ -25,24 +25,28 @@
 
 #include "generic.h"
 
-#define AT91_RTC_IDR	0x24	/* Interrupt Disable Register */
-#define AT91_RTC_IMR	0x28	/* Interrupt Mask Register */
+#define AT91_RTC_IDR		0x24	/* Interrupt Disable Register */
+#define AT91_RTC_IMR		0x28	/* Interrupt Mask Register */
+#define AT91_RTC_IRQ_MASK	0x1f	/* Available IRQs mask */
 
 void __init at91_sysirq_mask_rtc(u32 rtc_base)
 {
 	void __iomem *base;
-	u32 mask;
 
 	base = ioremap(rtc_base, 64);
 	if (!base)
 		return;
 
-	mask = readl_relaxed(base + AT91_RTC_IMR);
-	if (mask) {
-		pr_info("AT91: Disabling rtc irq\n");
-		writel_relaxed(mask, base + AT91_RTC_IDR);
-		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
-	}
+	/*
+	 * The sam9g25 and sam9g35 have the following errata:
+	 * "RTC: Interrupt Mask Register cannot be used
+	 *  Interrupt Mask Register read always returns 0."
+	 *
+	 * Hence we're not relying on IMR values to disable
+	 * interrupts.
+	 */
+	writel_relaxed(AT91_RTC_IRQ_MASK, base + AT91_RTC_IDR);
+	(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
 
 	iounmap(base);
 }
-- 
1.8.3.2

