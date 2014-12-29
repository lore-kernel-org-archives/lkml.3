Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaL2Xfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:35:44 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41061 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaL2Xc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 04/12] irqchip: nvic: increase number of external interrupts to 112
Date: Tue, 30 Dec 2014 00:32:07 +0100
Message-Id: <1419895935-22966-5-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, only vectors for up to 48 external interrupts have been
allocated in the vector table. The first 16 vectors of the vector
table are reserved for internal exceptions (Reset, SVC...). The
external interrupts start at offset 16. Hence, by increasing the
vector table to 128 vectors, we increase the amount of vectors
reserved for external interrupts to 112. Also, only register the
amount of IRQ's we have vectors available for.

Note: the vector table must align to the number of entries in the
vector table, hence increase the alignment to 0x200.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
When I started developing, I added UART0 with IRQ 61 to the device
tree. The framework happily accepted that, even though only 48
vectors for external interrupts were available. This was the
initial reason I added the WARN (in v1). However, when thinking
about it, just registering the amount of IRQ's actually supported
according to the vector table makes much more sense, since this
would warn the user on the offending IRQ's request call...

 arch/arm/kernel/entry-v7m.S | 8 ++++----
 drivers/irqchip/irq-nvic.c  | 9 +++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7m.S
index 2260f18..c38a5e5 100644
--- a/arch/arm/kernel/entry-v7m.S
+++ b/arch/arm/kernel/entry-v7m.S
@@ -115,9 +115,9 @@ ENTRY(__switch_to)
 ENDPROC(__switch_to)
 
 	.data
-	.align	8
+	.align	9
 /*
- * Vector table (64 words => 256 bytes natural alignment)
+ * Vector table (128 words => 512 bytes natural alignment)
  */
 ENTRY(vector_table)
 	.long	0			@ 0 - Reset stack pointer
@@ -136,6 +136,6 @@ ENTRY(vector_table)
 	.long	__invalid_entry		@ 13 - Reserved
 	.long	__pendsv_entry		@ 14 - PendSV
 	.long	__invalid_entry		@ 15 - SysTick
-	.rept	64 - 16
-	.long	__irq_entry		@ 16..64 - External Interrupts
+	.rept	128 - 16
+	.long	__irq_entry		@ 16..128 - External Interrupts
 	.endr
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index 5fac910..740cc55 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -38,6 +38,11 @@
  * 16 irqs.
  */
 #define NVIC_MAX_IRQ		((NVIC_MAX_BANKS - 1) * 32 + 16)
+/*
+ * Number of IRQ's supported is limited by the size of the vector table
+ * defined in entry-v7m.S
+ */
+#define NVIC_MAX_IRQ_VECTORS	(128 - 16)
 
 static struct irq_domain *nvic_irq_domain;
 
@@ -46,6 +51,8 @@ nvic_handle_irq(irq_hw_number_t hwirq, struct pt_regs *regs)
 {
 	unsigned int irq = irq_linear_revmap(nvic_irq_domain, hwirq);
 
+	BUG_ON(hwirq >= NVIC_MAX_IRQ_VECTORS);
+
 	handle_IRQ(irq, regs);
 }
 
@@ -93,6 +100,8 @@ static int __init nvic_of_init(struct device_node *node,
 	irqs = numbanks * 32;
 	if (irqs > NVIC_MAX_IRQ)
 		irqs = NVIC_MAX_IRQ;
+	if (irqs > NVIC_MAX_IRQ_VECTORS)
+		irqs = NVIC_MAX_IRQ_VECTORS;
 
 	nvic_irq_domain =
 		irq_domain_add_linear(node, irqs, &nvic_irq_domain_ops, NULL);
-- 
2.2.1

