Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3APNyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:54:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42815 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab3APNyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:54:08 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH v2 05/11] mfd: twl-core: Allocate twl_modules dynamically
Date: Wed, 16 Jan 2013 14:53:53 +0100
Message-ID: <1358344439-23017-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At boot time we can allocate the twl_modules array dynamically based on the
twl class we are using with devm_kzalloc() instead of the static
twl_modules[] array.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index f07317b..fbff830 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -66,8 +66,6 @@
 
 /* Triton Core internal information (BEGIN) */
 
-#define TWL_NUM_SLAVES		4
-
 /* Base Address defns for twl4030_map[] */
 
 /* subchip/slave 0 - USB ID */
@@ -162,7 +160,7 @@ struct twl_client {
 	struct regmap *regmap;
 };
 
-static struct twl_client twl_modules[TWL_NUM_SLAVES];
+static struct twl_client *twl_modules;
 
 /* mapping the module id to slave id and base address */
 struct twl_mapping {
@@ -284,6 +282,14 @@ static struct regmap_config twl6030_regmap_config[3] = {
 
 /*----------------------------------------------------------------------*/
 
+static inline int twl_get_num_slaves(void)
+{
+	if (twl_class_is_4030())
+		return 4; /* TWL4030 class have four slave address */
+	else
+		return 3; /* TWL6030 class have three slave address */
+}
+
 static inline int twl_get_last_module(void)
 {
 	if (twl_class_is_4030())
@@ -1127,17 +1133,15 @@ static int twl_remove(struct i2c_client *client)
 	unsigned i, num_slaves;
 	int status;
 
-	if (twl_class_is_4030()) {
+	if (twl_class_is_4030())
 		status = twl4030_exit_irq();
-		num_slaves = TWL_NUM_SLAVES;
-	} else {
+	else
 		status = twl6030_exit_irq();
-		num_slaves = TWL_NUM_SLAVES - 1;
-	}
 
 	if (status < 0)
 		return status;
 
+	num_slaves = twl_get_num_slaves();
 	for (i = 0; i < num_slaves; i++) {
 		struct twl_client	*twl = &twl_modules[i];
 
@@ -1215,12 +1219,19 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			twl_map[TWL_MODULE_MAIN_CHARGE].base =
 							TWL6025_BASEADD_CHARGER;
 		twl_regmap_config = twl6030_regmap_config;
-		num_slaves = TWL_NUM_SLAVES - 1;
 	} else {
 		twl_id = TWL4030_CLASS_ID;
 		twl_map = &twl4030_map[0];
 		twl_regmap_config = twl4030_regmap_config;
-		num_slaves = TWL_NUM_SLAVES;
+	}
+
+	num_slaves = twl_get_num_slaves();
+	twl_modules = devm_kzalloc(&client->dev,
+				   sizeof(struct twl_client) * num_slaves,
+				   GFP_KERNEL);
+	if (!twl_modules) {
+		status = -ENOMEM;
+		goto free;
 	}
 
 	for (i = 0; i < num_slaves; i++) {
-- 
1.8.1

