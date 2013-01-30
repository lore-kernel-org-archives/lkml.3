Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3A3M2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:28:37 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52463 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3A3M2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:28:33 -0500
Message-ID: <1359548900.3885.2.camel@phoenix>
Subject: [PATCH] regulator: tps65090: Fix using wrong dev argument for
 calling of_regulator_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Jan 2013 20:28:20 +0800
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
 drivers/regulator/tps65090-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 8687543..c8e7045 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -186,7 +186,7 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 		return ERR_PTR(-ENODEV);
 	}
 
-	ret = of_regulator_match(pdev->dev.parent, regulators, tps65090_matches,
+	ret = of_regulator_match(&pdev->dev, regulators, tps65090_matches,
 			ARRAY_SIZE(tps65090_matches));
 	if (ret < 0) {
 		dev_err(&pdev->dev,
-- 
1.7.9.5



