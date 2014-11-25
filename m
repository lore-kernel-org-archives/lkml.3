Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaKYMGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:06:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKYKkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grzegorz Jaszczyk <jaz@semihalf.com>, Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 010/254] irqchip: armada-370-xp: Fix MSI interrupt handling
Date: Tue, 25 Nov 2014 10:36:00 +0000
Message-Id: <1416912004-5928-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Jaszczyk <jaz@semihalf.com>

commit 298dcb2dd0267d51e4f7c94a628cd0765a50ad75 upstream.

The MSI interrupts use the 16 high doorbells, which are notified by using IRQ1
of the main interrupt controller.

The MSI interrupts were handled correctly for Armada-XP and Armada-370 but not
for Armada-375 and Armada-38x, which use chained handler for the MPIC.

This commit fixes that by checking proper interrupt number in chained handler
for the MPIC.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Fixes: bc69b8adfe22 ("irqchip: armada-370-xp: Setup a chained handler for the MPIC")
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Link: https://lkml.kernel.org/r/1411643839-64925-2-git-send-email-jaz@semihalf.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 574aba0eba4e..91424c481782 100644
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
2.1.0

