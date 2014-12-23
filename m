Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaLWPrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:47:07 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46047 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLWPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:47:05 -0500
Date: Tue, 23 Dec 2014 17:46:54 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] can: kvaser_usb: Don't free packets when tight on URBs
Message-ID: <20141223154654.GB6460@vivalin-002>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <ahmed.darwish@valeo.com>

Flooding the Kvaser CAN to USB dongle with multiple reads and
writes in high frequency caused seemingly-random panics in the
kernel.

On further inspection, it seems the driver erroneously freed the
to-be-transmitted packet upon getting tight on URBs and returning
NETDEV_TX_BUSY, leading to invalid memory writes and double frees
at a later point in time.

Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
---
 drivers/net/can/usb/kvaser_usb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

 (Generated over 3.19.0-rc1)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 541fb7a..34c35d8 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1286,6 +1286,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 	struct kvaser_msg *msg;
 	int i, err;
 	int ret = NETDEV_TX_OK;
+	bool kfree_skb_on_error = true;
 
 	if (can_dropped_invalid_skb(netdev, skb))
 		return NETDEV_TX_OK;
@@ -1336,6 +1337,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 
 	if (!context) {
 		netdev_warn(netdev, "cannot find free context\n");
+		kfree_skb_on_error = false;
 		ret =  NETDEV_TX_BUSY;
 		goto releasebuf;
 	}
@@ -1364,8 +1366,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 	if (unlikely(err)) {
 		can_free_echo_skb(netdev, context->echo_index);
 
-		skb = NULL; /* set to NULL to avoid double free in
-			     * dev_kfree_skb(skb) */
+		kfree_skb_on_error = false;
 
 		atomic_dec(&priv->active_tx_urbs);
 		usb_unanchor_urb(urb);
@@ -1389,7 +1390,8 @@ releasebuf:
 nobufmem:
 	usb_free_urb(urb);
 nourbmem:
-	dev_kfree_skb(skb);
+	if (kfree_skb_on_error)
+		dev_kfree_skb(skb);
 	return ret;
 }

