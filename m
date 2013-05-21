Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3EUTAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:00:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab3EUTAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:00:30 -0400
Date: Tue, 21 May 2013 21:00:54 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Jan Beulich <JBeulich@suse.com>
Subject: [PATCH RESEND 1/1] AHCI: Optimize interrupt processing
Message-ID: <61d2ba7c83abada5841d4b12254d1f428842437c.1369155164.git.agordeev@redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1369155164.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split interrupt service routine into hardware context handler and
threaded context handler. That allows to protect ports with individual
locks rather than with a single host-wide lock, which results in better
parallelism.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/acard-ahci.c    |    8 ++---
 drivers/ata/ahci.c          |   54 ++++++++++++++++++-------------
 drivers/ata/ahci.h          |   10 +++--
 drivers/ata/ahci_platform.c |    3 +-
 drivers/ata/libahci.c       |   74 +++++++++++++++++++++++++------------------
 5 files changed, 85 insertions(+), 64 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 4e94ba2..e429225 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -409,7 +409,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int n_ports, i, rc;
+	int n_ports, n_msis, i, rc;
 
 	VPRINTK("ENTER\n");
 
@@ -436,8 +436,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 		return -ENOMEM;
 	hpriv->flags |= (unsigned long)pi.private_data;
 
-	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
-		pci_enable_msi(pdev);
+	n_msis = ahci_init_interrupts(pdev, hpriv);
 
 	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
 
@@ -499,8 +498,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 	acard_ahci_pci_print_info(host);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &acard_ahci_sht);
+	return ahci_host_activate(host, pdev->irq, n_msis, &acard_ahci_sht);
 }
 
 module_pci_driver(acard_ahci_pci_driver);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 251e57d..e4d915f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1110,14 +1110,14 @@ int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
 	pci_intx(pdev, 1);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_init_interrupts);
 
 /**
  *	ahci_host_activate - start AHCI host, request IRQs and register it
  *	@host: target ATA host
  *	@irq: base IRQ number to request
  *	@n_msis: number of MSIs allocated for this host
- *	@irq_handler: irq_handler used when requesting IRQs
- *	@irq_flags: irq_flags used when requesting IRQs
+ *	@sht: scsi_host_template to use when registering the host
  *
  *	Similar to ata_host_activate, but requests IRQs according to AHCI-1.1
  *	when multiple MSIs were allocated. That is one MSI per port, starting
@@ -1129,43 +1129,59 @@ int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
+int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis,
+		       struct scsi_host_template *sht)
 {
 	int i, rc;
-
-	/* Sharing Last Message among several ports is not supported */
-	if (n_msis < host->n_ports)
-		return -EINVAL;
+	unsigned int n_irqs;
 
 	rc = ata_host_start(host);
 	if (rc)
 		return rc;
 
-	for (i = 0; i < host->n_ports; i++) {
-		rc = devm_request_threaded_irq(host->dev,
-			irq + i, ahci_hw_interrupt, ahci_thread_fn, IRQF_SHARED,
-			dev_driver_string(host->dev), host->ports[i]);
+	n_irqs = min(host->n_ports, n_msis);
+	n_irqs = max(n_irqs, 1u);
+
+	if (n_irqs > 1) {
+		/* Sharing Last Message among several ports is not supported */
+		if (n_irqs < host->n_ports)
+			return -EINVAL;
+
+		for (i = 0; i < n_irqs; i++) {
+			rc = devm_request_threaded_irq(host->dev, irq + i,
+				ahci_multi_irqs_intr, ahci_port_thread_fn,
+				IRQF_SHARED, dev_driver_string(host->dev),
+				host->ports[i]);
+			if (rc)
+				goto out_free_irqs;
+		}
+	} else {
+		rc = devm_request_threaded_irq(host->dev, irq,
+			ahci_single_irq_intr, ahci_thread_fn, IRQF_SHARED,
+			dev_driver_string(host->dev), host);
 		if (rc)
-			goto out_free_irqs;
+			goto out;
 	}
 
-	for (i = 0; i < host->n_ports; i++)
+	for (i = 0; i < n_irqs; i++)
 		ata_port_desc(host->ports[i], "irq %d", irq + i);
 
-	rc = ata_host_register(host, &ahci_sht);
+	rc = ata_host_register(host, sht);
 	if (rc)
 		goto out_free_all_irqs;
 
 	return 0;
 
 out_free_all_irqs:
-	i = host->n_ports;
+	i = n_irqs;
 out_free_irqs:
 	for (i--; i >= 0; i--)
 		devm_free_irq(host->dev, irq + i, host->ports[i]);
+out:
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ahci_host_activate);
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -1265,8 +1281,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
 	n_msis = ahci_init_interrupts(pdev, hpriv);
