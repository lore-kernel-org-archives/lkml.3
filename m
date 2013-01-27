Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3A0Myx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:54:53 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54027 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A0Myv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:54:51 -0500
Message-ID: <1359291280.11083.1.camel@phoenix>
Subject: [PATCH] regulator: tps6507x: Fix using wrong dev argument for
 calling of_regulator_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 27 Jan 2013 20:54:40 +0800
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
 drivers/regulator/tps6507x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index afdeb65..54aa2da 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -394,7 +394,7 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 	count = ARRAY_SIZE(tps6507x_matches);
 	matches = tps6507x_matches;
 
-	ret = of_regulator_match(pdev->dev.parent, regulators, matches, count);
+	ret = of_regulator_match(&pdev->dev, regulators, matches, count);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
1.7.9.5



