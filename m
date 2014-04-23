Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbaDWPDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:03:19 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41692 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbaDWPDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:03:13 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
To: Rob Herring <robherring2@gmail.com>, Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <CAL_JsqLvLTJwgsB-m0W72WxSUoTV4ubMdvM_a784J4k2eiK9AQ@mail.gmail.com>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
	<1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
	<1395413185-29763-3-git-send-email-jjhiblot@traphandler.com>
	<CAL_Jsq+aU+rs28gV=Gesb_-Dy6Ht7zuKrRA6_hmqp94Uun23Yg@mail.gmail.com>
	<20140418205213.GA21823@atomide.com>
	<CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com>
	<20140418215848.GD21823@atomide.com>
	<20140418230335.GI24070@n2100.arm.linux.org.uk>
	<20140418232407.GQ21823@atomide.com>
	<CAL_JsqLvLTJwgsB-m0W72WxSUoTV4ubMdvM_a784J4k2eiK9AQ@mail.gmail.com>
Date: Wed, 23 Apr 2014 16:02:49 +0100
Message-Id: <20140423150249.38110C408D2@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014 08:47:41 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Apr 18, 2014 at 6:24 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [140418 16:04]:
> >> On Fri, Apr 18, 2014 at 02:58:48PM -0700, Tony Lindgren wrote:
> >> > Oh come on, let's stop pretending it's not broken. And it's way worse with
> >> > device tree as there's nothing making sure the resources for a driver
> >> > are set up before the driver probes. And we've been unable to fix just
> >> > this issue alone for about six months now. It's also broken beyond that.
> >> > It's called of_platform_bus yet it won't even pass the platform_data
> >> > as auxdata to the devices on a sub-bus instantatiated like I2C.
> >>
> >> Isn't there a much simpler solution to the platform device IRQ problem?
> >>
> >> Rather than trying to fix it at the point where the resources are
> >> created, why not just *not* have DT create the IRQ resources in the
> >> first place, and instead have platform_get_irq() (which is the function
> >> which should be used to get an IRQ) be the actor to do whatever is
> >> necessary to return the IRQ(s) ?
> >
> > Yeah why not. I don't see why we would need to do all this of_* special
> > trickery for much anything beyond parsing the binding.
> 
> That can work, but it will still need something like
> of_find_irq_domain() to determine whether to return -EPROBE_DEFER or
> not.
> 
> You could also go in the other direction and don't create the device
> until the resources can be resolved. Unlike any of the other
> solutions, that would work for amba bus as well although we may never
> have a case where we need this with the amba bus. This would require
> making of_platform_populate be callable multiple times, but there are
> already some other reasons for wanting to do that. Specifically, I
> would like the core code to call of_platform_populate with default
> options and then only platforms with non-default options need a call
> to of_platform_populate.

No it wouldn't. It would require of_platform_populate to do the right
thing internally and know when to create devices from nodes that get
flagged by calling of_platform_populate().

> >> Yes, I know we have some drivers which use platform_get_resources() with
> >> IORESOURCE_IRQ, but they should really use the right accessor.  And those
> >> who just dereference the resource array directly... get what's coming
> >> (though of course they have to be fixed.)
> >
> > $ git grep IORESOURCE_IRQ drivers/ | grep platform_get_resource | wc -l
> > 179
> 
> Certainly, this is worthwhile clean-up no matter what the solution.

Yes, and it works no matter what the data source is; platform_data, dt,
acpi, and works on any platform.

g.

