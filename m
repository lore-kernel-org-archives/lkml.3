Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbaGWLAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:00:23 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57875 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbaGWKyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:15 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/25] clocksource: sh_mtu2: Replace global spinlock with a per-device spinlock
Date: Wed, 23 Jul 2014 12:53:48 +0200
Message-Id: <1406112847-26275-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The global spinlock is used to protect the shared start/stop register.
Now that all MTU2 channels are handled by a single device instance, use
a per-device spinlock.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 0342e4a..b0c229f 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -47,14 +47,14 @@ struct sh_mtu2_device {
 	void __iomem *mapbase;
 	struct clk *clk;
 
+	raw_spinlock_t lock; /* Protect the shared registers */
+
 	struct sh_mtu2_channel *channels;
 	unsigned int num_channels;
 
 	bool has_clockevent;
 };
 
-static DEFINE_RAW_SPINLOCK(sh_mtu2_lock);
-
 #define TSTR -1 /* shared register */
 #define TCR  0 /* channel register */
 #define TMDR 1 /* channel register */
@@ -192,7 +192,7 @@ static void sh_mtu2_start_stop_ch(struct sh_mtu2_channel *ch, int start)
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
-	raw_spin_lock_irqsave(&sh_mtu2_lock, flags);
+	raw_spin_lock_irqsave(&ch->mtu->lock, flags);
 	value = sh_mtu2_read(ch, TSTR);
 
 	if (start)
@@ -201,7 +201,7 @@ static void sh_mtu2_start_stop_ch(struct sh_mtu2_channel *ch, int start)
 		value &= ~(1 << ch->index);
 
 	sh_mtu2_write(ch, TSTR, value);
-	raw_spin_unlock_irqrestore(&sh_mtu2_lock, flags);
+	raw_spin_unlock_irqrestore(&ch->mtu->lock, flags);
 }
 
 static int sh_mtu2_enable(struct sh_mtu2_channel *ch)
@@ -402,6 +402,8 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 
 	mtu->pdev = pdev;
 
+	raw_spin_lock_init(&mtu->lock);
+
 	/* Get hold of clock. */
 	mtu->clk = clk_get(&mtu->pdev->dev, "fck");
 	if (IS_ERR(mtu->clk)) {
-- 
1.7.9.5

