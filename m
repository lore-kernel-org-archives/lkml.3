Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab3BMNPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:15:20 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8657 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab3BMNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:15:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 13 Feb 2013 05:15:14 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regmap: irq: do not write mask register if it is not supported
Date: Wed, 13 Feb 2013 18:44:50 +0530
Message-ID: <1360761290-15976-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore the mask register write if mask_base is not provided by
regmap irq client. This is useful when regmap irq framework is
used for the MFD's gpio interrupt support. Typically, gpio has
two registers related to interrupt, one is for setting interrupt
edge type like rising and falling which indirectly work as mask
interrupt register and second as interrupt status register. In
this case mask_base is set as 0.

Now when interrupt enabled/disabled, the mask_buf get set/reset as
it keeps the interrupt enable/disable state but need not to be write
into register. When interrupt occurs, it is masked with interrupt mask
to check interrupt is valid or not and accordingly the isr handler
get called.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/base/regmap/regmap-irq.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index e7a1a26..dbdd407 100644
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
@@ -470,6 +474,9 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
 		d->mask_buf[i] = d->mask_buf_def[i];
+		if (!chip->mask_base)
+			continue;
+
 		reg = chip->mask_base +
 			(i * map->reg_stride * d->irq_reg_stride);
 		if (chip->mask_invert)
-- 
1.7.1.1

