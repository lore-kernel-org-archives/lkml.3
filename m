Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197Ab3DCJ06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:26:58 -0400
Received: from smtp-out-217.synserver.de ([212.40.185.217]:1177 "EHLO
	smtp-out-217.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761386Ab3DCJ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:26:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4496
Message-ID: <515C03BC.3040301@metafoo.de>
Date: Wed, 03 Apr 2013 12:26:04 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, swarren@wwwdotorg.org,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, tiwai@suse.de, perex@perex.cz
Subject: Re: [PATCH] sound: soc: tegra: do not provide PAUSE/RESUME in hardware
 info
References: <1364980781-2204-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1364980781-2204-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 11:19 AM, Laxman Dewangan wrote:
> Tegra PCM driver uses the dmaengine based DMA driver and Tegra DMA
> driver does not support the pause/resume functionality as hardware
> does not support it.
> 
> ALSA driver support the sw based pause/resume functionality if hardware
> does not support it and in this case, hw driver should not provide
> the hardware info with PAUSE/RESUME bit enable.
> 
> Remmoving the SNDRV_PCM_INFO_PAUSE and SNDRV_PCM_INFO_RESUME from hardware
> info and using the snd_dmaengine_pcm_trigger() for pcm_trigger callback.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Hm, I sent out the same patch just half an our or so ago.

- Lars

> ---
> Lars reported that if driver/chip dma driver does not support the pause/resume
> then need not to export this info through the hw capability and leave this
> implementation to alsa driver.
> 
> Making the change accordingly.
> 
>  sound/soc/tegra/tegra_pcm.c |   24 +-----------------------
>  1 files changed, 1 insertions(+), 23 deletions(-)
> 
> diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
> index e67af0b..117cccc 100644
> --- a/sound/soc/tegra/tegra_pcm.c
> +++ b/sound/soc/tegra/tegra_pcm.c
> @@ -43,8 +43,6 @@
>  static const struct snd_pcm_hardware tegra_pcm_hardware = {
>  	.info			= SNDRV_PCM_INFO_MMAP |
>  				  SNDRV_PCM_INFO_MMAP_VALID |
> -				  SNDRV_PCM_INFO_PAUSE |
> -				  SNDRV_PCM_INFO_RESUME |
>  				  SNDRV_PCM_INFO_INTERLEAVED,
>  	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
>  	.channels_min		= 2,
> @@ -121,26 +119,6 @@ static int tegra_pcm_hw_free(struct snd_pcm_substream *substream)
>  	return 0;
>  }
>  
> -static int tegra_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
> -{
> -	switch (cmd) {
> -	case SNDRV_PCM_TRIGGER_START:
> -	case SNDRV_PCM_TRIGGER_RESUME:
> -	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> -		return snd_dmaengine_pcm_trigger(substream,
> -					SNDRV_PCM_TRIGGER_START);
> -
> -	case SNDRV_PCM_TRIGGER_STOP:
> -	case SNDRV_PCM_TRIGGER_SUSPEND:
> -	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		return snd_dmaengine_pcm_trigger(substream,
> -					SNDRV_PCM_TRIGGER_STOP);
> -	default:
> -		return -EINVAL;
> -	}
> -	return 0;
> -}
> -
>  static int tegra_pcm_mmap(struct snd_pcm_substream *substream,
>  				struct vm_area_struct *vma)
>  {
> @@ -158,7 +136,7 @@ static struct snd_pcm_ops tegra_pcm_ops = {
>  	.ioctl		= snd_pcm_lib_ioctl,
>  	.hw_params	= tegra_pcm_hw_params,
>  	.hw_free	= tegra_pcm_hw_free,
> -	.trigger	= tegra_pcm_trigger,
> +	.trigger	= snd_dmaengine_pcm_trigger,
>  	.pointer	= snd_dmaengine_pcm_pointer,
>  	.mmap		= tegra_pcm_mmap,
>  };

