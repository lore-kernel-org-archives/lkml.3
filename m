Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3HEGIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:08:52 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44202 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3HEGIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:08:43 -0400
Message-ID: <1375682917.11490.0.camel@phoenix>
Subject: [PATCH] regulator: s2mps11: Fix setting ramp_delay
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 14:08:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has wrong mask and val arguments for updating ramp_delay. Fix it.
Also ensure the return value of get_ramp_delay() won't greater than 3 because
the mask field for ramp_val only takes 2 bits.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s2mps11.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 89140ae..5eba2ff 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -50,6 +50,10 @@ static int get_ramp_delay(int ramp_delay)
 			break;
 		cnt++;
 	}
+
+	if (cnt > 3)
+		cnt = 3;
+
 	return cnt;
 }
 
@@ -203,8 +207,8 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 
 	ramp_val = get_ramp_delay(ramp_delay);
 
-	return regmap_update_bits(rdev->regmap, ramp_reg,
-				  ramp_val << ramp_shift, 1 << ramp_shift);
+	return regmap_update_bits(rdev->regmap, ramp_reg, 0x3 << ramp_shift,
+				  ramp_val << ramp_shift);
 
 ramp_disable:
 	return regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
-- 
1.8.1.2



