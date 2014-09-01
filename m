Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaIAHLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:11:41 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:44399
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751078AbaIAHLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:11:40 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "jsarha@ti.com" <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/2] ASoC: simple-card: Fix bug of wrong decrement DT
 node's refcount
Thread-Topic: [PATCHv2 2/2] ASoC: simple-card: Fix bug of wrong decrement DT
 node's refcount
Thread-Index: AQHPxYw1ao2bIoO95kK3sW4L1iZlZZvr2AmAgAAAruA=
Date: Mon, 1 Sep 2014 07:11:36 +0000
Message-ID: <1dfb7c81e6dd4fc3a273136482799af9@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
	<1409535327-11449-3-git-send-email-Li.Xiubo@freescale.com>
 <20140901085425.6553dac5@armhf>
In-Reply-To: <20140901085425.6553dac5@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199003)(51704005)(31966008)(101416001)(33646002)(76176999)(54356999)(50986999)(46102001)(15202345003)(21056001)(86362001)(15975445006)(20776003)(95666004)(85306004)(99286002)(105586002)(74662001)(107046002)(77982001)(90102001)(85852003)(106356001)(74502001)(108616004)(77096002)(74316001)(83322001)(81542001)(80022001)(19580405001)(76576001)(106116001)(19580395003)(110136001)(92566001)(81342001)(66066001)(87936001)(4396001)(79102001)(2656002)(76482001)(15866825004)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s817BlIn003258

> > DAI links's cpu_of_node's and codec_of_node's refcounts shouldn't
> > be decremented immediately at the end of the probe() fucntion.
> > Because we will still use them before the audio card is removed.
> 
> Right, but your patch seems a bit complicated. See below.
> 
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  sound/soc/generic/simple-card.c | 52 ++++++++++++++++++++++----------------
> ---
> >  1 file changed, 28 insertions(+), 24 deletions(-)
> >
> > diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-
> card.c
> > index 9e170fe..08c5d7d 100644
> > --- a/sound/soc/generic/simple-card.c
> > +++ b/sound/soc/generic/simple-card.c
> > @@ -307,6 +307,22 @@ dai_link_of_err:
> >  	return ret;
> >  }
> >
> > +static inline void
> > +asoc_simple_card_unref(const struct snd_soc_dai_link *dai_link,
> > +		       int num_links)
> > +{
> > +	struct device_node *np;
> > +
> > +	while (num_links--) {
> > +		np = dai_link[num_links].cpu_of_node;
> > +		if (np)
> > +			of_node_put(np);
> > +		np = dai_link[num_links].codec_of_node;
> > +		if (np)
> > +			of_node_put(np);
> > +	}
> > +}
> > +
> >  static int asoc_simple_card_parse_of(struct device_node *node,
> >  				     struct simple_card_data *priv,
> >  				     struct device *dev,
> > @@ -355,6 +371,7 @@ static int asoc_simple_card_parse_of(struct device_node
> *node,
> >  							   dai_props + i,
> >  							   false);
> >  			if (ret < 0) {
> > +				asoc_simple_card_unref(dai_link, i + 1);
> >  				of_node_put(np);
> >  				return ret;
> >  			}
> > @@ -374,27 +391,6 @@ static int asoc_simple_card_parse_of(struct device_node
> *node,
> >  	return 0;
> >  }
> >
> > -/* update the reference count of the devices nodes at end of probe */
> > -static int asoc_simple_card_unref(struct platform_device *pdev)
> > -{
> > -	struct snd_soc_card *card = platform_get_drvdata(pdev);
> > -	struct snd_soc_dai_link *dai_link;
> > -	struct device_node *np;
> > -	int num_links;
> > -
> > -	for (num_links = 0, dai_link = card->dai_link;
> > -	     num_links < card->num_links;
> > -	     num_links++, dai_link++) {
> > -		np = (struct device_node *) dai_link->cpu_of_node;
> > -		if (np)
> > -			of_node_put(np);
> > -		np = (struct device_node *) dai_link->codec_of_node;
> > -		if (np)
> > -			of_node_put(np);
> > -	}
> > -	return 0;
> > -}
> > -
> >  static int asoc_simple_card_probe(struct platform_device *pdev)
> >  {
> >  	struct simple_card_data *priv;
> > @@ -441,7 +437,7 @@ static int asoc_simple_card_probe(struct platform_device
> *pdev)
> >  		if (ret < 0) {
> >  			if (ret != -EPROBE_DEFER)
> >  				dev_err(dev, "parse error %d\n", ret);
> > -			goto err;
> > +			return ret;
> >  		}
> >
> >  	} else {
> > @@ -483,11 +479,18 @@ static int asoc_simple_card_probe(struct
> platform_device *pdev)
> >
> >  	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
> >
> > -err:
> > -	asoc_simple_card_unref(pdev);
> >  	return ret;
> >  }
> 
> The main problem is there: don't unref the nodes is no error.
> Why not simply:
> 
>  	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
> +	if (ret >= 0)
> +		return ret;		/* success */
> 
>  err:
> 	asoc_simple_card_unref(pdev);
>  	return ret;
>  }
> 
> ? Then, the above stuff is not needed.
> 

Why I moved the _unref() from the probe() to asoc_simple_card_parse_of()
Is that I think we should _unref() those nodes immediately after failed,
But this will be a bit more complicated as you said, and also will include
one new bug:
When devm_snd_soc_register_card() failed, the _unref() won't be ran.
 
Thanks very much for you comment.

I will fix it in the next version,

BRs
Xiubo



> > +static int asoc_simple_card_remove(struct platform_device *pdev)
> > +{
> > +	struct snd_soc_card *card = platform_get_drvdata(pdev);
> > +
> > +	asoc_simple_card_unref(card->dai_link, card->num_links);
> > +
> > +	return 0;
> > +}
> > +
> >  static const struct of_device_id asoc_simple_of_match[] = {
> >  	{ .compatible = "simple-audio-card", },
> >  	{},
> > @@ -501,6 +504,7 @@ static struct platform_driver asoc_simple_card = {
> >  		.of_match_table = asoc_simple_of_match,
> >  	},
> >  	.probe = asoc_simple_card_probe,
> > +	.remove = asoc_simple_card_remove,
> >  };
> >
> >  module_platform_driver(asoc_simple_card);
> 
> OK.
> 
> --
> Ken ar c'hentaÃ±	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
