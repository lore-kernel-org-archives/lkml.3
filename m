Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3EZP5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:57:09 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58410 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3EZP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:57:06 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3, part2 00/20] Introduce hotplug-safe PCI bus iterators
Date: Sun, 26 May 2013 23:52:57 +0800
Message-Id: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second part of PCI bus lock patch series, it's based on
https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

And the first part of the PCI bus lock patch series could be found at:
http://marc.info/?l=linux-pci&m=136948986401098&w=2

You can access the git tree at:

Introduce hotplug-safe PCI bus iterators as below, which hold a
reference on the returned PCI bus object.
bool pci_bus_exists(int domain, int busnr);
struct pci_bus *pci_get_bus(int domain, int busnr);
struct pci_bus *pci_get_next_bus(struct pci_bus *from);
struct pci_bus *pci_get_next_root_bus(struct pci_bus *from);
#define for_each_pci_bus(b) for (b = NULL; (b = pci_get_next_bus(b)); )
#define for_each_pci_root_bus(b)  \
		for (b = NULL; (b = pci_get_next_root_bus(b)); )

The long-term goal is to remove hotplug-unsafe pci_find_bus(),
pci_find_next_bus() and the global pci_root_buses list.

These new interfaces may be a little slower than existing interfaces,
but it should be acceptable because they are not used on hot paths.

V1->V2:
1) address review comments for V1

Jiang Liu (20):
  PCI: introduce hotplug-safe PCI bus iterators
  PCI, core: use hotplug-safe iterators to walk PCI buses
  PCI, hotplug: use hotplug-safe iterators to walk PCI buses
  PCI, IOV: hold a reference to PCI bus when creating virtual PCI
    devices
  PCI, Alpha: use hotplug-safe iterators to walk PCI buses
  PCI, FRV: use hotplug-safe iterators to walk PCI buses
  PCI, IA64: use hotplug-safe iterators to walk PCI buses
  PCI, Microblaze: use hotplug-safe iterators to walk PCI buses
  PCI, mn10300: use hotplug-safe iterators to walk PCI buses
  PCI, PPC: use hotplug-safe iterators to walk PCI buses
  PCI, SPARC: use hotplug-safe iterators to walk PCI buses
  PCI, x86: use hotplug-safe iterators to walk PCI buses
  PCI, ACPI: use hotplug-safe iterators to walk PCI buses
  PCI, DRM: use hotplug-safe iterators to walk PCI buses
  PCI, EDAC: use hotplug-safe PCI bus iterators to walk PCI buses
  PCI, via-camera: use hotplug-safe iterators to walk PCI buses
  PCI, iommu: use hotplug-safe iterators to walk PCI buses
  PCI, eeepc-laptop: use hotplug-safe iterators to walk PCI buses
  PCI, asus-wmi: use hotplug-safe iterators to walk PCI buses
  PCI, ARM: use hotplug-safe PCI bus iterators to walk PCI buses

 arch/alpha/kernel/pci.c                 |   2 +-
 arch/arm/kernel/bios32.c                |  13 +--
 arch/arm/mach-footbridge/dc21285.c      |  12 ++-
 arch/frv/mb93090-mb00/pci-frv.c         |   5 +-
 arch/frv/mb93090-mb00/pci-vdk.c         |   2 +-
 arch/ia64/hp/common/sba_iommu.c         |   2 +-
 arch/ia64/sn/kernel/io_common.c         |   2 +-
 arch/ia64/sn/pci/tioca_provider.c       |   3 +-
 arch/microblaze/pci/pci-common.c        |   4 +-
 arch/mn10300/unit-asb2305/pci-asb2305.c |   5 +-
 arch/powerpc/kernel/pci-common.c        |   4 +-
 arch/powerpc/kernel/pci_64.c            |  22 ++---
 arch/sparc/kernel/pci.c                 |   4 +-
 arch/x86/pci/acpi.c                     |   3 +-
 arch/x86/pci/common.c                   |   3 +-
 arch/x86/pci/i386.c                     |   9 +-
 arch/x86/pci/irq.c                      |   2 +-
 arch/x86/pci/legacy.c                   |   2 +-
 drivers/acpi/reboot.c                   |   3 +-
 drivers/edac/i7core_edac.c              |   2 +-
 drivers/gpu/drm/drm_fops.c              |   6 +-
 drivers/iommu/amd_iommu.c               |   4 +-
 drivers/iommu/dmar.c                    |   6 +-
 drivers/media/platform/via-camera.c     |  12 ++-
 drivers/pci/hotplug-pci.c               |   2 +-
 drivers/pci/hotplug/ibmphp_core.c       |   8 +-
 drivers/pci/hotplug/ibmphp_ebda.c       |   8 +-
 drivers/pci/hotplug/sgi_hotplug.c       |   3 +-
 drivers/pci/hotplug/shpchp_sysfs.c      |   2 +-
 drivers/pci/iov.c                       |  14 +--
 drivers/pci/pci-sysfs.c                 |   2 +-
 drivers/pci/pci.h                       |   1 +
 drivers/pci/pcie/pme.c                  |   5 +-
 drivers/pci/probe.c                     |  17 ++--
 drivers/pci/search.c                    | 159 ++++++++++++++++++++++++++------
 drivers/pci/setup-bus.c                 |  14 ++-
 drivers/pci/xen-pcifront.c              |   3 +-
 drivers/platform/x86/asus-wmi.c         |   9 +-
 drivers/platform/x86/eeepc-laptop.c     |   5 +-
 include/linux/pci.h                     |  23 ++++-
 40 files changed, 278 insertions(+), 129 deletions(-)

-- 
1.8.1.2

