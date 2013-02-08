Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946983Ab3BHT24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:28:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25999 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760288Ab3BHT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:28:51 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/26] x86, irq: support ioapic device hotplug
Date: Fri,  8 Feb 2013 11:27:57 -0800
Message-Id: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Current x86 code does not support iapic hotplug yet.

This patcheset will try to pre-reserve irq block in allocated_irqs bitmap.
for hot add ioapic controller, also record irq_base in gsi_config, so later
could use it to convert gsi to irq for pci device using that ioapic controller.
Need to new realloc_irq to allocate irq_desc/cfg later.

It is based on x86/apic and pci/next that is supporting pci root bus hotplug now.

could get them from:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-irq

Yinghai Lu (26):
  x86, irq: Change irq_remap_modify_chip_defaults to static
  x86, irq: Modify irq chip once for irq remapping
  x86, irq: Print out MSI/MSI-X clearly
  x86, irq: Show MSI-X in /proc/interrupt
  x86, irq: Show pci device name for msi in /proc/interrupt
  x86, irq: Make dmar_msi/hpet_msi irq_chip name consistent
  ia64, irq: Add dummy create_irq_nr()
  iommu, irq: Allocate irq_desc for dmar_msi with local node
  x86, irq: kill create_irq()
  x86, irq: Convert irq_2_pin list to generic list
  genirq: Split __irq_reserve_irqs from irq_alloc_descs
  x86, irq: Add realloc_irq_and_cfg_at()
  x86, irq: Move down arch_early_irq_init()
  x86, irq: Split out alloc_ioapic_save_registers()
  xen, irq: call irq_realloc_desc_at() at first
  x86, irq: pre-reserve irq range/realloc for booting path
  x86, irq: Add ioapic_gsi_to_irq
  genirq: Bail out early in free_desc()
  x86, irq: More strict checking about registering ioapic
  x86, irq: Make mp_register_ioapic handle hotadd ioapic
  x86, irq: Add mp_unregister_ioapic to handle hot-remove ioapic
  x86, irq: Make ioapics loop skip blank slots
  x86, ioapic: Find usable ioapic id for 64bit.
  x86: Move declaration for mp_register_ioapic()
  PCI: Disable mem in the ioapic removing path
  PCI, x86, ACPI: Add ioapic hotplug support with acpi host bridge.

 arch/ia64/kernel/irq_ia64.c          |   10 +
 arch/x86/include/asm/hw_irq.h        |    2 +-
 arch/x86/include/asm/io_apic.h       |    7 +
 arch/x86/include/asm/irq_remapping.h |    6 -
 arch/x86/include/asm/mpspec.h        |   21 +-
 arch/x86/kernel/acpi/boot.c          |   32 +--
 arch/x86/kernel/apic/apic.c          |    9 +-
 arch/x86/kernel/apic/io_apic.c       |  446 +++++++++++++++++++++++++---------
 drivers/acpi/pci_root.c              |    4 +
 drivers/iommu/dmar.c                 |    2 +-
 drivers/iommu/irq_remapping.c        |   24 +-
 drivers/pci/Kconfig                  |    3 +-
 drivers/pci/ioapic.c                 |  243 ++++++++++++------
 drivers/xen/events.c                 |    8 +-
 include/linux/irq.h                  |    6 +
 include/linux/pci-acpi.h             |    8 +
 kernel/irq/irqdesc.c                 |   83 +++++--
 17 files changed, 673 insertions(+), 241 deletions(-)

-- 
1.7.10.4

