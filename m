Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab3GVLLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:11:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55923 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3GVLLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:11:47 -0400
Message-ID: <1374491474.4355.12.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH] regmap: irq: Acknowledge also interrupts that are masked
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 13:11:14 +0200
In-Reply-To: <20130722100856.GQ9858@sirena.org.uk>
References: <1374485092-13211-1-git-send-email-p.zabel@pengutronix.de>
	 <20130722100856.GQ9858@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Montag, den 22.07.2013, 11:08 +0100 schrieb Mark Brown:
> On Mon, Jul 22, 2013 at 11:24:52AM +0200, Philipp Zabel wrote:
> > In case the hardware interrupt mask register does not prevent the chip level
> > irq from being asserted by the corresponding interrupt status bit, stray
> > masked interrupts should to be acknowledged, too.
> 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > I have seen GPI interrupts trigger on DA9063 trigger after being masked during
> > initialization, and once the status bits are set, the interrupt handler routine
> > never clears them, which keeps the chip irq line asserted forever.
> 
> This can't be the standard behaviour since it breaks expectations as to
> what happens for masked interrupts.  Though based on your description of
> the problem it sounds like a quirk to ack interrupts immediately after
> masking them might do the trick instead of the full on always ack
> behaviour.

thanks, this seems to work, too:

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 1643e88..4c99ed8 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -418,6 +418,24 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 				reg, ret);
 			goto err_alloc;
 		}
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
+		reg = chip->ack_base +
+			(i * map->reg_stride * d->irq_reg_stride);
+		ret = regmap_write(map, reg, d->status_buf[i] & d->mask_buf[i]);
+		if (ret != 0) {
+			dev_err(map->dev, "Failed to ack 0x%x: %d\n", reg, ret);
+			goto err_alloc;
+		}
 	}
 
 	/* Wake is disabled by default */
-- 
1.8.3.2

Can something like this be done unconditionally, or should I add a quirk
flag to regmap_irq_chip?

regards
Philipp

