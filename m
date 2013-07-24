Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3GXGa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:30:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46135 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3GXGa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:30:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51EF7466.20703@jp.fujitsu.com>
Date: Wed, 24 Jul 2013 15:29:58 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: bhelgaas@google.com
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        ishii.hironobu@jp.fujitsu.com, ddutile@redhat.com, bill.sumner@hp.com,
        alex.williamson@redhat.com, vgoyal@redhat.com, hbabu@us.ibm.com
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com> <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com> <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com> <51B6BEDB.3000509@jp.fujitsu.com> <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com> <51B93221.2040505@jp.fujitsu.com> <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com> <51BA7BB6.1080104@jp.fujitsu.com>
In-Reply-To: <51BA7BB6.1080104@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for letting this discussion slide, I was busy on other works:-(
Anyway, the summary of previous discussion is:
- My patch adds new initcall(fs_initcall) to reset all PCIe endpoints on
  boot. This expects PCI enumeration is done before IOMMU
  initialization as follows.
    (1) PCI enumeration
    (2) fs_initcall ---> device reset
    (3) IOMMU initialization
- This works on x86, but does not work on other architecture because
  IOMMU is initialized before PCI enumeration on some architectures. So,
  device reset should be done where IOMMU is initialized instead of
  initcall.
- Or, as another idea, we can reset devices in first kernel(panic kernel)

Resetting devices in panic kernel is against kdump policy and seems not to
be good idea. So I think adding reset code into iommu initialization is
better. I'll post patches for that.

Another discussion point is how to handle buggy devices. Resetting buggy
devices makes system more unstable. One of ideas is using boot parameter
so that user can choose to reset devices or not. An existed parameter
"reset_devices" is not helpful for this purpose because it is always
necessary for kdump and user cannot get rid of it. Introducing new boot
parameter seems to be unpopular for maintainers. Any ideas?

Thanks,
Takao Indoh

(2013/06/14 11:11), Takao Indoh wrote:
> (2013/06/13 12:41), Bjorn Helgaas wrote:
>> On Wed, Jun 12, 2013 at 8:44 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
>>> (2013/06/12 13:45), Bjorn Helgaas wrote:
>>>> [+cc Vivek, Haren; sorry I didn't think to add you earlier]
>>>>
>>>> On Tue, Jun 11, 2013 at 12:08 AM, Takao Indoh
>>>> <indou.takao@jp.fujitsu.com> wrote:
>>>>> (2013/06/11 11:20), Bjorn Helgaas wrote:
>>>>
>>>>>> I'm not sure you need to reset legacy devices (or non-PCI devices)
>>>>>> yet, but the current hook isn't anchored anywhere -- it's just an
>>>>>> fs_initcall() that doesn't give the reader any clue about the
>>>>>> connection between the reset and the problem it's solving.
>>>>>>
>>>>>> If we do something like this patch, I think it needs to be done at the
>>>>>> point where we enable or disable the IOMMU.  That way, it's connected
>>>>>> to the important event, and there's a clue about how to make
>>>>>> corresponding fixes for other IOMMUs.
>>>>>
>>>>> Ok. pci_iommu_init() is appropriate place to add this hook?
>>>>
>>>> I looked at various IOMMU init places today, and it's far more
>>>> complicated and varied than I had hoped.
>>>>
>>>> This reset scheme depends on enumerating PCI devices before we
>>>> initialize the IOMMU used by those devices.  x86 works that way today,
>>>> but not all architectures do (see the sparc pci_fire_pbm_init(), for
>>>
>>> Sorry, could you tell me which part depends on architecture?
>>
>> Your patch works if PCIe devices are reset before the kdump kernel
>> enables the IOMMU.  On x86, this is possible because PCI enumeration
>> happens before the IOMMU initialization.  On sparc, the IOMMU is
>> initialized before PCI devices are enumerated, so there would still be
>> a window where ongoing DMA could cause an IOMMU error.
> 
> Ok, understood, thanks.
> 
> Hmmm, it seems to be difficult to find out method which is common to
> all architectures. So, what I can do for now is introducing reset scheme
> which is only for x86.
> 
> 1) Change this patch so that it work only on x86 platform. For example
>     call this reset code from x86_init.iommu.iommu_init() instead of
>     fs_initcall.
> 
> Or another idea is:
> 
> 2) Enumerate PCI devices in IOMMU layer. That is:
>     PCI layer
>       Just provide interface to reset given strcut pci_dev. Maybe
>       pci_reset_function() looks good for this purpose.
>     IOMMU layer
>       Determine which devices should be reset. On kernel boot, check if
>       IOMMU is already active or not, and if active, check IOMMU page
>       table and reset devices whose entry exists there.
> 
>> Of course, it might be possible to reorganize the sparc code to to the
>> IOMMU init *after* it enumerates PCI devices.  But I think that change
>> would be hard to justify.
>>
>> And I think even on x86, it would be better if we did the IOMMU init
>> before PCI enumeration -- the PCI devices depend on the IOMMU, so
>> logically the IOMMU should be initialized first so the PCI devices can
>> be associated with it as they are enumerated.
> 
> So third idea is:
> 
> 3) Do reset before PCI enumeration(arch_initcall_sync or somewhere). We
>     need to implement new code to enumerate PCI devices and reset them
>     for this purpose.
> 
> Idea 2 is not difficult to implement, but one problem is that this
> method may be dangerous. We need to scan IOMMU page table which is used
> in previous kernel, but it may be broken. Idea 3 seems to be difficult
> to implement...
> 
> 
>>
>>>> example).  And I think conceptually, the IOMMU should be enumerated
>>>> and initialized *before* the devices that use it.
>>>>
>>>> So I'm uncomfortable with that aspect of this scheme.
>>>>
>>>> It would be at least conceivable to reset the devices in the system
>>>> kernel, before the kexec.  I know we want to do as little as possible
>>>> in the crashing kernel, but it's at least a possibility, and it might
>>>> be cleaner.
>>>
>>> I bet this will be not accepted by kdump maintainer. Everything in panic
>>> kernel is unreliable.
>>
>> kdump is inherently unreliable.  The kdump kernel doesn't start from
>> an arbitrary machine state.  We don't expect it to tolerate all CPUs
>> running, for example.  Maybe it should be expected to tolerate PCI
>> devices running, either.
> 
> What I wanted to say is that any resources of first kernel are
> unreliable. Under panic situation, struct pci_dev tree may be broken, or
> pci_lock may be already hold by someone, etc. So, if we do this in first
> kernel, maybe kdump needs its own code to enumerate PCI devices and
> reset them.
> 
> Vivek?
> 
> Thanks,
> Takao Indoh
> 
> 
> 


