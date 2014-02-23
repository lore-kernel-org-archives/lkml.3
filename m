Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaBWOVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 09:21:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35456 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaBWOVZ (ORCPT
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
Subject: [PATCH v4 01/16] pinctrl: mvebu: count unnamed controls and allocate name buffer
Date: Sun, 23 Feb 2014 15:20:59 +0100
Message-Id: <1393165274-32492-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl-mvebu allows SoCs to pass unnamed controls that will get an
auto-generated name of "mpp<PIN#>". Currently, we are allocating name
buffers on a per-control basis while looping over passed controls.
This counts the total number of unnamed controls and allocates a
global name buffer instead. The new buffer is then used while assigning
controls to pinctrl groups later.

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
 drivers/pinctrl/mvebu/pinctrl-mvebu.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 0fd1ad31fbf9..d47650fc5119 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -598,6 +598,9 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 	void __iomem *base;
 	struct pinctrl_pin_desc *pdesc;
 	unsigned gid, n, k;
+	unsigned size, noname = 0;
+	char *noname_buf;
+	void *p;
 	int ret;
 
 	if (!soc || !soc->controls || !soc->modes) {
@@ -660,6 +663,7 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 			sprintf(names + 8*k, "mpp%d", ctrl->pid+k);
 		ctrl->name = names;
 		pctl->num_groups += ctrl->npins;
+		noname += ctrl->npins;
 	}
 
 	pdesc = devm_kzalloc(&pdev->dev, pctl->desc.npins *
@@ -673,12 +677,17 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		pdesc[n].number = n;
 	pctl->desc.pins = pdesc;
 
-	pctl->groups = devm_kzalloc(&pdev->dev, pctl->num_groups *
-			     sizeof(struct mvebu_pinctrl_group), GFP_KERNEL);
-	if (!pctl->groups) {
-		dev_err(&pdev->dev, "failed to alloc pinctrl groups\n");
+	/*
+	 * allocate groups and name buffers for unnamed groups.
+	 */
+	size = pctl->num_groups * sizeof(*pctl->groups) + noname * 8;
+	p = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!p) {
+		dev_err(&pdev->dev, "failed to alloc group data\n");
 		return -ENOMEM;
 	}
+	pctl->groups = p;
+	noname_buf = p + pctl->num_groups * sizeof(*pctl->groups);
 
 	/* assign mpp controls to groups */
 	gid = 0;
@@ -692,15 +701,20 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 
 		/* generic mvebu register control maps to a number of groups */
 		if (!ctrl->mpp_get && !ctrl->mpp_set) {
+			pctl->groups[gid].name = noname_buf;
 			pctl->groups[gid].npins = 1;
+			sprintf(noname_buf, "mpp%d", ctrl->pid+0);
+			noname_buf += 8;
 
 			for (k = 1; k < ctrl->npins; k++) {
 				gid++;
 				pctl->groups[gid].gid = gid;
 				pctl->groups[gid].ctrl = ctrl;
-				pctl->groups[gid].name = &ctrl->name[8*k];
+				pctl->groups[gid].name = noname_buf;
 				pctl->groups[gid].pins = &ctrl->pins[k];
 				pctl->groups[gid].npins = 1;
+				sprintf(noname_buf, "mpp%d", ctrl->pid+k);
+				noname_buf += 8;
 			}
 		}
 		gid++;
-- 
1.8.5.3

