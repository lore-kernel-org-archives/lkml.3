Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaI3HOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:14:24 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62096 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaI3HOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:14:23 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] pinctrl: nomadik: use util function to reserve maps
Date: Tue, 30 Sep 2014 09:14:18 +0200
Message-Id: <1412061258-20750-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop brewing our own pin map reservation function and use the
generic code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-nomadik.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index c093d75a022a..9fe31daf9230 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -32,6 +32,7 @@
 #include <linux/pinctrl/consumer.h>
 #include "pinctrl-nomadik.h"
 #include "../core.h"
+#include "../pinctrl-utils.h"
 
 /*
  * The GPIO module in the Nomadik family of Systems-on-Chip is an
@@ -1349,28 +1350,6 @@ static void nmk_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
 	kfree(map);
 }
 
-static int nmk_dt_reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
-		unsigned *num_maps, unsigned reserve)
-{
-	unsigned old_num = *reserved_maps;
-	unsigned new_num = *num_maps + reserve;
-	struct pinctrl_map *new_map;
-
-	if (old_num >= new_num)
-		return 0;
-
-	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
-	if (!new_map)
-		return -ENOMEM;
-
-	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
-
-	*map = new_map;
-	*reserved_maps = new_num;
-
-	return 0;
-}
-
 static int nmk_dt_add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
 		unsigned *num_maps, const char *group,
 		const char *function)
@@ -1561,7 +1540,7 @@ static int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 
 	reserve *= ret;
 
-	ret = nmk_dt_reserve_map(map, reserved_maps, num_maps, reserve);
+	ret = pinctrl_utils_reserve_map(pctldev, map, reserved_maps, num_maps, reserve);
 	if (ret < 0)
 		goto exit;
 
-- 
1.9.3

