Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161931Ab3BOM6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:41 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62385 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161908Ab3BOM6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Dariusz Szymczak <dariusz.xd.szymczak@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 35/35] mfd: ab8500-core: Hierarchical interrupt registers
Date: Fri, 15 Feb 2013 12:57:06 +0000
Message-Id: <1360933026-30325-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dariusz Szymczak <dariusz.xd.szymczak@stericsson.com>

Make use of the hierarchical interrupt rergister called
ITLatchHier1 - 3 also for the 8500 platform (currently the
hierarchical interrupt registers are used only for the 8540
and 9540 platforms). This will make the interrupt routing
go faster since fewer i2c reads need to made in the most
common cases.

Signed-off-by: Dariusz Szymczak <dariusz.xd.szymczak@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
---
 drivers/mfd/ab8500-core.c |   82 ++++-----------------------------------------
 1 file changed, 6 insertions(+), 76 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 2716c6c..fd87e0a 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -502,66 +502,6 @@ static irqreturn_t ab8500_hierarchical_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-/**
- * ab8500_irq_get_virq(): Map an interrupt on a chip to a virtual IRQ
- *
- * @ab8500: ab8500_irq controller to operate on.
- * @irq: index of the interrupt requested in the chip IRQs
- *
- * Useful for drivers to request their own IRQs.
- */
-static int ab8500_irq_get_virq(struct ab8500 *ab8500, int irq)
-{
-	if (!ab8500)
-		return -EINVAL;
-
-	return irq_create_mapping(ab8500->domain, irq);
-}
-
-static irqreturn_t ab8500_irq(int irq, void *dev)
-{
-	struct ab8500 *ab8500 = dev;
-	int i;
-
-	dev_vdbg(ab8500->dev, "interrupt\n");
-
-	atomic_inc(&ab8500->transfer_ongoing);
-
-	for (i = 0; i < ab8500->mask_size; i++) {
-		int regoffset = ab8500->irq_reg_offset[i];
-		int status;
-		u8 value;
-
-		/*
-		 * Interrupt register 12 doesn't exist prior to AB8500 version
-		 * 2.0
-		 */
-		if (regoffset == 11 && is_ab8500_1p1_or_earlier(ab8500))
-			continue;
-
-		if (regoffset < 0)
-			continue;
-
-		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
-			AB8500_IT_LATCH1_REG + regoffset, &value);
-		if (status < 0 || value == 0)
-			continue;
-
-		do {
-			int bit = __ffs(value);
-			int line = i * 8 + bit;
-			int virq = ab8500_irq_get_virq(ab8500, line);
-
-			handle_nested_irq(virq);
-			ab8500_debug_register_interrupt(line);
-			value &= ~(1 << bit);
-
-		} while (value);
-	}
-	atomic_dec(&ab8500->transfer_ongoing);
-	return IRQ_HANDLED;
-}
-
 static int ab8500_irq_map(struct irq_domain *d, unsigned int virq,
 				irq_hw_number_t hwirq)
 {
@@ -1697,22 +1637,12 @@ static int ab8500_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	/*  Activate this feature only in ab9540 */
-	/*  till tests are done on ab8500 1p2 or later*/
-	if (is_ab9540(ab8500) || is_ab8540(ab8500))
-		ret = devm_request_threaded_irq(&pdev->dev, ab8500->irq, NULL,
-						ab8500_hierarchical_irq,
-						IRQF_ONESHOT | IRQF_NO_SUSPEND,
-						"ab8500", ab8500);
-	}
-	else {
-		ret = devm_request_threaded_irq(&pdev->dev, ab8500->irq, NULL,
-						ab8500_irq,
-						IRQF_ONESHOT | IRQF_NO_SUSPEND,
-						"ab8500", ab8500);
-		if (ret)
-			return ret;
-	}
+	ret = devm_request_threaded_irq(&pdev->dev, ab8500->irq, NULL,
+			ab8500_hierarchical_irq,
+			IRQF_ONESHOT | IRQF_NO_SUSPEND,
+			"ab8500", ab8500);
+	if (ret)
+		return ret;
 
 	if (is_ab9540(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
-- 
1.7.10.4

