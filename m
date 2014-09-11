Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaIKKWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:22:54 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51043 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaIKKWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:22:52 -0400
Message-ID: <1410430968.32479.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: rk808: Fix missing of_node_put
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Doug Anderson <dianders@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Sep 2014 18:22:48 +0800
In-Reply-To: <1410430870.32479.0.camel@phoenix>
References: <1410430870.32479.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Pass &pdev->dev rather than &client->dev to of_regulator_match, the *dev
   argument is used for devres to ensure devm_of_regulator_put_matches() will
   be called when unload the module.

2. of_get_child_by_name() returns a node pointer with refcount incremented.
   Thus add missing of_node_put(reg_np).

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/rk808-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 9557428..07b0eb4 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -281,8 +281,9 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 	if (!reg_np)
 		return -ENXIO;
 
-	ret = of_regulator_match(&client->dev, reg_np, rk808_reg_matches,
+	ret = of_regulator_match(&pdev->dev, reg_np, rk808_reg_matches,
 				 RK808_NUM_REGULATORS);
+	of_node_put(reg_np);
 	if (ret < 0)
 		return ret;
 
-- 
1.9.1



