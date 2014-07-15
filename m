Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbaGOXsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:48:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699AbaGOXNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>
Subject: [PATCH 3.14 43/66] PCI: Fix unaligned access in AF transaction pending test
Date: Tue, 15 Jul 2014 16:17:37 -0700
Message-Id: <20140715231704.073788182@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231702.156040999@linuxfoundation.org>
References: <20140715231702.156040999@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit d066c946a866268c14a120b33e7226e899981998 upstream.

pci_wait_for_pending() uses word access, so we shouldn't be passing
an offset that is only byte aligned.  Use the control register offset
instead, shifting the mask to match.

Fixes: d0b4cc4e3270 ("PCI: Wrong register used to check pending traffic")
Fixes: 157e876ffe0b ("PCI: Add pci_wait_for_pending() (refactor pci_wait_for_pending_transaction())
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3085,8 +3085,13 @@ static int pci_af_flr(struct pci_dev *de
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


