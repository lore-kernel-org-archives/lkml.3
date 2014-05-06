Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095AbaEFGiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:38:01 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32179 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934028AbaEFGh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:37:57 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-d2-5368834343ca
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/3] regulator: s2mpa01: Fix accidental enable of buck4 ramp
 delay
Date: Tue, 06 May 2014 08:37:37 +0200
Message-id: <1399358258-21536-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
References: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xK7rOzRnBBt3PNC2OzPnKbDH14RM2
	i9cvDC2+Xelgsri8aw6bxck/vYwWF1d8YXJg99g56y67R9vPMo9NqzrZPO5c28Pm0bdlFaPH
	501yAWxRXDYpqTmZZalF+nYJXBnzH7xnLGjlrfh77iZzA+Ndri5GTg4JAROJnq8fWCFsMYkL
	99azdTFycQgJLGWU2PN7EiOE08ckcaVpDQtIFZuAscTm5UvAqkQEtjFKTOjvZQJJMAsES6x7
	epINxBYWCJc417cCLM4ioCqxauZVRhCbV8Bd4vvSGcwQ6+QkTh6bDLaaU8BD4s2abWC2EFDN
	0vP32Scw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJeX3cwLj1mdYhRgINRiYd3
	gUxGsBBrYllxZe4hRgkOZiUR3vp8oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGVV5WWi1XDUok
	3/Vx5h1QvKoSFrvt1e57D0SaCiXf3BC6pXPi9W2piwnhHJ/mzti2SPM7n8MXW/H86FKV1x48
	65Znf2D9cEDm6uVPrr4RD6V2PeT8VijmqHDr46G8B08mK7pbXn0WviXk8qREs7avGrWtm04L
	Je972cD4qCzw9EoV+9NvJJ6GK7EUZyQaajEXFScCAByqTxcNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S2MPA01 supports enabling/disabling ramp delay only for buck[1234].
Other bucks have ramp delay enabled always.

However the bit shift for enabling buck4 ramp delay in register is equal
to 0. When ramp delay was set for the bucks unsupporting enable/disable
(buck[56789] and buck10), the ramp delay for buck4 was also enabled.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: f7b1a8dc1c1c ("regulator: s2mpa01: Don't check enable_shift before setting enable ramp rate")
---

Changes since v2:
 * Apply Axel Lin's suggestion (don't change the meaning
   of enable_shift variable).

---
 drivers/regulator/s2mpa01.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index f19a30f0fb42..cab1a2b9efc5 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -192,11 +192,15 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	if (!ramp_enable)
 		goto ramp_disable;
 
-	ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
-				 1 << enable_shift, 1 << enable_shift);
-	if (ret) {
-		dev_err(&rdev->dev, "failed to enable ramp rate\n");
-		return ret;
+	/* Ramp delay can be enabled/disabled only for buck[1234] */
+	if (rdev_get_id(rdev) >= S2MPA01_BUCK1 &&
+			rdev_get_id(rdev) <= S2MPA01_BUCK4) {
+		ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
+					 1 << enable_shift, 1 << enable_shift);
+		if (ret) {
+			dev_err(&rdev->dev, "failed to enable ramp rate\n");
+			return ret;
+		}
 	}
 
 	ramp_val = get_ramp_delay(ramp_delay);
-- 
1.9.1

