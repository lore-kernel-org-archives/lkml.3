Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaJTCGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 22:06:19 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:31523 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaJTCGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 22:06:18 -0400
X-Greylist: delayed 1154 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2014 22:06:18 EDT
Message-ID: <54446E09.30908@hp.com>
Date: Mon, 20 Oct 2014 10:06:01 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gavin Shan <gwshan@linux.vnet.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        indou.takao@jp.fujitsu.com, kexec@lists.infradead.org,
        linda.knippers@hp.com, Randy Wright <rwright@hp.com>
Subject: Re: [PATCH 1/1] pci: reset all pci endpoints to stop on going dma
References: <1413537207-16514-1-git-send-email-zhen-hual@hp.com> <87siin58tw.fsf@x220.int.ebiederm.org> <20141019232008.GA20854@shangw> <54446986.3050603@hp.com>
In-Reply-To: <54446986.3050603@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 09:46 AM, Li, ZhenHua wrote:
>
> On 10/20/2014 07:20 AM, Gavin Shan wrote:
>> On Fri, Oct 17, 2014 at 02:44:43AM -0700, Eric W. Biederman wrote:
>>> "Li, Zhen-Hua" <zhen-hual@hp.com> writes:
>>>
>>>> This is an update of the patch
>>>>     https://lkml.org/lkml/2014/10/10/37
>>>>
>>>> This patch is doing the reset works before the kdump kernel boots.
>>>
>>> If I have said it once I have said it a thousand times.
>>>
>>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>
>>> It is absolutely inappropriate to do this in the kernel that has
>>> crashed.
>>>
>>> Either reserve a chunk of the iommu for use by the crash dump kernel,
>>> or figure out how to do this during boot up.
>>>
>>> But this is absolutely and totally inappropriate to do in crash_kexec.
>>> The failure modes are all wrong.  It will impact the reliability of our
>>> crash dumps.
>>>
>>> If an the code for a linux architecture is not structured in such a way
>>> as to make it easy or straight forward to do this my sympathies you are
>>> going to have do fix that linux port to be able to do things during
>>> boot.
>>>
>>> But things called from crash_kexec should be absolute necessities and I
>>> do not see this as coming anywhere close to being something that is
>>> impossible to do in the target kernel.
>>>
>>
>> Zhenhua, Intrestingly, PPC has mechanism to reset the root port for
>> kdump case
>> in order to drop pending DMA traffic. Maybe you can implement similar
>> thing.
>> However, this kind of reset would be platform/board specific and needs
>> support
>> from underly firmware. More details could be found from arch/powerpc/
>> platforms/powernv/pci-ioda.c
>>
>>          if (is_kdump_kernel()) {
>>                  pr_info("  Issue PHB reset ...\n");
>>                  ioda_eeh_phb_reset(hose, EEH_RESET_FUNDAMENTAL);
>>                  ioda_eeh_phb_reset(hose, OPAL_DEASSERT_RESET);
>>          }
>>
>> Please check if it's the thing you're looking for. I didn't understand
>> your
>> requirements 100%
>>
>> Thanks,
>> Gavin
> Gavin,
> I was trying to fix a DMAR fault for iommu. On X86 platform, iommu is
> initialized after pci , while on powerpc iommu is before pci.  So I
> tried to do the operation in the first kernel, and this can work on all
> platforms.
>
Sorry I made mistake. it should be sparc, not powerpc.


