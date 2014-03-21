Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbaCUIPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:15:34 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47627 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbaCUIP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:15:29 -0400
Message-ID: <1395389720.29259.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: s2mpa01: Don't check enable_shift before
 setting enable ramp rate
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 16:15:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code misses updating the register when enable_shift is 0.
e.g. S2MPA01_BUCK4_RAMP_EN_SHIFT is 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s2mpa01.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index 808b3aa..f19a30f 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -192,13 +192,11 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	if (!ramp_enable)
 		goto ramp_disable;
 
-	if (enable_shift) {
-		ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
-					1 << enable_shift, 1 << enable_shift);
-		if (ret) {
-			dev_err(&rdev->dev, "failed to enable ramp rate\n");
-			return ret;
-		}
+	ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
+				 1 << enable_shift, 1 << enable_shift);
+	if (ret) {
+		dev_err(&rdev->dev, "failed to enable ramp rate\n");
+		return ret;
 	}
 
 	ramp_val = get_ramp_delay(ramp_delay);
-- 
1.8.3.2



