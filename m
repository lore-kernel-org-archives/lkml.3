Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaKKLKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbaKKLKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 079/170] macvlan: fix a race on port dismantle and possible skb leaks
Date: Tue, 11 Nov 2014 11:07:18 +0000
Message-Id: <1415704129-12709-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit fe0ca7328d03d36aafecebb3af650e1bb2841c20 upstream.

We need to cancel the work queue after rcu grace period,
otherwise it can be rescheduled by incoming packets.

We need to purge queue if some skbs are still in it.

We can use __skb_queue_head_init() variant in
macvlan_process_broadcast()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 412ca1550cbec ("macvlan: Move broadcasts into a work queue")
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvlan.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index f3008e3cf118..d4404e4cad41 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -201,7 +201,7 @@ static void macvlan_process_broadcast(struct work_struct *w)
 	struct sk_buff *skb;
 	struct sk_buff_head list;
 
-	skb_queue_head_init(&list);
+	__skb_queue_head_init(&list);
 
 	spin_lock_bh(&port->bc_queue.lock);
 	skb_queue_splice_tail_init(&port->bc_queue, &list);
@@ -935,9 +935,15 @@ static void macvlan_port_destroy(struct net_device *dev)
 {
 	struct macvlan_port *port = macvlan_port_get_rtnl(dev);
 
-	cancel_work_sync(&port->bc_work);
 	dev->priv_flags &= ~IFF_MACVLAN_PORT;
 	netdev_rx_handler_unregister(dev);
+
+	/* After this point, no packet can schedule bc_work anymore,
+	 * but we need to cancel it and purge left skbs if any.
+	 */
+	cancel_work_sync(&port->bc_work);
+	__skb_queue_purge(&port->bc_queue);
+
 	kfree_rcu(port, rcu);
 }
 
-- 
2.1.0

