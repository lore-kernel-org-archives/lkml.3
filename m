Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3FYRrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:47:47 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54080 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FYRrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:47:46 -0400
MIME-Version: 1.0
In-Reply-To: <1372177330-28013-4-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-4-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 25 Jun 2013 20:47:45 +0300
Message-ID: <CAHp75Vfw5WO+6+_NB1mbgma7KVo-b7pyr6XA=LM1ozg580kbrg@mail.gmail.com>
Subject: Re: [PATCH 3/6] PCI: introduce pci_trim_stale_devices()
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

> The new function stops and removes the device if it doesn't respond.
> If the device responds and it's a bus we apply the function to all
> subdevices recursively.
>
> It's useful for hotplug bus check case, when you need drop all unplugged
> devices before looking for new ones.

One comment below.

> +void pci_trim_stale_devices(struct pci_dev *dev)
> +{
> +       struct pci_bus *bus = dev->subordinate;
> +       struct pci_dev *child, *tmp;
> +       bool alive;
> +       u32 l;
> +
> +       /* check if the device responds */
> +       alive = pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &l, 0);
> +       if (!alive)
> +               pci_stop_and_remove_bus_device(dev);
> +
> +       if (alive && bus)
> +               list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
> +                       pci_trim_stale_devices(child);

It's not a tail call anyway, so, what about

   if (!pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &l, 0)) {
             pci_stop_and_remove_bus_device(dev);
   } else if (bus) {
             list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
                     pci_trim_stale_devices(child);
   }

> +}

--
With Best Regards,
Andy Shevchenko
