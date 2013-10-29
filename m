Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3J2Day (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:30:54 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41177 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab3J2Dat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:30:49 -0400
MIME-Version: 1.0
In-Reply-To: <20131016202123.GA17866@google.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Oct 2013 21:30:28 -0600
Message-ID: <CAErSpo6g5vR0NMs18YZBz+6RGZd0zNeDu_=1Pk4c5a+OqHfS1g@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 2:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Oct 15, 2013 at 03:44:52AM +0100, Matthew Garrett wrote:
>> On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
>> > [+cc Rafael, Mika, Kirill, linux-pci]
>> >
>> > On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever
>> > <andreas.noever@gmail.com> wrote:
>> > > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
>> > > crashes a few seconds later. Using
>> > > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
>> > > to remove a bridge two levels above the device triggers the fault immediately:
>> >
>> > There have been significant changes in acpiphp related to Thunderbolt
>> > since v3.11.
>>
>> Apple don't expose Thunderbolt via ACPI, so it appears as native PCIe.
>> I'd be surprised if acpiphp makes a difference here.
>
> Yeah, you're right; I wasn't paying attention.
>
> We save a pci_dev pointer in the pci_pme_list, which of course has a
> longer lifetime than the pci_dev itself, but we don't acquire a reference
> on it, so I suspect the pci_dev got released before we got around to
> doing the pci_pme_list_scan().
>
> Andreas, can you try the patch below?  It's against v3.12-rc2, but it
> should apply to v3.11, too.
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index ad7fc72..8b0a2f3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1580,6 +1580,7 @@ static void pci_pme_list_scan(struct work_struct *work)
>                                 pci_pme_wakeup(pme_dev->dev, NULL);
>                         } else {
>                                 list_del(&pme_dev->list);
> +                               pci_dev_put(pme_dev->dev);
>                                 kfree(pme_dev);
>                         }
>                 }
> @@ -1640,7 +1641,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
>                                           GFP_KERNEL);
>                         if (!pme_dev)
>                                 goto out;
> -                       pme_dev->dev = dev;
> +                       pme_dev->dev = pci_dev_get(dev);
>                         mutex_lock(&pci_pme_list_mutex);
>                         list_add(&pme_dev->list, &pci_pme_list);
>                         if (list_is_singular(&pci_pme_list))
> @@ -1652,6 +1653,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
>                         list_for_each_entry(pme_dev, &pci_pme_list, list) {
>                                 if (pme_dev->dev == dev) {
>                                         list_del(&pme_dev->list);
> +                                       pci_dev_put(pme_dev->dev);
>                                         kfree(pme_dev);
>                                         break;
>                                 }

The patch above covered up the problem, but is incorrect.  The topology is:

  08:00.0 PCI bridge to [bus 09-0a] Thunderbolt Upstream Port
  09:00.0 PCI bridge to [bus 0a]    Thunderbolt Downstream Port
  0a:00.0 tg3 NIC

and the sequence leading to the crash is (edited for brevity):

  remove_store(08:00.0)
    pci_stop_and_remove_bus_device(08:00.0)     # Upstream Port
      pci_stop_bus_device(08:00.0)
        pci_stop_bus_device(09:00.0)            # Downstream Port
          pci_stop_bus_device(0a:00.0)          # tg3 device
            pci_stop_dev(0a:00.0)
              pci_pme_active(0a:00.0, false)    # remove from pci_pme_list
              device_del(0a:00.0)
                device_release_driver
                  tg3_remove_one
                    unregister_netdev
                      dev->netdev_ops->ndo_stop # tg3_close
                      tg3_close
                        pci_wake_from_d3
                          pci_pme_active(dev, true)     # add to pci_pme_list
      pci_remove_bus_device(08:00.0)
        pci_remove_bus_device(09:00.0)
          pci_remove_bus_device(0a:00.0)
            pci_destroy_dev(0a:00.0)
              put_device(0a:00.0)               # drop last tg3
pci_dev reference
              ...
              pci_release_dev                   # pci_dev release function
                kfree(0a:00.0)
  ...
  pci_pme_list_scan
    0a:00.0 still on list => use-after-free

The patch above avoids the crash by acquiring a reference when adding
to pci_pme_list, so when pci_destroy_dev() drops the reference, it's
not the *last* reference, so the pci_dev is not released.

The problem is that the reference acquired when we add to pci_pme_list
will *never* be dropped, so we leaked the pci_dev.

Bjorn
