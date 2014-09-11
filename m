Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaIKOBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:01:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:52776 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaIKOBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:01:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384738222"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part2 v1 00/21] Enable hierarchy irqdomian on x86 platforms
Date: Thu, 11 Sep 2014 22:03:27 +0800
Message-Id: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
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
on x86 platforms. It depends on the first part at:
https://lkml.org/lkml/2014/9/11/101 
And you may access it at:
https://github.com/jiangliu/linux.git irqdomain/p2v1

And there will be a third patch set to convert IOAPIC driver to support
hierarchy irqdomain and clean up code.

The first patch extends irqdomain interfaces to support hierarchy
irqdomain. Hope this interface could be used by other architectures too,
such as ARM/ARM64.
The second patch introduces two helper functions to support stacked
irq_chip.
Patch 3-9 implements an irqdomain to manange CPU interrupt vectors, and
it's the root irqdomain for x86 platforms.
Patch 10-13 converts Intel and AMD interrupt remapping drivers to
support hierarchy irqdomain.
Patch 14-17 converts HPET, MSI and HT_IRQ drivers to support hierarchy
irqdomain.
Patch 18-21 cleans up unsued code in x86 arch and interrupt remapping
drivers.

We have tested this patchset on Intel 32-bit and 64-bit systems. But we
have only done compilation tests for HT_IRQ and AMD interrupt remapping
drivers due to hardware resource limitation. Tests on AMD platforms are
warmly welcomed!

Jiang Liu (21):
  irqdomain: Introduce new interfaces to support hierarchy irqdomains
  genirq: Introduce helper functions to support stacked irq_chip
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
  x86, MSI: Use hierarchy irqdomain to manage MSI interrupts
  x86, irq: Directly call native_compose_msi_msg() for DMAR IRQ
  x86, htirq: Use hierarchy irqdomain to manage Hypertransport
    interrupts
  iommu/vt-d: Clean up unused MSI related code
  iommu/amd: Clean up unused MSI related code
  x86: irq_remapping: Clean up unused MSI related code
  x86, irq: Clean up unused MSI related code and interfaces

 arch/x86/Kconfig                     |    3 +-
 arch/x86/include/asm/hpet.h          |   16 +-
 arch/x86/include/asm/hw_irq.h        |   64 +++++
 arch/x86/include/asm/irq_remapping.h |   66 +++--
 arch/x86/include/asm/pci.h           |    5 -
 arch/x86/include/asm/x86_init.h      |    4 -
 arch/x86/kernel/apic/htirq.c         |  179 +++++++++----
 arch/x86/kernel/apic/io_apic.c       |    3 -
 arch/x86/kernel/apic/msi.c           |  430 +++++++++++++++++++++++--------
 arch/x86/kernel/apic/vector.c        |  158 +++++++++++-
 arch/x86/kernel/hpet.c               |   57 ++---
 arch/x86/kernel/x86_init.c           |    2 -
 arch/x86/platform/uv/uv_irq.c        |   27 +-
 drivers/iommu/amd_iommu.c            |  385 ++++++++++++++++++++++------
 drivers/iommu/amd_iommu_init.c       |    4 +
 drivers/iommu/amd_iommu_proto.h      |    9 +
 drivers/iommu/amd_iommu_types.h      |    5 +
 drivers/iommu/intel_irq_remapping.c  |  468 +++++++++++++++++++++++-----------
 drivers/iommu/irq_remapping.c        |  221 ++++++----------
 drivers/iommu/irq_remapping.h        |   22 +-
 drivers/pci/htirq.c                  |   48 +---
 include/linux/htirq.h                |   22 +-
 include/linux/intel-iommu.h          |    4 +
 include/linux/irq.h                  |    8 +
 include/linux/irqdomain.h            |   60 +++++
 kernel/irq/Kconfig                   |    3 +
 kernel/irq/chip.c                    |   21 ++
 kernel/irq/irqdomain.c               |  349 ++++++++++++++++++++++++-
 28 files changed, 1934 insertions(+), 709 deletions(-)

-- 
1.7.10.4

