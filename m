Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaDOXJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:09:42 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:6244 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaDOXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:09:30 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH 0/8] Fix crashdump failure caused by legacy DMA/IO
Date: Tue, 15 Apr 2014 17:09:01 -0600
Message-Id: <1397603349-30930-1-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements a fix for:
A kdump problem about DMA that has been discussed for a long time.
That is, when a kernel panics and boots into the kdump kernel, DMA that was
started by the panicked kernel is not stopped before the kdump kernel is booted;
and the kdump kernel disables the IOMMU while this DMA continues.
This causes the IOMMU to stop translating the DMA addresses as IOVAs and
begin to treat them as physical memory addresses -- which causes the DMA to either:
1. generate DMAR errors or
2. generate PCI SERR errors or
3. transfer data to or from incorrect areas of memory.
Often this causes the dump to fail.

This patch set modifies the behavior of the Intel iommu in the crashdump kernel: 
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
5. Minimal code-changes among the existing mainline intel-iommu code.

Summary of changes in this patch set since the previous posting:
1. Returned to the structure of a patch-set
2. Enabled the intel-iommu driver to consist of multiple *.c files
   by moving many of the #defines, prototypes, and inline functions
   into a new file: intel-iommu-private.h (First three patches implement
   only this enhancement -- could be applied independent of the last 5)
3. Moved the new "crashdump fix" code into a new file: intel-iommu-kdump.c 
4. Removed the pr_debug constructs from the new code that implements the
   "crashdump fix" -- making the code much cleaner and easier to read.
5. Miscellaneous cleanups such as enum-values for return-codes.
6. Simplified the code that retrieves the values needed to initialize a new
   domain by using the linked-list of previously-collected values
   instead of stepping back into the tree of translation tables.


Bill Sumner (8):
  Fix a few existing lines that checkpatch.pl will complain about
    later.     #86: FILE: drivers/iommu/intel-iommu.c:390:     +static
    int force_on = 0;
  Consolidate all .h lines at front of intel-iommu.c file     In
    intel-iommu.c, move downward the few lines near the front that
    should     not move to an intel-iommu-private.h file (mostly
    data-item definitions)     This leaves a consolidated block of the
    lines that would move to an     intel-iommu-private.h file at the
    front of the file.
  Create intel-iommu-private.h     Move the single block of #define,
    static inline ... ; struct definitions     to intel-iommu-private.h
    from intel-iommu.c     Replace them with #include
    "intel-iommu-private.h"
  Update iommu_attach_domain() and its callers     Allow specification
    of domain-id for the new domain.
  Add new definitions & prototypes to intel-iommu-private.h     Items
    needed for fixing crashdump.
  Create intel-iommu-kdump.c     Populate with "Copy iommu translation
    tables" function set.     Edit Makefile to add intel-iommu-kdump.o
  Add domain-id functions to intel-iommu-kdump.c    
    intel_iommu_did_to_domain_values_entry()    
    intel_iommu_get_dids_from_old_kernel()
  Add remaining changes to intel-iommu.c to fix crashdump     Add
    "#include <linux/crash_dump.h>"     Chg device_to_domain_id     Chg
    get_domain_for_dev     Chg init_dmars     Chg intel_iommu_init

 drivers/iommu/Makefile              |   2 +-
 drivers/iommu/intel-iommu-kdump.c   | 629 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/intel-iommu-private.h | 443 +++++++++++++++++++++++++
 drivers/iommu/intel-iommu.c         | 565 ++++++++++----------------------
 4 files changed, 1249 insertions(+), 390 deletions(-)
 create mode 100644 drivers/iommu/intel-iommu-kdump.c
 create mode 100644 drivers/iommu/intel-iommu-private.h

-- 
Bill Sumner <bill.sumner@hp.com>

