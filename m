Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaJUH5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:57:22 -0400
Received: from axentia.se ([87.96.186.132]:50536 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbaJUH5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:57:19 -0400
From: Peter Rosin <peda@axentia.se>
To: Bo Shen <voice.shen@atmel.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Topic: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Index: Ac/saz/Ebhtl/6cSQtuv8Muf3bNWIgAVeLOAAA3ODdA=
Date: Tue, 21 Oct 2014 07:55:28 +0000
Message-ID: <dc4461593ddb4d539f2db74b69bab98c@EMAIL.axentia.se>
References: <a541333cf46b4c61b790df927d4b315d@EMAIL.axentia.se>
 <5445BCBF.5090002@atmel.com>
In-Reply-To: <5445BCBF.5090002@atmel.com>
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(and thank you for the pointer to the example with the ssc-dai in master mode)

> Hi Peter,
> 
> On 10/20/2014 09:45 PM, Peter Rosin wrote:
> >  From 1e5621d7b9887c648d1a66238dc82d715c1e2cad Mon Sep 17 00:00:00
> > 2001
> > From: Peter Rosin <peda@axentia.se>
> > Date: Mon, 20 Oct 2014 14:38:04 +0200
> > Subject: [PATCH] ASoC: atmel_ssc_dai: Track playback and capture CMR
> dividers
> >   separately.
> >
> > The CMR divider register is shared by playback and capture. The SSC
> > driver therefore tries to enforce rules so that the needed register
> > content do not conflict during simultaneous playback/capture. However,
> > the implementation also prevents changing the register content in a
> > half-duplex scenario, which is needed when changing sample rates.
> 
> I am not fully get what you mean here, do you mean:
>    - when playback, first playback 48kHz, and then playback 8Khz, the 8Khz still
> playback in 48kHz mode?
> 
> or other things?

I do not know exactly why the problem occurs, but it might be connected to
the library (proprietary) we are using. It apparently uses the OSS interface
and somehow it opens a stream and changes the playback sample-rate a
couple of time before it settles on something. I don't know why this is
done, and I have no control over it. The end result is that without this patch,
the ssc-dai driver returns -EBUSY when the library changes the playback
sample-rate (the driver returns -EBUSY because it thinks that the new
sample rate does not match a previously given capture sample-rate, but
that is of course bogus when no capture is going on at all).

> > Thus, keep track of the desired playback and capture clock dividers
> > separately, and allow changing rates without closing the stream.
> >
> > Signed-off-by: Peter Rosin <peda@axentia.se>
> > ---
> >   sound/soc/atmel/atmel_ssc_dai.c |   31 ++++++++++++++++++++++------
> ---
> >   sound/soc/atmel/atmel_ssc_dai.h |   10 ++++++----
> >   2 files changed, 28 insertions(+), 13 deletions(-)
> >
> > diff --git a/sound/soc/atmel/atmel_ssc_dai.c
> > b/sound/soc/atmel/atmel_ssc_dai.c index f403f39..fec14fb 100644
> > --- a/sound/soc/atmel/atmel_ssc_dai.c
> > +++ b/sound/soc/atmel/atmel_ssc_dai.c
> > @@ -277,7 +277,8 @@ static void atmel_ssc_shutdown(struct
> snd_pcm_substream *substream,
> >   		/* Reset the SSC */
> >   		ssc_writel(ssc_p->ssc->regs, CR, SSC_BIT(CR_SWRST));
> >   		/* Clear the SSC dividers */
> > -		ssc_p->cmr_div = ssc_p->tcmr_period = ssc_p->rcmr_period
> = 0;
> > +		ssc_p->tcmr_div = ssc_p->rcmr_div = 0;
> > +		ssc_p->tcmr_period = ssc_p->rcmr_period = 0;
> >   	}
> >   	spin_unlock_irq(&ssc_p->lock);
> >   }
> > @@ -304,17 +305,27 @@ static int atmel_ssc_set_dai_clkdiv(struct
> snd_soc_dai *cpu_dai,
> >   	struct atmel_ssc_info *ssc_p = &ssc_info[cpu_dai->id];
> >
> >   	switch (div_id) {
> > -	case ATMEL_SSC_CMR_DIV:
> > +	case ATMEL_SSC_TCMR_DIV:
> >   		/*
> >   		 * The same master clock divider is used for both
> >   		 * transmit and receive, so if a value has already
> > -		 * been set, it must match this value.
> > +		 * been set for the other direction, it must match
> > +		 * this value.
> >   		 */
> > -		if (ssc_p->cmr_div == 0)
> > -			ssc_p->cmr_div = div;
> > -		else
> > -			if (div != ssc_p->cmr_div)
> > -				return -EBUSY;
> > +		if (ssc_p->rcmr_div == 0)
> > +			ssc_p->tcmr_div = div;
> > +		else if (div != ssc_p->rcmr_div)
> > +			return -EBUSY;
> > +		break;
> > +
> > +	case ATMEL_SSC_RCMR_DIV:
> > +		/*
> > +		 * See ATMEL_SSC_TCMR_DIV.
> > +		 */
> > +		if (ssc_p->tcmr_div == 0)
> > +			ssc_p->rcmr_div = div;
> > +		else if (div != ssc_p->tcmr_div)
> > +			return -EBUSY;
> >   		break;
> >
> >   	case ATMEL_SSC_TCMR_PERIOD:
> > @@ -345,6 +356,7 @@ static int atmel_ssc_hw_params(struct
> snd_pcm_substream *substream,
> >   	struct atmel_pcm_dma_params *dma_params;
> >   	int dir, channels, bits;
> >   	u32 tfmr, rfmr, tcmr, rcmr;
> > +	u16 cmr;
> 
> should be u32.

Ok, I'll send an updated patch later.

> >   	int start_event;
> >   	int ret;
> >   	int fslen, fslen_ext;
> > @@ -626,7 +638,8 @@ static int atmel_ssc_hw_params(struct
> snd_pcm_substream *substream,
> >   	}
> >
> >   	/* set SSC clock mode register */
> > -	ssc_writel(ssc_p->ssc->regs, CMR, ssc_p->cmr_div);
> > +	cmr = ssc_p->tcmr_div ? ssc_p->tcmr_div : ssc_p->rcmr_div;
> > +	ssc_writel(ssc_p->ssc->regs, CMR, cmr);
> >
> >   	/* set receive clock mode and format */
> >   	ssc_writel(ssc_p->ssc->regs, RCMR, rcmr); diff --git
> > a/sound/soc/atmel/atmel_ssc_dai.h b/sound/soc/atmel/atmel_ssc_dai.h
> > index b1f08d5..a25df7a 100644
> > --- a/sound/soc/atmel/atmel_ssc_dai.h
> > +++ b/sound/soc/atmel/atmel_ssc_dai.h
> > @@ -39,9 +39,10 @@
> >   #define ATMEL_SYSCLK_MCK	0 /* SSC uses AT91 MCK as system
> clock */
> >
> >   /* SSC divider ids */
> > -#define ATMEL_SSC_CMR_DIV	0 /* MCK divider for BCLK */
> > -#define ATMEL_SSC_TCMR_PERIOD	1 /* BCLK divider for transmit FS */
> > -#define ATMEL_SSC_RCMR_PERIOD	2 /* BCLK divider for receive FS */
> > +#define ATMEL_SSC_TCMR_DIV	0 /* MCK divider for transmit BCLK */
> > +#define ATMEL_SSC_RCMR_DIV	1 /* MCK divider for receive BCLK */
> > +#define ATMEL_SSC_TCMR_PERIOD	2 /* BCLK divider for transmit
> FS */
> > +#define ATMEL_SSC_RCMR_PERIOD	3 /* BCLK divider for receive
> FS */
> >   /*
> >    * SSC direction masks
> >    */
> > @@ -110,7 +111,8 @@ struct atmel_ssc_info {
> >   	unsigned short dir_mask;	/* 0=unused, 1=playback, 2=capture
> */
> >   	unsigned short initialized;	/* true if SSC has been initialized */
> >   	unsigned short daifmt;
> > -	unsigned short cmr_div;
> > +	unsigned short tcmr_div;
> > +	unsigned short rcmr_div;
> >   	unsigned short tcmr_period;
> >   	unsigned short rcmr_period;
> >   	struct atmel_pcm_dma_params *dma_params[2];
> >
> 
> Best Regards,
> Bo Shen

Cheers,
Peter

