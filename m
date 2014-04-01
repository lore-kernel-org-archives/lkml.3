Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaDAQml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:42:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaDAQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick Lai <plai@codeaurora.org>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 57/86] ASoC: pcm: free path list before exiting from error conditions
Date: Tue,  1 Apr 2014 09:08:10 -0700
Message-Id: <1396368519-12728-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Lai <plai@codeaurora.org>

commit e4ad1accb28d0ed8cea6f12395d58686ad344ca7 upstream.

dpcm_path_get() allocates dynamic memory to hold path list.
Corresponding dpcm_path_put() must be called to free the memory.
dpcm_path_put() is not called under several error conditions.
This leads to memory leak.

Signed-off-by: Patrick Lai <plai@codeaurora.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/soc-pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index cf191e6..2d0dbd2 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1866,6 +1866,7 @@ int soc_dpcm_runtime_update(struct snd_soc_dapm_widget *widget)
 
 		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_PLAYBACK, &list);
 		if (paths < 0) {
+			dpcm_path_put(&list);
 			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
 					fe->dai_link->name,  "playback");
 			mutex_unlock(&card->mutex);
@@ -1895,6 +1896,7 @@ capture:
 
 		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_CAPTURE, &list);
 		if (paths < 0) {
+			dpcm_path_put(&list);
 			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
 					fe->dai_link->name,  "capture");
 			mutex_unlock(&card->mutex);
@@ -1959,6 +1961,7 @@ static int dpcm_fe_dai_open(struct snd_pcm_substream *fe_substream)
 	fe->dpcm[stream].runtime = fe_substream->runtime;
 
 	if (dpcm_path_get(fe, stream, &list) <= 0) {
+		dpcm_path_put(&list);
 		dev_dbg(fe->dev, "ASoC: %s no valid %s route\n",
 			fe->dai_link->name, stream ? "capture" : "playback");
 	}
-- 
1.8.3.2

