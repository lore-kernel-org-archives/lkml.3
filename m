Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaIXI5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:57:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:18034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbaIXI5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:57:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390840456"
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
Subject: [Patch v6 00/15] Enable support of IOAPIC hotplug on x86 platforms
Date: Wed, 24 Sep 2014 16:59:21 +0800
Message-Id: <1411549176-30780-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
hotplug on x86 platforms. It's based on latest mainstream kernel at
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

You may pull it from 
https://github.com/jiangliu/linux.git ioapic/hotplug_v6

We have pick up several patches from Yinghai's original IOAPIC hotplug
patch set and reimplemented IOAPIC driver as an ACPI driver instead of
a PCI driver.

It has been tested on a 4-socket Intel SDV with socket hot-addition
capability. Any suggestions are welcomed!

Patch 1-4 are bugfixes and enhancements to ACPI subsystem
Patch 5 killes PCI IOAPIC driver
Patch 6-14 enhances IOAPIC core to support IOAPIC hotplug
Patch 15 reimplements ACPI IOAPIC driver and enables IOAPIC hotplug

V5->V6:
1) Rebase to the latest v3.17-16
2) Minor fixes for comments
V4->V5:
1) Fix a building error
2) Don't rename processor_core.c as apic_id.c
3) Improve comments
4) Reorder patches to get rid of some temporary code
V3->V4:
1) Fix a bug in manage IOAPIC reference count
2) Rebase to v3.17-rc2
3) Refine commit messages
V2->V3:
1) Refine ACPI resource walk functions for PCI root bus and IOAPIC
2) Improve commit messages
3) Reorder patch order for better maintenence


Jiang Liu (12):
  x86, PCI, ACPI: Kill private function resource_to_addr() in
    arch/x86/pci/acpi.c
  ACPI: Correct return value of acpi_dev_resource_address_space()
  ACPI: Fix minor syntax issues in processor_core.c
  PCI: Remove PCI ioapic driver
  x86, irq: Remove __init marker for functions will be used by IOAPIC
    hotplug
  x86, irq: Keep balance of IOAPIC pin reference count
  x86, irq: Refine mp_register_ioapic() to prepare for IOAPIC hotplug
  x86, irq, ACPI: Introduce a rwsem to protect IOAPIC operations from
    hotplug
  x86, irq, ACPI: Implement interface to support ACPI based IOAPIC
    hot-addition
  x86, irq, ACPI: Implement interfaces to support ACPI based IOAPIC
    hot-removal
  x86, irq: Introduce helper to check whether an IOAPIC has been
    registered
  x86, irq, ACPI: Implement ACPI driver to support IOAPIC hotplug

Yinghai Lu (3):
  ACPI: Add interfaces to parse IOAPIC ID for IOAPIC hotplug
  x86, irq: Split out alloc_ioapic_save_registers()
  x86, irq: Prefer assigned ID in APIC ID register for x86_64

 arch/x86/include/asm/io_apic.h |    6 +-
 arch/x86/kernel/acpi/boot.c    |   90 +++++++++++++--
 arch/x86/kernel/apic/io_apic.c |  234 +++++++++++++++++++++++++++++++--------
 arch/x86/pci/acpi.c            |  142 +++++++++---------------
 arch/x86/pci/intel_mid_pci.c   |   10 +-
 arch/x86/pci/irq.c             |    7 +-
 drivers/acpi/Kconfig           |    6 +
 drivers/acpi/Makefile          |    1 +
 drivers/acpi/internal.h        |    7 ++
 drivers/acpi/ioapic.c          |  235 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/pci_irq.c         |   11 +-
 drivers/acpi/pci_root.c        |    3 +
 drivers/acpi/processor_core.c  |  131 +++++++++++++++++++---
 drivers/acpi/resource.c        |    2 +-
 drivers/pci/Kconfig            |    7 --
 drivers/pci/Makefile           |    2 -
 drivers/pci/ioapic.c           |  121 ---------------------
 include/linux/acpi.h           |    5 +
 include/linux/pci.h            |    1 +
 19 files changed, 727 insertions(+), 294 deletions(-)
 create mode 100644 drivers/acpi/ioapic.c
 delete mode 100644 drivers/pci/ioapic.c

-- 
1.7.10.4

