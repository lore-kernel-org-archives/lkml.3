Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab3GKNxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:53:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42592 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3GKNxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:53:24 -0400
Message-ID: <51DEB8D1.6080700@canonical.com>
Date: Thu, 11 Jul 2013 15:53:21 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] alx: fix lockdep annotation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move spin_lock_init to be called before the spinlocks are used, preventing a lockdep splat.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 418de8b..d30085c 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1303,6 +1303,8 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	alx = netdev_priv(netdev);
+	spin_lock_init(&alx->hw.mdio_lock);
+	spin_lock_init(&alx->irq_lock);
 	alx->dev = netdev;
 	alx->hw.pdev = pdev;
 	alx->msg_enable = NETIF_MSG_LINK | NETIF_MSG_HW | NETIF_MSG_IFUP |
@@ -1385,9 +1387,6 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&alx->link_check_wk, alx_link_check);
 	INIT_WORK(&alx->reset_wk, alx_reset);
-	spin_lock_init(&alx->hw.mdio_lock);
-	spin_lock_init(&alx->irq_lock);
-
 	netif_carrier_off(netdev);
 
 	err = register_netdev(netdev);

