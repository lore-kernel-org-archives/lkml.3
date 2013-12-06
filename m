Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161550Ab3LFOTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:19:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161088Ab3LFNAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/272] ASoC: wm5110: Add post SYSCLK register patch for rev D chip
Date: Fri,  6 Dec 2013 12:55:13 +0000
Message-Id: <1386334761-25517-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit f69f86b1ba6493126a7f093a65a8952bcb183de2 upstream.

Certain registers require patching after the SYSCLK has been brought up
add support for this into the CODEC driver.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm5110.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 2e7cb4b..18cdee7 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -37,6 +37,47 @@ struct wm5110_priv {
 	struct arizona_fll fll[2];
 };
 
+static const struct reg_default wm5110_sysclk_revd_patch[] = {
+	{ 0x3093, 0x1001 },
+	{ 0x30E3, 0x1301 },
+	{ 0x3133, 0x1201 },
+	{ 0x3183, 0x1501 },
+	{ 0x31D3, 0x1401 },
+};
+
+static int wm5110_sysclk_ev(struct snd_soc_dapm_widget *w,
+			    struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec = w->codec;
+	struct arizona *arizona = dev_get_drvdata(codec->dev->parent);
+	struct regmap *regmap = codec->control_data;
+	const struct reg_default *patch = NULL;
+	int i, patch_size;
+
+	switch (arizona->rev) {
+	case 3:
+		patch = wm5110_sysclk_revd_patch;
+		patch_size = ARRAY_SIZE(wm5110_sysclk_revd_patch);
+		break;
+	default:
+		return 0;
+	}
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+		if (patch)
+			for (i = 0; i < patch_size; i++)
+				regmap_write(regmap, patch[i].reg,
+					     patch[i].def);
+		break;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static DECLARE_TLV_DB_SCALE(ana_tlv, 0, 100, 0);
 static DECLARE_TLV_DB_SCALE(eq_tlv, -1200, 100, 0);
 static DECLARE_TLV_DB_SCALE(digital_tlv, -6400, 50, 0);
@@ -404,7 +445,7 @@ static const struct snd_kcontrol_new wm5110_aec_loopback_mux =
 
 static const struct snd_soc_dapm_widget wm5110_dapm_widgets[] = {
 SND_SOC_DAPM_SUPPLY("SYSCLK", ARIZONA_SYSTEM_CLOCK_1, ARIZONA_SYSCLK_ENA_SHIFT,
-		    0, NULL, 0),
+		    0, wm5110_sysclk_ev, SND_SOC_DAPM_POST_PMU),
 SND_SOC_DAPM_SUPPLY("ASYNCCLK", ARIZONA_ASYNC_CLOCK_1,
 		    ARIZONA_ASYNC_CLK_ENA_SHIFT, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY("OPCLK", ARIZONA_OUTPUT_SYSTEM_CLOCK,
-- 
1.8.3.2

