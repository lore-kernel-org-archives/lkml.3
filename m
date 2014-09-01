Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaIAGxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:53:09 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:2041 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaIAGxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:53:06 -0400
Date: Mon, 1 Sep 2014 08:54:25 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] ASoC: simple-card: Fix bug of wrong decrement DT
 node's refcount
Message-ID: <20140901085425.6553dac5@armhf>
In-Reply-To: <1409535327-11449-3-git-send-email-Li.Xiubo@freescale.com>
References: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
	<1409535327-11449-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2014 09:35:27 +0800
Xiubo Li <Li.Xiubo@freescale.com> wrote:

> DAI links's cpu_of_node's and codec_of_node's refcounts shouldn't
> be decremented immediately at the end of the probe() fucntion.
> Because we will still use them before the audio card is removed.

Right, but your patch seems a bit complicated. See below.

> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/generic/simple-card.c | 52 ++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 24 deletions(-)
> 
> diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> index 9e170fe..08c5d7d 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
> @@ -307,6 +307,22 @@ dai_link_of_err:
>  	return ret;
>  }
>  
> +static inline void
> +asoc_simple_card_unref(const struct snd_soc_dai_link *dai_link,
> +		       int num_links)
> +{
> +	struct device_node *np;
> +
> +	while (num_links--) {
> +		np = dai_link[num_links].cpu_of_node;
> +		if (np)
> +			of_node_put(np);
> +		np = dai_link[num_links].codec_of_node;
> +		if (np)
> +			of_node_put(np);
> +	}
> +}
> +
>  static int asoc_simple_card_parse_of(struct device_node *node,
>  				     struct simple_card_data *priv,
>  				     struct device *dev,
> @@ -355,6 +371,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
>  							   dai_props + i,
>  							   false);
>  			if (ret < 0) {
> +				asoc_simple_card_unref(dai_link, i + 1);
>  				of_node_put(np);
>  				return ret;
>  			}
> @@ -374,27 +391,6 @@ static int asoc_simple_card_parse_of(struct device_node *node,
>  	return 0;
>  }
>  
> -/* update the reference count of the devices nodes at end of probe */
> -static int asoc_simple_card_unref(struct platform_device *pdev)
> -{
> -	struct snd_soc_card *card = platform_get_drvdata(pdev);
> -	struct snd_soc_dai_link *dai_link;
> -	struct device_node *np;
> -	int num_links;
> -
> -	for (num_links = 0, dai_link = card->dai_link;
> -	     num_links < card->num_links;
> -	     num_links++, dai_link++) {
> -		np = (struct device_node *) dai_link->cpu_of_node;
> -		if (np)
> -			of_node_put(np);
> -		np = (struct device_node *) dai_link->codec_of_node;
> -		if (np)
> -			of_node_put(np);
> -	}
> -	return 0;
> -}
> -
>  static int asoc_simple_card_probe(struct platform_device *pdev)
>  {
>  	struct simple_card_data *priv;
> @@ -441,7 +437,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
>  		if (ret < 0) {
>  			if (ret != -EPROBE_DEFER)
>  				dev_err(dev, "parse error %d\n", ret);
> -			goto err;
> +			return ret;
>  		}
>  
>  	} else {
> @@ -483,11 +479,18 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
>  
>  	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
>  
> -err:
> -	asoc_simple_card_unref(pdev);
>  	return ret;
>  }

The main problem is there: don't unref the nodes is no error.
Why not simply:
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
+	if (ret >= 0)
+		return ret;		/* success */
 
 err:
	asoc_simple_card_unref(pdev);
 	return ret;
 }

? Then, the above stuff is not needed.

> +static int asoc_simple_card_remove(struct platform_device *pdev)
> +{
> +	struct snd_soc_card *card = platform_get_drvdata(pdev);
> +
> +	asoc_simple_card_unref(card->dai_link, card->num_links);
> +
> +	return 0;
> +}
> +
>  static const struct of_device_id asoc_simple_of_match[] = {
>  	{ .compatible = "simple-audio-card", },
>  	{},
> @@ -501,6 +504,7 @@ static struct platform_driver asoc_simple_card = {
>  		.of_match_table = asoc_simple_of_match,
>  	},
>  	.probe = asoc_simple_card_probe,
> +	.remove = asoc_simple_card_remove,
>  };
>  
>  module_platform_driver(asoc_simple_card);

OK.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
