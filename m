Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaI2Q1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaI2Q0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:26:19 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v5 3/5] AHCI: Move host activation code into ahci_host_activate()
Date: Mon, 29 Sep 2014 18:25:59 +0200
Message-Id: <548a7d45d36d59114aa49ba4871a4f8ec2de4293.1412007152.git.agordeev@redhat.com>
In-Reply-To: <cover.1412007152.git.agordeev@redhat.com>
References: <cover.1412007152.git.agordeev@redhat.com>
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
 drivers/ata/ahci.c             |  6 +----
 drivers/ata/ahci.h             |  3 ---
 drivers/ata/libahci.c          | 59 +++++++++++++++++++++++++-----------------
 drivers/ata/libahci_platform.c |  3 +--
 drivers/ata/sata_highbank.c    |  3 +--
 6 files changed, 39 insertions(+), 38 deletions(-)

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
index 0b21604..d0ac38b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1427,11 +1427,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
-		return ahci_host_activate(host, pdev->irq, &ahci_sht);
-
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_sht);
+	return ahci_host_activate(host, pdev->irq, &ahci_sht);
 }
 
 module_pci_driver(ahci_pci_driver);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 31b4c44..6a22055 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -388,9 +388,6 @@ int ahci_port_resume(struct ata_port *ap);
 void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi);
 int ahci_reset_em(struct ata_host *host);
-irqreturn_t ahci_interrupt(int irq, void *dev_instance);
-irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance);
-irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
 int ahci_host_activate(struct ata_host *host, int irq,
 		       struct scsi_host_template *sht);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 21bb427..0080551 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1789,7 +1789,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	ahci_handle_port_interrupt(ap, port_mmio, status);
 }
 
-irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
+static irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
 {
 	struct ata_port *ap = dev_instance;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1809,7 +1809,6 @@ irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
 
 	return IRQ_HANDLED;
 }
-EXPORT_SYMBOL_GPL(ahci_thread_fn);
 
 static void ahci_hw_port_interrupt(struct ata_port *ap)
 {
@@ -1823,7 +1822,7 @@ static void ahci_hw_port_interrupt(struct ata_port *ap)
 	pp->intr_status |= status;
 }
 
-irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
+static irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 {
 	struct ata_port *ap_this = dev_instance;
 	struct ahci_port_priv *pp = ap_this->private_data;
@@ -1877,9 +1876,8 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance)
 
 	return IRQ_WAKE_THREAD;
 }
-EXPORT_SYMBOL_GPL(ahci_hw_interrupt);
 
-irqreturn_t ahci_interrupt(int irq, void *dev_instance)
+static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	struct ahci_host_priv *hpriv;
@@ -1938,7 +1936,6 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 	return IRQ_RETVAL(handled);
 }
-EXPORT_SYMBOL_GPL(ahci_interrupt);
 
 unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -2472,24 +2469,8 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 }
 EXPORT_SYMBOL_GPL(ahci_set_em_messages);
 
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
+static int ahci_host_activate_multi_irqs(struct ata_host *host, int irq,
+					 struct scsi_host_template *sht)
 {
 	int i, rc;
 
@@ -2531,6 +2512,36 @@ out_free_irqs:
 
 	return rc;
 }
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
+	int rc;
+
+	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
+		rc = ahci_host_activate_multi_irqs(host, irq, sht);
+	else
+		rc = ata_host_activate(host, irq, ahci_interrupt,
+				       IRQF_SHARED, sht);
+	return rc;
+}
 EXPORT_SYMBOL_GPL(ahci_host_activate);
 
 MODULE_AUTHOR("Jeff Garzik");
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index c7f787e..0b03f90 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -493,8 +493,7 @@ int ahci_platform_init_host(struct platform_device *pdev,
 	ahci_init_controller(host);
 	ahci_print_info(host, "platform");
 
-	return ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_platform_sht);
+	return ahci_host_activate(host, irq, &ahci_platform_sht);
 }
 EXPORT_SYMBOL_GPL(ahci_platform_init_host);
 
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index da3bc27..ce2b99a 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -568,8 +568,7 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	ahci_init_controller(host);
 	ahci_print_info(host, "platform");
 
-	rc = ata_host_activate(host, irq, ahci_interrupt, 0,
-					&ahci_highbank_platform_sht);
+	rc = ahci_host_activate(host, irq, &ahci_highbank_platform_sht);
 	if (rc)
 		goto err0;
 
-- 
1.8.3.1

