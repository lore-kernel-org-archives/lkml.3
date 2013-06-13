Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab3FMTIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:08:46 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46598 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab3FMTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <9686208.vxkaqkMmr5@vostro.rjw.lan>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
	<9686208.vxkaqkMmr5@vostro.rjw.lan>
Date: Thu, 13 Jun 2013 12:08:42 -0700
X-Google-Sender-Auth: LO0iH6iUZdXMpbX5qlzhWGIa1cI
Message-ID: <CAE9FiQVOvA8HB6QNBO5XxGGyO0bsfnHA6e-3yYFC0nXesKfkUg@mail.gmail.com>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 12:02 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, June 13, 2013 11:42:16 AM Yinghai Lu wrote:
>> On Thu, Jun 13, 2013 at 9:32 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
>> > Alexander E. Patrakov <patrakov@gmail.com> reports two bugs related to
>> > dock station support on Sony VAIO VPCZ23A4R. Actually there are at least
>> > four bugs related to Sony VAIO VPCZ23A4R dock support.
>> > 1) can't correctly detect hotplug slot for dock state
>> > 2) resource leak on undocking
>> > 3) resource allocation failure for dock devices
>> > 4) one bug in intel_snd_hda driver
>> >
>> > The first patch fixes issue 1, and the second patch fixes issue 2.
>> > These two patches, if accepted, should be material for stable branches
>> > too.
>> > Patch 3-9 are code improvement for ACPI and dock driver.
>> >
>> > I have found the root cause for issue three, but still working on
>> > solutions, and seems can't be solve in short time. So please help
>> > to review and test patches for issue 1) and 2) first.
>>
>> the 3) is about pci resource allocation?
>> because pcibios_add_bus is called too early?
>>
>> If that is case, we should have something like attached patch for it.
>
> I'm including the patch below to make it easier to comment.
>
>> With that, we will not need to worry about _OSC set for 3.10 etc.
>
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index b1ff02a..68ed5d8 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -186,6 +186,14 @@ int pci_bus_add_device(struct pci_dev *dev)
>>       return 0;
>>  }
>>
>> +void __weak pcibios_add_bus(struct pci_bus *bus)
>> +{
>> +}
>> +
>> +void __weak pcibios_remove_bus(struct pci_bus *bus)
>> +{
>> +}
>> +
>>  /**
>>   * pci_bus_add_devices - start driver for PCI devices
>>   * @bus: bus to check for new devices
>> @@ -198,6 +206,11 @@ void pci_bus_add_devices(const struct pci_bus *bus)
>>       struct pci_bus *child;
>>       int retval;
>>
>> +     if (bus->is_added == 1) {
>> +             pcibios_add_bus(bus);
>> +             bus->is_added++;
>> +     }
>
> Do we need that in all of the places pci_bus_add_devices() is called?

Yes.

>
> It looks like pci_scan_child_bus() might be a better place for adding this,
> or am I overlooking something?

acpiphp and acpi_pci_slot used to get attached when pci devices
get enumerated and pci resources get assigned unallocated...

they some kind of pci drivers to pci bus  (comparing with real pci diver to
pci devices).

in dock case, could be, we just got bus, and do not scan pci devices under it.
then we try to scan dock pci devices too early...

>
> [Hint: the bus->is_added++ hack is <explicit content> ugly.]

Yeah,  if we could move pcibios_fixup_bus to right place, we can move
bus->is_added setting to same place like we set pci_dev->is_added.

Yinghai
