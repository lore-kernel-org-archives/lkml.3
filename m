Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314Ab3D3LRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:17:08 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:44006 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760208Ab3D3LRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:17:05 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        sebastian.hesselbarth@gmail.com, daniel@zonque.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH] clk: si5351: Allow user to define disabled state for every clock output.
Date: Tue, 30 Apr 2013 13:16:47 +0200
Message-Id: <1367320607-25657-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform data and dt bindings to allow user override disabled state.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 .../devicetree/bindings/clock/silabs,si5351.txt    |    5 +++
 drivers/clk/clk-si5351.c                           |   36 +++++++++++++++++---
 include/linux/platform_data/si5351.h               |   16 +++++++++
 3 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/silabs,si5351.txt b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
index cc37465..2f24c12 100644
--- a/Documentation/devicetree/bindings/clock/silabs,si5351.txt
+++ b/Documentation/devicetree/bindings/clock/silabs,si5351.txt
@@ -44,6 +44,11 @@ Optional child node properties:
 - silabs,multisynth-source: source pll A(0) or B(1) of corresponding multisynth
   divider.
 - silabs,pll-master: boolean, multisynth can change pll frequency.
+- silabs,disable-state : clock disable state (default 0) shall be
+  0 = CLKx is set to a LOW state when disabled
+  1 = CLKx is set to a HIGH state when disabled
+  2 = CLKx is set to a HIGH IMPEDANCE state when disabled
+  3 = CLKx is NEVER DISABLED
 
 ==Example==
 
diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 8323c31..bfe92b8 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1230,6 +1230,21 @@ static int si5351_dt_parse(struct i2c_client *client)
 
 		pdata->clkout[num].pll_master =
 			of_property_read_bool(child, "silabs,pll-master");
+
+		if (!of_property_read_u32(child, "silabs,disable-state",
+					  &val)) {
+			switch (val) {
+			case SI5351_DISABLE_LOW:
+			case SI5351_DISABLE_HIGH:
+			case SI5351_DISABLE_HIGH_IMPEDANCE:
+			case SI5351_NEVER_DISABLED:
+				pdata->clkout[num].disable_state = val;
+				break;
+			default:
+				pdata->clkout[num].disable_state = 0;
+			}
+		}
+
 	}
 	client->dev.platform_data = pdata;
 
@@ -1250,7 +1265,7 @@ static int si5351_i2c_probe(struct i2c_client *client,
 	struct clk_init_data init;
 	struct clk *clk;
 	const char *parent_names[4];
-	u8 num_parents, num_clocks;
+	u8 num_parents, num_clocks, disabled;
 	int ret, n;
 
 	ret = si5351_dt_parse(client);
@@ -1281,9 +1296,22 @@ static int si5351_i2c_probe(struct i2c_client *client,
 
 	/* Disable interrupts */
 	si5351_reg_write(drvdata, SI5351_INTERRUPT_MASK, 0xf0);
-	/* Set disabled output drivers to drive low */
-	si5351_reg_write(drvdata, SI5351_CLK3_0_DISABLE_STATE, 0x00);
-	si5351_reg_write(drvdata, SI5351_CLK7_4_DISABLE_STATE, 0x00);
+
+	/* Set disabled output states */
+	disabled = (pdata->clkout[0].disable_state & 0x03) |
+		((pdata->clkout[1].disable_state << 2) & 0x0C) |
+		((pdata->clkout[2].disable_state << 4) & 0x30) |
+		((pdata->clkout[3].disable_state << 6) & 0xC0);
+
+	si5351_reg_write(drvdata, SI5351_CLK3_0_DISABLE_STATE, disabled);
+
+	disabled = (pdata->clkout[4].disable_state & 0x03) |
+		((pdata->clkout[5].disable_state << 2) & 0x0C) |
+		((pdata->clkout[6].disable_state << 4) & 0x30) |
+		((pdata->clkout[7].disable_state << 6) & 0xC0);
+
+	si5351_reg_write(drvdata, SI5351_CLK7_4_DISABLE_STATE, disabled);
+
 	/* Ensure pll select is on XTAL for Si5351A/B */
 	if (drvdata->variant != SI5351_VARIANT_C)
 		si5351_set_bits(drvdata, SI5351_PLL_INPUT_SOURCE,
diff --git a/include/linux/platform_data/si5351.h b/include/linux/platform_data/si5351.h
index 92dabca..6702991 100644
--- a/include/linux/platform_data/si5351.h
+++ b/include/linux/platform_data/si5351.h
@@ -79,6 +79,21 @@ enum si5351_drive_strength {
 };
 
 /**
+ * enum si5351_disable_state - Si5351 clock output disable state
+ * @SI5351_DISABLE_LOW: CLKx is set to a LOW state when disabled
+ * @SI5351_DISABLE_HIGH: CLKx is set to a HIGH state when disabled
+ * @SI5351_DISABLE_HIGH_IMPEDANCE: CLKx is set to a HIGH IMPEDANCE state
+ *				   when disabled
+ * @SI5351_NEVER_DISABLED: CLKx is NEVER DISABLED
+ */
+enum si5351_disable_state {
+	SI5351_DISABLE_LOW = 0,
+	SI5351_DISABLE_HIGH,
+	SI5351_DISABLE_HIGH_IMPEDANCE,
+	SI5351_NEVER_DISABLED,
+};
+
+/**
  * struct si5351_clkout_config - Si5351 clock output configuration
  * @clkout: clkout number
  * @multisynth_src: multisynth source clock
@@ -93,6 +108,7 @@ struct si5351_clkout_config {
 	enum si5351_drive_strength drive;
 	bool pll_master;
 	unsigned long rate;
+	enum si5351_disable_state disable_state;
 };
 
 /**
-- 
1.7.9.5

