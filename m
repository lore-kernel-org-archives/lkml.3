Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaCRK7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:59:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42385 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755246AbaCRK6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:58:04 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] regulator: arizona-ldo1: Add processing of init_data from device tree
Date: Tue, 18 Mar 2014 10:49:13 +0000
Message-Id: <1395139757-6907-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |    7 +++++
 drivers/regulator/arizona-ldo1.c                  |   26 +++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 36a0c3d..d78f1aa 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,13 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - wlf,ldo1 : Initial data for the LDO1 regulator, as covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
+
+  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
+    externally supplied. As covered in
+    Documentation/devicetree/bindings/regulator/regulator.txt
+
 Example:
 
 codec: wm5102@1a {
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 6379fd3..a67013f 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
@@ -184,9 +185,34 @@ static const struct regulator_init_data arizona_ldo1_default = {
 static int arizona_ldo1_get_pdata(struct arizona *arizona,
 				  struct regulator_config *config)
 {
+	struct arizona_pdata *pdata = &arizona->pdata;
+	struct arizona_ldo1 *ldo1 = config->driver_data;
+	struct device_node *np_init, *np_dcvdd;
+
 	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true,
 				  &config->ena_gpio);
 
+	np_init = of_get_child_by_name(arizona->dev->of_node, "wlf,ldo1");
+	np_dcvdd = of_parse_phandle(arizona->dev->of_node, "DCVDD-supply", 0);
+
+	if (np_init) {
+		config->of_node = np_init;
+
+		pdata->ldo1 = of_get_regulator_init_data(arizona->dev, np_init);
+
+		if (np_dcvdd) {
+			if (np_dcvdd != np_init)
+				arizona->external_dcvdd = true;
+		} else {
+			pdata->ldo1->consumer_supplies = &ldo1->supply;
+			pdata->ldo1->num_consumer_supplies = 1;
+		}
+
+		config->init_data = pdata->ldo1;
+	} else if (np_dcvdd) {
+		arizona->external_dcvdd = true;
+	}
+
 	return 0;
 }
 #else
-- 
1.7.2.5

