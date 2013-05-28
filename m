Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3E1D4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52533 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758826Ab3E1DyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.346888270@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [86/94] 3c59x: fix PCI resource management
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

[ Upstream commit 4b264a1676e70dc656ba53a8cac690f2d4b65f4e ]

The driver wrongly claimed I/O ports at an address returned by pci_iomap() --
even if it was passed an MMIO address.  Fix this by claiming/releasing all PCI
resources in the PCI driver's probe()/remove() methods instead and get rid of
'must_free_region' flag weirdness (why would Cardbus claim anything for us?).

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/3com/3c59x.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index d1a6dbb..efc9dee 100644
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
@@ -1012,6 +1011,12 @@ static int __devinit vortex_init_one(struct pci_dev *pdev,
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
@@ -1027,6 +1032,7 @@ static int __devinit vortex_init_one(struct pci_dev *pdev,
 	if (!ioaddr) /* If mapping fails, fall-back to BAR 0... */
 		ioaddr = pci_iomap(pdev, 0, 0);
 	if (!ioaddr) {
+		pci_release_regions(pdev);
 		pci_disable_device(pdev);
 		rc = -ENOMEM;
 		goto out;
@@ -1036,6 +1042,7 @@ static int __devinit vortex_init_one(struct pci_dev *pdev,
 			   ent->driver_data, unit);
 	if (rc < 0) {
 		pci_iounmap(pdev, ioaddr);
+		pci_release_regions(pdev);
 		pci_disable_device(pdev);
 		goto out;
 	}
@@ -1180,11 +1187,6 @@ static int __devinit vortex_probe1(struct device *gendev,
 
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
@@ -1222,7 +1224,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 					   &vp->rx_ring_dma);
 	retval = -ENOMEM;
 	if (!vp->rx_ring)
-		goto free_region;
+		goto free_device;
 
 	vp->tx_ring = (struct boom_tx_desc *)(vp->rx_ring + RX_RING_SIZE);
 	vp->tx_ring_dma = vp->rx_ring_dma + sizeof(struct boom_rx_desc) * RX_RING_SIZE;
@@ -1487,9 +1489,7 @@ free_ring:
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
@@ -3254,8 +3254,9 @@ static void __devexit vortex_remove_one(struct pci_dev *pdev)
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
 

