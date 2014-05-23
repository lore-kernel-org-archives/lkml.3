Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaEWKyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:54:08 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56440 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaEWKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:45 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/71] clocksource: sh_cmt: Rename mapbase/mapbase_str to mapbase_ch/mapbase
Date: Fri, 23 May 2014 12:30:46 +0200
Message-Id: <1400841111-6683-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The mapbase variable points to the mapped base address of the channel,
rename it to mapbase_sh. mapbase_str points to the mapped base address
of the CMT device, rename it to mapbase.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index febd6bf..eb93b88 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -55,8 +55,8 @@ struct sh_cmt_channel {
 struct sh_cmt_device {
 	struct platform_device *pdev;
 
+	void __iomem *mapbase_ch;
 	void __iomem *mapbase;
-	void __iomem *mapbase_str;
 	struct clk *clk;
 
 	struct sh_cmt_channel channel;
@@ -125,41 +125,41 @@ static void sh_cmt_write32(void __iomem *base, unsigned long offs,
 
 static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_control(ch->cmt->mapbase_str, 0);
+	return ch->cmt->read_control(ch->cmt->mapbase, 0);
 }
 
 static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_control(ch->cmt->mapbase, CMCSR);
+	return ch->cmt->read_control(ch->cmt->mapbase_ch, CMCSR);
 }
 
 static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_count(ch->cmt->mapbase, CMCNT);
+	return ch->cmt->read_count(ch->cmt->mapbase_ch, CMCNT);
 }
 
 static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_control(ch->cmt->mapbase_str, 0, value);
+	ch->cmt->write_control(ch->cmt->mapbase, 0, value);
 }
 
 static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_control(ch->cmt->mapbase, CMCSR, value);
+	ch->cmt->write_control(ch->cmt->mapbase_ch, CMCSR, value);
 }
 
 static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_count(ch->cmt->mapbase, CMCNT, value);
+	ch->cmt->write_count(ch->cmt->mapbase_ch, CMCNT, value);
 }
 
 static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_count(ch->cmt->mapbase, CMCOR, value);
+	ch->cmt->write_count(ch->cmt->mapbase_ch, CMCOR, value);
 }
 
 static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
@@ -761,18 +761,18 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	/* optional resource for the shared timer start/stop register */
 	res2 = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 1);
 
-	/* map memory, let mapbase point to our channel */
-	cmt->mapbase = ioremap_nocache(res->start, resource_size(res));
-	if (cmt->mapbase == NULL) {
+	/* map memory, let mapbase_ch point to our channel */
+	cmt->mapbase_ch = ioremap_nocache(res->start, resource_size(res));
+	if (cmt->mapbase_ch == NULL) {
 		dev_err(&cmt->pdev->dev, "failed to remap I/O memory\n");
 		goto err0;
 	}
 
 	/* map second resource for CMSTR */
-	cmt->mapbase_str = ioremap_nocache(res2 ? res2->start :
-					   res->start - cfg->channel_offset,
-					   res2 ? resource_size(res2) : 2);
-	if (cmt->mapbase_str == NULL) {
+	cmt->mapbase = ioremap_nocache(res2 ? res2->start :
+				       res->start - cfg->channel_offset,
+				       res2 ? resource_size(res2) : 2);
+	if (cmt->mapbase == NULL) {
 		dev_err(&cmt->pdev->dev, "failed to remap I/O second memory\n");
 		goto err1;
 	}
@@ -824,9 +824,9 @@ err4:
 err3:
 	clk_put(cmt->clk);
 err2:
-	iounmap(cmt->mapbase_str);
-err1:
 	iounmap(cmt->mapbase);
+err1:
+	iounmap(cmt->mapbase_ch);
 err0:
 	return ret;
 }
-- 
1.7.9.5

