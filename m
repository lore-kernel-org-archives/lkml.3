Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaFJUbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:31:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaFJTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/160] clocksource: Exynos_mct: Use irq_force_affinity() in cpu bringup
Date: Tue, 10 Jun 2014 12:45:08 -0700
Message-Id: <1402429600-20477-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 30ccf03b4a6a2102a2219058bdc6d779dc637dd7 upstream.

The starting cpu is not yet in the online mask so irq_set_affinity()
fails which results in per cpu timers for this cpu ending up on some
other online cpu, ususally cpu 0.

Use irq_force_affinity() which disables the online mask check and
makes things work.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
Link: http://lkml.kernel.org/r/20140416143316.106665251@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/clocksource/exynos_mct.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 62b0de6..b17b3e0 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -428,6 +428,7 @@ static int exynos4_local_timer_setup(struct clock_event_device *evt)
 				evt->irq);
 			return -EIO;
 		}
+		irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));
 	} else {
 		enable_percpu_irq(mct_irqs[MCT_L0_IRQ], 0);
 	}
@@ -448,7 +449,6 @@ static int exynos4_mct_cpu_notify(struct notifier_block *self,
 					   unsigned long action, void *hcpu)
 {
 	struct mct_clock_event_device *mevt;
-	unsigned int cpu;
 
 	/*
 	 * Grab cpu pointer in each case to avoid spurious
@@ -459,12 +459,6 @@ static int exynos4_mct_cpu_notify(struct notifier_block *self,
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
-- 
1.9.1

