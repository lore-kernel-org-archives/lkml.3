Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbbAHDMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 22:12:42 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:36294 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbbAHDMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 22:12:39 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>,
        "bhe@redhat.com" <bhe@redhat.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Hatch, Douglas B (HPS Linux PM)" <doug.hatch@hp.com>,
        "Hoemann, Jerry" <jerry.hoemann@hp.com>,
        "Vaden, Tom (HP Server OS Architecture)" <tom.vaden@hp.com>,
        "Zhang, Li (Zoe@HPservers-Core-OE-PSC)" <li.zhang6@hp.com>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        "billsumnerlinux@gmail.com" <billsumnerlinux@gmail.com>,
        "Wright, Randy (HP Servers Linux)" <rwright@hp.com>
Subject: RE: [PATCH v7 0/10] iommu/vt-d: Fix intel vt-d faults in kdump
 kernel
Thread-Topic: [PATCH v7 0/10] iommu/vt-d: Fix intel vt-d faults in kdump
 kernel
Thread-Index: AQHQKi85FMyrBZcVEk2JkuF9UcH3LZy0C52AgAAOX4CAAAZygIAAMvSAgAAGxgCAAQ5pAIAAHcEg
Date: Thu, 8 Jan 2015 03:11:36 +0000
Message-ID: <1267BB84A242B24E81E0C0C8955CFFC061AD4A8E@G9W0343.americas.hpqcorp.net>
References: <1420603474-4235-1-git-send-email-zhen-hual@hp.com>
 <54ACB1E9.9070904@hp.com>
 <20150107050247.GA16050@dhcp-16-116.nay.redhat.com>
 <54ACC35F.1070007@hp.com>
 <20150107082813.GB16050@dhcp-16-116.nay.redhat.com>
 <54ACF3CC.7090004@hp.com> <54ADD6A2.5020807@jp.fujitsu.com>
In-Reply-To: <54ADD6A2.5020807@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.65.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In your log, it seems something incorrect while copying pages.

Your last DMAR fault is:
DMAR:[fault reason 01] Present bit in root entry is clear

But this time, it is:
DMAR:[fault reason 05] PTE Write access is not set


So I think this line I added to this version , it works.
function intel_iommu_load_translation_tables, line:
    __iommu_flush_cache(iommu, iommu->root_entry, PAGE_SIZE);


I checked the code, found I missed one flush in function copy_page_table.
How do you think we add one flush after this lines:

			ret = copy_page_table(&dma_pte_next, 
					(p->val & VTD_PAGE_MASK),
					shift-9, page_addr | (u << shift),
					iommu, bus, devfn, dve, ppap);

+			__iommu_flush_cache(iommu, phys_to_virt(dma_pte_next),
+				VTD_PAGE_SIZE);

If this does not work, I have no ideas currently, need to dig the code more.

Regards
Zhenhua

-----Original Message-----
From: Takao Indoh [mailto:indou.takao@jp.fujitsu.com] 
Sent: Thursday, January 08, 2015 9:00 AM
To: Li, Zhen-Hua; bhe@redhat.com
Cc: dwmw2@infradead.org; joro@8bytes.org; vgoyal@redhat.com; dyoung@redhat.com; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; kexec@lists.infradead.org; alex.williamson@redhat.com; ddutile@redhat.com; ishii.hironobu@jp.fujitsu.com; bhelgaas@google.com; Hatch, Douglas B (HPS Linux PM); Hoemann, Jerry; Vaden, Tom (HP Server OS Architecture); Zhang, Li (Zoe@HPservers-Core-OE-PSC); Mitchell, Lisa (MCLinux in Fort Collins); billsumnerlinux@gmail.com; Wright, Randy (HP Servers Linux)
Subject: Re: [PATCH v7 0/10] iommu/vt-d: Fix intel vt-d faults in kdump kernel

On 2015/01/07 17:52, Li, ZhenHua wrote:
> Well, that's quite good news.
> Looking forward Takao's testing on his system.