> But according to Eric's mail, it is inappropriate doing this in
> crash_kexec. So I have to figure out how to do this in the kdump kernel.
>
> As it is clear the powerpc has already do the resetting during booting,
> so I only need to implement a similar mechanism on X86 system.
>
> Thanks
> Zhenhua
>>
>>> Eric
>>>
>>>
>>>> On a Linux system with iommu supported and many PCI devices on it,
>>>> when kernel crashed and the kdump kernel boots with intel_iommu=on,
>>>> there may be some unexpected DMA requests on this adapter, which will
>>>> cause DMA Remapping faults like:
>>>>      dmar: DRHD: handling fault status reg 102
>>>>      dmar: DMAR:[DMA Read] Request device [41:00.0] fault addr fff81000
>>>>      DMAR:[fault reason 01] Present bit in root entry is clear
>>>>
>>>> This bug may happen on *any* PCI device.
>>>> Analysis for this bug:
>>>>
>>>> The present bit is set in this function:
>>>>
>>>> static struct context_entry * device_to_context_entry(
>>>>                  struct intel_iommu *iommu, u8 bus, u8 devfn)
>>>> {
>>>>      ......
>>>>                  set_root_present(root);
>>>>      ......
>>>> }
>>>>
>>>> Calling tree:
>>>>      device driver
>>>>          intel_alloc_coherent
>>>>              __intel_map_single
>>>>                  domain_context_mapping
>>>>                      domain_context_mapping_one
>>>>                          device_to_context_entry
>>>>
>>>> This means, the present bit in root entry will not be set until the
>>>> device
>>>> driver is loaded.
>>>>
>>>> But in the kdump kernel, hardware devices are not aware that control
>>>> has
>>>> transferred to the second kernel, and those drivers must initialize
>>>> again.
>>>> Consequently there may be unexpected DMA requests from devices activity
>>>> initiated in the first kernel leading to the DMA Remapping errors in
>>>> the
>>>> second kernel.
>>>>
>>>> To fix this DMAR fault, we need to reset the bus that this device
>>>> on. Reset
>>>> the device itself does not work.
>>>>
>>>> A patch for this bug that has been sent before:
>>>> https://lkml.org/lkml/2014/9/30/55
>>>> As in discussion, this bug may happen on *any* device, so we need to
>>>> reset
>>>> all pci devices.
>>>>
>>>> There was an original version(Takao Indoh) that resets the pcie
>>>> devices:
>>>> https://lkml.org/lkml/2013/5/14/9
>>>>
>>>> According to the previous discussion, On sparc, the IOMMU is
>>>> initialized
>>>> before PCI devices are enumerated, this patch does the resetting
>>>> works before
>>>> the kdump kernel boots, so it can also fix the problems on sparc.
>>>>
>>>> Update of this new version, comparing with Takao Indoh's version:
>>>>      Add support for legacy PCI devices.
>>>>      Use pci_try_reset_bus instead of do_downstream_device_reset.
>>>>      Reset all PCI/PCIe deviecs in the first kernel, before kdump
>>>> kernel boots.
>>>>
>>>> Randy Wright corrects some misunderstanding in this description.
>>>>
>>>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>>>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>>>> Signed-off-by: Randy Wright <rwright@hp.com>
>>>> ---
>>>>   drivers/pci/pci.c   | 82
>>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>   include/linux/pci.h |  6 ++++
>>>>   kernel/kexec.c      |  2 ++
>>>>   3 files changed, 90 insertions(+)
>>>>
>>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>>> index 625a4ac..aa9192a 100644
>>>> --- a/drivers/pci/pci.c
>>>> +++ b/drivers/pci/pci.c
>>>> @@ -23,6 +23,7 @@
>>>>   #include <linux/device.h>
>>>>   #include <linux/pm_runtime.h>
>>>>   #include <linux/pci_hotplug.h>
>>>> +#include <linux/crash_dump.h>
>>>>   #include <asm-generic/pci-bridge.h>
>>>>   #include <asm/setup.h>
>>>>   #include "pci.h"
>>>> @@ -4466,6 +4467,87 @@ void __weak pci_fixup_cardbus(struct pci_bus
>>>> *bus)
>>>>   }
>>>>   EXPORT_SYMBOL(pci_fixup_cardbus);
>>>>
>>>> +/*
>>>> + * Return true if dev is PCI root port or downstream port whose
>>>> child is PCI
>>>> + * endpoint except VGA device.
>>>> + */
>>>> +static int __pci_dev_need_reset(struct pci_dev *dev)
>>>> +{
>>>> +    struct pci_bus *subordinate;
>>>> +    struct pci_dev *child;
>>>> +
>>>> +    if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
>>>> +        return 0;
>>>> +
>>>> +    if (pci_is_pcie(dev)) {
>>>> +        if ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
>>>> +            (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM))
>>>> +            return 0;
>>>> +    }
>>>> +
>>>> +    subordinate = dev->subordinate;
>>>> +    list_for_each_entry(child, &subordinate->devices, bus_list) {
>>>> +        /* Don't reset switch, bridge, VGA device */
>>>> +        if ((child->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
>>>> +            ((child->class >> 16) == PCI_BASE_CLASS_BRIDGE) ||
>>>> +            ((child->class >> 16) == PCI_BASE_CLASS_DISPLAY))
>>>> +            return 0;
>>>> +
>>>> +        if (pci_is_pcie(child)) {
>>>> +            if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
>>>> +                (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE))
>>>> +                return 0;
>>>> +        }
>>>> +    }
>>>> +
>>>> +    return 1;
>>>> +}
>>>> +
>>>> +struct pci_dev_reset_entry {
>>>> +    struct list_head list;
>>>> +    struct pci_dev *dev;
>>>> +};
>>>> +int pci_reset_endpoints(void)
>>>> +{
>>>> +    struct pci_dev *dev = NULL;
>>>> +    struct pci_dev_reset_entry *pdev_entry, *tmp;
>>>> +    struct pci_bus *subordinate = NULL;
>>>> +    int has_it;
>>>> +
>>>> +    LIST_HEAD(pdev_list);
>>>> +
>>>> +
>>>> +    for_each_pci_dev(dev) {
>>>> +        subordinate = dev->subordinate;
>>>> +        if (!subordinate || list_empty(&subordinate->devices))
>>>> +            continue;
>>>> +
>>>> +        has_it = 0;
>>>> +        list_for_each_entry(pdev_entry, &pdev_list, list) {
>>>> +            if (dev == pdev_entry->dev) {
>>>> +                has_it = 1;
>>>> +                break;
>>>> +            }
>>>> +        }
>>>> +        if (has_it)
>>>> +            continue;
>>>> +
>>>> +        if (__pci_dev_need_reset(dev)) {
>>>> +            pdev_entry = kmalloc(sizeof(*pdev_entry), GFP_KERNEL);
>>>> +            pdev_entry->dev = dev;
>>>> +            list_add(&pdev_entry->list, &pdev_list);
>>>> +        }
>>>> +    }
>>>> +
>>>> +    list_for_each_entry_safe(pdev_entry, tmp, &pdev_list, list) {
>>>> +        pci_try_reset_bus(pdev_entry->dev->subordinate);
>>>> +        kfree(pdev_entry);
>>>> +    }
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(pci_reset_endpoints);
>>>> +
>>>>   static int __init pci_setup(char *str)
>>>>   {
>>>>       while (str) {
>>>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>>>> index 5be8db4..1cf7207 100644
>>>> --- a/include/linux/pci.h
>>>> +++ b/include/linux/pci.h
>>>> @@ -1869,4 +1869,10 @@ static inline bool pci_is_dev_assigned(struct
>>>> pci_dev *pdev)
>>>>   {
>>>>       return (pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED) ==
>>>> PCI_DEV_FLAGS_ASSIGNED;
>>>>   }
>>>> +
>>>> +/*
>>>> + * Reset all pci devices by resetting the buses.
>>>> + */
>>>> +int pci_reset_endpoints(void);
>>>> +
>>>>   #endif /* LINUX_PCI_H */
>>>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>>>> index 2abf9f6..986e8f7 100644
>>>> --- a/kernel/kexec.c
>>>> +++ b/kernel/kexec.c
>>>> @@ -36,6 +36,7 @@
>>>>   #include <linux/syscore_ops.h>
>>>>   #include <linux/compiler.h>
>>>>   #include <linux/hugetlb.h>
>>>> +#include <linux/pci.h>
>>>>
>>>>   #include <asm/page.h>
>>>>   #include <asm/uaccess.h>
>>>> @@ -1474,6 +1475,7 @@ void crash_kexec(struct pt_regs *regs)
>>>>           if (kexec_crash_image) {
>>>>               struct pt_regs fixed_regs;
>>>>
>>>> +            pci_reset_endpoints();
>>>>               crash_setup_regs(&fixed_regs, regs);
>>>>               crash_save_vmcoreinfo();
>>>>               machine_crash_shutdown(&fixed_regs);
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>

