Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaANXby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:31:54 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13713 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaANXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:31:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 14 Jan 2014 15:31:31 -0800
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Arun Shamanna Lakshmi <aruns@nvidia.com>
Subject: [PATCH] ASoC: dapm: Change prototype of soc_widget_read
Date: Tue, 14 Jan 2014 15:31:54 -0800
Message-ID: <1389742314-20125-2-git-send-email-aruns@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389742314-20125-1-git-send-email-aruns@nvidia.com>
References: <1389742314-20125-1-git-send-email-aruns@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soc_widget_read API returns the register data and it is possible
that a register can contain 0xffffffff. Thus, change the prototype
of soc_widget_read to return only the error code and pass the reg
data through pointer argument.

Signed-off-by: Arun Shamanna Lakshmi <aruns@nvidia.com>
---
 sound/soc/soc-dapm.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 51b4c19..2a44fe9 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -371,12 +371,16 @@ static void dapm_reset(struct snd_soc_card *card)
 	}
 }
 
-static int soc_widget_read(struct snd_soc_dapm_widget *w, int reg)
+static int soc_widget_read(struct snd_soc_dapm_widget *w, int reg,
+	unsigned int *value)
 {
-	if (w->codec)
-		return snd_soc_read(w->codec, reg);
-	else if (w->platform)
-		return snd_soc_platform_read(w->platform, reg);
+	if (w->codec) {
+		*value = snd_soc_read(w->codec, reg);
+		return 0;
+	} else if (w->platform) {
+		*value = snd_soc_platform_read(w->platform, reg);
+		return 0;
+	}
 
 	dev_err(w->dapm->dev, "ASoC: no valid widget read method\n");
 	return -1;
@@ -430,13 +434,12 @@ static int soc_widget_update_bits_locked(struct snd_soc_dapm_widget *w,
 			return ret;
 	} else {
 		soc_widget_lock(w);
-		ret = soc_widget_read(w, reg);
+		ret = soc_widget_read(w, reg, &old);
 		if (ret < 0) {
 			soc_widget_unlock(w);
 			return ret;
 		}
 
-		old = ret;
 		new = (old & ~mask) | (value & mask);
 		change = old != new;
 		if (change) {
@@ -513,7 +516,7 @@ static void dapm_set_path_status(struct snd_soc_dapm_widget *w,
 		unsigned int invert = mc->invert;
 
 		if (reg != SND_SOC_NOPM) {
-			val = soc_widget_read(w, reg);
+			soc_widget_read(w, reg, &val);
 			val = (val >> shift) & mask;
 			if (invert)
 				val = max - val;
@@ -529,7 +532,7 @@ static void dapm_set_path_status(struct snd_soc_dapm_widget *w,
 			w->kcontrol_news[i].private_value;
 		int val, item;
 
-		val = soc_widget_read(w, e->reg);
+		soc_widget_read(w, e->reg, &val);
 		item = (val >> e->shift_l) & e->mask;
 
 		if (item < e->max && !strcmp(p->name, e->texts[item]))
@@ -558,7 +561,7 @@ static void dapm_set_path_status(struct snd_soc_dapm_widget *w,
 			w->kcontrol_news[i].private_value;
 		int val, item;
 
-		val = soc_widget_read(w, e->reg);
+		soc_widget_read(w, e->reg, &val);
 		val = (val >> e->shift_l) & e->mask;
 		for (item = 0; item < e->max; item++) {
 			if (val == e->values[item])
@@ -2782,7 +2785,8 @@ int snd_soc_dapm_new_widgets(struct snd_soc_card *card)
 
 		/* Read the initial power state from the device */
 		if (w->reg >= 0) {
-			val = soc_widget_read(w, w->reg) >> w->shift;
+			soc_widget_read(w, w->reg, &val);
+			val = val >> w->shift;
 			val &= w->mask;
 			if (val == w->on_val)
 				w->power = 1;
-- 
1.7.9.5

