Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634Ab3DGX1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:27:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46608 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934537Ab3DGX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:27:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        "=?UTF-8?Q?Christian=20S=C3=BCnkenb?=erg" 
	<christian.suenkenberg@student.kit.edu>,
        "rebelyouth" <rebelyouth.hacklab@gmail.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.9901736@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [64/74] atl1e: drop pci-msi support because of packet  corruption
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 188ab1b105c96656f6bcfb49d0d8bb1b1936b632 ]

Usage of pci-msi results in corrupted dma packet transfers to the host.

Reported-by: rebelyouth <rebelyouth.hacklab@gmail.com>
Cc: Huang, Xiong <xiong@qca.qualcomm.com>
Tested-by: Christian Sünkenberg <christian.suenkenberg@student.kit.edu>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |  1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index 829b5ad..edfdf6b 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -438,7 +438,6 @@ struct atl1e_adapter {
 	struct atl1e_hw        hw;
 	struct atl1e_hw_stats  hw_stats;
 
-	bool have_msi;
 	u32 wol;
 	u16 link_speed;
 	u16 link_duplex;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 95483bc..c69dc29 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1867,37 +1867,19 @@ static void atl1e_free_irq(struct atl1e_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 
 	free_irq(adapter->pdev->irq, netdev);
-
-	if (adapter->have_msi)
-		pci_disable_msi(adapter->pdev);
 }
 
 static int atl1e_request_irq(struct atl1e_adapter *adapter)
 {
 	struct pci_dev    *pdev   = adapter->pdev;
 	struct net_device *netdev = adapter->netdev;
-	int flags = 0;
 	int err = 0;
 
-	adapter->have_msi = true;
-	err = pci_enable_msi(adapter->pdev);
-	if (err) {
-		netdev_dbg(adapter->netdev,
-			   "Unable to allocate MSI interrupt Error: %d\n", err);
-		adapter->have_msi = false;
-	} else
-		netdev->irq = pdev->irq;
-
-
-	if (!adapter->have_msi)
-		flags |= IRQF_SHARED;
-	err = request_irq(adapter->pdev->irq, atl1e_intr, flags,
-			netdev->name, netdev);
+	err = request_irq(pdev->irq, atl1e_intr, IRQF_SHARED,
+			  netdev->name, netdev);
 	if (err) {
 		netdev_dbg(adapter->netdev,
 			   "Unable to allocate interrupt Error: %d\n", err);
-		if (adapter->have_msi)
-			pci_disable_msi(adapter->pdev);
 		return err;
 	}
 	netdev_dbg(adapter->netdev, "atl1e_request_irq OK\n");

