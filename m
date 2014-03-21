Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965977AbaCUAJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:09:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965867AbaCUAJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick Lai <plai@codeaurora.org>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 56/85] ASoC: pcm: free path list before exiting from error conditions
Date: Thu, 20 Mar 2014 17:09:59 -0700
Message-Id: <20140321000606.724570655@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Lai <plai@codeaurora.org>

commit e4ad1accb28d0ed8cea6f12395d58686ad344ca7 upstream.

dpcm_path_get() allocates dynamic memory to hold path list.
Corresponding dpcm_path_put() must be called to free the memory.
dpcm_path_put() is not called under several error conditions.
This leads to memory leak.

Signed-off-by: Patrick Lai <plai@codeaurora.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1864,6 +1864,7 @@ int soc_dpcm_runtime_update(struct snd_s
 
 		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_PLAYBACK, &list);
 		if (paths < 0) {
+			dpcm_path_put(&list);
 			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
 					fe->dai_link->name,  "playback");
 			mutex_unlock(&card->mutex);
@@ -1893,6 +1894,7 @@ capture:
 
 		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_CAPTURE, &list);
 		if (paths < 0) {
+			dpcm_path_put(&list);
 			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
 					fe->dai_link->name,  "capture");
 			mutex_unlock(&card->mutex);
@@ -1957,6 +1959,7 @@ static int dpcm_fe_dai_open(struct snd_p
 	fe->dpcm[stream].runtime = fe_substream->runtime;
 
 	if (dpcm_path_get(fe, stream, &list) <= 0) {
+		dpcm_path_put(&list);
 		dev_dbg(fe->dev, "ASoC: %s no valid %s route\n",
 			fe->dai_link->name, stream ? "capture" : "playback");
 	}


