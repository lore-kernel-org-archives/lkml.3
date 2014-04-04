Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaDDJZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:25:06 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:13572
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752266AbaDDJYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:24:42 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "timur@tabi.org" <timur@tabi.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: RE: [PATCH 1/2] ASoC: fsl_sai: Add clock control for SAI
Thread-Topic: [PATCH 1/2] ASoC: fsl_sai: Add clock control for SAI
Thread-Index: AQHPTaDvZlMavNvE00agcQhBEjQ6BZsBLoGw
Date: Fri, 4 Apr 2014 09:24:39 +0000
Message-ID: <49295d4f0f0f42c4b9c6de77583b978e@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1396352401.git.Guangyu.Chen@freescale.com>
 <87d225a25812d730c0865f9d0bb733c67d8b3ed1.1396352401.git.Guangyu.Chen@freescale.com>
In-Reply-To: <87d225a25812d730c0865f9d0bb733c67d8b3ed1.1396352401.git.Guangyu.Chen@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(189002)(199002)(51704005)(81686001)(47736001)(49866001)(94316002)(74366001)(66066001)(50986001)(4396001)(81816001)(79102001)(80022001)(65816001)(76796001)(2656002)(74316001)(76786001)(80976001)(95666003)(33646001)(97186001)(86362001)(51856001)(87266001)(46102001)(97336001)(2201001)(85306002)(93516002)(56816005)(81342001)(76482001)(59766001)(74706001)(77982001)(69226001)(47446002)(54316002)(56776001)(74502001)(93136001)(98676001)(99396002)(94946001)(19580395003)(20776003)(47976001)(99286001)(76576001)(63696002)(87936001)(19580405001)(83322001)(54356001)(81542001)(74876001)(83072002)(85852003)(90146001)(74662001)(95416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB444;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:A9EDCF25.FD3375BA.B1EDABB4.8ED31EA3.20246;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have test this series on my Vybrid-TWR board and it works happily.

[...]
> diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> index 3847d2a..2d749df 100644
> --- a/sound/soc/fsl/fsl_sai.c
> +++ b/sound/soc/fsl/fsl_sai.c
> @@ -428,5 +428,18 @@ static int fsl_sai_startup(struct snd_pcm_substream
> *substream,
>  {
>  	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> -	u32 reg;
> +	struct device *dev = &sai->pdev->dev;
> +	u32 reg, ret;
> +

I'd prefer:
  +	int ret;


> +	ret = clk_prepare_enable(sai->ipg_clk);
> +	if (ret) {
> +		dev_err(dev, "failed to prepare and enable ipg clock\n");
> +		return ret;
> +	}
> +

[...]

> @@ -609,5 +630,5 @@ static int fsl_sai_probe(struct platform_device *pdev)
> 
>  	sai->regmap = devm_regmap_init_mmio_clk(&pdev->dev,
> -			"sai", base, &fsl_sai_regmap_config);
> +			"ipg", base, &fsl_sai_regmap_config);
>  	if (IS_ERR(sai->regmap)) {
>  		dev_err(&pdev->dev, "regmap init failed\n");
> @@ -615,4 +636,16 @@ static int fsl_sai_probe(struct platform_device *pdev)
>  	}
> 
> +	sai->ipg_clk = devm_clk_get(&pdev->dev, "ipg");
> +	if (IS_ERR(sai->ipg_clk)) {
> +		dev_err(&pdev->dev, "failed to get ipg clock\n");
> +		return PTR_ERR(sai->ipg_clk);
> +	}
> +

Since the 'ipg' clock is just intend to be used for registers accessing and
We are using the regmap_init_mmio_clk(), so we can just drop it here and
Let the regmap APIs to do the clock options properly.

Otherwise it look good to me.

After this:
Acked-by: Xiubo Li <Li.Xiubo@freescale.com>



Thanks,

Brs,
Xiubo




> +	sai->sai_clk = devm_clk_get(&pdev->dev, "sai");
> +	if (IS_ERR(sai->sai_clk)) {
> +		dev_err(&pdev->dev, "failed to get sai clock\n");
> +		return PTR_ERR(sai->sai_clk);
> +	}
> +
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
> diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
> index 677670d..cbaf114 100644
> --- a/sound/soc/fsl/fsl_sai.h
> +++ b/sound/soc/fsl/fsl_sai.h
> @@ -127,4 +127,6 @@ struct fsl_sai {
>  	struct platform_device *pdev;
>  	struct regmap *regmap;
> +	struct clk *ipg_clk;
> +	struct clk *sai_clk;
> 
>  	bool big_endian_regs;
> --
> 1.8.4
> 