Unfortunately DMAR fault still occurs with this patch...
I attach console log.

Thanks,
Takao Indoh

> 
> Regards
> Zhenhua
> On 01/07/2015 04:28 PM, Baoquan He wrote:
>> On 01/07/15 at 01:25pm, Li, ZhenHua wrote:
>>> It is same as the last one I send to you yesterday.
>>>
>>> The continuous memory that needed for data in this patchset:
>>> RE: PAGE_SIZE, 4096 Bytes;
>>> IRTE: 65536 * 16 ; 1M Bytes;
>>>
>>> It should use same memory as the old versions of this patchset. The 
>>> changes for the last version do not need more memory.
>>
>> Hi Zhenhua,
>>
>> It was my mistake because I didn't strip the debug info of modules, 
>> then initramfs is bloated very big. Just now I tested the latest 
>> version, it works well and dump is successful. No dmar fault and 
>> intr-remap fault seen any more, good job!
>>
>> Thanks
>> Baoquan
>>
>>
>>>
>>> Regards
>>> Zhenhua
>>>
>>> On 01/07/2015 01:02 PM, Baoquan He wrote:
>>>> On 01/07/15 at 12:11pm, Li, ZhenHua wrote:
>>>>> Many thanks to Takao Indoh and Baoquan He, for your testing on 
>>>>> more different systems.
>>>>>
>>>>> The calling of flush functions are added to this version.
>>>>>
>>>>> The usage of __iommu_flush_cache function :
>>>>> 1. Fixes a dump on Takao's system.
>>>>> 2. Reduces the count of faults on Baoquan's system.
>>>>
>>>> I am testing the version you sent to me yesterday afternoon. Is 
>>>> that different with this patchset? I found your patchset man 
>>>> reserve a big contiguous memory region under 896M, this will cause 
>>>> the crashkernel reservation failed when I set crashkernel=320M. The 
>>>> reason I increase the crashkerenl reservation to 320M is 256M is 
>>>> not enough and cause OOM when that patchset is tested.
>>>>
>>>> I am checking what happened.
>>>>
>>>>
>>>> Thanks
>>>> Baoquan
>>>>
>>>>>
>>>>> Regards
>>>>> Zhenhua
>>>>>
>>>>> On 01/07/2015 12:04 PM, Li, Zhen-Hua wrote:
>>>>>> This patchset is an update of Bill Sumner's patchset, implements a fix for:
>>>>>> If a kernel boots with intel_iommu=on on a system that supports 
>>>>>> intel vt-d, when a panic happens, the kdump kernel will boot with these faults:
>>>>>>
>>>>>>      dmar: DRHD: handling fault status reg 102
>>>>>>      dmar: DMAR:[DMA Read] Request device [01:00.0] fault addr fff80000
>>>>>>      DMAR:[fault reason 01] Present bit in root entry is clear
>>>>>>
>>>>>>      dmar: DRHD: handling fault status reg 2
>>>>>>      dmar: INTR-REMAP: Request device [[61:00.0] fault index 42
>>>>>>      INTR-REMAP:[fault reason 34] Present field in the IRTE entry 
>>>>>> is clear
>>>>>>
>>>>>> On some system, the interrupt remapping fault will also happen 
>>>>>> even if the intel_iommu is not set to on, because the interrupt 
>>>>>> remapping will be enabled when x2apic is needed by the system.
>>>>>>
>>>>>> The cause of the DMA fault is described in Bill's original 
>>>>>> version, and the INTR-Remap fault is caused by a similar reason. 
>>>>>> In short, the initialization of vt-d drivers causes the in-flight 
>>>>>> DMA and interrupt requests get wrong response.
>>>>>>
>>>>>> To fix this problem, we modifies the behaviors of the intel vt-d 
>>>>>> in the crashdump kernel:
>>>>>>
>>>>>> For DMA Remapping:
>>>>>> 1. To accept the vt-d hardware in an active state, 2. Do not 
>>>>>> disable and re-enable the translation, keep it enabled.
>>>>>> 3. Use the old root entry table, do not rewrite the RTA register.
>>>>>> 4. Malloc and use new context entry table and page table, copy data from the
>>>>>>     old ones that used by the old kernel.
>>>>>> 5. to use different portions of the iova address ranges for the device drivers
>>>>>>     in the crashdump kernel than the iova ranges that were in-use at the time
>>>>>>     of the panic.
>>>>>> 6. After device driver is loaded, when it issues the first dma_map command,
>>>>>>     free the dmar_domain structure for this device, and generate a new one, so
>>>>>>     that the device can be assigned a new and empty page table.
>>>>>> 7. When a new context entry table is generated, we also save its address to
>>>>>>     the old root entry table.
>>>>>>
>>>>>> For Interrupt Remapping:
>>>>>> 1. To accept the vt-d hardware in an active state, 2. Do not 
>>>>>> disable and re-enable the interrupt remapping, keep it enabled.
>>>>>> 3. Use the old interrupt remapping table, do not rewrite the IRTA register.
>>>>>> 4. When ioapic entry is setup, the interrupt remapping table is changed, and
>>>>>>     the updated data will be stored to the old interrupt remapping table.
>>>>>>
>>>>>> Advantages of this approach:
>>>>>> 1. All manipulation of the IO-device is done by the Linux device-driver
>>>>>>     for that device.
>>>>>> 2. This approach behaves in a manner very similar to operation without an
>>>>>>     active iommu.
>>>>>> 3. Any activity between the IO-device and its RMRR areas is handled by the
>>>>>>     device-driver in the same manner as during a non-kdump boot.
>>>>>> 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
>>>>>>     This supports the practice of creating a special kdump kernel without
>>>>>>     drivers for any devices that are not required for taking a crashdump.
>>>>>> 5. Minimal code-changes among the existing mainline intel vt-d code.
>>>>>>
>>>>>> Summary of changes in this patch set:
>>>>>> 1. Added some useful function for root entry table in code 
>>>>>> intel-iommu.c 2. Added new members to struct root_entry and 
>>>>>> struct irte; 3. Functions to load old root entry table to iommu->root_entry from the memory
>>>>>>     of old kernel.
>>>>>> 4. Functions to malloc new context entry table and page table and copy the data
>>>>>>     from the old ones to the malloced new ones.
>>>>>> 5. Functions to enable support for DMA remapping in kdump kernel.
>>>>>> 6. Functions to load old irte data from the old kernel to the kdump kernel.
>>>>>> 7. Some code changes that support other behaviours that have been listed.
>>>>>> 8. In the new functions, use physical address as "unsigned long" type, not
>>>>>>     pointers.
>>>>>>
>>>>>> Original version by Bill Sumner:
>>>>>>      https://lkml.org/lkml/2014/1/10/518
>>>>>>      https://lkml.org/lkml/2014/4/15/716
>>>>>>      https://lkml.org/lkml/2014/4/24/836
>>>>>>
>>>>>> Zhenhua's updates:
>>>>>>      https://lkml.org/lkml/2014/10/21/134
>>>>>>      https://lkml.org/lkml/2014/12/15/121
>>>>>>      https://lkml.org/lkml/2014/12/22/53
>>>>>>
>>>>>> Changelog[v7]:
>>>>>>      1. Use __iommu_flush_cache to flush the data to hardware.
>>>>>>
>>>>>> Changelog[v6]:
>>>>>>      1. Use "unsigned long" as type of physical address.
>>>>>>      2. Use new function unmap_device_dma to unmap the old dma.
>>>>>>      3. Some small incorrect bits order for aw shift.
>>>>>>
>>>>>> Changelog[v5]:
>>>>>>      1. Do not disable and re-enable traslation and interrupt remapping.
>>>>>>      2. Use old root entry table.
>>>>>>      3. Use old interrupt remapping table.
>>>>>>      4. New functions to copy data from old kernel, and save to old kernel mem.
>>>>>>      5. New functions to save updated root entry table and irte table.
>>>>>>      6. Use intel_unmap to unmap the old dma;
>>>>>>      7. Allocate new pages while driver is being loaded.
>>>>>>
>>>>>> Changelog[v4]:
>>>>>>      1. Cut off the patches that move some defines and functions to new files.
>>>>>>      2. Reduce the numbers of patches to five, make it more easier to read.
>>>>>>      3. Changed the name of functions, make them consistent with current context
>>>>>>         get/set functions.
>>>>>>      4. Add change to function __iommu_attach_domain.
>>>>>>
>>>>>> Changelog[v3]:
>>>>>>      1. Commented-out "#define DEBUG 1" to eliminate debug messages.
>>>>>>      2. Updated the comments about changes in each version.
>>>>>>      3. Fixed: one-line added to Copy-Translations patch to initialize the iovad
>>>>>>            struct as recommended by Baoquan He [bhe@redhat.com]
>>>>>>            init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
>>>>>>
>>>>>> Changelog[v2]:
>>>>>>      The following series implements a fix for:
>>>>>>      A kdump problem about DMA that has been discussed for a long time. That is,
>>>>>>      when a kernel panics and boots into the kdump kernel, DMA started by the
>>>>>>      panicked kernel is not stopped before the kdump kernel is booted and the
>>>>>>      kdump kernel disables the IOMMU while this DMA continues.  This causes the
>>>>>>      IOMMU to stop translating the DMA addresses as IOVAs and begin to treat
>>>>>>      them as physical memory addresses -- which causes the DMA to either:
>>>>>>          (1) generate DMAR errors or
>>>>>>          (2) generate PCI SERR errors or
>>>>>>          (3) transfer data to or from incorrect areas of memory. Often this
>>>>>>              causes the dump to fail.
>>>>>>
>>>>>> Changelog[v1]:
>>>>>>      The original version.
>>>>>>
>>>>>> Changed in this version:
>>>>>> 1. Do not disable and re-enable traslation and interrupt remapping.
>>>>>> 2. Use old root entry table.
>>>>>> 3. Use old interrupt remapping table.
>>>>>> 4. Use "unsigned long" as physical address.
>>>>>> 5. Use intel_unmap to unmap the old dma;
>>>>>>
>>>>>> Baoquan He <bhe@redhat.com> helps testing this patchset.
>>>>>>
>>>>>>    iommu/vt-d: Update iommu_attach_domain() and its callers
>>>>>>    iommu/vt-d: Items required for kdump
>>>>>>    iommu/vt-d: Add domain-id functions
>>>>>>    iommu/vt-d: functions to copy data from old mem
>>>>>>    iommu/vt-d: Add functions to load and save old re
>>>>>>    iommu/vt-d: datatypes and functions used for kdump
>>>>>>    iommu/vt-d: enable kdump support in iommu module
>>>>>>    iommu/vt-d: assign new page table for dma_map
>>>>>>    iommu/vt-d: Copy functions for irte
>>>>>>    iommu/vt-d: Use old irte in kdump kernel
>>>>>>
>>>>>> Signed-off-by: Bill Sumner <billsumnerlinux@gmail.com>
>>>>>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>>>>>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>>>>>> Tested-by: Baoquan He <bhe@redhat.com>
>>>>>> ---
>>>>>>   drivers/iommu/intel-iommu.c         | 1050 +++++++++++++++++++++++++++++++++--
>>>>>>   drivers/iommu/intel_irq_remapping.c |  104 +++-
>>>>>>   include/linux/intel-iommu.h         |   18 +
>>>>>>   3 files changed, 1130 insertions(+), 42 deletions(-)
>>>>>>
>>>>>
>>>
> 
> 
> 

