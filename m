Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaEDPlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaEDPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 003/158] ASoC: pcm: Drop incorrect double/extra frees
Date: Sun,  4 May 2014 11:38:32 -0400
Message-Id: <20140504154030.472366571@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 017d9491ce203c620ad1377f46a3ce78d554b2de upstream.

The changes in "ASoC: pcm: free path list before exiting from error
conditions" actually introduced both double frees (in case where the
path list was allocated but empty) and frees of unallocated memory (in
cases where the error being handled was -ENOMEM.  Drop the commit for
now.

Fixes: e4ad1accb (ASoC: pcm: free path list before exiting from error conditions)
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1989,7 +1989,6 @@ int soc_dpcm_runtime_update(struct snd_s
 
 		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_PLAYBACK, &list);
 		if (paths < 0) {
-			dpcm_path_put(&list);
 			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
 					fe->dai_link->name,  "playback");
 			mutex_unlock(&card->mutex);
@@ -2019,7 +2018,6 @@ capture:
 
 		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_CAPTURE, &list);
 		if (paths < 0) {
-			dpcm_path_put(&list);
 			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
 					fe->dai_link->name,  "capture");
 			mutex_unlock(&card->mutex);
@@ -2084,7 +2082,6 @@ static int dpcm_fe_dai_open(struct snd_p
 	fe->dpcm[stream].runtime = fe_substream->runtime;
 
 	if (dpcm_path_get(fe, stream, &list) <= 0) {
-		dpcm_path_put(&list);
 		dev_dbg(fe->dev, "ASoC: %s no valid %s route\n",
 			fe->dai_link->name, stream ? "capture" : "playback");
 	}


