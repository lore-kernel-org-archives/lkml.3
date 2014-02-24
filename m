Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBXP5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:57:48 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:27859
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbaBXP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:57:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI1432I168aJzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Mon, 24 Feb 2014 23:47:09 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <brian.austin@cirrus.com>, <Paul.Handrigan@cirrus.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
Message-ID: <20140224154708.GA6132@MrMyself>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140224113011.GE25940@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 08:30:11PM +0900, Mark Brown wrote:
> On Mon, Feb 24, 2014 at 02:55:29PM +0800, Nicolin Chen wrote:
> > This patch adds support for the Cirrus Logic CS42888 Audio CODEC that
> > has four 24-bit A/D and eight 24-bit D/A converters.
> 
> Looks generally good, some fairly small nits below.

I'll revise all of them.

Thank you.
Nicolin

----

> 
> > [ CS42888 supports both I2C and SPI control ports. As initial patch,
> >   this patch only adds the support for I2C. ]
> 
> >  5 files changed, 795 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/sound/cs42888.txt
> >  create mode 100644 sound/soc/codecs/cs42888.c
> >  create mode 100644 sound/soc/codecs/cs42888.h
> 
> Given that we're starting to split out separate bus drivers for the I2C
> and SPI CODECs (look at the recent submissions from Lars-Peter) it'd be
> good to start this off with a separate bus driver for I2C even if the
> SPI one is still to be done - that way the Kconfig stuff for machine
> drivers is all in place and doesn't need updating.
> 
> > +  - clocks : phandle to the clock source for MCLK
> > +
> > +  - clock-names : must contain "mclk".
> 
> These should really be lists though there's only one documented element
> so it's purely a documentation update.
> 
> > +	/* Disable auto-mute */
> > +	regmap_update_bits(cs42888->regmap, CS42888_TXCTL,
> > +			   CS42888_TXCTL_AMUTE | CS42888_TXCTL_DAC_SZC_MASK,
> > +			   CS42888_TXCTL_DAC_SZC_SR);
> 
> Does this interfere with the manual mute controls or is it a separate
> thing?  If it plays nicely with the manual controls it's probably better
> to leave it enabled since it improves performance in some benchmarks
> (that's why hardware tends to have the feature).
> 
> > +	/*
> > +	 * We haven't marked the chip revision as volatile due to
> > +	 * sharing a register with the right input volume; explicitly
> > +	 * bypass the cache to read it.
> > +	 */
> > +	regcache_cache_bypass(cs42888->regmap, true);
> 
> The other option here is to just not provide a default so that the first
> time it's read it goes to hardware.  It doesn't make much difference
> either way though.
> 
> > +static int cs42888_i2c_remove(struct i2c_client *i2c_client)
> > +{
> > +	snd_soc_unregister_codec(&i2c_client->dev);
> > +	return 0;
> > +}
> 
> The driver ought to disable runtime PM, the clock and the regulators here.
> 
> > +	/*
> > +	 * In case the device was put to hard reset during sleep,
> > +	 * we need to wait 500ns here before any I2C communication
> > +	 */
> > +	mdelay(5);
> 
> Do we need 500ns or 5ms?  
> 
> > +	regcache_sync(cs42888->regmap);
> 
> Should really check the return value here.
> 
> > +	if (!IS_ERR(cs42888->clk))
> > +		clk_disable_unprepare(cs42888->clk);
> 
> Does the device work without MCLK?




