Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaEPIDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:03:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:12263 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbaEPIDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:03:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540106037"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org
Subject: [RFC Patch Part1 V1 00/30] use irqdomain to dynamically allocate IRQ for IOAPIC pin
Date: Fri, 16 May 2014 16:05:20 +0800
Message-Id: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 platforms, IRQ number are statically allocated to IOAPIC pins at boot.
There are two issues with this design. First it causes trouble to IOAPIC
hotplug because we need to allocate a block of IRQ numbers for each IOAPIC.
Second it may waste IRQ nubmers even if some IOAPIC pins are not used because
IRQ numbers are statically assigned.

This patchset tries to enable dynamic IRQ number allocation for IOAPIC
by adopting the irqdomain framework, it solves the two issues mentioned
above. It also simplifies the IOAPIC driver by consolidating ways to
program IOAPIC pins with the irqdomain map interface.

We will enhance the IOAPIC driver core to support ACPI based IOAPIC hotplug
once the IOAPIC driver has been converted to irqdomain.

This patchset applies to v3.15-rc4-260-g38583f095c5a and has been tested
on a two socket 64 bit Intel platforms with:
1) ACPI and mpparse enabled (boot successfully)
2) Mpparse enabled with ACPI disabled (boot successfully)
3) ACPI enabled with Mpparse disabled (boot successfully)

It also builds successfully (but without booting due to hardware resource
constraints) for 32 bit platforms with following configuraitons:
1) IOAPIC diabled
2) SFI enabled
3) devicetree (CE4100) enabled

TODO list:
1) check whether it affects Xen or not

Patch 1-17 are trivial code improvements, bugfixes and preparation.

Patch 18-24 enable basic irqdomain support and IRQ number dynamic
allocation.

Patch 25-29 consoldate the way to program IOAPIC pins by using
irqdomain map() interface.

Patch 30 cleans up unused interfaces and functions in IOAPIC driver.

Tests and comments are warmly welcomed!

Jiang Liu (30):
  genirq, trivial: improve documentation to match current
    implementation
  x86, mpparse: use pr_lvl() helper utilities to replace
    printk(KERN_LVL)
  x86, mpparse: simplify arch/x86/include/asm/mpspec.h
  x86, PCI, ACPI: use kmalloc_node() to optimize for performance
  x86, acpi, irq: kill static function irq_to_gsi()
  x86, ACPI, trivial: minor improvements to arch/x86/kernel/acpi/boot.c
  x86, ACPI, irq: enhance error handling in function
    acpi_register_gsi()
  x86, ACPI, irq: fix possible eror in GSI to IRQ mapping for legacy
    IRQ
  x86, irq, trivial: minor improvements of IRQ related code
  x86, ioapic: kill unused global variable timer_through_8259
  x86, ioapic: replace get_nr_irqs_gsi() with
    arch_dynirq_lower_bound(0)
  x86, ioapic: kill static variable nr_irqs_gsi
  x86, ioapic: introduce helper utilities to walk ioapics and pins
  x86, ioapic: use irq_cfg() instead of irq_get_chip_data() for better
    readability
  x86, irq: update high address field when updating affinity for MSI
    IRQ
  x86, irq: reorganize IO_APIC_get_PCI_irq_vector() to prepare for
    irqdomain
  x86, irq: introduce some helper utilities to improve readability
  x86, ACPI, irq: consolidate algorithm of mapping (ioapic, pin) to IRQ
    number
  x86, irq: introduce mechanisms to support dynamically allocate IRQ
    for IOAPIC
  x86, irq: enhance mp_register_ioapic() to support irqdomain
  x86, ACPI, irq: provide basic irqdomain support
  x86, mpparse, irq: provide basic irqdomain support
  x86, devicetree, irq: use common mechanism to support irqdomain
  x86, SFI, irq: provide basic irqdomain support
  x86, irq: introduce two helper functions to support irqdomain map
    operation
  x86, irq, ACPI: use common irqdomain map interface to program IOAPIC
    pins
  x86, irq, mpparse: use common irqdomain map interface to program
    IOAPIC pins
  x86, irq, SFI: use common irqdomain map interface to program IOAPIC
    pins
  x86, irq, devicetree: use common irqdomain map interface to program
    IOAPIC pins
  x86, irq: clean up unused IOAPIC interface

 Documentation/IRQ-domain.txt      |    3 +-
 arch/x86/include/asm/apic.h       |    4 +-
 arch/x86/include/asm/hardirq.h    |    3 -
 arch/x86/include/asm/io_apic.h    |   44 ++-
 arch/x86/include/asm/mpspec.h     |   13 -
 arch/x86/include/asm/prom.h       |    2 -
 arch/x86/kernel/acpi/boot.c       |  205 ++++++------
 arch/x86/kernel/apic/apic.c       |    2 +-
 arch/x86/kernel/apic/io_apic.c    |  623 +++++++++++++++++++++----------------
 arch/x86/kernel/devicetree.c      |   92 +-----
 arch/x86/kernel/irqinit.c         |    6 -
 arch/x86/kernel/mpparse.c         |   97 +++---
 arch/x86/pci/acpi.c               |    6 +-
 arch/x86/pci/intel_mid_pci.c      |   17 +-
 arch/x86/pci/irq.c                |    2 -
 arch/x86/platform/intel-mid/sfi.c |   18 +-
 arch/x86/platform/sfi/sfi.c       |   12 +-
 drivers/iommu/irq_remapping.c     |    4 +-
 drivers/xen/events/events_base.c  |    2 +-
 kernel/irq/internals.h            |    2 +-
 kernel/irq/irqdomain.c            |    6 +-
 21 files changed, 581 insertions(+), 582 deletions(-)

-- 
1.7.10.4

