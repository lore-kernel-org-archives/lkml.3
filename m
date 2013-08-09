Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966484Ab3HIJa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:30:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40838 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965824Ab3HIJaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:30:55 -0400
Date: Fri, 9 Aug 2013 10:30:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu
	audio subsystem
Message-ID: <20130809093032.GM23006@n2100.arm.linux.org.uk>
References: <20130808132201.2610aef3@armhf> <5204A716.6070507@gmail.com> <20130809110623.7bb3e7ad@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809110623.7bb3e7ad@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:06:23AM +0200, Jean-Francois Moine wrote:
> On Fri, 09 Aug 2013 10:23:50 +0200
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
> > we need at least two more compatibles for the audio controller found on
> > Dove and Kirkwood respectively. This is how we are going to distinguish
> > those two, e.g. Kirkwood has SPDIF in which Dove hasn't.
> 
> Sebastian,
> 
> s/has/hasn't & s/hasn't/has

No, you're both wrong.

Some Kirkwood has SPDIF recording and playback.  There are those audio
blocks which have just I2S capture and playback.  There are those which
have I2S capture and playback, and SPDIF playback.  There are those which
have both I2S and SPDIF for both capture and playback.  The only one I
haven't yet seen is SPDIF capture without playback.

> On Fri, 26 Jul 2013 10:21:56 +0100 Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Fri, Jul 26, 2013 at 11:09:13AM +0200, Jean-Francois Moine wrote:
> > > The A510 documentation uses the names "DCO PLL" for the internal clock
> > > and "AU_EXTCLK" for the external clock. So, what about "dcopll" and
> > > "extclk"?
> > 
> > Stop naming them according to their source.  Their _consumer_ names
> > not _source_ names.
> 
> But Russell did not tell clearly which name could be the best.
> 
> BTW, as we are naming the clocks, the 'clk' in "xxxclk" seems redondant...

"extclk" follows what's in the data sheet - the exact name of it is
"AU_EXTCLK".  Since we already know that this is the audio unit from
the struct device, the "AU_" part is redundant.  The input name for
the internal clock is not given, instead they talk about where it
comes from (it's producer) so your choice of "internal" is fine.

Take a moment to think about it: if you call it "dcoclk" then what
happens on a future SoC if it's not connected to the dcoclk anymore?

> I don't think that we need any reference to the codec here. The glue is
> done by the audio device. For example, using the (soon?) extended
> simple audio card:
> 
> 	spdif: spdif {
> 		compatible = "linux,spdif-dit";
> 	};
> 	sound {
> 		compatible = "linux,simple-audio";
> 		audio-controller = <&i2s1>;
> 		audio-codec = <&spdif>;
> 		codec-dai-name = "dit-hifi";
> 	};

As I understand the way DPCM works, that isn't going to work for this
case.  For DPCM as per Liam's example, it's going to require the audio
controller to be bound to the dummy codec, and a dummy platform/dai
bound to the SPDIF codec.  You then use DAPM routing to connect the
SPDIF codec to the appropriate CPU DAI output stream.

So the above "simple" implementation won't do - it can't be used to
specify two DAI links, and it can't specify the DAPM routing between
them.

This will be another challenge to solve in DT!
