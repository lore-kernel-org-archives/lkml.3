Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716Ab3DDKkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:40:36 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41015 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab3DDKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:40:32 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Thomas Abraham <thomas.ab@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 1/3] pinctrl: exynos5440: fix probe failure due to missing pin-list in config nodes
Date: Wed, 27 Mar 2013 00:12:32 +0900
Message-Id: <1364310754-3692-2-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1364310754-3692-1-git-send-email-kgene.kim@samsung.com>
References: <1364310754-3692-1-git-send-email-kgene.kim@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Abraham <thomas.ab@samsung.com>

The property 'samsung,exynos5440-pins' is optional in configuration nodes
which are included in the Exynos5440 pin-controller device node. Fix the
incorrect failure in driver probe if 'samsung,exynos5440-pins' property
is not found in the configuration nodes.

Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/pinctrl/pinctrl-exynos5440.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 1376eb7..96cb1e9 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -670,8 +670,10 @@ static int exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
 
 		ret = exynos5440_pinctrl_parse_dt_pins(pdev, cfg_np,
 					&pin_list, &npins);
-		if (ret)
-			return ret;
+		if (ret) {
+			gname = NULL;
+			goto skip_to_pin_function;
+		}
 
 		/* derive pin group name from the node name */
 		gname = devm_kzalloc(dev, strlen(cfg_np->name) + GSUFFIX_LEN,
@@ -687,6 +689,7 @@ static int exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
 		grp->num_pins = npins;
 		grp++;
 
+skip_to_pin_function:
 		ret = of_property_read_u32(cfg_np, "samsung,exynos5440-pin-function",
 						&function);
 		if (ret)
@@ -709,7 +712,7 @@ static int exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
 			return -ENOMEM;
 		}
 		func->groups[0] = gname;
-		func->num_groups = 1;
+		func->num_groups = gname ? 1 : 0;
 		func->function = function;
 		func++;
 		func_idx++;
-- 
1.7.4.4

