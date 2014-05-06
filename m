Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbaEFGh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:37:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27871 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933956AbaEFGh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:37:57 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-d0-53688343c461
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/3] regulator: s2mps11: Fix accidental enable of buck6 ramp
 delay
Date: Tue, 06 May 2014 08:37:36 +0200
Message-id: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t/xK7rOzRnBBvdfCVscmfOV2WLqwyds
	Fq9fGFp8u9LBZHF51xw2i5N/ehktLq74wuTA7rFz1l12j7afZR6bVnWyedy5tofNo2/LKkaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDJ2PjvFVrCZt+LM9YnMDYxN3F2MnBwSAiYSfw/8ZoSwxSQu
	3FvP1sXIxSEksJRRov3CfVYIp49J4krTGhaQKjYBY4nNy5eAVYkIbGOUmNDfywSSYBYIllj3
	9CQbiC0sEC6xffFjZhCbRUBVYuPrQ2A2r4C7xLWbM5gh1slJnDw2mXUCI/cCRoZVjKKppckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGCHh8nUH49JjVocYBTgYlXh4F8hkBAuxJpYVV+YeYpTgYFYS
	4a3PBwrxpiRWVqUW5ccXleakFh9iZOLglGpgvHnLuJLPuCN8fUrWilM/Ljh2fROyXf+lsuaM
	X/7+3p+KC8wTn7d2KWQodORaVF35fbDwx/vNazVt/116tpixp29/kNtDv+/83TNmuv+v+Pol
	+UE/69N9wpXT2L+17WXx+8dquaPbTlxx/lvD7S/N+FPrxTY9P7fcS31Px+RbL/4zOHE9K7Df
	pcRSnJFoqMVcVJwIAF309sn1AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S2MPS11 supports enabling/disabling ramp delay only for buck[2346].
Other bucks have ramp delay enabled always.

However the bit shift for enabling buck6 ramp delay in register is equal
to 0. When ramp delay was set for the bucks unsupporting enable/disable
(buck[15789] and buck10), the ramp delay for buck6 was also enabled.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: b96244fad953 ("regulator: s2mps11: Don't check enable_shift before setting enable ramp rate")
---

Changes since v2:
 * Apply Axel Lin's suggestion (don't change the meaning
   of enable_shift variable).

---
 drivers/regulator/s2mps11.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index e713c162fbd4..aaca37e1424f 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -202,11 +202,16 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	if (!ramp_enable)
 		goto ramp_disable;
 
-	ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
-				 1 << enable_shift, 1 << enable_shift);
-	if (ret) {
-		dev_err(&rdev->dev, "failed to enable ramp rate\n");
-		return ret;
+	/* Ramp delay can be enabled/disabled only for buck[2346] */
+	if ((rdev_get_id(rdev) >= S2MPS11_BUCK2 &&
+			rdev_get_id(rdev) <= S2MPS11_BUCK4) ||
+			rdev_get_id(rdev) == S2MPS11_BUCK6)  {
+		ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
+					 1 << enable_shift, 1 << enable_shift);
+		if (ret) {
+			dev_err(&rdev->dev, "failed to enable ramp rate\n");
+			return ret;
+		}
 	}
 
 	ramp_val = get_ramp_delay(ramp_delay);
-- 
1.9.1

