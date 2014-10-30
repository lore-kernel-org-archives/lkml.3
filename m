Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbaJ3LVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:21:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23538 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbaJ3LVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:24 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-96-54521f31066f
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
Subject: [PATCH v3 04/14] regulator: max77686: Consistently index opmode array
 by rdev id
Date: Thu, 30 Oct 2014 12:20:43 +0100
Message-id: <1414668053-31370-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7qG8kEhBqsnSltsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKuLl8N2vBda6Khwf2sDcwPuHo
	YuTkkBAwkZj2q5sFwhaTuHBvPRuILSSwlFFiwrXELkYuILuPSeLO0ZnsIAk2AWOJzcuXsIEk
	RAQ6mSV6DvYygzjMAquZJH5eOcUMUiUsEC2xcUozI4jNIqAq8XbLdDCbV8BdYvmSFVDr5CRO
	HpvMCmJzCnhIrPnYDmRzAK1zl7j3TXsCI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GCEB/nUH49JjVocYBTgYlXh4I44FhAixJpYVV+YeYpTgYFYS4V0tFhQixJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgZHzSWLFrXdiSo5/z76WXb/AoOm45v9PW1jWfY8SPlLqOaf6RneY1hvLGsXH
	fG7rzlXpGgfLvXXqbFgy7fx3U26p9QtufTxSv275BV9noWpLiVkWRtm1DVxV1ySnRZfO1cyU
	Mb+5wnRxQ4Pdc6E1detm6V2uUnq+cOnCzYE3/71bt3//niuT4zuUWIozEg21mIuKEwG5d0C7
	TgIAAA==
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

