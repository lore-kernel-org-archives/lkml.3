Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaCDMC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 07:02:28 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36565 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbaCDMCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 07:02:01 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s24C1wmB025572, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 12/12] r8152: modify the tx timeout funcfion
Date: Tue, 4 Mar 2014 20:01:04 +0800
Message-ID: <1393934464-23675-13-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset and reinitialize the device when the tx timeout occurs.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e04fcbd..23e03a6 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1791,16 +1791,6 @@ static void rtl_drop_queued_tx(struct r8152 *tp)
 	}
 }
 
-static void rtl8152_tx_timeout(struct net_device *netdev)
-{
-	struct r8152 *tp = netdev_priv(netdev);
-	int i;
-
-	netif_warn(tp, tx_err, netdev, "Tx timeout\n");
-	for (i = 0; i < RTL8152_MAX_TX; i++)
-		usb_unlink_urb(tp->tx_info[i].urb);
-}
-
 static void rtl8152_set_rx_mode(struct net_device *netdev)
 {
 	struct r8152 *tp = netdev_priv(netdev);
@@ -3177,6 +3167,37 @@ out:
 	return res;
 }
 
+static void rtl8152_tx_timeout(struct net_device *netdev)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	netif_warn(tp, tx_err, netdev, "Tx timeout\n");
+
+	if (usb_autopm_get_interface(tp->intf) < 0)
+		return;
+
+	netif_stop_queue(netdev);
+	clear_bit(WORK_ENABLE, &tp->flags);
+	usb_kill_urb(tp->intr_urb);
+	cancel_delayed_work_sync(&tp->schedule);
+	tp->rtl_ops.down(tp);
+
+	usb_reset_device(tp->udev);
+
+	tp->rtl_ops.init(tp);
+	tp->rtl_ops.up(tp);
+	rtl8152_set_speed(tp, AUTONEG_ENABLE,
+			  tp->mii.supports_gmii ? SPEED_1000 : SPEED_100,
+			  DUPLEX_FULL);
+	tp->speed = 0;
+	netif_carrier_off(netdev);
+	netif_start_queue(netdev);
+	set_bit(WORK_ENABLE, &tp->flags);
+	usb_submit_urb(tp->intr_urb, GFP_KERNEL);
+
+	usb_autopm_put_interface(tp->intf);
+}
+
 static const struct net_device_ops rtl8152_netdev_ops = {
 	.ndo_open		= rtl8152_open,
 	.ndo_stop		= rtl8152_close,
-- 
1.8.4.2

