Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaJHIzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:55:24 -0400
Received: from ozlabs.org ([103.22.144.67]:39632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaJHIzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:55:20 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v4 0/16] POWER8 Coherent Accelerator device driver
Date: Wed,  8 Oct 2014 19:54:49 +1100
Message-Id: <1412758505-23495-1-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the latest version of the cxl driver.  Change log below:

v4:
 - Updates based on comments from mpe (offline and online).
 - Refactor the sstp lock to be an entry lock.
 - Fixed error paths on new status_mutex in start_work
 - added some missing include files
 - moved associating pid/mm from open() to start_work ioctl.
 - improved IDR setup and destroy
 - fix block comments.
 - remove #undef at top of files
 - wed -> work_element_descriptor on user visible interfaces
 - Lots of documentation updates.
 - Device name changes.
   - No longer has a default dev name /dev/afuM.N for each mode.
   - Dedicated, slave and master all have distinct char devs.
 - Prevent AFU reset when contexts active.
 - Endian bug fix for find_free_sste().
 - Fix locking on reset_store_afu.
 - Make CXL_IOCTL_GET_PROCESS_ELEMENT return a __u32 instead of int.
 - Rename event.afu_err.err to error
 - Fixed master specific sysfs attribute creation
 - fix sparse errors with debugfs.  Was passing iomem ptrs to userspace.

v3:
 - Updates based on comments from mpe, benh, aneesh and offline reviews.
 - Fixed bug freeing AFU IRQs that also freed the multiplexed PSL IRQ
 - Change copro_flush_all_slbs to a static inline as suggested by mpe
 - Implement sanitisation routines to clear out more registers and do full
   adapter wide tlbia and slbia when initialising hardware
 - Add self testcase to msi_bitmap to test allocations are aligned to a power of
   2 and cleanup comment as suggested by mpe
 - Clean up cxl_use_count
 - Split out detach_process_native into two logical functions
 - Improve comment in set_msi_irq_chip as requested by mpe
 - Move cxl functions in pci-ioda.c to be under just one #ifdef CONFIG_CXL_BASE
 - Cleanup hash_page and hash_page_mm from mpes and Aneesh' reviews
 - Remove dead code in cxl_alloc_sst
 - Add timeout in afu_slbia_native
 - Remove cxl backend and driver ops abstractions
   - Removed separate cxl-pci module
   - Merged cxl pci module init calls into main driver init
 - Refactor afu_read() to be a bit simpler and more closely follow exising
   patterns in the kernel
 - Userspace API updates from reviews:
   - Added ioctl to get the process element number, and removed it as a return
     from the start work ioctl
   - Alter cxl_event to have one common header struct
   - Dropped check error ioctl
   - Added current and binary compatible API version numbers to sysfs
   - read() now takes a 4K (or greater) buffer
   - Pack event structs to reduce unecessary reserved fields
     - Event sizes can now differ
     - All event sizes are 64bit multiples to allow future event coalescing
   - Add flags fields to indicate which fields contain valid data
   - Add BUILD_BUG_ONs to protect against inadvertantly changing API without
     bumping version number and/or flags
   - Update documentation
 - Skip CXL SLBIA codepath if CXL is not in use
 - Split cxl_slbia_core into two functions to be easier to read
 - Refactor copro_data_segment (renamed to copro_calc_slb) since we are no
   longer merging with hash_page and cleaned up parameters.
 - Some renames:
   - struct cxl_t -> struct cxl
   - struct cxl_afu_t -> struct cxl_afu
   - struct cxl_context_t -> struct cxl_context
   - copro_data_segment -> copro_calc_slb
   - ctx->ph -> ctx->pe
 - Added ctx->status mutex lock around for start and release context

v2:
 - Updates based on comments from, Anton, Gavin, Aneesh, jk and offline reviews
 - Simplified copro_data_segment() and merged code with hash_page_mm()
    (New patch 10/17)
 - PCIe code simplifications based on Gavin's review
 - Removed redundant comment in msi_bitmap_alloc_hwirqs()
 - Fix for locking in idr_remove in core driver
 - Ensure PSL is enabled when PHB is flipped to CXL mode
 - Added CONFIG_PPC_COPRO_BASE to compile copro_fault.c
 - Merged SPU and cxl slb flushing calls into copro_flush_all_slbs()
    (New patch 03/17)
 - Moved slb_vsid_shift() to static inline from #define
 - Don't write paca->context when demoting segments and mm != current
 - Fix minor typos in documentation

v1:
 - Initial post

This add support for the Coherent Accelerator (cxl) attached to POWER8
processors.  This coherent accelerator interface is designed to allow the
coherent connection of FPGA based accelerators (and other devices) to a POWER
systems.

IBM refers to this as the Coherent Accelerator Processor Interface or CAPI.  In
this driver it's referred to by the name cxl to avoid confusion with the ISDN
CAPI subsystem.

An overview of the patches:
  Patches  1-3:  Split some of the old Cell co-processor code out so it can be
		   reused.
  Patches  4-10: Add infrastructure to arch/powerpc needed by cxl.
  Patches  11:   Add call backs needed for invalidating cxl mm contexts.
  Patch    12:   Add cxl specific support that needs to be built in to the
		   kernel (can't be a module).
  Patches 13-15: Add the majority of the device driver and API header.
  Patch    16:   Documentation.

The documentation in this last patch gives an overview of the hardware
architecture as well as the userspace API.

The cxl driver has a user-space interface described in include/uapi/misc/cxl.h
and Documentation/powerpc/cxl.txt.  There are two ioctls which can be used to
talk to the driver once the new /dev/cxl/afu0.0 device is opened.  This device
can also be read and mmaped.

There's also sysfs entries used to communicate information about the cxl
configuration to userspace.  These are documented in
Documentation/ABI/testing/sysfs-class-cxl.

Many contributed to this device driver but Ian Munsie is the principal author.

Driver can also be found here (based on 3.17-rc5):
   git://github.com/mikey/linux.git cxl
   https://github.com/mikey/linux/commits/cxl
(Series rebases on recent linux-next with one trivial include file conflict)

Please consider for inclusion.  Feedback welcome!

Regards,
Mikey
