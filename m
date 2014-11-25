Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaKYKmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaKYKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sebastian Reichel <sre@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 155/254] power: bq2415x_charger: Fix memory leak on DTS parsing error
Date: Tue, 25 Nov 2014 10:38:25 +0000
Message-Id: <1416912004-5928-156-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 21e863b233553998737e1b506c823a00bf012e00 upstream.

Memory allocated for 'name' was leaking if required binding properties
were not present.

The memory for 'name' was allocated early at probe with kasprintf(). It
was freed in error paths executed before and after parsing DTS but not
in that error path.

Fix the error path for parsing device tree properties.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: faffd234cf85 ("bq2415x_charger: Add DT support")
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/power/bq2415x_charger.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 260795c6901a..1f49986fc605 100644
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
2.1.0

