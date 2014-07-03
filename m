Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbaGCJYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030406AbaGCJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bryan Evenson <bevenson@melinkcorp.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mark Roszko <mark.roszko@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 154/198] ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs
Date: Thu,  3 Jul 2014 10:19:57 +0100
Message-Id: <1404379241-8590-155-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

commit 9dcc87fec8947308e0111c65dcd881e6aa5b1673 upstream.

sam9x5 SoCs have the following errata:
 "RTC: Interrupt Mask Register cannot be used
  Interrupt Mask Register read always returns 0."

Hence we should not rely on what IMR claims about already masked IRQs
and just disable all IRQs.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
Reviewed-by: Johan Hovold <johan@hovold.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Roszko <mark.roszko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-at91/sysirq_mask.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/sysirq_mask.c b/arch/arm/mach-at91/sysirq_mask.c
index 2ba694f9626b..f8bc3511a8c8 100644
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
+	 * sam9x5 SoCs have the following errata:
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
1.9.1

