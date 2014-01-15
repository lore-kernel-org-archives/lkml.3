Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaAOVDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:03:25 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7436 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaAOVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:03:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 15 Jan 2014 13:03:10 -0800
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Arun Shamanna Lakshmi <aruns@nvidia.com>,
        Songhee Baek <sbaek@nvidia.com>
Subject: [PATCH] ASoC: dapm: Fix double prefix addition
Date: Wed, 15 Jan 2014 13:03:16 -0800
Message-ID: <1389819796-12858-1-git-send-email-aruns@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix for the codec driver can be used during dual identical
codec usecases. However, dapm adds prefix twice for codec DAI widget
in snd_soc_dapm_add_route API.

This change is to avoid double prefix addition for codec DAI widget
and is needed while using identical dual codecs.

Signed-off-by: Songhee Baek <sbaek@nvidia.com>
Signed-off-by: Arun Shamanna Lakshmi <aruns@nvidia.com>
---
 sound/soc/soc-dapm.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 2a44fe9..dc8ff13 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2476,7 +2476,8 @@ err:
 }
 
 static int snd_soc_dapm_add_route(struct snd_soc_dapm_context *dapm,
-				  const struct snd_soc_dapm_route *route)
+				  const struct snd_soc_dapm_route *route,
+				  unsigned int is_prefixed)
 {
 	struct snd_soc_dapm_widget *wsource = NULL, *wsink = NULL, *w;
 	struct snd_soc_dapm_widget *wtsource = NULL, *wtsink = NULL;
@@ -2486,7 +2487,7 @@ static int snd_soc_dapm_add_route(struct snd_soc_dapm_context *dapm,
 	char prefixed_source[80];
 	int ret;
 
-	if (dapm->codec && dapm->codec->name_prefix) {
+	if (dapm->codec && dapm->codec->name_prefix && !is_prefixed) {
 		snprintf(prefixed_sink, sizeof(prefixed_sink), "%s %s",
 			 dapm->codec->name_prefix, route->sink);
 		sink = prefixed_sink;
@@ -2614,7 +2615,7 @@ int snd_soc_dapm_add_routes(struct snd_soc_dapm_context *dapm,
 
 	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_INIT);
 	for (i = 0; i < num; i++) {
-		r = snd_soc_dapm_add_route(dapm, route);
+		r = snd_soc_dapm_add_route(dapm, route, false);
 		if (r < 0) {
 			dev_err(dapm->dev, "ASoC: Failed to add route %s -> %s -> %s\n",
 				route->source,
@@ -3670,7 +3671,7 @@ void snd_soc_dapm_connect_dai_link_widgets(struct snd_soc_card *card)
 				cpu_dai->codec->name, r.source,
 				codec_dai->platform->name, r.sink);
 
-			snd_soc_dapm_add_route(&card->dapm, &r);
+			snd_soc_dapm_add_route(&card->dapm, &r, true);
 		}
 
 		/* connect BE DAI capture if widgets are valid */
@@ -3681,7 +3682,7 @@ void snd_soc_dapm_connect_dai_link_widgets(struct snd_soc_card *card)
 				codec_dai->codec->name, r.source,
 				cpu_dai->platform->name, r.sink);
 
-			snd_soc_dapm_add_route(&card->dapm, &r);
+			snd_soc_dapm_add_route(&card->dapm, &r, true);
 		}
 
 	}
-- 
1.7.9.5

