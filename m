Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaJONmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:42:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35769 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbaJONmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:42:18 -0400
Date: Wed, 15 Oct 2014 14:42:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
Message-ID: <20141015134209.GD20034@leverpostej>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <1413378271.2762.77.camel@infradead.org>
 <20141015131551.GC20034@leverpostej>
 <1413379736.2762.79.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413379736.2762.79.camel@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 02:28:56PM +0100, David Woodhouse wrote:
> On Wed, 2014-10-15 at 14:15 +0100, Mark Rutland wrote:
> > > @@ -155,7 +168,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
> > >  	if (!match)
> > >  		return -EINVAL;
> > >  
> > > -	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
> > > +	if (!device_get_property(&ofdev->dev, "used-by-rtas", NULL))
> > >  		return -EBUSY;
> > 
> > This property should never be present on an ACPI system. RTAS is a
> > completely different firmware interface on PowerPC.
> 
> Yes, I sincerely hope we never see used-by-rtas being set on a non-PPC
> system. But this isn't a new consideration; we were already checking for
> 'used-by-rtas' on *all* platforms. Perhaps we shouldn't be. But that's
> almost orthogonal to the issue at hand.

We have been checking for all DT platforms, and that's a bug for DT.
Copying that bug to ACPI is inexcusable given we know it's a bug to do
so.

No-one is using ACPI+RTAS, so there is no reason to enable this property
for ACPI. The only reason anyone would (mis)use this property with ACPI
is because Linux happened to support that combination, which need not be
the case because it doesn't make any sense.

> > As a general note, I would hope that we're not going to blindly convert
> > drivers and subsystems over to a common property interface without
> > considering each property w.r.t. the particular FW interface. 
> >
> > Each addition to _DSD, especially if through a common accessor needs
> > _more_ scrutiny than is applied to DT bindings, and we hardly manage to
> > review DT bindings.
> 
> The whole point here is to use existing bindings rather than having to
> reinvent the wheel. Sure, where the existing binding really makes no
> sense for certain subsystems, we should come up with something
> different.

I understand that. However, where a binding doesn't make sense (as in
this case), it shouldn't be enabled for ACPI as it provides a larger
surface area for misuse, for no benefit.

> But in the general case for 'leaf-node' peripherals we would hope that
> we don't really have to change *anything* other than to make sure the
> driver is using generic property accessor functions instead of the old
> OF-specific ones. The point here is *consistency*. We really don't want
> to make a habit of reinventing different bindings to be exposed through
> the different firmware types.

Where we have a property of a leaf-node that is independent of the
description format, sure. I am not asking us to re-invent bindings, but
we must consider the differences between ACPI and DT systems when trying
to port a DT binding to ACPI.

My concern here is that we don't have the mechanisms in place for
sufficient scrutiny to be applied when bindings are ported over. We
_will_ end up porting over things that don't make sense (as this patch
shows), and some of those are likely to cause unnecessary pain for
everyone. It does not make sense to say that is OK.

Mark.
