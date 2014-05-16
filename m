Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbaEPNdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbaEPNdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:43 -0400
Date: Fri, 16 May 2014 06:32:50 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-59b47ddc0b4d7ea8a625512e802832730c1feeb4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        bhelgaas@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        tony.luck@intel.com, bhelgaas@google.com, tglx@linutronix.de
In-Reply-To: <20140507154335.452206351@linutronix.de>
References: <20140507154335.452206351@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: htirq: Use irq_alloc/free_irq()
Git-Commit-ID: 59b47ddc0b4d7ea8a625512e802832730c1feeb4
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

Commit-ID:  59b47ddc0b4d7ea8a625512e802832730c1feeb4
Gitweb:     http://git.kernel.org/tip/59b47ddc0b4d7ea8a625512e802832730c1feeb4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:08 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:19 +0200

x86: htirq: Use irq_alloc/free_irq()

No functional change, just cleaned up a bit.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: x86@kernel.org
Cc: linux-pci@vger.kernel.org
Link: http://lkml.kernel.org/r/20140507154335.452206351@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/htirq.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 6e373ea..d68b030 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -87,12 +87,9 @@ void unmask_ht_irq(struct irq_data *data)
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 {
 	struct ht_irq_cfg *cfg;
+	int max_irq, pos, irq;
 	unsigned long flags;
 	u32 data;
-	int max_irq;
-	int pos;
-	int irq;
-	int node;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -120,10 +117,8 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
-	node = dev_to_node(&dev->dev);
-	irq = create_irq_nr(0, node);
-
-	if (irq <= 0) {
+	irq = irq_alloc_hwirq(dev_to_node(&dev->dev));
+	if (!irq) {
 		kfree(cfg);
 		return -EBUSY;
 	}
@@ -166,7 +161,7 @@ void ht_destroy_irq(unsigned int irq)
 	cfg = irq_get_handler_data(irq);
 	irq_set_chip(irq, NULL);
 	irq_set_handler_data(irq, NULL);
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 
 	kfree(cfg);
 }
