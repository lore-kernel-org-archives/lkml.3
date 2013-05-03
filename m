Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598Ab3ECFdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:33:52 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:52681 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3ECFdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:33:50 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        daniel@zonque.org, vladimir.koutny@streamunlimited.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH v2] clk: si5351: Allow user to define disabled state for every clock output
Date: Fri,  3 May 2013 07:33:27 +0200
Message-Id: <1367559207-20086-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

This patch adds platform data and DT bindings to allow to overwrite
the stored disabled state for each clock output.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changes from v1->v2:
Sebastian Hesselbarth send me updated version of patch which was based
on v1. Resending with updates.

 .../devicetree/bindings/clock/silabs,si5351.txt    |    5 ++
 drivers/clk/clk-si5351.c                           |   74 +++++++++++++++++++-
 drivers/clk/clk-si5351.h                           |    1 +
 include/linux/platform_data/si5351.h               |   18 +++++
 4 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/silabs,si5351.txt b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
index cc37465..66c75b2 100644
--- a/Documentation/devicetree/bindings/clock/silabs,si5351.txt
+++ b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
@@ -44,6 +44,11 @@ Optional child node properties:
 - silabs,multisynth-source: source pll A(0) or B(1) of corresponding multisynth
   divider.
 - silabs,pll-master: boolean, multisynth can change pll frequency.
+- silabs,disable-state : clock output disable state, shall be
+  0 = clock output is driven LOW when disabled
+  1 = clock output is driven HIGH when disabled
+  2 = clock output is FLOATING (HIGH-Z) when disabled
+  3 = clock output is NEVER disabled
 
 ==Example==
 
diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 8323c31..098f28b 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -851,6 +851,41 @@ static int _si5351_clkout_set_drive_strength(
 	return 0;
 }
 
+static int _si5351_clkout_set_disable_state(
+	struct si5351_driver_data *drvdata, int num,
+	enum si5351_disable_state state)
+{
+	u8 reg = (num < 4) ? SI5351_CLK3_0_DISABLE_STATE :
+		SI5351_CLK7_4_DISABLE_STATE;
+	u8 shift = (num < 4) ? (2 * num) : (2 * (num-4));
+	u8 mask = SI5351_CLK_DISABLE_STATE_MASK << shift;
+	u8 val;
+
+	if (num > 8)
+		return -EINVAL;
+
+	switch (state) {
+	case SI5351_DISABLE_LOW:
+		val = SI5351_CLK_DISABLE_STATE_LOW;
+		break;
+	case SI5351_DISABLE_HIGH:
+		val = SI5351_CLK_DISABLE_STATE_HIGH;
+		break;
+	case SI5351_DISABLE_FLOATING:
+		val = SI5351_CLK_DISABLE_STATE_FLOAT;
+		break;
+	case SI5351_DISABLE_NEVER:
+		val = SI5351_CLK_DISABLE_STATE_NEVER;
+		break;
+	default:
+		return 0;
+	}
+
+	si5351_set_bits(drvdata, reg, mask, val << shift);
+
+	return 0;
+}
+
 static int si5351_clkout_prepare(struct clk_hw *hw)
 {
 	struct si5351_hw_data *hwdata =
@@ -1225,6 +1260,33 @@ static int si5351_dt_parse(struct i2c_client *client)
 			}
 		}
 
+		if (!of_property_read_u32(child, "silabs,disable-state",
+					  &val)) {
+			switch (val) {
+			case 0:
+				pdata->clkout[num].disable_state =
+					SI5351_DISABLE_LOW;
+				break;
+			case 1:
+				pdata->clkout[num].disable_state =
+					SI5351_DISABLE_HIGH;
+				break;
+			case 2:
+				pdata->clkout[num].disable_state =
+					SI5351_DISABLE_FLOATING;
+				break;
+			case 3:
+				pdata->clkout[num].disable_state =
+					SI5351_DISABLE_NEVER;
+				break;
+			default:
+				dev_err(&client->dev,
+					"invalid disable state %d for clkout %d\n",
+					val, num);
+				return -EINVAL;
+			}
+		}
+
 		if (!of_property_read_u32(child, "clock-frequency", &val))
 			pdata->clkout[num].rate = val;
 
