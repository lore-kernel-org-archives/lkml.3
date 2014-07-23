Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaGWKyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:54:12 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39718 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaGWKyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:11 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/25] clocksource: sh_cmt: Replace global spinlock with a per-device spinlock
Date: Wed, 23 Jul 2014 12:53:44 +0200
Message-Id: <1406112847-26275-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The global spinlock is used to protect the shared start/stop register.
Now that all CMT channels are handled by a single device instance, use a
per-device spinlock.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/clocksource/sh_cmt.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index fcd38db..190c655 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -118,6 +118,8 @@ struct sh_cmt_device {
 	void __iomem *mapbase;
 	struct clk *clk;
 
+	raw_spinlock_t lock; /* Protect the shared start/stop register */
+
 	struct sh_cmt_channel *channels;
 	unsigned int num_channels;
 
@@ -299,14 +301,12 @@ static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
 	return v2;
 }
 
-static DEFINE_RAW_SPINLOCK(sh_cmt_lock);
-
 static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 {
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
-	raw_spin_lock_irqsave(&sh_cmt_lock, flags);
+	raw_spin_lock_irqsave(&ch->cmt->lock, flags);
 	value = sh_cmt_read_cmstr(ch);
 
 	if (start)
@@ -315,7 +315,7 @@ static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 		value &= ~(1 << ch->timer_bit);
 
 	sh_cmt_write_cmstr(ch, value);
-	raw_spin_unlock_irqrestore(&sh_cmt_lock, flags);
+	raw_spin_unlock_irqrestore(&ch->cmt->lock, flags);
 }
 
 static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
@@ -934,6 +934,7 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 
 	memset(cmt, 0, sizeof(*cmt));
 	cmt->pdev = pdev;
+	raw_spin_lock_init(&cmt->lock);
 
 	if (!cfg) {
 		dev_err(&cmt->pdev->dev, "missing platform data\n");
-- 
1.7.9.5

