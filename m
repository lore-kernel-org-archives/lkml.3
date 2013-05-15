Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab3EORAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:00:39 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20423 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513Ab3EORAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:00:37 -0400
From: "Sumner, William" <bill.sumner@hp.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tindoh@gmail.com" <tindoh@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>
Subject: RE: [PATCH] Reset PCIe devices to stop ongoing DMA
Thread-Topic: [PATCH] Reset PCIe devices to stop ongoing DMA
Thread-Index: AQHOSvH1vNwIBbyiG0WojIErJau26ZkFWd2Q
Date: Wed, 15 May 2013 16:59:43 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A054E69390@G4W3299.americas.hpqcorp.net>
References: <1366779539-3584-1-git-send-email-indou.takao@jp.fujitsu.com>
 <51783987.2040604@redhat.com> <5178BAFB.9060100@jp.fujitsu.com>
 <51796F77.1040108@redhat.com> <5179F038.2030706@jp.fujitsu.com>
 <517A8451.7010202@redhat.com>
 <875D89B79D1D86448A583A7302C022A054E4DDF3@G9W0337.americas.hpqcorp.net>
 <5188A8B4.2080503@jp.fujitsu.com>
In-Reply-To: <5188A8B4.2080503@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for sending the 2-line addition to your patch that helps me test the suggestions in the PCIe standard.

I started with a new Linux top-of-tree as of last week, added the patch from late April, added these new lines of code, then tested on one of the platforms that showed the problem before.  

This addition seems to improve operation on my platform.  Previously the lock-up occurred immediately when the problem PCI card was reset.  With these two lines added, the patch code completed: all resets occurred, all status was restored to PCI cards, and the crash kernel began loading modules.  The kernel then stopped after loading a few modules -- around 5 or 6 modules.  This was consistent over a few tries.  Using the same kernel, eliminating only the "pci=pcie_reset_devices" from the crash kernel's command line, a dump succeeds.  I am still investigating why the crash kernel stops during module loading.

Reading other reset code in Linux: pci_reset_function() writes PCI_COMMAND_INTX_DISABLE into the command register instead of writing 0.  This clears all bits and sets the INTX_DISABLE bit.  So I tried that in the patch and the results were the same as in the paragraph above.

Two questions:
1. Since the two added lines prevent the PCIe device from initiating new bus activity including DMA IO, and also prevent the PCIe device from sending interrupts; is this not sufficient (without resetting the PCIe device) to solve the original problem of leftover ongoing DMA IO when the crash kernel resets the hardware IOMMU ?

1a. My guess is that the answer to question 1 is "No" because some PCIe card may not check the bus master flag just before each bus transaction -- its engineers having interpreted the standard differently than I do.  However, this seems like a question worth asking of the community.  


2. Linux has a set of functions to reset PCIe devices beginning at " int pci_reset_function(struct pci_dev *dev) " and calling down to "__pci_dev_reset"  which tries several different methods to reset the PCI device.  Would any of these be useful additions to the proposed patch ?  

Bill Sumner 



-----Original Message-----
From: Takao Indoh [mailto:indou.takao@jp.fujitsu.com] 
Sent: Tuesday, May 07, 2013 2:10 AM
To: Sumner, William
Cc: linux-pci@vger.kernel.org; kexec@lists.infradead.org; linux-kernel@vger.kernel.org; tindoh@gmail.com; iommu@lists.linux-foundation.org; bhelgaas@google.com; ddutile@redhat.com
Subject: Re: [PATCH] Reset PCIe devices to stop ongoing DMA

Sorry for the delayed response.

