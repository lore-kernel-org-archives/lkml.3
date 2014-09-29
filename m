Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaI2NYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:24:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34984 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbaI2NYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:24:01 -0400
Date: Mon, 29 Sep 2014 14:23:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] DT: add binding for mxs regulator
Message-ID: <20140929132334.GE2432@leverpostej>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
 <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com>
 <20140929110919.GB2432@leverpostej>
 <54294832.8000702@i2se.com>
 <20140929124137.GD2432@leverpostej>
 <54295A2F.3070700@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54295A2F.3070700@i2se.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 02:10:07PM +0100, Stefan Wahren wrote:
> Hi,
> 
> Am 29.09.2014 um 14:41 schrieb Mark Rutland:
> > Well, the simple-bus will cause the children to be probed. But it looks
> > like you care about properties of the parent. I don't think that
> > simple-bus is appropriate because it's not being handled as a
> > transparent bridge from the PoV of the children.
> 
> actually i need the address of the power status register. In this
> version i get the base address from the parent node add an offset.
> 
> Do you prefer to define the address of the power status register like a
> second address cell:
> 
> reg_vddd: regulator@80044040 {
> 	reg = <0x80044040 0x10
> 	       0x800440c0 0x01>;
>         ...
> };
> 
> or do i need special properties like this:
> 
> reg_vddd: regulator@80044040 {
> 	reg = <0x80044040 0x10>;
> 	fsl,mxs-status-reg = <0x800440c0>;
>         ...
> };

I would prefer a top level node for the subsystem that is not a
simple-bus.

Give it a compatible string and a well-defined set of base properties
(looks like you just need the reg for now). Match that and probe the
child nodes as appropriate.

> >> Do we need a extra driver?
> > Perhaps, but it's relatively simple to match on a compatible string and
> > probe children if you just wantto start small for now.
> 
> Okay. Would be great if someone has a good example. At first, i thought
> of power/anatop.

While I believe there are examples in the kernel, I can't think
immediately of any instances.

> >>>> +- #address-cells: Number of cells required to define regulator register,
> >>>> +  must be 1
> >>>> +- #size-cells: Number of cells required to define register size, must be 1
> >>> Why must this be the case, given that the child node expects an absolute
> >>> physical address?
> >> I need a property to define the control register for the regulators
> >> without defining vendor specific properties like "fsl,mxs-control-reg"
> >> or something.
> > You misunderstand me. I was querying the "must be 1" rather than the
> > proeprties themselves.
> >
> >>> What's wrong with #address-cells = <2>, for example?
> >> Nothing
> > Then we shouldn't specify "must be 1", no?
> 
> Right, must be at least 1.

Why not just say that #address-cells, #size-cells and ranges must be
present as appropriate to map children?

> 
> >>>> +- reg: Absolute physical address and size of the register set for the device
> >>> Why is this here _and_ in the child node(s)?
> >> The parent of the power node is also a simple bus. I use this to
> >> calculate the power status register per offset.
> >>
> >>> What is the difference between this node and its children?
> >> The parent node represent the power sub system and the regulators are
> >> part of this sub system.
> >>
> >>> Can there be more than one sub-node?
> >> In the i.MX28 are at least 4 voltage regulators, 1 current regulator and
> >> many more. At first, the driver should implement only 3 voltage
> >> regulators (vddd, vdda, vddio).
> > Ok.
> >
> > I think you need a binding for the power subsystem, and a trivial driver
> > that can match on that and probe the child regulators. Are there
> > components other than voltage or current regulators in the sub system?
> 
> Yes, according to the reference manual there is a dc-dc converter, a
> battery charger, battery monitor, ...
> 
> In short a lot of developing time ;-)

Sure, but not everything needs to be supported fomr the outset.

Mark.
