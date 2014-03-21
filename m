Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbaCUIQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:16:37 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54639 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124AbaCUIQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:16:30 -0400
Message-ID: <1395389784.29259.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: s2mps11: Don't check enable_shift before
 setting enable ramp rate
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 16:16:24 +0800
In-Reply-To: <1395389720.29259.1.camel@phoenix>
References: <1395389720.29259.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code misses updating the register when enable_shift is 0.
e.g. S2MPS11_BUCK9_RAMP_SHIFT and S2MPS11_BUCK6_RAMP_EN_SHIFT are 0.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s2mps11.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 68fd547..e713c16 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -202,13 +202,11 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	if (!ramp_enable)
 		goto ramp_disable;
 
-	if (enable_shift) {
-		ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
-					1 << enable_shift, 1 << enable_shift);
-		if (ret) {
-			dev_err(&rdev->dev, "failed to enable ramp rate\n");
-			return ret;
-		}
+	ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
+				 1 << enable_shift, 1 << enable_shift);
+	if (ret) {
+		dev_err(&rdev->dev, "failed to enable ramp rate\n");
+		return ret;
 	}
 
 	ramp_val = get_ramp_delay(ramp_delay);
-- 
1.8.3.2