(2013/04/30 23:54), Sumner, William wrote:
> I have installed your original patch set (from last November) and tested with three platforms, each with a different IO configuration.  On the first platform crashdumps were consistently successful.  On the second and third platforms, the reset of one specific PCI device on each platform (a different device type on each platform) immediately hung the crash kernel. This was consistent across multiple tries.  Temporarily modifying the patch to skip resetting the one problem-device on each platform allowed each platform to create a dump successfully.
> 
> I am now working with our IO team to determine the exact nature of the hang and to see if the hang is unique to the specific cards or the specific platforms.
> 
> Also I am starting to look at an alternate possibility:
> 
> The PCIe spec (my copy is version 2.0) in section 6.6.2 (Function-Level Reset) describes reset use-cases for "a partitioned environment where hardware is migrated from one partition to another" and for "system software is taking down the software stack for a Function and then rebuilding that stack".
> 
> These use-cases seem very similar to transitioning into the crash kernel.  The "Implementation Note" at the end of that section describes an algorithm for "Avoiding Data Corruption From Stale Completions" which looks like it might be applicable to stopping ongoing DMA.  I am hopeful that adding some of the steps from this algorithm to one of the already proposed patches would avoid the hang that I saw on two platforms.

It seems that the algorithm you mentioned requires four steps.

1. Clear Command register
2. Wait a few milliseconds (Or polling Transactions Pending bit)
3. Do FLR
4. Wait 100 ms

My patch does not do step 1 and 2. So, I would appreciate it if you
could add the following into save_config() in my latest patch and
confirm if kernel still hangs up or not.

        subordinate = dev->subordinate;
        list_for_each_entry(child, &subordinate->devices, bus_list) {
                dev_info(&child->dev, "save state\n");
                pci_save_state(child);
+               pci_write_config_word(child, PCI_COMMAND, 0);
+               msleep(1000);
        }

Thanks,
Takao Indoh