-	if (n_msis > 1)
-		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
 
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
@@ -1364,11 +1378,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
-		return ahci_host_activate(host, pdev->irq, n_msis);
-
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_sht);
+	return ahci_host_activate(host, pdev->irq, n_msis, &ahci_sht);
 }
 
 module_pci_driver(ahci_pci_driver);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b830e6c..ed1fbc8 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -231,7 +231,6 @@ enum {
 	AHCI_HFLAG_DELAY_ENGINE		= (1 << 15), /* do not start engine on
 						        port start (wait until
 						        error-handling stage) */
-	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
 
 	/* ap->flags bits */
 
@@ -361,11 +360,14 @@ int ahci_port_resume(struct ata_port *ap);
 void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi);
 int ahci_reset_em(struct ata_host *host);
-irqreturn_t ahci_interrupt(int irq, void *dev_instance);
-irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance);
+irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance);
+irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance);
 irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
+irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
-int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis);
+int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis,
+		       struct scsi_host_template *sht);
+int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv);
 
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
 					     unsigned int port_no)
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 7a8a284..b10cd87 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -211,8 +211,7 @@ static int ahci_probe(struct platform_device *pdev)
 	ahci_init_controller(host);
 	ahci_print_info(host, "platform");
 
-	rc = ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
-			       &ahci_platform_sht);
+	rc = ahci_host_activate(host, irq, 0, &ahci_platform_sht);
 	if (rc)
 		goto pdata_exit;
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 34c8216..68b3bdd 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1655,9 +1655,9 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		ata_port_abort(ap);
 }
 
-static void ahci_handle_port_interrupt(struct ata_port *ap,
-				       void __iomem *port_mmio, u32 status)
+static void ahci_handle_port_interrupt(struct ata_port *ap, u32 status)
 {
+	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1740,22 +1740,10 @@ static void ahci_handle_port_interrupt(struct ata_port *ap,
 	}
 }
 
-void ahci_port_intr(struct ata_port *ap)
-{
-	void __iomem *port_mmio = ahci_port_base(ap);
-	u32 status;
-
-	status = readl(port_mmio + PORT_IRQ_STAT);
-	writel(status, port_mmio + PORT_IRQ_STAT);
-
-	ahci_handle_port_interrupt(ap, port_mmio, status);
-}
-
-irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
+irqreturn_t ahci_port_thread_fn(int irq, void *dev_instance)
 {
 	struct ata_port *ap = dev_instance;
 	struct ahci_port_priv *pp = ap->private_data;
-	void __iomem *port_mmio = ahci_port_base(ap);
 	unsigned long flags;
 	u32 status;
 
@@ -1766,14 +1754,43 @@ irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
 	spin_unlock_irqrestore(&ap->host->lock, flags);
 
 	spin_lock_bh(ap->lock);
-	ahci_handle_port_interrupt(ap, port_mmio, status);
+	ahci_handle_port_interrupt(ap, status);
 	spin_unlock_bh(ap->lock);
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(ahci_port_thread_fn);
+
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
 EXPORT_SYMBOL_GPL(ahci_thread_fn);
 
-void ahci_hw_port_interrupt(struct ata_port *ap)
+void ahci_update_intr_status(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1785,7 +1802,7 @@ void ahci_hw_port_interrupt(struct ata_port *ap)
 	pp->intr_status |= status;
 }
 
-irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
+irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
 {
 	struct ata_port *ap_this = dev_instance;
 	struct ahci_port_priv *pp = ap_this->private_data;
@@ -1821,7 +1838,7 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_hw_port_interrupt(ap);
+			ahci_update_intr_status(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1839,9 +1856,9 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 	return IRQ_WAKE_THREAD;
 }
-EXPORT_SYMBOL_GPL(ahci_hw_interrupt);
+EXPORT_SYMBOL_GPL(ahci_multi_irqs_intr);
 
-irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ahci_host_priv *hpriv;
@@ -1871,7 +1888,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_port_intr(ap);
+			ahci_update_intr_status(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1898,9 +1915,9 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 	VPRINTK("EXIT\n");
 
-	return IRQ_RETVAL(handled);
+	return handled ? IRQ_WAKE_THREAD : IRQ_NONE;
 }
-EXPORT_SYMBOL_GPL(ahci_interrupt);
+EXPORT_SYMBOL_GPL(ahci_single_irq_intr);
 
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -2294,13 +2311,8 @@ static int ahci_port_start(struct ata_port *ap)
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
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
