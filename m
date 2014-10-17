Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaJQIzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:55:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:54474 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaJQIzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:55:17 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9H8tDn5029555, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: return -EBUSY for runtime suspend
Date: Fri, 17 Oct 2014 16:55:08 +0800
Message-ID: <1394712342-15778-65-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <87zjcvgn1x.fsf@nemi.mork.no>
References: <87zjcvgn1x.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove calling cancel_delayed_work_sync() for runtime suspend,
because it would cause dead lock. Instead, return -EBUSY to
avoid the device enters suspending if the net is running and
the delayed work is pending or running. The delayed work would
try to wake up the device later, so the suspending is not
necessary.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 864159e..e3d84c3 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3189,31 +3189,39 @@ static void r8153_init(struct r8152 *tp)
 static int rtl8152_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct r8152 *tp = usb_get_intfdata(intf);
+	struct net_device *netdev = tp->netdev;
+	int ret = 0;
 
 	mutex_lock(&tp->control);
 
-	if (PMSG_IS_AUTO(message))
+	if (PMSG_IS_AUTO(message)) {
+		if (netif_running(netdev) && work_busy(&tp->schedule.work)) {
+			ret = -EBUSY;
+			goto out1;
+		}
+
 		set_bit(SELECTIVE_SUSPEND, &tp->flags);
-	else
-		netif_device_detach(tp->netdev);
+	} else {
+		netif_device_detach(netdev);
+	}
 
-	if (netif_running(tp->netdev)) {
+	if (netif_running(netdev)) {
 		clear_bit(WORK_ENABLE, &tp->flags);
 		usb_kill_urb(tp->intr_urb);
-		cancel_delayed_work_sync(&tp->schedule);
 		tasklet_disable(&tp->tl);
 		if (test_bit(SELECTIVE_SUSPEND, &tp->flags)) {
 			rtl_stop_rx(tp);
 			rtl_runtime_suspend_enable(tp, true);
 		} else {
+			cancel_delayed_work_sync(&tp->schedule);
 			tp->rtl_ops.down(tp);
 		}
 		tasklet_enable(&tp->tl);
 	}
-
+out1:
 	mutex_unlock(&tp->control);
 
-	return 0;
+	return ret;
 }
 
 static int rtl8152_resume(struct usb_interface *intf)
-- 
1.9.3

