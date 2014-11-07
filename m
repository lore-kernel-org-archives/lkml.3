Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaKGJ4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:56:05 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:55353 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaKGJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:55:26 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sA79tKHs019413, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/2] r8152: adjust r8152_submit_rx
Date: Fri, 7 Nov 2014 17:55:10 +0800
Message-ID: <1394712342-15778-89-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-88-Taiwan-albertk@realtek.com>
References: <1394712342-15778-88-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The behavior of handling the returned status from r8152_submit_rx()
is almost same, so let r8152_submit_rx() deal with the error
directly. This could avoid the duplicate code.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 66b139a..ad62994 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1032,7 +1032,6 @@ static void read_bulk_callback(struct urb *urb)
 	int status = urb->status;
 	struct rx_agg *agg;
 	struct r8152 *tp;
-	int result;
 
 	agg = urb->context;
 	if (!agg)
@@ -1083,16 +1082,7 @@ static void read_bulk_callback(struct urb *urb)
 		break;
 	}
 
-	result = r8152_submit_rx(tp, agg, GFP_ATOMIC);
-	if (result == -ENODEV) {
-		set_bit(RTL8152_UNPLUG, &tp->flags);
-		netif_device_detach(tp->netdev);
-	} else if (result) {
-		spin_lock(&tp->rx_lock);
-		list_add_tail(&agg->list, &tp->rx_done);
-		spin_unlock(&tp->rx_lock);
-		tasklet_schedule(&tp->tl);
-	}
+	r8152_submit_rx(tp, agg, GFP_ATOMIC);
 }
 
 static void write_bulk_callback(struct urb *urb)
@@ -1681,7 +1671,6 @@ static void rx_bottom(struct r8152 *tp)
 		int len_used = 0;
 		struct urb *urb;
 		u8 *rx_data;
-		int ret;
 
 		list_del_init(cursor);
 
@@ -1734,13 +1723,7 @@ find_next_rx:
 		}
 
 submit:
-		ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
-		if (ret && ret != -ENODEV) {
-			spin_lock_irqsave(&tp->rx_lock, flags);
-			list_add_tail(&agg->list, &tp->rx_done);
-			spin_unlock_irqrestore(&tp->rx_lock, flags);
-			tasklet_schedule(&tp->tl);
-		}
+		r8152_submit_rx(tp, agg, GFP_ATOMIC);
 	}
 }
 
@@ -1805,11 +1788,27 @@ static void bottom_half(unsigned long data)
 static
 int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 {
+	int ret = 0;
+
 	usb_fill_bulk_urb(agg->urb, tp->udev, usb_rcvbulkpipe(tp->udev, 1),
 			  agg->head, agg_buf_sz,
 			  (usb_complete_t)read_bulk_callback, agg);
 
-	return usb_submit_urb(agg->urb, mem_flags);
+	ret = usb_submit_urb(agg->urb, mem_flags);
+
+	if (ret == -ENODEV) {
+		set_bit(RTL8152_UNPLUG, &tp->flags);
+		netif_device_detach(tp->netdev);
+	} else if (ret) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&tp->rx_lock, flags);
+		list_add_tail(&agg->list, &tp->rx_done);
+		spin_unlock_irqrestore(&tp->rx_lock, flags);
+		tasklet_schedule(&tp->tl);
+	}
+
+	return ret;
 }
 
 static void rtl_drop_queued_tx(struct r8152 *tp)
-- 
1.9.3

