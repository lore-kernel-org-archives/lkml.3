Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3K1OWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:22:24 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52699 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213Ab3K1OWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:22:23 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: tglx@linutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, rob.herring@calxeda.com, olof@lixom.net,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH RESEND] irqchip: gic: fix boot for chained gics
Date: Thu, 28 Nov 2013 14:21:40 +0000
Message-Id: <1385648500-29048-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Could you please pick up this patch? It's the only thing preventing my Realview
EB ARM11MPCore from booting v3.13-rc1.

I've posted the patch a couple of times previously [1,2], but it seems to have
slipped through the cracks. I'm happy to rework the patch if there are any
comments.

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/191586.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/191630.html

---->8----
As of c0114709ed: "irqchip: gic: Perform the gic_secondary_init() call
via CPU notifier", booting on a platform with chained gics (e.g.
Realview EB ARM11MPCore) will result in the gic_cpu_notifier being
registered twice, corrupting the cpu notifier list and rendering the
platform unbootable.

This patch ensures that we only register the notifier for the first gic,
allowing platforms with chained gics to boot. At the same time we limit
the pointlessly duplicated calls to set_smp_cross_call and
set_handle_irq to the first gic registered.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-gic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 9031171..341c601 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -957,12 +957,13 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	if (WARN_ON(!gic->domain))
 		return;
 
+	if (gic_nr == 0) {
 #ifdef CONFIG_SMP
-	set_smp_cross_call(gic_raise_softirq);
-	register_cpu_notifier(&gic_cpu_notifier);
+		set_smp_cross_call(gic_raise_softirq);
+		register_cpu_notifier(&gic_cpu_notifier);
 #endif
-
-	set_handle_irq(gic_handle_irq);
+		set_handle_irq(gic_handle_irq);
+	}
 
 	gic_chip.flags |= gic_arch_extn.flags;
 	gic_dist_init(gic);
-- 
1.8.1.1

