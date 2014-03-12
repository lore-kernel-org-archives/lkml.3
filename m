Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaCLFUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 01:20:23 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:12005
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751009AbaCLFUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 01:20:22 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/4] ASoC: simple-card: accept many DAI links
Thread-Topic: [PATCH v2 3/4] ASoC: simple-card: accept many DAI links
Thread-Index: AQHPPRZ6fdIo7ESiS0OQEyU8K0kETZrc6MGw
Date: Wed, 12 Mar 2014 05:20:17 +0000
Message-ID: <2e7647de940f400a916e2f6c43f9811f@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1394533640.git.moinejf@free.fr>
 <d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
In-Reply-To: <d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(51704005)(87936001)(59766001)(74366001)(93516002)(83322001)(81816001)(85852003)(93136001)(83072002)(56816005)(20776003)(63696002)(65816001)(80022001)(31966008)(77982001)(47446002)(74662001)(74502001)(66066001)(79102001)(74316001)(95416001)(2656002)(85306002)(19580405001)(87266001)(80976001)(86362001)(76796001)(81342001)(33646001)(81542001)(69226001)(94316002)(74706001)(94946001)(74876001)(76482001)(4396001)(53806001)(97336001)(49866001)(56776001)(54316002)(95666003)(50986001)(51856001)(92566001)(46102001)(76786001)(81686001)(97186001)(54356001)(47976001)(19580395003)(47736001)(90146001)(76576001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB028;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:8EF0DF4B.12F09302.31FD93C7.49F5EB31.20412;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH v2 3/4] ASoC: simple-card: accept many DAI links
> 
> Some simple audio cards may have many DAI links.
> This patch extends the simple-card driver for handling such cards.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  sound/soc/generic/simple-card.c | 132 ++++++++++++++++++++++++++-------------
> -
>  1 file changed, 85 insertions(+), 47 deletions(-)
> 
> diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> index 2710b52..8188c34 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
> @@ -107,6 +107,9 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
>  	if (ret < 0)
>  		return ret;
> 
> +	if (!dai)
> +		return 0;
> +
>  	/* parse TDM slot */
>  	ret = snd_soc_of_parse_tdm_slot(np, &dai->slots, &dai->slot_width);
>  	if (ret)
> @@ -154,7 +157,7 @@ static int asoc_simple_card_parse_of(struct device_node
> *node,
>  	struct snd_soc_dai_link *dai_link = priv->snd_card.dai_link;
>  	struct device_node *np;
>  	char *name;
> -	int ret;
> +	int first_link, ret;
> 
>  	/* parsing the card name from DT */
>  	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
> @@ -179,50 +182,67 @@ static int asoc_simple_card_parse_of(struct device_node
> *node,
>  			return ret;
>  	}
> 
> -	/* CPU sub-node */
> -	ret = -EINVAL;
> -	np = of_get_child_by_name(node, "simple-audio-card,cpu");
> -	if (np) {
> +	/* loop on the DAI links */
> +	np = NULL;
> +	first_link = 1;
> +	for (;;) {
> +		np = of_get_next_child(node, np);
> +		if (!np)
> +			break;
> +
> +		/* CPU sub-node */
> +		if (strcmp(np->name, "simple-audio-card,cpu") != 0) {
> +			dev_err(dev, "Bad CPU DAI\n");
> +			ret = -EINVAL;
> +			goto err;
> +		}
>  		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
> -						  &priv->cpu_dai,
> +					first_link ? &priv->cpu_dai : NULL,

@Jean-Francois,

I'm not sure why only the first link needs parsing the DAIFMT ?

On my LS1 platform there are two CODECs and two CPU SAI deivces,
SGTL5000 <---> SAI
CS42888  <---> ESAI

Could the many dai links feature support this case? 

I my understanding is correct here, this patch will support the
Board, in which board there maybe only one CODEC supporting many
DAIs...


Thanks,

--
Best Regards,
Xiubo




>  						  &dai_link->cpu_of_node,
>  						  &dai_link->cpu_dai_name);
> -		of_node_put(np);
> -	}
> -	if (ret < 0)
> -		return ret;
> +		if (ret < 0)
> +			goto err;
> 
> -	/* CODEC sub-node */
> -	ret = -EINVAL;
> -	np = of_get_child_by_name(node, "simple-audio-card,codec");
> -	if (np) {
> +		/* CODEC sub-node */
> +		np = of_get_next_child(node, np);
> +		if (strcmp(np->name, "simple-audio-card,codec") != 0) {
> +			dev_err(dev, "Bad CODEC DAI\n");
> +			ret = -EINVAL;
> +			goto err;
> +		}
>  		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
> -						  &priv->codec_dai,
> +					first_link ? &priv->codec_dai : NULL,
>  						  &dai_link->codec_of_node,
>  						  &dai_link->codec_dai_name);
> -		of_node_put(np);
> -	}
> -	if (ret < 0)
> -		return ret;
> +		if (ret < 0)
> +			goto err;
> +
> +		if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> 
> -	if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name)
> -		return -EINVAL;
> +		/* simple-card assumes platform == cpu */
> +		dai_link->platform_of_node = dai_link->cpu_of_node;
> +
> +		name = devm_kzalloc(dev,
> +				    strlen(dai_link->cpu_dai_name)   +
> +				    strlen(dai_link->codec_dai_name) + 2,
> +				    GFP_KERNEL);
> +		sprintf(name, "%s-%s", dai_link->cpu_dai_name,
> +					dai_link->codec_dai_name);
> +		dai_link->name = dai_link->stream_name = name;
> +
> +		dai_link++;
> +		first_link = 0;
> +	}
> 
>  	/* card name is created from CPU/CODEC dai name */
> -	name = devm_kzalloc(dev,
> -			    strlen(dai_link->cpu_dai_name)   +
> -			    strlen(dai_link->codec_dai_name) + 2,
> -			    GFP_KERNEL);
> -	sprintf(name, "%s-%s", dai_link->cpu_dai_name,
> -				dai_link->codec_dai_name);
> +	dai_link = priv->snd_card.dai_link;
>  	if (!priv->snd_card.name)
> -		priv->snd_card.name = name;
> -	dai_link->name = dai_link->stream_name = name;
> +		priv->snd_card.name = dai_link->name;
> 
> -	/* simple-card assumes platform == cpu */
> -	dai_link->platform_of_node = dai_link->cpu_of_node;
> -
> -	dev_dbg(dev, "card-name : %s\n", name);
> +	dev_dbg(dev, "card-name : %s\n", priv->snd_card.name);
>  	dev_dbg(dev, "platform : %04x\n", priv->daifmt);
>  	dev_dbg(dev, "cpu : %s / %04x / %d\n",
>  		dai_link->cpu_dai_name,
> @@ -233,18 +253,11 @@ static int asoc_simple_card_parse_of(struct device_node
> *node,
>  		priv->codec_dai.fmt,
>  		priv->codec_dai.sysclk);
> 
> -	/*
> -	 * soc_bind_dai_link() will check cpu name
> -	 * after of_node matching if dai_link has cpu_dai_name.
> -	 * but, it will never match if name was created by fmt_single_name()
> -	 * remove cpu_dai_name to escape name matching.
> -	 * see
> -	 *	fmt_single_name()
> -	 *	fmt_multiple_name()
> -	 */
> -	dai_link->cpu_dai_name = NULL;
> -
>  	return 0;
> +
> +err:
> +	of_node_put(np);
> +	return ret;
>  }
> 
>  /* update the reference count of the devices nodes at end of probe */
> @@ -274,10 +287,22 @@ static int asoc_simple_card_probe(struct platform_device
> *pdev)
>  	struct snd_soc_dai_link *dai_link;
>  	struct device_node *np = pdev->dev.of_node;
>  	struct device *dev = &pdev->dev;
> -	int ret;
> +	int num_links, ret;
> +
> +	/* get the number of DAI links */
> +	if (np) {
> +		num_links = of_get_child_count(np);
> +		if (num_links == 0 || (num_links & 1)) {
> +			dev_err(&pdev->dev, "Bad number of DAI links\n");
> +			return -EINVAL;
> +		}
> +		num_links /= 2;
> +	} else {
> +		num_links = 1;
> +	}
> 
>  	priv = devm_kzalloc(dev,
> -			sizeof(*priv) + sizeof(*dai_link),
> +			sizeof(*priv) + sizeof(*dai_link) * num_links,
>  			GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> @@ -289,7 +314,7 @@ static int asoc_simple_card_probe(struct platform_device
> *pdev)
>  	priv->snd_card.dev = dev;
>  	dai_link = priv->dai_link;
>  	priv->snd_card.dai_link = dai_link;
> -	priv->snd_card.num_links = 1;
> +	priv->snd_card.num_links = num_links;
> 
>  	if (np && of_device_is_available(np)) {
> 
> @@ -299,6 +324,19 @@ static int asoc_simple_card_probe(struct platform_device
> *pdev)
>  				dev_err(dev, "parse error %d\n", ret);
>  			goto err;
>  		}
> +
> +		/*
> +		 * soc_bind_dai_link() will check cpu name
> +		 * after of_node matching if dai_link has cpu_dai_name.
> +		 * but, it will never match if name was created by
> fmt_single_name()
> +		 * remove cpu_dai_name to escape name matching.
> +		 * see
> +		 *	fmt_single_name()
> +		 *	fmt_multiple_name()
> +		 */
> +		if (num_links == 1)
> +			dai_link->cpu_dai_name = NULL;
> +
>  	} else {
>  		struct asoc_simple_card_info *cinfo;
> 
> --
> 1.9.0
> 
> 

