Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbaLKEQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:16:12 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:61923 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574AbaLKEPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:15:53 -0500
From: Ben Zhang <benzh@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>, linux-kernel@vger.kernel.org,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH 3/3] ASoC: rt5677: add a platform config option for DACREF source
Date: Wed, 10 Dec 2014 20:15:27 -0800
Message-Id: <1418271327-14710-3-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418271327-14710-1-git-send-email-benzh@chromium.org>
References: <1418271327-14710-1-git-send-email-benzh@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DACREF power source can come from external 1.8V or codec internal 1.8V.
This patch adds the option to enable the internal DACREF power source.

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 Documentation/devicetree/bindings/sound/rt5677.txt | 3 +++
 include/sound/rt5677.h                             | 2 ++
 sound/soc/codecs/rt5677.c                          | 9 +++++++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/rt5677.txt b/Documentation/devicetree/bindings/sound/rt5677.txt
index f54d0dd..f06d52a 100644
--- a/Documentation/devicetree/bindings/sound/rt5677.txt
+++ b/Documentation/devicetree/bindings/sound/rt5677.txt
@@ -22,6 +22,9 @@ Optional properties:
 - realtek,micbias1
   Select 0/1/2/3 to set MICBIAS1 voltage to 1.476V/2.970V/1.242V/2.475V
 
+- realtek,internal-dacref-en
+  Select codec internal 1.8V as DACREF source optionally.
+
 - realtek,in1-differential
 - realtek,in2-differential
 - realtek,lout1-differential
diff --git a/include/sound/rt5677.h b/include/sound/rt5677.h
index efa74bb..42866f3 100644
--- a/include/sound/rt5677.h
+++ b/include/sound/rt5677.h
@@ -28,6 +28,8 @@ enum rt5677_dmic2_clk {
 struct rt5677_platform_data {
 	/* MICBIAS output voltage control */
 	enum rt5677_micbias micbias1;
+	/* Select codec internal 1.8V as DACREF source optionally */
+	bool internal_dacref_en;
 	/* IN1/IN2/LOUT1/LOUT2/LOUT3 can optionally be differential */
 	bool in1_diff;
 	bool in2_diff;
diff --git a/sound/soc/codecs/rt5677.c b/sound/soc/codecs/rt5677.c
index ac4bee8..e6d7bb4 100644
--- a/sound/soc/codecs/rt5677.c
+++ b/sound/soc/codecs/rt5677.c
@@ -4552,6 +4552,8 @@ MODULE_DEVICE_TABLE(i2c, rt5677_i2c_id);
 static int rt5677_parse_dt(struct rt5677_priv *rt5677, struct device_node *np)
 {
 	of_property_read_u32(np, "realtek,micbias1", &rt5677->pdata.micbias1);
+	rt5677->pdata.internal_dacref_en = of_property_read_bool(np,
+					"realtek,internal-dacref-en");
 	rt5677->pdata.in1_diff = of_property_read_bool(np,
 					"realtek,in1-differential");
 	rt5677->pdata.in2_diff = of_property_read_bool(np,
@@ -4728,6 +4730,13 @@ static int rt5677_i2c_probe(struct i2c_client *i2c,
 			RT5677_MICBIAS1_CTRL_VDD_MASK,
 			rt5677->pdata.micbias1 << RT5677_MICBIAS1_CTRL_VDD_SFT);
 
+	if (rt5677->pdata.internal_dacref_en) {
+		regmap_update_bits(rt5677->regmap, RT5677_PR_BASE +
+				RT5677_TEST_CTRL1, 1 << 9, 1 << 9);
+		regmap_update_bits(rt5677->regmap, RT5677_PR_BASE +
+				RT5677_SOFT_DEPOP_DAC_CLK_CTRL, 1 << 5, 1 << 5);
+	}
+
 	if (rt5677->pdata.in1_diff)
 		regmap_update_bits(rt5677->regmap, RT5677_IN1,
 					RT5677_IN_DF1, RT5677_IN_DF1);
-- 
2.2.0.rc0.207.ga3a616c

