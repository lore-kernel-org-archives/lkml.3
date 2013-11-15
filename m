Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3KOMau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:30:50 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42747 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3KOMaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:30:23 -0500
Date: Fri, 15 Nov 2013 20:29:37 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: et131x: drop packet when error occurs in
 et131x_tx
Message-ID: <c55eeb3252a868e9e62655baed8d6b11992b9cbe.1384518190.git.gamerh2o@gmail.com>
Mail-Followup-To: ZHAO Gang <gamerh2o@gmail.com>,
	Mark Einon <mark.einon@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
References: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As TODO file suggested, drop packet instead of return NETDEV_TX_BUSY
when tx failed.

et131x_tx calls function et131x_send_packets, I put the work of
et131x_send_packets directly into et131x_tx, and made some changes to
let the code more readable.

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 drivers/staging/et131x/et131x.c | 84 +++++++++++------------------------------
 1 file changed, 22 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 836a4db..cda037a 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3123,55 +3123,6 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
 	return 0;
 }
 
-/* et131x_send_packets - This function is called by the OS to send packets
- * @skb: the packet(s) to send
- * @netdev:device on which to TX the above packet(s)
- *
- * Return 0 in almost all cases; non-zero value in extreme hard failure only
- */
-static int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
-{
-	int status = 0;
-	struct et131x_adapter *adapter = netdev_priv(netdev);
-
-	/* Send these packets
-	 *
-	 * NOTE: The Linux Tx entry point is only given one packet at a time
-	 * to Tx, so the PacketCount and it's array used makes no sense here
-	 */
-
-	/* TCB is not available */
-	if (adapter->tx_ring.used >= NUM_TCB) {
-		/* NOTE: If there's an error on send, no need to queue the
-		 * packet under Linux; if we just send an error up to the
-		 * netif layer, it will resend the skb to us.
-		 */
-		status = -ENOMEM;
-	} else {
-		/* We need to see if the link is up; if it's not, make the
-		 * netif layer think we're good and drop the packet
-		 */
-		if ((adapter->flags & FMP_ADAPTER_FAIL_SEND_MASK) ||
-					!netif_carrier_ok(netdev)) {
-			dev_kfree_skb_any(skb);
-			skb = NULL;
-
-			adapter->net_stats.tx_dropped++;
-		} else {
-			status = send_packet(skb, adapter);
-			if (status != 0 && status != -ENOMEM) {
-				/* On any other error, make netif think we're
-				 * OK and drop the packet
-				 */
-				dev_kfree_skb_any(skb);
-				skb = NULL;
-				adapter->net_stats.tx_dropped++;
-			}
-		}
-	}
-	return status;
-}
-
 /* free_send_packet - Recycle a struct tcb
  * @adapter: pointer to our adapter
  * @tcb: pointer to struct tcb
@@ -4537,12 +4488,9 @@ static void et131x_multicast(struct net_device *netdev)
 /* et131x_tx - The handler to tx a packet on the device
  * @skb: data to be Tx'd
  * @netdev: device on which data is to be Tx'd
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 {
-	int status = 0;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
 	/* stop the queue if it's getting full */
@@ -4553,17 +4501,29 @@ static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 	/* Save the timestamp for the TX timeout watchdog */
 	netdev->trans_start = jiffies;
 
-	/* Call the device-specific data Tx routine */
-	status = et131x_send_packets(skb, netdev);
+	/* TCB is not available */
+	if (adapter->tx_ring.used >= NUM_TCB)
+		goto drop;
 
-	/* Check status and manage the netif queue if necessary */
-	if (status != 0) {
-		if (status == -ENOMEM)
-			status = NETDEV_TX_BUSY;
-		else
-			status = NETDEV_TX_OK;
+	/* We need to see if the link is up; if it's not, make the
+	 * netif layer think we're good and drop the packet
+	 */
+	if ((adapter->flags & FMP_ADAPTER_FAIL_SEND_MASK) ||
+	    !netif_carrier_ok(netdev)) {
+		goto drop;
+	} else {
+		if (!send_packet(skb, adapter))
+			goto out;
+		/* On error (send_packet returns != 0), make netif
+		 * think we're OK and drop the packet
+		 */
 	}
-	return status;
+
+drop:
+	dev_kfree_skb_any(skb);
+	adapter->net_stats.tx_dropped++;
+out:
+	return NETDEV_TX_OK;
 }
 
 /* et131x_tx_timeout - Timeout handler
-- 
1.8.3.1

