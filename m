Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaIYL5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:57:33 -0400
Received: from gilgamesh.semihalf.com ([213.17.239.106]:22646 "EHLO
	gilgamesh.semihalf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIYL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:57:32 -0400
From: Grzegorz Jaszczyk <jaz@semihalf.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, jason@lakedaemon.net,
        ezequiel.garcia@free-electrons.com, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, alior@marvell.com,
        tawfik@marvell.com, mw@semihalf.com, jaz@semihalf.com
Subject: [PATCH 1/2] irqchip: armada-370-xp: fix MSI interrupt handling
Date: Thu, 25 Sep 2014 13:17:18 +0200
Message-Id: <1411643839-64925-2-git-send-email-jaz@semihalf.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
References: <1411643839-64925-1-git-send-email-jaz@semihalf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSI interrupts use the 16 high doorbells, which are notified by using IRQ1
of the main interrupt controller.

The MSI interrupts were handled correctly for Armada-XP and Armada-370 but not
for Armada-375 and Armada-38x, which use chained handler for the MPIC.

This commit fixes that by checking proper interrupt number in chained handler
for the MPIC.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 574aba0..91424c4 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -417,9 +417,9 @@ static void armada_370_xp_mpic_handle_cascade_irq(unsigned int irq,
 
 	irqmap = readl_relaxed(per_cpu_int_base + ARMADA_375_PPI_CAUSE);
 
-	if (irqmap & BIT(0)) {
+	if (irqmap & BIT(1)) {
 		armada_370_xp_handle_msi_irq(NULL, true);
-		irqmap &= ~BIT(0);
+		irqmap &= ~BIT(1);
 	}
 
 	for_each_set_bit(irqn, &irqmap, BITS_PER_LONG) {
-- 
1.8.3.1

