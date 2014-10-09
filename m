Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbaJIVRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:17:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59657 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921AbaJIVLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sudeep Holla <sudeep.holla@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 081/163] ARM: 8133/1: use irq_set_affinity with force=false when migrating irqs
Date: Thu,  9 Oct 2014 14:01:46 -0700
Message-Id: <1412888588-26755-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

commit a040803a9d6b8c1876d3487a5cb69602ebcbb82c upstream.

Since commit 1dbfa187dad ("ARM: irq migration: force migration off CPU
going down") the ARM interrupt migration code on cpu offline calls
irqchip.irq_set_affinity() with the argument force=true. At the point
of this change the argument had no effect because it was not used by
any interrupt chip driver and there was no semantics defined.

This changed with commit 01f8fa4f01d8 ("genirq: Allow forcing cpu
affinity of interrupts") which made the force argument useful to route
interrupts to not yet online cpus without checking the target cpu
against the cpu online mask. The following commit ffde1de64012
("irqchip: gic: Support forced affinity setting") implemented this for
the GIC interrupt controller.

As a consequence the ARM cpu offline irq migration fails if CPU0 is
offlined, because CPU0 is still set in the affinity mask and the
validataion against cpu online mask is skipped to the force argument
being true. The following first_cpu(mask) selection always selects
CPU0 as the target.

Solve the issue by calling irq_set_affinity() with force=false from
the CPU offline irq migration code so the GIC driver validates the
affinity mask against CPU online mask and therefore removes CPU0 from
the possible target candidates.

Tested on TC2 hotpluging CPU0 in and out. Without this patch the system
locks up as the IRQs are not migrated away from CPU0.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 9723d17..1e782bd 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -163,7 +163,7 @@ static bool migrate_one_irq(struct irq_desc *desc)
 	c = irq_data_get_irq_chip(d);
 	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
-	else if (c->irq_set_affinity(d, affinity, true) == IRQ_SET_MASK_OK && ret)
+	else if (c->irq_set_affinity(d, affinity, false) == IRQ_SET_MASK_OK && ret)
 		cpumask_copy(d->affinity, affinity);
 
 	return ret;
-- 
1.9.1

