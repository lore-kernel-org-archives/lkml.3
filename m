Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaIUNUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaIUNTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:19:52 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH RESEND v3 3/6] AHCI: Make few function names more descriptive
Date: Sun, 21 Sep 2014 15:19:26 +0200
Message-Id: <fe20e3ee0fb7b3f68de0015dac11021c68823cf6.1411297686.git.agordeev@redhat.com>
In-Reply-To: <cover.1411297686.git.agordeev@redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.c    |  7 +++----
 drivers/ata/ahci.h    |  6 +++---
 drivers/ata/libahci.c | 16 ++++++++--------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7ce8e01..4a849f8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1255,8 +1255,8 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host, int irq,
 		}
 
 		rc = devm_request_threaded_irq(host->dev, irq + i,
-					       ahci_hw_interrupt,
-					       ahci_thread_fn, IRQF_SHARED,
+					       ahci_multi_irqs_intr,
+					       ahci_port_thread_fn, IRQF_SHARED,
 					       pp->irq_desc, host->ports[i]);
 		if (rc)
 			goto out_free_irqs;
@@ -1305,9 +1305,8 @@ int ahci_host_activate(struct ata_host *host, int irq,
 	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
 		rc = ahci_host_activate_multi_irqs(host, irq, sht);
 	else
-		rc = ata_host_activate(host, irq, ahci_interrupt,
+		rc = ata_host_activate(host, irq, ahci_single_irq_intr,
 				       IRQF_SHARED, sht);
-	return rc;
 }
 EXPORT_SYMBOL_GPL(ahci_host_activate);
 
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 1a9955c..44c02f7 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -388,9 +388,9 @@ int ahci_port_resume(struct ata_port *ap);
 void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi);
 int ahci_reset_em(struct ata_host *host);
-irqreturn_t ahci_interrupt(int irq, void *dev_instance);
-irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance);
-irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
+irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance);
+irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance);
+irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
 int ahci_host_activate(struct ata_host *host, int irq,
 		       struct scsi_host_template *sht);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b784e9d..e6ef3d4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1789,7 +1789,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	ahci_handle_port_interrupt(ap, port_mmio, status);
 }
 
-irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
+irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 {
 	struct ata_port *ap = dev_instance;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1809,9 +1809,9 @@ irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
 
 	return IRQ_HANDLED;
 }
-EXPORT_SYMBOL_GPL(ahci_thread_fn);
+EXPORT_SYMBOL_GPL(ahci_port_thread_fn);
 
-static void ahci_hw_port_interrupt(struct ata_port *ap)
+static void ahci_update_intr_status(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1823,7 +1823,7 @@ static void ahci_hw_port_interrupt(struct ata_port *ap)
 	pp->intr_status |= status;
 }
 
-irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
+irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
 {
 	struct ata_port *ap_this = dev_instance;
 	struct ahci_port_priv *pp = ap_this->private_data;
@@ -1859,7 +1859,7 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_hw_port_interrupt(ap);
+			ahci_update_intr_status(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1877,9 +1877,9 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 	return IRQ_WAKE_THREAD;
 }
-EXPORT_SYMBOL_GPL(ahci_hw_interrupt);
+EXPORT_SYMBOL_GPL(ahci_multi_irqs_intr);
 
-irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ahci_host_priv *hpriv;
@@ -1938,7 +1938,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 	return IRQ_RETVAL(handled);
 }
-EXPORT_SYMBOL_GPL(ahci_interrupt);
+EXPORT_SYMBOL_GPL(ahci_single_irq_intr);
 
 unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
-- 
1.8.3.1

