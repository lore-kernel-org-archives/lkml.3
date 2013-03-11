Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3CKTYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:24:22 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33057 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab3CKTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:24:21 -0400
Message-ID: <513E2FF0.1000608@metafoo.de>
Date: Mon, 11 Mar 2013 20:26:40 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        device-drivers-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH linux-next v2] ASoC: adau1373: adau1373_hw_params: Silence
 overflow warning
References: <513E2895.6040904@metafoo.de> <1363029503-23880-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1363029503-23880-1-git-send-email-tim.gardner@canonical.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 08:18 PM, Tim Gardner wrote:
> ADAU1373_BCLKDIV_SOURCE is defined as BIT(5) which uses UL constants. On
> amd64 the result of the ones complement operator is then truncated to
> unsigned int according to the prototype of snd_soc_update_bits(). I think
> gcc is correctly warning that the upper 32 bits are lost.
> 
> sound/soc/codecs/adau1373.c: In function 'adau1373_hw_params':
> sound/soc/codecs/adau1373.c:940:3: warning: large integer implicitly truncated to unsigned type [-Woverflow]
> 
> gcc version 4.6.3
> 
> Add 2 more BCLKDIV mask macros as explained by Lars:
> 
> The BCLKDIV has three fields. The bitclock divider (bit 0-1), the samplerate
> (bit 2-4) and the source select (bit 5). Here we want to update the bitclock
> divider field and the samplerate field. When I wrote the code I was lazy and
> used ~ADAU1373_BCLKDIV_SOURCE as the mask, which for this register is
> functionally equivalent to ADAU1373_BCLKDIV_SR_MASK | ADAU1373_BCLKDIV_BCLK_MASK.
> 
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: device-drivers-devel@blackfin.uclinux.org
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
> v1 - simple cast solution
> v2 - Implement a full set of field masks as suggested by Lars.
> 
>  sound/soc/codecs/adau1373.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
> index 068b3ae..1aa10dd 100644
> --- a/sound/soc/codecs/adau1373.c
> +++ b/sound/soc/codecs/adau1373.c
> @@ -133,6 +133,8 @@ struct adau1373 {
>  #define ADAU1373_DAI_FORMAT_DSP		0x3
>  
>  #define ADAU1373_BCLKDIV_SOURCE		BIT(5)
> +#define ADAU1373_BCLKDIV_SR_MASK	(0x07 << 2)
> +#define ADAU1373_BCLKDIV_BCLK_MASK	0x03
>  #define ADAU1373_BCLKDIV_32		0x03
>  #define ADAU1373_BCLKDIV_64		0x02
>  #define ADAU1373_BCLKDIV_128		0x01
> @@ -937,7 +939,8 @@ static int adau1373_hw_params(struct snd_pcm_substream *substream,
>  	adau1373_dai->enable_src = (div != 0);
>  
>  	snd_soc_update_bits(codec, ADAU1373_BCLKDIV(dai->id),
> -		~ADAU1373_BCLKDIV_SOURCE, (div << 2) | ADAU1373_BCLKDIV_64);
> +		ADAU1373_BCLKDIV_SR_MASK | ADAU1373_BCLKDIV_BCLK_MASK,
> +		(div << 2) | ADAU1373_BCLKDIV_64);
>  
>  	switch (params_format(params)) {
>  	case SNDRV_PCM_FORMAT_S16_LE:

