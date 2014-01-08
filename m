Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaAHVuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:50:19 -0500
Received: from nwas12.bluewin.ch ([195.186.228.230]:45665 "EHLO
	zhhdzmsp-nwas12.bluewin.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbaAHVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:50:16 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2014 16:50:16 EST
Date: Wed, 8 Jan 2014 22:36:53 +0100 (CET)
From: Daniel Matuschek <daniel@matuschek.net>
X-X-Sender: parallels@parallels-Parallels-Virtual-Platform
To: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Dimitris.Papastamos@Wolfsonmicro.com, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] ASoC: wm8804: Allow fine-grained control of the PLL
 generation
Message-ID: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Matuschek <daniel@matuschek.net>

  WM8804 can run
  with PLL frequencies of 256xfs and 128xfs for most sample
  rates. At 192kHz only 128xfs is supported. The existing
  driver selects 128xfs automatically for some lower samples
  rates. By using the "pllid" argument of the "set_pll"
  function is is now possible to control the behaviour. This
  allows using 256xfs PLL frequency on all sample rates up to
  96kHz. It should allow lower jitter and better signal
  quality. When pllid=0, the behaviour of the driver does not
  change.

---
  sound/soc/codecs/wm8804.c |   18 +++++++++++++-----
  sound/soc/codecs/wm8804.h |    7 +++++++
  2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 1704b1e..e79c408 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -2,6 +2,8 @@
   * wm8804.c  --  WM8804 S/PDIF transceiver driver
   *
   * Copyright 2010-11 Wolfson Microelectronics plc
+ * patched by Daniel Matuschek <info@crazyaudio.com> to allow
+ * fine-grained control of PLL
   *
   * Author: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
   *
@@ -318,7 +320,7 @@ static struct {

  #define FIXED_PLL_SIZE ((1ULL << 22) * 10)
  static int pll_factors(struct pll_div *pll_div, unsigned int target,
-		       unsigned int source)
+		       unsigned int source, int mclk_div)
  {
  	u64 Kpart;
  	unsigned long int K, Ndiv, Nmod, tmp;
@@ -332,9 +334,15 @@ static int pll_factors(struct pll_div *pll_div, unsigned int target,
  		tmp = target * post_table[i].div;
  		if (tmp >= 90000000 && tmp <= 100000000) {
  			pll_div->freqmode = post_table[i].freqmode;
-			pll_div->mclkdiv = post_table[i].mclkdiv;
-			target *= post_table[i].div;
-			break;
+			if ((mclk_div == WM8804_MCLKDIV_DONTCARE) ||
+			    ((post_table[i].mclkdiv == 1) &&
+				(mclk_div == WM8804_MCLKDIV_1)) ||
+			    ((post_table[i].mclkdiv == 0) &&
+				(mclk_div == WM8804_MCLKDIV_0))) {
+				pll_div->mclkdiv = post_table[i].mclkdiv;
+				target *= post_table[i].div;
+				break;
+			}
  		}
  	}

@@ -388,7 +396,7 @@ static int wm8804_set_pll(struct snd_soc_dai *dai, int pll_id,
  		int ret;
  		struct pll_div pll_div;

-		ret = pll_factors(&pll_div, freq_out, freq_in);
+		ret = pll_factors(&pll_div, freq_out, freq_in, pll_id);
  		if (ret)
  			return ret;

diff --git a/sound/soc/codecs/wm8804.h b/sound/soc/codecs/wm8804.h
index 8ec14f5..0365177 100644
--- a/sound/soc/codecs/wm8804.h
+++ b/sound/soc/codecs/wm8804.h
@@ -58,4 +58,11 @@

  #define WM8804_CLKOUT_DIV			1

+#define WM8804_MCLKDIV_DONTCARE			0
+#define WM8804_MCLKDIV_0			1
+#define WM8804_MCLKDIV_1			2
+#define WM8804_PLL_MCLKDIV_DONTCARE		WM8804_MCLKDIV_DONTCARE
+#define WM8804_PLL_MCLKDIV_0			WM8804_MCLKDIV_0
+#define WM8804_PLL_MCLKDIV_1			WM8804_MCLKDIV_1
+
  #endif  /* _WM8804_H */
-- 
1.7.9.5

