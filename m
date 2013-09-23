Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab3IWSls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:41:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54311 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab3IWSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:41:46 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 1/5] mfd: arizona: Add device tree helper functions
Date: Mon, 23 Sep 2013 19:30:39 +0100
Message-Id: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out reading of specific device tree bindings into seperate
functions in preperation for adding more of them. Whilst we are at is
fixup a couple of small issues in the existing binding documentation.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   12 +-
 drivers/mfd/arizona-core.c                        |  121 +++++++++++++++------
 2 files changed, 95 insertions(+), 38 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 0e295c9..e2cecfc 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -25,7 +25,7 @@ Required properties:
   - #gpio-cells : Must be 2. The first cell is the pin number and the
     second cell is used to specify optional parameters (currently unused).
 
-  - AVDD1-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
+  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
     SPKVDDL-supply, SPKVDDR-supply : power supplies for the device, as covered
     in Documentation/devicetree/bindings/regulator/regulator.txt
 
@@ -53,10 +53,10 @@ codec: wm5102@1a {
 	#gpio-cells = <2>;
 
 	wlf,gpio-defaults = <
-		0x00000000, /* AIF1TXLRCLK */
-		0xffffffff,
-		0xffffffff,
-		0xffffffff,
-		0xffffffff,
+		0x00000000 /* AIF1TXLRCLK */
+		0xffffffff
+		0xffffffff
+		0xffffffff
+		0xffffffff
 	>;
 };
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 5ac3aa4..986abc5 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -512,42 +512,99 @@ int arizona_of_get_type(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(arizona_of_get_type);
 
-static int arizona_of_get_core_pdata(struct arizona *arizona)
+static int arizona_of_get_named_gpio(struct arizona *arizona,
+				     const char *prop, bool mandatory,
+				     int *gpio)
 {
-	int ret, i;
+	int ret;
 
-	arizona->pdata.reset = of_get_named_gpio(arizona->dev->of_node,
-						 "wlf,reset", 0);
-	if (arizona->pdata.reset < 0)
-		arizona->pdata.reset = 0;
-
-	arizona->pdata.ldoena = of_get_named_gpio(arizona->dev->of_node,
-						  "wlf,ldoena", 0);
-	if (arizona->pdata.ldoena < 0)
-		arizona->pdata.ldoena = 0;
-
-	ret = of_property_read_u32_array(arizona->dev->of_node,
-					 "wlf,gpio-defaults",
-					 arizona->pdata.gpio_defaults,
-					 ARRAY_SIZE(arizona->pdata.gpio_defaults));
-	if (ret >= 0) {
-		/*
-		 * All values are literal except out of range values
-		 * which are chip default, translate into platform
-		 * data which uses 0 as chip default and out of range
-		 * as zero.
-		 */
-		for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
-			if (arizona->pdata.gpio_defaults[i] > 0xffff)
-				arizona->pdata.gpio_defaults[i] = 0;
-			if (arizona->pdata.gpio_defaults[i] == 0)
-				arizona->pdata.gpio_defaults[i] = 0x10000;
-		}
-	} else {
-		dev_err(arizona->dev, "Failed to parse GPIO defaults: %d\n",
-			ret);
+	ret = of_get_named_gpio(arizona->dev->of_node, prop, 0);
+	*gpio = ret;
+	if (ret >= 0)
+		return ret;
+
+	*gpio = 0;
+
+	if (mandatory)
+		dev_err(arizona->dev,
+			"Mandatory DT gpio %s missing/malformed: %d\n",
+			prop, ret);
+
+	return ret;
+}
+
+static int arizona_of_read_u32_array(struct arizona *arizona,
+				     const char *prop, bool mandatory,
+				     u32 *data, size_t num)
+{
+	int ret;
+
+	ret = of_property_read_u32_array(arizona->dev->of_node, prop,
+					 data, num);
+
+	if (ret >= 0)
+		return 0;
+
+	switch (ret) {
+	case -EINVAL:
+		if (mandatory)
+			dev_err(arizona->dev,
+				"Mandatory DT property %s is missing\n",
+				prop);
+		break;
+	default:
+		dev_err(arizona->dev,
+			"DT property %s is malformed: %d\n",
+			prop, ret);
 	}
 
+	return ret;
+}
+
+static int arizona_of_read_u32(struct arizona *arizona,
+			       const char* prop, bool mandatory,
+			       u32 *data)
+{
+	return arizona_of_read_u32_array(arizona, prop, mandatory, data, 1);
+}
+
+static int arizona_of_get_gpio_defaults(struct arizona *arizona,
+					const char *prop)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+	int i, ret;
+
+	ret = arizona_of_read_u32_array(arizona, prop, false,
+					pdata->gpio_defaults,
+					ARRAY_SIZE(pdata->gpio_defaults));
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * All values are literal except out of range values
+	 * which are chip default, translate into platform
+	 * data which uses 0 as chip default and out of range
+	 * as zero.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
+		if (pdata->gpio_defaults[i] > 0xffff)
+			pdata->gpio_defaults[i] = 0;
+		if (pdata->gpio_defaults[i] == 0)
+			pdata->gpio_defaults[i] = 0x10000;
+	}
+
+	return ret;
+}
+
+static int arizona_of_get_core_pdata(struct arizona *arizona)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+
+	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
+	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
+
+	arizona_of_get_gpio_defaults(arizona, "wlf,gpio-defaults");
+
 	return 0;
 }
 
-- 
1.7.2.5

