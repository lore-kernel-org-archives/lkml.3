Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161585AbaDPOgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:36:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:39624 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161487AbaDPOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:36:31 -0400
Message-Id: <20140416143316.106665251@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 16 Apr 2014 14:36:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
Subject: [patch 3/4] clocksource: exynos_mct: Use irq_force_affinity() in cpu
 bringup
References: <20140416142106.537575971@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-exynos_mct-use-irq-force-affinity.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The starting cpu is not yet in the online mask so irq_set_affinity()
fails which results in per cpu timers for this cpu ending up on some
other online cpu, ususally cpu 0.

Use irq_force_affinity() which disables the online mask check and
makes things work.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/exynos_mct.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: tip/drivers/clocksource/exynos_mct.c
===================================================================
--- tip.orig/drivers/clocksource/exynos_mct.c
+++ tip/drivers/clocksource/exynos_mct.c
@@ -430,6 +430,7 @@ static int exynos4_local_timer_setup(str
 				evt->irq);
 			return -EIO;
 		}
+		irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
@@ -450,7 +451,6 @@ static int exynos4_mct_cpu_notify(struct
 					   unsigned long action, void *hcpu)
 {
 	struct mct_clock_event_device *mevt;
-	unsigned int cpu;
 
 	/*
 	 * Grab cpu pointer in each case to avoid spurious
@@ -461,12 +461,6 @@ static int exynos4_mct_cpu_notify(struct
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_setup(&mevt->evt);
 		break;
-	case CPU_ONLINE:
-		cpu = (unsigned long)hcpu;
-		if (mct_int_type == MCT_INT_SPI)
-			irq_set_affinity(mct_irqs[MCT_L0_IRQ + cpu],
-						cpumask_of(cpu));
-		break;
 	case CPU_DYING:
 		mevt = this_cpu_ptr(&percpu_mct_tick);
 		exynos4_local_timer_stop(&mevt->evt);


