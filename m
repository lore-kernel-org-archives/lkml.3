Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaIUNUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaIUNT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:19:57 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH RESEND v3 6/6] AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI mode
Date: Sun, 21 Sep 2014 15:19:29 +0200
Message-Id: <bad782a13ebaedbe1fd39bcefad2b98712dfe373.1411297686.git.agordeev@redhat.com>
In-Reply-To: <cover.1411297686.git.agordeev@redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
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
 drivers/ata/ahci.h    |  2 ++
 drivers/ata/libahci.c | 59 ++++++++++++---------------------------------------
 2 files changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index c12f590..2476024 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -305,6 +305,8 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32			intr_status;	/* interrupts to handle */
+	spinlock_t		*intr_lock;	/* interrupt context lock */
+	spinlock_t		__intr_lock;	/* protects intr_status */
 	spinlock_t		lock;		/* protects parent ata_port */
 	u32 			intr_mask;	/* interrupts to enable */
 	bool			fbs_supported;	/* set iff FBS is supported */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 169c272..beaeb76 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1785,11 +1785,11 @@ irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 	unsigned long flags;
 	u32 status;
 
-	spin_lock_irqsave(&ap->host->lock, flags);
+	spin_lock_irqsave(pp->intr_lock, flags);
 	status = pp->intr_status;
 	if (status)
 		pp->intr_status = 0;
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+	spin_unlock_irqrestore(pp->intr_lock, flags);
 
 	spin_lock_bh(ap->lock);
 	ahci_handle_port_interrupt(ap, status);
@@ -1842,53 +1842,14 @@ static void ahci_update_intr_status(struct ata_port *ap)
 
 irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
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
+	spin_lock(pp->intr_lock);
+	ahci_update_intr_status(ap);
+	spin_unlock(pp->intr_lock);
 
 	VPRINTK("EXIT\n");
 
@@ -2366,6 +2327,12 @@ static int ahci_port_start(struct ata_port *ap)
 	 */
 	pp->intr_mask = DEF_PORT_IRQ;
 
+	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI) {
+		spin_lock_init(&pp->__intr_lock);
+		pp->intr_lock = &pp->__intr_lock;
+	} else {
+		pp->intr_lock = &ap->host->lock;
+	}
 	spin_lock_init(&pp->lock);
 	ap->lock = &pp->lock;
 
-- 
1.8.3.1

