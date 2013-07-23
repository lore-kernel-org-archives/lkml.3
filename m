Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab3GWPUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:20:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38287 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3GWPUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:20:14 -0400
Date: Tue, 23 Jul 2013 16:19:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
	driver for DT usage
Message-ID: <20130723151956.GX24642@n2100.arm.linux.org.uk>
References: <20130723104615.3696f1a9@armhf> <20130723123444.GW9858@sirena.org.uk> <51EE7E1A.3040301@gmail.com> <20130723132016.GC9858@sirena.org.uk> <51EE8591.7060005@gmail.com> <20130723150150.GH9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723150150.GH9858@sirena.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 04:01:50PM +0100, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 03:30:57PM +0200, Sebastian Hesselbarth wrote:
> > On 07/23/13 15:20, Mark Brown wrote:
> 
> > >Why would this be required?  The driver is already asking for multiple
> > >clocks...
> 
> > The driver is asking for multiple *DT based* clocks. Legacy
> > platform_data has never been updated to reflect that. Mainly because
> > multiple clocks are only supported on Dove, which has no active non-DT
> > board in mainline.
> 
> Why would platform data have anything to do with this?  To repeat again
> the way the clocks are mapped should be totally transparent to the
> driver requesting them, if it isn't then the driver is not using the API
> properly.

Total rubbish.  Of course the driver needs to know what the clocks are,
so that it can program its hardware accordingly.

What you have here is an audio block which has two clock inputs.  One
clock is the system clock, whose rate can be adjusted but has a massive
impact on the rest of the system.  The other clock input is via an
external pin.

Internally, in one of the audio blocks registers is a set of control bits
which select which clock is to be used to generate the internal timing
for the block, and a divisor on that input.

>From that description, anyone can see that it is absolutely required for
the driver to know which clock is which, so it can program the clock
input selection bit appropriately.

In this case, it has always been the rule with the clock API that it
shall be used as:

	clk_get(device, "internal");

to get the internal clock, and:

	clk_get(device, "external");

to get the external clock - or whatever names are appropriate to name the
clock _inputs_.
