Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaJNIdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:33:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21552 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaJNIdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:33:06 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-4a-543cdfbe8c7b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [RFT PATCH] power: bq2415x_charger: Properly handle ENODEV from
 power_supply_get_by_phandle
Date: Tue, 14 Oct 2014 10:32:53 +0200
Message-id: <1413275573-23014-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xa7r77tuEGMyZrm8x6cl7ZouJKycz
	W7x+YWhxedccNovPvUcYLU7vLrFYsPERowO7x85Zd9k9Nq/Q8ti0qpPNo2/LKkaPz5vkAlij
	uGxSUnMyy1KL9O0SuDKatvWwFpzjqjg1bwZLA+Mfji5GTg4JAROJlX9OsULYYhIX7q1n62Lk
	4hASWMoo8efpRiYIp49J4uzqd8wgVWwCxhKbly8BqxIR2M0oMWHqchaQBLOAp8S7vw/ZQWxh
	gTSJ7mlrGUFsFgFViSWHf4PZvALuEjP2XWGGWCcncfLYZNYJjNwLGBlWMYqmliYXFCel5xrp
	FSfmFpfmpesl5+duYoSEyNcdjEuPWR1iFOBgVOLhLYi0CRFiTSwrrsw9xCjBwawkwmu8ECjE
	m5JYWZValB9fVJqTWnyIkYmDU6qBMW6vtb9sg8W+r4t/Xg5+X1DDrjPrt7yCnY5azCeuuw9+
	1t0MPfBl1a+X/59zvfrR0DpXYcrdkHf/9X+py7XYZdvVywrvzb3AeWuV47S3TY+BbvMttbzl
	dkf3wOvnfJuNZTsz5vSI1i9jYotvu5nY9U9o1f/3nTversrPuJy3NSdsxczMX8zeSizFGYmG
	WsxFxYkApo3A1O8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power_supply_get_by_phandle() on error returns ENODEV or NULL.
The driver later expects obtained pointer to power supply to be
valid or NULL. If it is not NULL then it dereferences it in
bq2415x_notifier_call() which would lead to dereferencing ENODEV-value
pointer.

Properly handle the power_supply_get_by_phandle() error case and abort probe.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: faffd234cf85 ("bq2415x_charger: Add DT support")
Cc: <stable@vger.kernel.org>
---
 drivers/power/bq2415x_charger.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index e384844a1ae1..d9c457217b6a 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1579,8 +1579,13 @@ static int bq2415x_probe(struct i2c_client *client,
 	if (np) {
 		bq->notify_psy = power_supply_get_by_phandle(np, "ti,usb-charger-detection");
 
-		if (!bq->notify_psy)
+		if (!bq->notify_psy) {
 			return -EPROBE_DEFER;
+		} else if (IS_ERR(bq->notify_psy)) {
+			dev_err(&client->dev, "no 'ti,usb-charger-detection' property\n");
+			ret = PTR_ERR(bq->notify_psy);
+			goto error_2;
+		}
 	}
 	else if (pdata->notify_device)
 		bq->notify_psy = power_supply_get_by_name(pdata->notify_device);
-- 
1.9.1

