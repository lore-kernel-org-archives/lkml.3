Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbaHHP3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:29:44 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:49069 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbaHHP3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:29:43 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] ASoC: dapm: Fix uninitialized variable in snd_soc_dapm_get_enum_double()
Date: Fri,  8 Aug 2014 17:29:35 +0200
Message-Id: <1407511775-26479-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If soc_dapm_read() fails, reg_val will be uninitialized, and bogus
values will be written later:

sound/soc/soc-dapm.c: In function 'snd_soc_dapm_get_enum_double':
sound/soc/soc-dapm.c:2862:15: warning: 'reg_val' may be used uninitialized in this function [-Wmaybe-uninitialized]
  unsigned int reg_val, val;
               ^

Return early on error to fix this.

Introduced by commit ce0fc93ae56e2ba50ff8c220d69e4e860e889320 ("ASoC:
Add DAPM support at the component level").
---
Is this correct? Please review.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 sound/soc/soc-dapm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 8348352dc2c6..177bd8639ef9 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2860,12 +2860,14 @@ int snd_soc_dapm_get_enum_double(struct snd_kcontrol *kcontrol,
 	struct snd_soc_dapm_context *dapm = snd_soc_dapm_kcontrol_dapm(kcontrol);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int reg_val, val;
-	int ret = 0;
 
-	if (e->reg != SND_SOC_NOPM)
-		ret = soc_dapm_read(dapm, e->reg, &reg_val);
-	else
+	if (e->reg != SND_SOC_NOPM) {
+		int ret = soc_dapm_read(dapm, e->reg, &reg_val);
+		if (ret)
+			return ret;
+	} else {
 		reg_val = dapm_kcontrol_get_value(kcontrol);
+	}
 
 	val = (reg_val >> e->shift_l) & e->mask;
 	ucontrol->value.enumerated.item[0] = snd_soc_enum_val_to_item(e, val);
@@ -2875,7 +2877,7 @@ int snd_soc_dapm_get_enum_double(struct snd_kcontrol *kcontrol,
 		ucontrol->value.enumerated.item[1] = val;
 	}
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_get_enum_double);
 
-- 
1.9.1

