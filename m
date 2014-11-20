Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaKTC3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:29:51 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33135 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbaKTC3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:29:47 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAK2TNwI022005, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 2/2] r8152: adjust rtl_start_rx
Date: Thu, 20 Nov 2014 10:29:06 +0800
Message-ID: <1394712342-15778-100-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-98-Taiwan-albertk@realtek.com>
References: <1394712342-15778-88-Taiwan-albertk@realtek.com>
 <1394712342-15778-98-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a error for r8152_submit_rx(), add the remaining rx
buffers to the list. Then the remaining rx buffers could be
submitted later.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 3b89229..4a9ece0 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2001,6 +2001,25 @@ static int rtl_start_rx(struct r8152 *tp)
 			break;
 	}
 
+	if (ret && ++i < RTL8152_MAX_RX) {
+		struct list_head rx_queue;
+		unsigned long flags;
+
+		INIT_LIST_HEAD(&rx_queue);
+
+		do {
+			struct rx_agg *agg = &tp->rx_info[i++];
+			struct urb *urb = agg->urb;
+
+			urb->actual_length = 0;
+			list_add_tail(&agg->list, &rx_queue);
+		} while (i < RTL8152_MAX_RX);
+
+		spin_lock_irqsave(&tp->rx_lock, flags);
+		list_splice_tail(&rx_queue, &tp->rx_done);
+		spin_unlock_irqrestore(&tp->rx_lock, flags);
+	}
+
 	return ret;
 }
 
-- 
1.9.3

