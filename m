Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbaJ2PLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:11:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47969 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465AbaJ2PLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:03 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-8e-54510384970b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/8] regulator: max77686: Consistently index opmode array by
 rdev id
Date: Wed, 29 Oct 2014 16:06:39 +0100
Message-id: <1414595206-1437-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
References: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7otzIEhBnf+KFtsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKuLl8N2vBda6Khwf2sDcwPuHo
	YuTkkBAwkVjwagsjhC0mceHeerYuRi4OIYGljBIvz7WzQjh9TBIdc5axglSxCRhLbF6+BKxK
	RKCTWaLnYC8ziMMssJpJ4ueVU8wgVcICkRLH159gAbFZBFQl1s4/xgRi8wq4SRxddoQJYp+c
	xMljk8Gmcgq4Syxs+QB2hxBQzdtlk1gmMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7
	iRES5F92MC4+ZnWIUYCDUYmH12FjQIgQa2JZcWXuIUYJDmYlEd7Pv4BCvCmJlVWpRfnxRaU5
	qcWHGJk4OKUaGJ1SEpctEvh4jGff1BndAmwf3nX+uO96RIUr7rHPrpLHmzWWskw8cj/k5I1k
	4UeMM33L325/L39RgLfpN5vbmVkvPs6Zc3Ojx0odLZfze5733BK6yHz5dV5BvIXko4wnlx+H
	pq88KbnWpvTEV87vgUx+sv1Rri41X3+v/9rBei7YoY/XqX5llo8SS3FGoqEWc1FxIgDM/Tde
	UAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mixed indexes were used for array of opmodes in max77686_data structure:
id of regulator and index of regulator_desc array.

These indexes are exactly the same but the mixture may confuse. Use
consistently the id of regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 09b0d8c20a9d..27c5f4556044 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -82,6 +82,7 @@ enum max77686_ramp_rate {
 };
 
 struct max77686_data {
+	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77686_REGULATORS];
 };
 
@@ -513,12 +514,13 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
 		struct regulator_dev *rdev;
+		int id = regulators[i].id;
 
 		config.init_data = pdata->regulators[i].initdata;
 		config.of_node = pdata->regulators[i].of_node;
 
-		max77686->opmode[i] = regulators[i].enable_mask >>
-						max77686_get_opmode_shift(i);
+		max77686->opmode[id] = regulators[i].enable_mask >>
+						max77686_get_opmode_shift(id);
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.9.1

