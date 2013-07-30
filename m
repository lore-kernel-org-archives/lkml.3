Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3G3Orw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:47:52 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40772 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3G3Oru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:47:50 -0400
Message-ID: <1375195664.11289.1.camel@phoenix>
Subject: [PATCH] regulator: pfuze100: Simplify pfuze100_set_ramp_delay
 implementation
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Jul 2013 22:47:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the equation to calculate ramp_delay.
Below equations are equivalent:
  ramp_delay = 25000 / (2 * ramp_delay);
  ramp_delay = 50000 / (4 * ramp_delay);
  ramp_delay = 25000 / (2 * ramp_delay);
  ramp_delay = 12500 / ramp_delay;
So we don't need to read BIT6 of rdev->desc->vsel_reg for applying different
equations.

Also use rdev->desc->vsel_reg instead of run-time calculate register address.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index e02d9b9..bda5561 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -93,26 +93,15 @@ static int pfuze100_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	struct pfuze_chip *pfuze100 = rdev_get_drvdata(rdev);
 	int id = rdev->desc->id;
-	unsigned int val, ramp_bits, reg;
+	unsigned int ramp_bits;
 	int ret;
 
 	if (id < PFUZE100_SWBST) {
-		if (id == PFUZE100_SW1AB)
-			reg = PFUZE100_SW1ABVOL;
-		else
-			reg = PFUZE100_SW1CVOL + (id - PFUZE100_SW1C) * 7;
-		regmap_read(pfuze100->regmap, reg, &val);
-
-		if (id <= PFUZE100_SW1C)
-			ramp_delay = 25000 / (2 * ramp_delay);
-		else if (val & 0x40)
-			ramp_delay = 50000 / (4 * ramp_delay);
-		else
-			ramp_delay = 25000 / (2 * ramp_delay);
-
+		ramp_delay = 12500 / ramp_delay;
 		ramp_bits = (ramp_delay >> 1) - (ramp_delay >> 3);
-		ret = regmap_update_bits(pfuze100->regmap, reg + 4 , 0xc0,
-				ramp_bits << 6);
+		ret = regmap_update_bits(pfuze100->regmap,
+					 rdev->desc->vsel_reg + 4,
+					 0xc0, ramp_bits << 6);
 		if (ret < 0)
 			dev_err(pfuze100->dev, "ramp failed, err %d\n", ret);
 	} else
-- 
1.8.1.2



