Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3LTFmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:42:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3LTFmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:42:03 -0500
Date: Fri, 20 Dec 2013 13:41:22 +0800
From: Baoquan He <bhe@redhat.com>
To: Bill Sumner <bill.sumner@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        kexec-kdump-list@redhat.com
Subject: Re: [PATCHv2 0/6] Crashdump Accepting Active IOMMU
Message-ID: <20131220053959.GA32194@dhcp-16-116.nay.redhat.com>
References: <1387507787-14163-1-git-send-email-bill.sumner@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387507787-14163-1-git-send-email-bill.sumner@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have reviewed and tested this patchset. Without it the DMAR error
always occured as below. With this patchset, no error is reported and
kdump can work successfully.

This patchset is awesome, it get to the root of the problem when enable
intel-iommu in kdump and fix it. And from code no harm would come to 1st
kernel, surely people's review can guarantee this better and is very
important.

Hi Bill,

Thanks a lot for your effort. 

I have several comments. I think for a formal patch the debug print
need be erased. Or you can split it from this patchset and post it
separately. Then people who review and test your patchset can use the
debug utility.

A bug is found when I test it. please see the inline comment.

Baoquan
Thanks


On 12/19/13 at 07:49pm, Bill Sumner wrote:
> 
> Changes from previous submission:
> 1. Moved up to Linux kernel top-of-tree of this week.
> 2. Expanded the comments section of each patch so that the documentation
>    will appear in the commit logs. (Requested by Alex Williamson and one
>    internal reviewer)
> 3. Corrected one line in the table which drives the diagnostic printing
>    of the IOMMU registers (Requested by one internal reviewer)
> 
> Notes:
> 1. This patch set is ready for extensive testing by the Linux community,
>    for discussion, and hopefully for acceptance into Linux mainstream.
> 2. In order to support this testing, I have left a modest amount of
>    debug print enabled.  For testing, the amount of print can be increased
>    or decreased easily; and for production, can be completely turned-off.
>    Please see the bit-flags in struct 'pr_dbg'
> 
> Testing:
> 1. This patch set was re-tested on the machine that reproduced the problem
>    a. Without this patch set, crashdump console sees a large number of:
>       "dmar: DMAR:[DMA Write] Request device [04:00.0] fault addr fff69000
>       "DMAR:[fault reason 01] Present bit in root entry is clear"
>    b. With this patch set, none of the above messages are seen.
> 2. This patch set has not yet been tested with hardware pass-through enabled.
> 
> 
> Patch 0 file from previous submission:
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
>    using its current buffers until the device drivers in the crashdump kernel
>    initialize and initialize their devices,
> 3. to use different portions of the iova address ranges for the device drivers
>    in the crashdump kernel than the iova ranges that were in-use at the time
>    of the panic.  
> 
> Advantages of this approach:
> 1. All manipulation of the IO-device is done by the Linux device-driver
>    for that device.
> 2. This approach behaves in a manner very similar to operation without an
>    active iommu.
> 3. Any activity between the IO-device and its RMRR areas is handled by the
>    device-driver in the same manner as during a non-kdump boot.
> 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
>    This supports the practice of creating a special kdump kernel without
>    drivers for any devices that are not required for taking a crashdump. 
> 
> Changes since the RFC version of this patch:
> 1. Consolidated all of the operational code into the "copy..." functions.
>    The "process..." functions were primarily used for diagnostics and
>    exploration; however, there was a small amount of operational code that
>    used the "process..." functions.
>    This operational code has been moved into the "copy..." functions.
> 
> 2. Removed the "Process ..." functions and the diagnostic code that ran
>    on that function set.  This removed about 1/4 of the code -- which this
>    operational patch set no longer needs.  These portions of the RFC patch
>    could be formatted as a separate patch and submitted independently
>    at a later date. 
> 
> 3. Re-formatted the code to the Linux Coding Standards.
>    The checkpatch script still finds some lines to complain about;
>    however most of these lines are either (1) lines that I did not change,
>    or (2) lines that only changed by adding a level of indent which pushed
>    them over 80-characters, or (3) new lines whose intent is far clearer when
>    longer than 80-characters.
> 
> 4. Updated the remaining debug print to be significantly more flexible.
>    This allows control over the amount of debug print to the console --
>    which can vary widely.
> 
> 5. Fixed a couple of minor bugs found by testing on a machine with a
>    very large IO configuration.
> 
> At a high level, this code operates primarily during iommu initialization
> and device-driver initialization
> 
> During intel-iommu hardware initialization:
> In intel_iommu_init(void)
> * If (This is the crash kernel)
>   .  Set flag: crashdump_accepting_active_iommu (all changes below check this)
>   .  Skip disabling the iommu hardware translations
> 
> In init_dmars()
> * Duplicate the intel iommu translation tables from the old kernel
>   in the new kernel
>   . The root-entry table, all context-entry tables,
>     and all page-translation-entry tables
>   . The duplicate tables contain updated physical addresses to link them together.
>   . The duplicate tables are mapped into kernel virtual addresses
>     in the new kernel which allows most of the existing iommu code
>     to operate without change.
>   . Do some minimal sanity-checks during the copy
>   . Place the address of the new root-entry structure into "struct intel_iommu"
> 
> * Skip setting-up new domains for 'si', 'rmrr', 'isa' 
>   . Translations for 'rmrr' and 'isa' ranges have been copied from the old kernel
>   . This patch has not yet been tested with iommu pass-through enabled
> 
> * Existing (unchanged) code near the end of dmar_init:
>   . Loads the address of the (now new) root-entry structure from
>     "struct intel_iommu" into the iommu hardware and does the hardware flushes.
>     This changes the active translation tables from the ones in the old kernel
>     to the copies in the new kernel.
>   . This is legal because the translations in the two sets of tables are
>     currently identical:
>       Virtualization Technology for Directed I/O. Architecture Specification,
>       February 2011, Rev. 1.3  (section 11.2, paragraph 2) 
> 
> In iommu_init_domains()
> * Mark as in-use all domain-id's from the old kernel
>   . In case the new kernel contains a device that was not in the old kernel
>     and a new, unused domain-id is actually needed, the bitmap will give us one.
> 
> When a new domain is created for a device:
> * If (this device has a context in the old kernel)
>   . Get domain-id, address-width, and IOVA ranges from the old kernel context;
>   . Get address(page-entry-tables) from the copy in the new kernel;
>   . And apply all of the above values to the new domain structure.
> * Else
>   . Create a new domain as normal
> 
> 
> Bill Sumner (6):
>   Crashdump-Accepting-Active-IOMMU-Flags-and-Prototype
>   Crashdump-Accepting-Active-IOMMU-Utility-functions
>   Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
>   Crashdump-Accepting-Active-IOMMU-Copy-Translations
>   Crashdump-Accepting-Active-IOMMU-Debug-Print-IOMMU
>   Crashdump-Accepting-Active-IOMMU-Call-From-Mainline
> 
>  drivers/iommu/intel-iommu.c | 1292 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 1224 insertions(+), 68 deletions(-)
> 
> -- 
> Bill Sumner <bill.sumner@hp.com>
