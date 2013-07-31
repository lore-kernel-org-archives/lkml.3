Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab3GaJWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:22:00 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42999 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3GaJV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:21:57 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6V9Lq5n030808, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH v4 2/5] net/usb/r815x: avoid to call mdio functions for runtime-suspended device
Date: Wed, 31 Jul 2013 17:21:23 +0800
Message-ID: <1375262486-5373-2-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375262486-5373-1-git-send-email-hayeswang@realtek.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
 <1375262486-5373-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't replace the usb_control_msg() with usbnet_{read,write}_cmd()
which couldn't be called inside suspend/resume callback. Keep the
basic functions unlimited. Instead, using usb_autopm_get_interface()
and usb_autopm_put_interface() in r815x_mdio_{read,write}().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r815x.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r815x.c b/drivers/net/usb/r815x.c
index e9b99ba..1a80e76 100644
--- a/drivers/net/usb/r815x.c
+++ b/drivers/net/usb/r815x.c
@@ -126,11 +126,18 @@ out1:
 static int r815x_mdio_read(struct net_device *netdev, int phy_id, int reg)
 {
 	struct usbnet *dev = netdev_priv(netdev);
+	int ret;
 
 	if (phy_id != R815x_PHY_ID)
 		return -EINVAL;
 
-	return ocp_reg_read(dev, BASE_MII + reg * 2);
+	if (usb_autopm_get_interface(dev->intf) < 0)
+		return -ENODEV;
+
+	ret = ocp_reg_read(dev, BASE_MII + reg * 2);
+
+	usb_autopm_put_interface(dev->intf);
+	return ret;
 }
 
 static
@@ -141,7 +148,12 @@ void r815x_mdio_write(struct net_device *netdev, int phy_id, int reg, int val)
 	if (phy_id != R815x_PHY_ID)
 		return;
 
+	if (usb_autopm_get_interface(dev->intf) < 0)
+		return;
+
 	ocp_reg_write(dev, BASE_MII + reg * 2, val);
+
+	usb_autopm_put_interface(dev->intf);
 }
 
 static int r8153_bind(struct usbnet *dev, struct usb_interface *intf)
-- 
1.8.3.1

