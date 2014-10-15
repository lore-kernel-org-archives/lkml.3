Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaJOOZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:25:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15578 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJOOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:25:22 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-5b-543e83d0c58f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] power: bq2415x_charger: Properly handle ENODEV from
 power_supply_get_by_phandle
Date: Wed, 15 Oct 2014 16:25:09 +0200
Message-id: <1413383110-20310-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xq7oXmu1CDBpvclhMevKe2WLiysnM
	Fq9fGFpc3jWHzeJz7xFGi9O7SywWbHzE6MDusXPWXXaPzSu0PDat6mTz6NuyitHj8ya5ANYo
	LpuU1JzMstQifbsErowJyy6wFizmq1h6fA9bA+MH7i5GTg4JAROJOzdXMEPYYhIX7q1nA7GF
	BJYyStzc6tDFyAVk9zFJtJ67ygSSYBMwlti8fAkbSEJEYDejxISpy1lAEswCnhLv/j5kB7GF
	BTIlrj97CDaVRUBVYu2MS2A1vALuEu1PJ7FBbJOTOHlsMusERu4FjAyrGEVTS5MLipPSc430
	ihNzi0vz0vWS83M3MUIC5OsOxqXHrA4xCnAwKvHwchywDRFiTSwrrsw9xCjBwawkwjs/wS5E
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA6PZvxDe0q+l3hz/DrCfm5SWcObr1Ac/O/49Fp14pWau
	eujrmc6XlPZ+5P8ssXXK6wT/pW3+RXbGZ18eNu//qcSl94N3n+y5wNwnlxXYxQ1kLl2SfxN8
	tO3Cpadsu/KCJ+6+9tL65CHesx4twovmdDWdK62YUSHsqPX1LdulS72TFj8+oORUuX6iEktx
	RqKhFnNRcSIAzNvyou4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power_supply_get_by_phandle() on error returns ENODEV or NULL.
The driver later expects obtained pointer to power supply to be
valid or NULL. If it is not NULL then it dereferences it in
bq2415x_notifier_call() which would lead to dereferencing ENODEV-value
pointer.

Properly handle the power_supply_get_by_phandle() error case by
replacing error value with NULL. This indicates that usb charger
detection won't be used.

Fix also memory leak of 'name' if power_supply_get_by_phandle() fails
with NULL and probe should defer.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: faffd234cf85 ("bq2415x_charger: Add DT support")
Cc: <stable@vger.kernel.org>

---

Changes since v1:
1. Fix memory leak in probe defer (goto error_2) (suggested by Sebastian
   Reichel).
2. Don't fail the probe if 'ti,usb-charger-detection' is not present.
   Just print message.
---
 drivers/power/bq2415x_charger.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index e384844a1ae1..edf945a5260f 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1579,8 +1579,15 @@ static int bq2415x_probe(struct i2c_client *client,
 	if (np) {
 		bq->notify_psy = power_supply_get_by_phandle(np, "ti,usb-charger-detection");
 
-		if (!bq->notify_psy)
-			return -EPROBE_DEFER;
+		if (IS_ERR(bq->notify_psy)) {
+			bq->notify_psy = NULL;
+			dev_info(&client->dev,
+				"no 'ti,usb-charger-detection' property (err=%ld)\n",
+				PTR_ERR(bq->notify_psy));
+		} else if (!bq->notify_psy) {
+			ret = -EPROBE_DEFER;
+			goto error_2;
+		}
 	}
 	else if (pdata->notify_device)
 		bq->notify_psy = power_supply_get_by_name(pdata->notify_device);
-- 
1.9.1

