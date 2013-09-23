Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3IWSml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:42:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54335 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab3IWSlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:41:50 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] mfd: arizona: Add simple microphone detection device tree bindings
Date: Mon, 23 Sep 2013 19:30:41 +0100
Message-Id: <1379961043-23762-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings for several of simpler microphone detection
pdata fields.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt |   23 +++++++++++++++++++++
 drivers/mfd/arizona-core.c                        |   22 ++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 9eeef62..3ee659d 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -34,6 +34,22 @@ Optional properties:
   - wlf,reset : GPIO specifier for the GPIO controlling /RESET
   - wlf,ldoena : GPIO specifier for the GPIO controlling LDOENA
 
+  - wlf,micd-detect-debounce : Additional software microphone detection
+    debounce specified in milliseconds
+  - wlf,micd-pol-gpio : GPIO specifier for the GPIO controlling the headset
+    polarity if one exists
+  - wlf,micd-bias-start-time : Time allowed for MICBIAS to startup prior to
+    performing microphone detection, specified as per the MICD_BIAS_STARTTIME
+    bits in the register MIC_DETECT_1
+  - wlf,micd-rate : Delay between successive microphone detection measurements,
+    specified as per the MICD_RATE bits in the register MIC_DETECT_1
+  - wlf,micd-dbtime : Microphone detection hardware debounce level, specified
+    as per the MICD_DBTIME bits in the register MIC_DETECT_1
+  - wlf,micd-timeout : Timeout for microphone detection, specified in
+    milliseconds
+  - wlf,micd-force-micbias : Force MICBIAS continuously on during microphone
+    detection
+
   - wlf,gpio-defaults : A list of GPIO configuration register values. If
     absent, no configuration of these registers is performed. If any
     entry has a value that is out of range for a 16 bit register then
@@ -57,6 +73,13 @@ codec: wm5102@1a {
 	gpio-controller;
 	#gpio-cells = <2>;
 
+	wlf,micd-detect-debounce = <10>;
+	wlf,micd-bias-start-time = <0x1>;
+	wlf,micd-rate = <0x1>;
+	wlf,micd-dbtime = <0x1>;
+	wlf,micd-timeout = <10>;
+	wlf,micd-force-micbias;
+
 	wlf,gpio-defaults = <
 		0x00000000 /* AIF1TXLRCLK */
 		0xffffffff
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index b3337ee..1cc6aa0 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -603,6 +603,28 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
 	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
 
+	arizona_of_read_u32(arizona, "wlf,micd-detect-debounce", false,
+			    &pdata->micd_detect_debounce);
+
+	arizona_of_get_named_gpio(arizona, "wlf,micd-pol-gpio", false,
+				  &pdata->micd_pol_gpio);
+
+	arizona_of_read_u32(arizona, "wlf,micd-bias-start-time", false,
+			    &pdata->micd_bias_start_time);
+
+	arizona_of_read_u32(arizona, "wlf,micd-rate", false,
+			    &pdata->micd_rate);
+
+	arizona_of_read_u32(arizona, "wlf,micd-dbtime", false,
+			    &pdata->micd_dbtime);
+
+	arizona_of_read_u32(arizona, "wlf,micd-timeout", false,
+			    &pdata->micd_timeout);
+
+	pdata->micd_force_micbias =
+		of_property_read_bool(arizona->dev->of_node,
+				      "wlf,micd-force-micbias");
+
 	arizona_of_get_gpio_defaults(arizona, "wlf,gpio-defaults");
 
 	arizona_of_read_u32_array(arizona, "wlf,max-channels-clocked",
-- 
1.7.2.5

