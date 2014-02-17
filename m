Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaBQRDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:03:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40027 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbaBQRAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:02 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 03/15] ASoC: adav80x: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:31 +0000
Message-Id: <1392655903-24537-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin updates in this driver look like they are intended to be done
atomically, update to do so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/adav80x.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/adav80x.c b/sound/soc/codecs/adav80x.c
index f78b27a..aacb2c03 100644
--- a/sound/soc/codecs/adav80x.c
+++ b/sound/soc/codecs/adav80x.c
@@ -600,15 +600,21 @@ static int adav80x_set_sysclk(struct snd_soc_codec *codec,
 			adav80x->sysclk_pd[clk_id] = false;
 		}
 
+		mutex_lock(&codec->dapm.card->dapm_mutex);
+
 		if (adav80x->sysclk_pd[0])
-			snd_soc_dapm_disable_pin(&codec->dapm, "PLL1");
+			snd_soc_dapm_disable_pin_locked(&codec->dapm, "PLL1");
 		else
-			snd_soc_dapm_force_enable_pin(&codec->dapm, "PLL1");
+			snd_soc_dapm_force_enable_pin_locked(&codec->dapm,
+							     "PLL1");
 
 		if (adav80x->sysclk_pd[1] || adav80x->sysclk_pd[2])
-			snd_soc_dapm_disable_pin(&codec->dapm, "PLL2");
+			snd_soc_dapm_disable_pin_locked(&codec->dapm, "PLL2");
 		else
-			snd_soc_dapm_force_enable_pin(&codec->dapm, "PLL2");
+			snd_soc_dapm_force_enable_pin_locked(&codec->dapm,
+							     "PLL2");
+
+		mutex_unlock(&codec->dapm.card->dapm_mutex);
 
 		snd_soc_dapm_sync(&codec->dapm);
 	}
-- 
1.7.2.5

