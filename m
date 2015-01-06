Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbbAFATa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:19:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59987 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbAFAT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:19:26 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <54AB29E6.6070403@jp.fujitsu.com>
Date: Tue, 6 Jan 2015 09:18:46 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <zhen-hual@hp.com>
CC: <dwmw2@infradead.org>, <bhe@redhat.com>, <joro@8bytes.org>,
        <vgoyal@redhat.com>, <dyoung@redhat.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        <billsumnerlinux@gmail.com>
Subject: Re: [PATCH 0/10] iommu/vt-d: Fix intel vt-d faults in kdump kernel
References: <1419239729-26529-1-git-send-email-zhen-hual@hp.com> <549CEE8F.2090209@jp.fujitsu.com> <549D0459.4080202@hp.com> <549D0DEE.8000301@jp.fujitsu.com> <54A0C761.5060604@hp.com>
In-Reply-To: <54A0C761.5060604@hp.com>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/29 12:15, Li, ZhenHua wrote:
> Hi Takao Indoh,
> 
> Happy New Year, and thank you very much for you help.  The flush is quite

Happy new year!

>   a problem,  as there are several places the flush function should be called,
> I think the flush should be placed in functions like __iommu_update_old_*.
> Created a small patch for this, it is attached.
> 
> 
> 
> As I cannot reproduce your problems on my system, so could you please try
> these steps?
> 1. Apply the latest patchset, including 9/10 and 10/10, and then apply the
> attached patch_for_flush.patch.  And then test the kernel.

No inter-remap fault, but there is still DMAR fault message.

> 
> 2.  If 1 does not fix the DMAR fault  problems, then it might be caused by
> 7/10, so please *unpatch* it from the kernel (others and the  attached one
> should be patched), and then test the kernel.

DMAR fault still occurs. I'll dig iommu driver code to find out the
reason.

Thanks,
Takao Indoh

