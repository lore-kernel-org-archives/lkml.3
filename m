Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaKKPsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:48:31 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56153 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaKKPsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:25 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 02/15] PCI/MSI: genirq: allow architecture-specific override of flow handler
Date: Tue, 11 Nov 2014 15:48:00 +0000
Message-Id: <1415720893-13371-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM interrupt controllers tend to use a "fasteoi" handler rather than
the expected "edge". Allow the architecture to override the function
call setting up the flow handler by defining arch_msi_irq_set_handler.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/msi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8de7c87..6fea997 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1113,6 +1113,11 @@ msi_get_hwirq(struct pci_dev *dev, struct msi_desc *desc)
 		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
 }
 
+void __weak arch_msi_irq_set_handler(unsigned int virq)
+{
+	__irq_set_handler(virq, handle_edge_irq, 0, "edge");
+}
+
 static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 			    unsigned int nr_irqs, void *arg)
 {
@@ -1130,7 +1135,7 @@ static int msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
 					      domain->host_data,
 					      (void *)(long)i);
-		__irq_set_handler(virq + i, handle_edge_irq, 0, "edge");
+		arch_msi_irq_set_handler(virq + i);
 	}
 
 	return ret;
-- 
2.0.4

