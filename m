Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaEPNeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:34:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbaEPNeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:34:00 -0400
Date: Fri, 16 May 2014 06:33:04 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-be47be6c28a83dd8b3c5540d0be3675af1ac7b2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154335.749579081@linutronix.de>
References: <20140507154335.749579081@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: ioapic: Use irq_alloc/free_hwirq()
Git-Commit-ID: be47be6c28a83dd8b3c5540d0be3675af1ac7b2e
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

Commit-ID:  be47be6c28a83dd8b3c5540d0be3675af1ac7b2e
Gitweb:     http://git.kernel.org/tip/be47be6c28a83dd8b3c5540d0be3675af1ac7b2e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:09 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:19 +0200

x86: ioapic: Use irq_alloc/free_hwirq()

No functional change just less crap.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140507154335.749579081@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b7175c0..3c17b25 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3169,8 +3169,8 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
+	unsigned int irq;
 	int node, ret;
 
 	/* Multiple MSI vectors only supported with interrupt remapping */
@@ -3178,28 +3178,25 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		return 1;
 
 	node = dev_to_node(&dev->dev);
-	irq_want = nr_irqs_gsi;
+
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want, node);
-		if (irq == 0)
+		irq = irq_alloc_hwirq(node);
+		if (!irq)
 			return -ENOSPC;
 
-		irq_want = irq + 1;
-
 		ret = setup_msi_irq(dev, msidesc, irq, 0);
-		if (ret < 0)
-			goto error;
+		if (ret < 0) {
+			irq_free_hwirq(irq);
+			return ret;
+		}
+
 	}
 	return 0;
-
-error:
-	destroy_irq(irq);
-	return ret;
 }
 
 void native_teardown_msi_irq(unsigned int irq)
 {
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 }
 
 #ifdef CONFIG_DMAR_TABLE
