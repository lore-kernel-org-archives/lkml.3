Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3J2OaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:30:24 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36007 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3J2OaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:30:23 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-sh@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] clocksource: sh_mtu2: Add clk_prepare/unprepare support
Date: Tue, 29 Oct 2013 15:30:45 +0100
Message-Id: <1383057045-22608-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1383057045-22608-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1383000569-8916-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1383057045-22608-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the clock at probe time, as there is no other appropriate place
in the driver where we're allowed to sleep.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_mtu2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index e6cfb32..3cf1283 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -313,13 +313,18 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
 		goto err1;
 	}
 
+	ret = clk_prepare(p->clk);
+	if (ret < 0)
+		goto err2;
+
 	ret = sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
 			       cfg->clockevent_rating);
 	if (ret < 0)
-		goto err2;
+		goto err3;
 
 	return 0;
-
+ err3:
+	clk_unprepare(p->clk);
  err2:
 	clk_put(p->clk);
  err1:
-- 
1.8.1.5

