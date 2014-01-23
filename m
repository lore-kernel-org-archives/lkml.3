Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaAWHMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:12:05 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:35213 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaAWHME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:12:04 -0500
Date: Thu, 23 Jan 2014 08:11:51 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <lgirdwood@gmail.com>, <broonie@kernel.org>, <shawn.guo@linaro.org>,
        <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH Resend 2/8] ASoC: simple-card: fix
 __asoc_simple_card_dai_init
Message-ID: <20140123081151.35837d3b@armhf>
In-Reply-To: <1390453370-29194-3-git-send-email-Li.Xiubo@freescale.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
	<1390453370-29194-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 13:02:44 +0800
Xiubo Li <Li.Xiubo@freescale.com> wrote:

> If the CPU/CODEC DAI set_sysclk() is not support, the -ENOTSUPP will returnd.
> Here do the check like set_fmt().
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> 
> 
> 
> The VF610 Tower and VF610 LS1 platforms' ESAI and SPDIF will depend on this
> patch too.
> 
> 
> 
> 
>  sound/soc/generic/simple-card.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> index 6443c87..3b8c9a2 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
> @@ -31,16 +31,21 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
>  
>  	daifmt |= set->fmt;
>  
> -	if (daifmt)
> +	if (daifmt) {
>  		ret = snd_soc_dai_set_fmt(dai, daifmt);
> -
> -	if (ret == -ENOTSUPP) {
> -		dev_dbg(dai->dev, "ASoC: set_fmt is not supported\n");
> -		ret = 0;
> +		if (ret && ret != -ENOTSUPP) {
> +			dev_err(dai->dev, "simple-card: set_fmt error\n");
> +			return ret;
> +		}
>  	}
>  
> -	if (!ret && set->sysclk)
> +	if (set->sysclk) {
>  		ret = snd_soc_dai_set_sysclk(dai, 0, set->sysclk, 0);
> +		if (ret && ret != -ENOTSUPP) {
> +			dev_err(dai->dev, "simple-card: set_sysclk error\n");
> +			return ret;
> +		}
> +	}
>  
>  	return ret;

Sorry: you must return 0 here

>  }

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
