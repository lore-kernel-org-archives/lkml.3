Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaKCOHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:07:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65070 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaKCOHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:07:17 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d1-54578c126bb6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] regulator: max77693: Fix use of uninitialized regulator config
Date: Mon, 03 Nov 2014 15:07:05 +0100
Message-id: <1415023625-17921-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xK7pCPeEhBofeaVpMffiEzeL1C0OL
	b1c6mCwu75rDZrFg4yNGB1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	t462sRWc5qx4cnwtcwPjZI4uRk4OCQETie4Vz1ghbDGJC/fWs3UxcnEICSxllLh/+Ds7hNPH
	JHGm9RYTSBWbgLHE5uVL2EBsEYEMic3zpoJ1Mwt4Srz7+xCogYNDWMBfouWpMkiYRUBV4sT7
	S+wgNq+Au8T5x3uZIJbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxgh
	QfBlB+PiY1aHGAU4GJV4eCdcDgsRYk0sK67MPcQowcGsJML7LyU8RIg3JbGyKrUoP76oNCe1
	+BAjEwenVAOjJ8/Xizdu7f3b4G67bP6CxPD82dHbWv7pnXoatDr4E+P8ZRuS7kqr/DGeLc7w
	3bNfwaYl4nzPGrELF39k5Zs4zlv0SbdcLYC7eFu/5zOPtQfmzmpef92m9Xa92By5pXv1sgXt
	t7W9vyky88uMN816HApnBRbrpkd8DPjv+3syz8dZGupzhdZcUWIpzkg01GIuKk4EAGmKQW7g	AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver allocated on stack struct regulator_config but didn't initialize
it fully. Few fields (driver_data, ena_gpio) were left untouched. This
lead to using random ena_gpio values as GPIOs for max77693 regulators.

On occasion these values could match real GPIO numbers leading to
interfering with other drivers and to unsuccessful enable/disable of
regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 80b022e29bfd ("regulator: max77693: Add max77693 regualtor driver.")
Cc: <stable@vger.kernel.org>
---
 drivers/regulator/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 177dd9d2ce67..7b9755a6c3b5 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -227,7 +227,7 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	struct max77693_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max77693_regulator_data *rdata = NULL;
 	int num_rdata, i;
-	struct regulator_config config;
+	struct regulator_config config = { };
 
 	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
 	if (!rdata || num_rdata <= 0) {
-- 
1.9.1

