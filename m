Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab3CGQfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:35:09 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6070 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3CGQfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:35:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Mar 2013 08:35:03 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 RESEND 2/2] regmap: irq: do not write mask register if it is not supported
Date: Thu, 7 Mar 2013 22:03:16 +0530
Message-ID: <1362673997-6762-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore the mask register write if mask_base is not provided by
regmap irq client. Also assume that all interrupts are enabled
in this case.

This is useful when device does not have explicit interrupt mask
register but control the interrupt enabling/disabling by other
mechanism like irq type/irq edge registers.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Rewrite description.
- Assume interrupt enable when there is no mask register.

- Resending in case of if it is missed.

 drivers/base/regmap/regmap-irq.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 8ca32bc..a8896ac 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -80,6 +80,9 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 	 * suppress pointless writes.
 	 */
 	for (i = 0; i < d->chip->num_regs; i++) {
+		if (!d->chip->mask_base)
+			goto skip_mask_reg_update;
+
 		reg = d->chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (d->chip->mask_invert)
@@ -92,6 +95,7 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 			dev_err(d->map->dev, "Failed to sync masks in %x\n",
 				reg);
 
+skip_mask_reg_update:
 		reg = d->chip->wake_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (d->wake_buf) {
@@ -491,7 +495,17 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
-		d->mask_buf[i] = d->mask_buf_def[i];
+		/**
+		 * If no mask base register then assuming all interrupt are
+		 * unmasked.
+		 */
+		if (!chip->mask_base) {
+			d->mask_buf[i] = ~d->mask_buf_def[i];
+			continue;
+		} else {
+			d->mask_buf[i] = d->mask_buf_def[i];
+		}
+
 		reg = chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (chip->mask_invert)
-- 
1.7.1.1

