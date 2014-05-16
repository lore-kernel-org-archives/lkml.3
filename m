Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbaEPODB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:03:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbaEPNdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:08 -0400
Date: Fri, 16 May 2014 06:32:11 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d24a135412ab4dba50eb7aeffd4064eee23b4da6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, joro@8bytes.org, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, joro@8bytes.org,
        tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154334.741805075@linutronix.de>
References: <20140507154334.741805075@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: irq_remapping: Use irq_alloc/free_hwirq()
Git-Commit-ID: d24a135412ab4dba50eb7aeffd4064eee23b4da6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d24a135412ab4dba50eb7aeffd4064eee23b4da6
Gitweb:     http://git.kernel.org/tip/d24a135412ab4dba50eb7aeffd4064eee23b4da6
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:07 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:18 +0200

x86: irq_remapping: Use irq_alloc/free_hwirq()

The create_irq variants are going away. Use the new interface. The
core and arch code already excludes the gsi interrupts from the
allocation, so no functional change.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Joerg Roedel <joro@8bytes.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
Link: http://lkml.kernel.org/r/20140507154334.741805075@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/irq_remapping.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 228632c9..33c4395 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -51,7 +51,7 @@ static void irq_remapping_disable_io_apic(void)
 
 static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 {
-	int node, ret, sub_handle, nvec_pow2, index = 0;
+	int ret, sub_handle, nvec_pow2, index = 0;
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
@@ -61,8 +61,7 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	WARN_ON(msidesc->msi_attrib.multiple);
 	WARN_ON(msidesc->nvec_used);
 
-	node = dev_to_node(&dev->dev);
-	irq = __create_irqs(get_nr_irqs_gsi(), nvec, node);
+	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
 	if (irq == 0)
 		return -ENOSPC;
 
@@ -89,7 +88,7 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	return 0;
 
 error:
-	destroy_irqs(irq, nvec);
+	irq_free_hwirqs(irq, nvec);
 
 	/*
 	 * Restore altered MSI descriptor fields and prevent just destroyed
@@ -109,12 +108,11 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 	unsigned int irq;
 
 	node		= dev_to_node(&dev->dev);
-	irq		= get_nr_irqs_gsi();
 	sub_handle	= 0;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 
-		irq = create_irq_nr(irq, node);
+		irq = irq_alloc_hwirq(node);
 		if (irq == 0)
 			return -1;
 
@@ -137,7 +135,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 	return 0;
 
 error:
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 	return ret;
 }
 
