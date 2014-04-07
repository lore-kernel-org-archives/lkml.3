Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaDGUoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbaDGUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:44:05 -0400
Message-ID: <53430DE9.9080303@redhat.com>
Date: Mon, 07 Apr 2014 16:43:21 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Bill Sumner <bill.sumner@hp.com>
CC: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, alex.williamson@redhat.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        zhenhua@hp.com
Subject: Re: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
In-Reply-To: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 05:07 PM, Bill Sumner wrote:
> v2->v3:
> 1. Commented-out "#define DEBUG 1" to eliminate debug messages
> 2. Updated the comments about changes in each version in all patches in the set.
> 3. Fixed: one-line added to Copy-Translations" patch to initialize the iovad
>            struct as recommended by Baoquan He [bhe@redhat.com]
>            init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
>
> v1->v2:
> The following series implements a fix for:
> A kdump problem about DMA that has been discussed for a long time. That is,
> when a kernel panics and boots into the kdump kernel, DMA started by the
> panicked kernel is not stopped before the kdump kernel is booted and the
> kdump kernel disables the IOMMU while this DMA continues.  This causes the
> IOMMU to stop translating the DMA addresses as IOVAs and begin to treat them
> as physical memory addresses -- which causes the DMA to either:
> (1) generate DMAR errors or (2) generate PCI SERR errors or (3) transfer
> data to or from incorrect areas of memory. Often this causes the dump to fail.
>
> This patch set modifies the behavior of the iommu in the (new) crashdump kernel:
> 1. to accept the iommu hardware in an active state,
> 2. to leave the current translations in-place so that legacy DMA will continue
>     using its current buffers until the device drivers in the crashdump kernel
>     initialize and initialize their devices,
> 3. to use different portions of the iova address ranges for the device drivers
>     in the crashdump kernel than the iova ranges that were in-use at the time
>     of the panic.
>
> Advantages of this approach:
> 1. All manipulation of the IO-device is done by the Linux device-driver
>     for that device.
> 2. This approach behaves in a manner very similar to operation without an
>     active iommu.

Sorry to be late to the game.... finally getting out of a deep hole &
asked to look at this proposal...

