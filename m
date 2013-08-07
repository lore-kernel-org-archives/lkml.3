Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab3HGRNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:13:55 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:65457 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3HGRNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:13:53 -0400
Date: Wed, 7 Aug 2013 13:13:48 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] pdev: Fix platform device resource linking
Message-ID: <20130807171345.GA30831@ohporter.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com>
 <1375775624-12250-2-git-send-email-panto@antoniou-consulting.com>
 <20130806093601.GB27889@kroah.com>
 <311C42C3-6544-4058-ABE9-F9FAE72DD5CA@antoniou-consulting.com>
 <20130806101527.GB29283@kroah.com>
 <A7E5F769-6238-430C-AEE5-94598C334D5E@antoniou-consulting.com>
 <20130807055630.GC5304@kroah.com>
 <29EDB4A0-B6EF-4795-AD14-A35D9415EFE2@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29EDB4A0-B6EF-4795-AD14-A35D9415EFE2@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed my old email]

On Wed, Aug 07, 2013 at 10:37:17AM +0300, Pantelis Antoniou wrote:
> Hi Greg,
> 
> On Aug 7, 2013, at 8:56 AM, Greg Kroah-Hartman wrote:
> 
> > On Tue, Aug 06, 2013 at 01:27:35PM +0300, Pantelis Antoniou wrote:
> >> Hi Greg,
> >> 
> >> On Aug 6, 2013, at 1:15 PM, Greg Kroah-Hartman wrote:
> >> 
> >>> On Tue, Aug 06, 2013 at 12:45:42PM +0300, Pantelis Antoniou wrote:
> >>>> Hi Greg,
> >>>> 
> >>>> On Aug 6, 2013, at 12:36 PM, Greg Kroah-Hartman wrote:
> >>>> 
> >>>>> On Tue, Aug 06, 2013 at 10:53:40AM +0300, Pantelis Antoniou wrote:
> >>>>>> Platform device removal uncovered a number of problems with
> >>>>>> the way resources are handled in the core platform code.
> >>>>>> 
> >>>>>> Resources now form child/parent linkages and this requires
> >>>>>> proper linking of the resources. On top of that the OF core
> >>>>>> directly creates it's own platform devices. Simplify things
> >>>>>> by providing helper functions that manage the linking properly.
> >>>>> 
> >>>>> Ugh, the OF core shouldn't be creating platform devices.  Well, yes, I
> >>>>> know it does that today, but ick, ick, ick.
> >>>>> 
> >>>> 
> >>>> Yep, ick, ick, ick is the correct form.
> >>>> 
> >>>>>> Two functions are provided:
> >>>>>> 
> >>>>>> platform_device_link_resources(), which links all the
> >>>>>> linkable resources (if not already linked).
> >>>>>> 
> >>>>>> and platform_device_unlink_resources(), which unlinks all the
> >>>>>> resources.
> >>>>> 
> >>>>> Why would anyone need to call this?  I'm getting the feeling that OF
> >>>>> should just have it's own bus of devices to handle this type of mess.
> >>>>> ACPI is going through the same rewrite for this same type of problem
> >>>>> (they did things differently.)  I suggest you work with the ACPI
> >>>>> developers to so the same thing they are, to solve it correctly for
> >>>>> everyone.
> >>>>> 
> >>>> 
> >>>> It's the same problem really. Another bus type might not fly well.
> >>>> The same device driver should be (in theory) be made to work unchanged
> >>>> either on an OF/ACPI/Fex( :) ) setup.
> >>> 
> >>> No, that's not quite true, a driver needs to know how to talk to the
> >>> bus, as that is how it communicates to the hardware.  It can be done for
> >>> different types of busses (see the OHCI USB controller for one example
> >>> of this), but a driver will have to know what type of bus it is on in
> >>> order to work properly.
> >>> 
> >> 
> >> In the case of OF & ACPI there is no 'bus'. The device is probably integrated
> >> in the SoC's silicon, but there is absolutely no way to 'probe' for it's existence;
> >> you have to use a-priori knowledge of the SoC's topology in order to configure it
> >> (along with any per-board specific information if there is any kind of shared 
> >> resource configuration - i.e. pinmuxing or something else).
> > 
> > Not all busses need to have the aiblity to "probe" for new devices,
> > that's not a requirement at all.  Some of them just "know" where the
> > devices are at in the driver model, and create the devices for the bus
> > just fine.
> > 
> > So don't think that just because of that lack of probing, they should be
> > on the "platform" bus at all.  Platform is for the "oh crap, I have no
> > way to bind this to anything else, make it a platform device then."
> > 
> 
> I'm not sure if you remember, but a long time ago when OF started getting
> into the kernel, there actually was an OCP (On Chip Peripheral) bus, 
> and the switch to platform devices was mandated by kernel people, by their
> insistance that platform devices would cover every case.
> 
> See here:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0405.1/0930.html
> 
> I'm sure Matt Porter can shed some light on the exchange that led to the 
> abandonment of the ocp bus concept.

Heh, that OCP support looks a bit antiquated by today's standards. If it
helps, http://lkml.indiana.edu/hypermail/linux/kernel/0501.2/0696.html
is the posting where Kumar starts taking arch/ppc away from using
drivers/ocp/. I can't find any public discussion that led to this, but I
recall the common advice was "just use platform devices". This was,
incidentally, just before the move to arch/powerpc (and DT for all)
began.

Keep in mind that this is 8ish years ago before embedded was
fashionable since we didn't all have Linux machines in our pockets.
I suspect that advice was given because nobody cared about
platform_device removal and it worked for the use cases at the time.

-Matt
