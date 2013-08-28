Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3H1MnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:43:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50871 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab3H1MnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:43:15 -0400
Date: Wed, 28 Aug 2013 13:42:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130828124255.GL6617@n2100.arm.linux.org.uk>
References: <20130828113459.48ecbb34@armhf> <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate> <521DD057.4040208@gmail.com> <20130828131548.0009d613@skate> <521DE2B3.9050508@gmail.com> <20130828135827.2307c89e@skate> <20130828121320.GK6617@n2100.arm.linux.org.uk> <20130828142909.3521064b@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130828142909.3521064b@skate>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:29:09PM +0200, Thomas Petazzoni wrote:
> Dear Russell King - ARM Linux,
> 
> On Wed, 28 Aug 2013 13:13:20 +0100, Russell King - ARM Linux wrote:
> 
> > > > I guess, yes.
> > > 
> > > Jean-François, could you cook and submit a patch to change the
> > > compatible string?
> > 
> > I don't think this is a good idea.  The configuration of this IP is
> > not based on the SoC as a single SoC can have a mixture of different
> > configurations.
> 
> Using the name of the oldest SoC in the family that had the IP block is
> the norm, because it's really what "compatible" means: the IP block in
> Dove is *compatible* with the one that was originally introduced in
> Kirkwood.
> 
> See what Rob Herring (one of the DT maintainer) says in
> http://lists.infradead.org/pipermail/linux-mtd/2012-March/040417.html:
> 
> """
> There is no reason all machines can't use "st,spear600-smi" in their
> dts. It doesn't have to be a spear600, just compatible with it. Really
> you want the string to be the oldest SOC the block is in and then newer
> SOCs can claim compatibility with the old version.
> """
> 
> The thread was precisely about replacing a SoC-specific compatible
> string "st,spear600-smi" by a more generic "st,spear-smi" and Rob
> Herring (above) was opposing to that.

We're not talking about replacing a pre-existing string, we're talking
about adding one, which is a different situation.

> > I think marvell,mvebu-audio is a reasonable compatible string for this,
> > and that the different configurations should be described by properties
> > indicating which inputs and outputs have been implemented.
> > 
> > For instance, on the Dove, there are two of these blocks.  One has I2S
> > in and out only, but the other block has I2S in and out, and SPDIF out.
> > On some other Marvell devices, this block has I2S in and out and SPDIF
> > in and out.
> > 
> > Otherwise, they're functionally the same.
> 
> Right, that's why they can both use "kirkwood-audio" as the compatible
> string.
> 
> > > Though, if the difference between the two units is the availability of
> > > SPDIF support, then we shouldn't encode the channel number, but instead
> > > the availability of SPDIF, i.e:
> > > 
> > > 	audio0 {
> > > 		reg = <... ...>;
> > > 		compatible = "marvell,kirkwood-audio";
> > > 		marvell,has-spdif;
> > > 	};
> > > 
> > > 	audio1 {
> > > 		reg = <... ...>;
> > > 		compatible = "marvell,kirkwood-audio";
> > > 	};
> > 
> > ... which means there's no problem with using marvell,mvebu-audio as the
> > compatible string if you're going to use properties to describe what
> > facilities are available.
> 
> I disagree, because how do you know if a future "mvebu" SOC such as
> Armada 370, or one that doesn't exist yet, will not have a different
> audio IP block?

The Dove already contains _three_ audio blocks, two of which are this
one, and another which is block for driving an AC'97 codec (which doesn't
have a driver.)  That's no problem because you won't call that one an
"audio" block but an AC'97 block.  So...

> It will still be audio, it will still be mvebu, but it
> will not be able to use a "marvell,mvebu-audio" driver. Or maybe it can
> use the same driver, but with a few variations, so a different
> compatible string will be needed to identify the original IP
> ("marvell,kirkwood-audio", used on Kirkwood/Dove) and slightly newer
> versions of the IP ("marvell,some-funky-soc-audio").

I don't think this really applies.

> > In any case "marvell,has-spdif" is too generic - as I've indicated above,
> > there's versions with spdif out, and other versions with spdif in and
> > out.
> 
> Right, the above was just an example to illustrate that we can have
> additional properties to encode the differences between each instance
> of the audio devices.

I think this is a mistake too: these properties will just tell us what
may be possible, and the driver will take no real action on them.  I
suppose that a property specifying whether there is a SPDIF output could
be used to control whether the IEC958 channel status controls are
registered.  However...

What's more important is which outputs are actually wired up, and
therefore which bits of this hardware are enabled.  Even then, we
wouldn't want to expose (eg) the IEC958 channel status controls if
the SPDIF output isn't wired.  So all in all, I don't see any point
to a set of properties saying "we have SPDIF" etc.  That information
should come solely from whether the SPDIF output has been "wired up".

Let me put that another way: we _can_ provide those properties to
indicate what facilities the hardware has, we just wouldn't use them
at all - and to provide them seems like over-design to me.
