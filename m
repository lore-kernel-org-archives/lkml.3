Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaKMLkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:40:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:39574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328AbaKMLkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:40:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="607187984"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
Date: Thu, 13 Nov 2014 19:43:42 +0800
Message-Id: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is based on tip/irq/irqdomain and tries to refine
interfaces to support irqdomain for generic MSI and PCI MSI.

Patch 1 is just minor fixes for tip/irq/irqdomain.

Patch 2 introduces some helpers to hide struct msi_desc implementation
details, so later we could move msi_list from struct pci_dev into
struct device to enable generic MSI support.

Patch 3 introduces msi_domain_{alloc|free}_irqs() which generalize
pci_msi_domain_alloc_irqs() to support generic MSI.

Patch 4 introduces default data structures and callback implementations
to support msi_domain_alloc_irqs(), so reduce burden on generic MSI
users.

Patch 5 converts PCI MSI to use generic MSI interfaces, and also
implement default callbacks for PCI MSI.

Patch 6 introduces a mechanism to replace arch_setup_msi_irq()/
arch_setup_msi_irqs()/arch_teardown_msi_irq()/arch_teardown_msi_irqs().

With this patch set applied, the generic MSI and PCI MSI interfaces
are much easier to use. For extreme case, you only need to define
a "struct msi_domain_info" and don't need to implement any callbacks,
just using the default callbacks is OK:)

This patch set is also a preparation for:
1) Kill all weak functions in drivers/pci/msi.c
2) Implement support for non-PCI-compliant MSI device

It has been tested on x86 platforms, comments are welcomed!

Jiang Liu (6):
  PCI, MSI: Fix errors caused by commit e5f1a59c4e12
  PCI, MSI: Introduce helpers to hide struct msi_desc implemenation
    details
  genirq: Introduce msi_domain_{alloc|free}_irqs()
  genirq: Provide default callbacks for msi_domain_ops
  PCI, MSI: Refine irqdomain interfaces to simplify its usage
  PCI, MSI: Provide mechanism to alloc/free MSI/MSIX interrupt from
    irqdomain

 drivers/pci/msi.c   |  170 ++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/msi.h |   90 ++++++++++++++++++++++++---
 kernel/irq/msi.c    |  150 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 366 insertions(+), 44 deletions(-)

-- 
1.7.10.4

