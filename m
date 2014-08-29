Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaH2WR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:17:29 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:63171 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaH2WOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:48 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] MIPS: Provide a generic plat_irq_dispatch
Date: Fri, 29 Aug 2014 15:14:28 -0700
Message-Id: <1409350479-19108-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms which boot with device-tree and use the MIPS CPU interrupt
controller binding, a generic plat_irq_dispatch() can be used since all
CPU interrupts should be mapped through the CPU IRQ domain.  Implement a
plat_irq_dispatch() which simply handles the highest pending interrupt.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/kernel/irq_cpu.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index e498f2b..9cf8459 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -116,6 +116,24 @@ void __init mips_cpu_irq_init(void)
 }
 
 #ifdef CONFIG_IRQ_DOMAIN
+static struct irq_domain *mips_intc_domain;
+
+asmlinkage void __weak plat_irq_dispatch(void)
+{
+	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
+	unsigned int hw;
+	int irq;
+
+	if (!pending) {
+		spurious_interrupt();
+		return;
+	}
+
+	hw = fls(pending) - CAUSEB_IP - 1;
+	irq = irq_linear_revmap(mips_intc_domain, hw);
+	do_IRQ(irq);
+}
+
 static int mips_cpu_intc_map(struct irq_domain *d, unsigned int irq,
 			     irq_hw_number_t hw)
 {
@@ -141,15 +159,15 @@ static const struct irq_domain_ops mips_cpu_intc_irq_domain_ops = {
 int __init mips_cpu_intc_init(struct device_node *of_node,
 			      struct device_node *parent)
 {
-	struct irq_domain *domain;
-
 	/* Mask interrupts. */
 	clear_c0_status(ST0_IM);
 	clear_c0_cause(CAUSEF_IP);
 
-	domain = irq_domain_add_legacy(of_node, 8, MIPS_CPU_IRQ_BASE, 0,
-				       &mips_cpu_intc_irq_domain_ops, NULL);
-	if (!domain)
+	mips_intc_domain = irq_domain_add_legacy(of_node, 8,
+						 MIPS_CPU_IRQ_BASE, 0,
+						 &mips_cpu_intc_irq_domain_ops,
+						 NULL);
+	if (!mips_intc_domain)
 		panic("Failed to add irqdomain for MIPS CPU");
 
 	return 0;
-- 
2.1.0.rc2.206.gedb03e5

