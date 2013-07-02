Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3GBJnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:43:19 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:57491 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250Ab3GBJnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:43:18 -0400
From: Nenghua Cao <nhcao@marvell.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
CC: Henry zhao <xzhao10@marvell.com>, nhcao <nhcao@marvell.com>
Subject: [PATCH] ASOC: pcm: support fe dapm widget derived from codec_dai
Date: Tue, 2 Jul 2013 17:42:46 +0800
Message-ID: <1372758166-14798-1-git-send-email-nhcao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: nhcao <nhcao@marvell.com>

	In some chips, the codec_dai in cpu is abstracted as one dapm
widget. Enhance the framework to use codec_dai as fe widget.

Change-Id: I1b545bd1e2f24288f4508a7c6d4efbcfe1e03c5b
Signed-off-by: nhcao <nhcao@marvell.com>
---
 sound/soc/soc-pcm.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 73bb8ee..6ca23d7 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -856,17 +856,37 @@ static int widget_in_list(struct snd_soc_dapm_widget_list *list,
 static int dpcm_path_get(struct snd_soc_pcm_runtime *fe,
 	int stream, struct snd_soc_dapm_widget_list **list_)
 {
-	struct snd_soc_dai *cpu_dai = fe->cpu_dai;
+	struct snd_soc_dai *dai = fe->cpu_dai ;
 	struct snd_soc_dapm_widget_list *list;
 	int paths;
 
+	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		if (fe->cpu_dai->playback_widget) {
+			dai = fe->cpu_dai;
+		} else if (fe->codec_dai->playback_widget) {
+			dai = fe->codec_dai;
+		} else {
+			dev_err(fe->dev, "ASoC: can't find the correspond playback_widget for the dai\n");
+			return -EINVAL;
+		}
+	} else if (stream == SNDRV_PCM_STREAM_CAPTURE) {
+		if (fe->cpu_dai->capture_widget) {
+			dai = fe->cpu_dai;
+		} else if (fe->codec_dai->capture_widget) {
+			dai = fe->codec_dai;
+		} else {
+			dev_err(fe->dev, "ASoC: can't find the correspond capture_widget for the dai\n");
+			return -EINVAL;
+		}
+	}
+
 	list = kzalloc(sizeof(struct snd_soc_dapm_widget_list) +
 			sizeof(struct snd_soc_dapm_widget *), GFP_KERNEL);
 	if (list == NULL)
 		return -ENOMEM;
 
 	/* get number of valid DAI paths and their widgets */
-	paths = snd_soc_dapm_dai_get_connected_widgets(cpu_dai, stream, &list);
+	paths = snd_soc_dapm_dai_get_connected_widgets(dai, stream, &list);
 
 	dev_dbg(fe->dev, "ASoC: found %d audio %s paths\n", paths,
 			stream ? "capture" : "playback");
-- 
1.7.0.4

