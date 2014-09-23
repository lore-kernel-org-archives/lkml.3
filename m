Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaIWIdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:33:33 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42530 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaIWIda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:33:30 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8N8XR56014830, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: fix the carrier off when autoresuming
Date: Tue, 23 Sep 2014 16:31:47 +0800
Message-ID: <1394712342-15778-45-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netif_carrier_off would be called when autoresuming, even though
the cable is plugged. This causes some applications do relative
actions when detecting the carrier off. Keep the status of the
carrier, and let it be modified when the linking change occurs.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 52 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 74760e8..e039442 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1949,10 +1949,34 @@ static void rxdy_gated_en(struct r8152 *tp, bool enable)
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MISC_1, ocp_data);
 }
 
+static int rtl_start_rx(struct r8152 *tp)
+{
+	int i, ret = 0;
+
+	INIT_LIST_HEAD(&tp->rx_done);
+	for (i = 0; i < RTL8152_MAX_RX; i++) {
+		INIT_LIST_HEAD(&tp->rx_info[i].list);
+		ret = r8152_submit_rx(tp, &tp->rx_info[i], GFP_KERNEL);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int rtl_stop_rx(struct r8152 *tp)
+{
+	int i;
+
+	for (i = 0; i < RTL8152_MAX_RX; i++)
+		usb_kill_urb(tp->rx_info[i].urb);
+
+	return 0;
+}
+
 static int rtl_enable(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i, ret;
 
 	r8152b_reset_packet_filter(tp);
 
@@ -1962,14 +1986,7 @@ static int rtl_enable(struct r8152 *tp)
 
 	rxdy_gated_en(tp, false);
 
-	INIT_LIST_HEAD(&tp->rx_done);
-	ret = 0;
-	for (i = 0; i < RTL8152_MAX_RX; i++) {
-		INIT_LIST_HEAD(&tp->rx_info[i].list);
-		ret |= r8152_submit_rx(tp, &tp->rx_info[i], GFP_KERNEL);
-	}
-
-	return ret;
+	return rtl_start_rx(tp);
 }
 
 static int rtl8152_enable(struct r8152 *tp)
@@ -2053,8 +2070,7 @@ static void rtl_disable(struct r8152 *tp)
 		mdelay(1);
 	}
 
-	for (i = 0; i < RTL8152_MAX_RX; i++)
-		usb_kill_urb(tp->rx_info[i].urb);
+	rtl_stop_rx(tp);
 
 	rtl8152_nic_reset(tp);
 }
@@ -3083,13 +3099,14 @@ static int rtl8152_suspend(struct usb_interface *intf, pm_message_t message)
 		clear_bit(WORK_ENABLE, &tp->flags);
 		usb_kill_urb(tp->intr_urb);
 		cancel_delayed_work_sync(&tp->schedule);
+		tasklet_disable(&tp->tl);
 		if (test_bit(SELECTIVE_SUSPEND, &tp->flags)) {
+			rtl_stop_rx(tp);
 			rtl_runtime_suspend_enable(tp, true);
 		} else {
-			tasklet_disable(&tp->tl);
 			tp->rtl_ops.down(tp);
-			tasklet_enable(&tp->tl);
 		}
+		tasklet_enable(&tp->tl);
 	}
 
 	return 0;
@@ -3108,17 +3125,18 @@ static int rtl8152_resume(struct usb_interface *intf)
 		if (test_bit(SELECTIVE_SUSPEND, &tp->flags)) {
 			rtl_runtime_suspend_enable(tp, false);
 			clear_bit(SELECTIVE_SUSPEND, &tp->flags);
+			set_bit(WORK_ENABLE, &tp->flags);
 			if (tp->speed & LINK_STATUS)
-				tp->rtl_ops.disable(tp);
+				rtl_start_rx(tp);
 		} else {
 			tp->rtl_ops.up(tp);
 			rtl8152_set_speed(tp, AUTONEG_ENABLE,
 				tp->mii.supports_gmii ? SPEED_1000 : SPEED_100,
 				DUPLEX_FULL);
+			tp->speed = 0;
+			netif_carrier_off(tp->netdev);
+			set_bit(WORK_ENABLE, &tp->flags);
 		}
-		tp->speed = 0;
-		netif_carrier_off(tp->netdev);
-		set_bit(WORK_ENABLE, &tp->flags);
 		usb_submit_urb(tp->intr_urb, GFP_KERNEL);
 	}
 
-- 
1.9.3

