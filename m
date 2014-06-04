Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaFEABL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:01:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbaFDXXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@gmail.com>
Subject: [PATCH 3.14 186/228] PCI: Wrong register used to check pending traffic
Date: Wed,  4 Jun 2014 16:23:35 -0700
Message-Id: <20140604232354.004988520@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit d0b4cc4e32705ff00d90d32da7783c266c702c04 upstream.

The incorrect register offset is passed to pci_wait_for_pending(), which is
caused by commit 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor
pci_wait_for_pending_transaction())").

Fixes: 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor pci_wait_for_pending_transaction())
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Alex Williamson <alex.williamson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3043,7 +3043,8 @@ int pci_wait_for_pending_transaction(str
 	if (!pci_is_pcie(dev))
 		return 1;
 
-	return pci_wait_for_pending(dev, PCI_EXP_DEVSTA, PCI_EXP_DEVSTA_TRPND);
+	return pci_wait_for_pending(dev, pci_pcie_cap(dev) + PCI_EXP_DEVSTA,
+				    PCI_EXP_DEVSTA_TRPND);
 }
 EXPORT_SYMBOL(pci_wait_for_pending_transaction);
 
@@ -3085,7 +3086,7 @@ static int pci_af_flr(struct pci_dev *de
 		return 0;
 
 	/* Wait for Transaction Pending bit clean */
-	if (pci_wait_for_pending(dev, PCI_AF_STATUS, PCI_AF_STATUS_TP))
+	if (pci_wait_for_pending(dev, pos + PCI_AF_STATUS, PCI_AF_STATUS_TP))
 		goto clear;
 
 	dev_err(&dev->dev, "transaction is not cleared; "


