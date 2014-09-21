Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaIUNUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:20:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaIUNTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:19:55 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt processing
Date: Sun, 21 Sep 2014 15:19:28 +0200
Message-Id: <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
In-Reply-To: <cover.1411297686.git.agordeev@redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split interrupt service routine into hardware context handler
and threaded context handler. That allows to protect ports with
individual locks rather than with a single host-wide lock and
move port interrupts handling out of the hardware interrupt
context.

Testing was done by transferring 8GB on two hard drives in
parallel using command 'dd if=/dev/sd{a,b} of=/dev/null'. With
lock_stat statistics I measured access times to ata_host::lock
spinlock (since interrupt handler code is fully embraced with
this lock). The average lock's holdtime decreased eight times
while average waittime decreased two times.

Both before and after the change the transfer time is the same,
while 'perf record -e cycles:k ...' shows 1%-4% CPU time spent
in ahci_single_irq_intr() routine before the update and not even
sampled/shown ahci_single_irq_intr() after the update.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.c    | 29 ++++++++++++++++++++++++++--
 drivers/ata/ahci.h    |  1 +
 drivers/ata/libahci.c | 53 ++++++++++++++++++++++++++++++++-------------------
 3 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4a849f8..0a6d112 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1280,6 +1280,31 @@ out_free_irqs:
 	return rc;
 }
 
+static int ahci_host_activate_single_irq(struct ata_host *host, int irq,
+					 struct scsi_host_template *sht)
+{
+	int i, rc;
+
+	rc = ata_host_start(host);
+	if (rc)
+		return rc;
+
+	rc = devm_request_threaded_irq(host->dev, irq, ahci_single_irq_intr,
+				       ahci_thread_fn, IRQF_SHARED,
+				       dev_driver_string(host->dev), host);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < host->n_ports; i++)
+		ata_port_desc(host->ports[i], "irq %d", irq);
+
+	rc = ata_host_register(host, sht);
+	if (rc)
+		devm_free_irq(host->dev, irq, host);
+
+	return rc;
+}
+
 /**
  *	ahci_host_activate - start AHCI host, request IRQs and register it
  *	@host: target ATA host
@@ -1305,8 +1330,8 @@ int ahci_host_activate(struct ata_host *host, int irq,
 	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
 		rc = ahci_host_activate_multi_irqs(host, irq, sht);
 	else
-		rc = ata_host_activate(host, irq, ahci_single_irq_intr,
-				       IRQF_SHARED, sht);
+		rc = ahci_host_activate_single_irq(host, irq, sht);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(ahci_host_activate);
 
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 44c02f7..c12f590 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -390,6 +390,7 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 int ahci_reset_em(struct ata_host *host);
 irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance);
 irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance);
+irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
 irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
 int ahci_host_activate(struct ata_host *host, int irq,
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index cbe7757..169c272 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1778,17 +1778,6 @@ static void ahci_handle_port_interrupt(struct ata_port *ap, u32 status)
 	}
 }
 
-static void ahci_port_intr(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 status;
-
-	status = readl(port_mmio + PORT_IRQ_STAT);
-	writel(status, port_mmio + PORT_IRQ_STAT);
-
-	ahci_handle_port_interrupt(ap, status);
-}
-
 irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 {
 	struct ata_port *ap = dev_instance;
@@ -1810,6 +1799,35 @@ irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 }
 EXPORT_SYMBOL_GPL(ahci_port_thread_fn);
 
+irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct ahci_host_priv *hpriv = host->private_data;
+	u32 irq_masked = hpriv->port_map;
+	unsigned int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+
+		if (!(irq_masked & (1 << i)))
+			continue;
+
+		ap = host->ports[i];
+		if (ap) {
+			ahci_port_thread_fn(irq, ap);
+			VPRINTK("port %u\n", i);
+		} else {
+			VPRINTK("port %u (no irq)\n", i);
+			if (ata_ratelimit())
+				dev_warn(host->dev,
+					 "interrupt on disabled port %u\n", i);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL_GPL(ahci_thread_fn);
+
 static void ahci_update_intr_status(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -1908,7 +1926,7 @@ irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_port_intr(ap);
+			ahci_update_intr_status(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1935,7 +1953,7 @@ irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 
 	VPRINTK("EXIT\n");
 
-	return IRQ_RETVAL(handled);
+	return handled ? IRQ_WAKE_THREAD : IRQ_NONE;
 }
 EXPORT_SYMBOL_GPL(ahci_single_irq_intr);
 
@@ -2348,13 +2366,8 @@ static int ahci_port_start(struct ata_port *ap)
 	 */
 	pp->intr_mask = DEF_PORT_IRQ;
 
-	/*
-	 * Switch to per-port locking in case each port has its own MSI vector.
-	 */
-	if ((hpriv->flags & AHCI_HFLAG_MULTI_MSI)) {
-		spin_lock_init(&pp->lock);
-		ap->lock = &pp->lock;
-	}
+	spin_lock_init(&pp->lock);
+	ap->lock = &pp->lock;
 
 	ap->private_data = pp;
 
-- 
1.8.3.1

