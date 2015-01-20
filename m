Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbbATDFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:05:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:61669 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbbATDFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:05:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442528009"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v7 00/38] Convert x86 to hierarchy irqdomain and stacked irqchip
Date: Tue, 20 Jan 2015 11:08:03 +0800
Message-Id: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	The generic hierarchy irqdomain and stacked irqchip implementation
has been merged into v3.19, so this patch set converts x86 interupt
management to hierarchy irqdomain and stacked irqchip. I will send out
another following-on patch set to clean up code and interfaces obseleted
by this patch set.

	This patch set has been reviewed several times and it missed v3.19
merging because several got fixed just before the merging window.
	The main changes since last review are:
1) Rebased the patch set onto v3.19-rc5.
2) Merged bugfixes into the patch introducing the bug so it won't break
   bisecting.

Hi Thomas,
	Rafael needs more time to review the patch set to refine ACPI
resource paring interface, and we are nearing to v3.19-rc6. So it would
be helpful to move onto the x86 hierarchy irqdomain patch set first, so
we may catch up with v3.20 merging window.
Thanks!
Gerry

Jiang Liu (36):
  x86/irq: Save destination CPU ID in irq_cfg
  x86/irq: Use hierarchy irqdomain to manage CPU interrupt vectors
  x86/hpet: Use new irqdomain interfaces to allocate/free IRQ
  x86/MSI: Use new irqdomain interfaces to allocate/free IRQ
  x86/uv: Use new irqdomain interfaces to allocate/free IRQ
  x86/htirq: Use new irqdomain interfaces to allocate/free IRQ
  x86/dmar: Use new irqdomain interfaces to allocate/free IRQ
  irq_remapping: Introduce new interfaces to support hierarchy
    irqdomain
  irq_remapping/vt-d: Change prototypes to prepare for enabling
    hierarchy irqdomain
  irq_remapping/vt-d: Enhance Intel IR driver to suppport hierarchy
    irqdomain
  irq_remapping/amd: Enhance AMD IR driver to suppport hierarchy
    irqdomain
  x86/hpet: Enhance HPET IRQ to support hierarchy irqdomain
  x86/MSI: Use hierarchy irqdomain to manage MSI interrupts
  x86/irq: Directly call native_compose_msi_msg() for DMAR IRQ
  irq_remapping/vt-d: Clean up unused MSI related code
  irq_remapping/amd: Clean up unused MSI related code
  irq_remapping: Clean up unused MSI related code
  x86/MSI: Clean up unused MSI related code and interfaces
  iommu/vt-d: Refine the interfaces to create IRQ for DMAR unit
  x86/irq: Use hierarchy irqdomain to manage DMAR interrupts
  x86/htirq: Use hierarchy irqdomain to manage Hypertransport
    interrupts
  x86/uv: Use hierarchy irqdomain to manage UV interrupts
  x86/irq: Normalize x86 irq_chip name
  x86/MSI: Simplify the way to deal with remapped MSI interrupts
  x86/MSI: Replace msi_update_msg() with irq_chip_compose_msi_msg()
  x86/irq: Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET
    irq_chips
  x86/irq: Simplify MSI/DMAR/HPET implementation by using common code
  irq_remapping: Kill unused function irq_remapping_print_chip()
  x86/intel-mid, trivial: Refine code syntax for sfi_parse_mtmr()
  x86/irq: Kill unused pre_init_apic_IRQ0()
  x86/irq: Prepare IOAPIC interfaces to support hierarchy irqdomain
  x86/irq: Implement callbacks to enable hierarchy irqdomain on IOAPICs
  x86/irq: Refine the way to allocate irq_cfg for legacy IRQs
  x86/irq: Simplify the way to print IOAPIC entry
  x86/irq: Introduce helper functions to support hierarchy irqdomain
    for IOAPIC
  x86/irq: Convert IOAPIC to use hierarchy irqdomain interfaces

Rickard Strandqvist (1):
  x86/apb_timer: Remove unused function is_apbt_capable()

Thomas Gleixner (1):
  x86/intel-mid: Delay initialization of APB timer

 arch/ia64/include/asm/irq_remapping.h              |    2 -
 arch/ia64/kernel/msi_ia64.c                        |   30 +-
 arch/x86/Kconfig                                   |    4 +-
 arch/x86/include/asm/hpet.h                        |   16 +-
 arch/x86/include/asm/hw_irq.h                      |   91 +++
 arch/x86/include/asm/io_apic.h                     |   25 +-
 arch/x86/include/asm/irq_remapping.h               |   45 +-
 arch/x86/include/asm/msi.h                         |    7 +
 arch/x86/include/asm/pci.h                         |    5 -
 arch/x86/include/asm/x86_init.h                    |    4 -
 arch/x86/kernel/acpi/boot.c                        |   20 +-
 arch/x86/kernel/apb_timer.c                        |   12 -
 arch/x86/kernel/apic/htirq.c                       |  173 ++++--
 arch/x86/kernel/apic/io_apic.c                     |  600 +++++++++++++++-----
 arch/x86/kernel/apic/msi.c                         |  416 ++++++++------
 arch/x86/kernel/apic/vector.c                      |  205 ++++++-
 arch/x86/kernel/devicetree.c                       |   37 +-
 arch/x86/kernel/hpet.c                             |   57 +-
 arch/x86/kernel/mpparse.c                          |    6 +-
 arch/x86/kernel/x86_init.c                         |    2 -
 arch/x86/pci/intel_mid_pci.c                       |    6 +-
 .../platform/intel-mid/device_libs/platform_wdt.c  |    5 +-
 arch/x86/platform/intel-mid/intel-mid.c            |   18 +-
 arch/x86/platform/intel-mid/sfi.c                  |   30 +-
 arch/x86/platform/sfi/sfi.c                        |    5 +-
 arch/x86/platform/uv/uv_irq.c                      |  299 ++++------
 drivers/iommu/amd_iommu.c                          |  376 +++++++++---
 drivers/iommu/amd_iommu_init.c                     |    4 +
 drivers/iommu/amd_iommu_proto.h                    |    9 +
 drivers/iommu/amd_iommu_types.h                    |    5 +
 drivers/iommu/dmar.c                               |   19 +-
 drivers/iommu/intel_irq_remapping.c                |  451 ++++++++++-----
 drivers/iommu/irq_remapping.c                      |  178 ++----
 drivers/iommu/irq_remapping.h                      |   20 +-
 drivers/pci/htirq.c                                |   48 +-
 include/linux/dmar.h                               |    3 +-
 include/linux/htirq.h                              |   22 +-
 include/linux/intel-iommu.h                        |    4 +
 38 files changed, 2100 insertions(+), 1159 deletions(-)
 create mode 100644 arch/x86/include/asm/msi.h

-- 
1.7.10.4

