Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaJOOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:25:26 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37387 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaJOOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:25:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-97-543e83d03512
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] power: bq2415x_charger: Fix memory leak on DTS parsing
 error
Date: Wed, 15 Oct 2014 16:25:10 +0200
Message-id: <1413383110-20310-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413383110-20310-1-git-send-email-k.kozlowski@samsung.com>
References: <1413383110-20310-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xq7oXmu1CDA4fU7CY9OQ9s8XElZOZ
	LV6/MLS4vGsOm8Xn3iOMFqd3l1gs2PiI0YHdY+esu+wem1doeWxa1cnm0bdlFaPH501yAaxR
	XDYpqTmZZalF+nYJXBkP+j4yFjzlq3j8uYGlgfEfdxcjJ4eEgInEzp597BC2mMSFe+vZQGwh
	gaWMEhceZnQxcgHZfUwSreeuMoEk2ASMJTYvX8IGkhAR2M0oMWHqchaQBLOAp8S7vw+BJnFw
	CAuESfycbg4SZhFQldhw5TBYCa+Au8S7J6tZIJbJSZw8NpkVxOYU8JA4sXIPK0irEFDN2g+M
	Exh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICaYvOxgXH7M6xCjAwajEw8txwDZE
	iDWxrLgy9xCjBAezkgjv/AS7ECHelMTKqtSi/Pii0pzU4kOMTBycUg2MsY+NegOrmjI6kzZw
	TeL63L7ktv21pGR+tdmxi50tBT9IqT46W3oqOuQkc7DhXZapOitFU8NqDByLYwL87jafeBLF
	L1rYc/X31G13piR6mToHVJxc7mD50p5ZKnuhdfzLUw/OmCrfYOifesluyR9RzzDjjTz76o8z
	6f0zFN91Ounl0zzH+TFKLMUZiYZazEXFiQCTqstBBAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory allocated for 'name' was leaking if required binding properties
were not present.

The memory for 'name' was allocated early at probe with kasprintf(). It
was freed in error paths executed before and after parsing DTS but not
in that error path.

Fix the error path for parsing device tree properties.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: faffd234cf85 ("bq2415x_charger: Add DT support")
Cc: <stable@vger.kernel.org>

---

Changes since v1:
1. None, new patch.
---
 drivers/power/bq2415x_charger.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index edf945a5260f..311be01480c8 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1609,27 +1609,27 @@ static int bq2415x_probe(struct i2c_client *client,
 		ret = of_property_read_u32(np, "ti,current-limit",
 				&bq->init_data.current_limit);
 		if (ret)
-			return ret;
+			goto error_2;
 		ret = of_property_read_u32(np, "ti,weak-battery-voltage",
 				&bq->init_data.weak_battery_voltage);
 		if (ret)
-			return ret;
+			goto error_2;
 		ret = of_property_read_u32(np, "ti,battery-regulation-voltage",
 				&bq->init_data.battery_regulation_voltage);
 		if (ret)
-			return ret;
+			goto error_2;
 		ret = of_property_read_u32(np, "ti,charge-current",
 				&bq->init_data.charge_current);
 		if (ret)
-			return ret;
+			goto error_2;
 		ret = of_property_read_u32(np, "ti,termination-current",
 				&bq->init_data.termination_current);
 		if (ret)
-			return ret;
+			goto error_2;
 		ret = of_property_read_u32(np, "ti,resistor-sense",
 				&bq->init_data.resistor_sense);
 		if (ret)
-			return ret;
+			goto error_2;
 	} else {
 		memcpy(&bq->init_data, pdata, sizeof(bq->init_data));
 	}
-- 
1.9.1

