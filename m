Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3LRFew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 00:34:52 -0500
Received: from [216.32.180.14] ([216.32.180.14]:34039 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750961Ab3LRFeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 00:34:50 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Wed, 18 Dec 2013 13:13:36 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <alsa-devel@alsa-project.org>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ASoC: fsl: imx-wm8962: Grant hw_params/free()
 permission to control FLL
Message-ID: <20131218051334.GA7648@MrMyself>
References: <1386842368-19951-1-git-send-email-Guangyu.Chen@freescale.com>
 <20131217225002.GR28455@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131217225002.GR28455@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:50:02PM +0000, Mark Brown wrote:
> On Thu, Dec 12, 2013 at 05:59:28PM +0800, Nicolin Chen wrote:
> 
> > +	mask = WM8962_MIXINL_TO_HPMIXL_MASK | WM8962_MIXINR_TO_HPMIXL_MASK |
> > +		WM8962_IN4L_TO_HPMIXL_MASK | WM8962_IN4R_TO_HPMIXL_MASK;
> > +	bypass |= snd_soc_read(codec, WM8962_HEADPHONE_MIXER_1) & mask;
> > +	bypass |= snd_soc_read(codec, WM8962_HEADPHONE_MIXER_2) & mask;
> > +	bypass |= snd_soc_read(codec, WM8962_SPEAKER_MIXER_1) & mask;
> > +	bypass |= snd_soc_read(codec, WM8962_SPEAKER_MIXER_2) & mask;
> > +
> > +	/* Don't diable FLL if running multi-substreams or analogue bypass */
> > +	if (codec_dai->active != 1 || bypass)
> > +		return 0;
> 
> I don't think this works with the power down delay we do on playback -
> the DAI will go inactive when closed but we'll still have the CODEC
> active and using its clocks until the power down time has elapsed if
> it's a playback DAI.  Trying to reclock the device while active is at
> best risky, even if it's muted.
>
> I do think refcounting from both here and the bias level changes is
> going to be the most robust thing, that'd also avoid the need to peer
> into the CODEC register map.

I've tried count reference way to handle FLL enabler/disabler here before
I sent this version. But the result shows the FLL would be never disabled
in hw_free() because the refcount is accumulated to 2, one from hw_params()
and the other from set_bias_level(PREPARE), which just made this patch
meaningless to me.

So the reclocking with bypass checking seems to be the last resort I can
figure out right here as the playback flow for 'aplay -Dhw:0 44k16bit.wav
48k24bit.wav' does need to reprogram the FLL during CODEC active.

Thank you,
Nicolin Chen

