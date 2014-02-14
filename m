Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaBNA74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:59:56 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaBNA7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:10 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 08/27] clocksource: sh_cmt: Allocate channels dynamically
Date: Fri, 14 Feb 2014 01:59:46 +0100
Message-Id: <1392339605-20691-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prepares the driver for multi-channel support.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index cd3121d..7a65d64 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -63,7 +63,8 @@ struct sh_cmt_device {
 	void __iomem *mapbase;
 	struct clk *clk;
 
-	struct sh_cmt_channel channel;
+	struct sh_cmt_channel *channels;
+	unsigned int num_channels;
 
 	unsigned long width; /* 16 or 32 bit version of hardware block */
 	unsigned long overflow_bit;
@@ -824,7 +825,15 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 		cmt->clear_bits = ~0xc000;
 	}
 
-	ret = sh_cmt_setup_channel(&cmt->channel, cfg->timer_bit, cmt);
+	cmt->channels = kzalloc(sizeof(*cmt->channels), GFP_KERNEL);
+	if (cmt->channels == NULL) {
+		ret = -ENOMEM;
+		goto err4;
+	}
+
+	cmt->num_channels = 1;
+
+	ret = sh_cmt_setup_channel(&cmt->channels[0], cfg->timer_bit, cmt);
 	if (ret < 0)
 		goto err4;
 
@@ -832,6 +841,7 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 
 	return 0;
 err4:
+	kfree(cmt->channels);
 	clk_unprepare(cmt->clk);
 err3:
 	clk_put(cmt->clk);
-- 
1.8.3.2

