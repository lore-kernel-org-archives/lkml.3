Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaIKMop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbaIKMon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:44:43 -0400
Date: Thu, 11 Sep 2014 14:44:37 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH v2] AHCI: Optimize interrupt processing
Message-ID: <20140911124437.GB18490@dhcp-27-160.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split interrupt service routine into hardware context handler and
threaded context handler. That allows to protect ports with individual
locks rather than with a single host-wide lock, which results in better
parallelism.

Cc: linux-ide@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/acard-ahci.c       |   3 +-
 drivers/ata/ahci.c             | 100 ++++++++++++++++++++++++++---------------
 drivers/ata/ahci.h             |   8 ++--
 drivers/ata/libahci.c          |  74 +++++++++++++++++-------------
 drivers/ata/libahci_platform.c |   3 +-
 5 files changed, 115 insertions(+), 73 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 25d0ac3..c962886 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -498,8 +498,7 @@ static int acard_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id
 	acard_ahci_pci_print_info(host);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &acard_ahci_sht);
+	return ahci_host_activate(host, pdev->irq, &acard_ahci_sht);
 }
 
 module_pci_driver(acard_ahci_pci_driver);
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a29f801..52decdc 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1211,6 +1211,9 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 		goto single_msi;
 	}
 
+	if (nvec > 1)
+		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+
 	return nvec;
 
 single_msi:
@@ -1223,32 +1226,11 @@ intx:
 	return 0;
 }
 
-/**
- *	ahci_host_activate - start AHCI host, request IRQs and register it
- *	@host: target ATA host
- *	@irq: base IRQ number to request
- *	@n_msis: number of MSIs allocated for this host
- *	@irq_handler: irq_handler used when requesting IRQs
- *	@irq_flags: irq_flags used when requesting IRQs
- *
- *	Similar to ata_host_activate, but requests IRQs according to AHCI-1.1
- *	when multiple MSIs were allocated. That is one MSI per port, starting
- *	from @irq.
- *
- *	LOCKING:
- *	Inherited from calling layer (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
-int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
+static int ahci_host_activate_multi_irqs(struct ata_host *host, int irq,
+					 struct scsi_host_template *sht)
 {
 	int i, rc;
 
-	/* Sharing Last Message among several ports is not supported */
-	if (n_msis < host->n_ports)
-		return -EINVAL;
-
 	rc = ata_host_start(host);
 	if (rc)
 		return rc;
@@ -1263,8 +1245,8 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
 		}
 
 		rc = devm_request_threaded_irq(host->dev, irq + i,
-					       ahci_hw_interrupt,
-					       ahci_thread_fn, IRQF_SHARED,
+					       ahci_multi_irqs_intr,
+					       ahci_port_thread_fn, IRQF_SHARED,
 					       pp->irq_desc, host->ports[i]);
 		if (rc)
 			goto out_free_irqs;
@@ -1273,7 +1255,7 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_desc(host->ports[i], "irq %d", irq + i);
 
-	rc = ata_host_register(host, &ahci_sht);
+	rc = ata_host_register(host, sht);
 	if (rc)
 		goto out_free_all_irqs;
 
@@ -1288,6 +1270,60 @@ out_free_irqs:
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
+
+}
+
+/**
+ *	ahci_host_activate - start AHCI host, request IRQs and register it
+ *	@host: target ATA host
+ *	@irq: base IRQ number to request
+ *	@sht: scsi_host_template to use when registering the host
+ *
+ *	Similar to ata_host_activate, but requests IRQs according to AHCI-1.1
+ *	when multiple MSIs were allocated. That is one MSI per port, starting
+ *	from @irq.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ahci_host_activate(struct ata_host *host, int irq,
+		       struct scsi_host_template *sht)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+
+	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
+		return ahci_host_activate_multi_irqs(host, irq, sht);
+	else
+		return ahci_host_activate_single_irq(host, irq, sht);
+}
+EXPORT_SYMBOL_GPL(ahci_host_activate);
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned int board_id = ent->driver_data;
@@ -1296,7 +1332,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int n_ports, n_msis, i, rc;
+	int n_ports, i, rc;
 	int ahci_pci_bar = AHCI_PCI_BAR_STANDARD;
 
 	VPRINTK("ENTER\n");
@@ -1437,9 +1473,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
-	n_msis = ahci_init_interrupts(pdev, n_ports, hpriv);
-	if (n_msis > 1)
-		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+	ahci_init_interrupts(pdev, n_ports, hpriv);
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
@@ -1491,11 +1525,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
-		return ahci_host_activate(host, pdev->irq, n_msis);
-
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_sht);
+	return ahci_host_activate(host, pdev->irq, &ahci_sht);
 }
 
 module_pci_driver(ahci_pci_driver);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 59ae0ee..c12f590 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -388,11 +388,13 @@ int ahci_port_resume(struct ata_port *ap);
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
+int ahci_host_activate(struct ata_host *host, int irq,
+		       struct scsi_host_template *sht);
 void ahci_error_handler(struct ata_port *ap);
 
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b784e9d..169c272 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1693,9 +1693,9 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
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
@@ -1778,22 +1778,10 @@ static void ahci_handle_port_interrupt(struct ata_port *ap,
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
 
@@ -1804,14 +1792,43 @@ irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
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
 
-static void ahci_hw_port_interrupt(struct ata_port *ap)
+static void ahci_update_intr_status(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1823,7 +1840,7 @@ static void ahci_hw_port_interrupt(struct ata_port *ap)
 	pp->intr_status |= status;
 }
 
-irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
+irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
 {
 	struct ata_port *ap_this = dev_instance;
 	struct ahci_port_priv *pp = ap_this->private_data;
@@ -1859,7 +1876,7 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_hw_port_interrupt(ap);
+			ahci_update_intr_status(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1877,9 +1894,9 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 	return IRQ_WAKE_THREAD;
 }
-EXPORT_SYMBOL_GPL(ahci_hw_interrupt);
+EXPORT_SYMBOL_GPL(ahci_multi_irqs_intr);
 
-irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ahci_host_priv *hpriv;
@@ -1909,7 +1926,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_port_intr(ap);
+			ahci_update_intr_status(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1936,9 +1953,9 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 	VPRINTK("EXIT\n");
 
-	return IRQ_RETVAL(handled);
+	return handled ? IRQ_WAKE_THREAD : IRQ_NONE;
 }
-EXPORT_SYMBOL_GPL(ahci_interrupt);
+EXPORT_SYMBOL_GPL(ahci_single_irq_intr);
 
 unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -2349,13 +2366,8 @@ static int ahci_port_start(struct ata_port *ap)
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
 
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 5b92c29..a085224 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -495,8 +495,7 @@ int ahci_platform_init_host(struct platform_device *pdev,
 	ahci_init_controller(host);
 	ahci_print_info(host, "platform");
 
-	return ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_platform_sht);
+	return ahci_host_activate(host, irq, &ahci_platform_sht);
 }
 EXPORT_SYMBOL_GPL(ahci_platform_init_host);
 
-- 
1.9.3

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
