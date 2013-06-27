Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3F0NuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:50:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:21976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3F0NuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:50:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,952,1363158000"; 
   d="scan'208";a="360487406"
Date: Thu, 27 Jun 2013 16:54:05 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
Message-ID: <20130627135405.GW9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 04:18:53PM -0600, Bjorn Helgaas wrote:
> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > Thunderbolt PCI-to-PCI bridges typically use BIOS "assisted" enumeration.
> > This means that the BIOS will allocate bridge resources based on some
> > assumptions of a maximum Thunderbolt chain. It also disables native PCIe
> > hotplug of the root port where the Thunderbolt host router is connected.
> 
> The BIOS often assigns PCI bridge windows, e.g., for root ports
> leading to ExpressCard slots.  I assume BIOSes make similar
> assumptions there about what ExpressCards are likely to be plugged in.
>  Is your BIOS assistance the same sort of thing, or is there something
> additional happening at hot-add time?  (I think there might be AML
> that does Thunderbolt-specific stuff at hotplug-time, but I assume
> that's not related to resource assignment, because the OS owns those
> resources.)

Yes, if I understand it right the BIOS gets SCI on hotplug, then it
enumerates and configures the devices, and finally sends an ACPI bus check
event to the OS.

> > In order to support this we must make sure that the kernel does not try to
> > be too smart and resize / open the bridge windows during PCI enumeration.
> > For example by default the kernel will add certain amount of space to the
> > bridge memory/io windows (this is configurable via pci=hp[mem|io]size=xxx
> > command line option). Eventually we run out of space that the BIOS has
> > allocated.
> 
> ROMs usually aren't very big compared to regular memory BARs.  Is the
> problem just that adding space the BIOS didn't plan for causes the OS
> to increase the window size and bump into space assigned to a peer of
> the Thunderbolt controller?

You are right.

I did some more investigation on this and the BIOS seems to close the
bridge windows if there are no devices behind the bridge or the device is
not using certain type of resource (io/pmem). However, Linux then finds out
that the bridge supports these optional windows (in pci_bridge_check_ranges())
and because is_hotplug_bridge == 1, it adds the default sizes to the bridge
window resources causing this:

[   15.753262] pci 0000:07:06.0: scanning [bus 80-80] behind bridge, pass 0
[   15.754458] pci_bus 0000:80: scanning bus
[   15.755563] pci_bus 0000:80: fixups for bus
[   15.756668] pci 0000:07:06.0: PCI bridge to [bus 80]
...
[   15.873433] pci 0000:07:06.0: BAR 7: can't assign io (size 0x1000)
[   15.874542] pci 0000:07:06.0: BAR 8: can't assign mem (size 0x200000)
[   15.875632] pci 0000:07:06.0: BAR 9: can't assign mem pref (size 0x200000)

The above bridge has all the windows closed by the BIOS.

If I have "pci=hpmemsize=0,hpiosize=0" in the kernel command line this
works.

> > Also address space for expansion ROMs should not be allocated (BIOS does
> > not execute them for Thunderbolt endpoints). If we don't prevent this the
> > kernel might find expansion ROM associated with some endpoint and reopen
> > the bridge window which the BIOS already closed leading again resource
> > exhaustion.
> 
> I assume the only reason we should not allocate expansion ROM space is
> to avoid resource exhaustion.  If we had enough resources, allocating
> ROM space wouldn't cause anything bad to happen, would it?

Right.

> > Fix this by adding a quirk that matches known Thunderbolt PCI-to-PCI
> > bridges and in that case prevents allocation of expansion ROM resources and
> > makes sure that the PCI core does not increase size of bridge windows.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  arch/x86/pci/fixup.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> >
> > diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> > index f5809fa..924822b 100644
> > --- a/arch/x86/pci/fixup.c
> > +++ b/arch/x86/pci/fixup.c
> > @@ -7,6 +7,8 @@
> >  #include <linux/pci.h>
> >  #include <linux/init.h>
> >  #include <linux/vgaarb.h>
> > +#include <linux/acpi.h>
> > +#include <linux/pci-acpi.h>
> >  #include <asm/pci_x86.h>
> >
> >  static void pci_fixup_i450nx(struct pci_dev *d)
> > @@ -539,3 +541,52 @@ static void twinhead_reserve_killing_zone(struct pci_dev *dev)
> >          }
> >  }
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27B9, twinhead_reserve_killing_zone);
> > +
> > +#ifdef CONFIG_ACPI
> > +/*
> > + * BIOS assisted Thunderbolt PCI enumeration should handle all resource
> > + * allocation on behalf of OS.
> > + */
> > +static void quirk_thunderbolt(struct pci_dev *dev)
> > +{
> > +       struct acpi_pci_root *root;
> > +       acpi_handle handle;
> > +
> > +       handle = acpi_find_root_bridge_handle(dev);
> > +       if (!handle)
> > +               return;
> > +
> > +       root = acpi_pci_find_root(handle);
> > +       if (!root)
> > +               return;
> > +
> > +       /*
> > +        * Native PCIe hotplug should be disabled when BIOS assisted
> > +        * hotplug is in use.
> > +        */
> > +       if (root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
> > +               return;
> 
> I'm not really sure why this test is here.  I dimly recall hearing
> that Thunderbolt hotplug requires some work at hotplug-time, and this
> is not all public, and hence is done by AML.  But that in itself
> doesn't seem related to the question of allocating ROM space.

The check is here because we need to check that the native PCIe hotplug is
disabled by the BIOS. Thunderbolt supports standard PCIe hotplug but some
operating systems (not including Linux) can't handle that properly so BIOS
will do that on behalf of the OS.

It is possible that some systems use native PCIe hotplug (although we
haven't seen such yet). Hence we need to check it here and not apply the
quirk in that case.

> > +       /*
> > +        * Make sure that we don't allocate resources for expansion ROMs.
> > +        * This may accidentally increase the size of the bridge window
> > +        * causing us to run out of resources.
> > +        */
> > +       if (!(pci_probe & PCI_NOASSIGN_ROMS)) {
> > +               pr_info("Thunderbolt host router detected disabling ROMs\n");
> 
> We have a pci_dev, so this should use dev_info().

OK.

> > +               pci_probe |= PCI_NOASSIGN_ROMS;
> 
> I think you really only care about the space for ROMs on devices
> connected via Thunderbolt, so it's kind of a shame that the switch is
> global and affects ROMs on *all* devices.  I guess there's nothing
> simple to be done about that, though.

Well, now that I understand this a bit better, I think we don't need to
set the PCI_NOASSIGN_ROMS anymore...

> > +       }
> > +
> > +       /*
> > +        * Don't add anything to the BIOS allocated bridge window size for
> > +        * the same reason.
> > +        */
> > +       dev->is_hotplug_bridge = 0;

...nor do this

I think that we can get this working so that we add a new flag to struct
pci_dev, something like 'no_additional_hotplug_bus_space' and in this quirk
set that.

Then in __pci_bus_size_bridges() we do:

	pci_bridge_check_ranges(bus);
	if (bus->self->is_hotplug_bridge &&
	    !bus->self->no_additional_hotplug_bus_space) {
		additional_io_size  = pci_hotplug_io_size;
		additional_mem_size = pci_hotplug_mem_size;
	}

This should prevent the problem this patch was trying to solve. Does that
work for you?

Of course, once we do that the user is not able to change the defaults for
Thunderbolt PCI bridges anymore by passing new values from the kernel
command line. Not sure if it is needed, though.
