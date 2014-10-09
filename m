Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbaJIVHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:07:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59103 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaJIVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:07:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 025/163] arm64: use irq_set_affinity with force=false when migrating irqs
Date: Thu,  9 Oct 2014 14:00:50 -0700
Message-Id: <1412888588-26755-26-git-send-email-kamal@canonical.com>
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

commit 3d8afe3099ebc602848aa7f09235cce3a9a023ce upstream.

The arm64 interrupt migration code on cpu offline calls
irqchip.irq_set_affinity() with the argument force=true. Originally
this argument had no effect because it was not used by any interrupt
chip driver and there was no semantics defined.

This changed with commit 01f8fa4f01d8 ("genirq: Allow forcing cpu
affinity of interrupts") which made the force argument useful to route
interrupts to not yet online cpus without checking the target cpu
against the cpu online mask. The following commit ffde1de64012
("irqchip: gic: Support forced affinity setting") implemented this for
the GIC interrupt controller.

As a consequence the cpu offline irq migration fails if CPU0 is
offlined, because CPU0 is still set in the affinity mask and the
validation against cpu online mask is skipped to the force argument
being true. The following first_cpu(mask) selection always selects
CPU0 as the target.

Commit 601c942176d8("arm64: use cpu_online_mask when using forced
irq_set_affinity") intended to fix the above mentioned issue but
introduced another issue where affinity can be migrated to a wrong
CPU due to unconditional copy of cpu_online_mask.

As with for arm, solve the issue by calling irq_set_affinity() with
force=false from the CPU offline irq migration code so the GIC driver
validates the affinity mask against CPU online mask and therefore
removes CPU0 from the possible target candidates. Also revert the
changes done in the commit 601c942176d8 as it's no longer needed.

Tested on Juno platform.

Fixes: 601c942176d8("arm64: use cpu_online_mask when using forced
	irq_set_affinity")
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ kamal: backport to 3.13-stable: only need the irq_set_affinity(false) fix ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 473e5db..dfa6e3e 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -105,7 +105,7 @@ static bool migrate_one_irq(struct irq_desc *desc)
 	c = irq_data_get_irq_chip(d);
 	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
-	else if (c->irq_set_affinity(d, affinity, true) == IRQ_SET_MASK_OK && ret)
+	else if (c->irq_set_affinity(d, affinity, false) == IRQ_SET_MASK_OK && ret)
 		cpumask_copy(d->affinity, affinity);
 
 	return ret;
-- 
1.9.1

