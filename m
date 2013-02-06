Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3BFVbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:31:39 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46318 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758237Ab3BFVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:31:38 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: ab8500: actually handle the AB8500 GPIO IRQs correctly
Date: Wed, 6 Feb 2013 22:31:20 +0100
Message-ID: <1360186280-6883-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch:
"mfd: ab8500: prepare to handle AB8500 GPIO's IRQs correctly"
altered the AB8500 IRQ mask/unmask functions such that they
would handle masking on/off the falling edge IRQ if this was
requested by the consumer. However the bit mask for hwirqs
43 and 44 was shifting the bit mask incorrectly, resulting in
the wrong IRQ being mased/unmasked.

Further while the patch would mask/unmask the correct line,
when the interrupt actually came in, it would still be treated
as a valid hwirq. The offsetting applied when masking/unmasking
was not applied when handling the IRQ, i.e. the falling edge
lines were not routed back to the rising edge lines.

This fixes both cases. The end result has been tested with
the SIM detect IRQ, GPIO12, hwirq 46 and 62.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Sam, requesting an ACK for this as well. It goes on top of
the previous series for the AB8500 GPIO IRQ business from
Lee Jones, basically it repairs one of the patches in that
series.
---
 drivers/mfd/ab8500-core.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index a0a3f72..f67106a 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -374,7 +374,8 @@ static void ab8500_irq_mask(struct irq_data *data)
 	if (offset >= AB9540_INT_GPIO50R && offset <= AB9540_INT_GPIO54R)
 		ab8500->mask[index + 1] |= mask;
 	if (offset == AB8540_INT_GPIO43R || offset == AB8540_INT_GPIO44R)
-		ab8500->mask[index] |= (mask >> 1);
+		/* Here the falling IRQ is one bit lower */
+		ab8500->mask[index] |= (mask << 1);
 }
 
 static void ab8500_irq_unmask(struct irq_data *data)
@@ -390,17 +391,20 @@ static void ab8500_irq_unmask(struct irq_data *data)
 
 	/* The AB8500 GPIOs have two interrupts each (rising & falling). */
 	if (type & IRQ_TYPE_EDGE_FALLING) {
+		pr_info("AB8500 IRQ: unmask falling IRQ %d, index %d, mask %08x\n", offset, index, mask);
 		if (offset >= AB8500_INT_GPIO6R && offset <= AB8500_INT_GPIO41R)
 			ab8500->mask[index + 2] &= ~mask;
 		else if (offset >= AB9540_INT_GPIO50R && offset <= AB9540_INT_GPIO54R)
 			ab8500->mask[index + 1] &= ~mask;
 		else if (offset == AB8540_INT_GPIO43R || offset == AB8540_INT_GPIO44R)
-			ab8500->mask[index] &= ~(mask >> 1);
+			/* Here the falling IRQ is one bit lower */
+			ab8500->mask[index] &= ~(mask << 1);
 		else
 			ab8500->mask[index] &= ~mask;
-	} else
+	} else {
 		/* Satisfies the case where type is not set. */
 		ab8500->mask[index] &= ~mask;
+	}
 }
 
 static int ab8500_irq_set_type(struct irq_data *data, unsigned int type)
@@ -440,6 +444,19 @@ static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
 		line = (i << 3) + int_bit;
 		latch_val &= ~(1 << int_bit);
 
+		/*
+		 * This handles the falling edge hwirqs from the GPIO
+		 * lines. Route them back to the line registered for the
+		 * rising IRQ, as this is merely a flag for the same IRQ
+		 * in linux terms.
+		 */
+		if (line >= AB8500_INT_GPIO6F && line <= AB8500_INT_GPIO41F)
+			line -= 16;
+		if (line >= AB9540_INT_GPIO50F && line <= AB9540_INT_GPIO54F)
+			line -= 8;
+		if (line == AB8540_INT_GPIO43F || line == AB8540_INT_GPIO44F)
+			line += 1;
+
 		handle_nested_irq(ab8500->irq_base + line);
 	} while (latch_val);
 
-- 
1.7.11.3

