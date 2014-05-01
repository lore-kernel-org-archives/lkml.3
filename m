Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaEAXVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:21:14 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaEAXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:18:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/8] irq: Use irq_alloc_desc_at instead of irq_reserve_irq
Date: Thu,  1 May 2014 16:18:17 -0700
Message-Id: <1398986302-30455-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
References: <1398986302-30455-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_reserve_irq actually only set bit allocated_irq, and it is not really
"reserve" and cause confusion.

For !CONFIG_SPARSE_IRQ path, irq_alloc_desc_at() will only set bit
in allocated_irq.

We can use that instead, kill one irq_reserve_irq() calling.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/irq/chip.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6397df2..aff7481 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -28,8 +28,13 @@
 int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
+	struct irq_desc *desc;
+
+#ifndef CONFIG_SPARSE_IRQ
+	irq_alloc_desc_at(irq, 0);
+#endif
 
+	desc = irq_get_desc_lock(irq, &flags, 0);
 	if (!desc)
 		return -EINVAL;
 
@@ -38,12 +43,7 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 
 	desc->irq_data.chip = chip;
 	irq_put_desc_unlock(desc, flags);
-	/*
-	 * For !CONFIG_SPARSE_IRQ make the irq show up in
-	 * allocated_irqs. For the CONFIG_SPARSE_IRQ case, it is
-	 * already marked, and this call is harmless.
-	 */
-	irq_reserve_irq(irq);
+
 	return 0;
 }
 EXPORT_SYMBOL(irq_set_chip);
-- 
1.8.4.5

