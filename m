Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaIWTHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:07:54 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:45094 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbaIWTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:05:49 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 1/5] pinctrl: samsung: Make samsung_pinctrl_get_soc_data use ERR_PTR()
Date: Tue, 23 Sep 2014 21:05:37 +0200
Message-Id: <1411499141-26551-2-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the function returns a valid pointer on success and NULL on
error, so exact error code is lost. This patch changes return convention
of the function to use ERR_PTR() on error instead.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/pinctrl/samsung/pinctrl-samsung.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 4a47691c32b1..0504f0b75de8 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -988,7 +988,7 @@ static struct samsung_pin_ctrl *samsung_pinctrl_get_soc_data(
 	id = of_alias_get_id(node, "pinctrl");
 	if (id < 0) {
 		dev_err(&pdev->dev, "failed to get alias id\n");
-		return NULL;
+		return ERR_PTR(-ENOENT);
 	}
 	match = of_match_node(samsung_pinctrl_dt_match, node);
 	ctrl = (struct samsung_pin_ctrl *)match->data + id;
@@ -1040,9 +1040,9 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	ctrl = samsung_pinctrl_get_soc_data(drvdata, pdev);
-	if (!ctrl) {
+	if (IS_ERR(ctrl)) {
 		dev_err(&pdev->dev, "driver data not available\n");
-		return -EINVAL;
+		return PTR_ERR(ctrl);
 	}
 	drvdata->ctrl = ctrl;
 	drvdata->dev = dev;
-- 
2.1.0

