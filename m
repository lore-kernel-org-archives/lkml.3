Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbaHZKEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:04:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21038 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934630AbaHZKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:50 -0400
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
Subject: [PATCH v2 18/26] irqchip: GICv3: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:33 +0100
Message-Id: <1409047421-27649-19-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 57eaa5a..9e31449 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -274,14 +274,13 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		irqnr = gic_read_iar();
 
 		if (likely(irqnr > 15 && irqnr < 1020)) {
-			u64 irq = irq_find_mapping(gic_data.domain, irqnr);
-			if (likely(irq)) {
-				handle_IRQ(irq, regs);
-				continue;
+			int err;
+			err = handle_domain_irq(gic_data.domain, irqnr, regs);
+			if (err) {
+				WARN_ONCE(true, "Unexpected SPI received!\n");
+				gic_write_eoir(irqnr);
 			}
-
-			WARN_ONCE(true, "Unexpected SPI received!\n");
-			gic_write_eoir(irqnr);
+			continue;
 		}
 		if (irqnr < 16) {
 			gic_write_eoir(irqnr);
-- 
2.0.4

