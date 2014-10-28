Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbaJ1GGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:06:15 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49247 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaJ1GGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:06:08 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9S664hQ010173, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/2] r8152: support nway_reset of ethtool
Date: Tue, 28 Oct 2014 14:05:52 +0800
Message-ID: <1394712342-15778-68-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-66-Taiwan-albertk@realtek.com>
References: <1394712342-15778-66-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the nway_reset() function for ethtool.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index fdea194..e1810bc 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3558,11 +3558,33 @@ out:
 	return ret;
 }
 
+static int rtl8152_nway_reset(struct net_device *dev)
+{
+	struct r8152 *tp = netdev_priv(dev);
+	int ret;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		goto out;
+
+	mutex_lock(&tp->control);
+
+	ret = mii_nway_restart(&tp->mii);
+
+	mutex_unlock(&tp->control);
+
+	usb_autopm_put_interface(tp->intf);
+
+out:
+	return ret;
+}
+
 static struct ethtool_ops ops = {
 	.get_drvinfo = rtl8152_get_drvinfo,
 	.get_settings = rtl8152_get_settings,
 	.set_settings = rtl8152_set_settings,
 	.get_link = ethtool_op_get_link,
+	.nway_reset = rtl8152_nway_reset,
 	.get_msglevel = rtl8152_get_msglevel,
 	.set_msglevel = rtl8152_set_msglevel,
 	.get_wol = rtl8152_get_wol,
-- 
1.9.3

