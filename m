Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbaJCWtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:49:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbaJCWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.10 065/143] ARM: 8133/1: use irq_set_affinity with force=false when migrating irqs
Date: Fri,  3 Oct 2014 14:34:20 -0700
Message-Id: <20141003213316.470126049@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -163,7 +163,7 @@ static bool migrate_one_irq(struct irq_d
 	c = irq_data_get_irq_chip(d);
 	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
-	else if (c->irq_set_affinity(d, affinity, true) == IRQ_SET_MASK_OK && ret)
+	else if (c->irq_set_affinity(d, affinity, false) == IRQ_SET_MASK_OK && ret)
 		cpumask_copy(d->affinity, affinity);
 
 	return ret;


