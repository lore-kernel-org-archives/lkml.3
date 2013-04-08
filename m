Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936190Ab3DHKDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:03:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935840Ab3DHJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Huang, Xiong" <xiong@qca.qualcomm.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 073/102] atl1e: drop pci-msi support because of packet corruption
Date: Mon,  8 Apr 2013 10:50:28 +0100
Message-Id: <1365414657-29191-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 188ab1b105c96656f6bcfb49d0d8bb1b1936b632 upstream.

Usage of pci-msi results in corrupted dma packet transfers to the host.

Reported-by: rebelyouth <rebelyouth.hacklab@gmail.com>
Cc: Huang, Xiong <xiong@qca.qualcomm.com>
Tested-by: Christian Sünkenberg <christian.suenkenberg@student.kit.edu>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |  1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 19 ++-----------------
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
index 1220e51..38f7093 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1870,34 +1870,19 @@ static void atl1e_free_irq(struct atl1e_adapter *adapter)
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
1.8.1.2

