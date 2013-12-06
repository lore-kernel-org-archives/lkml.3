Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab3LFUvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:51:36 -0500
Received: from mail.ispras.ru ([83.149.199.45]:58202 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3LFUve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:51:34 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] can: ems_usb: fix a leak in ems_usb_start_xmit()
Date: Sat,  7 Dec 2013 00:51:22 +0400
Message-Id: <1386363082-15144-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is spare code with obvious misprint in ems_usb_start_xmit():
usb_free_urb() should be used to deallocate urb instead of usb_unanchor_urb().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/can/usb/ems_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 5f9a7ad9b964..beae1ec255f4 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -798,7 +798,7 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 	 * allowed (MAX_TX_URBS).
 	 */
 	if (!context) {
-		usb_unanchor_urb(urb);
+		usb_free_urb(urb);
 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
 
 		netdev_warn(netdev, "couldn't find free context\n");
-- 
1.8.3.2

