Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaLVJom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:44:42 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46015 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaLVJok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:44:40 -0500
Message-ID: <5497E7CA.1030504@hp.com>
Date: Mon, 22 Dec 2014 17:43:38 +0800
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
        lisa.mitchell@hp.com, billsumnerlinux@gmail.com
Subject: Re: [PATCH 0/10] iommu/vt-d: Fix intel vt-d faults in kdump kernel
References: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1419239729-26529-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version works for 3.19.0-rc1.

Zhenhua
On 12/22/2014 05:15 PM, Li, Zhen-Hua wrote:
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
> Zhenhua's last of Bill's patchset:
>      https://lkml.org/lkml/2014/10/21/134
>      https://lkml.org/lkml/2014/12/15/121
>
> Changed in this version:
> 1. Do not disable and re-enable traslation and interrupt remapping.
> 2. Use old root entry table.
> 3. Use old interrupt remapping table.
> 4. Use "unsigned long" as physical address.
> 5. Use intel_unmap to unmap the old dma;
>
> This patchset should be applied with this one together:
>      https://lkml.org/lkml/2014/11/5/43
>      x86/iommu: fix incorrect bit operations in setting values
>
> Bill Sumner (5):
>    iommu/vt-d: Update iommu_attach_domain() and its callers
>    iommu/vt-d: Items required for kdump
>    iommu/vt-d: data types and functions used for kdump
>    iommu/vt-d: Add domain-id functions
>    iommu/vt-d: enable kdump support in iommu module
>
> Li, Zhen-Hua (10):
>    iommu/vt-d: Update iommu_attach_domain() and its callers
>    iommu/vt-d: Items required for kdump
>    iommu/vt-d: Add domain-id functions
>    iommu/vt-d: functions to copy data from old mem
>    iommu/vt-d: Add functions to load and save old re
>    iommu/vt-d: datatypes and functions used for kdump
>    iommu/vt-d: enable kdump support in iommu module
>    iommu/vtd: assign new page table for dma_map
>    iommu/vt-d: Copy functions for irte
>    iommu/vt-d: Use old irte in kdump kernel
>
>   drivers/iommu/intel-iommu.c         | 1050 +++++++++++++++++++++++++++++++++--
>   drivers/iommu/intel_irq_remapping.c |   99 +++-
>   include/linux/intel-iommu.h         |   18 +
>   3 files changed, 1123 insertions(+), 44 deletions(-)
>

