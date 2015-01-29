Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbbA2LSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:18:11 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:64231 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbbA2LOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:14:34 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3/9] irqchip: mips-gic: Don't treat FDC IRQ as percpu devid
Date: Thu, 29 Jan 2015 11:14:08 +0000
Message-ID: <1422530054-7976-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
References: <1422530054-7976-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Treat the Fast Debug Channel (FDC) interrupt the same as the timer and
performance counter interrupts. Like them, the FDC IRQ is also per-VPE,
and also doesn't use a per-CPU device ID yet. Per-CPU device IDs don't
seem to work with IRQF_SHARED which is needed for compatibility with
cores which don't route the FDC IRQ through the GIC. For hardware which
routes FDC IRQs through the GIC this is something that could be added
later.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Bresticker <abrestic@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-mips@linux-mips.org
---
 drivers/irqchip/irq-mips-gic.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 1f12eaedc9d9..bcfead6e8ae6 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -591,15 +591,20 @@ static int gic_local_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	 * of the MIPS kernel code does not use the percpu IRQ API for
 	 * the CP0 timer and performance counter interrupts.
 	 */
-	if (intr != GIC_LOCAL_INT_TIMER && intr != GIC_LOCAL_INT_PERFCTR) {
+	switch (intr) {
+	case GIC_LOCAL_INT_TIMER:
+	case GIC_LOCAL_INT_PERFCTR:
+	case GIC_LOCAL_INT_FDC:
+		irq_set_chip_and_handler(virq,
+					 &gic_all_vpes_local_irq_controller,
+					 handle_percpu_irq);
+		break;
+	default:
 		irq_set_chip_and_handler(virq,
 					 &gic_local_irq_controller,
 					 handle_percpu_devid_irq);
 		irq_set_percpu_devid(virq);
-	} else {
-		irq_set_chip_and_handler(virq,
-					 &gic_all_vpes_local_irq_controller,
-					 handle_percpu_irq);
+		break;
 	}
 
 	spin_lock_irqsave(&gic_lock, flags);
-- 
2.0.5

