Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab3LBVQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:16:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3LBTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 020/173] ASoC: wm5110: Add post SYSCLK register patch for rev D chip
Date: Mon,  2 Dec 2013 11:10:03 -0800
Message-Id: <20131202191145.149342287@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit f69f86b1ba6493126a7f093a65a8952bcb183de2 upstream.

Certain registers require patching after the SYSCLK has been brought up
add support for this into the CODEC driver.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm5110.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

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
@@ -386,7 +427,7 @@ static const struct snd_kcontrol_new wm5
 
 static const struct snd_soc_dapm_widget wm5110_dapm_widgets[] = {
 SND_SOC_DAPM_SUPPLY("SYSCLK", ARIZONA_SYSTEM_CLOCK_1, ARIZONA_SYSCLK_ENA_SHIFT,
-		    0, NULL, 0),
+		    0, wm5110_sysclk_ev, SND_SOC_DAPM_POST_PMU),
 SND_SOC_DAPM_SUPPLY("ASYNCCLK", ARIZONA_ASYNC_CLOCK_1,
 		    ARIZONA_ASYNC_CLK_ENA_SHIFT, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY("OPCLK", ARIZONA_OUTPUT_SYSTEM_CLOCK,


