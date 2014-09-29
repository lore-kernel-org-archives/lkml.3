Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaI2KNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaI2KND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:13:03 -0400
Date: Mon, 29 Sep 2014 11:21:51 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        "Jiang, Dave" <dave.jiang@intel.com>
Subject: [PATCH] AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI mode
Message-ID: <20140929102150.GC8971@agordeev.usersys.redhat.com>
References: <cover.1411648623.git.agordeev@redhat.com>
 <82c0cbbafd74eca0e346ca97f73838ba236315c3.1411648623.git.agordeev@redhat.com>
 <20140928161050.GC8050@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928161050.GC8050@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
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
Cc: "Jiang, Dave" <dave.jiang@intel.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.h    |  2 +-
 drivers/ata/libahci.c | 67 ++++++---------------------------------------------
 2 files changed, 9 insertions(+), 60 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 6a22055..40f0e34 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -304,7 +304,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
-	u32			intr_status;	/* interrupts to handle */
+	atomic_t		intr_status;	/* interrupts to handle */
 	spinlock_t		lock;		/* protects parent ata_port */
 	u32 			intr_mask;	/* interrupts to enable */
 	bool			fbs_supported;	/* set iff FBS is supported */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 48175e5..97683e4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1794,14 +1794,11 @@ static irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 	struct ata_port *ap = dev_instance;
 	struct ahci_port_priv *pp = ap->private_data;
 	void __iomem *port_mmio = ahci_port_base(ap);
-	unsigned long flags;
 	u32 status;
 
-	spin_lock_irqsave(&ap->host->lock, flags);
-	status = pp->intr_status;
-	if (status)
-		pp->intr_status = 0;
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+	status = atomic_xchg(&pp->intr_status, 0);
+	if (!status)
+		return IRQ_NONE;
 
 	spin_lock_bh(ap->lock);
 	ahci_handle_port_interrupt(ap, port_mmio, status);
@@ -1810,67 +1807,19 @@ static irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
-static void ahci_update_intr_status(struct ata_port *ap)
+static irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
 {
+	struct ata_port *ap = dev_instance;
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_port_priv *pp = ap->private_data;
 	u32 status;
 
-	status = readl(port_mmio + PORT_IRQ_STAT);
-	writel(status, port_mmio + PORT_IRQ_STAT);
-
-	pp->intr_status |= status;
-}
-
-static irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
-{
-	struct ata_port *ap_this = dev_instance;
-	struct ahci_port_priv *pp = ap_this->private_data;
-	struct ata_host *host = ap_this->host;
-	struct ahci_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = hpriv->mmio;
-	unsigned int i;
-	u32 irq_stat, irq_masked;
-
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
+	status = readl(port_mmio + PORT_IRQ_STAT);
+	writel(status, port_mmio + PORT_IRQ_STAT);
 
-	spin_unlock(&host->lock);
+	atomic_or(status, &pp->intr_status);
 
 	VPRINTK("EXIT\n");
 
-- 
1.8.3.1

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
