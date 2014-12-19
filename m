Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaLSI5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:57:33 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33819 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaLSI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:56:45 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID sBJ8ugm7021800, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 1/2] r8152: adjust set_carrier
Date: Fri, 19 Dec 2014 16:55:59 +0800
Message-ID: <1394712342-15778-108-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-107-Taiwan-albertk@realtek.com>
References: <1394712342-15778-107-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.212]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the tp->speed at the beginning of the function. Then,
the other fucntion could use it for checking linking status.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2d1c77e..59b70c5 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2848,26 +2848,25 @@ static void rtl8153_down(struct r8152 *tp)
 static void set_carrier(struct r8152 *tp)
 {
 	struct net_device *netdev = tp->netdev;
-	u8 speed;
+	u8 old_speed = tp->speed;
 
 	clear_bit(RTL8152_LINK_CHG, &tp->flags);
-	speed = rtl8152_get_speed(tp);
+	tp->speed = rtl8152_get_speed(tp);
 
-	if (speed & LINK_STATUS) {
-		if (!(tp->speed & LINK_STATUS)) {
+	if (tp->speed & LINK_STATUS) {
+		if (!(old_speed & LINK_STATUS)) {
 			tp->rtl_ops.enable(tp);
 			set_bit(RTL8152_SET_RX_MODE, &tp->flags);
 			netif_carrier_on(netdev);
 		}
 	} else {
-		if (tp->speed & LINK_STATUS) {
+		if (old_speed & LINK_STATUS) {
 			netif_carrier_off(netdev);
 			tasklet_disable(&tp->tl);
 			tp->rtl_ops.disable(tp);
 			tasklet_enable(&tp->tl);
 		}
 	}
-	tp->speed = speed;
 }
 
 static void rtl_work_func_t(struct work_struct *work)
-- 
2.1.0

