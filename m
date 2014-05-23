Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaEWKcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:39 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43837 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaEWKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:29 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 42/71] clocksource: sh_mtu2: Add memory base to sh_mtu2_channel structure
Date: Fri, 23 May 2014 12:31:22 +0200
Message-Id: <1400841111-6683-42-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The channel memory base is channel-specific, add it to the channel
structure in preparation for support of multiple channels per device.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 2fe3ab4c..97714ce 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -38,7 +38,10 @@ struct sh_mtu2_device;
 
 struct sh_mtu2_channel {
 	struct sh_mtu2_device *mtu;
+
+	void __iomem *base;
 	int irq;
+
 	struct clock_event_device ced;
 };
 
@@ -74,39 +77,35 @@ static unsigned long mtu2_reg_offs[] = {
 
 static inline unsigned long sh_mtu2_read(struct sh_mtu2_channel *ch, int reg_nr)
 {
-	struct sh_timer_config *cfg = ch->mtu->pdev->dev.platform_data;
-	void __iomem *base = ch->mtu->mapbase;
 	unsigned long offs;
 
 	if (reg_nr == TSTR)
-		return ioread8(base + cfg->channel_offset);
+		return ioread8(ch->mtu->mapbase);
 
 	offs = mtu2_reg_offs[reg_nr];
 
 	if ((reg_nr == TCNT) || (reg_nr == TGR))
-		return ioread16(base + offs);
+		return ioread16(ch->base + offs);
 	else
-		return ioread8(base + offs);
+		return ioread8(ch->base + offs);
 }
 
 static inline void sh_mtu2_write(struct sh_mtu2_channel *ch, int reg_nr,
 				unsigned long value)
 {
-	struct sh_timer_config *cfg = ch->mtu->pdev->dev.platform_data;
-	void __iomem *base = ch->mtu->mapbase;
 	unsigned long offs;
 
 	if (reg_nr == TSTR) {
-		iowrite8(value, base + cfg->channel_offset);
+		iowrite8(value, ch->mtu->mapbase);
 		return;
 	}
 
 	offs = mtu2_reg_offs[reg_nr];
 
 	if ((reg_nr == TCNT) || (reg_nr == TGR))
-		iowrite16(value, base + offs);
+		iowrite16(value, ch->base + offs);
 	else
-		iowrite8(value, base + offs);
+		iowrite8(value, ch->base + offs);
 }
 
 static void sh_mtu2_start_stop_ch(struct sh_mtu2_channel *ch, int start)
@@ -315,13 +314,18 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 		goto err0;
 	}
 
-	/* map memory, let mapbase point to our channel */
-	mtu->mapbase = ioremap_nocache(res->start, resource_size(res));
-	if (mtu->mapbase == NULL) {
+	/*
+	 * Map memory, let channel.base point to our channel and mapbase to the
+	 * start/stop shared register.
+	 */
+	mtu->channel.base = ioremap_nocache(res->start, resource_size(res));
+	if (mtu->channel.base == NULL) {
 		dev_err(&mtu->pdev->dev, "failed to remap I/O memory\n");
 		goto err0;
 	}
 
+	mtu->mapbase = mtu->channel.base + cfg->channel_offset;
+
 	/* get hold of clock */
 	mtu->clk = clk_get(&mtu->pdev->dev, "mtu2_fck");
 	if (IS_ERR(mtu->clk)) {
@@ -344,7 +348,7 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
  err2:
 	clk_put(mtu->clk);
  err1:
-	iounmap(mtu->mapbase);
+	iounmap(mtu->channel.base);
  err0:
 	return ret;
 }
-- 
1.7.9.5

