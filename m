Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab3EQWBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:01:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3EQVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 34/50] 3c59x: fix PCI resource management
Date: Fri, 17 May 2013 14:47:09 -0700
Message-Id: <20130517213846.271810706@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

[ Upstream commit 4b264a1676e70dc656ba53a8cac690f2d4b65f4e ]

The driver wrongly claimed I/O ports at an address returned by pci_iomap() --
even if it was passed an MMIO address.  Fix this by claiming/releasing all PCI
resources in the PCI driver's probe()/remove() methods instead and get rid of
'must_free_region' flag weirdness (why would Cardbus claim anything for us?).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/3com/3c59x.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -632,7 +632,6 @@ struct vortex_private {
 		pm_state_valid:1,				/* pci_dev->saved_config_space has sane contents */
 		open:1,
 		medialock:1,
-		must_free_region:1,				/* Flag: if zero, Cardbus owns the I/O region */
 		large_frames:1,			/* accept large frames */
 		handling_irq:1;			/* private in_irq indicator */
 	/* {get|set}_wol operations are already serialized by rtnl.
@@ -1012,6 +1011,12 @@ static int __devinit vortex_init_one(str
 	if (rc < 0)
 		goto out;
 
+	rc = pci_request_regions(pdev, DRV_NAME);
+	if (rc < 0) {
+		pci_disable_device(pdev);
+		goto out;
+	}
+
 	unit = vortex_cards_found;
 
 	if (global_use_mmio < 0 && (unit >= MAX_UNITS || use_mmio[unit] < 0)) {
@@ -1027,6 +1032,7 @@ static int __devinit vortex_init_one(str
 	if (!ioaddr) /* If mapping fails, fall-back to BAR 0... */
 		ioaddr = pci_iomap(pdev, 0, 0);
 	if (!ioaddr) {
+		pci_release_regions(pdev);
 		pci_disable_device(pdev);
 		rc = -ENOMEM;
 		goto out;
@@ -1036,6 +1042,7 @@ static int __devinit vortex_init_one(str
 			   ent->driver_data, unit);
 	if (rc < 0) {
 		pci_iounmap(pdev, ioaddr);
+		pci_release_regions(pdev);
 		pci_disable_device(pdev);
 		goto out;
 	}
@@ -1179,11 +1186,6 @@ static int __devinit vortex_probe1(struc
 
 	/* PCI-only startup logic */
 	if (pdev) {
-		/* EISA resources already marked, so only PCI needs to do this here */
-		/* Ignore return value, because Cardbus drivers already allocate for us */
-		if (request_region(dev->base_addr, vci->io_size, print_name) != NULL)
-			vp->must_free_region = 1;
-
 		/* enable bus-mastering if necessary */
 		if (vci->flags & PCI_USES_MASTER)
 			pci_set_master(pdev);
@@ -1221,7 +1223,7 @@ static int __devinit vortex_probe1(struc
 					   &vp->rx_ring_dma);
 	retval = -ENOMEM;
 	if (!vp->rx_ring)
-		goto free_region;
+		goto free_device;
 
 	vp->tx_ring = (struct boom_tx_desc *)(vp->rx_ring + RX_RING_SIZE);
 	vp->tx_ring_dma = vp->rx_ring_dma + sizeof(struct boom_rx_desc) * RX_RING_SIZE;
@@ -1486,9 +1488,7 @@ free_ring:
 							+ sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 						vp->rx_ring,
 						vp->rx_ring_dma);
-free_region:
-	if (vp->must_free_region)
-		release_region(dev->base_addr, vci->io_size);
+free_device:
 	free_netdev(dev);
 	pr_err(PFX "vortex_probe1 fails.  Returns %d\n", retval);
 out:
@@ -3256,8 +3256,9 @@ static void __devexit vortex_remove_one(
 							+ sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 						vp->rx_ring,
 						vp->rx_ring_dma);
-	if (vp->must_free_region)
-		release_region(dev->base_addr, vp->io_size);
+
+	pci_release_regions(pdev);
+
 	free_netdev(dev);
 }
 


