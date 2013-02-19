Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500Ab3BSTDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:03:54 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:55543 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396Ab3BSTDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:03:52 -0500
Date: Tue, 19 Feb 2013 12:03:35 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] of: use platform_device_add
Message-ID: <20130219190335.GA6024@obsidianresearch.com>
References: <1358473200-17886-1-git-send-email-grant.likely@secretlab.ca>
 <1358473200-17886-2-git-send-email-grant.likely@secretlab.ca>
 <20130217030331.GA15048@S2101-09.ap.freescale.net>
 <20130217074317.GB16632@S2101-09.ap.freescale.net>
 <20130217101958.GR17833@n2100.arm.linux.org.uk>
 <CACxGe6sJfRZ4AaDDtoQv6c-xOdB6-=cCJSn6fKawB0ULnzQFoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6sJfRZ4AaDDtoQv6c-xOdB6-=cCJSn6fKawB0ULnzQFoA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 10:49:08AM +0000, Grant Likely wrote:
> > > The patch introduce a regression on imx6q boot.  The IOMUXC block on
> > > imx6q is special.  It acts not only a pin controller but also a system
> > > controller with a bunch of system level registers in there.  That's why
> > > we currently have the following two nodes in imx6q device tree with the
> > > same start "reg" address, which work with drivers/mfd/syscon.c and
> > > drivers/pinctrl/pinctrl-imx6q.c respectively.
> > >
> > >         gpr: iomuxc-gpr@020e0000 {
> > >                 compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> > >                 reg = <0x020e0000 0x38>;
> > >         };
> > >
> > >         iomuxc: iomuxc@020e0000 {
> > >                 compatible = "fsl,imx6q-iomuxc";
> > >                 reg = <0x020e0000 0x4000>;
> > >         };
> > >
> > > With the patch in place, pinctrl-imx6q fails to register like below.
> > >
> > > syscon 20e0000.iomuxc: syscon regmap start 0x20e0000 end 0x20e3fff registered
> > > imx6q-pinctrl 20e0000.iomuxc: can't request region for resource [mem 0x020e0000-0x020e3fff]
> > > imx6q-pinctrl: probe of 20e0000.iomuxc failed with error -16
> 
> Strictly you're not supposed to do that with the device tree. There
> shouldn't be two nodes using the same overlapping memory region unless
> they are parent/child. That rule has been around for a long time, but
> the core never checked for it. What /should/ happen is the two drivers
> should be cooperating for the register region and only one device
> driver probe sets up both behaviours.

This case was something we both discussed when this patch was first
brough up, and both our tests seemed like it was OK.. What is going on
here that these non-staggered regions are failing? It looks like the
platform devices registered but the devm_request_and_iormap failed?

> >> It also breaks all of_amba_device users.
> >>
> >> of_amba_device_create() --> amba_device_add() --> request_resource()
> >> and fails.
> >
> > Presumably that's because we no longer know what the parent resource
> > is supposed to be?
> 
> Hmmm, it looks that way, yes. Currently the OF code is using
> iomem_resource as the parent for all amba_device_add() calls
> (driver/of/platform.c), but if the parent node gets registered as a
> platform device and it has the resources then the parenthood chain
> doesn't match up. It isn't immediately obvious to me how to fix this.
> I'm going to drop the patch from my tree. I could use some help
> figuring out what the correct behaviour really should be here.

I looked for a bit and it wasn't obvious to me where the colliding
request_resource was coming from. The DTs for amba busses seem to all
be placed under the root node, or within a simple bus, so there is not
parent platform device and the use of iomem_resource should still be OK?

Jason
