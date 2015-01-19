Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbbASHNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:13:54 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40517 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASHNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:13:52 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J7DmUR003933, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/7] r8152: adjust rx_bottom
Date: Mon, 19 Jan 2015 15:13:31 +0800
Message-ID: <1394712342-15778-119-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-118-Taiwan-albertk@realtek.com>
References: <1394712342-15778-118-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a error occurs when submitting rx, skip the remaining submissions
and try to submit them again next time.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2e22442..78a8917 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1655,7 +1655,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 {
 	unsigned long flags;
 	struct list_head *cursor, *next, rx_queue;
-	int work_done = 0;
+	int ret = 0, work_done = 0;
 
 	if (!skb_queue_empty(&tp->rx_queue)) {
 		while (work_done < budget) {
@@ -1746,7 +1746,18 @@ find_next_rx:
 		}
 
 submit:
-		r8152_submit_rx(tp, agg, GFP_ATOMIC);
+		if (!ret) {
+			ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
+		} else {
+			urb->actual_length = 0;
+			list_add_tail(&agg->list, next);
+		}
+	}
+
+	if (!list_empty(&rx_queue)) {
+		spin_lock_irqsave(&tp->rx_lock, flags);
+		list_splice_tail(&rx_queue, &tp->rx_done);
+		spin_unlock_irqrestore(&tp->rx_lock, flags);
 	}
 
 out1:
-- 
2.1.0

