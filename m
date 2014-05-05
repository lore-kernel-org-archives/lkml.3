Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaEEPKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:10:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16935 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbaEEPKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:10:05 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-74-5367a9ca2345
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] regulator: s2mpa01: Fix accidental enable of buck4 ramp
 delay
Date: Mon, 05 May 2014 17:10:03 +0200
Message-id: <1399302603-1427-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
References: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7qnVqYHG5y9rmBxZM5XZoupD5+w
	Wbx+YWjx7UoHk8XlXXPYLE7+6WW0uLjiC5MDu8fOWXfZPdp+lnlsWtXJ5nHn2h42j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MrY/3YmW8E/3orpb24wNjAe5O5i5OSQEDCRODN7HiOELSZx
	4d56ti5GLg4hgaWMEk13fjBBOH1MEgu+trKAVLEJGEtsXr4ErEpEYBujxIT+XiaQBLNAsMS6
	pyeBEhwcwgIhEj9uqICEWQRUJQ4sm8YKEuYVcJO4vVUKYpmcxMljk8HCnALuEhNXVoGYQkAV
	zx7ITWDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJKy+7mBceszqEKMAB6MSD6+H
	d0qwEGtiWXFl7iFGCQ5mJRHefUvSg4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwZljv/q1z9qRd
	Dk9k+xn7K++sC2Na4l937Q++7tnxYMv3HwV7efq+803s6l3MO89C7iWn6OGa2pUzF+hXf/Nb
	0RP2+LBZglzXkuQvMxkC/VdEfimI2mQipbJ5wy+zff+292vwWtUYnpj+JUQk3XiS6q/nzxv/
	37rwJOBXlnPdkowr/0+Iaz5QU2Ipzkg01GIuKk4EAKlojwsJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S2MPA01 supports enabling/disabling ramp delay only for buck[1234].
Other bucks have ramp delay enabled always.

However the bit shift for enabling buck4 ramp delay in register is equal
to 0. When ramp delay was set for these other bucks (buck[56789] and
buck10), the ramp delay for buck4 was also enabled.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: f7b1a8dc1c1c ("regulator: s2mpa01: Don't check enable_shift before setting enable ramp rate")
---
 drivers/regulator/s2mpa01.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index f19a30f0fb42..901504880ab6 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -99,7 +99,8 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	struct s2mpa01_info *s2mpa01 = rdev_get_drvdata(rdev);
 	unsigned int ramp_val, ramp_shift, ramp_reg = S2MPA01_REG_RAMP2;
-	unsigned int ramp_enable = 1, enable_shift = 0;
+	unsigned int ramp_enable = 1;
+	int enable_shift = -1;
 	int ret;
 
 	switch (rdev->desc->id) {
@@ -192,11 +193,13 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	if (!ramp_enable)
 		goto ramp_disable;
 
-	ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
-				 1 << enable_shift, 1 << enable_shift);
-	if (ret) {
-		dev_err(&rdev->dev, "failed to enable ramp rate\n");
-		return ret;
+	if (enable_shift >= 0) {
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

