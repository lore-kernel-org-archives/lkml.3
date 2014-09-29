Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaI2Q0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaI2Q0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:26:16 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v5 2/5] AHCI: Move ahci_host_activate() function to libahci.c
Date: Mon, 29 Sep 2014 18:25:58 +0200
Message-Id: <a515cec913c6b567f90775ebf26841ce000b0057.1412007152.git.agordeev@redhat.com>
In-Reply-To: <cover.1412007152.git.agordeev@redhat.com>
References: <cover.1412007152.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update is a prerequisite for consolidation of
AHCI host activation code within ahci_host_activate()
function.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.c    | 60 --------------------------------------------------
 drivers/ata/libahci.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 60 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fcda5b6..0b21604 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1226,66 +1226,6 @@ intx:
 	return 0;
 }
 
-/**
- *	ahci_host_activate - start AHCI host, request IRQs and register it
- *	@host: target ATA host
- *	@irq: base IRQ number to request
- *	@sht: scsi_host_template to use when registering the host
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
-int ahci_host_activate(struct ata_host *host, int irq,
-		       struct scsi_host_template *sht)
-{
-	int i, rc;
-
-	rc = ata_host_start(host);
-	if (rc)
-		return rc;
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ahci_port_priv *pp = host->ports[i]->private_data;
-
-		/* Do not receive interrupts sent by dummy ports */
-		if (!pp) {
-			disable_irq(irq + i);
-			continue;
-		}
-
-		rc = devm_request_threaded_irq(host->dev, irq + i,
-					       ahci_hw_interrupt,
-					       ahci_thread_fn, IRQF_SHARED,
-					       pp->irq_desc, host->ports[i]);
-		if (rc)
-			goto out_free_irqs;
-	}
-
-	for (i = 0; i < host->n_ports; i++)
-		ata_port_desc(host->ports[i], "irq %d", irq + i);
-
-	rc = ata_host_register(host, sht);
-	if (rc)
-		goto out_free_all_irqs;
-
-	return 0;
-
-out_free_all_irqs:
-	i = host->n_ports;
-out_free_irqs:
-	for (i--; i >= 0; i--)
-		devm_free_irq(host->dev, irq + i, host->ports[i]);
-
-	return rc;
-}
-
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned int board_id = ent->driver_data;
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b784e9d..21bb427 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2472,6 +2472,67 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 }
 EXPORT_SYMBOL_GPL(ahci_set_em_messages);
 
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
+	int i, rc;
+
+	rc = ata_host_start(host);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ahci_port_priv *pp = host->ports[i]->private_data;
+
+		/* Do not receive interrupts sent by dummy ports */
+		if (!pp) {
+			disable_irq(irq + i);
+			continue;
+		}
+
+		rc = devm_request_threaded_irq(host->dev, irq + i,
+					       ahci_hw_interrupt,
+					       ahci_thread_fn, IRQF_SHARED,
+					       pp->irq_desc, host->ports[i]);
+		if (rc)
+			goto out_free_irqs;
+	}
+
+	for (i = 0; i < host->n_ports; i++)
+		ata_port_desc(host->ports[i], "irq %d", irq + i);
+
+	rc = ata_host_register(host, sht);
+	if (rc)
+		goto out_free_all_irqs;
+
+	return 0;
+
+out_free_all_irqs:
+	i = host->n_ports;
+out_free_irqs:
+	for (i--; i >= 0; i--)
+		devm_free_irq(host->dev, irq + i, host->ports[i]);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(ahci_host_activate);
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Common AHCI SATA low-level routines");
 MODULE_LICENSE("GPL");
-- 
1.8.3.1

