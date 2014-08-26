Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbaHZKLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:11:42 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20712 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934495AbaHZKEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:11 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net
Cc: linux@arm.linux.org.uk, shawn.guo@freescale.com, kernel@pengutronix.de,
        tony@atomide.com, catalin.marinas@arm.com, will.deacon@arm.com,
        jonas@southpole.se, tglx@linutronix.de, jason@lakedaemon.net,
        shc_work@mail.ru, baohua@kernel.org, maxime.ripard@free-electrons.com,
        marc.zyngier@arm.com, khilman@linaro.org, sboyd@codeaurora.org,
        lorenzo.pieralisi@arm.com, larry.bassel@linaro.org,
        mark.rutland@arm.com, sudeep.holla@arm.com,
        stefan.kristiansson@saunalahti.fi, vkale@apm.com,
        schwidefsky@de.ibm.com
Subject: [PATCH v2 07/26] irqchip: clps711x: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:22 +0100
Message-Id: <1409047421-27649-8-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-clps711x.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-clps711x.c b/drivers/irqchip/irq-clps711x.c
index 33340dc..33127f1 100644
--- a/drivers/irqchip/irq-clps711x.c
+++ b/drivers/irqchip/irq-clps711x.c
@@ -76,24 +76,20 @@ static struct {
 
 static asmlinkage void __exception_irq_entry clps711x_irqh(struct pt_regs *regs)
 {
-	u32 irqnr, irqstat;
+	u32 irqstat;
 
 	do {
 		irqstat = readw_relaxed(clps711x_intc->intmr[0]) &
 			  readw_relaxed(clps711x_intc->intsr[0]);
-		if (irqstat) {
-			irqnr =	irq_find_mapping(clps711x_intc->domain,
-						 fls(irqstat) - 1);
-			handle_IRQ(irqnr, regs);
-		}
+		if (irqstat)
+			handle_domain_irq(clps711x_intc->domain,
+					  fls(irqstat) - 1, regs);
 
 		irqstat = readw_relaxed(clps711x_intc->intmr[1]) &
 			  readw_relaxed(clps711x_intc->intsr[1]);
-		if (irqstat) {
-			irqnr =	irq_find_mapping(clps711x_intc->domain,
-						 fls(irqstat) - 1 + 16);
-			handle_IRQ(irqnr, regs);
-		}
+		if (irqstat)
+			handle_domain_irq(clps711x_intc->domain,
+					  fls(irqstat) - 1 + 16, regs);
 	} while (irqstat);
 }
 
-- 
2.0.4

