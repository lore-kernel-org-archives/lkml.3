Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaB0QSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:18:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60409 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbaB0QS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:18:29 -0500
From: nikesh@opensource.wolfsonmicro.com
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        nikesh <Nikesh.Oswal@wolfsonmicro.com>
Subject: [PATCH v2] ASOC: dapm: add params_select callback
Date: Thu, 27 Feb 2014 16:18:20 +0000
Message-Id: <1393517900-27126-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: nikesh <Nikesh.Oswal@wolfsonmicro.com>

dai-link params for codec-codec links were fixed. The fixed link between
codec and another chip which may be another codec, baseband, bluetooth
codec etc may require run time configuaration changes. This change
provides an optional callback to select one of the param from a list
of params.

Signed-off-by: nikesh <Nikesh.Oswal@wolfsonmicro.com>
---

Change since v1:
Used an index to select from a list of params, instead of
overwriting the param.

Thanks,
Nikesh

 include/sound/soc-dapm.h |    3 ++-
 include/sound/soc.h      |    3 +++
 sound/soc/soc-core.c     |    4 ++--
 sound/soc/soc-dapm.c     |   20 ++++++++++++++++++--
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 68d92e3..12b0d9e 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -416,7 +416,8 @@ void snd_soc_dapm_connect_dai_link_widgets(struct snd_soc_card *card);
 int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 			 const struct snd_soc_pcm_stream *params,
 			 struct snd_soc_dapm_widget *source,
-			 struct snd_soc_dapm_widget *sink);
+			 struct snd_soc_dapm_widget *sink,
+			 struct snd_soc_dai_link *dai_link);
 
 /* dapm path setup */
 int snd_soc_dapm_new_widgets(struct snd_soc_card *card);
diff --git a/include/sound/soc.h b/include/sound/soc.h
index 9a00147..20110aa 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -876,6 +876,9 @@ struct snd_soc_dai_link {
 	int be_id;	/* optional ID for machine driver BE identification */
 
 	const struct snd_soc_pcm_stream *params;
+	/* optional params selection for dai links */
+	int (*params_select)(const struct snd_soc_pcm_stream *params,
+			unsigned int *param_index, int event);
 
 	unsigned int dai_fmt;           /* format to set on init */
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index fe1df50..4f03e88 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1469,7 +1469,7 @@ static int soc_probe_link_dais(struct snd_soc_card *card, int num, int order)
 			capture_w = cpu_dai->capture_widget;
 			if (play_w && capture_w) {
 				ret = snd_soc_dapm_new_pcm(card, dai_link->params,
-						   capture_w, play_w);
+						   capture_w, play_w, dai_link);
 				if (ret != 0) {
 					dev_err(card->dev, "ASoC: Can't link %s to %s: %d\n",
 						play_w->name, capture_w->name, ret);
@@ -1481,7 +1481,7 @@ static int soc_probe_link_dais(struct snd_soc_card *card, int num, int order)
 			capture_w = codec_dai->capture_widget;
 			if (play_w && capture_w) {
 				ret = snd_soc_dapm_new_pcm(card, dai_link->params,
-						   capture_w, play_w);
+						   capture_w, play_w, dai_link);
 				if (ret != 0) {
 					dev_err(card->dev, "ASoC: Can't link %s to %s: %d\n",
 						play_w->name, capture_w->name, ret);
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index dc8ff13..2e2f633 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3379,10 +3379,12 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 	struct snd_soc_dapm_path *source_p, *sink_p;
 	struct snd_soc_dai *source, *sink;
 	const struct snd_soc_pcm_stream *config = w->params;
+	struct snd_soc_dai_link *dai_link = w->priv;
 	struct snd_pcm_substream substream;
 	struct snd_pcm_hw_params *params = NULL;
 	u64 fmt;
-	int ret;
+	int ret = 0;
+	unsigned int param_index;
 
 	if (WARN_ON(!config) ||
 	    WARN_ON(list_empty(&w->sources) || list_empty(&w->sinks)))
@@ -3402,6 +3404,18 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 	source = source_p->source->priv;
 	sink = sink_p->sink->priv;
 
+	if (dai_link && dai_link->params_select) {
+		ret = dai_link->params_select(config, &param_index, event);
+		if (ret < 0) {
+			dev_err(w->dapm->dev,
+			"ASoC: params_select for dai link widget failed %d\n",
+			ret);
+			goto out;
+		}
+		if (param_index > 0)
+			config += param_index;
+	}
+
 	/* Be a little careful as we don't want to overflow the mask array */
 	if (config->formats) {
 		fmt = ffs(config->formats) - 1;
@@ -3485,7 +3499,8 @@ out:
 int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 			 const struct snd_soc_pcm_stream *params,
 			 struct snd_soc_dapm_widget *source,
-			 struct snd_soc_dapm_widget *sink)
+			 struct snd_soc_dapm_widget *sink,
+			 struct snd_soc_dai_link *dai_link)
 {
 	struct snd_soc_dapm_route routes[2];
 	struct snd_soc_dapm_widget template;
@@ -3517,6 +3532,7 @@ int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 	}
 
 	w->params = params;
+	w->priv = (void *)dai_link;
 
 	memset(&routes, 0, sizeof(routes));
 
-- 
1.7.9.5

