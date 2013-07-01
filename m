Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3GAQFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:05:09 -0400
Received: from multi.imgtec.com ([194.200.65.239]:10444 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab3GAQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:05:07 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 5/5] metag: cpu hotplug: route_irq: preserve irq mask
Date: Mon, 1 Jul 2013 17:04:19 +0100
Message-ID: <1372694659-30176-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_01_17_05_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The route_irq() function needs to preserve the irq mask by using the
_irqsave/irqrestore variants of raw spin lock functions instead of the
_irq variants. This is because it is called from __cpu_disable() (via
migrate_irqs()), which is called with IRQs disabled, so using the _irq
variants re-enables IRQs.

This appears to have been causing occasional hits of the
BUG_ON(!irqs_disabled()) in __irq_work_run() during CPU hotplug soak
testing:
  BUG: failure at kernel/irq_work.c:122/__irq_work_run()!

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/irq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/metag/kernel/irq.c b/arch/metag/kernel/irq.c
index d91b1e9..2a2c9d5 100644
--- a/arch/metag/kernel/irq.c
+++ b/arch/metag/kernel/irq.c
@@ -279,11 +279,12 @@ static void route_irq(struct irq_data *data, unsigned int irq, unsigned int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
+	unsigned long flags;
 
-	raw_spin_lock_irq(&desc->lock);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (chip->irq_set_affinity)
 		chip->irq_set_affinity(data, cpumask_of(cpu), false);
-	raw_spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 /*
-- 
1.8.1.2


