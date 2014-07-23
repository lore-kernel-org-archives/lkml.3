Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaGWKyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:54:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52950 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaGWKyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:13 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/25] clocksource: sh_tmu: Replace global spinlock with a per-device spinlock
Date: Wed, 23 Jul 2014 12:53:46 +0200
Message-Id: <1406112847-26275-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The global spinlock is used to protect the shared start/stop register.
Now that all TMU channels are handled by a single device instance, use a
per-device spinlock.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/clocksource/sh_tmu.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 3eee5c8..560a31a 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -61,6 +61,8 @@ struct sh_tmu_device {
 
 	enum sh_tmu_model model;
 
+	raw_spinlock_t lock; /* Protect the shared start/stop register */
+
 	struct sh_tmu_channel *channels;
 	unsigned int num_channels;
 
@@ -68,8 +70,6 @@ struct sh_tmu_device {
 	bool has_clocksource;
 };
 
-static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
-
 #define TSTR -1 /* shared register */
 #define TCOR  0 /* channel register */
 #define TCNT 1 /* channel register */
@@ -132,7 +132,7 @@ static void sh_tmu_start_stop_ch(struct sh_tmu_channel *ch, int start)
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
-	raw_spin_lock_irqsave(&sh_tmu_lock, flags);
+	raw_spin_lock_irqsave(&ch->tmu->lock, flags);
 	value = sh_tmu_read(ch, TSTR);
 
 	if (start)
@@ -141,7 +141,7 @@ static void sh_tmu_start_stop_ch(struct sh_tmu_channel *ch, int start)
 		value &= ~(1 << ch->index);
 
 	sh_tmu_write(ch, TSTR, value);
-	raw_spin_unlock_irqrestore(&sh_tmu_lock, flags);
+	raw_spin_unlock_irqrestore(&ch->tmu->lock, flags);
 }
 
 static int __sh_tmu_enable(struct sh_tmu_channel *ch)
@@ -524,6 +524,8 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	tmu->pdev = pdev;
 	tmu->model = id->driver_data;
 
+	raw_spin_lock_init(&tmu->lock);
+
 	/* Get hold of clock. */
 	tmu->clk = clk_get(&tmu->pdev->dev, "fck");
 	if (IS_ERR(tmu->clk)) {
-- 
1.7.9.5

