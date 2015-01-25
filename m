Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbbAYSJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:09:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbbAYSIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Sobrie <olivier@sobrie.be>,
        "Ahmed S. Darwish" <ahmed.darwish@valeo.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.10 32/50] can: kvaser_usb: Dont free packets when tight on URBs
Date: Sun, 25 Jan 2015 10:07:22 -0800
Message-Id: <20150125180704.475709726@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ahmed S. Darwish" <ahmed.darwish@valeo.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1286,12 +1286,14 @@ static netdev_tx_t kvaser_usb_start_xmit
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
 
@@ -1326,6 +1328,7 @@ static netdev_tx_t kvaser_usb_start_xmit
 		}
 	}
 
+	/* This should never happen; it implies a flow control bug */
 	if (!context) {
 		netdev_warn(netdev, "cannot find free context\n");
 		ret =  NETDEV_TX_BUSY;
@@ -1356,9 +1359,6 @@ static netdev_tx_t kvaser_usb_start_xmit
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
 


