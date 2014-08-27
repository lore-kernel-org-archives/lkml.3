Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935713AbaH0SjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:39:25 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35280 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935700AbaH0SjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:39:21 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, jason@lakedaemon.net,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3] genirq: warn on inconstent flags and flow handler
Date: Wed, 27 Aug 2014 11:38:45 -0700
Message-Id: <1409164725-25901-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is currently possible for a generic irq chip driver to set IRQ_LEVEL
and have its irq flow handler be handle_edge_irq. Setting IRQ_LEVEL in
such a case does not make sense, and will actually prevent e.g: the
software resend logic from kicking, and potential other problems too.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
- replaced BUG_ON() with WARN_ON(), essentially making it similar to v1

Changes in v2:
- replaced WARN_ON() with BUG_ON()

 kernel/irq/chip.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a2b28a2fd7b1..939ae1283ec9 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -749,8 +749,13 @@ void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set)
 		irqd_set(&desc->irq_data, IRQD_PER_CPU);
 	if (irq_settings_can_move_pcntxt(desc))
 		irqd_set(&desc->irq_data, IRQD_MOVE_PCNTXT);
-	if (irq_settings_is_level(desc))
+	if (irq_settings_is_level(desc)) {
+		/* Setting IRQD_LEVEL does not make sense on non-level
+		 * sensitive interrupts
+		 */
+		WARN_ON(desc->handle_irq != handle_level_irq);
 		irqd_set(&desc->irq_data, IRQD_LEVEL);
+	}
 
 	irqd_set(&desc->irq_data, irq_settings_get_trigger_mask(desc));
 
-- 
1.9.1

