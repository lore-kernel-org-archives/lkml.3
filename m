Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3HEThn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3HEThi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:37:38 -0400
Subject: [PATCH v4 5/9] pci: Split out pci_dev lock/unlock and save/restore
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: ddutile@redhat.com, indou.takao@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 13:37:34 -0600
Message-ID: <20130805193734.9260.69622.stgit@bling.home>
In-Reply-To: <20130805193200.9260.38729.stgit@bling.home>
References: <20130805193200.9260.38729.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only cosmetic code changes to existing paths.  Expand the comment in
the new pci_dev_save_and_disable() function since there's a lot
hidden in that Command register write.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   55 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 9407aab..4a0275c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3317,22 +3317,49 @@ done:
 	return rc;
 }
 
+static void pci_dev_lock(struct pci_dev *dev)
+{
+	pci_cfg_access_lock(dev);
+	/* block PM suspend, driver probe, etc. */
+	device_lock(&dev->dev);
+}
+
+static void pci_dev_unlock(struct pci_dev *dev)
+{
+	device_unlock(&dev->dev);
+	pci_cfg_access_unlock(dev);
+}
+
+static void pci_dev_save_and_disable(struct pci_dev *dev)
+{
+	pci_save_state(dev);
+	/*
+	 * Disable the device by clearing the Command register, except for
+	 * INTx-disable which is set.  This not only disable MMIO and I/O port
+	 * BARs, but also prevents the device from being Bus Master, preventing
+	 * DMA from the device including MSI/MSI-X interrupts.  For PCI 2.3
+	 * compliant devices, INTx-disable prevents legacy interrupts.
+	 */
+	pci_write_config_word(dev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+}
+
+static void pci_dev_restore(struct pci_dev *dev)
+{
+	pci_restore_state(dev);
+}
+
 static int pci_dev_reset(struct pci_dev *dev, int probe)
 {
 	int rc;
 
-	if (!probe) {
-		pci_cfg_access_lock(dev);
-		/* block PM suspend, driver probe, etc. */
-		device_lock(&dev->dev);
-	}
+	if (!probe)
+		pci_dev_lock(dev);
 
 	rc = __pci_dev_reset(dev, probe);
 
-	if (!probe) {
-		device_unlock(&dev->dev);
-		pci_cfg_access_unlock(dev);
-	}
+	if (!probe)
+		pci_dev_unlock(dev);
+
 	return rc;
 }
 /**
@@ -3423,17 +3450,11 @@ int pci_reset_function(struct pci_dev *dev)
 	if (rc)
 		return rc;
 
-	pci_save_state(dev);
-
-	/*
-	 * both INTx and MSI are disabled after the Interrupt Disable bit
-	 * is set and the Bus Master bit is cleared.
-	 */
-	pci_write_config_word(dev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+	pci_dev_save_and_disable(dev);
 
 	rc = pci_dev_reset(dev, 0);
 
-	pci_restore_state(dev);
+	pci_dev_restore(dev);
 
 	return rc;
 }

