Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbbA2Ojy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:39:54 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17035 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbbA2Ojv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:39:51 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7c-54ca45a3dd0b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Milo Kim <milo.kim@ti.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] power_supply: lp8788-charger: Fix leaked power supply on
 probe fail
Date: Thu, 29 Jan 2015 15:39:39 +0100
Message-id: <1422542379-8202-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1422542379-8202-1-git-send-email-k.kozlowski@samsung.com>
References: <1422542379-8202-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e/4Nd3FrqdCDPrui1hsnLGe1WLSk/fM
	FhNXTma2eP3C0OLyrjlsFp97jzBaLP+1jsXi9O4SiwUbHzE6cHrsnHWX3WPzCi2PTas62Tz6
	tqxi9Dh+YzuTx+dNcgFsUVw2Kak5mWWpRfp2CVwZH+c8YytYwFHxasZCtgbGHvYuRk4OCQET
	iTtXjzFD2GISF+6tZwOxhQSWMkrc2MHfxcgFZPcxSRy9sIgVJMEmYCyxefkSNpCEiMB1Rokr
	L48xgSSYBRoZJTbeVgCxhQWiJObvPQMWZxFQlVj64ifYBl4BN4mLc78xQmyTkzh5bDLQUA4O
	TgF3iX3LJCAWu0lM/drOOoGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkGD7soNx
	8TGrQ4wCHIxKPLwzN50MEWJNLCuuzD3EKMHBrCTCu9TyVIgQb0piZVVqUX58UWlOavEhRiYO
	TqkGxvl6F363d196UGacpzD/9P0S98sRnw8fksrhzvhoZVTx9MCJTcs8xQ5VHl6y7kZq7sZV
	S+et27P+eleXpq/UolOXl02Ua141ky9g/bQ9ubJ2ojy82srrhe+n7IoLldTiOevfW3b4xPbf
	+p61aSqdhqU/uUw1uVz/1ve5bi5qO3VLelNlR/p5NSWW4oxEQy3mouJEADXiYpkUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver forgot to unregister charger power supply if registering of
battery supply failed in probe(). In such case the memory associated
with power supply leaked.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 98a276649358 ("power_supply: Add new lp8788 charger driver")
Cc: <stable@vger.kernel.org>
---
 drivers/power/lp8788-charger.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
index 21fc233c7d61..176dab2e4c16 100644
--- a/drivers/power/lp8788-charger.c
+++ b/drivers/power/lp8788-charger.c
@@ -417,8 +417,10 @@ static int lp8788_psy_register(struct platform_device *pdev,
 	pchg->battery.num_properties = ARRAY_SIZE(lp8788_battery_prop);
 	pchg->battery.get_property = lp8788_battery_get_property;
 
-	if (power_supply_register(&pdev->dev, &pchg->battery))
+	if (power_supply_register(&pdev->dev, &pchg->battery)) {
+		power_supply_unregister(&pchg->charger);
 		return -EPERM;
+	}
 
 	return 0;
 }
-- 
1.9.1

