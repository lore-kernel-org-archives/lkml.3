Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbaGUOsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:48:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62537 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaGUOsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:48:17 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Marex Vasut <marex@denx.de>,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: [PATCH RFC 3/9] irqchip: gic: Remove spin locks from eoi_irq
Date: Mon, 21 Jul 2014 15:47:14 +0100
Message-Id: <1405954040-30399-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is motivated by the comment it removes from gic_init_fiq,
namely that the spin locks in eoi_irq preclude certain platforms from
supporting FIQ.

Currently there is only one upstream platform (tegra) that actually
hooks gic_arch_extn.irq_eoi and it does not require these spin locks.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/irqchip/irq-gic.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d3c7559..5c934a4 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -191,11 +191,8 @@ static void gic_unmask_irq(struct irq_data *d)
 
 static void gic_eoi_irq(struct irq_data *d)
 {
-	if (gic_arch_extn.irq_eoi) {
-		raw_spin_lock(&irq_controller_lock);
+	if (gic_arch_extn.irq_eoi)
 		gic_arch_extn.irq_eoi(d);
-		raw_spin_unlock(&irq_controller_lock);
-	}
 
 	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
 }
@@ -437,13 +434,6 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
 	unsigned int i;
 
 	/*
-	 * FIQ can only be supported on platforms without an extended irq_eoi
-	 * method (otherwise we take a lock during eoi handling).
-	 */
-	if (gic_arch_extn.irq_eoi)
-		return;
-
-	/*
 	 * If grouping is not available (not implemented or prohibited by
 	 * security mode) these registers a read-as-zero/write-ignored.
 	 * However as a precaution we restore the reset default regardless of
-- 
1.9.3

