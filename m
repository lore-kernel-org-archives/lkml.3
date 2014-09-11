Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaIKIWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:22:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:19347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaIKIW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571628834"
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
Subject: [RFC Part1 v1 00/18] Prepare for enabling hierarchy irqdomain on x86
Date: Thu, 11 Sep 2014 16:24:47 +0800
Message-Id: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to restructure x86 interrupt code based on hierarchy irqdomain,
that is to build irqdomains for CPU vector, interrupt remapping unit,
IOAPIC, MSI and HPET etc and orgonize those irqdomains in hierarchy mode.

This patchset is preparation work to enable hierarchy irqdomain on x86
platforms. It splits out code for vector management, MSI, HTIRQ from
ioapic.c into separate files. It also introduces some helper functions
to access irq_cfg, which will ease transition to hierarchy irqdomain
later.

It's based on patchset at:
https://lkml.org/lkml/2014/9/11/97

And you may access it at:
https://github.com/jiangliu/linux.git irqdomain/p1v1

Jiang Liu (17):
  x86, irq, ACPI: Fix building warning of unused code
  x86, irq: Kill fourth parameter of IO_APIC_get_PCI_irq_vector()
  x86, irq: Refine hw_irq.h to prepare for irqdomain support
  x86, irq: Rename local APIC related functions in io_apic.c as
    apic_xxx()
  x86, irq: Protect __clear_irq_vector() with vector_lock
  x86, irq: Introduce helpers to access struct irq_cfg
  x86, irq: Move local APIC related code from io_apic.c into vector.c
  x86, irq: Replace printk(KERN_LVL) with pr_lvl() utilities
  x86, irq: Move PCI MSI related code from io_apic.c into msi.c
  x86, irq: Move HT IRQ related code from io_apic.c into htirq.c
  x86, irq: Move IOAPIC related declarations from hw_irq.h into
    io_apic.h
  x86, irq: Move IRQ initialization routines from io_apic.c into
    vector.c
  x86, irq: Make MSI and HT_IRQ indepenent of X86_IO_APIC
  x86, irq: Use helpers to access irq_cfg data structure associated
    with IRQ
  x86: irq_remapping: Use helpers to access irq_cfg data structure
    associated with IRQ
  iommu/vt-d: Use helpers to access irq_cfg data structure associated
    with IRQ
  iommu/amd: Use helpers to access irq_cfg data structure associated
    with IRQ

Yinghai Lu (1):
  x86, irq: Convert irq_2_pin list to generic list

 arch/x86/Kconfig                    |    6 +-
 arch/x86/include/asm/hw_irq.h       |   76 +--
 arch/x86/include/asm/io_apic.h      |   29 +-
 arch/x86/include/asm/pci.h          |    3 +
 arch/x86/kernel/acpi/boot.c         |    2 +
 arch/x86/kernel/apic/Makefile       |    4 +-
 arch/x86/kernel/apic/htirq.c        |  106 ++++
 arch/x86/kernel/apic/io_apic.c      | 1096 ++---------------------------------
 arch/x86/kernel/apic/msi.c          |  283 +++++++++
 arch/x86/kernel/apic/vector.c       |  716 +++++++++++++++++++++++
 arch/x86/kernel/irqinit.c           |   22 -
 arch/x86/pci/irq.c                  |    6 +-
 arch/x86/platform/uv/uv_irq.c       |    6 +-
 drivers/iommu/amd_iommu.c           |   14 +-
 drivers/iommu/intel_irq_remapping.c |   10 +-
 drivers/iommu/irq_remapping.c       |    6 +-
 drivers/pci/Kconfig                 |    2 +-
 drivers/pci/hotplug/ibmphp_core.c   |    5 +-
 18 files changed, 1226 insertions(+), 1166 deletions(-)
 create mode 100644 arch/x86/kernel/apic/htirq.c
 create mode 100644 arch/x86/kernel/apic/msi.c
 create mode 100644 arch/x86/kernel/apic/vector.c

-- 
1.7.10.4

