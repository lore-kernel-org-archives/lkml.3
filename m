Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3GKUJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:09:36 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60175 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3GKUJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <51DE8032.4040808@redhat.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
 <1373535825-49972-2-git-send-email-wangyijing@huawei.com> <51DE8032.4040808@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Jul 2013 14:09:11 -0600
Message-ID: <CAErSpo50ni41TiscZDVpg8wMFK2wgWmS1sySfNTs8X9JA7Mmkw@mail.gmail.com>
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

On Thu, Jul 11, 2013 at 3:51 AM, Don Dutile <ddutile@redhat.com> wrote:
> On 07/11/2013 05:43 AM, Yijing Wang wrote:
>>
>> Introduce PCIe Ext Capability Device Serial Number support,
>> so we can use the unique device serial number to identify
>> the physical device. During system suspend, if the PCIe
>> device was removed and inserted a new same device, after
>> system resume there is no good way to identify it, maybe
>> Device Serial Number is a good choice if device support.
>>
>> Signed-off-by: Yijing Wang<wangyijing@huawei.com>
>> ---
>>   drivers/pci/pci.c   |   27 +++++++++++++++++++++++++++
>>   drivers/pci/probe.c |    2 ++
>>   include/linux/pci.h |    3 +++
>>   3 files changed, 32 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index e37fea6..2e855b5 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -2048,6 +2048,33 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
>>   }
>>
>>   /**
>> + * pci_device_serial_number - get device serial number
>> + * @dev: the PCI device
>> + *
>> + * return the device serial number if device support,
>> + * otherwise return 0.
>> + */
>> +u64 pci_device_serial_number(struct pci_dev *dev)
>
> See comment below:
> void  pci_device_serial_number(struct pci_dev *dev)
>
>
>> +{
>> +       int pos;
>> +       u64 sn;
>> +       u32 lo, hi;
>> +
>> +       if (!pci_is_pcie(dev))
>> +               return 0;
>> +
>
> See comment below:
> if (!pci_is_pcie(dev)) {
>         dev->sn = 0;
>         return;
>
> }
>>
>> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
>> +       if (!pos)
>> +               return 0;
>> +
>> +       pci_read_config_dword(dev, pos + 4,&lo);
>> +       pci_read_config_dword(dev, pos + 8,&hi);
>> +       sn = ((u64)hi<<  32) | lo;
>
> See comment below:
>         dev->sn = ((u64)hi<<  32) | lo;
>         return;
>
>> +       return sn;
>> +}
>> +EXPORT_SYMBOL(pci_device_serial_number);
>> +
>> +/**
>>    * pci_configure_ari - enable or disable ARI forwarding
>>    * @dev: the PCI device
>>    *
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 46ada5c..c4c1a2b 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -1322,6 +1322,8 @@ static void pci_init_capabilities(struct pci_dev
>> *dev)
>>         /* Power Management */
>>         pci_pm_init(dev);
>>
>> +       dev->sn = pci_device_serial_number(dev);
>> +
>
> Finally, 'the comment below':
> I know you were following Bjorn's suggestion, which I thought
> was an improvement, but why not do above assignment in
> pci_device_serial_number() ?
> See above....

pci_device_serial_number() would then have the side-effect of saving
the result somewhere, and callers would have to know where to look.
Personally, I think it's simpler to return the serial number directly
and avoid the side-effect, but maybe this is just bike-shedding.

As long as we are bike-shedding, I'd just drop "sn" and do:

    return ((u64)hi << 32) | lo;

And of course, you need spaces before "&hi" and "&lo" in the
pci_read_config_dword() calls.
