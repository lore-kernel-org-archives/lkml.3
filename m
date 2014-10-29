Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaJ2DQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:16:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55487 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaJ2DQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:16:33 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9T3GPYl004736, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 2/3] r8152: reset tp->speed before autoresuming in open function
Date: Wed, 29 Oct 2014 11:12:16 +0800
Message-ID: <1394712342-15778-71-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-69-Taiwan-albertk@realtek.com>
References: <1394712342-15778-69-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If (tp->speed & LINK_STATUS) is not zero, the rtl8152_resume()
would call rtl_start_rx() before enabling the tx/rx. Avoid this
by resetting it to zero.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a17ca58..f224231 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2891,6 +2891,9 @@ static int rtl8152_open(struct net_device *netdev)
 	if (res)
 		goto out;
 
+	/* set speed to 0 to avoid autoresume try to submit rx */
+	tp->speed = 0;
+
 	res = usb_autopm_get_interface(tp->intf);
 	if (res < 0) {
 		free_all_mem(tp);
@@ -2904,6 +2907,8 @@ static int rtl8152_open(struct net_device *netdev)
 		clear_bit(WORK_ENABLE, &tp->flags);
 		usb_kill_urb(tp->intr_urb);
 		cancel_delayed_work_sync(&tp->schedule);
+
+		/* disable the tx/rx, if the workqueue has enabled them. */
 		if (tp->speed & LINK_STATUS)
 			tp->rtl_ops.disable(tp);
 	}
-- 
1.9.3

