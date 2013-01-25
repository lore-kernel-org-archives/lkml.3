Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3AYEWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 23:22:15 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61945 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3AYEWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 23:22:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130125041411.GB12562@kroah.com>
References: <1356702623-9430-1-git-send-email-js1304@gmail.com>
 <CAErSpo5_dgH1Au3QChVrhqBY_Fm54+Aw_ZiwGf2JSsgQaR1dug@mail.gmail.com>
 <20130125011303.GA3401@lge.com> <20130125025901.GA26984@google.com> <20130125041411.GB12562@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 24 Jan 2013 21:21:52 -0700
Message-ID: <CAErSpo43SoeFn1N5shnxsXmL-ZOmkDQM6yFwyaeBMTRhcy4=dA@mail.gmail.com>
Subject: Re: [PATCH] x86, reboot: skip reboot_fixups in early boot phase
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 9:14 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 24, 2013 at 07:59:01PM -0700, Bjorn Helgaas wrote:
>> [+cc Greg for driver core]
>>
>> On Fri, Jan 25, 2013 at 10:13:03AM +0900, Joonsoo Kim wrote:
>> > Hello, Bjorn.
>> >
>> > On Thu, Jan 24, 2013 at 10:45:13AM -0700, Bjorn Helgaas wrote:
>> > > On Fri, Dec 28, 2012 at 6:50 AM, Joonsoo Kim <js1304@gmail.com> wrote:
>> > > > During early boot phase, PCI bus subsystem is not yet initialized.
>> > > > If panic is occured in early boot phase and panic_timeout is set,
>> > > > code flow go into emergency_restart() and hit mach_reboot_fixups(), then
>> > > > encounter another panic. When second panic, we can't hold a panic_lock, so
>> > > > code flow go into panic_smp_self_stop() which prevent system to restart.
>> > > >
>> > > > For avoid second panic, skip reboot_fixups in early boot phase.
>> > > > It makes panic_timeout works in early boot phase.
>> > > >
>> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > > > Cc: Ingo Molnar <mingo@redhat.com>
>> > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
>> > > > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>> > > >
>> > > > diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
>> > > > index c8e41e9..b9b8ec9 100644
>> > > > --- a/arch/x86/kernel/reboot_fixups_32.c
>> > > > +++ b/arch/x86/kernel/reboot_fixups_32.c
>> > > > @@ -89,6 +89,10 @@ void mach_reboot_fixups(void)
>> > > >         if (in_interrupt())
>> > > >                 return;
>> > > >
>> > > > +       /* During early boot phase, PCI is not yet initialized */
>> > > > +       if (system_state == SYSTEM_BOOTING)
>> > > > +               return;
>> > > > +
>> > > >         for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
>> > > >                 cur = &(fixups_table[i]);
>> > > >                 dev = pci_get_device(cur->vendor, cur->device, NULL);
>> > >
>> > > I guess you're saying that if we call pci_get_device() too early, it
>> > > panics?  Did you figure out why that happens?
>> > >
>> > > If we call pci_get_device() before PCI has been initialized, it would
>> > > be good if it just returned NULL, indicating that we didn't find any
>> > > matching device.  I looked briefly, and I thought that's what would
>> > > happen, but apparently I'm missing something.
>> >
>> > In bus_find_device(), klist_iter_init_node() is called with
>> > @bus->p->klist_device. Before initialization, bus->p is NULL,
>> > so panic is occured.
>>
>> I see.  pci_bus_type.p is initialized by __bus_register() in this path:
>>
>>   pci_driver_init        # postcore_initcall
>>     bus_register(&pci_bus_type)
>>       __bus_register
>>         priv = kzalloc(sizeof(struct subsys_private))
>>       bus->p = priv
>>       klist_init(&priv->klist_devices, klist_devices_get, klist_devices_put)
>>
>> I was hoping we could statically initialize the klist, but that doesn't
>> seem likely.
>>
>> But I wonder if we could do something like the following.  If we could,
>> then callers wouldn't have to worry about whether or not the bus has been
>> initialized.
>
> <snip>
>
> I have no objection to that patch, but really, someone wants to call
> pci_find_device() before PCI is initialized?  Can't that be fixed
> instead, as that is the root problem, not the driver core.
>
> But, to paper over your subsystem's bugs, I guess I can take it :)

The caller is in the native_machine_emergency_restart() path.
Joonsoo's original patch does what I think you're suggesting:

>> > > > +       /* During early boot phase, PCI is not yet initialized */
>> > > > +       if (system_state == SYSTEM_BOOTING)
>> > > > +               return;
>> > > > +
>> > > >         for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
>> > > >                 cur = &(fixups_table[i]);
>> > > >                 dev = pci_get_device(cur->vendor, cur->device, NULL);

I think it's sort of ugly to check system_state before using
pci_get_device(), and there's not really an obvious connection between
system_state and PCI initialization.

But if you prefer that, Joonsoo's original patch is fine with me.
