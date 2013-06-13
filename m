Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3FMDlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:41:53 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36054 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3FMDlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <51B93221.2040505@jp.fujitsu.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
 <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
 <51B6BEDB.3000509@jp.fujitsu.com> <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
 <51B93221.2040505@jp.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Jun 2013 21:41:30 -0600
Message-ID: <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        kexec@lists.infradead.org, ishii.hironobu@jp.fujitsu.com,
        Don Dutile <ddutile@redhat.com>, bill.sumner@hp.com,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, hbabu@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 8:44 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> (2013/06/12 13:45), Bjorn Helgaas wrote:
>> [+cc Vivek, Haren; sorry I didn't think to add you earlier]
>>
>> On Tue, Jun 11, 2013 at 12:08 AM, Takao Indoh
>> <indou.takao@jp.fujitsu.com> wrote:
>>> (2013/06/11 11:20), Bjorn Helgaas wrote:
>>
>>>> I'm not sure you need to reset legacy devices (or non-PCI devices)
>>>> yet, but the current hook isn't anchored anywhere -- it's just an
>>>> fs_initcall() that doesn't give the reader any clue about the
>>>> connection between the reset and the problem it's solving.
>>>>
>>>> If we do something like this patch, I think it needs to be done at the
>>>> point where we enable or disable the IOMMU.  That way, it's connected
>>>> to the important event, and there's a clue about how to make
>>>> corresponding fixes for other IOMMUs.
>>>
>>> Ok. pci_iommu_init() is appropriate place to add this hook?
>>
>> I looked at various IOMMU init places today, and it's far more
>> complicated and varied than I had hoped.
>>
>> This reset scheme depends on enumerating PCI devices before we
>> initialize the IOMMU used by those devices.  x86 works that way today,
>> but not all architectures do (see the sparc pci_fire_pbm_init(), for
>
> Sorry, could you tell me which part depends on architecture?

Your patch works if PCIe devices are reset before the kdump kernel
enables the IOMMU.  On x86, this is possible because PCI enumeration
happens before the IOMMU initialization.  On sparc, the IOMMU is
initialized before PCI devices are enumerated, so there would still be
a window where ongoing DMA could cause an IOMMU error.

Of course, it might be possible to reorganize the sparc code to to the
IOMMU init *after* it enumerates PCI devices.  But I think that change
would be hard to justify.

And I think even on x86, it would be better if we did the IOMMU init
before PCI enumeration -- the PCI devices depend on the IOMMU, so
logically the IOMMU should be initialized first so the PCI devices can
be associated with it as they are enumerated.

>> example).  And I think conceptually, the IOMMU should be enumerated
>> and initialized *before* the devices that use it.
>>
>> So I'm uncomfortable with that aspect of this scheme.
>>
>> It would be at least conceivable to reset the devices in the system
>> kernel, before the kexec.  I know we want to do as little as possible
>> in the crashing kernel, but it's at least a possibility, and it might
>> be cleaner.
>
> I bet this will be not accepted by kdump maintainer. Everything in panic
> kernel is unreliable.

kdump is inherently unreliable.  The kdump kernel doesn't start from
an arbitrary machine state.  We don't expect it to tolerate all CPUs
running, for example.  Maybe it should be expected to tolerate PCI
devices running, either.

Bjorn
