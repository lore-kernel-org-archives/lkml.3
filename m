Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaKOG5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 01:57:21 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54537 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaKOG5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 01:57:13 -0500
From: Ben Zhang <benzh@chromium.org>
To: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com, linux-kernel@vger.kernel.org,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH 2/2] ASoC: rt5677: add a platform config option for PDM clock divider
Date: Fri, 14 Nov 2014 22:56:48 -0800
Message-Id: <1416034608-24238-2-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416034608-24238-1-git-send-email-benzh@chromium.org>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PDM output clock can use a divider of 1/2/3/4 based on the system clock

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 Documentation/devicetree/bindings/sound/rt5677.txt | 5 +++++
 include/sound/rt5677.h                             | 8 ++++++++
 sound/soc/codecs/rt5677.c                          | 7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/rt5677.txt b/Documentation/devicetree/bindings/sound/rt5677.txt
index 740ff77..141f3e1 100644
--- a/Documentation/devicetree/bindings/sound/rt5677.txt
+++ b/Documentation/devicetree/bindings/sound/rt5677.txt
@@ -27,6 +27,10 @@ Optional properties:
   Boolean. Indicate MIC1/2 input and LOUT1/2/3 outputs are differential,
   rather than single-ended.
 
+- realtek,pdm_clk_div
+  Select 0/1/2/3 as PDM clock divider 1/2/4/3 respectively.
+  PDM clock = system clock / PDM clock divider
+
 - realtek,gpio-config
   Array of six 8bit elements that configures GPIO.
     0 - floating (reset value)
@@ -71,6 +75,7 @@ rt5677 {
 	realtek,pow-ldo2-gpio =
 		<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
 	realtek,in1-differential = "true";
+	realtek,pdm_clk_div = <1>  /* PDM clock = system clock / 2 */
 	realtek,gpio-config = /bits/ 8  <0 0 0 0 0 2>;   /* pull up GPIO6 */
 	realtek,jd2-gpio = <3>;  /* Enables Jack detection for GPIO6 */
 };
diff --git a/include/sound/rt5677.h b/include/sound/rt5677.h
index d9eb7d8..368aa33 100644
--- a/include/sound/rt5677.h
+++ b/include/sound/rt5677.h
@@ -17,6 +17,12 @@ enum rt5677_dmic2_clk {
 	RT5677_DMIC_CLK2 = 1,
 };
 
+enum rt5677_pdm_clk_div {
+	RT5677_PDM_CLK_DIV1 = 0,
+	RT5677_PDM_CLK_DIV2 = 1,
+	RT5677_PDM_CLK_DIV4 = 2,
+	RT5677_PDM_CLK_DIV3 = 3,
+};
 
 struct rt5677_platform_data {
 	/* IN1/IN2/LOUT1/LOUT2/LOUT3 can optionally be differential */
@@ -27,6 +33,8 @@ struct rt5677_platform_data {
 	bool lout3_diff;
 	/* DMIC2 clock source selection */
 	enum rt5677_dmic2_clk dmic2_clk_pin;
+	/* System clock to PDM filter divider */
+	enum rt5677_pdm_clk_div pdm_clk_div;
 
 	/* configures GPIO, 0 - floating, 1 - pulldown, 2 - pullup */
 	u8 gpio_config[6];
diff --git a/sound/soc/codecs/rt5677.c b/sound/soc/codecs/rt5677.c
index 384281d..383cb61 100644
--- a/sound/soc/codecs/rt5677.c
+++ b/sound/soc/codecs/rt5677.c
@@ -4502,6 +4502,8 @@ static int rt5677_parse_dt(struct rt5677_priv *rt5677, struct device_node *np)
 					"realtek,lout2-differential");
 	rt5677->pdata.lout3_diff = of_property_read_bool(np,
 					"realtek,lout3-differential");
+	of_property_read_u32(np, "realtek,pdm_clk_div",
+					&rt5677->pdata.pdm_clk_div);
 
 	rt5677->pow_ldo2 = of_get_named_gpio(np,
 					"realtek,pow-ldo2-gpio", 0);
@@ -4548,6 +4550,8 @@ static void rt5677_parse_acpi(struct rt5677_priv *rt5677, struct device *dev)
 {
 	rt5677->pdata.dmic2_clk_pin = (enum rt5677_dmic2_clk)
 		rt5677_parse_acpi_entry(dev, "DCLK");
+	rt5677->pdata.pdm_clk_div = (enum rt5677_pdm_clk_div)
+		rt5677_parse_acpi_entry(dev, "PCLK");
 	rt5677->pdata.in1_diff = (bool)rt5677_parse_acpi_entry(dev, "IN1");
 	rt5677->pdata.in2_diff = (bool)rt5677_parse_acpi_entry(dev, "IN2");
 	rt5677->pdata.lout1_diff = (bool)rt5677_parse_acpi_entry(dev, "OUT1");
@@ -4730,6 +4734,9 @@ static int rt5677_i2c_probe(struct i2c_client *i2c,
 					RT5677_GPIO5_DIR_OUT);
 	}
 
+	regmap_update_bits(rt5677->regmap, RT5677_PDM_DATA_CTRL1,
+			RT5677_PDM_DIV_MASK, rt5677->pdata.pdm_clk_div);
+
 	rt5677_init_gpio(i2c);
 	rt5677_irq_init(i2c);
 
-- 
2.1.0.rc2.206.gedb03e5

