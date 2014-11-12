Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaKLEXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:23:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaKLBUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 017/319] macvlan: fix a race on port dismantle and possible skb leaks
Date: Wed, 12 Nov 2014 10:12:35 +0900
Message-Id: <20141112010955.530706157@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fe0ca7328d03d36aafecebb3af650e1bb2841c20 ]

We need to cancel the work queue after rcu grace period,
otherwise it can be rescheduled by incoming packets.

We need to purge queue if some skbs are still in it.

We can use __skb_queue_head_init() variant in
macvlan_process_broadcast()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 412ca1550cbec ("macvlan: Move broadcasts into a work queue")
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -201,7 +201,7 @@ static void macvlan_process_broadcast(st
 	struct sk_buff *skb;
 	struct sk_buff_head list;
 
-	skb_queue_head_init(&list);
+	__skb_queue_head_init(&list);
 
 	spin_lock_bh(&port->bc_queue.lock);
 	skb_queue_splice_tail_init(&port->bc_queue, &list);
@@ -941,9 +941,15 @@ static void macvlan_port_destroy(struct
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
 


