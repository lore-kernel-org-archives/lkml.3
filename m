Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaCRNLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:11:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31811 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbaCRNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:11:38 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f796d000005a13-36-5328460896fe
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: sec-core: Fix uninitialized 'regmap_rtc' on S2MPA01
Date: Tue, 18 Mar 2014 14:11:26 +0100
Message-id: <1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <20140318110947.GR25478@lee--X1>
References: <20140318110947.GR25478@lee--X1>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7ocbhrBBufei1lMffiEzWL+kXOs
	Fq9fGFrc/3qU0eLyrjlsFif/9DI6sHlsWtXJ5nHn2h42j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrYu76LpWAiZ8WWvmVsDYx72LsYOTkkBEwkppzYxQJhi0lcuLeerYuRi0NIYCmjxOuX
	V5lAErwCghI/Jt8DKuLgYBaQlzhyKRskzCygLjFp3iJmiPo+JoldG58wgyTYBIwlNi9fwgZS
	LyKgInHujTlIDbPAakaJ07eb2EBqhAU8JXYtvsIKYrMIqEpsnLqCCaSeV8BdYv57WRBTQkBB
	Ys4kG5AKTgFdiRcLVoFNFxLQkdhxZxvrBEaBWUiOm4Vw3Cwkxy1gZF7FKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJERLIX3YwLj5mdYhRgINRiYf3BZt6sBBrYllxZe4hRgkOZiURXnYrjWAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjOa+MkXTpXjdHecc0dph1dZ/mfdI4dKt2X+N9lt/4Lxw
	P+uJ6mLryjf9/x6d26/uud8hTO9P95q5bj/vGEhuZ+ybeaxizfq+k6ybttfOvXdUT2JPwudr
	LWYXbmoYS05qKphXekhGrHKT1pqq8O/PFJfnX+f4trTxiIjq07nP5b7sWhUUIHYvoFqJpTgj
	0VCLuag4EQA52KdiQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the 'regmap_rtc' on S2MPA01 to some sane value. Sane at least
for S5M87X chipsets, not S2MPS/S2MPA but it won't be used because
rtc-s5m driver does not support S2MPA01.

This fixes following error:
drivers/mfd/sec-core.c:342:45: warning: ‘regmap_rtc’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 281a827..f5e09d0 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -295,6 +295,13 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	switch (sec_pmic->device_type) {
 	case S2MPA01:
 		regmap = &s2mpa01_regmap_config;
+		/*
+		 * The rtc-s5m driver does not support S2MPA01 and there
+		 * is no mfd_cell for S2MPA01 RTC device.
+		 * However we must pass something to devm_regmap_init_i2c()
+		 * so use S5M-like regmap config even though it wouldn't work.
+		 */
+		regmap_rtc = &s5m_rtc_regmap_config;
 		break;
 	case S2MPS11X:
 		regmap = &s2mps11_regmap_config;
-- 
1.7.9.5

