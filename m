Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbaGHN3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:29:05 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:36617 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754908AbaGHNZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:25:16 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>, Barry Song <baohua@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 05/15] irqchip: clps711x: convert to handle_domain_irq
Date: Tue,  8 Jul 2014 14:10:28 +0100
Message-Id: <1404825038-547-6-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
References: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 176.25.195.83
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tglx@linutronix.de, jason@lakedaemon.net, shc_work@mail.ru, baohua@kernel.org, maxime.ripard@free-electrons.com, khilman@linaro.org, daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, larry.bassel@linaro.org, mark.rutland@arm.com, sudeep.holla@arm.com
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
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
2.0.0

