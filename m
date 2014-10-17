Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaJQFzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 01:55:46 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35659 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQFzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 01:55:44 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9H5tdIV000941, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: use cancel_delayed_work for runtime suspend
Date: Fri, 17 Oct 2014 13:55:29 +0800
Message-ID: <1394712342-15778-64-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would cause dead lock for runtime suspend, when the workqueue
is running and runtime suspend occurs before the workqueue wakes
up the device. The rtl8152_suspend() waits the workqueue to finish
because of calling cancel_delayed_work_sync(). The workqueue waits
the suspend function to finish for waking up the device because of
calling usb_autopm_get_interface().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 864159e..7d4e55a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3200,12 +3200,13 @@ static int rtl8152_suspend(struct usb_interface *intf, pm_message_t message)
 	if (netif_running(tp->netdev)) {
 		clear_bit(WORK_ENABLE, &tp->flags);
 		usb_kill_urb(tp->intr_urb);
-		cancel_delayed_work_sync(&tp->schedule);
 		tasklet_disable(&tp->tl);
 		if (test_bit(SELECTIVE_SUSPEND, &tp->flags)) {
+			cancel_delayed_work(&tp->schedule);
 			rtl_stop_rx(tp);
 			rtl_runtime_suspend_enable(tp, true);
 		} else {
+			cancel_delayed_work_sync(&tp->schedule);
 			tp->rtl_ops.down(tp);
 		}
 		tasklet_enable(&tp->tl);
-- 
1.9.3

