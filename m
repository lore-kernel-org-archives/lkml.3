Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3FYSEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:04:34 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62135 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FYSEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:04:32 -0400
MIME-Version: 1.0
In-Reply-To: <1372177330-28013-5-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-5-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 25 Jun 2013 21:04:31 +0300
Message-ID: <CAHp75Vesp=u+GqBM5RfG-s_BmEoLXZz-zp3+tsHYUsoSNv4XUQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] PCI: acpiphp: check for new devices on enabled host
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 7:22 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Current acpiphp_check_bridge() implementation is pretty dumb:
>  - it enables the slot if it's not enabled and the slot status is
>    ACPI_STA_ALL;
>  - it disables the slot if it's enabled and slot is not in ACPI_STA_ALL
>    state.
>
> This behavior is not enough to handle Thunderbolt chaining case
> properly. We need to actually rescan for new devices even if a device
> has already in the slot.
>
> The new implementation disables and stops the slot if it's not in
> ACPI_STA_ALL state.
>
> For ACPI_STA_ALL state we first trim devices which don't respond and
> look for the ones after that. We do that even if slot already enabled
> (SLOT_ENABLED).

Just a couple of nitpicks below.

>         list_for_each_entry(slot, &bridge->slots, node) {
> +               struct pci_bus *bus = slot->bridge->pci_bus;
> +               struct pci_dev *dev, *tmp;
> +               int retval;
> +
> +               mutex_lock(&slot->crit_sect);

Does it make sense to introduce a helper let's say
__acpiphp_check_slot() and put there all lines inside this mutex?

> +               if (get_slot_status(slot) == ACPI_STA_ALL) {
> +                       /* remove stale devices if any */
> +                       list_for_each_entry_safe(dev, tmp,
> +                                       &bus->devices, bus_list) {
> +                               if (PCI_SLOT(dev->devfn) != slot->device)
> +                                       continue;
> +                               pci_trim_stale_devices(dev);

Perhaps

 list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list) {
      if (PCI_SLOT(dev->devfn) == slot->device)
                pci_trim_stale_devices(dev);
 }

--
With Best Regards,
Andy Shevchenko
