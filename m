Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3IWSl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:41:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54362 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478Ab3IWSlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:41:53 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 5/5] mfd: arizona: Add device tree bindings for MICBIAS generators
Date: Mon, 23 Sep 2013 19:30:43 +0100
Message-Id: <1379961043-23762-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings for the pdata needed to configure the MICBIAS
generators.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   15 ++++++++++++
 drivers/mfd/arizona-core.c                        |   25 +++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 09e384c..20730dd 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -64,6 +64,19 @@ Optional properties:
     The third cell represents the value of the micd-pol-gpio pin, a non-zero
     value indicates this should be on
 
+  - wlf,micbias1 : Configuration for the micbias regulator, should include 5
+    cells.
+    The first cell is the output voltage in millivolts
+    The second cell a non-zero value indicates an external capacitor is fitted
+    The third cell a non-zero value indicates the micbias should be actively
+    discharged
+    The four cell a non-zero value indicates that the micbias should be
+    brought up slowly to reduce pops
+    The fifth cell a non-zero value indicates the micbias should be bypassed
+    and simply output MICVDD
+  - wlf,micbias2 : See wlf,micbias1
+  - wlf,micbias3 : See wlf,micbias1
+
   - wlf,gpio-defaults : A list of GPIO configuration register values. If
     absent, no configuration of these registers is performed. If any
     entry has a value that is out of range for a 16 bit register then
@@ -106,6 +119,8 @@ codec: wm5102@1a {
 		0x0 2 1
 	>;
 
+	wlf,micbias2 = <2600 0 1 1 0>;
+
 	wlf,gpio-defaults = <
 		0x00000000 /* AIF1TXLRCLK */
 		0xffffffff
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index c8f30c4..6236e16 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -706,6 +706,27 @@ static int arizona_of_get_micd_configs(struct arizona *arizona,
 error:
 	devm_kfree(arizona->dev, micd_configs);
 	dev_err(arizona->dev, "DT property %s is malformed: %d\n", prop, ret);
+
+	return ret;
+}
+
+static int arizona_of_get_micbias(struct arizona *arizona,
+				  const char *prop, int index)
+{
+	int ret;
+	u32 micbias_config[5];
+
+	ret = arizona_of_read_u32_array(arizona, prop, false,
+					micbias_config,
+					ARRAY_SIZE(micbias_config));
+	if (ret >= 0) {
+		arizona->pdata.micbias[index].mV = micbias_config[0];
+		arizona->pdata.micbias[index].ext_cap = micbias_config[1];
+		arizona->pdata.micbias[index].discharge = micbias_config[2];
+		arizona->pdata.micbias[index].soft_start = micbias_config[3];
+		arizona->pdata.micbias[index].bypass = micbias_config[4];
+	}
+
 	return ret;
 }
 
@@ -741,6 +762,10 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 	arizona_of_get_micd_ranges(arizona, "wlf,micd-ranges");
 	arizona_of_get_micd_configs(arizona, "wlf,micd-configs");
 
+	arizona_of_get_micbias(arizona, "wlf,micbias1", 0);
+	arizona_of_get_micbias(arizona, "wlf,micbias2", 1);
+	arizona_of_get_micbias(arizona, "wlf,micbias3", 2);
+
 	arizona_of_get_gpio_defaults(arizona, "wlf,gpio-defaults");
 
 	arizona_of_read_u32_array(arizona, "wlf,max-channels-clocked",
-- 
1.7.2.5

