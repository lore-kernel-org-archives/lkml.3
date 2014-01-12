Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaALVLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 16:11:40 -0500
Received: from nwas12.bluewin.ch ([195.186.228.230]:60112 "EHLO
	zhhdzmsp-nwas12.bluewin.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbaALVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:11:38 -0500
Date: Sun, 12 Jan 2014 22:11:25 +0100 (CET)
From: Daniel Matuschek <daniel@matuschek.net>
X-X-Sender: parallels@parallels-Parallels-Virtual-Platform
To: alsa-devel@alsa-project.org
cc: Dimitris.Papastamos@wolfsonmicro.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        info@crazy-audio.com
Subject: [PATCH] ASoC: wm8804: Allow control of master clock divider in PLL
 generation
Message-ID: <alpine.DEB.2.02.1401122206520.7929@parallels-Parallels-Virtual-Platform>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Matuschek <daniel@matuschek.net>

After some discussions of the patch last week, here is a new version. 
Simply reducing the post_table did not work, as for some frequencies
both settings (MCLKDIV=0 and MCLKDIV=1) are needed (e.g. 96 and 192kHz)


  WM8804 can run with PLL frequencies of 256xfs and 128xfs for
  most sample rates. At 192kHz only 128xfs is supported. The
  existing driver selects 128xfs automatically for some lower
  samples rates. By using an additional mclk_div divider, is
  is now possible to control the behaviour. This allows using
  256xfs PLL frequency on all sample rates up to 96kHz. It
  should allow lower jitter and better signal quality. The
  behavior has to be controlled by the sound card driver,
  because some sample frequency share the same setting. e.g.
  192kHz and 96kHz use 24.576MHz master clock. The only
  difference is the MCLK divider.

---
  sound/soc/codecs/wm8804.c |   17 ++++++++++++++---
  sound/soc/codecs/wm8804.h |    4 ++++
  2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 1704b1e..4619bf8 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -63,6 +63,7 @@ struct wm8804_priv {
  	struct regmap *regmap;
  	struct regulator_bulk_data supplies[WM8804_NUM_SUPPLIES];
  	struct notifier_block disable_nb[WM8804_NUM_SUPPLIES];
+	int mclk_div;
  };

  static int txsrc_get(struct snd_kcontrol *kcontrol,
@@ -318,7 +319,7 @@ static struct {

  #define FIXED_PLL_SIZE ((1ULL << 22) * 10)
  static int pll_factors(struct pll_div *pll_div, unsigned int target,
-		       unsigned int source)
+		       unsigned int source, unsigned int mclk_div)
  {
  	u64 Kpart;
  	unsigned long int K, Ndiv, Nmod, tmp;
@@ -330,7 +331,8 @@ static int pll_factors(struct pll_div *pll_div, unsigned int target,
  	 */
  	for (i = 0; i < ARRAY_SIZE(post_table); i++) {
  		tmp = target * post_table[i].div;
-		if (tmp >= 90000000 && tmp <= 100000000) {
+		if ((tmp >= 90000000 && tmp <= 100000000) &&
+		    (mclk_div == post_table[i].mclkdiv)) {
  			pll_div->freqmode = post_table[i].freqmode;
  			pll_div->mclkdiv = post_table[i].mclkdiv;
  			target *= post_table[i].div;
@@ -387,8 +389,12 @@ static int wm8804_set_pll(struct snd_soc_dai *dai, int pll_id,
  	} else {
  		int ret;
  		struct pll_div pll_div;
+		struct wm8804_priv *wm8804;

-		ret = pll_factors(&pll_div, freq_out, freq_in);
+		wm8804 = snd_soc_codec_get_drvdata(codec);
+
+		ret = pll_factors(&pll_div, freq_out, freq_in,
+			wm8804->mclk_div);
  		if (ret)
  			return ret;

@@ -452,6 +458,7 @@ static int wm8804_set_clkdiv(struct snd_soc_dai *dai,
  			     int div_id, int div)
  {
  	struct snd_soc_codec *codec;
+	struct wm8804_priv *wm8804;

  	codec = dai->codec;
  	switch (div_id) {
@@ -459,6 +466,10 @@ static int wm8804_set_clkdiv(struct snd_soc_dai *dai,
  		snd_soc_update_bits(codec, WM8804_PLL5, 0x30,
  				    (div & 0x3) << 4);
  		break;
+	case WM8804_MCLK_DIV:
+		wm8804 = snd_soc_codec_get_drvdata(codec);
+		wm8804->mclk_div = div;
+		break;
  	default:
  		dev_err(dai->dev, "Unknown clock divider: %d\n", div_id);
  		return -EINVAL;
diff --git a/sound/soc/codecs/wm8804.h b/sound/soc/codecs/wm8804.h
index 8ec14f5..e72d4f4 100644
--- a/sound/soc/codecs/wm8804.h
+++ b/sound/soc/codecs/wm8804.h
@@ -57,5 +57,9 @@
  #define WM8804_CLKOUT_SRC_OSCCLK		4

  #define WM8804_CLKOUT_DIV			1
+#define WM8804_MCLK_DIV				2
+
+#define WM8804_MCLKDIV_256FS			0
+#define WM8804_MCLKDIV_128FS			1

  #endif  /* _WM8804_H */
-- 
1.7.9.5

