Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaFIIRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:17:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:35659 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaFIIRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352319391"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
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
        linux-acpi@vger.kernel.org
Subject: [Patch V4 00/42] use irqdomain to dynamically allocate IRQ for IOAPIC
Date: Mon,  9 Jun 2014 16:19:29 +0800
Message-Id: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
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

This patchset applies to tip/irq/core and you may pull from
https://github.com/jiangliu/linux.git ioapic/irqdomain_v4

The patchset has been tested on a two socket 64 bit Intel platforms with:
1) ACPI and mpparse enabled (boot successfully)
2) Mpparse enabled with ACPI disabled (boot successfully)
3) ACPI enabled with Mpparse disabled (boot successfully)
4) boot parameter "pci=nomsi"
5) boot parameter "acpi=noirq"
6) boot parameter "pci=noacpi"
7) UP mode (SMP disabled)

It has also been tested on an one socket laptop with 32bit Ubuntu with:
1) ACPI and mpparse enabled (boot successfully)
2) Mpparse enabled with ACPI disabled (boot successfully)
3) ACPI enabled with Mpparse disabled (boot successfully)
4) boot parameter "pci=nomsi"
5) boot parameter "acpi=noirq"
6) boot parameter "pci=noacpi"
7) UP mode (SMP disabled)
8) UP mode with IOAPIC disabled

It also builds successfully (but without booting due to hardware resource
constraints) for 32 bit platforms with following configuraitons:
1) SFI enabled
2) devicetree (CE4100) enabled

V3->V4
1) simplify interfaces/implementation to enable irqdomain for IOAPIC
2) clean up usage of NR_IRQS_LEGACY
3) refine support of CE4100
4) address review comments from last round of review

V2->V3
1) Implement irqdomain unmap() interface and free IRQ when it's not used
2) Fix posssible conflicts with native and PV Xen IRQ management
3) Fix build errors on CE4100
4) Code quality and readability improvement

V1->V2
1) Rebase to tip/irq/core
2) reorder patches to put bugfixes at the head
3) fix bug in handling shared ISA IRQs
4) refine commit messages

Patch 1 is simple bugfix for MSI.

Patch 2-20 are trivial code improvements, bugfixes and preparation.

Patch 21-28 enable basic irqdomain support and IRQ number dynamic
allocation.

Patch 29-33 consoldate the way to program IOAPIC pins by using
irqdomain map() interface.

Patch 34-35 cleans up unused interfaces and functions in IOAPIC driver.

Patch 36-41 implement irqdoamin unmap() interfaces and free IRQ when
it's not used

Patch 42 is a simple clean up

Tests and comments are warmly welcomed!

Jiang Liu (42):
  x86, irq: update high address field when updating affinity for MSI
    IRQ
  x86, mpparse: use pr_lvl() helper utilities to replace
    printk(KERN_LVL)
  x86, mpparse: simplify arch/x86/include/asm/mpspec.h
  x86, acpi: reorganize code to avoid forward declaration in boot.c
  x86, PCI, ACPI: use kmalloc_node() to optimize for performance
  x86, acpi, irq: kill static function irq_to_gsi()
  x86, ACPI, trivial: minor improvements to arch/x86/kernel/acpi/boot.c
  x86, ACPI, irq: enhance error handling in function
    acpi_register_gsi()
  x86, ACPI, irq: fix possible eror in GSI to IRQ mapping for legacy
    IRQ
  x86, irq, trivial: minor improvements of IRQ related code
  x86, ioapic: kill unused global variable timer_through_8259
  x86, ioapic: kill static variable nr_irqs_gsi
  x86, ioapic: introduce helper utilities to walk ioapics and pins
  x86, ioapic: use irq_cfg() instead of irq_get_chip_data() for better
    readability
  x86, irq: reorganize IO_APIC_get_PCI_irq_vector() to prepare for
    irqdomain
  x86, irq: introduce some helper utilities to improve readability
  ce4100, irq: make CE4100 depend on CONFIG_X86_IO_APIC
  ce4100, irq: do not set legacy_pic to null_legacy_pic
  x86, irq: count legacy IRQs by legacy_pic->nr_legacy_irqs instead of
    NR_IRQS_LEGACY
  x86, irq: simplify arch_early_irq_init()
  x86, ACPI, irq: consolidate algorithm of mapping (ioapic, pin) to IRQ
    number
  x86, irq, ACPI: change __acpi_register_gsi to return IRQ number
    instead of GSI
  x86, irq: introduce mechanisms to support dynamically allocate IRQ
    for IOAPIC
  x86, irq: enhance mp_register_ioapic() to support irqdomain
  x86, ACPI, irq: provide basic irqdomain support
  x86, mpparse, irq: provide basic irqdomain support
  x86, SFI, irq: provide basic irqdomain support
  x86, devicetree, irq: use common mechanism to support irqdomain
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
  x86, irq: simplify the way to handle ISA IRQ
  genirq: export irq_domain_disassociate() to architecture interrupt
    drivers
  x86, irq: introduce helper functions to release IOAPIC pin
  x86, irq, ACPI: release IOAPIC pin when PCI device is disabled
  x86, irq, mpparse: release IOAPIC pin when PCI device is disabled
  x86, irq, SFI: release IOAPIC pin when PCI device is disabled
  x86, irq, devicetree: release IOAPIC pin when PCI device is disabled
  x86, irq: clean up irqdomain transition code

 arch/x86/Kconfig                  |    2 +
 arch/x86/include/asm/apic.h       |    4 +-
 arch/x86/include/asm/hardirq.h    |    3 -
 arch/x86/include/asm/i8259.h      |    5 +
 arch/x86/include/asm/io_apic.h    |   56 +--
 arch/x86/include/asm/mpspec.h     |   13 -
 arch/x86/include/asm/prom.h       |    2 -
 arch/x86/kernel/acpi/boot.c       |  400 +++++++++----------
 arch/x86/kernel/apic/apic.c       |    2 +-
 arch/x86/kernel/apic/io_apic.c    |  779 +++++++++++++++++++++++--------------
 arch/x86/kernel/devicetree.c      |  211 ++++------
 arch/x86/kernel/irqinit.c         |   12 +-
 arch/x86/kernel/mpparse.c         |  108 ++---
 arch/x86/pci/acpi.c               |    6 +-
 arch/x86/pci/intel_mid_pci.c      |   27 +-
 arch/x86/pci/irq.c                |   15 +-
 arch/x86/pci/xen.c                |    7 +-
 arch/x86/platform/ce4100/ce4100.c |   11 +-
 arch/x86/platform/intel-mid/sfi.c |   56 ++-
 arch/x86/platform/sfi/sfi.c       |   10 +-
 drivers/acpi/pci_irq.c            |    3 +-
 include/linux/irqdomain.h         |    2 +
 kernel/irq/irqdomain.c            |    2 +-
 23 files changed, 919 insertions(+), 817 deletions(-)

-- 
1.7.10.4

