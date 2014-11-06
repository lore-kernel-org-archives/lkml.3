Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaKFOR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:17:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:57371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaKFORz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:17:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="618221356"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch Part2 v5 00/31] Enable hierarchy irqdomian on x86 platforms
Date: Thu,  6 Nov 2014 22:20:13 +0800
Message-Id: <1415283644-2559-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to restructure x86 interrupt code based on hierarchy irqdomain,
that is to build irqdomains for CPU vector, interrupt remapping unit,
IOAPIC, MSI and HPET etc and organize those irqdomains in hierarchy mode.
Each irqdomain manages corresponding interrupt controller and talks to
parent interrupt controller through public irqdomain interfaces. We also
support stacked irq_chip based on hierarchy irqdomain. It will make the
x86 interrupt architecture much more clear and more easy to maintain
with hierarchy irqdomain and stacked irq_chip. It may also help ARM
interrupt management architecture too.

This is the second patch set to enable support of hierarchy irqdomain
on x86 platforms. It's based on tip/x86/apic branch.
And you may access it at:
https://github.com/jiangliu/linux.git irqdomain/p2v5

And there will be a third patch set to convert IOAPIC driver to support
hierarchy irqdomain and clean up code.

Patch 1-5 enhance irqdomain and irq core to support hierarchy irqdomain
and stacked irqchip.
Patch 6-12 implement an irqdomain to manange CPU interrupt vectors, and
it's the root irqdomain for x86 platforms.
Patch 13-16 converts Intel and AMD interrupt remapping drivers to
support hierarchy irqdomain.
Patch 17-23 converts HPET and MSI to support hierarchy irqdomain.
Patch 24-27 cleans up unsued code in x86 arch and interrupt remapping
drivers.
Patch 28-31 converts DMAR, HTIRQ and UV to support hierarchy irqdomain.

We have tested this patchset on Intel 32-bit and 64-bit systems. And it
also passes Fengguang's 0day tests. But helps are need for testing:
1) AMD HT_IRQ
2) UV platform

V4->V5:
1) Refine PCI MSI interfaces to support hierarchy irqdomain
2) Fix a bug with dealing multiple MSI interrupts
3) Improve commit messages
V3->V4:
1) Simplify IRQ remapping interfaces
2) Hide all IRQ remapping logic from MSI/HPET drivers
3) Move most MSI irqdomain code to public drivers/pci/msi.c so it could
   be resued
4) Improve common PCI MSI code
5) Rebase to tip/x86/apic
V2->V3:
1) Fix bugs in handling OF irqdomain
2) Add documentation
3) Rebase to v3.18-rc2
V1->V2
1) Add hierarchy iredomain support of DMAR IRQ and UV IRQ.
2) Fix bugs reported by Joe C.
3) Address all review comments from Thomas
4) Fix a bug found during tests
5) Fix errors and warning found by 0day tests

