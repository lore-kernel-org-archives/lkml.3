Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918Ab3DKVYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:24:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3DKUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:48 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NOpVenwwrOoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YU0lCvQzNxYA:10 a=SaWEO8HGAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=J1Y8HTJGAAAA:8 a=iY4EukL9d6y28-PCuwgA:9 a=w2ubnULX9RwA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202612.640544931@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: rebelyouth <rebelyouth.hacklab@gmail.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        =?UTF-8?q?Christian=20S=C3=BCnkenberg?= 
	<christian.suenkenberg@student.kit.edu>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 161/171 ] atl1e: drop pci-msi support because of packet corruption
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0161-atl1e-drop-pci-msi-support-because-of-packet-corrupt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 188ab1b105c96656f6bcfb49d0d8bb1b1936b632 ]

Usage of pci-msi results in corrupted dma packet transfers to the host.

Reported-by: rebelyouth <rebelyouth.hacklab@gmail.com>
Cc: Huang, Xiong <xiong@qca.qualcomm.com>
Tested-by: Christian Sünkenberg <christian.suenkenberg@student.kit.edu>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |    1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |   19 ++-----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

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
index a98acc8..b986503 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1851,34 +1851,19 @@ static void atl1e_free_irq(struct atl1e_adapter *adapter)
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
-	err = pci_enable_msi(pdev);
-	if (err) {
-		netdev_dbg(netdev,
-			   "Unable to allocate MSI interrupt Error: %d\n", err);
-		adapter->have_msi = false;
-	}
-
-	if (!adapter->have_msi)
-		flags |= IRQF_SHARED;
-	err = request_irq(pdev->irq, atl1e_intr, flags, netdev->name, netdev);
+	err = request_irq(pdev->irq, atl1e_intr, IRQF_SHARED, netdev->name,
+			  netdev);
 	if (err) {
 		netdev_dbg(adapter->netdev,
 			   "Unable to allocate interrupt Error: %d\n", err);
-		if (adapter->have_msi)
-			pci_disable_msi(pdev);
 		return err;
 	}
 	netdev_dbg(netdev, "atl1e_request_irq OK\n");
-- 
1.7.10.4


