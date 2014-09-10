Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaIJJQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:16:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35721 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752241AbaIJJQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:16:04 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: linus.walleij@linaro.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: berlin: fix the dt_free_map function
Date: Wed, 10 Sep 2014 11:15:51 +0200
Message-Id: <1410340551-24023-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The berlin_pinctrl_dt_free_map function tries to free memory
allocated and handled by the of subsystem. This is wrong and
already handled by pinctrl_dt_free_maps() which calls
of_node_put().

This patch fixes the Berlin pinctrl way of freeing its maps,
avoiding a kernel BUG(), by using the common
pinctrl_utils_dt_free_map function instead.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/pinctrl/berlin/berlin.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c
index 86db2235ab00..6cd5e928fc7f 100644
--- a/drivers/pinctrl/berlin/berlin.c
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -99,30 +99,11 @@ static int berlin_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
 	return 0;
 }
 
-static void berlin_pinctrl_dt_free_map(struct pinctrl_dev *pctrl_dev,
-				       struct pinctrl_map *map,
-				       unsigned nmaps)
-{
-	int i;
-
-	for (i = 0; i < nmaps; i++) {
-		if (map[i].type == PIN_MAP_TYPE_MUX_GROUP) {
-			kfree(map[i].data.mux.group);
-
-			/* a function can be applied to multiple groups */
-			if (i == 0)
-				kfree(map[i].data.mux.function);
-		}
-	}
-
-	kfree(map);
-}
-
 static const struct pinctrl_ops berlin_pinctrl_ops = {
 	.get_groups_count	= &berlin_pinctrl_get_group_count,
 	.get_group_name		= &berlin_pinctrl_get_group_name,
 	.dt_node_to_map		= &berlin_pinctrl_dt_node_to_map,
-	.dt_free_map		= &berlin_pinctrl_dt_free_map,
+	.dt_free_map		= &pinctrl_utils_dt_free_map,
 };
 
 static int berlin_pinmux_get_functions_count(struct pinctrl_dev *pctrl_dev)
-- 
1.9.1

