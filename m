Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937807Ab3DKAM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:12:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937220Ab3DKAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 24/30] clocksource: exynos_mct: remove platform header dependency
Date: Thu, 11 Apr 2013 02:05:06 +0200
Message-Id: <1365638712-1028578-25-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:yITsnTetzWNAwMuBhmad716D+6eWHQ9kRd7NwkPGBEP
 T9BGm8OfycWmUa+NziDnbr8IY5Cfr7gKKUe3Uu82owu8GQ+KWJ
 yo4QZiOGsM0iBHZFYAwjHrnxVzpm+0OgWaPypxAgRUIApSnADe
 Qbc3ExcBbRLx32s6BbJ795Iopq9giCzSgZ1kB4m0H1AAqzMDe2
 XumST09s9mMws6CBOBIcONCnbH9FF/BFI4IcT/AvRJ1oWb7DlV
 PU14dIipy33Ja+5C81x4wOOl80/fmaa40PlRT7g9EviyKSYt/W
 6VBIin5SNQwlRkaoerwbZoIWR0uHvLiUqCxqdshBAZ/yKjt351
 /muD2YgXjUUIYuIdUJYDQ2Cdp060LmlPcuuLuY6RTnZkqh4E9U
 xR2plmsB9f5gQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the non-DT case, the mct_init() function requires access
to a couple of platform specific constants, but cannot include
the header files in case we are building for multiplatform.

This changes the interface to the platform so we pass all
the necessary data as arguments to mct_init.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
---
 arch/arm/mach-exynos/common.c    |  2 +-
 arch/arm/mach-exynos/common.h    |  2 +-
 drivers/clocksource/exynos_mct.c | 21 ++++++---------------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 87b2e06..8e85d6c 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -448,7 +448,7 @@ void __init exynos_init_time(void)
 		exynos4_clk_init(NULL, !soc_is_exynos4210(), S5P_VA_CMU, readl(S5P_VA_CHIPID + 8) & 1);
 		exynos4_clk_register_fixed_ext(xxti_f, xusbxti_f);
 #endif
-		mct_init();
+		mct_init(S5P_VA_SYSTIMER, EXYNOS4_IRQ_MCT_G0, EXYNOS4_IRQ_MCT_L0, EXYNOS4_IRQ_MCT_L1);
 	}
 }
 
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 9832e03..f426a5b 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -14,7 +14,7 @@
 
 #include <linux/of.h>
 
-extern void mct_init(void);
+void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
 void exynos_init_time(void);
 extern unsigned long xxti_f, xusbxti_f;
 
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 020ba55..88ff404 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -26,11 +26,6 @@
 
 #include <asm/arch_timer.h>
 #include <asm/localtimer.h>
-
-#include <plat/cpu.h>
-
-#include <mach/map.h>
-#include <mach/irqs.h>
 #include <asm/mach/time.h>
 
 #define EXYNOS4_MCTREG(x)		(x)
@@ -511,18 +506,14 @@ static void __init exynos4_timer_resources(struct device_node *np, void __iomem
 #endif /* CONFIG_LOCAL_TIMERS */
 }
 
-void __init mct_init(void)
+void __init mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1)
 {
-	if (soc_is_exynos4210()) {
-		mct_irqs[MCT_G0_IRQ] = EXYNOS4_IRQ_MCT_G0;
-		mct_irqs[MCT_L0_IRQ] = EXYNOS4_IRQ_MCT_L0;
-		mct_irqs[MCT_L1_IRQ] = EXYNOS4_IRQ_MCT_L1;
-		mct_int_type = MCT_INT_SPI;
-	} else {
-		panic("unable to determine mct controller type\n");
-	}
+	mct_irqs[MCT_G0_IRQ] = irq_g0;
+	mct_irqs[MCT_L0_IRQ] = irq_l0;
+	mct_irqs[MCT_L1_IRQ] = irq_l1;
+	mct_int_type = MCT_INT_SPI;
 
-	exynos4_timer_resources(NULL, S5P_VA_SYSTIMER);
+	exynos4_timer_resources(NULL, base);
 	exynos4_clocksource_init();
 	exynos4_clockevent_init();
 }
-- 
1.8.1.2

