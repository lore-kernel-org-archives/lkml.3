Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3ARCaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 21:30:06 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44754 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3ARCaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 21:30:05 -0500
Message-ID: <1358476199.25899.3.camel@phoenix>
Subject: [PATCH] regulator: lp872x: Remove _rdev_to_offset() function
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jan 2013 10:29:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one caller calling _rdev_to_offset(), and the code
looks simper if we remove _rdev_to_offset(). Thus remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp872x.c |   32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 9289ead..41bdbbe 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -181,20 +181,6 @@ static inline int lp872x_update_bits(struct lp872x *lp, u8 addr,
 	return regmap_update_bits(lp->regmap, addr, mask, data);
 }
 
-static int _rdev_to_offset(struct regulator_dev *rdev)
-{
-	enum lp872x_regulator_id id = rdev_get_id(rdev);
-
-	switch (id) {
-	case LP8720_ID_LDO1 ... LP8720_ID_BUCK:
-		return id;
-	case LP8725_ID_LDO1 ... LP8725_ID_BUCK2:
-		return id - LP8725_ID_BASE;
-	default:
-		return -EINVAL;
-	}
-}
-
 static int lp872x_get_timestep_usec(struct lp872x *lp)
 {
 	enum lp872x_id chip = lp->chipid;
@@ -236,26 +222,18 @@ static int lp872x_regulator_enable_time(struct regulator_dev *rdev)
 	struct lp872x *lp = rdev_get_drvdata(rdev);
 	enum lp872x_regulator_id regulator = rdev_get_id(rdev);
 	int time_step_us = lp872x_get_timestep_usec(lp);
-	int ret, offset;
+	int ret;
 	u8 addr, val;
 
 	if (time_step_us < 0)
 		return -EINVAL;
 
 	switch (regulator) {
-	case LP8720_ID_LDO1 ... LP8720_ID_LDO5:
-	case LP8725_ID_LDO1 ... LP8725_ID_LILO2:
-		offset = _rdev_to_offset(rdev);
-		if (offset < 0)
-			return -EINVAL;
-
-		addr = LP872X_LDO1_VOUT + offset;
-		break;
-	case LP8720_ID_BUCK:
-		addr = LP8720_BUCK_VOUT1;
+	case LP8720_ID_LDO1 ... LP8720_ID_BUCK:
+		addr = LP872X_LDO1_VOUT + regulator;
 		break;
-	case LP8725_ID_BUCK1:
-		addr = LP8725_BUCK1_VOUT1;
+	case LP8725_ID_LDO1 ... LP8725_ID_BUCK1:
+		addr = LP872X_LDO1_VOUT + regulator - LP8725_ID_BASE;
 		break;
 	case LP8725_ID_BUCK2:
 		addr = LP8725_BUCK2_VOUT1;
-- 
1.7.9.5



