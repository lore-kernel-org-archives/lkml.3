Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3GJU1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:27:53 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35725 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3GJU1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <51DCCE3E.9090503@huawei.com>
References: <1373356564-21668-1-git-send-email-wangyijing@huawei.com>
 <CAErSpo51x7Q6cFnJ-8RfmikDh3FtCWyjy9tYouH=sjkXdNPo7Q@mail.gmail.com> <51DCCE3E.9090503@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Jul 2013 14:27:27 -0600
Message-ID: <CAErSpo6G5JUEJu=++gAg9dkHu8Jrbv9NKALwDp4eGKosXg6cbg@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI,pciehp: avoid add a device already exist during pciehp_resume
To: Yijing Wang <wangyijing@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 9:00 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> Hi Bjorn,
>    Thanks for your review and comments!
>
>>> We can use PCIe Device Serial Number to identify the device if
>>> device support DSN.
>>
>> I think I like the idea of this, especially because the Microsoft PCI
>> Hardware Compliance Test apparently requires DSN for hot-pluggable
>> PCIe devices [1], so it should be pretty universal.
>>
>> [1] http://www.techtalkz.com/microsoft-device-drivers-dtm/341362-dtm-pcihct-test-violates-pci-express-base-specification-revision-1-a.html
>>
>>> currently:
>>> 1. slot is empty before suspend, insert card during suspend.
>>>         In this case, is safe, pciehp will add device by check adapter
>>> status register in pciehp_resume.
>>
>> Your patch doesn't change anything here.
>
> Yes, I only to make some changes for case 3/4.
>
>>
>>> 2. slot is non empty before suspend, remove card during suspend.
>>>         Also be safe, pciehp will remove device by check adapter
>>> status register in pciehp_resume.
>>
>> Your patch doesn't change anything here.  (But I think the driver
>> .remove() method will try to poke at the non-existent device; see
>> below.)
>
> I'm not sure the result of driver .remove() method to poke at the non-existent device.
> If driver .remove() method cannot detect the real device, remove action will be block ?
> If the slot support surprise hot remove, this action maybe safe. right?

If there's no device, config space accesses performed by .remove()
will fail (reads will return -1 data or error; writes will be
dropped).  MMIO or I/O port accesses may fail with machine checks or
similar bad things.  But I don't see a way around that except by
fixing drivers as we encounter issues like that.

Since you're not changing anything here, I don't think we should worry
about it for now.

> If the slot does not support surprise hot remove, but the device was already removed,
> we seem to have no other way to clean the stale data related to the old device.
>
> Now if we check adapter status in slot and found adapter is non existent, pciehp resume
> call pciehp_disable_slot() , in pciehp_disable_slot() function, we will check latch status,
> I guess this case latch is open(because slot is empty), this action will abort.
> But I have no platform to test it.
>
>>
>>> 3. slot is non empty before suspend, remove card during suspend
>>> and insert a new card.
>>>         Now pciehp just call pciehp_enable_slot() roughly. We should
>>> remove the old card firstly, then add the new card.
>>
>> With your patch, I think we'll call the old driver's .remove() method
>> on the new device.  This seems bad; see below.
>
> Ah, this is issue.
> What about power off slot first, then call the old driver's remove() method
> will not touch the new physical device. After the old driver's remove() cleanup,
> we call pciehp_enable_slot() to power on and enable the new device.

Turning off power to the slot seems like a reasonable approach.  Then
we can run the old .remove() method in basically the same way we would
in case 2.

>> With your patch, if we remove and reinsert the same device while
>> suspended, we do nothing because the DSN didn't change.  Previously we
>> called pciehp_enable_slot().  I don't know if we need to do anything
>> here or not.
>
> Mainly to avoid the redundant device add, the same like the changes for case 4

I don't know whether it's redundant or not.  Obviously if we remove
and reinsert a device, we lose *all* state that was in the device.  If
we lose everything even if the card stayed inserted the whole time we
were suspended, we must already deal with that and the "add" would be
redundant.  But if the state of the card is different if it got pulled
and reinserted, the "add" would be necessary.

>>> 4. slot is non empty before suspend, no action during suspend.
>>>         We should do nothing in pciehp_resume, but we call
>>> pciehp_enable_slot(), so some uncomfortable messages show like above.
>>> In this case, we can improve it a little by add a guard
>>> if (!list_empty(bus->devices)).
>>
>> This is the common case.  Previously we called pciehp_enable_slot(),
>> and with your patch we do nothing.  I think that seems sensible, but
>> this part should be split into a separate patch.  That way we can keep
>> the benefit of this change even if we trip over something with the
>> other changes.
>
> OK, I will split this changes into a new patch.

Actually, without your DSN changes, I don't think we can distinguish
this from case 3.  So I doubt it really could be split out.
