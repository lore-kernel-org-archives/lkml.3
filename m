Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbaJDAoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:44:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaJCVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.16 041/357] arm64: use irq_set_affinity with force=false when migrating irqs
Date: Fri,  3 Oct 2014 14:27:07 -0700
Message-Id: <20141003212934.696855626@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/irq.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -97,19 +97,15 @@ static bool migrate_one_irq(struct irq_d
 	if (irqd_is_per_cpu(d) || !cpumask_test_cpu(smp_processor_id(), affinity))
 		return false;
 
-	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids)
+	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
+		affinity = cpu_online_mask;
 		ret = true;
+	}
 
-	/*
-	 * when using forced irq_set_affinity we must ensure that the cpu
-	 * being offlined is not present in the affinity mask, it may be
-	 * selected as the target CPU otherwise
-	 */
-	affinity = cpu_online_mask;
 	c = irq_data_get_irq_chip(d);
 	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
-	else if (c->irq_set_affinity(d, affinity, true) == IRQ_SET_MASK_OK && ret)
+	else if (c->irq_set_affinity(d, affinity, false) == IRQ_SET_MASK_OK && ret)
 		cpumask_copy(d->affinity, affinity);
 
 	return ret;


