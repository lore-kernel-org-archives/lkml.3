Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaDCKzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 06:55:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60090 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaDCKyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:54:50 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: twl6040: Optional clk32k clock handling
Date: Thu, 3 Apr 2014 13:54:42 +0300
Message-ID: <1396522482-32036-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396522482-32036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396522482-32036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain boards the source for the clk32k clock can be gated. In these
boards the clk32k clock can be provided to the driver and it is going to be
enabled/disabled when it is needed.
If the clk32k clock is not provided the driver will assume that it is always
running.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 Documentation/devicetree/bindings/mfd/twl6040.txt |  2 ++
 drivers/mfd/twl6040.c                             | 10 ++++++++++
 include/linux/mfd/twl6040.h                       |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/twl6040.txt b/Documentation/devicetree/bindings/mfd/twl6040.txt
index 0f5dd709d752..a41157b5d930 100644
--- a/Documentation/devicetree/bindings/mfd/twl6040.txt
+++ b/Documentation/devicetree/bindings/mfd/twl6040.txt
@@ -19,6 +19,8 @@ Required properties:
 
 Optional properties, nodes:
 - enable-active-high: To power on the twl6040 during boot.
+- clocks: phandle to the clk32k clock provider
+- clock-names: Must be "clk32k"
 
 Vibra functionality
 Required properties:
diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 2e6504a8e1e3..12b314ea48dc 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -291,6 +291,8 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 		if (twl6040->power_count++)
 			goto out;
 
+		clk_prepare_enable(twl6040->clk32k);
+
 		/* Allow writes to the chip */
 		regcache_cache_only(twl6040->regmap, false);
 
@@ -346,6 +348,8 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 
 		twl6040->sysclk = 0;
 		twl6040->mclk = 0;
+
+		clk_disable_unprepare(twl6040->clk32k);
 	}
 
 out:
@@ -644,6 +648,12 @@ static int twl6040_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, twl6040);
 
+	twl6040->clk32k = devm_clk_get(&client->dev, "clk32k");
+	if (IS_ERR(twl6040->clk32k)) {
+		dev_info(&client->dev, "clk32k is not handled\n");
+		twl6040->clk32k = NULL;
+	}
+
 	twl6040->supplies[0].supply = "vio";
 	twl6040->supplies[1].supply = "v2v1";
 	ret = devm_regulator_bulk_get(&client->dev, TWL6040_NUM_SUPPLIES,
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index a69d16b30c18..8f9fc3d26e6d 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -28,6 +28,7 @@
 #include <linux/interrupt.h>
 #include <linux/mfd/core.h>
 #include <linux/regulator/consumer.h>
+#include <linux/clk.h>
 
 #define TWL6040_REG_ASICID		0x01
 #define TWL6040_REG_ASICREV		0x02
@@ -223,6 +224,7 @@ struct twl6040 {
 	struct regmap *regmap;
 	struct regmap_irq_chip_data *irq_data;
 	struct regulator_bulk_data supplies[2]; /* supplies for vio, v2v1 */
+	struct clk *clk32k;
 	struct mutex mutex;
 	struct mutex irq_mutex;
 	struct mfd_cell cells[TWL6040_CELLS];
-- 
1.9.1

