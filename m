Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3AUGqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:46:38 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34975 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3AUGqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:46:36 -0500
MIME-Version: 1.0
In-Reply-To: <5397828.ilPjagaOIa@vostro.rjw.lan>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org>
	<1358495602-22867-12-git-send-email-yinghai@kernel.org>
	<5397828.ilPjagaOIa@vostro.rjw.lan>
Date: Sun, 20 Jan 2013 22:46:35 -0800
X-Google-Sender-Auth: bKaH8WPej1fSCWTeNa24FvN5hj8
Message-ID: <CAE9FiQWPn3YEhS40XsUckuaMJkRvd7oiiWJa+S8Lzu+ZDFjfWg@mail.gmail.com>
Subject: Re: [PATCH v9 11/11] PCI: Put pci dev to device tree as early as possible
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 3:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 17, 2013 11:53:22 PM Yinghai Lu wrote:
>> We want to put created pci device in the device tree as soon as possible.
>> - just after we find it and create pci_dev struct for it.
>> so for_pci_dev iteration will not miss them.
>>
>> But at that time, we can not load driver for them yet. Need to be after
>> pci_assign_unsigned_resources() etc to make sure all pci devices get
>> resource allocated at first.
>>
>> Move out device registering out of pci_bus_add_devices, and
>> new pci_bus_add_devices() will do the device_attach work to load pci drivers
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/bus.c   |   47 +++--------------------------------------------
>>  drivers/pci/iov.c   |    7 -------
>>  drivers/pci/probe.c |   34 +++++++++++++++++++++++++++-------
>>  3 files changed, 30 insertions(+), 58 deletions(-)
>>
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index 18c1c6d..0a55845 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -178,22 +178,9 @@ static void pci_bus_attach_device(struct pci_dev *dev)
>>   */
..
>> @@ -205,21 +192,9 @@ int pci_bus_add_device(struct pci_dev *dev)
>>   */
>>  int pci_bus_add_child(struct pci_bus *bus)
>>  {
>> -     int retval;
>> -
>> -     if (bus->bridge)
>> -             bus->dev.parent = bus->bridge;
>> -
>> -     retval = device_register(&bus->dev);
>> -     if (retval)
>> -             return retval;
>> -
>>       bus->is_added = 1;
>>
>> -     /* Create legacy_io and legacy_mem files for this bus */
>> -     pci_create_legacy_files(bus);
>> -
>> -     return retval;
>> +     return 0;
>>  }
>
> Well, what sense does this make to keep that function as is after removing
> almost all of the code from it?

ok, will remove that function.

...
>>       list_for_each_entry(dev, &bus->devices, bus_list) {
>>               BUG_ON(!dev->is_added);
>>
>>               child = dev->subordinate;
>> -             /*
>> -              * If there is an unattached subordinate bus, attach
>> -              * it and then scan for unattached PCI devices.
>> -              */
>> +
>>               if (!child)
>>                       continue;
>> -             if (list_empty(&child->node)) {
>> -                     down_write(&pci_bus_sem);
>> -                     list_add_tail(&child->node, &dev->bus->children);
>> -                     up_write(&pci_bus_sem);
>> -             }
>
> This doesn't seem to have a replacement.  Why isn't it necessary any more?
>

add that in changelog, so related changlog will be:

---
Also remove unattached child bus handling in pci_bus_add_devices().
Because that is not needed, child bus via pci_add_new_bus() is already
in parent bus children list.
---
