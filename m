Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3CKJ7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:59:48 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1097 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3CKJ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:59:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29314
Message-ID: <513DAB80.1020900@metafoo.de>
Date: Mon, 11 Mar 2013 11:01:36 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        device-drivers-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: adau1373: adau1373_hw_params: Silence overflow
 warning
References: <1362936878-84443-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1362936878-84443-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 06:34 PM, Tim Gardner wrote:
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
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: device-drivers-devel@blackfin.uclinux.org
> Cc: alsa-devel@alsa-project.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  sound/soc/codecs/adau1373.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
> index 068b3ae..56ed788 100644
> --- a/sound/soc/codecs/adau1373.c
> +++ b/sound/soc/codecs/adau1373.c
> @@ -132,7 +132,7 @@ struct adau1373 {
>  #define ADAU1373_DAI_FORMAT_I2S		0x2
>  #define ADAU1373_DAI_FORMAT_DSP		0x3
>  
> -#define ADAU1373_BCLKDIV_SOURCE		BIT(5)
> +#define ADAU1373_BCLKDIV_SOURCE		(unsigned int)BIT(5)

Hm, that's a bit ugly. How about the following instead:

diff --git a/sound/soc/codecs/adau1373.c b/sound/soc/codecs/adau1373.c
index 068b3ae..1aa10dd 100644
--- a/sound/soc/codecs/adau1373.c
+++ b/sound/soc/codecs/adau1373.c
@@ -133,6 +133,8 @@ struct adau1373 {
 #define ADAU1373_DAI_FORMAT_DSP		0x3

 #define ADAU1373_BCLKDIV_SOURCE		BIT(5)
+#define ADAU1373_BCLKDIV_SR_MASK	(0x07 << 2)
+#define ADAU1373_BCLKDIV_BCLK_MASK	0x03
 #define ADAU1373_BCLKDIV_32		0x03
 #define ADAU1373_BCLKDIV_64		0x02
 #define ADAU1373_BCLKDIV_128		0x01
@@ -937,7 +939,8 @@ static int adau1373_hw_params(struct snd_pcm_substream
*substream,
 	adau1373_dai->enable_src = (div != 0);

 	snd_soc_update_bits(codec, ADAU1373_BCLKDIV(dai->id),
-		~ADAU1373_BCLKDIV_SOURCE, (div << 2) | ADAU1373_BCLKDIV_64);
+		ADAU1373_BCLKDIV_SR_MASK | ADAU1373_BCLKDIV_BCLK_MASK,
+		(div << 2) | ADAU1373_BCLKDIV_64);

 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:


