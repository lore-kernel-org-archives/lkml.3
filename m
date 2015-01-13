Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbbAMPA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:00:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:41415 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbbAMPA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:00:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="636637728"
Date: Tue, 13 Jan 2015 20:29:31 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ALSA: ASoC: soc-compress.c: fix NULL dereference
Message-ID: <20150113145931.GD3085@intel.com>
References: <1421147933-21802-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421147933-21802-1-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:18:53AM +0000, Qais Yousef wrote:
> In soc_new_compress() when rtd->dai_link->daynmic is set, we create the pcm
					   ^^^^^^^^
typo
> substreams with this call:
> 
>    ret = snd_pcm_new_internal(rtd->card->snd_card, new_name, num,
>                                    1, 0, &be_pcm);
> 
> which passes 0 as capture_count leading to
> 
>    be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream
> 
> being NULL, hence when trying to set rtd a few lines below we get an oops.
It is a good practice to add the oops here

> 
> Fix by using rtd->dai_link->dpcm_playback and rtd->dai_link->dpcm_capture as
> playback_count and capture_count to snd_pcm_new_internal().
> 
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: linux-kernel@vger.kernel.org
> ---
> v2->v1:
>    - use better way to fix it than just removing the line that caused the oops
> 
>  sound/soc/soc-compress.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
> index 590a82f01d0b..27a668463ad7 100644
> --- a/sound/soc/soc-compress.c
> +++ b/sound/soc/soc-compress.c
> @@ -659,7 +659,8 @@ int soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
>  			rtd->dai_link->stream_name);
>  
>  		ret = snd_pcm_new_internal(rtd->card->snd_card, new_name, num,
> -				1, 0, &be_pcm);
> +				rtd->dai_link->dpcm_playback,
> +				rtd->dai_link->dpcm_capture, &be_pcm);
>  		if (ret < 0) {
>  			dev_err(rtd->card->dev, "ASoC: can't create compressed for %s\n",
>  				rtd->dai_link->name);
> @@ -668,8 +669,10 @@ int soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
>  
>  		rtd->pcm = be_pcm;
>  		rtd->fe_compr = 1;
> -		be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
> -		be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
> +		if (rtd->dai_link->dpcm_playback)
> +			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
> +		if (rtd->dai_link->dpcm_capture)
this should be else if, as for compressed device we can have playback or
capture not both

> +			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
>  		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
>  	} else
>  		memcpy(compr->ops, &soc_compr_ops, sizeof(soc_compr_ops));
> -- 
> 2.1.0
> 

-- 
~Vinod
