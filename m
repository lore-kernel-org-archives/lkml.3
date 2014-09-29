Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaI2Q0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:26:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbaI2Q0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:26:15 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v5 1/5] AHCI: Pass SCSI host template as arg to ahci_host_activate()
Date: Mon, 29 Sep 2014 18:25:57 +0200
Message-Id: <25463ff3da3daca105ffd0a6299a21268fba7452.1412007152.git.agordeev@redhat.com>
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
 drivers/ata/ahci.c | 10 +++++-----
 drivers/ata/ahci.h |  3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index f68a995..fcda5b6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1230,8 +1230,7 @@ intx:
  *	ahci_host_activate - start AHCI host, request IRQs and register it
  *	@host: target ATA host
  *	@irq: base IRQ number to request
- *	@irq_handler: irq_handler used when requesting IRQs
- *	@irq_flags: irq_flags used when requesting IRQs
+ *	@sht: scsi_host_template to use when registering the host
  *
  *	Similar to ata_host_activate, but requests IRQs according to AHCI-1.1
  *	when multiple MSIs were allocated. That is one MSI per port, starting
@@ -1243,7 +1242,8 @@ intx:
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ahci_host_activate(struct ata_host *host, int irq)
+int ahci_host_activate(struct ata_host *host, int irq,
+		       struct scsi_host_template *sht)
 {
 	int i, rc;
 
@@ -1271,7 +1271,7 @@ int ahci_host_activate(struct ata_host *host, int irq)
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_desc(host->ports[i], "irq %d", irq + i);
 
-	rc = ata_host_register(host, &ahci_sht);
+	rc = ata_host_register(host, sht);
 	if (rc)
 		goto out_free_all_irqs;
 
@@ -1488,7 +1488,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 
 	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
-		return ahci_host_activate(host, pdev->irq);
+		return ahci_host_activate(host, pdev->irq, &ahci_sht);
 
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index a074c73..31b4c44 100644
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
-- 
1.8.3.1