Along this concept -- similar to operation without an active iommu --
have you considered the following:
a) if (this is crash kernel), turn *off* DMAR faults;
b) if (this is crash kernel), isolate all device DMA in IOMMU
b) as second kernel configures each device, have each device to use IOMMU hw-passthrough,
      i.e., the equivalent of having no IOMMU for the second, kexec'd kernel
   but, having the benefit of keeping all the other (potentially bad) devices
   sequestered / isolated, until they are initialized & re-configured in the second kernel,
    *if at all* -- note: kexec'd kernels may not enable/configure all devices that
    existed in the first kernel (Bill: I'm sure you know this, but others may not).

RMRR's that were previously setup could continue to work if they are skipped in step (b),
unless the device has gone mad/bad.  In that case, re-parsing the RMRR may or may not
clear up the issue.

Additionally, a tidbit of information like "some servers force NMI's on DMAR faults,
and cause a system reset, thereby, preventing a kdump to occur"
should have been included as one reason to stop DMAR faults from occurring on kexec-boot,
in addition to the fact that a flood of them can lock up a system.

Again, just turning off DMAR fault reporting for the 'if (this is crash kernel)',
short-term workaround sounds a whole lot less expensive to implement, as well as
'if (this is crash kernel), force hw-passthrough'.

If the IO devices are borked to the point that they won't complete DMA properly,
with or without IOMMU, the system is dead anyhow, game over.

Finally, copying the previous IOMMU state to the second kernel, and hoping
that the cause of the kernel crash wasn't an errant DMA (e.g., due to a device going bad,
or it's DMA-state being corrupted & causing an improper IO), is omitting an important failure
case/space.
Keeping the first-kernel DMA isolated (IOMMU on, all translations off, all DMAR faults off),
and then allowing each device (driver) configuration to sanely reset the device &
start a new (hw-passthrough) domain seems simpler and cleaner, for this dump-and-run kernel
effort.

- Don

> 3. Any activity between the IO-device and its RMRR areas is handled by the
>     device-driver in the same manner as during a non-kdump boot.
> 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
>     This supports the practice of creating a special kdump kernel without
>     drivers for any devices that are not required for taking a crashdump.
>
> Changes since the RFC version of this patch:
> 1. Consolidated all of the operational code into the "copy..." functions.
>     The "process..." functions were primarily used for diagnostics and
>     exploration; however, there was a small amount of operational code that
>     used the "process..." functions.
>     This operational code has been moved into the "copy..." functions.
>
> 2. Removed the "Process ..." functions and the diagnostic code that ran
>     on that function set.  This removed about 1/4 of the code -- which this
>     operational patch set no longer needs.  These portions of the RFC patch
>     could be formatted as a separate patch and submitted independently
>     at a later date.
>
> 3. Re-formatted the code to the Linux Coding Standards.
>     The checkpatch script still finds some lines to complain about;
>     however most of these lines are either (1) lines that I did not change,
>     or (2) lines that only changed by adding a level of indent which pushed
>     them over 80-characters, or (3) new lines whose intent is far clearer when
>     longer than 80-characters.
>
> 4. Updated the remaining debug print to be significantly more flexible.
>     This allows control over the amount of debug print to the console --
>     which can vary widely.
>
> 5. Fixed a couple of minor bugs found by testing on a machine with a
>     very large IO configuration.
>
> At a high level, this code operates primarily during iommu initialization
> and device-driver initialization
>
> During intel-iommu hardware initialization:
> In intel_iommu_init(void)
> * If (This is the crash kernel)
>    .  Set flag: crashdump_accepting_active_iommu (all changes below check this)
>    .  Skip disabling the iommu hardware translations
>
> In init_dmars()
> * Duplicate the intel iommu translation tables from the old kernel
>    in the new kernel
>    . The root-entry table, all context-entry tables,
>      and all page-translation-entry tables
>    . The duplicate tables contain updated physical addresses to link them together.
>    . The duplicate tables are mapped into kernel virtual addresses
>      in the new kernel which allows most of the existing iommu code
>      to operate without change.
>    . Do some minimal sanity-checks during the copy
>    . Place the address of the new root-entry structure into "struct intel_iommu"
>
> * Skip setting-up new domains for 'si', 'rmrr', 'isa'
>    . Translations for 'rmrr' and 'isa' ranges have been copied from the old kernel
>    . This patch has not yet been tested with iommu pass-through enabled
>
> * Existing (unchanged) code near the end of dmar_init:
>    . Loads the address of the (now new) root-entry structure from
>      "struct intel_iommu" into the iommu hardware and does the hardware flushes.
>      This changes the active translation tables from the ones in the old kernel
>      to the copies in the new kernel.
>    . This is legal because the translations in the two sets of tables are
>      currently identical:
>        Virtualization Technology for Directed I/O. Architecture Specification,
>        February 2011, Rev. 1.3  (section 11.2, paragraph 2)
>
> In iommu_init_domains()
> * Mark as in-use all domain-id's from the old kernel
>    . In case the new kernel contains a device that was not in the old kernel
>      and a new, unused domain-id is actually needed, the bitmap will give us one.
>
> When a new domain is created for a device:
> * If (this device has a context in the old kernel)
>    . Get domain-id, address-width, and IOVA ranges from the old kernel context;
>    . Get address(page-entry-tables) from the copy in the new kernel;
>    . And apply all of the above values to the new domain structure.
> * Else
>    . Create a new domain as normal
>
>
> Bill Sumner (6):
>    Crashdump-Accepting-Active-IOMMU-Flags-and-Prototype
>    Crashdump-Accepting-Active-IOMMU-Utility-functions
>    Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
>    Crashdump-Accepting-Active-IOMMU-Copy-Translations
>    Crashdump-Accepting-Active-IOMMU-Debug-Print-IOMMU
>    Crashdump-Accepting-Active-IOMMU-Call-From-Mainline
>
>   drivers/iommu/intel-iommu.c | 1293 ++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 1225 insertions(+), 68 deletions(-)
>

