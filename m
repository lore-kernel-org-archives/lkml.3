Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3FZWTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:19:16 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44345 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3FZWTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:19:14 -0400
MIME-Version: 1.0
In-Reply-To: <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Jun 2013 16:18:53 -0600
Message-ID: <CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
To: Mika Westerberg <mika.westerberg@linux.intel.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Thunderbolt PCI-to-PCI bridges typically use BIOS "assisted" enumeration.
> This means that the BIOS will allocate bridge resources based on some
> assumptions of a maximum Thunderbolt chain. It also disables native PCIe
> hotplug of the root port where the Thunderbolt host router is connected.

The BIOS often assigns PCI bridge windows, e.g., for root ports
leading to ExpressCard slots.  I assume BIOSes make similar
assumptions there about what ExpressCards are likely to be plugged in.
 Is your BIOS assistance the same sort of thing, or is there something
additional happening at hot-add time?  (I think there might be AML
that does Thunderbolt-specific stuff at hotplug-time, but I assume
that's not related to resource assignment, because the OS owns those
resources.)

> In order to support this we must make sure that the kernel does not try to
> be too smart and resize / open the bridge windows during PCI enumeration.
> For example by default the kernel will add certain amount of space to the
> bridge memory/io windows (this is configurable via pci=hp[mem|io]size=xxx
> command line option). Eventually we run out of space that the BIOS has
> allocated.

ROMs usually aren't very big compared to regular memory BARs.  Is the
problem just that adding space the BIOS didn't plan for causes the OS
to increase the window size and bump into space assigned to a peer of
the Thunderbolt controller?

> Also address space for expansion ROMs should not be allocated (BIOS does
> not execute them for Thunderbolt endpoints). If we don't prevent this the
> kernel might find expansion ROM associated with some endpoint and reopen
> the bridge window which the BIOS already closed leading again resource
> exhaustion.

I assume the only reason we should not allocate expansion ROM space is
to avoid resource exhaustion.  If we had enough resources, allocating
ROM space wouldn't cause anything bad to happen, would it?

> Fix this by adding a quirk that matches known Thunderbolt PCI-to-PCI
> bridges and in that case prevents allocation of expansion ROM resources and
> makes sure that the PCI core does not increase size of bridge windows.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  arch/x86/pci/fixup.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>
> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> index f5809fa..924822b 100644
> --- a/arch/x86/pci/fixup.c
> +++ b/arch/x86/pci/fixup.c
> @@ -7,6 +7,8 @@
>  #include <linux/pci.h>
>  #include <linux/init.h>
>  #include <linux/vgaarb.h>
> +#include <linux/acpi.h>
> +#include <linux/pci-acpi.h>
>  #include <asm/pci_x86.h>
>
>  static void pci_fixup_i450nx(struct pci_dev *d)
> @@ -539,3 +541,52 @@ static void twinhead_reserve_killing_zone(struct pci_dev *dev)
>          }
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27B9, twinhead_reserve_killing_zone);
> +
> +#ifdef CONFIG_ACPI
> +/*
> + * BIOS assisted Thunderbolt PCI enumeration should handle all resource
> + * allocation on behalf of OS.
> + */
> +static void quirk_thunderbolt(struct pci_dev *dev)
> +{
> +       struct acpi_pci_root *root;
> +       acpi_handle handle;
> +
> +       handle = acpi_find_root_bridge_handle(dev);
> +       if (!handle)
> +               return;
> +
> +       root = acpi_pci_find_root(handle);
> +       if (!root)
> +               return;
> +
> +       /*
> +        * Native PCIe hotplug should be disabled when BIOS assisted
> +        * hotplug is in use.
> +        */
> +       if (root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
> +               return;

I'm not really sure why this test is here.  I dimly recall hearing
that Thunderbolt hotplug requires some work at hotplug-time, and this
is not all public, and hence is done by AML.  But that in itself
doesn't seem related to the question of allocating ROM space.

> +       /*
> +        * Make sure that we don't allocate resources for expansion ROMs.
> +        * This may accidentally increase the size of the bridge window
> +        * causing us to run out of resources.
> +        */
> +       if (!(pci_probe & PCI_NOASSIGN_ROMS)) {
> +               pr_info("Thunderbolt host router detected disabling ROMs\n");

We have a pci_dev, so this should use dev_info().

> +               pci_probe |= PCI_NOASSIGN_ROMS;

I think you really only care about the space for ROMs on devices
connected via Thunderbolt, so it's kind of a shame that the switch is
global and affects ROMs on *all* devices.  I guess there's nothing
simple to be done about that, though.

> +       }
> +
> +       /*
> +        * Don't add anything to the BIOS allocated bridge window size for
> +        * the same reason.
> +        */
> +       dev->is_hotplug_bridge = 0;

"is_hotplug_bridge" is also used in MPS management
(pcie_find_smpss()).  Did you investigate that and make sure this is
safe?  I think the Thunderbolt controller supports hotplug, and I'm
not sure what will happen if the MPS code assumes it doesn't.

> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1513, quirk_thunderbolt);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x151a, quirk_thunderbolt);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x151b, quirk_thunderbolt);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1547, quirk_thunderbolt);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1548, quirk_thunderbolt);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1549, quirk_thunderbolt);
> +#endif
> --
> 1.8.3.1
>
