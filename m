Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3HKCqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:46:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25517 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3HKCqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:46:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/28] x86, irq: Support ioapic controller hotplug
Date: Sat, 10 Aug 2013 19:45:10 -0700
Message-Id: <1376189139-31856-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Intel cpu (from IVB) include cpu cores, mem controller, and IIO.
When hotplug cpu physically, it will involve cpu hotplug, mem hotplug,
and pci root hotplug.

IIO includes pci host bridge, ioapic controller and iommu etc.
pci devices will need to use ioapic and iommu.
So to make pci root bus hotplug working, we need ioapic hotplug support.

Now ioapics are with ACPI MADT table. During booting, kernel will parse
MADT and put info into ioapic arrays.
Also Bjorn added one pci device based driver, but it is not wired in yet,
as it need to call acpi_register_ioapic, and that is TBD.

This patchset will
1. extend genirq to support reserve/alloc_reserved method.
   because we want irqs for one ioapic controller to be linear mapping
   to the gsi range.
2. change ioapic array operation code so we could insert new ioapic and
   remove one leave the blank slot.
3. record irq_base in gsi_config in ioapic struct, and use it to convert gsi
   to irq for pci device using that ioapic controller
4. make static ioapic path (from MADT) use same code as hot-add path,
   with reserve/alloc_reserved method.
5. change ioapic add/remove to use acpi way, as that is only needed when
   pci root bus hotplug.
6. also support the case that ioapic controller is hiding in pci
   config space or ioapic address is not managed by pci reallocation subsys.

Also include some cleanups
1. print MSI-X clearly in /proc/interrupts and dmesg.
2. convert ioapic irq_2_pin to be generic list.

It is based on linus's tree of 2013/08/10 aka v3.11-rc4.

could get them from:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-irq

-v3: split last patch to 4 patches per request from Bjorn.
     drop one patch that will put pci device name in proc/interrupts
     update changelog.
-v4: address review from tglx, change to realloc to alloc_reserved.
     separate x86 code and core code into different patches.

Yinghai Lu (28):
  genirq: Split __irq_reserve_irqs from irq_alloc_descs
  genirq: Add irq_alloc_reserved_desc()
  genirq: Do not free unallocated irq descriptors
  x86, irq: Change irq_remap_modify_chip_defaults() to static
  x86, irq: Modify irq chip once for irq remapping
  x86, irq: Show MSI-X clearly in debug message
  x86, irq: Show MSI-X in /proc/interrupt
  x86, irq: Make dmar_msi/hpet_msi irq_chip name consistent
  ia64, irq: Add dummy create_irq_nr()
  iommu, irq: Allocate irq_desc for dmar_msi with local node
  x86, irq: Kill create_irq()
  x86, irq: Convert irq_2_pin list to generic list
  x86, irq: Add alloc_reserved_irq_and_cfg_at()
  x86, irq: Move down arch_early_irq_init()
  x86, irq: Split out alloc_ioapic_save_registers()
  xen, irq: Call irq_alloc_reserved_desc_at() at first
  x86, irq: Reserve irq range and alloc_reserved for booting path
  x86, irq: Add ioapic_gsi_to_irq
  x86, irq: Add for_each_ioapic helper
  x86, irq: More strict checking about registering ioapic
  x86, irq: Make mp_register_ioapic handle hot-added ioapic
  x86, irq: Add mp_unregister_ioapic to handle hot-remove ioapic
  x86, ioapic: Find usable ioapic id for 64bit.
  x86: Move declaration for mp_register_ioapic()
  PCI, x86: Make ioapic hotplug support built-in
  PCI, x86, ACPI: Link acpi ioapic register to ioapic
  PCI, x86, ACPI: Enable ioapic hotplug support with acpi host bridge.
  PCI, x86, ACPI: get ioapic address from acpi device

 arch/ia64/kernel/irq_ia64.c          |  10 +
 arch/x86/include/asm/hw_irq.h        |   2 +-
 arch/x86/include/asm/io_apic.h       |  13 +
 arch/x86/include/asm/irq_remapping.h |  14 +-
 arch/x86/include/asm/mpspec.h        |  21 +-
 arch/x86/kernel/acpi/boot.c          |  32 +--
 arch/x86/kernel/apic/apic.c          |   9 +-
 arch/x86/kernel/apic/io_apic.c       | 480 +++++++++++++++++++++++++----------
 arch/x86/kernel/devicetree.c         |   2 +-
 drivers/acpi/pci_root.c              |   4 +
 drivers/iommu/amd_iommu_init.c       |   2 +-
 drivers/iommu/dmar.c                 |   2 +-
 drivers/iommu/intel_irq_remapping.c  |   2 +-
 drivers/iommu/irq_remapping.c        |  18 +-
 drivers/pci/Kconfig                  |   3 +-
 drivers/pci/ioapic.c                 | 229 ++++++++++++-----
 drivers/xen/events.c                 |   8 +-
 include/linux/irq.h                  |   4 +
 include/linux/pci-acpi.h             |   8 +
 kernel/irq/irqdesc.c                 |  80 ++++--
 20 files changed, 679 insertions(+), 264 deletions(-)

-- 
1.8.1.4