Jiang Liu (30):
  irqdomain: Introduce new interfaces to support hierarchy irqdomains
  genirq: Introduce helper functions to support stacked irq_chip
  genirq: Introduce irq_chip.irq_compose_msi_msg() to support stacked
    irqchip
  genirq: Add IRQ_SET_MASK_OK_DONE to support stacked irqchip
  x86, irq: Save destination CPU ID in irq_cfg
  x86, irq: Use hierarchy irqdomain to manage CPU interrupt vectors
  x86, hpet: Use new irqdomain interfaces to allocate/free IRQ
  x86, MSI: Use new irqdomain interfaces to allocate/free IRQ
  x86, uv: Use new irqdomain interfaces to allocate/free IRQ
  x86, htirq: Use new irqdomain interfaces to allocate/free IRQ
  x86, dmar: Use new irqdomain interfaces to allocate/free IRQ
  x86: irq_remapping: Introduce new interfaces to support hierarchy
    irqdomain
  iommu/vt-d: Change prototypes to prepare for enabling hierarchy
    irqdomain
  iommu/vt-d: Enhance Intel IR driver to suppport hierarchy irqdomain
  iommu/amd: Enhance AMD IR driver to suppport hierarchy irqdomain
  x86, hpet: Enhance HPET IRQ to support hierarchy irqdomain
  PCI/MSI: Remove unnecessary braces around single statements
  PCI/MSI: Simplify PCI MSI code by initializing msi_desc.nvec_used
    earlier
  PCI/MSI: Kill redundant call of irq_set_msi_desc() for MSI-X
    interrupts
  PCI/MSI: Enhance core to support hierarchy irqdomain
  x86, PCI, MSI: Use hierarchy irqdomain to manage MSI interrupts
  x86, irq: Directly call native_compose_msi_msg() for DMAR IRQ
  iommu/vt-d: Clean up unused MSI related code
  iommu/amd: Clean up unused MSI related code
  x86: irq_remapping: Clean up unused MSI related code
  x86, irq: Clean up unused MSI related code and interfaces
  iommu/vt-d: Refine the interfaces to create IRQ for DMAR unit
  x86, irq: Use hierarchy irqdomain to manage DMAR interrupts
  x86, htirq: Use hierarchy irqdomain to manage Hypertransport
    interrupts
  x86, uv: Use hierarchy irqdomain to manage UV interrupts

Yingjoe Chen (1):
  irqdomain: Do irq_find_mapping and set_type for hierarchy irqdomain
    in case OF

 Documentation/IRQ-domain.txt          |   71 +++++
 arch/ia64/include/asm/irq_remapping.h |    2 -
 arch/ia64/kernel/msi_ia64.c           |   30 ++-
 arch/x86/Kconfig                      |    4 +-
 arch/x86/include/asm/hpet.h           |   16 +-
 arch/x86/include/asm/hw_irq.h         |   87 ++++++
 arch/x86/include/asm/irq_remapping.h  |   50 ++--
 arch/x86/include/asm/pci.h            |    5 -
 arch/x86/include/asm/x86_init.h       |    4 -
 arch/x86/kernel/apic/htirq.c          |  174 ++++++++----
 arch/x86/kernel/apic/io_apic.c        |    3 -
 arch/x86/kernel/apic/msi.c            |  422 ++++++++++++++++++++----------
 arch/x86/kernel/apic/vector.c         |  165 +++++++++++-
 arch/x86/kernel/hpet.c                |   57 ++--
 arch/x86/kernel/x86_init.c            |    2 -
 arch/x86/platform/uv/uv_irq.c         |  299 ++++++++-------------
 drivers/iommu/amd_iommu.c             |  378 +++++++++++++++++++++------
 drivers/iommu/amd_iommu_init.c        |    4 +
 drivers/iommu/amd_iommu_proto.h       |    9 +
 drivers/iommu/amd_iommu_types.h       |    5 +
 drivers/iommu/dmar.c                  |   19 +-
 drivers/iommu/intel_irq_remapping.c   |  465 ++++++++++++++++++++++-----------
 drivers/iommu/irq_remapping.c         |  197 ++++----------
 drivers/iommu/irq_remapping.h         |   20 +-
 drivers/pci/Kconfig                   |    4 +
 drivers/pci/htirq.c                   |   48 +---
 drivers/pci/msi.c                     |  184 ++++++++++---
 include/linux/dmar.h                  |    3 +-
 include/linux/htirq.h                 |   22 +-
 include/linux/intel-iommu.h           |    4 +
 include/linux/irq.h                   |   19 ++
 include/linux/irqdomain.h             |   86 ++++++
 include/linux/msi.h                   |   14 +
 kernel/irq/Kconfig                    |    4 +
 kernel/irq/chip.c                     |   37 +++
 kernel/irq/irqdomain.c                |  408 +++++++++++++++++++++++++++--
 kernel/irq/manage.c                   |    2 +
 37 files changed, 2327 insertions(+), 996 deletions(-)

-- 
1.7.10.4

