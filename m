Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbbAKUuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:50:00 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33405 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAKUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:49:57 -0500
Date: Sun, 11 Jan 2015 15:49:52 -0500
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 01/04] can: kvaser_usb: Don't dereference skb after a
 netif_rx()
Message-ID: <20150111204952.GC8999@linux>
References: <20141223154654.GB6460@vivalin-002>
 <20150111200544.GA8855@linux>
 <20150111201116.GB8855@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111201116.GB8855@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <ahmed.darwish@valeo.com>

We should not touch the packet after a netif_rx: it might
get freed behind our back.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
---
 drivers/net/can/usb/kvaser_usb.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

 (Resend, fix the garbled subject line. Sorry)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index cc7bfc0..c32cd61 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -520,10 +520,10 @@ static void kvaser_usb_tx_acknowledge(const struct kvaser_usb *dev,
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb) {
 			cf->can_id |= CAN_ERR_RESTARTED;
-			netif_rx(skb);
 
 			stats->rx_packets++;
 			stats->rx_bytes += cf->can_dlc;
+			netif_rx(skb);
 		} else {
 			netdev_err(priv->netdev,
 				   "No memory left for err_skb\n");
@@ -770,10 +770,9 @@ static void kvaser_usb_rx_error(const struct kvaser_usb *dev,
 
 	priv->can.state = new_state;
 
-	netif_rx(skb);
-
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
+	netif_rx(skb);
 }
 
 static void kvaser_usb_rx_can_err(const struct kvaser_usb_net_priv *priv,
@@ -805,10 +804,9 @@ static void kvaser_usb_rx_can_err(const struct kvaser_usb_net_priv *priv,
 		stats->rx_over_errors++;
 		stats->rx_errors++;
 
-		netif_rx(skb);
-
 		stats->rx_packets++;
 		stats->rx_bytes += cf->can_dlc;
+		netif_rx(skb);
 	}
 }
 
@@ -887,10 +885,9 @@ static void kvaser_usb_rx_can_msg(const struct kvaser_usb *dev,
 			       cf->can_dlc);
 	}
 
-	netif_rx(skb);
-
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
+	netif_rx(skb);
 }
 
 static void kvaser_usb_start_chip_reply(const struct kvaser_usb *dev,
-- 
1.9.1

