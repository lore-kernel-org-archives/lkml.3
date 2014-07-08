Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaGHGuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:50:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35946 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGHGuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:50:16 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s686oBpI019331, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: wake up the device before dumping the hw counter
Date: Tue, 8 Jul 2014 14:49:28 +0800
Message-ID: <1394712342-15778-5-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device should be waked up from runtime suspend before dumping
the hw counter.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2543196..a795ecf 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3204,8 +3204,13 @@ static void rtl8152_get_ethtool_stats(struct net_device *dev,
 	struct r8152 *tp = netdev_priv(dev);
 	struct tally_counter tally;
 
+	if (usb_autopm_get_interface(tp->intf) < 0)
+		return;
+
 	generic_ocp_read(tp, PLA_TALLYCNT, sizeof(tally), &tally, MCU_TYPE_PLA);
 
+	usb_autopm_put_interface(tp->intf);
+
 	data[0] = le64_to_cpu(tally.tx_packets);
 	data[1] = le64_to_cpu(tally.rx_packets);
 	data[2] = le64_to_cpu(tally.tx_errors);
-- 
1.9.3

