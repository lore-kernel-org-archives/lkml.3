Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbbAOOHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:07:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37754 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbbAOOHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:07:23 -0500
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH v8] ASoC: dapm: add code to configure dai link parameters
Date: Thu, 15 Jan 2015 14:07:11 +0000
Message-Id: <1421330832-15449-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dai-link params for codec-codec links were fixed. The fixed
link between codec and another chip which may be another codec,
baseband, bluetooth codec etc may require run time configuaration
changes. This change provides an optional alsa control to select
one of the params from a list of params.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
---
 include/sound/soc-dapm.h |    3 +
 include/sound/soc.h      |    1 +
 sound/soc/soc-core.c     |    6 +-
 sound/soc/soc-dapm.c     |  155 ++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 157 insertions(+), 8 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 5c0a798..a2098e4 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -378,6 +378,7 @@ int snd_soc_dapm_link_dai_widgets(struct snd_soc_card *card);
 void snd_soc_dapm_connect_dai_link_widgets(struct snd_soc_card *card);
 int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 			 const struct snd_soc_pcm_stream *params,
+			 unsigned int num_params,
 			 struct snd_soc_dapm_widget *source,
 			 struct snd_soc_dapm_widget *sink);
 
@@ -531,6 +532,8 @@ struct snd_soc_dapm_widget {
 	void *priv;				/* widget specific data */
 	struct regulator *regulator;		/* attached regulator */
 	const struct snd_soc_pcm_stream *params; /* params for dai links */
+	unsigned int num_params; /* number of params for dai links */
+	unsigned int params_select; /* currently selected param for dai link */
 
 	/* dapm control */
 	int reg;				/* negative reg = no direct dapm */
diff --git a/include/sound/soc.h b/include/sound/soc.h
index edd4a0a..7556885 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -940,6 +940,7 @@ struct snd_soc_dai_link {
 	int be_id;	/* optional ID for machine driver BE identification */
 
 	const struct snd_soc_pcm_stream *params;
+	unsigned int num_params;
 
 	unsigned int dai_fmt;           /* format to set on init */
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index ededb97..893a6e5 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1230,7 +1230,8 @@ static int soc_link_dai_widgets(struct snd_soc_card *card,
 	capture_w = cpu_dai->capture_widget;
 	if (play_w && capture_w) {
 		ret = snd_soc_dapm_new_pcm(card, dai_link->params,
-					   capture_w, play_w);
+					   dai_link->num_params, capture_w,
+					   play_w);
 		if (ret != 0) {
 			dev_err(card->dev, "ASoC: Can't link %s to %s: %d\n",
 				play_w->name, capture_w->name, ret);
@@ -1242,7 +1243,8 @@ static int soc_link_dai_widgets(struct snd_soc_card *card,
 	capture_w = codec_dai->capture_widget;
 	if (play_w && capture_w) {
 		ret = snd_soc_dapm_new_pcm(card, dai_link->params,
-					   capture_w, play_w);
+					   dai_link->num_params, capture_w,
+					   play_w);
 		if (ret != 0) {
 			dev_err(card->dev, "ASoC: Can't link %s to %s: %d\n",
 				play_w->name, capture_w->name, ret);
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index bc2d7a0..286413b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -853,6 +853,36 @@ static int dapm_new_pga(struct snd_soc_dapm_widget *w)
 	return 0;
 }
 
+/* create new dapm dai link control */
+static int dapm_new_dai_link(struct snd_soc_dapm_widget *w)
+{
+	int i, ret;
+	struct snd_kcontrol *kcontrol;
+	struct snd_soc_dapm_context *dapm = w->dapm;
+	struct snd_card *card = dapm->card->snd_card;
+
+	/* create control for links with > 1 config */
+	if (w->num_params <= 1)
+		return 0;
+
+	/* add kcontrol */
+	for (i = 0; i < w->num_kcontrols; i++) {
+		kcontrol = snd_soc_cnew(&w->kcontrol_news[i], w,
+					w->name, NULL);
+		ret = snd_ctl_add(card, kcontrol);
+		if (ret < 0) {
+			dev_err(dapm->dev,
+				"ASoC: failed to add widget %s dapm kcontrol %s: %d\n",
+				w->name, w->kcontrol_news[i].name, ret);
+			return ret;
+		}
+		kcontrol->private_data = w;
+		w->kcontrols[i] = kcontrol;
+	}
+
+	return 0;
+}
+
 /* We implement power down on suspend by checking the power state of
  * the ALSA card - when we are suspending the ALSA state for the card
  * is set to D3.
@@ -2724,6 +2754,9 @@ int snd_soc_dapm_new_widgets(struct snd_soc_card *card)
 		case snd_soc_dapm_out_drv:
 			dapm_new_pga(w);
 			break;
+		case snd_soc_dapm_dai_link:
+			dapm_new_dai_link(w);
+			break;
 		default:
 			break;
 		}
@@ -3198,7 +3231,7 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 {
 	struct snd_soc_dapm_path *source_p, *sink_p;
 	struct snd_soc_dai *source, *sink;
-	const struct snd_soc_pcm_stream *config = w->params;
+	const struct snd_soc_pcm_stream *config = w->params + w->params_select;
 	struct snd_pcm_substream substream;
 	struct snd_pcm_hw_params *params = NULL;
 	u64 fmt;
@@ -3290,8 +3323,39 @@ out:
 	return ret;
 }
 
+static int snd_soc_dapm_dai_link_get(struct snd_kcontrol *kcontrol,
+			  struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_dapm_widget *w = snd_kcontrol_chip(kcontrol);
+
+	ucontrol->value.integer.value[0] = w->params_select;
+
+	return 0;
+}
+
+static int snd_soc_dapm_dai_link_put(struct snd_kcontrol *kcontrol,
+			  struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_dapm_widget *w = snd_kcontrol_chip(kcontrol);
+
+	/* Can't change the config when widget is already powered */
+	if (w->power)
+		return -EBUSY;
+
+	if (ucontrol->value.integer.value[0] == w->params_select)
+		return 0;
+
+	if (ucontrol->value.integer.value[0] >= w->num_params)
+		return -EINVAL;
+
+	w->params_select = ucontrol->value.integer.value[0];
+
+	return 0;
+}
+
 int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 			 const struct snd_soc_pcm_stream *params,
+			 unsigned int num_params,
 			 struct snd_soc_dapm_widget *source,
 			 struct snd_soc_dapm_widget *sink)
 {
@@ -3299,14 +3363,52 @@ int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 	struct snd_soc_dapm_widget *w;
 	size_t len;
 	char *link_name;
-	int ret;
+	int ret, count;
+	unsigned long private_value;
+	const char **w_param_text;
+	struct soc_enum w_param_enum[] = {
+		SOC_ENUM_SINGLE(0, 0, 0, NULL),
+	};
+	struct snd_kcontrol_new kcontrol_dai_link[] = {
+		SOC_ENUM_EXT(NULL, w_param_enum[0],
+			     snd_soc_dapm_dai_link_get,
+			     snd_soc_dapm_dai_link_put),
+	};
+	const struct snd_soc_pcm_stream *config = params;
+
+	w_param_text = devm_kcalloc(card->dev, num_params,
+					sizeof(char *), GFP_KERNEL);
+	if (!w_param_text)
+		return -ENOMEM;
 
 	len = strlen(source->name) + strlen(sink->name) + 2;
 	link_name = devm_kzalloc(card->dev, len, GFP_KERNEL);
-	if (!link_name)
-		return -ENOMEM;
+	if (!link_name) {
+		ret = -ENOMEM;
+		goto outfree_w_param;
+	}
 	snprintf(link_name, len, "%s-%s", source->name, sink->name);
 
+	for (count = 0 ; count < num_params; count++) {
+		if (!config->stream_name) {
+			dev_warn(card->dapm.dev,
+				"ASoC: anonymous config %d for dai link %s\n",
+				count, link_name);
+		} else {
+			w_param_text[count] = devm_kmemdup(card->dev,
+						config->stream_name,
+						strlen(config->stream_name) + 1,
+						GFP_KERNEL);
+			if (!w_param_text[count]) {
+				ret = -ENOMEM;
+				goto outfree_link_name;
+			}
+		}
+		config++;
+	}
+	w_param_enum[0].items = num_params;
+	w_param_enum[0].texts = w_param_text;
+
 	memset(&template, 0, sizeof(template));
 	template.reg = SND_SOC_NOPM;
 	template.id = snd_soc_dapm_dai_link;
@@ -3314,6 +3416,30 @@ int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 	template.event = snd_soc_dai_link_event;
 	template.event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU |
 		SND_SOC_DAPM_PRE_PMD;
+	template.num_kcontrols = 1;
+	/* duplicate w_param_enum on heap so that memory persists */
+	private_value =
+		(unsigned long) devm_kmemdup(card->dev,
+			(void *)(kcontrol_dai_link[0].private_value),
+			sizeof(struct soc_enum), GFP_KERNEL);
+	if (!private_value) {
+		dev_err(card->dev, "ASoC: Failed to create control for %s widget\n",
+			link_name);
+		ret = -ENOMEM;
+		goto outfree_link_name;
+	}
+	kcontrol_dai_link[0].private_value = private_value;
+	/* duplicate kcontrol_dai_link on heap so that memory persists */
+	template.kcontrol_news =
+				devm_kmemdup(card->dev, &kcontrol_dai_link[0],
+					sizeof(struct snd_kcontrol_new),
+					GFP_KERNEL);
+	if (!template.kcontrol_news) {
+		dev_err(card->dev, "ASoC: Failed to create control for %s widget\n",
+			link_name);
+		ret = -ENOMEM;
+		goto outfree_private_value;
+	}
 
 	dev_dbg(card->dev, "ASoC: adding %s widget\n", link_name);
 
@@ -3321,15 +3447,32 @@ int snd_soc_dapm_new_pcm(struct snd_soc_card *card,
 	if (!w) {
 		dev_err(card->dev, "ASoC: Failed to create %s widget\n",
 			link_name);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto outfree_kcontrol_news;
 	}
 
 	w->params = params;
+	w->num_params = num_params;
 
 	ret = snd_soc_dapm_add_path(&card->dapm, source, w, NULL, NULL);
 	if (ret)
-		return ret;
+		goto outfree_w;
 	return snd_soc_dapm_add_path(&card->dapm, w, sink, NULL, NULL);
+
+outfree_w:
+	devm_kfree(card->dev, w);
+outfree_kcontrol_news:
+	devm_kfree(card->dev, (void *)template.kcontrol_news);
+outfree_private_value:
+	devm_kfree(card->dev, (void *)private_value);
+outfree_link_name:
+	devm_kfree(card->dev, link_name);
+outfree_w_param:
+	for (count = 0 ; count < num_params; count++)
+		devm_kfree(card->dev, (void *)w_param_text[count]);
+	devm_kfree(card->dev, w_param_text);
+
+	return ret;
 }
 
 int snd_soc_dapm_new_dai_widgets(struct snd_soc_dapm_context *dapm,
-- 
1.7.9.5

