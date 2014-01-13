Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaAMQFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:05:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaAMQFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 194/208] netpoll: Fix missing TXQ unlock and and OOPS.
Date: Mon, 13 Jan 2014 16:00:35 +0000
Message-Id: <1389628849-1614-195-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit aca5f58f9ba803ec8c2e6bcf890db17589e8dfcc upstream.

The VLAN tag handling code in netpoll_send_skb_on_dev() has two problems.

1) It exits without unlocking the TXQ.

2) It then tries to queue a NULL skb to npinfo->txq.

Reported-by: Ahmed Tamrawi <atamrawi@iastate.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/netpoll.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index fc75c9e..0c1482c 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -386,8 +386,14 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 					    !vlan_hw_offload_capable(netif_skb_features(skb),
 								     skb->vlan_proto)) {
 						skb = __vlan_put_tag(skb, skb->vlan_proto, vlan_tx_tag_get(skb));
-						if (unlikely(!skb))
-							break;
+						if (unlikely(!skb)) {
+							/* This is actually a packet drop, but we
+							 * don't want the code at the end of this
+							 * function to try and re-queue a NULL skb.
+							 */
+							status = NETDEV_TX_OK;
+							goto unlock_txq;
+						}
 						skb->vlan_tci = 0;
 					}
 
@@ -395,6 +401,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 					if (status == NETDEV_TX_OK)
 						txq_trans_update(txq);
 				}
+			unlock_txq:
 				__netif_tx_unlock(txq);
 
 				if (status == NETDEV_TX_OK)
-- 
1.8.3.2

