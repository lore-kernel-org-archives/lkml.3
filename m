Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaBNA7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:59:49 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaBNA7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:09 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 04/27] clocksource: sh_cmt: Rename mapbase/mapbase_str to mapbase_ch/mapbase
Date: Fri, 14 Feb 2014 01:59:42 +0100
Message-Id: <1392339605-20691-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mapbase variable points to the mapped base address of the channel,
rename it to mapbase_sh. mapbase_str points to the mapped base address
of the CMT device, rename it to mapbase.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 3a3cc83..1ac84ff 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -57,8 +57,8 @@ struct sh_cmt_channel {
 struct sh_cmt_device {
 	struct platform_device *pdev;
 
+	void __iomem *mapbase_ch;
 	void __iomem *mapbase;
-	void __iomem *mapbase_str;
 	struct clk *clk;
 
 	struct sh_cmt_channel channel;
@@ -127,41 +127,41 @@ static void sh_cmt_write32(void __iomem *base, unsigned long offs,
 
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
@@ -767,18 +767,18 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
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
@@ -830,9 +830,9 @@ err4:
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
1.8.3.2

