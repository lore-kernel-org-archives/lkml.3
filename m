Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbaLCAQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:16:34 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33474 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456AbaLCAMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:25 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 05/12] irqchip: nvic: increase number of external interrupts to 112
Date: Wed,  3 Dec 2014 01:12:04 +0100
Message-Id: <1417565531-4507-6-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far only vectors for up to 48 external interrupts have been
registred in the vector table. Increase the amount of registred
external vectors to 112. Also, add a warning in case NVIC reports
support for more interrupts than 128.

Note: the vector table must align to the number of entires in the
vector table, hence increase the alignment to 0x200.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/kernel/entry-v7m.S | 6 +++---
 drivers/irqchip/irq-nvic.c  | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7m.S
index 2260f18..754a1fa 100644
--- a/arch/arm/kernel/entry-v7m.S
+++ b/arch/arm/kernel/entry-v7m.S
@@ -115,7 +115,7 @@ ENTRY(__switch_to)
 ENDPROC(__switch_to)
 
 	.data
-	.align	8
+	.align	9
 /*
  * Vector table (64 words => 256 bytes natural alignment)
  */
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
index dbfb5be..40f62a9 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -137,6 +137,8 @@ static int __init nvic_of_init(struct device_node *node,
 	if (irqs > NVIC_MAX_IRQ)
 		irqs = NVIC_MAX_IRQ;
 
+	WARN(irqs > 128, "vector table in entry-v7m.S configured for 128 irqs");
+
 	nvic_irq_domain =
 		irq_domain_add_linear(node, irqs, &nvic_irq_domain_ops, NULL);
 	if (!nvic_irq_domain) {
-- 
2.1.3

