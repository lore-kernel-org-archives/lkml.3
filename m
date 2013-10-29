Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3J2OaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:30:25 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36004 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3J2OaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:30:23 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-sh@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] clocksource: sh_mtu2: Release clock when sh_mtu2_register() fails
Date: Tue, 29 Oct 2013 15:30:44 +0100
Message-Id: <1383057045-22608-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1383000569-8916-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1383000569-8916-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the probe error path to release the clock resource when the
sh_mtu2_register() call fails.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_mtu2.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 4aac9ee..e6cfb32 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -313,8 +313,15 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
 		goto err1;
 	}
 
-	return sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
-				cfg->clockevent_rating);
+	ret = sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
+			       cfg->clockevent_rating);
+	if (ret < 0)
+		goto err2;
+
+	return 0;
+
+ err2:
+	clk_put(p->clk);
  err1:
 	iounmap(p->mapbase);
  err0:
-- 
1.8.1.5

