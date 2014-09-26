Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbaIZOza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:55:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:3489 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbaIZOz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:55:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597291895"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Part3 v1 00/28] Enable hierarchy irqdomian on x86 platforms
Date: Fri, 26 Sep 2014 22:57:30 +0800
Message-Id: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last part to enable support of hierarchy domain on x86
platforms.

It first converts IOAPIC to support hierarchy irqdomain, then cleans
up all unused code and interfaces. It also introduces a kernel boot
parameter to configure CPU vector allocation policies.

It's based on my previous patch set at:
https://lkml.org/lkml/2014/9/26/538
And you may access it at:
https://github.com/jiangliu/linux.git irqdomain/p3v1

It has been tested on Intel 64-bit server and 32-bit laptop. It also
passes Fengguang's 0day tests. Helps are welcomed for testing:
1) Intel MID platform
2) Intel CE or OLPC platforms

Patch 1-6 convert IOAPIC to support hierarchy irqdomain.
Patch 7-16,22 clean up unused code, x86_io_apic_ops and header files.
Patch 17-20 simplify struct irq_cfg.
Patch 21, 23-26 clean up code and interfaces further.
Patch 27-28 introduces a mechanism to configure CPU vector allocation
	policies.

Jiang Liu (28):
  x86, irq: Kill unused setup_timer_IRQ0_pin()
  x86, irq: Prepare IOAPIC interfaces to support hierarchy irqdomain
  x86, irq: Implement callbacks to enable hierarchy irqdomain on
    IOAPICs
  x86, irq: Refine the way to allocate irq_cfg for legacy IRQs
  x86, irq: Convert IOAPIC to use hierarchy irqdomain interfaces
  x86, irq: Kill unused old IOAPIC irqdomain interfaces
  x86, irq: Kill x86_io_apic_ops.print_entries and related interfaces
  x86, irq: Kill x86_io_apic_ops.setup_entry and related interfaces
  x86, irq: Kill x86_io_apic_ops.set_affinity and related interfaces
  x86, irq: Kill x86_io_apic_ops.eoi_ioapic_pin and related interfaces
  x86, irq: Kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
  x86: Clean up unused forward declarations in x86_init.h
  x86: irq_remapping: Clean up unsued code
  iommu/vt-d: Clean up unsued code
  iommu/amd: Clean up unsued code
  x86: irq_remapping: Clean up unused interfaces
  x86, irq: Kill irq_cfg.irq_remapped
  iommu/vt-d: Move struct irq_2_iommu into intel_irq_remapping.c
  iommu/amd: Move struct irq_2_irte into amd_iommu.c
  x86, irq: Move irq_cfg.irq_2_pin into io_apic.c
  x86, irq: Kill struct io_apic_irq_attr
  x86, irq: Kill x86_io_apic_ops.write and x86_io_apic_ops.modify
  x86, irq: Clean up io_apic.h
  x86, irq: Kill unused alloc_irq_and_cfg_at()
  x86, irq: Change functions only used in vector.c as static
  x86, irq: Kill function apic_set_affinity()
  x86, irq: Introduce mechanism to support different vector allocation
    policies
  x86, irq: Add kernel parameter vector_alloc to set CPU vector
    allocation policy

 Documentation/kernel-parameters.txt                |    6 +
 arch/x86/Kconfig                                   |    1 -
 arch/x86/include/asm/hw_irq.h                      |   50 +-
 arch/x86/include/asm/io_apic.h                     |   81 +-
 arch/x86/include/asm/irq_remapping.h               |   36 -
 arch/x86/include/asm/x86_init.h                    |   16 -
 arch/x86/kernel/acpi/boot.c                        |   19 +-
 arch/x86/kernel/apic/io_apic.c                     |  926 +++++++++++---------
 arch/x86/kernel/apic/vector.c                      |  226 ++---
 arch/x86/kernel/devicetree.c                       |   39 +-
 arch/x86/kernel/mpparse.c                          |    6 +-
 arch/x86/kernel/x86_init.c                         |    6 -
 arch/x86/pci/intel_mid_pci.c                       |    6 +-
 .../platform/intel-mid/device_libs/platform_wdt.c  |    5 +-
 arch/x86/platform/intel-mid/intel-mid.c            |    2 +
 arch/x86/platform/intel-mid/sfi.c                  |    6 +-
 arch/x86/platform/sfi/sfi.c                        |    5 +-
 drivers/iommu/amd_iommu.c                          |  150 +---
 drivers/iommu/intel_irq_remapping.c                |  202 +----
 drivers/iommu/irq_remapping.c                      |   84 --
 drivers/iommu/irq_remapping.h                      |   16 -
 21 files changed, 709 insertions(+), 1179 deletions(-)

-- 
1.7.10.4

