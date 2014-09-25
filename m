Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaIYNOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbaIYNNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:13:44 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v4 3/4] AHCI: Make few function names more descriptive
Date: Thu, 25 Sep 2014 15:13:23 +0200
Message-Id: <138557d68c4f06f12244e8d43c7058aa7b1382f2.1411648623.git.agordeev@redhat.com>
In-Reply-To: <cover.1411648623.git.agordeev@redhat.com>
References: <cover.1411648623.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/libahci.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 0080551..48175e5 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1789,7 +1789,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	ahci_handle_port_interrupt(ap, port_mmio, status);
 }
 
-static irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
+static irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 {
 	struct ata_port *ap = dev_instance;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1810,7 +1810,7 @@ static irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
-static void ahci_hw_port_interrupt(struct ata_port *ap)
+static void ahci_update_intr_status(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1822,7 +1822,7 @@ static void ahci_hw_port_interrupt(struct ata_port *ap)
 	pp->intr_status |= status;
 }
 
-static irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
+static irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
 {
 	struct ata_port *ap_this = dev_instance;
 	struct ahci_port_priv *pp = ap_this->private_data;
@@ -1858,7 +1858,7 @@ static irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_hw_port_interrupt(ap);
+			ahci_update_intr_status(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1877,7 +1877,7 @@ static irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 	return IRQ_WAKE_THREAD;
 }
 
-static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ahci_host_priv *hpriv;
@@ -2488,8 +2488,8 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host, int irq,
 		}
 
 		rc = devm_request_threaded_irq(host->dev, irq + i,
-					       ahci_hw_interrupt,
-					       ahci_thread_fn, IRQF_SHARED,
+					       ahci_multi_irqs_intr,
+					       ahci_port_thread_fn, IRQF_SHARED,
 					       pp->irq_desc, host->ports[i]);
 		if (rc)
 			goto out_free_irqs;
@@ -2538,7 +2538,7 @@ int ahci_host_activate(struct ata_host *host, int irq,
 	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
 		rc = ahci_host_activate_multi_irqs(host, irq, sht);
 	else
-		rc = ata_host_activate(host, irq, ahci_interrupt,
+		rc = ata_host_activate(host, irq, ahci_single_irq_intr,
 				       IRQF_SHARED, sht);
 	return rc;
 }
-- 
1.8.3.1

