Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbaEPNgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:36:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbaEPNgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:36:32 -0400
Date: Fri, 16 May 2014 06:35:22 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-2aa799d891299457e4107d33f07a1ed5ac8849ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154338.132662495@linutronix.de>
References: <20140507154338.132662495@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] tile: pci: Use irq_alloc/free_hwirq()
Git-Commit-ID: 2aa799d891299457e4107d33f07a1ed5ac8849ae
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

Commit-ID:  2aa799d891299457e4107d33f07a1ed5ac8849ae
Gitweb:     http://git.kernel.org/tip/2aa799d891299457e4107d33f07a1ed5ac8849ae
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:21 +0200

tile: pci: Use irq_alloc/free_hwirq()

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20140507154338.132662495@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/kernel/pci_gx.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 077b7bc..e39f9c5 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -350,10 +350,9 @@ static int tile_init_irqs(struct pci_controller *controller)
 		int cpu;
 
 		/* Ask the kernel to allocate an IRQ. */
-		irq = create_irq();
-		if (irq < 0) {
+		irq = irq_alloc_hwirq(-1);
+		if (!irq) {
 			pr_err("PCI: no free irq vectors, failed for %d\n", i);
-
 			goto free_irqs;
 		}
 		controller->irq_intx_table[i] = irq;
@@ -382,7 +381,7 @@ static int tile_init_irqs(struct pci_controller *controller)
 
 free_irqs:
 	for (j = 0; j < i; j++)
-		destroy_irq(controller->irq_intx_table[j]);
+		irq_free_hwirq(controller->irq_intx_table[j]);
 
 	return -1;
 }
@@ -1500,9 +1499,9 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	int irq;
 	int ret;
 
-	irq = create_irq();
-	if (irq < 0)
-		return irq;
+	irq = irq_alloc_hwirq(-1);
+	if (!irq)
+		return -ENOSPC;
 
 	/*
 	 * Since we use a 64-bit Mem-Map to accept the MSI write, we fail
@@ -1601,11 +1600,11 @@ hv_msi_config_failure:
 	/* Free mem-map */
 msi_mem_map_alloc_failure:
 is_64_failure:
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 	return ret;
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
 {
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 }
