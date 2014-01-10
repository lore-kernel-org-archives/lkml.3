Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaAJHSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:18:13 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:53149 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaAJHSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:18:10 -0500
Date: Fri, 10 Jan 2014 08:17:29 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <broonie@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: simple-card: fix one bug to writing
 to the platform data
Message-ID: <20140110081729.035ce46f@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiubo Li wrote:

> It's a bug that writing to the platform data directly, for it should
> be constant. So just copy it before writing.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo at freescale.com>
> ---
>  sound/soc/generic/simple-card.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> index 406e4ea..5b65324 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
	[snip]
> @@ -204,36 +205,37 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
>  	struct device_node *np = pdev->dev.of_node;
>  	struct device_node *of_cpu, *of_codec, *of_platform;
>  	struct device *dev = &pdev->dev;
> +	int ret;
>  
>  	cinfo		= NULL;
>  	of_cpu		= NULL;
>  	of_codec	= NULL;
>  	of_platform	= NULL;
> +
> +	cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
> +	if (!cinfo)
> +		return -ENOMEM;
> +
>  	if (np && of_device_is_available(np)) {
> -		cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
> -		if (cinfo) {
> -			int ret;
> -			cinfo->snd_card.dev = &pdev->dev;
> -			ret = asoc_simple_card_parse_of(np, cinfo, dev,
> -							&of_cpu,
> -							&of_codec,
> -							&of_platform);
> -			if (ret < 0) {
> -				if (ret != -EPROBE_DEFER)
> -					dev_err(dev, "parse error %d\n", ret);
> -				return ret;
> -			}
> -		} else {
> -			return -ENOMEM;
> +		cinfo->snd_card.dev = dev;
> +
> +		ret = asoc_simple_card_parse_of(np, cinfo, dev,
> +						&of_cpu,
> +						&of_codec,
> +						&of_platform);
> +		if (ret < 0) {
> +			if (ret != -EPROBE_DEFER)
> +				dev_err(dev, "parse error %d\n", ret);
> +			return ret;
>  		}
>  	} else {
> -		cinfo = pdev->dev.platform_data;
> -		if (!cinfo) {
> +		if (!pdev->dev.platform_data) {
>  			dev_err(dev, "no info for asoc-simple-card\n");
>  			return -EINVAL;
>  		}
>  
> -		cinfo->snd_card.dev = &pdev->dev;
> +		memcpy(cinfo, pdev->dev.platform_data, sizeof(cinfo));
> +		cinfo->snd_card.dev = dev;
>  	}
>  
>  	if (!cinfo->name	||

If the original cinfo is not used anymore, the use of its structure to
handle the card information is not a good idea:

- almost all cinfo information are in the struct snd_soc_card,

- this cinfo structure cannot be extended to handle many DAI links,

- it contains simple-card information which are of no use for the
  platform caller.

So, I'd rather have seen:

- the removal of 'snd_link' and 'snd_card' from the platform interface
  (struct asoc_simple_card_info),

- the definition of a local struct simple_card_data containing the
  struct snd_soc_card and a pointer to an array of fmt/sysclk values
  (one per DAI link).

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
