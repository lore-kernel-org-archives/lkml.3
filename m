Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaKIPHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:07:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:21860 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaKIPHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:07:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604932673"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 00/17] Refine support of non-PCI-compliant Message
Date: Sun,  9 Nov 2014 23:10:22 +0800
Message-Id: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some interrupt controllers, such as DMAR/HPET/HT_IRQ, work almost in
the same as PCI MSI interrupt controller. And there some devices make
use of PCI MSI mechanism for non-PCI devices on ARm/ARM64 platforms.

So this patches tries to split PCI MSI code into PCI dependent part
and PCI independent part. The PCI independent part will be used to
support other PCI MSI like interrupt controllers.

Patch 1-9 are clean ups for previous hierarchy irqdomain patchset
and preparation for coming PCI MSI code reorganization.
Patch 10-15 split PCI MSI code and implement common mechanism to support
other MSI alike interrupt contollers.
Patch 16-17 converts HT_IRQ to use the common MSI support mechanism.

This patch set only solves the issue to manage interrupt controller,
but we still need another patch set to provide pci_enable_msix_range()
alike interfaces to support non-PCI devices. To achieve that, we will:
1) Move msi_list from struct pci_dev into struct device
2) Abstract common code from drivers/pci/msi.c into kernel/irq/msi.c
3) Implement msi_enable_range()/msi_disable() alike interfaces.

Apparently, we need much more time to discuss the proposal for next
patch set.

Hi Thomas and Bjorn,
	Could you please to review patch 10,13 and give your thoughts?
Those are the main changes. This patch set only passes compilation and
boot tests.

Regards!
Gerry

Jiang Liu (17):
  x86, irq: Normalize x86 irq_chip name
  genirq: Introduce helper irq_domain_set_info() to reduce duplicated
    code
  x86, PCI/MSI: Simplify the way to deal with remapped MSI interrupts
  PCI/MSI: Replace msi_update_msg() with irq_chip_compose_msi_msg()
  PCI/MSI: Move msi_set_affinity() to PCI core
  genirq: Introduce callback irq_chip.irq_write_msi_msg
  x86, irq: Implement irq_chip.irq_write_msi_msg for MSI/DMAR/HPET
    irq_chips
  PCI/MSI: Use irq_chip.irq_write_msi_msg() to share common code
  x86, irq: Simplify MSI/DMAR/HPET implementation by using common code
  PCI, MSI: Split MSI code into PCI dependent and PCI independent parts
  PCI, MSI: Rename __read_msi_msg() as __pci_read_msi_msg()
  PCI, MSI: Rename __write_msi_msg() as __pci_write_msi_msg()
  MSI: Provide irqdomain support for generic MSI
  x86, PCI, MSI: Use common code to manage MSI interrupts
  PCI, MSI: Clean up unused irqdomain related code
  x86, htirq: Kill struct ht_irq_msg by reusing struct msi_msg
  x86, htirq: Use common MSI code to manage Hypertransport interrupts

 arch/powerpc/platforms/pseries/msi.c        |    2 +-
 arch/x86/kernel/apic/htirq.c                |  137 +++++-------
 arch/x86/kernel/apic/msi.c                  |  309 ++++++++++++---------------
 arch/x86/pci/xen.c                          |    4 +-
 arch/x86/platform/uv/uv_irq.c               |    5 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
 drivers/pci/Kconfig                         |    5 +-
 drivers/pci/htirq.c                         |   20 +-
 drivers/pci/msi.c                           |  144 ++-----------
 include/linux/htirq.h                       |   15 +-
 include/linux/irq.h                         |    8 +
 include/linux/irqdomain.h                   |    4 +
 include/linux/msi.h                         |   89 +++++---
 kernel/irq/Kconfig                          |   10 +-
 kernel/irq/Makefile                         |    1 +
 kernel/irq/irqdomain.c                      |   10 +
 kernel/irq/msi.c                            |  133 ++++++++++++
 17 files changed, 454 insertions(+), 444 deletions(-)
 create mode 100644 kernel/irq/msi.c

-- 
1.7.10.4