> 
> Bill Sumner
> 
> -----Original Message-----
> From: kexec [mailto:kexec-bounces@lists.infradead.org] On Behalf Of Don Dutile
> Sent: Friday, April 26, 2013 8:43 AM
> To: Takao Indoh
> Cc: linux-pci@vger.kernel.org; kexec@lists.infradead.org; linux-kernel@vger.kernel.org; tindoh@gmail.com; iommu@lists.linux-foundation.org; bhelgaas@google.com
> Subject: Re: [PATCH] Reset PCIe devices to stop ongoing DMA
> 
> On 04/25/2013 11:10 PM, Takao Indoh wrote:
>> (2013/04/26 3:01), Don Dutile wrote:
>>> On 04/25/2013 01:11 AM, Takao Indoh wrote:
>>>> (2013/04/25 4:59), Don Dutile wrote:
>>>>> On 04/24/2013 12:58 AM, Takao Indoh wrote:
>>>>>> This patch resets PCIe devices on boot to stop ongoing DMA. When
>>>>>> "pci=pcie_reset_devices" is specified, a hot reset is triggered on each
>>>>>> PCIe root port and downstream port to reset its downstream endpoint.
>>>>>>
>>>>>> Problem:
>>>>>> This patch solves the problem that kdump can fail when intel_iommu=on is
>>>>>> specified. When intel_iommu=on is specified, many dma-remapping errors
>>>>>> occur in second kernel and it causes problems like driver error or PCI
>>>>>> SERR, at last kdump fails. This problem is caused as follows.
>>>>>> 1) Devices are working on first kernel.
>>>>>> 2) Switch to second kernel(kdump kernel). The devices are still working
>>>>>>         and its DMA continues during this switch.
>>>>>> 3) iommu is initialized during second kernel boot and ongoing DMA causes
>>>>>>         dma-remapping errors.
>>>>>>
>>>>>> Solution:
>>>>>> All DMA transactions have to be stopped before iommu is initialized. By
>>>>>> this patch devices are reset and in-flight DMA is stopped before
>>>>>> pci_iommu_init.
>>>>>>
>>>>>> To invoke hot reset on an endpoint, its upstream link need to be reset.
>>>>>> reset_pcie_devices() is called from fs_initcall_sync, and it finds root
>>>>>> port/downstream port whose child is PCIe endpoint, and then reset link
>>>>>> between them. If the endpoint is VGA device, it is skipped because the
>>>>>> monitor blacks out if VGA controller is reset.
>>>>>>
>>>>> Couple questions wrt VGA device:
>>>>> (1) Many graphics devices are multi-function, one function being VGA;
>>>>>          is the VGA always function 0, so this scan sees it first&   doesn't
>>>>>          do a reset on that PCIe link?  if the VGA is not function 0, won't
>>>>>          this logic break (will reset b/c function 0 is non-VGA graphics) ?
>>>>
>>>> VGA is not reset irrespective of its function number. The logic of this
>>>> patch is:
>>>>
>>>> for_each_pci_dev(dev) {
>>>>         if (dev is not PCIe)
>>>>            continue;
>>>>         if (dev is not root port/downstream port) ---(1)
>>>>            continue;
>>>>         list_for_each_entry(child,&dev->subordinate->devices, bus_list) {
>>>>             if (child is upstream port or bridge or VGA) ---(2)
>>>>                 continue;
>>>>         }
>>>>         do_reset_its_child(dev);
>>>> }
>>>>
>>>> Therefore VGA itself is skipped by (1), and upstream device(root port or
>>>> downstream port) of VGA is also skipped by (2).
>>>>
>>>>
>>>>> (2) I'm hearing VGA will soon not be the a required console; this logic
>>>>>          assumes it is, and why it isn't blanked.
>>>>>          Q: Should the filter be based on a device having a device-class of display ?
>>>>
>>>> I want to avoid the situation that user's monitor blacks out and user
>>>> cannot know what's going on. That's reason why I introduced the logic to
>>>> skip VGA. As far as I tested the logic based on device-class works well,
>>> sorry, I read your description, which said VGA, but your are filtering on display class,
>>> which includes non-VGA as well. So, all set ... but large, (x16) non-VGA display devices
>>> are probably one of the most aggressive DMA engines on a system.... and will grow as
>>> asymmetric processing using GPUs gets architected into a device-agnostic manner.
>>> So, this may work well for servers, which is the primary consumer/user of this feature,
>>> and they typically have built-in graphics that are generally used in simple VGA mode,
>>> so this may be sufficient for now.
>>
>> Ok, understood.
>>
>>
>>>
>>>> but I would appreciate it if there are better ways.
>>>>
>>> You probably don't want to hear it but....
>>> a) only turn off cmd-reg master enable bit
>>> b) only do reset based on a list of devices known not to
>>>       obey their cmd-reg master enable bit, and only do reset to those devices.
>>> But, given the testing you've done so far, this optional (need cmdline) feature,
>>> let's start here.
>>
>> Ok. Either way I think we need more testing.
>>
>>
>>>>>
>>>>>> Actually this is v8 patch but quite different from v7 and it's been so
>>>>>> long since previous post, so I start over again.
>>>>> Thanks for this re-start.  I need to continue reviewing the rest.
>>>>
>>>> Thank you for your review!
>>>>
>>>>>
>>>>> Q: Why not force IOMMU off when re-booting a kexec kernel to perform a crash
>>>>>         dump?  After the crash dump, the system is rebooting to previous (iommu=on) setting.
>>>>>         That logic, along w/your previous patch to disable the IOMMU if iommu=off
>>>>>         is set, would remove this (relatively slow) PCI init sequencing ?
>>>>
>>>> To force iommu off, all ongoing DMA have to be stopped before that since
>>>> they are accessing the device address, not physical address. If we disable
>>>> iommu without stopping in-flihgt DMA, devices access invalid memory area
>>>> and it causes memory corruption or PCI-SERR due to DMA error.
>>> Right, that's a 'duh' on my part.
>>> I thought 'disable iommu' == 'block all dma' and it just turns it off&
>>> let's the ongoing DMA run...
>>> Please ignore this question... sigh.
>>>
>>>>
>>>> So, whether we use iommu or not in second kernel, we have to stop DMA in
>>>> second kernel if iommu is used in first kernel.
>>>>
>>>> Thanks,
>>>> Takao Indoh
>>>>
>>>>
>>>>>
>>>>>> Previous post:
>>>>>> [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
>>>>>> https://lkml.org/lkml/2012/11/26/814
>>>>>>
>>>>>> Signed-off-by: Takao Indoh<indou.takao@jp.fujitsu.com>
>>>>>> ---
>>>>>>       Documentation/kernel-parameters.txt |    2 +
>>>>>>       drivers/pci/pci.c                   |  103 +++++++++++++++++++++++++++++++++++
>>>>>>       2 files changed, 105 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>>>>> index 4609e81..2a31ade 100644
>>>>>> --- a/Documentation/kernel-parameters.txt
>>>>>> +++ b/Documentation/kernel-parameters.txt
>>>>>> @@ -2250,6 +2250,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>>>>>                       any pair of devices, possibly at the cost of
>>>>>>                       reduced performance.  This also guarantees
>>>>>>                       that hot-added devices will work.
>>>>>> +        pcie_reset_devices    Reset PCIe endpoint on boot by hot
>>>>>> +                reset
>>>>>>               cbiosize=nn[KMG]    The fixed amount of bus space which is
>>>>>>                       reserved for the CardBus bridge's IO window.
>>>>>>                       The default value is 256 bytes.
>>>>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>>>>> index b099e00..42385c9 100644
>>>>>> --- a/drivers/pci/pci.c
>>>>>> +++ b/drivers/pci/pci.c
>>>>>> @@ -3878,6 +3878,107 @@ void __weak pci_fixup_cardbus(struct pci_bus *bus)
>>>>>>       }
>>>>>>       EXPORT_SYMBOL(pci_fixup_cardbus);
>>>>>>
>>>>>> +/*
>>>>>> + * Return true if dev is PCIe root port or downstream port whose child is PCIe
>>>>>> + * endpoint except VGA device.
>>>>>> + */
>>>>>> +static int __init need_reset(struct pci_dev *dev)
>>>>>> +{
>>>>>> +    struct pci_bus *subordinate;
>>>>>> +    struct pci_dev *child;
>>>>>> +
>>>>>> +    if (!pci_is_pcie(dev) || !dev->subordinate ||
>>>>>> +        list_empty(&dev->subordinate->devices) ||
>>>>>> +        ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT)&&
>>>>>> +         (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
>>>>>> +        return 0;
>>>>>> +
>>>>>> +    subordinate = dev->subordinate;
>>>>>> +    list_for_each_entry(child,&subordinate->devices, bus_list) {
>>>>>> +        if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
>>>>>> +            (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE) ||
>>>>>> +            ((child->class>>    16) == PCI_BASE_CLASS_DISPLAY))
>>>>>> +            /* Don't reset switch, bridge, VGA device */
>>>>>> +            return 0;
>>>>>> +    }
>>>>>> +
>>>>>> +    return 1;
>>>>>> +}
>>>>>> +
>>>>>> +static void __init save_config(struct pci_dev *dev)
>>> This should be renamed.  it implies it is saving the config of the pdev passed in,
>>> when in reality, it is saving the config of all the devices attached to this pdev.
>>> i.e., save_downstream_configs()
>>>
>>>>>> +{
>>>>>> +    struct pci_bus *subordinate;
>>>>>> +    struct pci_dev *child;
>>>>>> +
>>>>>> +    if (!need_reset(dev))
>>>>>> +        return;
>>>>>> +
>>>>>> +    subordinate = dev->subordinate;
>>>>>> +    list_for_each_entry(child,&subordinate->devices, bus_list) {
>>>>>> +        dev_info(&child->dev, "save state\n");
>>>>>> +        pci_save_state(child);
>>>>>> +    }
>>>>>> +}
>>>>>> +
>>>>>> +static void __init restore_config(struct pci_dev *dev)
>>> inverse of above: restore_downstream_configs()
>>>>>> +{
>>>>>> +    struct pci_bus *subordinate;
>>>>>> +    struct pci_dev *child;
>>>>>> +
>>>>>> +    if (!need_reset(dev))
>>>>>> +        return;
>>>>>> +
>>>>>> +    subordinate = dev->subordinate;
>>>>>> +    list_for_each_entry(child,&subordinate->devices, bus_list) {
>>>>>> +        dev_info(&child->dev, "restore state\n");
>>>>>> +        pci_restore_state(child);
>>>>>> +    }
>>>>>> +}
>>>>>> +
>>>>>> +static void __init do_device_reset(struct pci_dev *dev)
>>> do_downstream_device_reset() -- it's not resetting this pdev,
>>> but the pdev's of the devices attached to it.
>>>
>> Right, I'll change them as you said.
>>
>>
>>>>>> +{
>>>>>> +    u16 ctrl;
>>>>>> +
>>>>>> +    if (!need_reset(dev))
>>>>>> +        return;
>>>>>> +
>>>>>> +    dev_info(&dev->dev, "Reset Secondary bus\n");
>>>>>> +
>>>>>> +    /* Assert Secondary Bus Reset */
>>>>>> +    pci_read_config_word(dev, PCI_BRIDGE_CONTROL,&ctrl);
>>>>>> +    ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>>>>>> +    pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>>>>>> +
>>>>>> +    msleep(2);
>>>>>> +
>>> This works well for x86, which uses ioport registers to access
>>> these<256-offset registers, b/c the write() function can't return
>>> until the write is actually completed, but for a non-x86 system,
>>> with fully mmconf'd PCI space, a write() may still be a write&  run
>>> (sitting in CPU write-merge) buffer, so if you need a full 2ms,
>>> you ought to do another read_config() to the device, to flush the write,
>>> before starting the msleep(2) clock.
>>>
>> I didn't know that... I'll insert something like this before msleep.
>>
>> pci_read_config_word(dev, PCI_BRIDGE_CONTROL,&dummy);
>>
>> BTW, I referred aer_do_secondary_bus_reset() when I wrote this code.
>> Probably need the same fix, right?
>>
> sounds like it.
> Interested to hear from someone in non-x86-land how
> they ensure pci cfg writes aren't buffered in their cpus;
> maybe handled via special uncached regions on other arches.
> 
>>
>>>>>> +    /* De-assert Secondary Bus Reset */
>>>>>> +    ctrl&= ~PCI_BRIDGE_CTL_BUS_RESET;
>>>>>> +    pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>>>>>> +}
>>>>>> +
>>>>>> +static int __initdata pcie_reset_devices;
>>>>>> +static int __init reset_pcie_devices(void)
>>> this should be reset_pcie_endpoints() ... it's not resetting all pcie devices
>>>>>> +{
>>>>>> +    struct pci_dev *dev = NULL;
>>>>>> +
>>>>>> +    if (!pcie_reset_devices)
>>>>>> +        return 0;
>>>>>> +
>>>>>> +    for_each_pci_dev(dev)
>>>>>> +        save_config(dev);
>>>>>> +
>>>>>> +    for_each_pci_dev(dev)
>>>>>> +        do_device_reset(dev);
>>>>>> +
>>>>>> +    msleep(1000);
>>>>>> +
>>>>>> +    for_each_pci_dev(dev)
>>>>>> +        restore_config(dev);
>>>>>> +
>>> My apologies if past thread covered this sequence...
>>> Why three loops through all PCIe devices on the system?
>>> why not have the first for-each-pci-dev() loop filter devices
>>> to be reset, and save_config those pdev's,
>>> return a list of saved_pdev's;  feed that list into the do_device_reset();
>>> then mpsleep(), then restore the list.
>>> in fact, once you create a link list of pdev's to reset,
>>> just loop that list doing save, then reset; rtn the list, do msleep(),
>>> then restore the config of pdevs in the list.
>>> Otherwise, doing much more traversing than what's needed.
>>> Doing a great deal more config-saving then needed right now as well
>>> (saving all non-endpt devices that aren't reset).
>>>
>>
>> Creating list is nice idea, thanks. I'll do.
>>
>> I'll have vacation next week, so I'll post v2 patch the week after
>> next.
>>
>> Thanks,
>> Takao Indoh
>>
> Have a good vacation! Thanks for your willingness
> to respin again & make this improvement.
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
> 