@@ -1281,9 +1343,6 @@ static int si5351_i2c_probe(struct i2c_client *client,
 
 	/* Disable interrupts */
 	si5351_reg_write(drvdata, SI5351_INTERRUPT_MASK, 0xf0);
-	/* Set disabled output drivers to drive low */
-	si5351_reg_write(drvdata, SI5351_CLK3_0_DISABLE_STATE, 0x00);
-	si5351_reg_write(drvdata, SI5351_CLK7_4_DISABLE_STATE, 0x00);
 	/* Ensure pll select is on XTAL for Si5351A/B */
 	if (drvdata->variant != SI5351_VARIANT_C)
 		si5351_set_bits(drvdata, SI5351_PLL_INPUT_SOURCE,
@@ -1327,6 +1386,15 @@ static int si5351_i2c_probe(struct i2c_client *client,
 				n, pdata->clkout[n].drive);
 			return ret;
 		}
+
+		ret = _si5351_clkout_set_disable_state(drvdata, n,
+						pdata->clkout[n].disable_state);
+		if (ret) {
+			dev_err(&client->dev,
+				"failed set disable state of clkout%d to %d\n",
+				n, pdata->clkout[n].disable_state);
+			return ret;
+		}
 	}
 
 	/* register xtal input clock gate */
diff --git a/drivers/clk/clk-si5351.h b/drivers/clk/clk-si5351.h
index af41b50..c0dbf26 100644
--- a/drivers/clk/clk-si5351.h
+++ b/drivers/clk/clk-si5351.h
@@ -81,6 +81,7 @@
 
 #define SI5351_CLK3_0_DISABLE_STATE		24
 #define SI5351_CLK7_4_DISABLE_STATE		25
+#define  SI5351_CLK_DISABLE_STATE_MASK		3
 #define  SI5351_CLK_DISABLE_STATE_LOW		0
 #define  SI5351_CLK_DISABLE_STATE_HIGH		1
 #define  SI5351_CLK_DISABLE_STATE_FLOAT		2
diff --git a/include/linux/platform_data/si5351.h b/include/linux/platform_data/si5351.h
index 92dabca..5433439 100644
--- a/include/linux/platform_data/si5351.h
+++ b/include/linux/platform_data/si5351.h
@@ -79,6 +79,23 @@ enum si5351_drive_strength {
 };
 
 /**
+ * enum si5351_disable_state - Si5351 clock output disable state
+ * @SI5351_DISABLE_DEFAULT: default, do not change eeprom config
+ * @SI5351_DISABLE_LOW: CLKx is set to a LOW state when disabled
+ * @SI5351_DISABLE_HIGH: CLKx is set to a HIGH state when disabled
+ * @SI5351_DISABLE_FLOATING: CLKx is set to a FLOATING state when
+ *				disabled
+ * @SI5351_DISABLE_NEVER: CLKx is NEVER disabled
+ */
+enum si5351_disable_state {
+	SI5351_DISABLE_DEFAULT = 0,
+	SI5351_DISABLE_LOW,
+	SI5351_DISABLE_HIGH,
+	SI5351_DISABLE_FLOATING,
+	SI5351_DISABLE_NEVER,
+};
+
+/**
  * struct si5351_clkout_config - Si5351 clock output configuration
  * @clkout: clkout number
  * @multisynth_src: multisynth source clock
@@ -91,6 +108,7 @@ struct si5351_clkout_config {
 	enum si5351_multisynth_src multisynth_src;
 	enum si5351_clkout_src clkout_src;
 	enum si5351_drive_strength drive;
+	enum si5351_disable_state disable_state;
 	bool pll_master;
 	unsigned long rate;
 };
-- 
1.7.9.5

