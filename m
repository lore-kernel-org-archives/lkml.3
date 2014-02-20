Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaBTPTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:19:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24636 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaBTPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:19:14 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-5e-53061cef2cca
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: max14577: Fix invalid return value on DT parse
 success
Date: Thu, 20 Feb 2014 16:19:01 +0100
Message-id: <1392909541-10285-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xq7rvZdiCDXZvsLCY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxrOLogUn
	OSrm37jM2sDYy97FyMkhIWAi0XlnAhuELSZx4d56IJuDQ0hgKaPEbtkuRi4gs49JYuaqZ6wg
	NWwCxhKbly8BqxcRyJDYPG8qWJxZwFDi57s/YDOFBUIkPu6czwRiswioShxp28MMYvMKuEvM
	PLGABWS+hICCxJxJNhMYuRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECPH61x2MS49Z
	HWIU4GBU4uE9KcUWLMSaWFZcmXuIUYKDWUmEN0oaKMSbklhZlVqUH19UmpNafIiRiYNTqoFx
	08bmxV8aE9frzS47GrA7PuiW1oVVhyoUrjSUWN14t/js3UenhTQ+rtm/X2Y669x3X0yfJv9P
	nMP49ueNv98eHD1nsGr++R8mwe6SkbN1GMM/Wx2pUPpUzmdXt9asq3fnwRSxrdk3P2VMk3ZO
	tNF95pD3ITUu27SmZPrtxeb/jOWqX7tnrtzWrMRSnJFoqMVcVJwIAHmd60/YAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes bug introduced in 667a6b7a (regulator: max14577: Add missing
of_node_put). The DTS parsing function returned number of matched
regulators as success status which then was compared against 0 in probe.

Result was a probe fail after successful parsing the DTS:
max14577-regulator: probe of max14577-regulator failed with error 2

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max14577.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 186df8785a91..6ba11a8dd23d 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -168,11 +168,13 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
 			MAX14577_REG_MAX);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
+		of_node_put(np);
+		return ret;
 	}
 
 	of_node_put(np);
 
-	return ret;
+	return 0;
 }
 
 static inline struct regulator_init_data *match_init_data(int index)
-- 
1.7.9.5

