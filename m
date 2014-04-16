Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569AbaDPOgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:36:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:39628 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161488AbaDPOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:36:31 -0400
Message-Id: <20140416143316.299247848@linutronix.de>
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
Subject: [patch 4/4] clocksource: exynos_mct: Register clock event after
 request_irq()
References: <20140416142106.537575971@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-exynos_mct-fix-too-early-isr-fire-up-on-wrong-cpu.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

After hotplugging CPU1 the first call of interrupt handler for CPU1
oneshot timer was called on CPU0 because it fired before setting IRQ
affinity. Affected are SoCs where Multi Core Timer interrupts are
shared (SPI), e.g. Exynos 4210.

During setup of the MCT timers the clock event device should be
registered after setting the affinity for interrupt. This will prevent
starting the timer too early.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/exynos_mct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: tip/drivers/clocksource/exynos_mct.c
===================================================================
--- tip.orig/drivers/clocksource/exynos_mct.c
+++ tip/drivers/clocksource/exynos_mct.c
@@ -416,8 +416,6 @@ static int exynos4_local_timer_setup(str
 	evt->set_mode = exynos4_tick_set_mode;
 	evt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
 	evt->rating = 450;
-	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
-					0xf, 0x7fffffff);
 
 	exynos4_mct_write(TICK_BASE_CNT, mevt->base + MCT_L_TCNTB_OFFSET);
 
@@ -434,6 +432,8 @@ static int exynos4_local_timer_setup(str
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
+	clockevents_config_and_register(evt, clk_rate / (TICK_BASE_CNT + 1),
+					0xf, 0x7fffffff);
 
 	return 0;
 }


