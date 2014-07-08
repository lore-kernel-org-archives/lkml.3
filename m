Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaGHNpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:45:52 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:41119 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbaGHNpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:45:49 -0400
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
Subject: [PATCH v2 04/15] irqchip: armada-370-xp: convert to handle_domain_irq
Date: Tue,  8 Jul 2014 14:45:41 +0100
Message-Id: <1404827141-30381-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404827141-30381-1-git-send-email-marc.zyngier@arm.com>
References: <1404827141-30381-1-git-send-email-marc.zyngier@arm.com>
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
Sending the right patch this time...

 drivers/irqchip/irq-armada-370-xp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 574aba0..fa75a29 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -393,13 +393,15 @@ static void armada_370_xp_handle_msi_irq(struct pt_regs *regs, bool is_chained)
 		if (!(msimask & BIT(msinr)))
 			continue;
 
-		irq = irq_find_mapping(armada_370_xp_msi_domain,
-				       msinr - 16);
-
-		if (is_chained)
+		if (is_chained) {
+			irq = irq_find_mapping(armada_370_xp_msi_domain,
+					       msinr - 16);
 			generic_handle_irq(irq);
-		else
-			handle_IRQ(irq, regs);
+		} else {
+			irq = msinr - 16;
+			handle_domain_irq(armada_370_xp_msi_domain,
+					  irq, regs);
+		}
 	}
 }
 #else
@@ -444,9 +446,8 @@ armada_370_xp_handle_irq(struct pt_regs *regs)
 			break;
 
 		if (irqnr > 1) {
-			irqnr =	irq_find_mapping(armada_370_xp_mpic_domain,
-					irqnr);
-			handle_IRQ(irqnr, regs);
+			handle_domain_irq(armada_370_xp_mpic_domain,
+					  irqnr, regs);
 			continue;
 		}
 
-- 
2.0.0

