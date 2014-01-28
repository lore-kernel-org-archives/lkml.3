Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaA1Aj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:39:58 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40178 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaA1Aju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:39:50 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/21] pinctrl: mvebu: remove unused macros and functions
Date: Tue, 28 Jan 2014 01:39:25 +0100
Message-Id: <1390869573-27624-14-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With each SoC providing callbacks for every mpp pin, we can now remove
common set/get functions and unused MPP macro that cannot pass callbacks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 48 ++---------------------------------
 drivers/pinctrl/mvebu/pinctrl-mvebu.h | 12 ---------
 2 files changed, 2 insertions(+), 58 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 2bec4ef30b48..dd65b8c44b26 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -138,43 +138,6 @@ static struct mvebu_pinctrl_function *mvebu_pinctrl_find_function_by_name(
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
@@ -184,10 +147,7 @@ static int mvebu_pinconf_group_get(struct pinctrl_dev *pctldev,
 	if (!grp->ctrl)
 		return -EINVAL;
 
-	if (grp->ctrl->mpp_get)
-		return grp->ctrl->mpp_get(grp->ctrl, config);
-
-	return mvebu_common_mpp_get(pctl, grp, config);
+	return grp->ctrl->mpp_get(grp->ctrl, config);
 }
 
 static int mvebu_pinconf_group_set(struct pinctrl_dev *pctldev,
@@ -202,11 +162,7 @@ static int mvebu_pinconf_group_set(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 
 	for (i = 0; i < num_configs; i++) {
-		if (grp->ctrl->mpp_set)
-			ret = grp->ctrl->mpp_set(grp->ctrl, configs[i]);
-		else
-			ret = mvebu_common_mpp_set(pctl, grp, configs[i]);
-
+		ret = grp->ctrl->mpp_set(grp->ctrl, configs[i]);
 		if (ret)
 			return ret;
 	} /* for each config */
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index e81caa964d83..6c8451af95b6 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -114,18 +114,6 @@ struct mvebu_pinctrl_soc_info {
 	int ngpioranges;
 };
 
-#define MPP_REG_CTRL(_idl, _idh)				\
-	{							\
-		.name = NULL,					\
-		.pid = _idl,					\
-		.npins = _idh - _idl + 1,			\
-		.pins = (unsigned[_idh - _idl + 1]) { },	\
-		.mpp_get = NULL,				\
-		.mpp_set = NULL,				\
-		.mpp_gpio_req = NULL,				\
-		.mpp_gpio_dir = NULL,				\
-	}
-
 #define MPP_FUNC_CTRL(_idl, _idh, _name, _func)			\
 	{							\
 		.name = _name,					\
-- 
1.8.5.2

