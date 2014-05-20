Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaETFlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:41:08 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50486 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaETFlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:41:06 -0400
Message-ID: <537AEAEB.8040803@linaro.org>
Date: Tue, 20 May 2014 11:10:59 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
CC: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: soc: samsung: dma.c:  Fix for possible null pointer
 dereference
References: <1400535443-5886-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400535443-5886-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 03:07 AM, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  sound/soc/samsung/dma.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
> index dc09b71..1d9bcaa 100644
> --- a/sound/soc/samsung/dma.c
> +++ b/sound/soc/samsung/dma.c
> @@ -115,17 +115,19 @@ static void dma_enqueue(struct snd_pcm_substream *substream)
>  static void audio_buffdone(void *data)
>  {
>  	struct snd_pcm_substream *substream = data;
> -	struct runtime_data *prtd = substream->runtime->private_data;
> +	struct runtime_data *prtd = NULL;

I am not sure if this check is required as audio_buffdone() is set as a
callback function with known valid parameter during dma_enqueue().

>  
>  	pr_debug("Entered %s\n", __func__);
>  
> -	if (prtd->state & ST_RUNNING) {
> +	if (substream)
> +		prtd = substream->runtime->private_data;
> +
> +	if (prtd && prtd->state & ST_RUNNING) {

ditto as above

>  		prtd->dma_pos += prtd->dma_period;
>  		if (prtd->dma_pos >= prtd->dma_end)
>  			prtd->dma_pos = prtd->dma_start;
>  
> -		if (substream)
> -			snd_pcm_period_elapsed(substream);
> +		snd_pcm_period_elapsed(substream);

This check certainly can be removed as snd_pcm_period_elapsed() also
checks the validity of the argument.

-- 
Tushar Behera
