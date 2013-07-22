Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3GVPP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:15:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34277 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3GVPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:15:57 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] regmap: irq: Allow to acknowledge masked interrupts during initialization
Date: Mon, 22 Jul 2013 17:15:52 +0200
Message-Id: <1374506153-10092-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the hardware interrupt mask register does not prevent the chip level
irq from being asserted by the corresponding interrupt status bit, already
set interrupt bits should to be cleared once after masking them during
initialization. Add a flag to let drivers enable this behavior.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/base/regmap/regmap-irq.c | 25 +++++++++++++++++++++++++
 include/linux/regmap.h           |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 1643e88..d10456f 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -418,6 +418,31 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 				reg, ret);
 			goto err_alloc;
 		}
+
+		if (!chip->init_ack_masked)
+			continue;
+
+		/* Ack masked but set interrupts */
+		reg = chip->status_base +
+			(i * map->reg_stride * d->irq_reg_stride);
+		ret = regmap_read(map, reg, &d->status_buf[i]);
+		if (ret != 0) {
+			dev_err(map->dev, "Failed to read IRQ status: %d\n",
+				ret);
+			goto err_alloc;
+		}
+
+		if (d->status_buf[i] && chip->ack_base) {
+			reg = chip->ack_base +
+				(i * map->reg_stride * d->irq_reg_stride);
+			ret = regmap_write(map, reg,
+					d->status_buf[i] & d->mask_buf[i]);
+			if (ret != 0) {
+				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
+					reg, ret);
+				goto err_alloc;
+			}
+		}
 	}
 
 	/* Wake is disabled by default */
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 75981d0..34ebe77 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -470,6 +470,7 @@ struct regmap_irq {
  * @ack_base:    Base ack address.  If zero then the chip is clear on read.
  * @wake_base:   Base address for wake enables.  If zero unsupported.
  * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
+ * @init_ack_masked: Ack all masked interrupts once during initalization.
  * @runtime_pm:  Hold a runtime PM lock on the device when accessing it.
  *
  * @num_regs:    Number of registers in each control bank.
@@ -485,6 +486,7 @@ struct regmap_irq_chip {
 	unsigned int ack_base;
 	unsigned int wake_base;
 	unsigned int irq_reg_stride;
+	bool init_ack_masked;
 	unsigned int mask_invert;
 	unsigned int wake_invert;
 	bool runtime_pm;
-- 
1.8.3.2

