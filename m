Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3AXC1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:27:55 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50784 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3AXC1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:27:49 -0500
Message-ID: <1358994450.20257.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: tps65217: Fix using wrong dev argument for
 calling of_regulator_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 24 Jan 2013 10:27:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev parameter is the device requestiong the data.
In this case it should be &pdev->dev rather than pdev->dev.parent.

The dev parameter is used to call devm_kzalloc in of_get_regulator_init_data(),
which means this fixes a memory leak because the memory is allocated every time
probe() is called, thus it should be freed when this driver is unloaded.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65217-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 73dce76..df39518 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -305,8 +305,8 @@ static struct tps65217_board *tps65217_parse_dt(struct platform_device *pdev)
 	if (!regs)
 		return NULL;
 
-	count = of_regulator_match(pdev->dev.parent, regs,
-				reg_matches, TPS65217_NUM_REGULATOR);
+	count = of_regulator_match(&pdev->dev, regs, reg_matches,
+				   TPS65217_NUM_REGULATOR);
 	of_node_put(regs);
 	if ((count < 0) || (count > TPS65217_NUM_REGULATOR))
 		return NULL;
-- 
1.7.9.5



