Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaFMSYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:24:52 -0400
Received: from skprod3.natinst.com ([130.164.80.24]:41129 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752216AbaFMSYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:24:50 -0400
From: Vicentiu Neagoe <vicentiu.neagoe@ni.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Westfahl <jeff.westfahl@ni.com>
Subject: [PATCH] usb: gadget: u_ether: synchronize with transmit when stopping queue
Date: Fri, 13 Jun 2014 21:23:21 +0300
Message-Id: <1402683801-27782-1-git-send-email-vicentiu.neagoe@ni.com>
X-Mailer: git-send-email 1.7.9.5
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/13/2014 01:24:49 PM,
	Serialize by Router on US-AUS-MGWOut1/AUS/H/NIC(Release 8.5.3FP5|July 31, 2013) at
 06/13/2014 01:24:49 PM,
	Serialize complete at 06/13/2014 01:24:49 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-13_07:2014-06-13,2014-06-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Westfahl <jeff.westfahl@ni.com>

When disconnecting, it's possible that another thread has already made it
into eth_start_xmit before we call netif_stop_queue. This can lead to a
crash as eth_start_xmit tries to use resources that gether_disconnect is
freeing. Use netif_tx_lock/unlock around netif_stop_queue to ensure no
threads are executing during the remainder of gether_disconnect.

Signed-off-by: Jeff Westfahl <jeff.westfahl@ni.com>
Tested-by: Jaeden Amero <jaeden.amero@ni.com>
---
 drivers/usb/gadget/u_ether.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/u_ether.c b/drivers/usb/gadget/u_ether.c
index b7d4f82..085a76e 100644
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -1120,7 +1120,10 @@ void gether_disconnect(struct gether *link)
 
 	DBG(dev, "%s\n", __func__);
 
+	netif_tx_lock(dev->net);
 	netif_stop_queue(dev->net);
+	netif_tx_unlock(dev->net);
+
 	netif_carrier_off(dev->net);
 
 	/* disable endpoints, forcing (synchronous) completion
-- 
1.7.9.5

