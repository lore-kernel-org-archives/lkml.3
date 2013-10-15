Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3JOXBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:01:47 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:62329 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab3JOXBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:01:44 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 04/10] irqdomain: Return errors from irq_create_of_mapping()
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, sparclinux@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20130923081337.GB11881@ulmo>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com> <1379510692-32435-5-git-send-email-treding@nvidia.com> <CAL_JsqLQeAQD460f8Lk9eDE2dCzLusC1mXZ-_uaKVFLfhJNryg@mail.gmail.com> <20130923081337.GB11881@ulmo>
Date: Wed, 16 Oct 2013 00:01:39 +0100
Message-Id: <20131015230139.E9FBFC40099@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013 10:13:38 +0200, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Sun, Sep 22, 2013 at 04:14:43PM -0500, Rob Herring wrote:
> > On Wed, Sep 18, 2013 at 8:24 AM, Thierry Reding
> > <thierry.reding@gmail.com> wrote:
> > > Instead of returning 0 for all errors, allow the precise error code to
> > > be propagated. This will be used in subsequent patches to allow further
> > > propagation of error codes.
> > >
> > > The interrupt number corresponding to the new mapping is returned in an
> > > output parameter so that the return value is reserved to signal success
> > > (== 0) or failure (< 0).
> > >
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > 
> > One comment below, otherwise:
> > 
> > Acked-by: Rob Herring <rob.herring@calxeda.com>
> > 
> > > diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> > > index 905a24b..ae71b14 100644
> > > --- a/arch/powerpc/kernel/pci-common.c
> > > +++ b/arch/powerpc/kernel/pci-common.c
> > > @@ -230,6 +230,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
> > >  {
> > >         struct of_irq oirq;
> > >         unsigned int virq;
> > > +       int ret;
> > >
> > >         pr_debug("PCI: Try to map irq for %s...\n", pci_name(pci_dev));
> > >
> > > @@ -266,8 +267,10 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
> > >                          oirq.size, oirq.specifier[0], oirq.specifier[1],
> > >                          of_node_full_name(oirq.controller));
> > >
> > > -               virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
> > > -                                            oirq.size);
> > > +               ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
> > > +                                           oirq.size, &virq);
> > > +               if (ret)
> > > +                       virq = NO_IRQ;
> > >         }
> > >         if(virq == NO_IRQ) {
> > >                 pr_debug(" Failed to map !\n");
> > 
> > Can you get rid of NO_IRQ usage here instead of adding to it.
> 
> I was trying to stay consistent with the remainder of the code. PowerPC
> is a pretty heavy user of NO_IRQ. Of all 348 references, more than half
> (182) are in arch/powerpc, so I'd rather like to get a go-ahead from
> Benjamin on this.
> 
> That said, perhaps we should just go all the way and get rid of NO_IRQ
> for good. Things could get somewhat messy, though. There are a couple of
> these spread through the code:
> 
> 	#ifndef NO_IRQ
> 	#define NO_IRQ (-1)
> 	#endif

And all of them are wrong and need to be removed.  :-)  We're /slowly/
getting rid of the -1 and the usage of NO_IRQ. A global search and
replace of s/NO_IRQ/0/g can be very safely done on arch/powerpc since
powerpc has had NO_IRQ set correctly to '0' for a very long time now.

So, yes, if you're keen to do it I'd love to see a series getting rid of
more NO_IRQ users.

g.
