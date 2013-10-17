Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3JQKQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:16:47 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:42441
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab3JQKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:16:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h1de097h8275bhz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1155h)
Date: Thu, 17 Oct 2013 17:56:20 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <r65073@freescale.com>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <r64188@freescale.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <perex@perex.cz>, <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b18965@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCHv1 5/8] ASoC: sgtl5000: Revise the bugs about the sgt15000
 codec.
Message-ID: <20131017095619.GA27044@MrMyself>
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
 <1382000477-17304-6-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382000477-17304-6-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 17, 2013 at 05:01:14PM +0800, Xiubo Li wrote:
> When the CONFIG_REGULATOR is disabled there will be some warnings
> printed out.

A little confused by the title. But after looking at the comments,
is the patch just gonna add some debug info for the case when the
CONFIG_REGULATOR's been un-selected? 

Well first, I think at least the title should be more explicit.
And second, the necessity of this patch might just a little...
if CONFIG_REGULATOR is required to power it up, why not turn it on.

> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/codecs/sgtl5000.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index 1f4093f..4e2e4c9 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -883,14 +883,19 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
>  				struct regulator_init_data *init_data,
>  				int voltage)
>  {
> +#ifdef CONFIG_SND_SOC_FSL_SGTL5000

Why there's FSL_SGTL5000 here? Not supposed to be CONFIG_REGULATOR?

> +	return 0;
> +#else
>  	dev_err(codec->dev, "this setup needs regulator support in the kernel\n");
>  	return -EINVAL;
> +#endif
>  }
>  
>  static int ldo_regulator_remove(struct snd_soc_codec *codec)
>  {
>  	return 0;
>  }
> +

I don't think it's fair to add a meaningless line. It doesn't make any sense
according to the title and comments.

>  #endif
>  
>  /*
> @@ -1137,6 +1142,7 @@ static int sgtl5000_resume(struct snd_soc_codec *codec)
>  #define sgtl5000_resume  NULL
>  #endif	/* CONFIG_SUSPEND */
>  
> +#ifdef CONFIG_REGULATOR

The inline regulator-related functions are already have REGULATOR dependency.
Is that necessary to put an additional one here?

>  /*
>   * sgtl5000 has 3 internal power supplies:
>   * 1. VAG, normally set to vdda/2
> @@ -1269,6 +1275,7 @@ static int sgtl5000_set_power_regs(struct snd_soc_codec *codec)
>  
>  	return 0;
>  }
> +#endif
>  
>  static int sgtl5000_replace_vddd_with_ldo(struct snd_soc_codec *codec)
>  {
> @@ -1370,6 +1377,7 @@ err_regulator_free:
>  				sgtl5000->supplies);
>  	if (external_vddd)
>  		ldo_regulator_remove(codec);
> +

Pls drop this.

>  	return ret;
>  
>  }
> @@ -1391,11 +1399,12 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
>  	if (ret)
>  		return ret;
>  
> +#ifdef CONFIG_REGULATOR
>  	/* power up sgtl5000 */
>  	ret = sgtl5000_set_power_regs(codec);
>  	if (ret)
>  		goto err;
> -
> +#endif
>  	/* enable small pop, introduce 400ms delay in turning off */
>  	snd_soc_update_bits(codec, SGTL5000_CHIP_REF_CTRL,
>  				SGTL5000_SMALL_POP,
> @@ -1446,6 +1455,7 @@ err:
>  						sgtl5000->supplies);
>  	regulator_bulk_free(ARRAY_SIZE(sgtl5000->supplies),
>  				sgtl5000->supplies);
> +

Ditto

>  	ldo_regulator_remove(codec);
>  
>  	return ret;
> @@ -1461,6 +1471,7 @@ static int sgtl5000_remove(struct snd_soc_codec *codec)
>  						sgtl5000->supplies);
>  	regulator_bulk_free(ARRAY_SIZE(sgtl5000->supplies),
>  				sgtl5000->supplies);
> +

Ditto 

Best regards,
Nicolin Chen

>  	ldo_regulator_remove(codec);
>  
>  	return 0;
> -- 
> 1.8.0
> 


