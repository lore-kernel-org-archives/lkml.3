Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3AYCVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:21:08 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54231 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3AYCUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:20:46 -0500
Message-ID: <1359080429.4232.3.camel@phoenix>
Subject: [PATCH 1/3] regulator: max8907: Fix using wrong dev argument for
 calling of_regulator_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Gyungoh Yoo <jack.yoo@maxim-ic.com>, Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 10:20:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev parameter is the device requesting the data.
In this case it should be &pdev->dev rather than pdev->dev.parent.

The dev parameter is used to call devm_kzalloc in of_get_regulator_init_data(),
which means this fixes a memory leak because the memory is allocated every time
probe() is called, thus it should be freed when this driver is unloaded.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8907-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index d1a7751..d40cf7f 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -237,8 +237,7 @@ static int max8907_regulator_parse_dt(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	ret = of_regulator_match(pdev->dev.parent, regulators,
-				 max8907_matches,
+	ret = of_regulator_match(&pdev->dev, regulators, max8907_matches,
 				 ARRAY_SIZE(max8907_matches));
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
-- 
1.7.9.5



