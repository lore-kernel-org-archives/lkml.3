Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaEGJwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:52:51 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27960 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaEGJwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:52:49 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-f9-536a026fb498
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [RFT PATCH] regulator: s2mpa01: Use correct register for buck[36] ramp
 delay
Date: Wed, 07 May 2014 11:52:38 +0200
Message-id: <1399456358-12168-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xy7r5TFnBBnc/aVtMffiEzeL1C0OL
	b1c6mCwu75rDZnHyTy+jxcUVX5gsFmx8xOjA7rFz1l12j02rOtk87lzbw+bRt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGVN/NLEUTOermH75LXsD4x7uLkZODgkBE4mPV8+zQNhiEhfurWfr
	YuTiEBJYyijRd3wCO4TTxyRx6sBnNpAqNgFjic3Ll4BViQhsY5R49+kqI0iCWcBT4t3fh0Ad
	HBzCAuESt+7qgIRZBFQl7je+YAaxeQXcJTbda4TaJidx8thk1gmM3AsYGVYxiqaWJhcUJ6Xn
	GuoVJ+YWl+al6yXn525ihATJlx2Mi49ZHWIU4GBU4uF9EZ0RLMSaWFZcmXuIUYKDWUmE1/Jv
	ZrAQb0piZVVqUX58UWlOavEhRiYOTqkGxvyaLydbJnxJaTymbqPqvWRJfIa+qbGI0935N29P
	51I47blpuUms8LYJvIpftriUHCpRmvByUoKJ3I/WyFOMHM/0tvxoMWjTcrq4c52xmKr9dr4N
	i2z/7fzMFLFURs1G/1NXdP2uQOnzz6K+Ve4K4K9OOHpMUezFT2PuVdNnzvCfzij5O6cpWIml
	OCPRUIu5qDgRANNaHt7wAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buck1 and buck6 share the field (offset 4) in ramp delay register
(S2MPA01_REG_RAMP1). The buck3 uses its own field in S2MPA01_REG_RAMP2
register, also at offset 4.

The driver interchanged the registers for ramp delay of buck3 and buck6.
This lead to updating ramp delay for wrong buck (buck3 instead of buck6
and vice versa).

Cc: <stable@vger.kernel.org>
Fixes: f18792714608 ("regulator: Add support for S2MPA01 regulator")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mpa01.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index f19a30f0fb42..67a5ab335dae 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -137,17 +137,16 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 		enable_shift = S2MPA01_BUCK3_RAMP_EN_SHIFT;
 		if (!ramp_delay) {
 			ramp_enable = 0;
 			break;
 		}
 
 		s2mpa01->ramp_delay3 = ramp_delay;
 		ramp_shift = S2MPA01_BUCK3_RAMP_SHIFT;
-		ramp_reg = S2MPA01_REG_RAMP1;
 		break;
 	case S2MPA01_BUCK4:
 		enable_shift = S2MPA01_BUCK4_RAMP_EN_SHIFT;
 		if (!ramp_delay) {
 			ramp_enable = 0;
 			break;
 		}
 
@@ -165,16 +164,17 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 		break;
 	case S2MPA01_BUCK6:
 		if (ramp_delay > s2mpa01->ramp_delay16)
 			s2mpa01->ramp_delay16 = ramp_delay;
 		else
 			ramp_delay = s2mpa01->ramp_delay16;
 
 		ramp_shift = S2MPA01_BUCK16_RAMP_SHIFT;
+		ramp_reg = S2MPA01_REG_RAMP1;
 		break;
 	case S2MPA01_BUCK7:
 		s2mpa01->ramp_delay7 = ramp_delay;
 		ramp_shift = S2MPA01_BUCK7_RAMP_SHIFT;
 		break;
 	case S2MPA01_BUCK8:
 	case S2MPA01_BUCK9:
 	case S2MPA01_BUCK10:
-- 
1.9.1

