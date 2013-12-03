Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3LCTmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:42:46 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37889 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LCTmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:42:44 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com
Subject: [PATCH 0/6] Crashdump Accepting Active IOMMU
Date: Tue,  3 Dec 2013 12:41:28 -0700
Message-Id: <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <Crashdump-Accepting-Active-IOMMU>
References: <Crashdump-Accepting-Active-IOMMU>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following series implements a fix for:
A kdump problem about DMA that has been discussed for a long time. That is,
when a kernel panics and boots into the kdump kernel, DMA started by the 
panicked kernel is not stopped before the kdump kernel is booted and the 
kdump kernel disables the IOMMU while this DMA continues.  This causes the
IOMMU to stop translating the DMA addresses as IOVAs and begin to treat them 
as physical memory addresses -- which causes the DMA to either:
(1) generate DMAR errors or (2) generate PCI SERR errors or (3) transfer  
data to or from incorrect areas of memory. Often this causes the dump to fail.

This patch set modifies the behavior of the iommu in the (new) crashdump kernel: 
1. to accept the iommu hardware in an active state, 
2. to leave the current translations in-place so that legacy DMA will continue
   using its current buffers until the device drivers in the crashdump kernel
   initialize and initialize their devices,
3. to use different portions of the iova address ranges for the device drivers
   in the crashdump kernel than the iova ranges that were in-use at the time
   of the panic.  

Advantages of this approach:
1. All manipulation of the IO-device is done by the Linux device-driver
   for that device.
2. This approach behaves in a manner very similar to operation without an
   active iommu.
3. Any activity between the IO-device and its RMRR areas is handled by the
   device-driver in the same manner as during a non-kdump boot.
4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
   This supports the practice of creating a special kdump kernel without
   drivers for any devices that are not required for taking a crashdump. 

Changes since the RFC version of this patch:
1. Consolidated all of the operational code into the "copy..." functions.
   The "process..." functions were primarily used for diagnostics and
   exploration; however, there was a small amount of operational code that
   used the "process..." functions.
   This operational code has been moved into the "copy..." functions.

2. Removed the "Process ..." functions and the diagnostic code that ran
   on that function set.  This removed about 1/4 of the code -- which this
   operational patch set no longer needs.  These portions of the RFC patch
   could be formatted as a separate patch and submitted independently
   at a later date. 

3. Re-formatted the code to the Linux Coding Standards.
   The checkpatch script still finds some lines to complain about;
   however most of these lines are either (1) lines that I did not change,
   or (2) lines that only changed by adding a level of indent which pushed
   them over 80-characters, or (3) new lines whose intent is far clearer when
   longer than 80-characters.

4. Updated the remaining debug print to be significantly more flexible.
   This allows control over the amount of debug print to the console --
   which can vary widely.

5. Fixed a couple of minor bugs found by testing on a machine with a
   very large IO configuration.

At a high level, this code operates primarily during iommu initialization
and device-driver initialization

During intel-iommu hardware initialization:
In intel_iommu_init(void)
* If (This is the crash kernel)
  .  Set flag: crashdump_accepting_active_iommu (all changes below check this)
  .  Skip disabling the iommu hardware translations

In init_dmars()
* Duplicate the intel iommu translation tables from the old kernel
  in the new kernel
  . The root-entry table, all context-entry tables,
    and all page-translation-entry tables
  . The duplicate tables contain updated physical addresses to link them together.
  . The duplicate tables are mapped into kernel virtual addresses
    in the new kernel which allows most of the existing iommu code
    to operate without change.
  . Do some minimal sanity-checks during the copy
  . Place the address of the new root-entry structure into "struct intel_iommu"

* Skip setting-up new domains for 'si', 'rmrr', 'isa' 
  . Translations for 'rmrr' and 'isa' ranges have been copied from the old kernel
  . This patch has not yet been tested with iommu pass-through enabled

* Existing (unchanged) code near the end of dmar_init:
  . Loads the address of the (now new) root-entry structure from
    "struct intel_iommu" into the iommu hardware and does the hardware flushes.
    This changes the active translation tables from the ones in the old kernel
    to the copies in the new kernel.
  . This is legal because the translations in the two sets of tables are
    currently identical:
      Virtualization Technology for Directed I/O. Architecture Specification,
      February 2011, Rev. 1.3  (section 11.2, paragraph 2) 

In iommu_init_domains()
* Mark as in-use all domain-id's from the old kernel
  . In case the new kernel contains a device that was not in the old kernel
    and a new, unused domain-id is actually needed, the bitmap will give us one.

When a new domain is created for a device:
* If (this device has a context in the old kernel)
  . Get domain-id, address-width, and IOVA ranges from the old kernel context;
  . Get address(page-entry-tables) from the copy in the new kernel;
  . And apply all of the above values to the new domain structure.
* Else
  . Create a new domain as normal

--- 
Signed-off-by: Bill Sumner <bill.sumner@hp.com>

Bill Sumner (6):
  Crashdump-Accepting-Active-IOMMU-Flags-and-Prototypes
  Crashdump-Accepting-Active-IOMMU-Utility-functions
  Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
  Crashdump-Accepting-Active-IOMMU-Copy-Translations
  Crashdump-Accepting-Active-IOMMU-Debug-Print-IOMMU
  Crashdump-Accepting-Active-IOMMU-Call-From-Mainline

 drivers/iommu/intel-iommu.c | 1292 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 1224 insertions(+), 68 deletions(-)

-- 
Bill Sumner <bill.sumner@hp.com>

