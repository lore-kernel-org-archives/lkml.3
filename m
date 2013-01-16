Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3APClY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:41:24 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46349 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab3APClU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:41:20 -0500
MIME-Version: 1.0
In-Reply-To: <50F6108B.6070204@huawei.com>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<1357944049-29620-23-git-send-email-yinghai@kernel.org>
	<50F6108B.6070204@huawei.com>
Date: Tue, 15 Jan 2013 18:41:18 -0800
X-Google-Sender-Auth: R8sA2XCe1ZuxtwkPacovbyxiyGQ
Message-ID: <CAE9FiQVg5xJka9V_Aim4yzmC3PL9cx8wReV12-nPacPJXff5ZA@mail.gmail.com>
Subject: Re: [PATCH v8 22/22] PCI: move device_add out of pci_bus_add_device()
From: Yinghai Lu <yinghai@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 6:29 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> On 2013/1/12 6:40, Yinghai Lu wrote:
>> Move out device registering out of pci_bus_add_devices, so we could
>> put new created pci devices in device tree early.
>>
>> new pci_bus_add_devices will do the device_attach work to load pci drivers
>> instead.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/bus.c   |   47 +++--------------------------------------------
>>  drivers/pci/iov.c   |    7 -------
>>  drivers/pci/probe.c |   34 +++++++++++++++++++++++++++-------
>>  3 files changed, 30 insertions(+), 58 deletions(-)
>>
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index 1f5916a..0a55845 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -178,22 +178,9 @@ static void pci_bus_attach_device(struct pci_dev *dev)
>>   */
>>  int pci_bus_add_device(struct pci_dev *dev)
>>  {
>> -     int retval;
>> -
>> -     pci_fixup_device(pci_fixup_final, dev);
>> -
>> -     retval = pcibios_add_device(dev);
>> -     if (retval)
>> -             return retval;
>> -
>> -     retval = device_add(&dev->dev);
>> -     if (retval)
>> -             return retval;
>> -
>>       pci_bus_attach_device(dev);
>>       dev->is_added = 1;
>> -     pci_proc_attach_device(dev);
>> -     pci_create_sysfs_dev_files(dev);
>> +
>>       return 0;
>>  }
>
>
> Hi Yinghai,
>    Should change pci_bus_add_device() function to void return now? So some unnecessary ret check can remove.
>

yeah, maybe later. this patch is already some kind of big now.

also there is outside caller...

drivers/edac/i82875p_edac.c:            err = pci_bus_add_device(dev);
drivers/platform/x86/asus-wmi.c:                                if
(pci_bus_add_device(dev))
drivers/platform/x86/eeepc-laptop.c:                            if
(pci_bus_add_device(dev))

so let change that later.

Thanks

Yinghai
