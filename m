Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3EHC6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:58:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab3EHC6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:58:15 -0400
Subject: [PATCH v2 6/8] pci: Split out pci_dev lock/unlock and save/restore
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 May 2013 20:58:13 -0600
Message-ID: <20130508025813.30771.59764.stgit@bling.home>
In-Reply-To: <20130508025339.30771.61937.stgit@bling.home>
References: <20130508025339.30771.61937.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only cosmetic changes to existing paths.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   52 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f5035f5..ee3cb18 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3297,22 +3297,46 @@ done:
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
+static void pci_dev_save(struct pci_dev *dev)
+{
+	pci_save_state(dev);
+	/*
+	 * both INTx and MSI are disabled after the Interrupt Disable bit
+	 * is set and the Bus Master bit is cleared.
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
@@ -3403,17 +3427,11 @@ int pci_reset_function(struct pci_dev *dev)
 	if (rc)
 		return rc;
 
-	pci_save_state(dev);
-
-	/*
-	 * both INTx and MSI are disabled after the Interrupt Disable bit
-	 * is set and the Bus Master bit is cleared.
-	 */
-	pci_write_config_word(dev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+	pci_dev_save(dev);
 
 	rc = pci_dev_reset(dev, 0);
 
-	pci_restore_state(dev);
+	pci_dev_restore(dev);
 
 	return rc;
 }

