Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3AKUqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:46:36 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:38367 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523Ab3AKUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:46:35 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH] pinctrl: do not defer device tree hogs
Date: Fri, 11 Jan 2013 21:46:13 +0100
Message-ID: <1357937173-4634-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit af1024e0f7cde9023ddd0f3116db03911d5914c0
"pinctrl: skip deferral of hogs"

Attempts to avoid probe deferral on hogged pins, but we
forgot the device tree case. This patch fixes this.

Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reported-by: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/devicetree.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index fe2d1af..fd40a11 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -141,6 +141,11 @@ static int dt_to_map_one_config(struct pinctrl *p, const char *statename,
 		pctldev = find_pinctrl_by_of_node(np_pctldev);
 		if (pctldev)
 			break;
+		/* Do not defer probing of hogs (circular loop) */
+		if (np_pctldev == p->dev->of_node) {
+			of_node_put(np_pctldev);
+			return -ENODEV;
+		}
 	}
 	of_node_put(np_pctldev);
 
-- 
1.7.11.3

