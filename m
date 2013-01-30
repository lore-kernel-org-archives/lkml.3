Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3A3RVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:21:32 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50257 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3A3RV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:21:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130130080921.GA15263@kroah.com>
References: <20130129234427.23748.83270.stgit@bhelgaas.mtv.corp.google.com>
 <CAErSpo6B+TWKpP=P6hoNLzziq9Po-OwW2zGBHCc+qSJ2HtTYNQ@mail.gmail.com> <20130130080921.GA15263@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 30 Jan 2013 10:21:07 -0700
Message-ID: <CAErSpo4M_z7Yj=uSUfy-SjyVEr7_q-5xLN6q==cgERVY2EDKZg@mail.gmail.com>
Subject: Re: [PATCH] Driver core: treat unregistered bus_types as having no devices
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joonsoo Kim <js1304@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 1:09 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 29, 2013 at 04:47:13PM -0700, Bjorn Helgaas wrote:
>> On Tue, Jan 29, 2013 at 4:44 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> > A bus_type has a list of devices (klist_devices), but the list and the
>> > subsys_private structure that contains it are not initialized until the
>> > bus_type is registered with bus_register().
>> >
>> > The panic/reboot path has fixups that look up devices in pci_bus_type.  If
>> > we panic before registering pci_bus_type, the bus_type exists but the list
>> > does not, so mach_reboot_fixups() trips over a null pointer and panics
>> > again:
>> >
>> >     mach_reboot_fixups
>> >       pci_get_device
>> >         ..
>> >           bus_find_device(&pci_bus_type, ...)
>> >             bus->p is NULL
>> >
>> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> > ---
>> >  drivers/base/bus.c |    4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
>> > index 24eb078..6856303 100644
>> > --- a/drivers/base/bus.c
>> > +++ b/drivers/base/bus.c
>> > @@ -290,7 +290,7 @@ int bus_for_each_dev(struct bus_type *bus, struct device *start,
>> >         struct device *dev;
>> >         int error = 0;
>> >
>> > -       if (!bus)
>> > +       if (!bus || !bus->p)
>> >                 return -EINVAL;
>> >
>> >         klist_iter_init_node(&bus->p->klist_devices, &i,
>> > @@ -324,7 +324,7 @@ struct device *bus_find_device(struct bus_type *bus,
>> >         struct klist_iter i;
>> >         struct device *dev;
>> >
>> > -       if (!bus)
>> > +       if (!bus || !bus->p)
>> >                 return NULL;
>> >
>> >         klist_iter_init_node(&bus->p->klist_devices, &i,
>> >
>>
>> Sorry, I meant to include this in the original post:
>>
>> Joonsoo reported a problem when panicking before PCI was initialized.
>> I think this patch should be sufficient to replace the patch he posted
>> here: https://lkml.org/lkml/2012/12/28/75 ("[PATCH] x86, reboot: skip
>> reboot_fixups in early boot phase")
>
> Don't you think that should be applied as well?  That makes things a bit
> more explicit in the boot process as to exactly what is going on.  The
> driver core changes is good to have if other people mess things up like
> this in the future, don't rely on it to protect you from foolish things.

mach_reboot_fixups() is not part of the boot process at all.  That's
why it seems ugly to me to clutter it with a system_state check.  I
don't really think of it as having messed up by calling
pci_get_device() without checking system_state.  Certainly we don't
expect *every* caller to check system_state, and it's not trivial to
determine at every call site whether pci_bus has been registered or
not.

But if anybody wants to apply the https://lkml.org/lkml/2012/12/28/75
too, it's OK with me.

Tangential question ... I was curious as to why bus_for_each_dev() and
bus_find_device() (and other driver core things) check for "!bus" in
the first place.  For all the callers I looked at, it's obvious at
compile-time that bus can't be NULL.  The question of whether "bus->p"
is null can't be answered at compile-time because it depends on
whether the bus has been registered.

Bjorn
