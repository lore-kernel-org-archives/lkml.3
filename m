Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3GKCdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:33:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:60552 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3GKCdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:33:37 -0400
Message-ID: <51DE1970.5060508@huawei.com>
Date: Thu, 11 Jul 2013 10:33:20 +0800
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
References: <1373356564-21668-1-git-send-email-wangyijing@huawei.com> <CAErSpo51x7Q6cFnJ-8RfmikDh3FtCWyjy9tYouH=sjkXdNPo7Q@mail.gmail.com> <51DCCE3E.9090503@huawei.com> <CAErSpo6G5JUEJu=++gAg9dkHu8Jrbv9NKALwDp4eGKosXg6cbg@mail.gmail.com>
In-Reply-To: <CAErSpo6G5JUEJu=++gAg9dkHu8Jrbv9NKALwDp4eGKosXg6cbg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If the slot support surprise hot remove, this action maybe safe. right?
> 
> If there's no device, config space accesses performed by .remove()
> will fail (reads will return -1 data or error; writes will be
> dropped).  MMIO or I/O port accesses may fail with machine checks or
> similar bad things.  But I don't see a way around that except by
> fixing drivers as we encounter issues like that.
> 
> Since you're not changing anything here, I don't think we should worry
> about it for now.

OK.

> 
>>>> remove the old card firstly, then add the new card.
>>>
>>> With your patch, I think we'll call the old driver's .remove() method
>>> on the new device.  This seems bad; see below.
>>
>> Ah, this is issue.
>> What about power off slot first, then call the old driver's remove() method
>> will not touch the new physical device. After the old driver's remove() cleanup,
>> we call pciehp_enable_slot() to power on and enable the new device.
> 
> Turning off power to the slot seems like a reasonable approach.  Then
> we can run the old .remove() method in basically the same way we would
> in case 2.

Hmmm, I will follow this method to rework this patch in next version.

> 
>>> With your patch, if we remove and reinsert the same device while
>>> suspended, we do nothing because the DSN didn't change.  Previously we
>>> called pciehp_enable_slot().  I don't know if we need to do anything
>>> here or not.
>>
>> Mainly to avoid the redundant device add, the same like the changes for case 4
> 
> I don't know whether it's redundant or not.  Obviously if we remove
> and reinsert a device, we lose *all* state that was in the device.  If
> we lose everything even if the card stayed inserted the whole time we
> were suspended, we must already deal with that and the "add" would be
> redundant.  But if the state of the card is different if it got pulled
> and reinserted, the "add" would be necessary.

This is a key issue, sorry, I'm not familiar with PM :(
In my opinion, the device driver .suspend() method will be called
regardless of system enter in suspend to RAM(S3) or suspend to Disk(S4). Driver will
save the pci/pcie/pci-x state in .suspend() method. So once device driver .resume()
method be called, the pci/pcie/pci-x state willl be restored.
Because suspend to disk will power off whole system, so I thought if the device
was removed and inserted same device(DSN) again, maybe .resume will enable this device ok
regardless of the pci config space state has been changed.

If I have any thing above understanding wrong, please correct me, thanks!

> 
>>>> 4. slot is non empty before suspend, no action during suspend.
>>>>         We should do nothing in pciehp_resume, but we call
>>>> pciehp_enable_slot(), so some uncomfortable messages show like above.
>>>> In this case, we can improve it a little by add a guard
>>>> if (!list_empty(bus->devices)).
>>>
>>> This is the common case.  Previously we called pciehp_enable_slot(),
>>> and with your patch we do nothing.  I think that seems sensible, but
>>> this part should be split into a separate patch.  That way we can keep
>>> the benefit of this change even if we trip over something with the
>>> other changes.
>>
>> OK, I will split this changes into a new patch.
> 
> Actually, without your DSN changes, I don't think we can distinguish
> this from case 3.  So I doubt it really could be split out.

I will try, but I think this is not a big deal :)

> 
> .
> 


-- 
Thanks!
Yijing