> 
> Regards
> Zhenhua
> 
> On 12/26/2014 03:27 PM, Takao Indoh wrote:
>> On 2014/12/26 15:46, Li, ZhenHua wrote:
>>> Hi Takao Indoh,
>>>
>>> Thank you very much for your testing. I will add your update in next
>>> version.
>>> Also I think a flush for __iommu_update_old_root_entry is also necessary.
>>>
>>> Currently I have no idea about your fault, does it happen before or
>>> during its loading? Could you send me your full kernel log as an
>>> attachment?
>> Sure, see attached file.
>>
>> I removed 9/10 and 10/10 patches from my kernel to avoid panic problem I
>> reported in previous mail, and then tested kdump. So please ignore
>> intr-remap fault message in log file. Also please ignore stack trace
>> starting with the following message, it's a problem of my box.
>>
>>    Flags mismatch irq 0. 00000080 (i801_smbus) vs. 00015a00 (timer)
>>
>> Thanks,
>> Takao Indoh
>>
>>> Regards and Merry Christmas.
>>> Zhenhua
>>>
>>> On 12/26/2014 01:13 PM, Takao Indoh wrote:
>>>> Hi Zhen-Hua,
>>>>
>>>> I tested your patch and found two problems.
>>>>
>>>> [1]
>>>> Kenel panic occurs during 2nd kernel boot.
>>>>
>>>> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>>>> Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
>>>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0 #25
>>>> Hardware name: FUJITSU-SV PRIMERGY BX920 S2/D3030, BIOS 080015 Rev.3D81.3030 02/10/2012
>>>>    0000000000000002 ffff880036167d08 ffffffff815b1c6a 0000000000000000
>>>>    ffffffff817f7670 ffff880036167d88 ffffffff815b19f1 0000000000000008
>>>>    ffff880036167d98 ffff880036167d38 ffffffff810a5d2f ffff880036167d98
>>>> Call Trace:
>>>>    [<ffffffff815b1c6a>] dump_stack+0x48/0x5e
>>>>    [<ffffffff815b19f1>] panic+0xbb/0x1fa
>>>>    [<ffffffff810a5d2f>] ? vprintk_default+0x1f/0x30
>>>>    [<ffffffff814c6a6c>] panic_if_irq_remap+0x1c/0x20
>>>>    [<ffffffff81b53985>] check_timer+0x1e7/0x5ed
>>>>    [<ffffffff8129bd9d>] ? radix_tree_lookup+0xd/0x10
>>>>    [<ffffffff81b5413b>] setup_IO_APIC+0x261/0x292
>>>>    [<ffffffff81b50302>] native_smp_prepare_cpus+0x214/0x25d
>>>>    [<ffffffff81b41c65>] kernel_init_freeable+0x1dc/0x28c
>>>>    [<ffffffff815aaf00>] ? rest_init+0x80/0x80
>>>>    [<ffffffff815aaf0e>] kernel_init+0xe/0xf0
>>>>    [<ffffffff815b5d2c>] ret_from_fork+0x7c/0xb0
>>>>    [<ffffffff815aaf00>] ? rest_init+0x80/0x80
>>>> ---[ end Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
>>>>
>>>>
>>>> This panic seems to be related to unflushed cache. I confirmed this
>>>> problem was fixed by the following patch.
>>>>
>>>> --- a/drivers/iommu/intel_irq_remapping.c
>>>> +++ b/drivers/iommu/intel_irq_remapping.c
>>>> @@ -200,8 +200,13 @@ static int modify_irte(int irq, struct irte *irte_modified)
>>>>    	set_64bit(&irte->high, irte_modified->high);
>>>>    
>>>>    #ifdef CONFIG_CRASH_DUMP
>>>> -	if (is_kdump_kernel())
>>>> +	if (is_kdump_kernel()) {
>>>>    		__iommu_update_old_irte(iommu, index);
>>>> +		__iommu_flush_cache(iommu,
>>>> +			iommu->ir_table->base_old_virt +
>>>> +			index * sizeof(struct irte),
>>>> +			sizeof(struct irte));
>>>> +	}
>>>>    #endif
>>>>    	__iommu_flush_cache(iommu, irte, sizeof(*irte));
>>>>    
>>>>
>>>> [2]
>>>> Some DMAR error messages are still found in 2nd kernel boot.
>>>>
>>>> dmar: DRHD: handling fault status reg 2
>>>> dmar: DMAR:[DMA Write] Request device [01:00.0] fault addr ffded000
>>>> DMAR:[fault reason 01] Present bit in root entry is clear
>>>>
>>>> I confiremd your commit 1a2262 was already applied. Any idea?
>>>>
>>>> Thanks,
>>>> Takao Indoh
>>>>
>>>>
>>>> On 2014/12/22 18:15, Li, Zhen-Hua wrote:
>>>>> This patchset is an update of Bill Sumner's patchset, implements a fix for:
>>>>> If a kernel boots with intel_iommu=on on a system that supports intel vt-d,
>>>>> when a panic happens, the kdump kernel will boot with these faults:
>>>>>
>>>>>        dmar: DRHD: handling fault status reg 102
>>>>>        dmar: DMAR:[DMA Read] Request device [01:00.0] fault addr fff80000
>>>>>        DMAR:[fault reason 01] Present bit in root entry is clear
>>>>>
>>>>>        dmar: DRHD: handling fault status reg 2
>>>>>        dmar: INTR-REMAP: Request device [[61:00.0] fault index 42
>>>>>        INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
>>>>>
>>>>> On some system, the interrupt remapping fault will also happen even if the
>>>>> intel_iommu is not set to on, because the interrupt remapping will be enabled
>>>>> when x2apic is needed by the system.
>>>>>
>>>>> The cause of the DMA fault is described in Bill's original version, and the
>>>>> INTR-Remap fault is caused by a similar reason. In short, the initialization
>>>>> of vt-d drivers causes the in-flight DMA and interrupt requests get wrong
>>>>> response.
>>>>>
>>>>> To fix this problem, we modifies the behaviors of the intel vt-d in the
>>>>> crashdump kernel:
>>>>>
>>>>> For DMA Remapping:
>>>>> 1. To accept the vt-d hardware in an active state,
>>>>> 2. Do not disable and re-enable the translation, keep it enabled.
>>>>> 3. Use the old root entry table, do not rewrite the RTA register.
>>>>> 4. Malloc and use new context entry table and page table, copy data from the
>>>>>       old ones that used by the old kernel.
>>>>> 5. to use different portions of the iova address ranges for the device drivers
>>>>>       in the crashdump kernel than the iova ranges that were in-use at the time
>>>>>       of the panic.
>>>>> 6. After device driver is loaded, when it issues the first dma_map command,
>>>>>       free the dmar_domain structure for this device, and generate a new one, so
>>>>>       that the device can be assigned a new and empty page table.
>>>>> 7. When a new context entry table is generated, we also save its address to
>>>>>       the old root entry table.
>>>>>
>>>>> For Interrupt Remapping:
>>>>> 1. To accept the vt-d hardware in an active state,
>>>>> 2. Do not disable and re-enable the interrupt remapping, keep it enabled.
>>>>> 3. Use the old interrupt remapping table, do not rewrite the IRTA register.
>>>>> 4. When ioapic entry is setup, the interrupt remapping table is changed, and
>>>>>       the updated data will be stored to the old interrupt remapping table.
>>>>>
>>>>> Advantages of this approach:
>>>>> 1. All manipulation of the IO-device is done by the Linux device-driver
>>>>>       for that device.
>>>>> 2. This approach behaves in a manner very similar to operation without an
>>>>>       active iommu.
>>>>> 3. Any activity between the IO-device and its RMRR areas is handled by the
>>>>>       device-driver in the same manner as during a non-kdump boot.
>>>>> 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
>>>>>       This supports the practice of creating a special kdump kernel without
>>>>>       drivers for any devices that are not required for taking a crashdump.
>>>>> 5. Minimal code-changes among the existing mainline intel vt-d code.
>>>>>
>>>>> Summary of changes in this patch set:
>>>>> 1. Added some useful function for root entry table in code intel-iommu.c
>>>>> 2. Added new members to struct root_entry and struct irte;
>>>>> 3. Functions to load old root entry table to iommu->root_entry from the memory
>>>>>       of old kernel.
>>>>> 4. Functions to malloc new context entry table and page table and copy the data
>>>>>       from the old ones to the malloced new ones.
>>>>> 5. Functions to enable support for DMA remapping in kdump kernel.
>>>>> 6. Functions to load old irte data from the old kernel to the kdump kernel.
>>>>> 7. Some code changes that support other behaviours that have been listed.
>>>>> 8. In the new functions, use physical address as "unsigned long" type, not
>>>>>       pointers.
>>>>>
>>>>> Original version by Bill Sumner:
>>>>>        https://lkml.org/lkml/2014/1/10/518
>>>>>        https://lkml.org/lkml/2014/4/15/716
>>>>>        https://lkml.org/lkml/2014/4/24/836
>>>>>
>>>>> Zhenhua's last of Bill's patchset:
>>>>>        https://lkml.org/lkml/2014/10/21/134
>>>>>        https://lkml.org/lkml/2014/12/15/121
>>>>>
>>>>> Changed in this version:
>>>>> 1. Do not disable and re-enable traslation and interrupt remapping.
>>>>> 2. Use old root entry table.
>>>>> 3. Use old interrupt remapping table.
>>>>> 4. Use "unsigned long" as physical address.
>>>>> 5. Use intel_unmap to unmap the old dma;
>>>>>
>>>>> This patchset should be applied with this one together:
>>>>>        https://lkml.org/lkml/2014/11/5/43
>>>>>        x86/iommu: fix incorrect bit operations in setting values
>>>>>
>>>>> Bill Sumner (5):
>>>>>      iommu/vt-d: Update iommu_attach_domain() and its callers
>>>>>      iommu/vt-d: Items required for kdump
>>>>>      iommu/vt-d: data types and functions used for kdump
>>>>>      iommu/vt-d: Add domain-id functions
>>>>>      iommu/vt-d: enable kdump support in iommu module
>>>>>
>>>>> Li, Zhen-Hua (10):
>>>>>      iommu/vt-d: Update iommu_attach_domain() and its callers
>>>>>      iommu/vt-d: Items required for kdump
>>>>>      iommu/vt-d: Add domain-id functions
>>>>>      iommu/vt-d: functions to copy data from old mem
>>>>>      iommu/vt-d: Add functions to load and save old re
>>>>>      iommu/vt-d: datatypes and functions used for kdump
>>>>>      iommu/vt-d: enable kdump support in iommu module
>>>>>      iommu/vtd: assign new page table for dma_map
>>>>>      iommu/vt-d: Copy functions for irte
>>>>>      iommu/vt-d: Use old irte in kdump kernel
>>>>>
>>>>>     drivers/iommu/intel-iommu.c         | 1050 +++++++++++++++++++++++++++++++++--
>>>>>     drivers/iommu/intel_irq_remapping.c |   99 +++-
>>>>>     include/linux/intel-iommu.h         |   18 +
>>>>>     3 files changed, 1123 insertions(+), 44 deletions(-)
>>>>>
>>>
>>>
> 


