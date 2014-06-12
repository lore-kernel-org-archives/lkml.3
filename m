Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaFLP2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:28:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbaFLP2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:28:16 -0400
Subject: [PATCH] pci: Fix unaligned access testing AF transaction pending
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org
Cc: bhelgaas@google.com, ben@decadent.org.uk, gwshan@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 09:28:07 -0600
Message-ID: <20140612152732.4162.23298.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_wait_for_pending() uses word access, so we shouldn't be passing
an offset that is only byte aligned.  Use the control register offset
instead, shifting the mask to match.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
---
 drivers/pci/pci.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 759475e..81012ec 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3109,8 +3109,13 @@ static int pci_af_flr(struct pci_dev *dev, int probe)
 	if (probe)
 		return 0;
 
-	/* Wait for Transaction Pending bit clean */
-	if (pci_wait_for_pending(dev, pos + PCI_AF_STATUS, PCI_AF_STATUS_TP))
+	/*
+	 * Wait for Transaction Pending bit to clear.  A word-aligned test
+	 * is used, so we use the conrol offset rather than status and shift
+	 * the test bit to match.
+	 */
+	if (pci_wait_for_pending(dev, pos + PCI_AF_CTRL,
+				 PCI_AF_STATUS_TP << 8))
 		goto clear;
 
 	dev_err(&dev->dev, "transaction is not cleared; "

