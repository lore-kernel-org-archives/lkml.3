Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3H1IZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:25:43 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50003 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3H1IZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:25:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX8bQsC0ezhO8ZtcS4XOuFmc50P9GeJsE3do5vd_NHycw@mail.gmail.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-28-git-send-email-yinghai@kernel.org>
	<CANVTcTZOQWLHOs5+DpopTDMpMf2dgAzjUGEv4gGd4Z2Le5TM7A@mail.gmail.com>
	<CAE9FiQX8bQsC0ezhO8ZtcS4XOuFmc50P9GeJsE3do5vd_NHycw@mail.gmail.com>
Date: Wed, 28 Aug 2013 16:25:38 +0800
Message-ID: <CANVTcTbD472CWTEM1URDE3Pf0YjMmukSYMkewZ0kFiKkKfcdEQ@mail.gmail.com>
Subject: Re: [PATCH v4 27/28] PCI, x86, ACPI: Enable ioapic hotplug support
 with acpi host bridge.
From: rui wang <ruiv.wang@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/13, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Aug 27, 2013 at 3:25 AM, rui wang <ruiv.wang@gmail.com> wrote:
>> On 8/11/13, Yinghai Lu <yinghai@kernel.org> wrote:
>>> We need to have ioapic setup before normal pci drivers.
>>> otherwise other pci driver can not setup irq.
>>>
>>> So we should not treat them as normal pci devices.
>>> Also we will need to support ioapic hotplug without pci device around.
>>>
>>> We need to call ioapic add/remove during host-bridge add/remove.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  drivers/acpi/pci_root.c  |   4 ++
>>>  drivers/pci/ioapic.c     | 147
>>> ++++++++++++++++++++++++++++++-----------------
>>>  include/linux/pci-acpi.h |   8 +++
>>>  3 files changed, 106 insertions(+), 53 deletions(-)
>>>
>>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>>> index 5917839..7577175 100644
>>> --- a/drivers/acpi/pci_root.c
>>> +++ b/drivers/acpi/pci_root.c
>>> @@ -532,6 +532,8 @@ static int acpi_pci_root_add(struct acpi_device
>>> *device,
>>>               pci_enable_bridges(root->bus);
>>>       }
>>>
>>> +     acpi_pci_ioapic_add(root);
>>> +
>>>       pci_bus_add_devices(root->bus);
>>>       return 1;
>>>
>>> @@ -546,6 +548,8 @@ static void acpi_pci_root_remove(struct acpi_device
>>> *device)
>>>
>>>       pci_stop_root_bus(root->bus);
>>>
>>> +     acpi_pci_ioapic_remove(root);
>>> +
>>>       device_set_run_wake(root->bus->bridge, false);
>>>       pci_acpi_remove_bus_pm_notifier(device);
>>>
>>> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
>>> index 7d6b157..60351b2 100644
>>> --- a/drivers/pci/ioapic.c
>>> +++ b/drivers/pci/ioapic.c
>>> @@ -22,101 +22,142 @@
>>>  #include <linux/slab.h>
>>>  #include <acpi/acpi_bus.h>
>>>
>>> -struct ioapic {
>>> -     acpi_handle     handle;
>>> +struct acpi_pci_ioapic {
>>> +     acpi_handle     root_handle;
>>>       u32             gsi_base;
>>> +     struct pci_dev *pdev;
>>> +     struct list_head list;
>>>  };
>>>
>>> -static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id
>>> *ent)
>>> +static LIST_HEAD(ioapic_list);
>>> +static DEFINE_MUTEX(ioapic_list_lock);
>>> +
>>> +static void handle_ioapic_add(acpi_handle handle, struct pci_dev
>>> **pdev,
>>> +                              u32 *pgsi_base)
>>>  {
>>> -     acpi_handle handle;
>>>       acpi_status status;
>>>       unsigned long long gsb;
>>> -     struct ioapic *ioapic;
>>> +     struct pci_dev *dev;
>>> +     u32 gsi_base;
>>>       int ret;
>>>       char *type;
>>> -     struct resource *res;
>>> +     struct resource r;
>>> +     struct resource *res = &r;
>>> +     char objname[64];
>>> +     struct acpi_buffer buffer = {sizeof(objname), objname};
>>>
>>> -     handle = DEVICE_ACPI_HANDLE(&dev->dev);
>>> -     if (!handle)
>>> -             return -EINVAL;
>>> +     *pdev = NULL;
>>> +     *pgsi_base = 0;
>>>
>>>       status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsb);
>>> -     if (ACPI_FAILURE(status))
>>> -             return -EINVAL;
>>> -
>>> -     /*
>>> -      * The previous code in acpiphp evaluated _MAT if _GSB failed, but
>>> -      * ACPI spec 4.0 sec 6.2.2 requires _GSB for hot-pluggable I/O
>>> APICs.
>>> -      */
>>> +     if (ACPI_FAILURE(status) || !gsb)
>>> +             return;
>>>
>>> -     ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
>>> -     if (!ioapic)
>>> -             return -ENOMEM;
>>> +     dev = acpi_get_pci_dev(handle);
>>> +     if (!dev)
>>> +             return;
>>>
>>> -     ioapic->handle = handle;
>>> -     ioapic->gsi_base = (u32) gsb;
>>> +     acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>>>
>>> -     if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
>>> -             type = "IOAPIC";
>>> -     else
>>> -             type = "IOxAPIC";
>>> +     gsi_base = gsb;
>>> +     type = "IOxAPIC";
>>>
>>>       ret = pci_enable_device(dev);
>>>       if (ret < 0)
>>> -             goto exit_free;
>>> +             goto exit_put;
>>>
>>>       pci_set_master(dev);
>>>
>>> +     if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
>>> +             type = "IOAPIC";
>>> +
>>>       if (pci_request_region(dev, 0, type))
>>>               goto exit_disable;
>>>
>>>       res = &dev->resource[0];
>>> -     if (acpi_register_ioapic(ioapic->handle, res->start,
>>> ioapic->gsi_base))
>>> +
>>> +     if (acpi_register_ioapic(handle, res->start, gsi_base))
>>>               goto exit_release;
>>
>> Here acpi_register_ioapic() fails for IOAPICs already described by the
>> static MADT. So they won't be added to the ioapic_list. Subsequent
>> hot-removal will also fail because they're not found by
>> acpi_pci_ioapic_remove() on the ioapic_list.
>>
>> Here's what I used to fix it:
>>
>> From 2fff3297b4c71c88d92b04ba9ad0a8931b3e99b8 Mon Sep 17 00:00:00 2001
>> From: Rui Wang <rui.y.wang@intel.com>
>> Date: Tue, 27 Aug 2013 11:23:43 -0400
>> Subject: [PATCH] Hotadd of IOAPICs described in static MADT
>>
>> For IOAPICs described in static MADT, we already called
>> __mp_register_ioapic()
>> in arch_early_irq_init(). During boot PCI root hotadd will call it again
>> and
>> will find it already registered, thus register_ioapic() won't add it to
>> the
>> ioapic_list. Subsequent hot-removal will also fail because it is not
>> found on the
>> ioapic_list.
>>
>> Signed-off-by: Rui Wang <rui.y.wang@intel.com>
>> ---
>>  arch/x86/kernel/apic/io_apic.c |    4 +++-
>>  drivers/pci/ioapic.c           |    3 ++-
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic/io_apic.c
>> b/arch/x86/kernel/apic/io_apic.c
>> index fb9bf06..15ab9f1 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -3956,8 +3956,10 @@ int __mp_register_ioapic(int id, u32 address,
>> u32 gsi_base, bool hotadd)
>>
>>         /* already registered ? */
>>         idx = __mp_find_ioapic(gsi_base);
>> -       if (idx >= 0)
>> +       if (idx >= 0) {
>> +               ret = -EEXIST;
>>                 goto out;
>> +       }
>>
>>         idx = find_first_zero_bit(ioapics_mask, MAX_IO_APICS);
>>         if (idx >= MAX_IO_APICS) {
>> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
>> index 41f7c69..83b002b 100644
>> --- a/drivers/pci/ioapic.c
>> +++ b/drivers/pci/ioapic.c
>> @@ -126,7 +126,8 @@ static void handle_ioapic_add(acpi_handle handle,
>> struct pci_dev **pdev,
>>                 }
>>         }
>>
>> -       if (acpi_register_ioapic(handle, res->start, gsi_base)) {
>> +       ret = acpi_register_ioapic(handle, res->start, gsi_base);
>> +       if (ret && ret != -EEXIST) {
>>                 if (dev)
>>                         goto exit_release;
>>                 return;
>> --
>
> ok, will put it my series.
>

That would be great. Thanks.

Rui

> Thanks
>
> Yinghai
>
