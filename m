Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaBWOV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:21:26 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33389 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaBWOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 09:21:25 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/16] pinctrl: mvebu: identify generic controls by name
Date: Sun, 23 Feb 2014 15:21:01 +0100
Message-Id: <1393165274-32492-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We treat unnamed controls as generic mvebu mpp register controls but
we identify them by not being special controls. Flip the logic and
use the name pointer as identification instead. While at it, add some
comments explaining the not so obvious treatment.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
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
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index c0e27e4f8953..2be432444124 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -638,23 +638,21 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		struct mvebu_mpp_ctrl *ctrl = &soc->controls[n];
 
 		pctl->desc.npins += ctrl->npins;
-		/* initial control pins */
+		/* initialize control's pins[] array */
 		for (k = 0; k < ctrl->npins; k++)
 			ctrl->pins[k] = ctrl->pid + k;
 
-		/* special soc specific control */
-		if (ctrl->mpp_get || ctrl->mpp_set) {
-			if (!ctrl->name || !ctrl->mpp_get || !ctrl->mpp_set) {
-				dev_err(&pdev->dev, "wrong soc control info\n");
-				return -EINVAL;
-			}
+		/*
+		 * We allow to pass controls with NULL name that we treat
+		 * as a range of one-pin groups with generic mvebu register
+		 * controls.
+		 */
+		if (!ctrl->name) {
+			pctl->num_groups += ctrl->npins;
+			noname += ctrl->npins;
+		} else {
 			pctl->num_groups += 1;
-			continue;
 		}
-
-		/* generic mvebu register control */
-		pctl->num_groups += ctrl->npins;
-		noname += ctrl->npins;
 	}
 
 	pdesc = devm_kzalloc(&pdev->dev, pctl->desc.npins *
@@ -690,8 +688,12 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		pctl->groups[gid].pins = ctrl->pins;
 		pctl->groups[gid].npins = ctrl->npins;
 
-		/* generic mvebu register control maps to a number of groups */
-		if (!ctrl->mpp_get && !ctrl->mpp_set) {
+		/*
+		 * We treat unnamed controls as a range of one-pin groups
+		 * with generic mvebu register controls. Use one group for
+		 * each in this range and assign a default group name.
+		 */
+		if (!ctrl->name) {
 			pctl->groups[gid].name = noname_buf;
 			pctl->groups[gid].npins = 1;
 			sprintf(noname_buf, "mpp%d", ctrl->pid+0);
-- 
1.8.5.3

