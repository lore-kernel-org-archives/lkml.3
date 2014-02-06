Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaBFDz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 22:55:58 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:56149 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaBFDz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 22:55:56 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s163tqfS002525, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: fix the submission of the interrupt transfer
Date: Thu, 6 Feb 2014 11:55:48 +0800
Message-ID: <1391658948-4456-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The submission of the interrupt transfer should be done after setting
the bit of WORK_ENABLE, otherwise the callback function would have
the opportunity to be returned directly.

Clear the bit of WORK_ENABLE before killing the interrupt transfer.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e8fac73..d89dbe3 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2273,22 +2273,21 @@ static int rtl8152_open(struct net_device *netdev)
 	struct r8152 *tp = netdev_priv(netdev);
 	int res = 0;
 
+	rtl8152_set_speed(tp, AUTONEG_ENABLE,
+			  tp->mii.supports_gmii ? SPEED_1000 : SPEED_100,
+			  DUPLEX_FULL);
+	tp->speed = 0;
+	netif_carrier_off(netdev);
+	netif_start_queue(netdev);
+	set_bit(WORK_ENABLE, &tp->flags);
 	res = usb_submit_urb(tp->intr_urb, GFP_KERNEL);
 	if (res) {
 		if (res == -ENODEV)
 			netif_device_detach(tp->netdev);
 		netif_warn(tp, ifup, netdev, "intr_urb submit failed: %d\n",
 			   res);
-		return res;
 	}
 
-	rtl8152_set_speed(tp, AUTONEG_ENABLE,
-			  tp->mii.supports_gmii ? SPEED_1000 : SPEED_100,
-			  DUPLEX_FULL);
-	tp->speed = 0;
-	netif_carrier_off(netdev);
-	netif_start_queue(netdev);
-	set_bit(WORK_ENABLE, &tp->flags);
 
 	return res;
 }
@@ -2298,8 +2297,8 @@ static int rtl8152_close(struct net_device *netdev)
 	struct r8152 *tp = netdev_priv(netdev);
 	int res = 0;
 
-	usb_kill_urb(tp->intr_urb);
 	clear_bit(WORK_ENABLE, &tp->flags);
+	usb_kill_urb(tp->intr_urb);
 	cancel_delayed_work_sync(&tp->schedule);
 	netif_stop_queue(netdev);
 	tasklet_disable(&tp->tl);
-- 
1.8.4.2

