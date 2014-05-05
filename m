Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbaEEPKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:10:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23937 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbaEEPKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:10:04 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-73-5367a9caff6b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] regulator: s2mps11: Fix accidental enable of buck6 ramp
 delay
Date: Mon, 05 May 2014 17:10:02 +0200
Message-id: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xy7qnVqYHG/y9zG5xZM5XZoupD5+w
	Wbx+YWjx7UoHk8XlXXPYLE7+6WW0uLjiC5MDu8fOWXfZPdp+lnlsWtXJ5nHn2h42j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mro7rrAWtDKV/H0yS22BsYT3F2MnBwSAiYSHX0fGSFsMYkL
	99azdTFycQgJLGWU2HHjNjuE08ckseBrKwtIFZuAscTm5UvAqkQEtjFKTOjvZQJJMAsES6x7
	epINxBYWCJF49H03kM3BwSKgKnGjG6yXV8BNYtGp5+wQ2+QkTh6bzDqBkXsBI8MqRtHU0uSC
	4qT0XCO94sTc4tK8dL3k/NxNjJBg+bqDcekxq0OMAhyMSjy8Ht4pwUKsiWXFlbmHGCU4mJVE
	ePctSQ8W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwOjAkH2bd1Paw5svDXNYb6geCNJcdWrC8Tu/
	OZh8Z96uTFlSMW3TtOMMFyIqehcqHV0nFXPpveOrAKYoQe+t+1IOLfnHFVIQ+bI2Y221qRHz
	7MATujtL1t2bEu68tC4z1dT5d2xzf1HQ6ayUp5GW5oz3toULL5wp9flNmqyszSKLOClTq/U3
	FiixFGckGmoxFxUnAgA2nvjK9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S2MPS11 supports enabling/disabling ramp delay only for buck[2346].
Other bucks have ramp delay enabled always.

However the bit shift for enabling buck6 ramp delay in register is equal
to 0. When ramp delay was set for these other bucks (buck[15789] and
buck10), the ramp delay for buck6 was also enabled.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: b96244fad953 ("regulator: s2mps11: Don't check enable_shift before setting enable ramp rate")
---
 drivers/regulator/s2mps11.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index e713c162fbd4..db677a4be4d3 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -110,7 +110,8 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
 	unsigned int ramp_val, ramp_shift, ramp_reg = S2MPS11_REG_RAMP_BUCK;
-	unsigned int ramp_enable = 1, enable_shift = 0;
+	unsigned int ramp_enable = 1;
+	int enable_shift = -1;
 	int ret;
 
 	switch (rdev_get_id(rdev)) {
@@ -202,11 +203,13 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	if (!ramp_enable)
 		goto ramp_disable;
 
-	ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
-				 1 << enable_shift, 1 << enable_shift);
-	if (ret) {
-		dev_err(&rdev->dev, "failed to enable ramp rate\n");
-		return ret;
+	if (enable_shift >= 0) {
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

