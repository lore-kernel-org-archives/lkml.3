Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaIRI1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:27:17 -0400
Received: from ozlabs.org ([103.22.144.67]:41916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaIRI1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:27:14 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 0/15] POWER8 Coherent Accelerator device driver
Date: Thu, 18 Sep 2014 18:26:45 +1000
Message-Id: <1411028820-29933-1-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add support for the Coherent Accelerator (cxl) attached to POWER8
processors.  This coherent accelerator interface is designed to allow the
coherent connection of FPGA based accelerators (and other devices) to a POWER
systems.

IBM refers to this as the Coherent Accelerator Processor Interface or CAPI.  In
this driver it's referred to by the name cxl to avoid confusion with the ISDN
CAPI subsystem.

An overview of the patches:
  Patches  1-2:  Split some of the old Cell co-processor code out so it can be
		   reused.
  Patches  3-9:  Add infrastructure to arch/powerpc needed by cxl.
  Patches  10:   Add call backs needed for invalidating cxl mm contexts.
  Patch    11:   Add cxl specific support that needs to be built in to the
		   kernel (can't be a module).
  Patches 12-15: Add the majority of the device driver and API header.
  Patch    15:   Documentation.

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

Please consider for inclusion.  Feedback welcome!

Regards,
Mikey

 Documentation/ABI/testing/sysfs-class-cxl      | 125 ++++
 Documentation/ioctl/ioctl-number.txt           |   1 +
 Documentation/powerpc/00-INDEX                 |   2 +
 Documentation/powerpc/cxl.txt                  | 310 ++++++++
 MAINTAINERS                                    |   7 +
 arch/powerpc/include/asm/copro.h               |  18 +
 arch/powerpc/include/asm/mmu-hash64.h          |   3 +
 arch/powerpc/include/asm/opal.h                |   2 +
 arch/powerpc/include/asm/pnv-pci.h             |  27 +
 arch/powerpc/include/asm/spu.h                 |   5 +-
 arch/powerpc/mm/Makefile                       |   2 +
 arch/powerpc/mm/copro_fault.c                  | 140 ++++
 arch/powerpc/mm/hash_native_64.c               |   6 +-
 arch/powerpc/mm/hash_utils_64.c                |  25 +-
 arch/powerpc/mm/slb.c                          |   3 -
 arch/powerpc/mm/slice.c                        |   3 +
 arch/powerpc/platforms/cell/Makefile           |   2 +-
 arch/powerpc/platforms/cell/spu_base.c         |  41 +-
 arch/powerpc/platforms/cell/spu_fault.c        |  94 ---
 arch/powerpc/platforms/cell/spufs/fault.c      |   4 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S |   1 +
 arch/powerpc/platforms/powernv/pci-ioda.c      | 229 +++++-
 arch/powerpc/sysdev/msi_bitmap.c               |  18 +-
 drivers/misc/Kconfig                           |   1 +
 drivers/misc/Makefile                          |   1 +
 drivers/misc/cxl/Kconfig                       |  25 +
 drivers/misc/cxl/Makefile                      |   4 +
 drivers/misc/cxl/base.c                        | 102 +++
 drivers/misc/cxl/context.c                     | 169 +++++
 drivers/misc/cxl/cxl-pci.c                     | 977 +++++++++++++++++++++++++
 drivers/misc/cxl/cxl.h                         | 605 +++++++++++++++
 drivers/misc/cxl/debugfs.c                     | 116 +++
 drivers/misc/cxl/fault.c                       | 298 ++++++++
 drivers/misc/cxl/file.c                        | 503 +++++++++++++
 drivers/misc/cxl/irq.c                         | 405 ++++++++++
 drivers/misc/cxl/main.c                        | 238 ++++++
 drivers/misc/cxl/native.c                      | 649 ++++++++++++++++
 drivers/misc/cxl/sysfs.c                       | 348 +++++++++
 include/misc/cxl.h                             |  34 +
 include/uapi/Kbuild                            |   1 +
 include/uapi/misc/Kbuild                       |   2 +
 include/uapi/misc/cxl.h                        |  88 +++
 42 files changed, 5463 insertions(+), 171 deletions(-)
