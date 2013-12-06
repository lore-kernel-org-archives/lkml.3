Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3LFXKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:10:52 -0500
Received: from mail.ispras.ru ([83.149.199.45]:59327 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3LFXKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:10:50 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] can: ems_usb: fix urb leaks on failure paths
Date: Sat,  7 Dec 2013 03:10:35 +0400
Message-Id: <1386371435-17597-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple failure paths where urb leaks.
Is spare code within ems_usb_start_xmit(),
usb_free_urb() should be used to deallocate urb instead of usb_unanchor_urb().
In ems_usb_start() there is no usb_free_urb() if usb_submit_urb() fails.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/can/usb/ems_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 5f9a7ad9b964..8aeec0b4601a 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -625,6 +625,7 @@ static int ems_usb_start(struct ems_usb *dev)
 			usb_unanchor_urb(urb);
 			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
 					  urb->transfer_dma);
+			usb_free_urb(urb);
 			break;
 		}
 
@@ -798,8 +799,8 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 	 * allowed (MAX_TX_URBS).
 	 */
 	if (!context) {
-		usb_unanchor_urb(urb);
 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
+		usb_free_urb(urb);
 
 		netdev_warn(netdev, "couldn't find free context\n");
 
-- 
1.8.3.2

