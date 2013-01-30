Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3A3I4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:56:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:46040 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab3A3I4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:56:52 -0500
Date: Wed, 30 Jan 2013 09:09:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Driver core: treat unregistered bus_types as having no
 devices
Message-ID: <20130130080921.GA15263@kroah.com>
References: <20130129234427.23748.83270.stgit@bhelgaas.mtv.corp.google.com>
 <CAErSpo6B+TWKpP=P6hoNLzziq9Po-OwW2zGBHCc+qSJ2HtTYNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6B+TWKpP=P6hoNLzziq9Po-OwW2zGBHCc+qSJ2HtTYNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 04:47:13PM -0700, Bjorn Helgaas wrote:
> On Tue, Jan 29, 2013 at 4:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > A bus_type has a list of devices (klist_devices), but the list and the
> > subsys_private structure that contains it are not initialized until the
> > bus_type is registered with bus_register().
> >
> > The panic/reboot path has fixups that look up devices in pci_bus_type.  If
> > we panic before registering pci_bus_type, the bus_type exists but the list
> > does not, so mach_reboot_fixups() trips over a null pointer and panics
> > again:
> >
> >     mach_reboot_fixups
> >       pci_get_device
> >         ..
> >           bus_find_device(&pci_bus_type, ...)
> >             bus->p is NULL
> >
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > ---
> >  drivers/base/bus.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > index 24eb078..6856303 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -290,7 +290,7 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
> >         struct device *dev;
> >         int error = 0;
> >
> > -       if (!bus)
> > +       if (!bus || !bus->p)
> >                 return -EINVAL;
> >
> >         klist_iter_init_node(&bus->p->klist_devices, &i,
> > @@ -324,7 +324,7 @@ struct device *bus_find_device(struct bus_type *bus,
> >         struct klist_iter i;
> >         struct device *dev;
> >
> > -       if (!bus)
> > +       if (!bus || !bus->p)
> >                 return NULL;
> >
> >         klist_iter_init_node(&bus->p->klist_devices, &i,
> >
> 
> Sorry, I meant to include this in the original post:
> 
> Joonsoo reported a problem when panicking before PCI was initialized.
> I think this patch should be sufficient to replace the patch he posted
> here: https://lkml.org/lkml/2012/12/28/75 ("[PATCH] x86, reboot: skip
> reboot_fixups in early boot phase")

Don't you think that should be applied as well?  That makes things a bit
more explicit in the boot process as to exactly what is going on.  The
driver core changes is good to have if other people mess things up like
this in the future, don't rely on it to protect you from foolish things.

thanks,

greg k-h
