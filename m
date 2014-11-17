Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaKQLAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:00:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:17829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaKQLAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:00:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487988900"
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
Subject: [Patch V3 0/9] Refine generic/PCI MSI irqodmian interfaces
Date: Mon, 17 Nov 2014 19:03:13 +0800
Message-Id: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set is based on tip/irq/irqdomain and tries to refine
interfaces to support irqdomain for generic MSI and PCI MSI.

Patch 1 is just minor fixes for tip/irq/irqdomain.

Patch 2-4 introduce mechanisms to help reduce irqdomain users' code size.
When converting XEN to use hierarchy irqdomain, I found the code size
increases about 100 lines. So we still need helpers to reduce code size.

Patch 5 introduces some helpers to hide struct msi_desc implementation
details, so later we could move msi_list from struct pci_dev into
struct device to enable generic MSI support.

Patch 6 introduces msi_domain_{alloc|free}_irqs() which generalize
pci_msi_domain_alloc_irqs() to support generic MSI.

Patch 7 introduces default data structures and callback implementations
to support msi_domain_alloc_irqs(), so reduce burden on generic MSI
users.

Patch 8 converts PCI MSI to use generic MSI interfaces, and also
implement default callbacks for PCI MSI.

Patch 9 introduces a mechanism to replace arch_setup_msi_irq()/
arch_setup_msi_irqs()/arch_teardown_msi_irq()/arch_teardown_msi_irqs().

With this patch set applied, the generic MSI and PCI MSI interfaces
are much easier to use. For extreme case, you only need to define
a "struct msi_domain_info" and don't need to implement any callbacks,
just using the default callbacks is OK:)

This patch set is also a preparation for:
1) Kill all weak functions in drivers/pci/msi.c
2) Implement support for non-PCI-compliant MSI device

It has been tested on x86 platforms, comments are welcomed!

V2->V3:
1) Refine msi_domain_ops.set_desc() and msi_domain_ops.handle_error()
   interfaces.
V1->V2:
1) Fix bugs reported by Marc
2) Rename MSI_FLAG_USE_DEF_OPS as MSI_FLAG_USE_DEF_DOM_OPS
3) Add support of MSI_FLAG_USE_DEF_CHIP_OPS
4) Include linxu/irqhandler.h to use irq_flow_handler_t instead of "void *"
5) Change iterfaces to pass in "nvect" to msi_domain_ops.msi_prepare()
6) Add new interfaces/flags to help reduce irqdomain users' code size
Jiang Liu (8):
  PCI, MSI: Fix errors caused by commit e5f1a59c4e12
  irqdomain: Implement a method to automatically call parent domain's
    alloc/free
  irqdomain: Introduce helper function irq_domain_add_hierarchy()
  PCI, MSI: Introduce helpers to hide struct msi_desc implementation
    details
  genirq: Introduce msi_domain_{alloc|free}_irqs()
  genirq: Provide default callbacks for msi_domain_ops
  PCI, MSI: Refine irqdomain interfaces to simplify its usage
  PCI, MSI: Provide mechanism to alloc/free MSI/MSIX interrupt from
    irqdomain

Yingjoe Chen (1):
  irqdomain: Use consistent prototype for irq_domain_free_irqs_*

 drivers/pci/msi.c         |  183 ++++++++++++++++++++++++++++++++++++---------
 include/linux/irqdomain.h |   33 ++++----
 include/linux/msi.h       |   99 +++++++++++++++++++++---
 kernel/irq/irqdomain.c    |   93 +++++++++++++++++++++--
 kernel/irq/msi.c          |  175 +++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 510 insertions(+), 73 deletions(-)

-- 
1.7.10.4

