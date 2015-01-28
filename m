Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbbA1WH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:07:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:49878 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbbA1UU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:20:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677268624"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [Patch v2 00/22] Improve ACPI resource parsing interfaces and enable IOAPIC hotplug
Date: Wed, 28 Jan 2015 18:57:18 +0800
Message-Id: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During enabling ACPI based IOAPIC hotplug, Thomas noticed some issues
in ACPI resource parsing interfaces. So this is an effort to improve them.

Patch 1 refines ACPICA resource descriptors, which has already been
merged into "git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git bleeding-edge"

Patch 2-12 improve ACPI resource parsing interfaces and also fixes some
bugs.

Patch 13-19 try to share the common data structure resource_list_entry
between PCI and ACPI. It may also be shared with PNP too.

Patch 20-22 enable ACPI based IOAPIC hotplug.

The patchset is based on v3.19-rc6+ and passed Fengguang's 0day test
suite. You may get it from:
https://github.com/jiangliu/linux.git acpires_v2

V1->V2:
1) Refine the way to share common code between address space and extended
   address space.
2) Relax some checks to avoid regressions according to Rafael's suggestions.
3) Introduce struct resource_win to avoiding add extra parameter "offset"
   to several interfaces.
4) Add patches to enable ACPI based IOAPIC hotplug, which has been reviwed
   several rounds.
5) Rebase to v3.19-rc6+

Thanks,
Gerry

Jiang Liu (13):
  ACPI: Fix a bug in parsing ACPI Memroy24 resource
  ACPI: Normalize return value of resource parser functions
  ACPI: Set flag IORESOURCE_UNSET for unassigned resources
  ACPI: Enforce stricter checks for address space descriptors
  ACPI: Return translation offset when parsing ACPI address space
    resources
  ACPI: Translate resource into master side address for bridge window
    resources
  ACPI: Add field offset to struct resource_list_entry
  ACPI: Introduce helper function acpi_dev_filter_resource_type()
  resources: Move struct resource_list_entry from ACPI into resource
    core
  PCI: Use common resource list management code instead of private
    implementation
  x86/PCI/ACPI: Use common ACPI resource interfaces to simplify
    implementation
  x86/PCI: Refine the way to release PCI IRQ resources
  x86/irq, ACPI: Implement ACPI driver to support IOAPIC hotplug

Lv Zheng (1):
  ACPICA: Resources: Provide common part for struct
    acpi_resource_address structures.

Thomas Gleixner (7):
  ACPI: Remove redundant check in function
    acpi_dev_resource_address_space()
  ACPI: Implement proper length checks for mem resources
  ACPI: Use the length check for io resources as well
  ACPI: Let the parser return false for disabled resources
  ACPI: Unify the parsing of address_space and ext_address_space
  ACPI: Move the window flag logic to the combined parser
  ACPI: Add prefetch decoding to the address space parser

Yinghai Lu (1):
  ACPI: Add interfaces to parse IOAPIC ID for IOAPIC hotplug

 arch/arm/kernel/bios32.c            |    5 +-
 arch/ia64/kernel/acpi-ext.c         |    6 +-
 arch/ia64/pci/pci.c                 |   14 +-
 arch/x86/include/asm/pci_x86.h      |    2 -
 arch/x86/pci/acpi.c                 |  296 ++++++++++-------------------
 arch/x86/pci/bus_numa.c             |    4 +-
 arch/x86/pci/common.c               |   30 ++-
 arch/x86/pci/intel_mid_pci.c        |    4 +-
 arch/x86/pci/irq.c                  |   15 +-
 arch/x86/pci/mmconfig-shared.c      |    6 +-
 drivers/acpi/Kconfig                |    6 +
 drivers/acpi/Makefile               |    1 +
 drivers/acpi/acpi_lpss.c            |    6 +-
 drivers/acpi/acpi_memhotplug.c      |    8 +-
 drivers/acpi/acpi_platform.c        |    2 +-
 drivers/acpi/acpica/rsaddr.c        |    9 +-
 drivers/acpi/acpica/rsdumpinfo.c    |   59 +++---
 drivers/acpi/acpica/rsxface.c       |   10 +-
 drivers/acpi/internal.h             |    7 +
 drivers/acpi/ioapic.c               |  225 ++++++++++++++++++++++
 drivers/acpi/pci_irq.c              |    9 +-
 drivers/acpi/pci_root.c             |    9 +-
 drivers/acpi/processor_core.c       |  123 +++++++++++-
 drivers/acpi/resource.c             |  349 +++++++++++++++++++++--------------
 drivers/char/hpet.c                 |    4 +-
 drivers/dma/acpi-dma.c              |    8 +-
 drivers/hv/vmbus_drv.c              |    4 +-
 drivers/pci/bus.c                   |   18 +-
 drivers/pci/host-bridge.c           |    8 +-
 drivers/pci/host/pci-host-generic.c |    4 +-
 drivers/pci/host/pci-xgene.c        |    4 +-
 drivers/pci/host/pcie-xilinx.c      |    4 +-
 drivers/pci/probe.c                 |   10 +-
 drivers/pnp/pnpacpi/rsparser.c      |   45 ++---
 drivers/xen/xen-acpi-memhotplug.c   |    8 +-
 include/acpi/acrestyp.h             |   40 ++--
 include/linux/acpi.h                |   22 ++-
 include/linux/pci.h                 |    9 +-
 include/linux/resource_ext.h        |   77 ++++++++
 kernel/resource.c                   |   25 +++
 40 files changed, 964 insertions(+), 531 deletions(-)
 create mode 100644 drivers/acpi/ioapic.c
 create mode 100644 include/linux/resource_ext.h

-- 
1.7.10.4

