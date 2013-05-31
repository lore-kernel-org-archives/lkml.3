Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3EaAyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:54:33 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61945 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3EaAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5o3KvkXnLsOuFZsP0M3Jq1VL9yweXgEusAu2=NmqjLiA@mail.gmail.com>
References: <1369892734-26244-1-git-send-email-xudong.hao@intel.com>
	<CAE9FiQUCOJ5FFwRWpVy59RqEwGC2KMNXvKe5HUAKLSES5fAR+Q@mail.gmail.com>
	<CAE9FiQWfSW7yT4cZrDoh==H=v_qmvR=9WF54jggSKGq8S_xqug@mail.gmail.com>
	<CAErSpo5o3KvkXnLsOuFZsP0M3Jq1VL9yweXgEusAu2=NmqjLiA@mail.gmail.com>
Date: Thu, 30 May 2013 17:54:24 -0700
X-Google-Sender-Auth: oNv-rnr1aDoga5lnvo4N2wDQBPI
Message-ID: <CAE9FiQXERyJ-rw8OX1X1XJC_9OMtoYxCCbZUR6N27Bp=tnqnrA@mail.gmail.com>
Subject: Re: [PATCH] PCI: set correct value for iov device before device
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xudong Hao <xudong.hao@intel.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 4:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, May 30, 2013 at 2:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, May 29, 2013 at 11:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Wed, May 29, 2013 at 10:45 PM, Xudong Hao <xudong.hao@intel.com> wrote:
>>>> Since device registering is put into pci_device_add(), it must set value of
>>>> Virtual Function device's member before the pci_dev is put to device tree. Or
>>>> some relevant subsystem of driver model such as xen will report a incorrect
>>>> IOV device to Xen hypervior.
>>>>
>>>> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
>>>> ---
>>>>  drivers/pci/iov.c | 6 +++---
>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>>>> index c93071d..43d3de9 100644
>>>> --- a/drivers/pci/iov.c
>>>> +++ b/drivers/pci/iov.c
>>>> @@ -110,12 +110,12 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
>>>>         if (reset)
>>>>                 __pci_reset_function(virtfn);
>>>>
>>>> -       pci_device_add(virtfn, virtfn->bus);
>>>> -       mutex_unlock(&iov->dev->sriov->lock);
>>>> -
>>>>         virtfn->physfn = pci_dev_get(dev);
>>>>         virtfn->is_virtfn = 1;
>>>>
>>>> +       pci_device_add(virtfn, virtfn->bus);
>>>> +       mutex_unlock(&iov->dev->sriov->lock);
>>>> +
>>>>         rc = pci_bus_add_device(virtfn);
>>>>         sprintf(buf, "virtfn%u", id);
>>>>         rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
>>>
>>> I have similar patch at
>>> https://patchwork.kernel.org/patch/2562551/
>>>    [5/7] PCI, ACPI: Don't glue ACPI dev with pci VFs
>>>
>>> and Jiang has another one
>>> https://patchwork.kernel.org/patch/2613481/
>>>    [v3,part1,10/10] PCI, IOV: hide remove and rescan sysfs interfaces
>>> for SR-IOV virtual functions
>>
>> Bjorn,
>>
>> I double check this one, we should split the patch from me or Jiang.
>
> I don't know what the sentence above means.

I mean half of patch
https://patchwork.kernel.org/patch/2562551/
or half of patch
https://patchwork.kernel.org/patch/2613481/

just like what Xudong extracted.

>
>> and the one about set virtfn=1 should be -stable material.
>
> I assume you mean that Jiang's "[v3,part1,10/10] PCI, IOV: hide remove
> and rescan sysfs interfaces for SR-IOV virtual functions" patch does
> not need to be in v3.10, but it should be marked for -stable.

no half of it, move set virtfn=1 two lines forward.

>
> How far back should it go?  v3.9+?

yes. v3.9+

>
>> That will address another problem that is caused by
>> moving device_add from pci_bus_add_device to pci_device_add.
>
> I assume you're talking about a problem caused by 4f535093 ("PCI: Put
> pci_dev in device tree as early as possible").  That commit appeared
> in v3.9.

yes.

>
> If we're asking to add the "hide remove and rescan sysfs interfaces"
> patch to the v3.9 stable series, we should have a description of
> exactly what problem it fixes, and ideally, a bugzilla for it.  Can
> you provide that?

No. that is not what i mean.

That problem have been there when sriov support was added.

>
> That patch appears to be the only one in the [v3,part1,0/10] series
> that actually directly fixes an issue, so it would be nice to have
> more specifics in that changelog to begin with.  The other patches in
> that series appear to to be cleanups and preparation for the real
> fixes that will come later.

yes. even should be separated from that patchset.

Yinghai
