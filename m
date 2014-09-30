Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaI3Kfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:35:37 -0400
Received: from ozlabs.org ([103.22.144.67]:56200 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaI3Kff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:35 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 0/17] POWER8 Coherent Accelerator device driver
Date: Tue, 30 Sep 2014 20:34:49 +1000
Message-Id: <1412073306-13812-1-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
  Patches  4-11: Add infrastructure to arch/powerpc needed by cxl.
  Patches  12:   Add call backs needed for invalidating cxl mm contexts.
  Patch    13:   Add cxl specific support that needs to be built in to the
		   kernel (can't be a module).
  Patches 14-16: Add the majority of the device driver and API header.
  Patch    17:   Documentation.

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

 Documentation/ABI/testing/sysfs-class-cxl      | 125 ++++
 Documentation/ioctl/ioctl-number.txt           |   1 +
 Documentation/powerpc/00-INDEX                 |   2 +
 Documentation/powerpc/cxl.txt                  | 310 ++++++++
 MAINTAINERS                                    |   7 +
 arch/powerpc/Kconfig                           |   4 +
 arch/powerpc/include/asm/copro.h               |  24 +
 arch/powerpc/include/asm/mmu-hash64.h          |  10 +-
 arch/powerpc/include/asm/opal.h                |   2 +
 arch/powerpc/include/asm/pnv-pci.h             |  27 +
 arch/powerpc/include/asm/spu.h                 |   5 +-
 arch/powerpc/mm/Makefile                       |   1 +
 arch/powerpc/mm/copro_fault.c                  | 124 ++++
 arch/powerpc/mm/hash_native_64.c               |   6 +-
 arch/powerpc/mm/hash_utils_64.c                |  95 ++-
 arch/powerpc/mm/slb.c                          |   3 -
 arch/powerpc/mm/slice.c                        |  10 +-
 arch/powerpc/platforms/cell/Kconfig            |   1 +
 arch/powerpc/platforms/cell/Makefile           |   2 +-
 arch/powerpc/platforms/cell/spu_base.c         |  41 +-
 arch/powerpc/platforms/cell/spu_fault.c        |  94 ---
 arch/powerpc/platforms/cell/spufs/fault.c      |   4 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S |   1 +
 arch/powerpc/platforms/powernv/pci-ioda.c      | 204 +++++-
 arch/powerpc/sysdev/msi_bitmap.c               |  23 +-
 drivers/misc/Kconfig                           |   1 +
 drivers/misc/Makefile                          |   1 +
 drivers/misc/cxl/Kconfig                       |  26 +
 drivers/misc/cxl/Makefile                      |   4 +
 drivers/misc/cxl/base.c                        | 102 +++
 drivers/misc/cxl/context.c                     | 171 +++++
 drivers/misc/cxl/cxl-pci.c                     | 964 +++++++++++++++++++++++++
 drivers/misc/cxl/cxl.h                         | 605 ++++++++++++++++
 drivers/misc/cxl/debugfs.c                     | 116 +++
 drivers/misc/cxl/fault.c                       | 298 ++++++++
 drivers/misc/cxl/file.c                        | 503 +++++++++++++
 drivers/misc/cxl/irq.c                         | 405 +++++++++++
 drivers/misc/cxl/main.c                        | 238 ++++++
 drivers/misc/cxl/native.c                      | 649 +++++++++++++++++
 drivers/misc/cxl/sysfs.c                       | 348 +++++++++
 include/misc/cxl.h                             |  34 +
 include/uapi/Kbuild                            |   1 +
 include/uapi/misc/Kbuild                       |   2 +
 include/uapi/misc/cxl.h                        |  88 +++
 44 files changed, 5469 insertions(+), 213 deletions(-)
