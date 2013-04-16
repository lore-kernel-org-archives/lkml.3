Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935570Ab3DPD4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 23:56:01 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52431 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935382Ab3DPDz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 23:55:59 -0400
MIME-Version: 1.0
In-Reply-To: <516CAE35.7090204@huawei.com>
References: <1364808128-12792-1-git-send-email-wangyijing@huawei.com>
	<516CAE35.7090204@huawei.com>
Date: Mon, 15 Apr 2013 20:55:58 -0700
X-Google-Sender-Auth: M3k1G4PnGB8tTIz4gcbGq_Pog9g
Message-ID: <CAE9FiQUACgSPffKQrKvb3zbrm-pg3gxkWxahNFFHofkW33sHwA@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI,acpiphp: use generic pci_hp_add_bridge()
From: Yinghai Lu <yinghai@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On 2013/4/1 17:22, Yijing Wang wrote:
>> Use pci_hp_add_bridge() like most other hotplug drivers
>> rather than call pci_scan_bridge() directly.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  drivers/pci/hotplug/acpiphp_glue.c |   24 ++++++++++--------------
>>  1 files changed, 10 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
>> index 270fdba..7d7ed3f 100644
>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>> @@ -811,7 +811,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>>       struct pci_bus *bus = slot->bridge->pci_bus;
>>       struct acpiphp_func *func;
>>       int retval = 0;
>> -     int num, max, pass;
>> +     int num;
>>       acpi_status status;
>>
>>       if (slot->flags & SLOT_ENABLED)
>> @@ -827,22 +827,18 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>>               goto err_exit;
>>       }
>>
>> -     max = acpiphp_max_busnr(bus);
>> -     for (pass = 0; pass < 2; pass++) {
>> -             list_for_each_entry(dev, &bus->devices, bus_list) {
>> -                     if (PCI_SLOT(dev->devfn) != slot->device)
>> +     list_for_each_entry(dev, &bus->devices, bus_list) {
>> +             if (PCI_SLOT(dev->devfn) != slot->device)
>>                               continue;
>> -                     if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
>> -                         dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
>> -                             max = pci_scan_bridge(bus, dev, max, pass);
>> -                             if (pass && dev->subordinate) {
>> -                                     check_hotplug_bridge(slot, dev);
>> -                                     pci_bus_size_bridges(dev->subordinate);
>> -                             }
>> -                     }
>> +             if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
>> +                             (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
>> +                     pci_hp_add_bridge(dev);
>> +             if (dev->subordinate) {
>> +                     check_hotplug_bridge(slot, dev);
>> +                     pci_bus_size_bridges(dev->subordinate);
>>               }
>>       }

On Mon, Apr 15, 2013 at 6:49 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> Hi Yinghai,
>    Any comments about this patch? I searched the code history and found
> you introduced pci_hp_add_bridge() function at commit a8e4b9c10. In your
> patchset use pci_hp_add_bridge() for all pci hotplug drivers except acpiphp.
> So I use pci_hp_add_bridge() in acpiphp instead of using pci_scan_bridge()
> directly. I would appreciate if you can give some suggestions.

There is one problem in your patch.
max start value get change. before your patch max is the maximum value
of bus all children...
   now it is change bus  start value.

looks like old code try to handle the case that we already some
children on that bus.

Last time i did not change it, because i think it only is ready after
busn_res alloc patchset
is merged.

in pci-mini summit of last year, Bjorn asked Linus about that
patchset, and Linus said it is
risky and it is not worthy to merge it .

so assume we should hold your patch as it could cause some regression.

Thanks

Yinghai
