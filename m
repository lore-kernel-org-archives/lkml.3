Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3GVJY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:24:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55099 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3GVJY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:24:57 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] regmap: irq: Acknowledge also interrupts that are masked
Date: Mon, 22 Jul 2013 11:24:52 +0200
Message-Id: <1374485092-13211-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the hardware interrupt mask register does not prevent the chip level
irq from being asserted by the corresponding interrupt status bit, stray
masked interrupts should to be acknowledged, too.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
I have seen GPI interrupts trigger on DA9063 trigger after being masked during
initialization, and once the status bits are set, the interrupt handler routine
never clears them, which keeps the chip irq line asserted forever.
---
 drivers/base/regmap/regmap-irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 1643e88..0bdf43f 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -253,8 +253,6 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	 * doing a write per register.
 	 */
 	for (i = 0; i < data->chip->num_regs; i++) {
-		data->status_buf[i] &= ~data->mask_buf[i];
-
 		if (data->status_buf[i] && chip->ack_base) {
 			reg = chip->ack_base +
 				(i * map->reg_stride * data->irq_reg_stride);
@@ -263,6 +261,8 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
 					reg, ret);
 		}
+
+		data->status_buf[i] &= ~data->mask_buf[i];
 	}
 
 	for (i = 0; i < chip->num_irqs; i++) {
-- 
1.8.3.2

