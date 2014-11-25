Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaKYFui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:50:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:64065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaKYFuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:50:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,453,1413270000"; 
   d="scan'208";a="627797293"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v6 00/27] Enable hierarchy irqdomian on x86 platforms
Date: Tue, 25 Nov 2014 13:53:09 +0800
Message-Id: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
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
with hierarchy irqdomain and stacked irq_chip.

This is the second patch set to enable support of hierarchy irqdomain
on x86 platforms. It's based on tip/x86/apic branch and IOMMU x86/vt-d
branch at:
https://git.kernel.org/cgit/linux/kernel/git/joro/iommu.git/ x86/vt-d

You may access it at:
https://github.com/jiangliu/linux.git irqdomain/p2v6

There will aslo be a third patch set to convert IOAPIC driver to support
hierarchy irqdomain and clean up code.

We have tested this patchset on Intel 32-bit and 64-bit systems. Joerg has
helped to test it on AMD platforms. It also passes Fengguang's 0day tests.
Helps are still needed for testings on:
1) AMD HT_IRQ
2) UV platform
3) Intel MID platforms

Patch 1-7 introduce vector domain to manage CPU vectors and convert
	PCI MSI/HPET/DMAT etc to use vector domain.
Patch 8-11 introduce new irq_remapping interfaces to support hierarchy
	irqdomain.
Patch 12-14, 19-20, 24-27 convert PCI MSI/HPET/DMAR to use new hierarchy
	irqdomain framework.
Patch 15-18 clean up old irq_remapping interfaces to support PCI MSI and
	HPET interrupts.
Patch 21-22 convert HT_IRQ and UV platform to use new hierarchy irqdomain.
Patch 23 normalizes irqchip names on x86 platforms.

V5->V6:
1) Common hierarchy irqdomian code has been moved into tip/irq/irqdomain
2) Rebase onto tip/irq/irqdomain and iommu/x86/vt-d
3) Convert PCI MSI/HPET/DMAR to use the new generic MSI framework
4) Fix bugs and conflicts when merging with IOMMU hotplug code
5) More code cleanups
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

Jiang Liu (27):
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
  x86, irq: Normalize x86 irq_chip name
  x86, PCI/MSI: Simplify the way to deal with remapped MSI interrupts
  PCI/MSI: Replace msi_update_msg() with irq_chip_compose_msi_msg()
  x86, irq: Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET
    irq_chips
  x86, irq: Simplify MSI/DMAR/HPET implementation by using common code

 arch/ia64/include/asm/irq_remapping.h |    2 -
 arch/ia64/kernel/msi_ia64.c           |   30 ++-
 arch/x86/Kconfig                      |    4 +-
 arch/x86/include/asm/hpet.h           |   16 +-
 arch/x86/include/asm/hw_irq.h         |   91 +++++++
 arch/x86/include/asm/irq_remapping.h  |   47 ++--
 arch/x86/include/asm/msi.h            |    7 +
 arch/x86/include/asm/pci.h            |    5 -
 arch/x86/include/asm/x86_init.h       |    4 -
 arch/x86/kernel/apic/htirq.c          |  173 +++++++++----
 arch/x86/kernel/apic/io_apic.c        |    3 -
 arch/x86/kernel/apic/msi.c            |  420 +++++++++++++++++-------------
 arch/x86/kernel/apic/vector.c         |  165 +++++++++++-
 arch/x86/kernel/hpet.c                |   57 ++---
 arch/x86/kernel/x86_init.c            |    2 -
 arch/x86/platform/uv/uv_irq.c         |  298 ++++++++--------------
 drivers/iommu/amd_iommu.c             |  378 ++++++++++++++++++++-------
 drivers/iommu/amd_iommu_init.c        |    4 +
 drivers/iommu/amd_iommu_proto.h       |    9 +
 drivers/iommu/amd_iommu_types.h       |    5 +
 drivers/iommu/dmar.c                  |   19 +-
 drivers/iommu/intel_irq_remapping.c   |  453 +++++++++++++++++++++++----------
 drivers/iommu/irq_remapping.c         |  191 ++++----------
 drivers/iommu/irq_remapping.h         |   20 +-
 drivers/pci/htirq.c                   |   48 +---
 include/linux/dmar.h                  |    3 +-
 include/linux/htirq.h                 |   22 +-
 include/linux/intel-iommu.h           |    4 +
 28 files changed, 1523 insertions(+), 957 deletions(-)
 create mode 100644 arch/x86/include/asm/msi.h

-- 
1.7.10.4

