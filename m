Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3LTJf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:35:28 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27066 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab3LTJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:35:24 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-25-52b40f5ab75e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] mfd: max77686: fix regmap resource leak on driver remove
Date: Fri, 20 Dec 2013 10:35:07 +0100
Message-id: <1387532108-9813-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJMWRmVeSWpSXmKPExsVy+t/xa7pR/FuCDG7dkLV4/cLQ4mzTG3aL
	+1+PMlpc3jWHzWLtkbvsFqe7WS0WbHzE6MDucefaHjaPeScDPfq2rGL0+LxJLoAlissmJTUn
	syy1SN8ugSvj5qbigmmcFZsmXWdrYHzK3sXIySEhYCJxbfF6NghbTOLCPRCbi0NIYCmjxM0T
	Z5kgnD4mid2HfrKCVLEJGEtsXr4ErENEIEvix7TVLCBFzCAdu7pmMoMkhAV8JY68bAUrYhFQ
	lVhxvhHM5hVwk1gw8xXQag6gdQoScybZTGDkXsDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/
	dxMjJCi+7GBcfMzqEKMAB6MSD2+D7eYgIdbEsuLK3EOMEhzMSiK8HM+BQrwpiZVVqUX58UWl
	OanFhxiZODilGhjFIllXSR9nO/7rb9Buju3xRSn1ll5ZnzLc10l2TTFXP9io+vCxZtuVsuqL
	67v6hB/OEgs+G2p69Zea29tfadF3f/5zOyt1nT+J+ytzUqy5rs+PJfVO1pH6UyM2TGA6tUNC
	/Pe7I+XL7tpGnP+rc6ht/q6uft5lD0sTnIQdy/RMne5k7FpjU6LEUpyRaKjFXFScCACh0l1j
	6AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap used by max77686 MFD driver was not freed with regmap_exit()
on driver exit. This lead to leak of resources.

Replace regmap_init_i2c() call in driver probe with initialization of
managed register map so the regmap will be properly freed by the device
management code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/max77686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 34520cbe8afb..12b3ae3aa7c5 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -104,7 +104,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->irq_gpio = pdata->irq_gpio;
 	max77686->irq = i2c->irq;
 
-	max77686->regmap = regmap_init_i2c(i2c, &max77686_regmap_config);
+	max77686->regmap = devm_regmap_init_i2c(i2c, &max77686_regmap_config);
 	if (IS_ERR(max77686->regmap)) {
 		ret = PTR_ERR(max77686->regmap);
 		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
-- 
1.7.9.5

