Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaJIGZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:25:13 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:33399 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaJIGZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:25:08 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s996P3CA014683, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: add rtnl_lock
Date: Thu, 9 Oct 2014 14:24:44 +0800
Message-ID: <1394712342-15778-59-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-58-Taiwan-albertk@realtek.com>
References: <1394712342-15778-58-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rtnl_lock() for suspend/resume and workqueue.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5cfd414..2b2b679 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -26,7 +26,7 @@
 #include <linux/mdio.h>
 
 /* Version Information */
-#define DRIVER_VERSION "v1.06.1 (2014/10/01)"
+#define DRIVER_VERSION "v1.07.0 (2014/10/09)"
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
 #define DRIVER_DESC "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 #define MODULENAME "r8152"
@@ -2851,6 +2851,11 @@ static void rtl_work_func_t(struct work_struct *work)
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		goto out1;
 
+	if (!rtnl_trylock()) {
+		schedule_delayed_work(&tp->schedule, 0);
+		goto out1;
+	}
+
 	if (test_bit(RTL8152_LINK_CHG, &tp->flags))
 		set_carrier(tp);
 
@@ -2866,6 +2871,8 @@ static void rtl_work_func_t(struct work_struct *work)
 	if (test_bit(PHY_RESET, &tp->flags))
 		rtl_phy_reset(tp);
 
+	rtnl_unlock();
+
 out1:
 	usb_autopm_put_interface(tp->intf);
 }
@@ -3169,6 +3176,8 @@ static int rtl8152_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct r8152 *tp = usb_get_intfdata(intf);
 
+	rtnl_lock();
+
 	if (PMSG_IS_AUTO(message))
 		set_bit(SELECTIVE_SUSPEND, &tp->flags);
 	else
@@ -3188,6 +3197,8 @@ static int rtl8152_suspend(struct usb_interface *intf, pm_message_t message)
 		tasklet_enable(&tp->tl);
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -3195,6 +3206,8 @@ static int rtl8152_resume(struct usb_interface *intf)
 {
 	struct r8152 *tp = usb_get_intfdata(intf);
 
+	rtnl_lock();
+
 	if (!test_bit(SELECTIVE_SUSPEND, &tp->flags)) {
 		tp->rtl_ops.init(tp);
 		netif_device_attach(tp->netdev);
@@ -3220,6 +3233,8 @@ static int rtl8152_resume(struct usb_interface *intf)
 		usb_submit_urb(tp->intr_urb, GFP_KERNEL);
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
-- 
1.9.3

