Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBNBAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:00:04 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaBNA7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:12 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 12/27] clocksource: sh_cmt: Acquire default clock in the non-legacy case
Date: Fri, 14 Feb 2014 01:59:50 +0100
Message-Id: <1392339605-20691-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sh_cmt driver gets the CMT functional clock using a connection ID of
"cmt_fck". While all SH SoCs create clock lookup entries with a NULL
device ID and a "cmt_fck" connection ID, the ARM SoCs use the device ID
only with a NULL connection ID. This works on legacy platforms but will
break on ARM with DT boot.

Fix the situation by using a NULL connection ID in the non-legacy
platform data case. Clock lookup entries will be renamed as platforms
get moved to new platform data. The legacy code will eventually be
dropped, leaving us with device ID based clock lookup only, compatible
with DT boot.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 8390f0f..2389e33 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -1013,7 +1013,7 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	cmt->legacy = cmt->info ? false : true;
 
 	/* Get hold of clock. */
-	cmt->clk = clk_get(&cmt->pdev->dev, "cmt_fck");
+	cmt->clk = clk_get(&cmt->pdev->dev, cmt->legacy ? "cmt_fck" : NULL);
 	if (IS_ERR(cmt->clk)) {
 		dev_err(&cmt->pdev->dev, "cannot get clock\n");
 		return PTR_ERR(cmt->clk);
-- 
1.8.3.2

