Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaIBNDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:03:34 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61131 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaIBNDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:03:31 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: [PATCH v11 08/19] irqchip: gic: Remove spin locks from eoi_irq
Date: Tue,  2 Sep 2014 14:00:42 +0100
Message-Id: <1409662853-29313-9-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
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
index 6fa0542..d928912 100644
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
@@ -413,13 +410,6 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
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

