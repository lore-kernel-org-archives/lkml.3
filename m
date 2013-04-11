Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937732Ab3DKAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:09:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57204 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937513Ab3DKAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Arnd Bergmann <arnd@arnd.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 27/30] irqchip: exynos: localize irq lookup for ATAGS
Date: Thu, 11 Apr 2013 02:05:09 +0200
Message-Id: <1365638712-1028578-28-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:PVfhk4dgOI35h9PEHeZorP8rCSmCIt+6VnBbVRNEKF+
 ytLv0mnnT4mZnlkTFSdQZDe0Lxc7+vhdH5xH0w976PxC+9hewQ
 ujk8XyZmVBue8bJE1OujIDFDLVwRrfMnnBpnPZD6mc3XZUfOsf
 ULAgVeKvidnlZUB77Dd7XzXRascByb6QlKeGyg0wiydKI0hyqb
 ciljbjjpkY21hfy7W2sE4RSdJN4Wmb0Wj+GI/F6PxEmYvKze8l
 rqZ4eB/Wf5rQLWPrgz0zV/8dzLS00TWOpPO+m+o2tktW8VJd3I
 8VoDvY8vbq9Vm9SXfTQDEsJ5W6NvBwyh3cySgPEIiyzkwc3Wnw
 uBuA0WPcReEm+U7EyroJw+8EkV0r3toxIFbrQKD6lzyV9Dv3W4
 uRvOUsxFpH0Ug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ_SPI() macro is not available in the driver when building with sparse
IRQs or multiplatform, so let's move all users of this into one function
that we can leave out when building DT-only.

Signed-off-by: Arnd Bergmann <arnd@arnd.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/exynos-combiner.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index ffb10aa..31a4e96 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -19,7 +19,9 @@
 #include <linux/of_irq.h>
 #include <asm/mach/irq.h>
 
+#ifdef CONFIG_EXYNOS_ATAGS
 #include <plat/cpu.h>
+#endif
 
 #include "irqchip.h"
 
@@ -183,8 +185,12 @@ static struct irq_domain_ops combiner_irq_domain_ops = {
 	.map	= combiner_irq_domain_map,
 };
 
-static unsigned int exynos4x12_combiner_extra_irq(int group)
+static unsigned int combiner_lookup_irq(int group)
 {
+#ifdef CONFIG_EXYNOS_ATAGS
+	if (group < EXYNOS4210_MAX_COMBINER_NR || soc_is_exynos5250())
+		return IRQ_SPI(group);
+
 	switch (group) {
 	case 16:
 		return IRQ_SPI(107);
@@ -194,9 +200,9 @@ static unsigned int exynos4x12_combiner_extra_irq(int group)
 		return IRQ_SPI(48);
 	case 19:
 		return IRQ_SPI(42);
-	default:
-		return 0;
 	}
+#endif
+	return 0;
 }
 
 void __init combiner_init(void __iomem *combiner_base,
@@ -229,14 +235,13 @@ void __init combiner_init(void __iomem *combiner_base,
 	}
 
 	for (i = 0; i < max_nr; i++) {
-		if (i < EXYNOS4210_MAX_COMBINER_NR || soc_is_exynos5250())
-			irq = IRQ_SPI(i);
-		else
-			irq = exynos4x12_combiner_extra_irq(i);
 #ifdef CONFIG_OF
 		if (np)
 			irq = irq_of_parse_and_map(np, i);
+		else
 #endif
+			irq = combiner_lookup_irq(i);
+
 		combiner_init_one(&combiner_data[i], i,
 				  combiner_base + (i >> 2) * 0x10, irq);
 		combiner_cascade_irq(&combiner_data[i], irq);
-- 
1.8.1.2

