Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3IWSm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:42:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54347 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068Ab3IWSlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:41:52 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] mfd: arizona: Add micdet ranges and polarity device tree bindings
Date: Mon, 23 Sep 2013 19:30:42 +0100
Message-Id: <1379961043-23762-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings for the pdata that configures the microphone
button detection and microphone detection polarity configurations.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   26 +++++
 drivers/mfd/arizona-core.c                        |  116 +++++++++++++++++++++
 2 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 3ee659d..09e384c 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -49,6 +49,20 @@ Optional properties:
     milliseconds
   - wlf,micd-force-micbias : Force MICBIAS continuously on during microphone
     detection
+  - wlf,micd-ranges : Microphone detection level and key configuration, this
+    field can be of variable length but should always be a multiple of 2 cells
+    long, each two cell group represents one button configuration
+    The first cell is the maximum impedance for this button in ohms
+    The second cell the key that should be reported to the input layer
+  - wlf,micd-configs : Headset polarity configurations, the field can be of
+    variable length but should always be a multiple of 3 cells long, each two
+    cell group represents one polarity configration
+    The first cell is the accessory detection source as per the ACCDET_SRC bits
+    in the ACCESSORY_DETECT_MODE_1 register
+    The second cell represents the MICBIAS to be used as per the MICD_BIAS_SRC
+    bits in the MIC_DETECT_1 register
+    The third cell represents the value of the micd-pol-gpio pin, a non-zero
+    value indicates this should be on
 
   - wlf,gpio-defaults : A list of GPIO configuration register values. If
     absent, no configuration of these registers is performed. If any
@@ -79,6 +93,18 @@ codec: wm5102@1a {
 	wlf,micd-dbtime = <0x1>;
 	wlf,micd-timeout = <10>;
 	wlf,micd-force-micbias;
+	wlf,micd-ranges = <
+		11 0x100
+		28 0x101
+		54 0x102
+		100 0x103
+		186 0x104
+		430 0x105
+	>;
+	wlf,micd-configs = <
+		0x1 1 0
+		0x0 2 1
+	>;
 
 	wlf,gpio-defaults = <
 		0x00000000 /* AIF1TXLRCLK */
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 1cc6aa0..c8f30c4 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -596,6 +596,119 @@ static int arizona_of_get_gpio_defaults(struct arizona *arizona,
 	return ret;
 }
 
+static int arizona_of_get_u32_num_groups(struct arizona *arizona,
+					const char *prop,
+					int group_size)
+{
+	int len_prop;
+	int num_groups;
+
+	if (!of_get_property(arizona->dev->of_node, prop, &len_prop))
+		return -EINVAL;
+
+	num_groups =  len_prop / (group_size * sizeof(u32));
+
+	if (num_groups * group_size * sizeof(u32) != len_prop) {
+		dev_err(arizona->dev,
+			"DT property %s is malformed: %d\n",
+			prop, -EOVERFLOW);
+		return -EOVERFLOW;
+	}
+
+	return num_groups;
+}
+
+static int arizona_of_get_micd_ranges(struct arizona *arizona,
+				      const char *prop)
+{
+	int nranges;
+	int i, j;
+	int ret = 0;
+	u32 value;
+	struct arizona_micd_range *micd_ranges;
+
+	nranges = arizona_of_get_u32_num_groups(arizona, prop, 2);
+	if (nranges < 0)
+		return nranges;
+
+	micd_ranges = devm_kzalloc(arizona->dev,
+				   nranges * sizeof(struct arizona_micd_range),
+				   GFP_KERNEL);
+
+	for (i = 0, j = 0; i < nranges; ++i) {
+		ret = of_property_read_u32_index(arizona->dev->of_node,
+						 prop, j++, &value);
+		if (ret < 0)
+			goto error;
+		micd_ranges[i].max = value;
+
+		ret = of_property_read_u32_index(arizona->dev->of_node,
+						 prop, j++, &value);
+		if (ret < 0)
+			goto error;
+		micd_ranges[i].key = value;
+	}
+
+	arizona->pdata.micd_ranges = micd_ranges;
+	arizona->pdata.num_micd_ranges = nranges;
+
+	return ret;
+
+error:
+	devm_kfree(arizona->dev, micd_ranges);
+	dev_err(arizona->dev, "DT property %s is malformed: %d\n", prop, ret);
+	return ret;
+}
+
+static int arizona_of_get_micd_configs(struct arizona *arizona,
+				       const char *prop)
+{
+	int nconfigs;
+	int i, j;
+	int ret = 0;
+	u32 value;
+	struct arizona_micd_config *micd_configs;
+
+	nconfigs = arizona_of_get_u32_num_groups(arizona, prop, 3);
+	if (nconfigs < 0)
+		return nconfigs;
+
+	micd_configs = devm_kzalloc(arizona->dev,
+				    nconfigs *
+				    sizeof(struct arizona_micd_config),
+				    GFP_KERNEL);
+
+	for (i = 0, j = 0; i < nconfigs; ++i) {
+		ret = of_property_read_u32_index(arizona->dev->of_node,
+						 prop, j++, &value);
+		if (ret < 0)
+			goto error;
+		micd_configs[i].src = value;
+
+		ret = of_property_read_u32_index(arizona->dev->of_node,
+						 prop, j++, &value);
+		if (ret < 0)
+			goto error;
+		micd_configs[i].bias = value;
+
+		ret = of_property_read_u32_index(arizona->dev->of_node,
+						 prop, j++, &value);
+		if (ret < 0)
+			goto error;
+		micd_configs[i].gpio = value;
+	}
+
+	arizona->pdata.micd_configs = micd_configs;
+	arizona->pdata.num_micd_configs = nconfigs;
+
+	return ret;
+
+error:
+	devm_kfree(arizona->dev, micd_configs);
+	dev_err(arizona->dev, "DT property %s is malformed: %d\n", prop, ret);
+	return ret;
+}
+
 static int arizona_of_get_core_pdata(struct arizona *arizona)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
@@ -625,6 +738,9 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 		of_property_read_bool(arizona->dev->of_node,
 				      "wlf,micd-force-micbias");
 
+	arizona_of_get_micd_ranges(arizona, "wlf,micd-ranges");
+	arizona_of_get_micd_configs(arizona, "wlf,micd-configs");
+
 	arizona_of_get_gpio_defaults(arizona, "wlf,gpio-defaults");
 
 	arizona_of_read_u32_array(arizona, "wlf,max-channels-clocked",
-- 
1.7.2.5

