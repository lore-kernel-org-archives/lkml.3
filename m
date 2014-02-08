Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaBHRbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 12:31:38 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:55648 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaBHRbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 12:31:36 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org, jan.kiszka@siemens.com,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: [RFC PATCH v4 00/10] VFIO support for platform devices
Date: Sat,  8 Feb 2014 18:29:30 +0100
Message-Id: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4 of this series is functionally identical to v3 for VFIO_PLATFORM. The only
change is the inclusion of Kim Phillips' patch to expose driver_probe_device()
and the implementation of a binding mechanism for arbitrary devices via a file
in sysfs. The latter has been folded in the skeleton patch (04/10).

This patch series aims to implement VFIO support for platform devices that
reside behind an IOMMU. Examples of such devices are devices behind an ARM SMMU,
or behind a Samsung Exynos System MMU.

The API used is based on the existing VFIO API that is also used with PCI
devices. Only devices that include a basic set of IRQs and memory regions are
targeted; devices with complex relationships with other devices on a device tree
are not taken into account at this stage.

A copy with all the dependencies applied can be cloned from branch
vfio-platform-v4 at git@github.com:virtualopensystems/linux-kvm-arm.git

This code can also be tested on ARM FastModels using the following test cases:
 - A user space implementation via VFIO for the PL330 on the FastModels:
   git@github.com:virtualopensystems/pl330-vfio-test.git
 - A QEMU prototype, also based on the PL330:
   git@github.com:virtualopensystems/qemu.git pl330-vfio-dev

   We have written detailed instructions on how to build and run these tests:
   http://www.virtualopensystems.com/en/solutions/guides/vfio-on-arm/

The following IOCTLs have been found to be working on FastModels with an
ARM SMMU (MMU400). Testing was based on the ARM PL330 DMA Controller featured
on those models.
 - VFIO_GET_API_VERSION
 - VFIO_CHECK_EXTENSION

The TYPE1 fix proposed here enables the following IOCTLs:
 - VFIO_GROUP_GET_STATUS
 - VFIO_GROUP_SET_CONTAINER
 - VFIO_SET_IOMMU
 - VFIO_IOMMU_GET_INFO
 - VFIO_IOMMU_MAP_DMA
     For this ioctl specifically, a new flag has been added:
     VFIO_DMA_MAP_FLAG_EXEC. This flag is taken into account on systems with an
     ARM SMMU.

The VFIO platform driver proposed here implements the following:
 - VFIO_GROUP_GET_DEVICE_FD
 - VFIO_DEVICE_GET_INFO
 - VFIO_DEVICE_GET_REGION_INFO
 - VFIO_DEVICE_GET_IRQ_INFO
 - VFIO_DEVICE_SET_IRQS
     IRQs are implemented partially using this ioctl. Handling incoming
     interrupts with an eventfd is supported, as is masking and unmasking.
     Level sensitive interrupts are automasked. What is not implemented is
     masking/unmasking via eventfd.

In addition, the VFIO platform driver implements the following through
the VFIO device file descriptor:
 - MMAPing memory regions to the virtual address space of the VFIO user.
 - Read / write of memory regions directly through the file descriptor.

What still needs to be done, includes:
 - Eventfd for masking/unmasking
 - Extend the driver and API for device tree metadata
 - QEMU / KVM integration
 - Device specific functionality (e.g. VFIO_DEVICE_RESET)
 - Improve VFIO_IOMMU_TYPE1 driver to support multiple buses at the same time
 - Bind to ARM AMBA devices
 - IOMMUs with nested page tables (Stage 1 & 2 translation on ARM SMMUs)

Changes since v3:
 - Use Kim Phillips' driver_probe_device()
Changes since v2:
 - Fixed Read/Write and MMAP on device regions
 - Removed dependency on Device Tree
 - Interrupts support
 - Interrupt masking/unmasking
 - Automask level sensitive interrupts
 - Introduced VFIO_DMA_MAP_FLAG_EXEC
 - Code clean ups

Antonios Motakis (9):
  VFIO_IOMMU_TYPE1: Introduce the VFIO_DMA_MAP_FLAG_EXEC flag
  VFIO_IOMMU_TYPE1: workaround to build for platform devices
  VFIO_PLATFORM: Initial skeleton of VFIO support for platform devices
  VFIO_PLATFORM: Return info for device and its memory mapped IO regions
  VFIO_PLATFORM: Read and write support for the device fd
  VFIO_PLATFORM: Support MMAP of MMIO regions
  VFIO_PLATFORM: Return IRQ info
  VFIO_PLATFORM: Initial interrupts support
  VFIO_PLATFORM: Support for maskable and automasked interrupts

Kim Phillips (1):
  driver core: export driver_probe_device()

 drivers/base/base.h                           |   1 -
 drivers/base/dd.c                             |   1 +
 drivers/vfio/Kconfig                          |   3 +-
 drivers/vfio/Makefile                         |   1 +
 drivers/vfio/platform/Kconfig                 |   9 +
 drivers/vfio/platform/Makefile                |   4 +
 drivers/vfio/platform/vfio_platform.c         | 493 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_irq.c     | 289 +++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  50 +++
 drivers/vfio/vfio_iommu_type1.c               |  27 +-
 include/linux/device.h                        |   1 +
 include/uapi/linux/vfio.h                     |   2 +
 12 files changed, 874 insertions(+), 7 deletions(-)
 create mode 100644 drivers/vfio/platform/Kconfig
 create mode 100644 drivers/vfio/platform/Makefile
 create mode 100644 drivers/vfio/platform/vfio_platform.c
 create mode 100644 drivers/vfio/platform/vfio_platform_irq.c
 create mode 100644 drivers/vfio/platform/vfio_platform_private.h

-- 
1.8.3.2

