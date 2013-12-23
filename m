Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab3LWIzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:55:15 -0500
Received: from [216.32.180.184] ([216.32.180.184]:10871 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab3LWIzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:55:13 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Anson Huang <b20788@freescale.com>
To: <shawn.guo@linaro.org>, <rui.zhang@intel.com>, <eduardo.valentin@ti.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] thermal: imx: correct suspend/resume flow
Date: Mon, 23 Dec 2013 15:51:58 -0500
Message-ID: <1387831918-17028-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current imx thermal sensor's suspend function will return fail if
thermal sensor is always enabled, but because alarm function is enabled,
thermal sensor will be always enabled as well, hence break system's suspend,
this patch will disable thermal sensor before suspend and re-enable it
after resume, it fixes the failure of suspend/resume caused by thermal driver.

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 drivers/thermal/imx_thermal.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index cbb16f3..9a9a6c2 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -510,27 +510,30 @@ static int imx_thermal_suspend(struct device *dev)
 {
 	struct imx_thermal_data *data = dev_get_drvdata(dev);
 	struct regmap *map = data->tempmon;
-	u32 val;
 
-	regmap_read(map, TEMPSENSE0, &val);
-	if ((val & TEMPSENSE0_POWER_DOWN) == 0) {
-		/*
-		 * If a measurement is taking place, wait for a long enough
-		 * time for it to finish, and then check again.  If it still
-		 * does not finish, something must go wrong.
-		 */
-		udelay(50);
-		regmap_read(map, TEMPSENSE0, &val);
-		if ((val & TEMPSENSE0_POWER_DOWN) == 0)
-			return -ETIMEDOUT;
-	}
+	/*
+	 * Need to disable thermal sensor, otherwise, when thermal core
+	 * try to get temperature before thermal sensor resume, a wrong
+	 * temperature will be read as the thermal sensor is powered
+	 * down.
+	 */
+	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_MEASURE_TEMP);
+	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_POWER_DOWN);
+	data->mode = THERMAL_DEVICE_DISABLED;
 
 	return 0;
 }
 
 static int imx_thermal_resume(struct device *dev)
 {
-	/* Nothing to do for now */
+	struct imx_thermal_data *data = dev_get_drvdata(dev);
+	struct regmap *map = data->tempmon;
+
+	/* Enabled thermal sensor after resume */
+	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
+	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
+	data->mode = THERMAL_DEVICE_ENABLED;
+
 	return 0;
 }
 #endif
-- 
1.7.9.5


