Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbaJXL7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:59:50 -0400
Received: from down.free-electrons.com ([37.187.137.238]:38823 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932421AbaJXL7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:59:46 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] irqchip: irq-armada-370-xp: suspend/resume support
Date: Fri, 24 Oct 2014 13:59:17 +0200
Message-Id: <1414151970-6626-5-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1414151970-6626-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1414151970-6626-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds suspend/resume support to the irqchip driver used on
Armada XP platforms (amongst others). It does so by adding a set of
suspend/resume syscore_ops, that will respectively save and restore
the necessary registers to ensure interrupts continue to work after
resume.

It is worth mentioning that the affinity is lost during a
suspend/resume cycle, because when a secondary CPU is brought
off-line, all interrupts that are assigned to this CPU in terms of
affinity gets re-assigned to a still running CPU. Therefore, right
before entering suspend, all interrupts are assigned to the boot CPU.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org
---
 drivers/irqchip/irq-armada-370-xp.c | 52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 9e630f2..3c2b89d 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -26,6 +26,7 @@
 #include <linux/of_pci.h>
 #include <linux/irqdomain.h>
 #include <linux/slab.h>
+#include <linux/syscore_ops.h>
 #include <linux/msi.h>
 #include <asm/mach/arch.h>
 #include <asm/exception.h>
@@ -66,6 +67,7 @@
 static void __iomem *per_cpu_int_base;
 static void __iomem *main_int_base;
 static struct irq_domain *armada_370_xp_mpic_domain;
+static u32 doorbell_mask_reg;
 #ifdef CONFIG_PCI_MSI
 static struct irq_domain *armada_370_xp_msi_domain;
 static DECLARE_BITMAP(msi_used, PCI_MSI_DOORBELL_NR);
@@ -474,6 +476,54 @@ armada_370_xp_handle_irq(struct pt_regs *regs)
 	} while (1);
 }
 
+static int armada_370_xp_mpic_suspend(void)
+{
+	doorbell_mask_reg = readl(per_cpu_int_base +
+				  ARMADA_370_XP_IN_DRBEL_MSK_OFFS);
+	return 0;
+}
+
+static void armada_370_xp_mpic_resume(void)
+{
+	int nirqs;
+	irq_hw_number_t irq;
+
+	/* Re-enable interrupts */
+	nirqs = (readl(main_int_base + ARMADA_370_XP_INT_CONTROL) >> 2) & 0x3ff;
+	for (irq = 0; irq < nirqs; irq++) {
+		struct irq_data *data;
+		int virq;
+
+		virq = irq_linear_revmap(armada_370_xp_mpic_domain, irq);
+		if (virq == 0)
+			continue;
+
+		if (irq != ARMADA_370_XP_TIMER0_PER_CPU_IRQ)
+			writel(irq, per_cpu_int_base +
+			       ARMADA_370_XP_INT_CLEAR_MASK_OFFS);
+		else
+			writel(irq, main_int_base +
+			       ARMADA_370_XP_INT_SET_ENABLE_OFFS);
+
+		data = irq_get_irq_data(virq);
+		if (!irqd_irq_disabled(data))
+			armada_370_xp_irq_unmask(data);
+	}
+
+	/* Reconfigure doorbells for IPIs and MSIs */
+	writel(doorbell_mask_reg,
+	       per_cpu_int_base + ARMADA_370_XP_IN_DRBEL_MSK_OFFS);
+	if (doorbell_mask_reg & IPI_DOORBELL_MASK)
+		writel(0, per_cpu_int_base + ARMADA_370_XP_INT_CLEAR_MASK_OFFS);
+	if (doorbell_mask_reg & PCI_MSI_DOORBELL_MASK)
+		writel(1, per_cpu_int_base + ARMADA_370_XP_INT_CLEAR_MASK_OFFS);
+}
+
+struct syscore_ops armada_370_xp_mpic_syscore_ops = {
+	.suspend	= armada_370_xp_mpic_suspend,
+	.resume		= armada_370_xp_mpic_resume,
+};
+
 static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 					     struct device_node *parent)
 {
@@ -530,6 +580,8 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 					armada_370_xp_mpic_handle_cascade_irq);
 	}
 
+	register_syscore_ops(&armada_370_xp_mpic_syscore_ops);
+
 	return 0;
 }
 
-- 
2.0.0

