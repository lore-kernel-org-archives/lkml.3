Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbaLKEPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:15:54 -0500
Received: from mail-yk0-f201.google.com ([209.85.160.201]:42271 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaLKEPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:15:53 -0500
From: Ben Zhang <benzh@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>, linux-kernel@vger.kernel.org,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH 2/3] ASoC: rt5677: add a platform config option for MICBIAS voltage
Date: Wed, 10 Dec 2014 20:15:26 -0800
Message-Id: <1418271327-14710-2-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418271327-14710-1-git-send-email-benzh@chromium.org>
References: <1418271327-14710-1-git-send-email-benzh@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MICBIAS voltage for IN1 can be set to 1.476V/2.970V/1.242V/2.475V

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 Documentation/devicetree/bindings/sound/rt5677.txt | 4 ++++
 include/sound/rt5677.h                             | 9 +++++++++
 sound/soc/codecs/rt5677.c                          | 6 ++++++
 3 files changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/rt5677.txt b/Documentation/devicetree/bindings/sound/rt5677.txt
index 740ff77..f54d0dd 100644
--- a/Documentation/devicetree/bindings/sound/rt5677.txt
+++ b/Documentation/devicetree/bindings/sound/rt5677.txt
@@ -19,6 +19,9 @@ Optional properties:
 
 - realtek,pow-ldo2-gpio : The GPIO that controls the CODEC's POW_LDO2 pin.
 
+- realtek,micbias1
+  Select 0/1/2/3 to set MICBIAS1 voltage to 1.476V/2.970V/1.242V/2.475V
+
 - realtek,in1-differential
 - realtek,in2-differential
 - realtek,lout1-differential
@@ -70,6 +73,7 @@ rt5677 {
 
 	realtek,pow-ldo2-gpio =
 		<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
+	realtek,micbias1 = <1>  /* MICBIAS1 = 2.970V */
 	realtek,in1-differential = "true";
 	realtek,gpio-config = /bits/ 8  <0 0 0 0 0 2>;   /* pull up GPIO6 */
 	realtek,jd2-gpio = <3>;  /* Enables Jack detection for GPIO6 */
diff --git a/include/sound/rt5677.h b/include/sound/rt5677.h
index d9eb7d8..efa74bb 100644
--- a/include/sound/rt5677.h
+++ b/include/sound/rt5677.h
@@ -12,6 +12,13 @@
 #ifndef __LINUX_SND_RT5677_H
 #define __LINUX_SND_RT5677_H
 
+enum rt5677_micbias {
+	RT5677_MICBIAS_1_476V = 0,
+	RT5677_MICBIAS_2_970V = 1,
+	RT5677_MICBIAS_1_242V = 2,
+	RT5677_MICBIAS_2_475V = 3,
+};
+
 enum rt5677_dmic2_clk {
 	RT5677_DMIC_CLK1 = 0,
 	RT5677_DMIC_CLK2 = 1,
@@ -19,6 +26,8 @@ enum rt5677_dmic2_clk {
 
 
 struct rt5677_platform_data {
+	/* MICBIAS output voltage control */
+	enum rt5677_micbias micbias1;
 	/* IN1/IN2/LOUT1/LOUT2/LOUT3 can optionally be differential */
 	bool in1_diff;
 	bool in2_diff;
diff --git a/sound/soc/codecs/rt5677.c b/sound/soc/codecs/rt5677.c
index 81fe146..ac4bee8 100644
--- a/sound/soc/codecs/rt5677.c
+++ b/sound/soc/codecs/rt5677.c
@@ -4551,6 +4551,7 @@ MODULE_DEVICE_TABLE(i2c, rt5677_i2c_id);
 
 static int rt5677_parse_dt(struct rt5677_priv *rt5677, struct device_node *np)
 {
+	of_property_read_u32(np, "realtek,micbias1", &rt5677->pdata.micbias1);
 	rt5677->pdata.in1_diff = of_property_read_bool(np,
 					"realtek,in1-differential");
 	rt5677->pdata.in2_diff = of_property_read_bool(np,
@@ -4722,6 +4723,11 @@ static int rt5677_i2c_probe(struct i2c_client *i2c,
 	if (ret != 0)
 		dev_warn(&i2c->dev, "Failed to apply regmap patch: %d\n", ret);
 
+	regmap_update_bits(rt5677->regmap, RT5677_MICBIAS,
+			RT5677_MICBIAS1_OUTVOLT_MASK |
+			RT5677_MICBIAS1_CTRL_VDD_MASK,
+			rt5677->pdata.micbias1 << RT5677_MICBIAS1_CTRL_VDD_SFT);
+
 	if (rt5677->pdata.in1_diff)
 		regmap_update_bits(rt5677->regmap, RT5677_IN1,
 					RT5677_IN_DF1, RT5677_IN_DF1);
-- 
2.2.0.rc0.207.ga3a616c

