Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaKHSKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:10:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:16091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaKHSKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:10:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533014"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 00/38] Enable hierarchy irqdomian on x86 platforms
Date: Sun,  9 Nov 2014 02:13:00 +0800
Message-Id: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
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
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg760868.html
And you may access it at:
https://github.com/jiangliu/linux.git irqdomain/p3v3

It has been tested on Intel 64-bit server and 32-bit laptop. It also
passes Fengguang's 0day tests. Helps are welcomed for testing:
1) Intel MID platform
2) Intel CE or OLPC platforms

Patch 1-3 kills pre_init_apic_IRQ0().
Patch 4-9 convert IOAPIC to use hierarch irqdomain
Patch 10-36 clean up code, unused interfaces etc.
Patch 37-38 introduces a mechanism to configure CPU vector allocation
	policies.

Jiang Liu (37):
  x86, intel-mid, trivial: Refine code syntax for sfi_parse_mtmr()
  x86, irq: Kill unused pre_init_apic_IRQ0()
  x86, irq: Prepare IOAPIC interfaces to support hierarchy irqdomain
  x86, irq: Implement callbacks to enable hierarchy irqdomain on
    IOAPICs
  x86, irq: Refine the way to allocate irq_cfg for legacy IRQs
  x86, irq: Simplify the way to print IOAPIC entry
  x86, irq: Introduce helper functions to support hierarchy irqdomain
    for IOAPIC
  x86, irq: Convert IOAPIC to use hierarchy irqdomain interfaces
  x86, irq: Kill unused old IOAPIC irqdomain interfaces
  x86, irq: Kill unused struct mp_pin_info
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
  x86, irq: Use cached IOAPIC entry instead of reading from hardware
  x86, irq: Kill unused alloc_irq_and_cfg_at()
  x86, irq: Change functions only used in vector.c as static
  x86, irq: Kill function apic_set_affinity()
  x86, irq: Move check of cfg->move_in_progress into
    send_cleanup_vector()
  x86, irq: Move private data in struct irq_cfg into dedicated data
    structure
  x86, irq: Refine the way to calculate NR_IRQS
  ACPI, irq, x86: Kill private function mp_register_gsi()/
    mp_unregister_gsi()
  x86, irq: Introduce mechanism to support different vector allocation
    policies
  x86, irq: Add kernel parameter vector_alloc to set CPU vector
    allocation policy

Thomas Gleixner (1):
  x86, intel-mid: Delay initialization of APB timer

 Documentation/kernel-parameters.txt                |    6 +
 arch/x86/Kconfig                                   |    1 -
 arch/x86/include/asm/hw_irq.h                      |   53 +-
 arch/x86/include/asm/io_apic.h                     |   81 +-
 arch/x86/include/asm/irq_remapping.h               |   36 -
 arch/x86/include/asm/irq_vectors.h                 |   18 +-
 arch/x86/include/asm/x86_init.h                    |   16 -
 arch/x86/kernel/acpi/boot.c                        |   69 +-
 arch/x86/kernel/apb_timer.c                        |    4 -
 arch/x86/kernel/apic/io_apic.c                     | 1071 +++++++++-----------
 arch/x86/kernel/apic/vector.c                      |  416 ++++----
 arch/x86/kernel/devicetree.c                       |   37 +-
 arch/x86/kernel/mpparse.c                          |    6 +-
 arch/x86/kernel/x86_init.c                         |    6 -
 arch/x86/pci/intel_mid_pci.c                       |    6 +-
 .../platform/intel-mid/device_libs/platform_wdt.c  |    5 +-
 arch/x86/platform/intel-mid/intel-mid.c            |   18 +-
 arch/x86/platform/intel-mid/sfi.c                  |   30 +-
 arch/x86/platform/sfi/sfi.c                        |    5 +-
 arch/x86/platform/uv/uv_irq.c                      |    3 +-
 drivers/iommu/amd_iommu.c                          |  153 +--
 drivers/iommu/intel_irq_remapping.c                |  206 +---
 drivers/iommu/irq_remapping.c                      |   84 --
 drivers/iommu/irq_remapping.h                      |   16 -
 24 files changed, 876 insertions(+), 1470 deletions(-)

-- 
1.7.10.4

