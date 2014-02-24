Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaBXNy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:54:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45746 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbaBXNy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:54:28 -0500
From: Nikesh@vger.kernel.org, Oswal@vger.kernel.org
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, nikesh <Nikesh.Oswal@wolfsonmicro.com>
Subject: [PATCH] ASOC: dapm: add param_fixup callback
Date: Mon, 24 Feb 2014 13:54:18 +0000
Message-Id: <1393250058-18430-1-git-send-email-Nikesh.Oswal@wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: nikesh <Nikesh.Oswal@wolfsonmicro.com>

dai-link params for codec-codec links were fixed.
The fixed link between codec and another chip which
may be another codec, baseband, bluetooth codec etc
may require run time configuaration changes.
This change provides an optional callback to modify
these params.

Change-Id: Iad6ee3951bc4e8b8bc519c62642a2b4bcd949c18
Signed-off-by: nikesh <Nikesh.Oswal@wolfsonmicro.com>
---
 include/sound/soc-dapm.h |    7 ++++---
 include/sound/soc.h      |    4 +++-
 sound/soc/soc-core.c     |    4 ++--
 sound/soc/soc-dapm.c     |   21 +++++++++++++++++----
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 68d92e3..e3497ed 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -414,9 +414,10 @@ int snd_soc_dapm_new_dai_widgets(struct snd_soc_dapm_context *dapm,
 int snd_soc_dapm_link_dai_widgets(struct snd_soc_card *card);
 void snd_soc_dapm_connect_dai_link_widgets(struct snd_soc_card *card);
 int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
-			 const struct snd_soc_pcm_stream *params,
+			 struct snd_soc_pcm_stream *params,
 			 struct snd_soc_dapm_widget *source,
-			 struct snd_soc_dapm_widget *sink);
+			 struct snd_soc_dapm_widget *sink,
+			 struct snd_soc_dai_link *dai_link);
 
 /* dapm path setup */
 int snd_soc_dapm_new_widgets(struct snd_soc_card *card);
@@ -561,7 +562,7 @@ struct snd_soc_dapm_widget {
 
 	void *priv;				/* widget specific data */
 	struct regulator *regulator;		/* attached regulator */
-	const struct snd_soc_pcm_stream *params; /* params for dai links */
+	struct snd_soc_pcm_stream *params; /* params for dai links */
 
 	/* dapm control */
 	int reg;				/* negative reg = no direct dapm */
diff --git a/include/sound/soc.h b/include/sound/soc.h
index 9a00147..401c911 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -875,7 +875,9 @@ struct snd_soc_dai_link {
 	const struct device_node *platform_of_node;
 	int be_id;	/* optional ID for machine driver BE identification */
 
-	const struct snd_soc_pcm_stream *params;
+	struct snd_soc_pcm_stream *params;
+	/* optional params re-writing for dai links */
+	int (*params_fixup)(struct snd_soc_dapm_widget *w, int event);
 
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
index dc8ff13..dc1ef8b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3378,11 +3378,12 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_dapm_path *source_p, *sink_p;
 	struct snd_soc_dai *source, *sink;
-	const struct snd_soc_pcm_stream *config = w->params;
+	struct snd_soc_pcm_stream *config = w->params;
+	struct snd_soc_dai_link *dai_link = w->priv;
 	struct snd_pcm_substream substream;
 	struct snd_pcm_hw_params *params = NULL;
 	u64 fmt;
-	int ret;
+	int ret = 0;
 
 	if (WARN_ON(!config) ||
 	    WARN_ON(list_empty(&w->sources) || list_empty(&w->sinks)))
@@ -3402,6 +3403,16 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 	source = source_p->source->priv;
 	sink = sink_p->sink->priv;
 
+	if (dai_link && dai_link->params_fixup) {
+		ret = dai_link->params_fixup(w, event);
+		if (ret < 0) {
+			dev_err(w->dapm->dev,
+				"ASoC: params_fixup for dai link widget failed %d\n",
+				ret);
+			goto out;
+		}
+	}
+
 	/* Be a little careful as we don't want to overflow the mask array */
 	if (config->formats) {
 		fmt = ffs(config->formats) - 1;
@@ -3483,9 +3494,10 @@ out:
 }
 
 int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
-			 const struct snd_soc_pcm_stream *params,
+			 struct snd_soc_pcm_stream *params,
 			 struct snd_soc_dapm_widget *source,
-			 struct snd_soc_dapm_widget *sink)
+			 struct snd_soc_dapm_widget *sink,
+			 struct snd_soc_dai_link *dai_link)
 {
 	struct snd_soc_dapm_route routes[2];
 	struct snd_soc_dapm_widget template;
@@ -3517,6 +3529,7 @@ int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 	}
 
 	w->params = params;
+	w->priv = (void *)dai_link;
 
 	memset(&routes, 0, sizeof(routes));
 
-- 
1.7.9.5

