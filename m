Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaESJ2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:28:41 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1052 "EHLO
	smtp-out-145.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752832AbaESJ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:28:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5070
Message-ID: <5379CEC4.9050001@metafoo.de>
Date: Mon, 19 May 2014 11:28:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org, tiwai@suse.de,
        perex@perex.cz
Subject: Re: [PATCH] ALSA: pcm_dmaengine: Add check during device suspend
References: <1400491433-16860-1-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1400491433-16860-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 11:23 AM, Tushar Behera wrote:
> Currently snd_dmaengine_pcm_trigger() calls dmaengine_pause()
> unconditinally during device suspend. In case where DMA controller
> doesn't support PAUSE/RESUME functionality, this call is not able
> to stop the DMA controller. In this scenario, audio playback doesn't
> resume after device resume.
>
> Calling dmaengine_pause/dmaengine_terminate_all conditionally fixes
> the issue.
>
> It has been tested with audio playback on Samsung platform having
> PL330 DMA controller which doesn't support PAUSE/RESUME.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>   sound/core/pcm_dmaengine.c |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
> index 94d0873..76cbb9e 100644
> --- a/sound/core/pcm_dmaengine.c
> +++ b/sound/core/pcm_dmaengine.c
> @@ -182,6 +182,7 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
>   int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
>   {
>   	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
> +	struct snd_pcm_runtime *runtime = substream->runtime;
>   	int ret;
>
>   	switch (cmd) {
> @@ -196,6 +197,11 @@ int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
>   		dmaengine_resume(prtd->dma_chan);
>   		break;
>   	case SNDRV_PCM_TRIGGER_SUSPEND:
> +		if (runtime->info & SNDRV_PCM_INFO_PAUSE)
> +			dmaengine_pause(prtd->dma_chan);
> +		else
> +			dmaengine_terminate_all(prtd->dma_chan);
> +		break;
>   	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>   		dmaengine_pause(prtd->dma_chan);
>   		break;
>

