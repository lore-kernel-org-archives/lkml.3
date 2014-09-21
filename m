Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaIUNUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:20:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaIUNTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:19:48 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH RESEND v3 1/6] AHCI: Cleanup checking of multiple MSIs/SLM modes
Date: Sun, 21 Sep 2014 15:19:24 +0200
Message-Id: <e5b010c7698160c8b93c92e7463f5dbb4cf33e52.1411297686.git.agordeev@redhat.com>
In-Reply-To: <cover.1411297686.git.agordeev@redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sharing Last Message (SLM) mode is currently checked in two
functions: ahci_host_activate() and ahci_init_interrupts().
This update consolidates SLM mode check with activation of
multiple MSIs mode.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.c | 18 +++++++-----------
 drivers/ata/ahci.h |  2 +-
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a0cc0ed..7a86b32 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1221,6 +1221,9 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 		goto single_msi;
 	}
 
+	if (nvec > 1)
+		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+
 	return nvec;
 
 single_msi:
@@ -1237,7 +1240,6 @@ intx:
  *	ahci_host_activate - start AHCI host, request IRQs and register it
  *	@host: target ATA host
  *	@irq: base IRQ number to request
- *	@n_msis: number of MSIs allocated for this host
  *	@irq_handler: irq_handler used when requesting IRQs
  *	@irq_flags: irq_flags used when requesting IRQs
  *
@@ -1251,14 +1253,10 @@ intx:
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
+int ahci_host_activate(struct ata_host *host, int irq)
 {
 	int i, rc;
 
-	/* Sharing Last Message among several ports is not supported */
-	if (n_msis < host->n_ports)
-		return -EINVAL;
-
 	rc = ata_host_start(host);
 	if (rc)
 		return rc;
@@ -1306,7 +1304,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int n_ports, n_msis, i, rc;
+	int n_ports, i, rc;
 	int ahci_pci_bar = AHCI_PCI_BAR_STANDARD;
 
 	VPRINTK("ENTER\n");
@@ -1459,9 +1457,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
-	n_msis = ahci_init_interrupts(pdev, n_ports, hpriv);
-	if (n_msis > 1)
-		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+	ahci_init_interrupts(pdev, n_ports, hpriv);
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
@@ -1514,7 +1510,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 
 	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
-		return ahci_host_activate(host, pdev->irq, n_msis);
+		return ahci_host_activate(host, pdev->irq);
 
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 59ae0ee..a2a31af 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -392,7 +392,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance);
 irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance);
 irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
-int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis);
+int ahci_host_activate(struct ata_host *host, int irq);
 void ahci_error_handler(struct ata_port *ap);
 
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
-- 
1.8.3.1

