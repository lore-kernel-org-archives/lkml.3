Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaJMCmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:42:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbaJMC3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:29:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thibaut Collet <thibaut.collet@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 26/55] macvlan: allow to enqueue broadcast pkt on virtual device
Date: Mon, 13 Oct 2014 04:24:40 +0200
Message-Id: <20141013022444.879115350@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 07d92d5cc977a7fe1e683e1d4a6f723f7f2778cb ]

Since commit 412ca1550cbe ("macvlan: Move broadcasts into a work queue"), the
driver uses tx_queue_len of the master device as the limit of packets enqueuing.
Problem is that virtual drivers have this value set to 0, thus all broadcast
packets were rejected.
Because tx_queue_len was arbitrarily chosen, I replace it with a static limit
of 1000 (also arbitrarily chosen).

CC: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: Thibaut Collet <thibaut.collet@6wind.com>
Suggested-by: Thibaut Collet <thibaut.collet@6wind.com>
Tested-by: Thibaut Collet <thibaut.collet@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -36,6 +36,7 @@
 #include <linux/netpoll.h>
 
 #define MACVLAN_HASH_SIZE	(1 << BITS_PER_BYTE)
+#define MACVLAN_BC_QUEUE_LEN	1000
 
 struct macvlan_port {
 	struct net_device	*dev;
@@ -248,7 +249,7 @@ static void macvlan_broadcast_enqueue(st
 		goto err;
 
 	spin_lock(&port->bc_queue.lock);
-	if (skb_queue_len(&port->bc_queue) < skb->dev->tx_queue_len) {
+	if (skb_queue_len(&port->bc_queue) < MACVLAN_BC_QUEUE_LEN) {
 		__skb_queue_tail(&port->bc_queue, nskb);
 		err = 0;
 	}


