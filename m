Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaBLQA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:00:29 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42871 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaBLQAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:00:25 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/13] pinctrl: mvebu: remove common get/set functions
Date: Wed, 12 Feb 2014 16:59:34 +0100
Message-Id: <1392220776-30851-12-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With every SoC always providing its own get/set callbacks, we can now
remove the generic ones, remove the obsolete base address, and always
use the provided callbacks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
---
Cc: Linus Walleij <linus.walleij@linaro.org> 
Cc: Jason Cooper <jason@lakedaemon.net> 
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 49 ++---------------------------------
 1 file changed, 2 insertions(+), 47 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 45e99e80502f..9908374f8f92 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -50,7 +50,6 @@ struct mvebu_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctldev;
 	struct pinctrl_desc desc;
-	void __iomem *base;
 	struct mvebu_pinctrl_group *groups;
 	unsigned num_groups;
 	struct mvebu_pinctrl_function *functions;
@@ -138,43 +137,6 @@ static struct mvebu_pinctrl_function *mvebu_pinctrl_find_function_by_name(
 	return NULL;
 }
 
-/*
- * Common mpp pin configuration registers on MVEBU are
- * registers of eight 4-bit values for each mpp setting.
- * Register offset and bit mask are calculated accordingly below.
- */
-static int mvebu_common_mpp_get(struct mvebu_pinctrl *pctl,
-				struct mvebu_pinctrl_group *grp,
-				unsigned long *config)
-{
-	unsigned pin = grp->gid;
-	unsigned off = (pin / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (pin % MPPS_PER_REG) * MPP_BITS;
-
-	*config = readl(pctl->base + off);
-	*config >>= shift;
-	*config &= MPP_MASK;
-
-	return 0;
-}
-
-static int mvebu_common_mpp_set(struct mvebu_pinctrl *pctl,
-				struct mvebu_pinctrl_group *grp,
-				unsigned long config)
-{
-	unsigned pin = grp->gid;
-	unsigned off = (pin / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (pin % MPPS_PER_REG) * MPP_BITS;
-	unsigned long reg;
-
-	reg = readl(pctl->base + off);
-	reg &= ~(MPP_MASK << shift);
-	reg |= (config << shift);
-	writel(reg, pctl->base + off);
-
-	return 0;
-}
-
 static int mvebu_pinconf_group_get(struct pinctrl_dev *pctldev,
 				unsigned gid, unsigned long *config)
 {
@@ -184,10 +146,7 @@ static int mvebu_pinconf_group_get(struct pinctrl_dev *pctldev,
 	if (!grp->ctrl)
 		return -EINVAL;
 
-	if (grp->ctrl->mpp_get)
-		return grp->ctrl->mpp_get(grp->pins[0], config);
-
-	return mvebu_common_mpp_get(pctl, grp, config);
+	return grp->ctrl->mpp_get(grp->pins[0], config);
 }
 
 static int mvebu_pinconf_group_set(struct pinctrl_dev *pctldev,
@@ -202,11 +161,7 @@ static int mvebu_pinconf_group_set(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	for (i = 0; i < num_configs; i++) {
-		if (grp->ctrl->mpp_set)
-			ret = grp->ctrl->mpp_set(grp->pins[0], configs[i]);
-		else
-			ret = mvebu_common_mpp_set(pctl, grp, configs[i]);
-
+		ret = grp->ctrl->mpp_set(grp->pins[0], configs[i]);
 		if (ret)
 			return ret;
 	} /* for each config */
-- 
1.8.5.3

