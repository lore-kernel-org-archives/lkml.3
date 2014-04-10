Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502AbaDJH4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:56:19 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19726
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933236AbaDJH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:56:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Thu, 10 Apr 2014 15:46:36 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: Re: [PATCH v4] ASoC: fsl_sai: Add clock controls for SAI
Message-ID: <20140410074635.GA14658@MrMyself>
References: <1397041577-9580-1-git-send-email-Guangyu.Chen@freescale.com>
 <fe26bf436e1846fca85415fc4c8bb67e@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fe26bf436e1846fca85415fc4c8bb67e@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 03:39:51PM +0800, Xiubo Li-B47053 wrote:
> > diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> > index db9f75e..7cd4af9 100644
> > --- a/sound/soc/fsl/fsl_sai.c
> > +++ b/sound/soc/fsl/fsl_sai.c
> > @@ -401,7 +401,23 @@ static int fsl_sai_startup(struct snd_pcm_substream
> > *substream,
> >  		struct snd_soc_dai *cpu_dai)
> >  {
> >  	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> > -	u32 reg;
> > +	struct device *dev = &sai->pdev->dev;
> > +	u32 reg, i;
> > +	int ret;
> > +
> > +	ret = clk_prepare_enable(sai->bus_clk);
> > +	if (ret) {
> > +		dev_err(dev, "failed to enable bus clock\n");
> > +		return ret;
> > +	}
> > +
> > +	for (i = 0; i < FSL_SAI_MCLK_MAX; i++) {
> > +		ret = clk_prepare_enable(sai->mclk_clk[i]);
> > +		if (ret) {
> > +			dev_err(dev, "failed to enable mclk%d clock\n", i + 1);
> > +			goto err;
> > +		}
> > +	}
> > 
> 
> Why prepare and enable all the mclks here ?
> And at last only one of 'bus', 'mclk1', 'mclk2' and 'mclk3' will be selected
> To generate the bit clock. How about just prepare and enable the selected
> one ?
 
That's a fair suggestion. I'll do the revise.

But in this way. We can provisionally drop the clock enabling part and add
them later after my clock dividing patch is ready.

Thank you,
Nicolin

