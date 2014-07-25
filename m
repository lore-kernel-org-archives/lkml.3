Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbaGYCVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:21:23 -0400
Received: from [207.46.163.205] ([207.46.163.205]:45741 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759079AbaGYCVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:21:22 -0400
Date: Fri, 25 Jul 2014 10:05:22 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Tobias Klauser <tklauser@distanz.ch>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <broonie@kernel.org>,
        <shawn.guo@linaro.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rdunlap@infradead.org>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <timur@tabi.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: Re: [PATCH v2 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140725020520.GA29136@MrMyself>
References: <cover.1406189745.git.nicoleotsuka@gmail.com>
 <2c74a11776ffcc017c80dc31be4a8313755be8f5.1406189745.git.nicoleotsuka@gmail.com>
 <20140724152045.GA3384@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140724152045.GA3384@distanz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(24454002)(51704005)(189002)(377424004)(92566001)(85852003)(77982001)(105606002)(79102001)(50986999)(92726001)(97736001)(4396001)(46406003)(81342001)(69596002)(31966008)(83072002)(64706001)(102836001)(74662001)(81156004)(97756001)(80022001)(104016003)(20776003)(84676001)(83322001)(50466002)(19580395003)(46102001)(54356999)(106466001)(87936001)(81542001)(99396002)(85306003)(19580405001)(83506001)(33656002)(76482001)(21056001)(74502001)(6806004)(23726002)(95666004)(110136001)(44976005)(86362001)(68736004)(33716001)(76176999)(26826002)(47776003)(107046002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB328;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

On Thu, Jul 24, 2014 at 05:20:45PM +0200, Tobias Klauser wrote:
> On 2014-07-24 at 10:35:29 +0200, Nicolin Chen <nicoleotsuka@gmail.com> wrote:
> > The Asynchronous Sample Rate Converter (ASRC) converts the sampling rate of a
> > signal associated with an input clock into a signal associated with a different
> > output clock. The driver currently works as a Front End of DPCM with other Back
> > Ends DAI links such as ESAI<->CS42888 and SSI<->WM8962 and SAI. It converts the
> > original sample rate to a common rate supported by Back Ends for playback while
> > converts the common rate of Back Ends to a desired rate for capture. It has 3
> > pairs to support three different substreams within totally 10 channels.
> > 
> > Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> > ---
> 
> [...]
> 
> > --- /dev/null
> > +++ b/sound/soc/fsl/fsl_asrc.c
> > @@ -0,0 +1,1031 @@
> 
> [...]
> 
> > +static struct platform_driver fsl_asrc_driver = {
> > +	.probe = fsl_asrc_probe,
> > +	.driver = {
> > +		.name = "fsl-asrc",
> > +		.owner = THIS_MODULE,
> 
> Not necessary, this will be set by module_platform_driver (or
> the expansion of platform_driver_register, respectively).
> 
> > +		.of_match_table = fsl_asrc_ids,
> > +		.pm = &fsl_asrc_pm,
> > +	},
> > +};
> > +module_platform_driver(fsl_asrc_driver);
> 
> [...]
> 
> > --- /dev/null
> > +++ b/sound/soc/fsl/fsl_asrc_dma.c
> > @@ -0,0 +1,384 @@
> 
> [...]
> 
> > +static int fsl_asrc_dma_pcm_new(struct snd_soc_pcm_runtime *rtd)
> > +{
> > +	struct snd_card *card = rtd->card->snd_card;
> > +	struct snd_pcm_substream *substream;
> > +	struct snd_pcm *pcm = rtd->pcm;
> > +	u64 dma_mask = DMA_BIT_MASK(32);
> > +	int ret, i;
> > +
> > +	if (!card->dev->dma_mask)
> > +		card->dev->dma_mask = &dma_mask;
> 
> dma_mask will go out of scope after fsl_asrc_dma_pcm_new returns,
> resulting in a stray pointer in card->dev->dma_mask.

Will fix them in v3.

Thank you
Nicolin
