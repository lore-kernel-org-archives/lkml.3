Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab3KZLA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:00:29 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:56531 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3KZLAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:00:24 -0500
Date: Tue, 26 Nov 2013 11:59:33 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <fabio.estevam@freescale.com>, <oskar@scara.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1] ASoC: SGTL5000: Fix kernel failed while getting
 regulator consumers
Message-ID: <20131126115933.74840d1a@ipc1.ka-ro>
In-Reply-To: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
References: <1385459713-6778-1-git-send-email-Li.Xiubo@freescale.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Xiubo Li wrote:
> SGTL5000 codec allows to use the internal LDO instead of VDDD, if the
> internal LDO is used, this caused the following kernel failed while trying
> to get the external VDDD regulator consumer.
> 
> Adding sgtl5000_external_vddd_used() to fix it. And this has been tested on
> VF610-TWR board.
> 
> sgtl5000 0-000a: Failed to get supply 'VDDD': -19
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> 
>  sound/soc/codecs/sgtl5000.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index 1f4093f..1a2d35a 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -1298,6 +1298,20 @@ static int sgtl5000_replace_vddd_with_ldo(struct snd_soc_codec *codec)
>  	return 0;
>  }
>  
> +static int sgtl5000_external_vddd_used(struct snd_soc_codec *codec)
> +{
> +	struct regulator *consumer;
> +	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
> +
> +	consumer = regulator_get(codec->dev, sgtl5000->supplies[VDDD].supply);
> +	if (IS_ERR(consumer)) {
> +		return 0;
> +	}
> +	regulator_put(consumer);
> +
> +	return 1;
> +}
> +
>  static int sgtl5000_enable_regulators(struct snd_soc_codec *codec)
>  {
>  	int reg;
> @@ -1310,9 +1324,7 @@ static int sgtl5000_enable_regulators(struct snd_soc_codec *codec)
>  	for (i = 0; i < ARRAY_SIZE(sgtl5000->supplies); i++)
>  		sgtl5000->supplies[i].supply = supply_names[i];
>  
> -	ret = regulator_bulk_get(codec->dev, ARRAY_SIZE(sgtl5000->supplies),
> -				sgtl5000->supplies);
> -	if (!ret)
> +	if (sgtl5000_external_vddd_used(codec))
>  		external_vddd = 1;
>  	else {
>  		ret = sgtl5000_replace_vddd_with_ldo(codec);
>
You could fix the coding style issue (braces on both branches
of the if clause) here too.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
