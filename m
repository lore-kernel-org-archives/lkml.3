Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaIUNUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:20:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaIUNTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:19:50 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH RESEND v3 2/6] AHCI: Move host activation code into ahci_host_activate()
Date: Sun, 21 Sep 2014 15:19:25 +0200
Message-Id: <4dde1cd7e44724d464b87c14c6192dec52fc8b50.1411297686.git.agordeev@redhat.com>
In-Reply-To: <cover.1411297686.git.agordeev@redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently host activation done by calling either function
ahci_host_activate() or ata_host_activate(). Consolidate
the code by only calling ahci_host_activate() for all AHCI
devices.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/acard-ahci.c       |  3 +--
 drivers/ata/ahci.c             | 59 +++++++++++++++++++++++++-----------------
 drivers/ata/ahci.h             |  3 ++-
 drivers/ata/libahci_platform.c |  3 +--
 4 files changed, 39 insertions(+), 29 deletions(-)

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
index 7a86b32..7ce8e01 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1236,24 +1236,8 @@ intx:
 	return 0;
 }
 
-/**
- *	ahci_host_activate - start AHCI host, request IRQs and register it
- *	@host: target ATA host
- *	@irq: base IRQ number to request
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
-int ahci_host_activate(struct ata_host *host, int irq)
+static int ahci_host_activate_multi_irqs(struct ata_host *host, int irq,
+					 struct scsi_host_template *sht)
 {
 	int i, rc;
 
@@ -1281,7 +1265,7 @@ int ahci_host_activate(struct ata_host *host, int irq)
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_desc(host->ports[i], "irq %d", irq + i);
 
-	rc = ata_host_register(host, &ahci_sht);
+	rc = ata_host_register(host, sht);
 	if (rc)
 		goto out_free_all_irqs;
 
@@ -1296,6 +1280,37 @@ out_free_irqs:
 	return rc;
 }
 
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
+	int rc;
+
+	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
+		rc = ahci_host_activate_multi_irqs(host, irq, sht);
+	else
+		rc = ata_host_activate(host, irq, ahci_interrupt,
+				       IRQF_SHARED, sht);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_host_activate);
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned int board_id = ent->driver_data;
@@ -1509,11 +1524,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
-		return ahci_host_activate(host, pdev->irq);
-
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_sht);
+	return ahci_host_activate(host, pdev->irq, &ahci_sht);
 }
 
 module_pci_driver(ahci_pci_driver);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index a2a31af..1a9955c 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -392,7 +392,8 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance);
 irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance);
 irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
-int ahci_host_activate(struct ata_host *host, int irq);
+int ahci_host_activate(struct ata_host *host, int irq,
+		       struct scsi_host_template *sht);
 void ahci_error_handler(struct ata_port *ap);
 
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
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
1.8.3.1

