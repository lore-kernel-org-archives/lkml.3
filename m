Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3FZQaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:30:14 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34298 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3FZQaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:30:12 -0400
MIME-Version: 1.0
Date: Thu, 27 Jun 2013 00:30:10 +0800
Message-ID: <CAPgLHd8-jbXfb95x1Bp7GsMuEJ3mOudUcknRqbxNpNmcdQvg3w@mail.gmail.com>
Subject: [PATCH -next] pinctrl: st: fix return value check
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, grant.likely@linaro.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function pinctrl_register() returns
NULL not ERR_PTR(). The IS_ERR() test in the return value
check should be replaced with NULL test.
The function syscon_regmap_lookup_by_phandle() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-st.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 7effedf..de8c626 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1299,9 +1299,9 @@ static int st_pctl_probe_dt(struct platform_device *pdev,
 		return -ENOMEM;
 
 	info->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
-	if (!info->regmap) {
+	if (IS_ERR(info->regmap)) {
 		dev_err(info->dev, "No syscfg phandle specified\n");
-		return -ENOMEM;
+		return PTR_ERR(info->regmap);
 	}
 	info->data = of_match_node(st_pctl_of_match, np)->data;
 
@@ -1376,9 +1376,9 @@ static int st_pctl_probe(struct platform_device *pdev)
 	pctl_desc->name		= dev_name(&pdev->dev);
 
 	info->pctl = pinctrl_register(pctl_desc, &pdev->dev, info);
-	if (IS_ERR(info->pctl)) {
+	if (!info->pctl) {
 		dev_err(&pdev->dev, "Failed pinctrl registration\n");
-		return PTR_ERR(info->pctl);
+		return -EINVAL;
 	}
 
 	for (i = 0; i < info->nbanks; i++)

