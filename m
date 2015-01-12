Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbbALIB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:01:59 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:42499 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbALIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:01:55 -0500
Message-ID: <54B37F2B.9050708@hp.com>
Date: Mon, 12 Jan 2015 16:00:43 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
CC: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org, vgoyal@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com, billsumnerlinux@gmail.com, rwright@hp.com
Subject: Re: [PATCH v8 0/10] iommu/vt-d: Fix intel vt-d faults in kdump kernel
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing to v7, this version adds only a few lines code:

In function copy_page_table,

+		__iommu_flush_cache(iommu, phys_to_virt(dma_pte_next),
+				VTD_PAGE_SIZE);


On 01/12/2015 03:06 PM, Li, Zhen-Hua wrote:
> This patchset is an update of Bill Sumner's patchset, implements a fix for:
> If a kernel boots with intel_iommu=on on a system that supports intel vt-d,
> when a panic happens, the kdump kernel will boot with these faults:
>
>      dmar: DRHD: handling fault status reg 102
>      dmar: DMAR:[DMA Read] Request device [01:00.0] fault addr fff80000
>      DMAR:[fault reason 01] Present bit in root entry is clear
>
>      dmar: DRHD: handling fault status reg 2
>      dmar: INTR-REMAP: Request device [[61:00.0] fault index 42
>      INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
>
> On some system, the interrupt remapping fault will also happen even if the
> intel_iommu is not set to on, because the interrupt remapping will be enabled
> when x2apic is needed by the system.
>
> The cause of the DMA fault is described in Bill's original version, and the
> INTR-Remap fault is caused by a similar reason. In short, the initialization
> of vt-d drivers causes the in-flight DMA and interrupt requests get wrong
> response.
>
> To fix this problem, we modifies the behaviors of the intel vt-d in the
> crashdump kernel:
>
> For DMA Remapping:
> 1. To accept the vt-d hardware in an active state,
> 2. Do not disable and re-enable the translation, keep it enabled.
> 3. Use the old root entry table, do not rewrite the RTA register.
> 4. Malloc and use new context entry table and page table, copy data from the
>     old ones that used by the old kernel.
> 5. to use different portions of the iova address ranges for the device drivers
>     in the crashdump kernel than the iova ranges that were in-use at the time
>     of the panic.
> 6. After device driver is loaded, when it issues the first dma_map command,
>     free the dmar_domain structure for this device, and generate a new one, so
>     that the device can be assigned a new and empty page table.
> 7. When a new context entry table is generated, we also save its address to
>     the old root entry table.
>
> For Interrupt Remapping:
> 1. To accept the vt-d hardware in an active state,
> 2. Do not disable and re-enable the interrupt remapping, keep it enabled.
> 3. Use the old interrupt remapping table, do not rewrite the IRTA register.
> 4. When ioapic entry is setup, the interrupt remapping table is changed, and
>     the updated data will be stored to the old interrupt remapping table.
>
> Advantages of this approach:
> 1. All manipulation of the IO-device is done by the Linux device-driver
>     for that device.
> 2. This approach behaves in a manner very similar to operation without an
>     active iommu.
> 3. Any activity between the IO-device and its RMRR areas is handled by the
>     device-driver in the same manner as during a non-kdump boot.
> 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
>     This supports the practice of creating a special kdump kernel without
>     drivers for any devices that are not required for taking a crashdump.
> 5. Minimal code-changes among the existing mainline intel vt-d code.
>
> Summary of changes in this patch set:
> 1. Added some useful function for root entry table in code intel-iommu.c
> 2. Added new members to struct root_entry and struct irte;
> 3. Functions to load old root entry table to iommu->root_entry from the memory
>     of old kernel.
> 4. Functions to malloc new context entry table and page table and copy the data
>     from the old ones to the malloced new ones.
> 5. Functions to enable support for DMA remapping in kdump kernel.
> 6. Functions to load old irte data from the old kernel to the kdump kernel.
> 7. Some code changes that support other behaviours that have been listed.
> 8. In the new functions, use physical address as "unsigned long" type, not
>     pointers.
>
> Original version by Bill Sumner:
>      https://lkml.org/lkml/2014/1/10/518
>      https://lkml.org/lkml/2014/4/15/716
>      https://lkml.org/lkml/2014/4/24/836
>
> Zhenhua's updates:
>      https://lkml.org/lkml/2014/10/21/134
>      https://lkml.org/lkml/2014/12/15/121
>      https://lkml.org/lkml/2014/12/22/53
>      https://lkml.org/lkml/2015/1/6/1166
>
> Changelog[v8]:
>      1. Add a missing __iommu_flush_cache in function copy_page_table.
>
> Changelog[v7]:
>      1. Use __iommu_flush_cache to flush the data to hardware.
>
> Changelog[v6]:
>      1. Use "unsigned long" as type of physical address.
>      2. Use new function unmap_device_dma to unmap the old dma.
>      3. Some small incorrect bits order for aw shift.
>
> Changelog[v5]:
>      1. Do not disable and re-enable traslation and interrupt remapping.
>      2. Use old root entry table.
>      3. Use old interrupt remapping table.
>      4. New functions to copy data from old kernel, and save to old kernel mem.
>      5. New functions to save updated root entry table and irte table.
>      6. Use intel_unmap to unmap the old dma;
>      7. Allocate new pages while driver is being loaded.
>
> Changelog[v4]:
>      1. Cut off the patches that move some defines and functions to new files.
>      2. Reduce the numbers of patches to five, make it more easier to read.
>      3. Changed the name of functions, make them consistent with current context
>         get/set functions.
>      4. Add change to function __iommu_attach_domain.
>
> Changelog[v3]:
>      1. Commented-out "#define DEBUG 1" to eliminate debug messages.
>      2. Updated the comments about changes in each version.
>      3. Fixed: one-line added to Copy-Translations patch to initialize the iovad
>            struct as recommended by Baoquan He [bhe@redhat.com]
>            init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
>
> Changelog[v2]:
>      The following series implements a fix for:
>      A kdump problem about DMA that has been discussed for a long time. That is,
>      when a kernel panics and boots into the kdump kernel, DMA started by the
>      panicked kernel is not stopped before the kdump kernel is booted and the
>      kdump kernel disables the IOMMU while this DMA continues.  This causes the
>      IOMMU to stop translating the DMA addresses as IOVAs and begin to treat
>      them as physical memory addresses -- which causes the DMA to either:
>          (1) generate DMAR errors or
>          (2) generate PCI SERR errors or
>          (3) transfer data to or from incorrect areas of memory. Often this
>              causes the dump to fail.
>
> Changelog[v1]:
>      The original version.
>
> Changed in this version:
> 1. Do not disable and re-enable traslation and interrupt remapping.
> 2. Use old root entry table.
> 3. Use old interrupt remapping table.
> 4. Use "unsigned long" as physical address.
> 5. Use intel_unmap to unmap the old dma;
>
> Baoquan He <bhe@redhat.com> helps testing this patchset.
> Takao Indoh <indou.takao@jp.fujitsu.com> gives valuable suggestions.
>
>    iommu/vt-d: Update iommu_attach_domain() and its callers
>    iommu/vt-d: Items required for kdump
>    iommu/vt-d: Add domain-id functions
>    iommu/vt-d: functions to copy data from old mem
>    iommu/vt-d: Add functions to load and save old re
>    iommu/vt-d: datatypes and functions used for kdump
>    iommu/vt-d: enable kdump support in iommu module
>    iommu/vt-d: assign new page table for dma_map
>    iommu/vt-d: Copy functions for irte
>    iommu/vt-d: Use old irte in kdump kernel
>
> Signed-off-by: Bill Sumner <billsumnerlinux@gmail.com>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> Tested-by: Baoquan He <bhe@redhat.com>
> ---
>   drivers/iommu/intel-iommu.c         | 1054 +++++++++++++++++++++++++++++++++--
>   drivers/iommu/intel_irq_remapping.c |  104 +++-
>   include/linux/intel-iommu.h         |   18 +
>   3 files changed, 1134 insertions(+), 42 deletions(-)
>

