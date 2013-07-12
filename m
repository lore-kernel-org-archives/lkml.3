Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3GLDiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 23:38:21 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37466 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab3GLDiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 23:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <51DEF6DD.1070406@redhat.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
 <1373535825-49972-2-git-send-email-wangyijing@huawei.com> <51DE8032.4040808@redhat.com>
 <CAErSpo50ni41TiscZDVpg8wMFK2wgWmS1sySfNTs8X9JA7Mmkw@mail.gmail.com> <51DEF6DD.1070406@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Jul 2013 21:37:58 -0600
Message-ID: <CAErSpo4c6xPh1otnU+-oTBGim0+K4X8RxvrPWdz7ViWqhq8e_g@mail.gmail.com>
Subject: Re: [PATCH -v2 1/3] PCI: introduce PCIe Device Serial Number
 Capability support
To: Don Dutile <ddutile@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:18 PM, Don Dutile <ddutile@redhat.com> wrote:
> On 07/11/2013 04:09 PM, Bjorn Helgaas wrote:
>>
>> On Thu, Jul 11, 2013 at 3:51 AM, Don Dutile<ddutile@redhat.com>  wrote:
>>>
>>> On 07/11/2013 05:43 AM, Yijing Wang wrote:
>>>>
>>>>
>>>> Introduce PCIe Ext Capability Device Serial Number support,
>>>> so we can use the unique device serial number to identify
>>>> the physical device. During system suspend, if the PCIe
>>>> device was removed and inserted a new same device, after
>>>> system resume there is no good way to identify it, maybe
>>>> Device Serial Number is a good choice if device support.
>>>>
>>>> Signed-off-by: Yijing Wang<wangyijing@huawei.com>
>>>> ---
>>>>    drivers/pci/pci.c   |   27 +++++++++++++++++++++++++++
>>>>    drivers/pci/probe.c |    2 ++
>>>>    include/linux/pci.h |    3 +++
>>>>    3 files changed, 32 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>>> index e37fea6..2e855b5 100644
>>>> --- a/drivers/pci/pci.c
>>>> +++ b/drivers/pci/pci.c
>>>> @@ -2048,6 +2048,33 @@ void pci_free_cap_save_buffers(struct pci_dev
>>>> *dev)
>>>>    }
>>>>
>>>>    /**
>>>> + * pci_device_serial_number - get device serial number
>>>> + * @dev: the PCI device
>>>> + *
>>>> + * return the device serial number if device support,
>>>> + * otherwise return 0.
>>>> + */
>>>> +u64 pci_device_serial_number(struct pci_dev *dev)
>>>
>>>
>>> See comment below:
>>> void  pci_device_serial_number(struct pci_dev *dev)
>>>
>>>
>>>> +{
>>>> +       int pos;
>>>> +       u64 sn;
>>>> +       u32 lo, hi;
>>>> +
>>>> +       if (!pci_is_pcie(dev))
>>>> +               return 0;
>>>> +
>>>
>>>
>>> See comment below:
>>> if (!pci_is_pcie(dev)) {
>>>          dev->sn = 0;
>>>          return;
>>>
>>> }
>>>>
>>>>
>>>> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
>>>> +       if (!pos)
>>>> +               return 0;
>>>> +
>>>> +       pci_read_config_dword(dev, pos + 4,&lo);
>>>> +       pci_read_config_dword(dev, pos + 8,&hi);
>>>> +       sn = ((u64)hi<<   32) | lo;
>>>
>>>
>>> See comment below:
>>>          dev->sn = ((u64)hi<<   32) | lo;
>>>          return;
>>>
>>>> +       return sn;
>>>> +}
>>>> +EXPORT_SYMBOL(pci_device_serial_number);
>>>> +
>>>> +/**
>>>>     * pci_configure_ari - enable or disable ARI forwarding
>>>>     * @dev: the PCI device
>>>>     *
>>>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>>>> index 46ada5c..c4c1a2b 100644
>>>> --- a/drivers/pci/probe.c
>>>> +++ b/drivers/pci/probe.c
>>>> @@ -1322,6 +1322,8 @@ static void pci_init_capabilities(struct pci_dev
>>>> *dev)
>>>>          /* Power Management */
>>>>          pci_pm_init(dev);
>>>>
>>>> +       dev->sn = pci_device_serial_number(dev);
>>>> +
>>>
>>>
>>> Finally, 'the comment below':
>>> I know you were following Bjorn's suggestion, which I thought
>>> was an improvement, but why not do above assignment in
>>> pci_device_serial_number() ?
>>> See above....
>>
>>
>> pci_device_serial_number() would then have the side-effect of saving
>> the result somewhere, and callers would have to know where to look.
>
> Ah, like so many other features of a PCI device?  -- what are all those
> flags/status bits in pdev for ??? ;-)
>
>
>> Personally, I think it's simpler to return the serial number directly
>> and avoid the side-effect, but maybe this is just bike-shedding.
>>
> What struck me about rtning a value is in pci_init_capabilities(),
> it was the only function with a rtn value that had to be put into a pci_dev
> struct element,
> while all the others stored their related capabilities in the pdev, or other
> struct
> related to it.

Good point, BTW.  I hadn't thought about it from that angle.

> So, maybe there should be a "pci_device_serial_number_init()" function
> which does the storage in the pdev struct, and another (wrapper,
> dare I shoot myself, inline)  that is "pci_device_serial_number()" that
> returns
> the value of the pdev's sn element, if another module or other core
> component
> want to get it. .... and do that in a future patch... :-/

Of course, for Yijing's use, it's important that we're able to get the
*non-cached* serial number, because the cached one belongs to the old,
pre-suspend device, and we want to look at the post-suspend device to
see if it's the same.

Sigh.  I dunno, I'll have to finish sorting through this in a week or
so...  (I'll be on vacation for the next few days.)

Bjorn
