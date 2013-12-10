Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3LJSsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:48:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab3LJSsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:48:36 -0500
Subject: [PATCH 1/3] pci: Generalize wait loop
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: ddutile@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 10 Dec 2013 11:48:33 -0700
Message-ID: <20131210184833.26294.20242.stgit@bling.home>
In-Reply-To: <20131210183339.26294.14581.stgit@bling.home>
References: <20131210183339.26294.14581.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have two instance of this loop which waits for a pending
bit to clear in a status dword.  Generalize the function for future
users.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   54 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 33120d1..05868e4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -431,6 +431,32 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 }
 
 /**
+ * pci_wait_for_pending - wait for @mask bit(s) to clear in status word @pos
+ * @dev: the PCI device to operate on
+ * @pos: config space offset of status word
+ * @mask: mask of bit(s) to care about in status word
+ *
+ * Return 1 when mask bit(s) in status word clear, 0 otherwise.
+ */
+static int pci_wait_for_pending(struct pci_dev *dev, int pos, u16 mask)
+{
+	int i;
+
+	/* Wait for Transaction Pending bit clean */
+	for (i = 0; i < 4; i++) {
+		u16 status;
+		if (i)
+			msleep((1 << (i - 1)) * 100);
+
+		pci_read_config_word(dev, pos, &status);
+		if (!(status & mask))
+			return 1;
+	}
+
+	return 0;
+}
+
+/**
  * pci_restore_bars - restore a devices BAR values (e.g. after wake-up)
  * @dev: PCI device to have its BARs restored
  *
@@ -3204,20 +3230,10 @@ EXPORT_SYMBOL(pci_set_dma_seg_boundary);
  */
 int pci_wait_for_pending_transaction(struct pci_dev *dev)
 {
-	int i;
-	u16 status;
-
-	/* Wait for Transaction Pending bit clean */
-	for (i = 0; i < 4; i++) {
-		if (i)
-			msleep((1 << (i - 1)) * 100);
-
-		pcie_capability_read_word(dev, PCI_EXP_DEVSTA, &status);
-		if (!(status & PCI_EXP_DEVSTA_TRPND))
-			return 1;
-	}
+	if (!pci_is_pcie(dev))
+		return 1;
 
-	return 0;
+	return pci_wait_for_pending(dev, PCI_EXP_DEVSTA, PCI_EXP_DEVSTA_TRPND);
 }
 EXPORT_SYMBOL(pci_wait_for_pending_transaction);
 
@@ -3244,10 +3260,8 @@ static int pcie_flr(struct pci_dev *dev, int probe)
 
 static int pci_af_flr(struct pci_dev *dev, int probe)
 {
-	int i;
 	int pos;
 	u8 cap;
-	u8 status;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_AF);
 	if (!pos)
@@ -3261,14 +3275,8 @@ static int pci_af_flr(struct pci_dev *dev, int probe)
 		return 0;
 
 	/* Wait for Transaction Pending bit clean */
-	for (i = 0; i < 4; i++) {
-		if (i)
-			msleep((1 << (i - 1)) * 100);
-
-		pci_read_config_byte(dev, pos + PCI_AF_STATUS, &status);
-		if (!(status & PCI_AF_STATUS_TP))
-			goto clear;
-	}
+	if (pci_wait_for_pending(dev, PCI_AF_STATUS, PCI_AF_STATUS_TP))
+		goto clear;
 
 	dev_err(&dev->dev, "transaction is not cleared; "
 			"proceeding with reset anyway\n");

