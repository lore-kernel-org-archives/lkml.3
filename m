Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbbA2JBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:34 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757299AbbA2JBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Ahmed S. Darwish" <ahmed.darwish@valeo.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 116/176] can: kvaser_usb: Don't free packets when tight on URBs
Date: Wed, 28 Jan 2015 15:29:06 +0100
Message-Id: <c08eb06c197a0c279bd08c1c075acd58e7836a56.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ahmed S. Darwish" <ahmed.darwish@valeo.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b442723fcec445fb0ae1104888dd22cd285e0a91 upstream.

Flooding the Kvaser CAN to USB dongle with multiple reads and
writes in high frequency caused seemingly-random panics in the
kernel.

On further inspection, it seems the driver erroneously freed the
to-be-transmitted packet upon getting tight on URBs and returning
NETDEV_TX_BUSY, leading to invalid memory writes and double frees
at a later point in time.

Note:

Finding no more URBs/transmit-contexts and returning NETDEV_TX_BUSY
is a driver bug in and out of itself: it means that our start/stop
queue flow control is broken.

This patch only fixes the (buggy) error handling code; the root
cause shall be fixed in a later commit.

Acked-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/usb/kvaser_usb.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index cc3df8aebb87..f6e30be1c0eb 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1286,12 +1286,14 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 	if (!urb) {
 		netdev_err(netdev, "No memory left for URBs\n");
 		stats->tx_dropped++;
-		goto nourbmem;
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
 	}
 
 	buf = kmalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
 	if (!buf) {
 		stats->tx_dropped++;
+		dev_kfree_skb(skb);
 		goto nobufmem;
 	}
 
@@ -1326,6 +1328,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 		}
 	}
 
+	/* This should never happen; it implies a flow control bug */
 	if (!context) {
 		netdev_warn(netdev, "cannot find free context\n");
 		ret =  NETDEV_TX_BUSY;
@@ -1356,9 +1359,6 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 	if (unlikely(err)) {
 		can_free_echo_skb(netdev, context->echo_index);
 
-		skb = NULL; /* set to NULL to avoid double free in
-			     * dev_kfree_skb(skb) */
-
 		atomic_dec(&priv->active_tx_urbs);
 		usb_unanchor_urb(urb);
 
@@ -1380,8 +1380,6 @@ releasebuf:
 	kfree(buf);
 nobufmem:
 	usb_free_urb(urb);
-nourbmem:
-	dev_kfree_skb(skb);
 	return ret;
 }
 
-- 
2.2.2

