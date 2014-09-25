Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaIYNNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaIYNNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:13:45 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v4 4/4] AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI mode
Date: Thu, 25 Sep 2014 15:13:24 +0200
Message-Id: <82c0cbbafd74eca0e346ca97f73838ba236315c3.1411648623.git.agordeev@redhat.com>
In-Reply-To: <cover.1411648623.git.agordeev@redhat.com>
References: <cover.1411648623.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As described in AHCI v1.0 specification chapter 10.6.2.2
"Multiple MSI Based Messages" generation of interrupts
is not controlled through the HOST_IRQ_STAT register.

Considering MMIO access is expensive remove unnecessary
reading and writing of HOST_IRQ_STAT register.

Further, serializing access to the host data is no longer
needed and the interrupt service routine can avoid competing
on the host lock.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Suggested-by: "Jiang, Dave" <dave.jiang@intel.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.h    |  1 +
 drivers/ata/libahci.c | 59 +++++++++++----------------------------------------
 2 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 6a22055..e5c6048 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -305,6 +305,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32			intr_status;	/* interrupts to handle */
+	spinlock_t		intr_lock;	/* protects intr_status */
 	spinlock_t		lock;		/* protects parent ata_port */
 	u32 			intr_mask;	/* interrupts to enable */
 	bool			fbs_supported;	/* set iff FBS is supported */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 48175e5..fafa7f0 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1797,11 +1797,14 @@ static irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 	unsigned long flags;
 	u32 status;
 
-	spin_lock_irqsave(&ap->host->lock, flags);
+	spin_lock_irqsave(&pp->intr_lock, flags);
 	status = pp->intr_status;
 	if (status)
 		pp->intr_status = 0;
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+	spin_unlock_irqrestore(&pp->intr_lock, flags);
+
+	if (!status)
+		return IRQ_NONE;
 
 	spin_lock_bh(ap->lock);
 	ahci_handle_port_interrupt(ap, port_mmio, status);
@@ -1824,53 +1827,14 @@ static void ahci_update_intr_status(struct ata_port *ap)
 
 static irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
 {
-	struct ata_port *ap_this = dev_instance;
-	struct ahci_port_priv *pp = ap_this->private_data;
-	struct ata_host *host = ap_this->host;
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = hpriv->mmio;
-	unsigned int i;
-	u32 irq_stat, irq_masked;
+	struct ata_port *ap = dev_instance;
+	struct ahci_port_priv *pp = ap->private_data;
 
 	VPRINTK("ENTER\n");
 
-	spin_lock(&host->lock);
-
-	irq_stat = readl(mmio + HOST_IRQ_STAT);
-
-	if (!irq_stat) {
-		u32 status = pp->intr_status;
-
-		spin_unlock(&host->lock);
-
-		VPRINTK("EXIT\n");
-
-		return status ? IRQ_WAKE_THREAD : IRQ_NONE;
-	}
-
-	irq_masked = irq_stat & hpriv->port_map;
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
-
-		if (!(irq_masked & (1 << i)))
-			continue;
-
-		ap = host->ports[i];
-		if (ap) {
-			ahci_update_intr_status(ap);
-			VPRINTK("port %u\n", i);
-		} else {
-			VPRINTK("port %u (no irq)\n", i);
-			if (ata_ratelimit())
-				dev_warn(host->dev,
-					 "interrupt on disabled port %u\n", i);
-		}
-	}
-
-	writel(irq_stat, mmio + HOST_IRQ_STAT);
-
-	spin_unlock(&host->lock);
+	spin_lock(&pp->intr_lock);
+	ahci_update_intr_status(ap);
+	spin_unlock(&pp->intr_lock);
 
 	VPRINTK("EXIT\n");
 
@@ -2349,7 +2313,8 @@ static int ahci_port_start(struct ata_port *ap)
 	/*
 	 * Switch to per-port locking in case each port has its own MSI vector.
 	 */
-	if ((hpriv->flags & AHCI_HFLAG_MULTI_MSI)) {
+	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI) {
+		spin_lock_init(&pp->intr_lock);
 		spin_lock_init(&pp->lock);
 		ap->lock = &pp->lock;
 	}
-- 
1.8.3.1

