Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaLVGxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 01:53:47 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57363 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaLVGxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 01:53:30 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID sBM6rRJF028060, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH net-next v2 2/2] r8152: check the status before submitting rx
Date: Mon, 22 Dec 2014 14:52:56 +0800
Message-ID: <1394712342-15778-112-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-110-Taiwan-albertk@realtek.com>
References: <1394712342-15778-107-Taiwan-albertk@realtek.com>
 <1394712342-15778-110-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't submit the rx if the device is unplugged, stopped, or
linking down.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index cbe450c..8ecc2df 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1789,6 +1789,11 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 {
 	int ret;
 
+	/* The rx would be stopped, so skip submitting */
+	if (test_bit(RTL8152_UNPLUG, &tp->flags) ||
+	    !test_bit(WORK_ENABLE, &tp->flags) || !netif_carrier_ok(tp->netdev))
+		return 0;
+
 	usb_fill_bulk_urb(agg->urb, tp->udev, usb_rcvbulkpipe(tp->udev, 1),
 			  agg->head, agg_buf_sz,
 			  (usb_complete_t)read_bulk_callback, agg);
-- 
2.1.0

