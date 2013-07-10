Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3GJDCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:02:24 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:14529 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3GJDCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:02:22 -0400
Message-ID: <51DCCE3E.9090503@huawei.com>
Date: Wed, 10 Jul 2013 11:00:14 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] PCI,pciehp: avoid add a device already exist during
 pciehp_resume
References: <1373356564-21668-1-git-send-email-wangyijing@huawei.com> <CAErSpo51x7Q6cFnJ-8RfmikDh3FtCWyjy9tYouH=sjkXdNPo7Q@mail.gmail.com>
In-Reply-To: <CAErSpo51x7Q6cFnJ-8RfmikDh3FtCWyjy9tYouH=sjkXdNPo7Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
   Thanks for your review and comments!

>> We can use PCIe Device Serial Number to identify the device if
>> device support DSN.
> 
> I think I like the idea of this, especially because the Microsoft PCI
> Hardware Compliance Test apparently requires DSN for hot-pluggable
> PCIe devices [1], so it should be pretty universal.
> 
> [1] http://www.techtalkz.com/microsoft-device-drivers-dtm/341362-dtm-pcihct-test-violates-pci-express-base-specification-revision-1-a.html
> 
>> currently:
>> 1. slot is empty before suspend, insert card during suspend.
>>         In this case, is safe, pciehp will add device by check adapter
>> status register in pciehp_resume.
> 
> Your patch doesn't change anything here.

Yes, I only to make some changes for case 3/4.

> 
>> 2. slot is non empty before suspend, remove card during suspend.
>>         Also be safe, pciehp will remove device by check adapter
>> status register in pciehp_resume.
> 
> Your patch doesn't change anything here.  (But I think the driver
> .remove() method will try to poke at the non-existent device; see
> below.)

I'm not sure the result of driver .remove() method to poke at the non-existent device.
If driver .remove() method cannot detect the real device, remove action will be block ?
If the slot support surprise hot remove, this action maybe safe. right?

If the slot does not support surprise hot remove, but the device was already removed,
we seem to have no other way to clean the stale data related to the old device.

Now if we check adapter status in slot and found adapter is non existent, pciehp resume
call pciehp_disable_slot() , in pciehp_disable_slot() function, we will check latch status,
I guess this case latch is open(because slot is empty), this action will abort.
But I have no platform to test it.

> 
>> 3. slot is non empty before suspend, remove card during suspend
>> and insert a new card.
>>         Now pciehp just call pciehp_enable_slot() roughly. We should
>> remove the old card firstly, then add the new card.
> 
> With your patch, I think we'll call the old driver's .remove() method
> on the new device.  This seems bad; see below.

Ah, this is issue.
What about power off slot first, then call the old driver's remove() method
will not touch the new physical device. After the old driver's remove() cleanup,
we call pciehp_enable_slot() to power on and enable the new device.

> 
> With your patch, if we remove and reinsert the same device while
> suspended, we do nothing because the DSN didn't change.  Previously we
> called pciehp_enable_slot().  I don't know if we need to do anything
> here or not.

Mainly to avoid the redundant device add, the same like the changes for case 4

> 
>> 4. slot is non empty before suspend, no action during suspend.
>>         We should do nothing in pciehp_resume, but we call
>> pciehp_enable_slot(), so some uncomfortable messages show like above.
>> In this case, we can improve it a little by add a guard
>> if (!list_empty(bus->devices)).
> 
> This is the common case.  Previously we called pciehp_enable_slot(),
> and with your patch we do nothing.  I think that seems sensible, but
> this part should be split into a separate patch.  That way we can keep
> the benefit of this change even if we trip over something with the
> other changes.

OK, I will split this changes into a new patch.

> 
>> Reported-by: Paul Bolle <pebolle@tiscali.nl>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Cc: Paul Bolle <pebolle@tiscali.nl>
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Cc: Oliver Neukum <oneukum@suse.de>
>> Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> Cc: linux-pci@vger.kernel.org
>> ---
>>  drivers/pci/hotplug/pciehp_core.c |   38 +++++++++++++++++++++++++++++++++---
>>  1 files changed, 34 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
>> index 7d72c5e..d01e093 100644
>> --- a/drivers/pci/hotplug/pciehp_core.c
>> +++ b/drivers/pci/hotplug/pciehp_core.c
>> @@ -291,6 +291,28 @@ static void pciehp_remove(struct pcie_device *dev)
>>  }
>>
>>  #ifdef CONFIG_PM
>> +
>> +/* If device support Device Serial Numner, use DSN
> 
> s/support/supports/
> s/Numner/Number/
> Use conventional comment style:
>   /*
>    * If device ...
>    */
> 

Will update, thanks.


>> + * to identify the device
>> + */
>> +static bool device_in_slot_is_changed(struct pci_bus *pbus)
>> +{
>> +       u64 old_dsn, new_dsn;
>> +       struct pci_dev *pdev;
>> +
>> +       pdev = pci_get_slot(pbus, PCI_DEVFN(0, 0));
> 
> pci_get_slot() can fail.

Will add failure return check, thanks.

> 
>> +       old_dsn = pdev->sn;
>> +
>> +       /* get func 0 device serial number */
>> +       pci_get_dsn(pdev, &new_dsn);
>> +       if (status) {
>> +               if (list_empty(&pbus->devices))
>> +                       pciehp_enable_slot(slot);
>> +               else if (device_in_slot_is_changed(pbus)) {
>> +                       pciehp_disable_slot(slot);
> 
> pciehp_disable_slot() ultimately calls the .remove() method for the
> device that has already been removed.  That method is likely to poke
> at the device, which will do something unexpected because the new
> device is likely to be completely different.

Yes, this is a really issue, so what about firstly power off the slot before call
.remove() method for the old device.

> 
> I think the call path is this:
> 
>     pciehp_resume
>       pciehp_disable_slot
>         remove_board
>           pciehp_unconfigure_device
>             pci_stop_and_remove_bus_device
>               pci_stop_bus_device
>                 pci_stop_dev
>                   device_del
>                     bus_remove_device
>                       device_release_driver
>                         __device_release_driver
>                           pci_device_remove     # pci_bus_type.remove
>                             dev->driver->remove
> 
> I think we already had this problem for case 2 (card removed while
> suspended), but at least in that case, the driver .remove() method
> doesn't have a device to poke at, so it's less likely to do something
> bad.

Agree.

> 
>> +                       pciehp_enable_slot(slot);
>> +               }
>> +       } else {
>> +               if (!list_empty(&pbus->devices))
>> +                       pciehp_disable_slot(slot);
>> +       }
>>         return 0;
>>  }
>>  #endif /* PM */
>> --
>> 1.7.1
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing

