Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959Ab3DBWTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:19:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933702Ab3DBWOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        rebelyouth <rebelyouth.hacklab@gmail.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        =?UTF-8?q?Christian=20S=FCnkenberg?= 
	<christian.suenkenberg@student.kit.edu>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 60/68] atl1e: drop pci-msi support because of packet corruption
Date: Tue,  2 Apr 2013 15:13:49 -0700
Message-Id: <20130402221336.908404375@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 188ab1b105c96656f6bcfb49d0d8bb1b1936b632 ]

Usage of pci-msi results in corrupted dma packet transfers to the host.

Reported-by: rebelyouth <rebelyouth.hacklab@gmail.com>
Cc: Huang, Xiong <xiong@qca.qualcomm.com>
Tested-by: Christian Sünkenberg <christian.suenkenberg@student.kit.edu>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |    1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |   22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -438,7 +438,6 @@ struct atl1e_adapter {
 	struct atl1e_hw        hw;
 	struct atl1e_hw_stats  hw_stats;
 
-	bool have_msi;
 	u32 wol;
 	u16 link_speed;
 	u16 link_duplex;
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1870,37 +1870,19 @@ static void atl1e_free_irq(struct atl1e_
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


