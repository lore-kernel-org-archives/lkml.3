Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaJBI00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:26:26 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49226 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJBI0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:26:24 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s928QKbl032053, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: autoresume before setting MAC address
Date: Thu, 2 Oct 2014 16:26:06 +0800
Message-ID: <1394712342-15778-55-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resume the device before setting the MAC address.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 604ef21..e823358 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1007,9 +1007,16 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 	struct sockaddr *addr = p;
+	int ret;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		goto out1;
 
-	if (!is_valid_ether_addr(addr->sa_data))
-		return -EADDRNOTAVAIL;
+	if (!is_valid_ether_addr(addr->sa_data)) {
+		ret = -EADDRNOTAVAIL;
+		goto out2;
+	}
 
 	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
 
@@ -1017,7 +1024,10 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 	pla_ocp_write(tp, PLA_IDR, BYTE_EN_SIX_BYTES, 8, addr->sa_data);
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
 
-	return 0;
+out2:
+	usb_autopm_put_interface(tp->intf);
+out1:
+	return ret;
 }
 
 static void read_bulk_callback(struct urb *urb)
-- 
1.9.3

