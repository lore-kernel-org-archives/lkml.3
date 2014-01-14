Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaANAnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:43:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaANA2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ahmed Tamrawi <atamrawi@iastate.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 38/77] netpoll: Fix missing TXQ unlock and and OOPS.
Date: Mon, 13 Jan 2014 16:27:59 -0800
Message-Id: <20140114002753.585811748@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit aca5f58f9ba803ec8c2e6bcf890db17589e8dfcc ]

The VLAN tag handling code in netpoll_send_skb_on_dev() has two problems.

1) It exits without unlocking the TXQ.

2) It then tries to queue a NULL skb to npinfo->txq.

Reported-by: Ahmed Tamrawi <atamrawi@iastate.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -386,8 +386,14 @@ void netpoll_send_skb_on_dev(struct netp
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
 
@@ -395,6 +401,7 @@ void netpoll_send_skb_on_dev(struct netp
 					if (status == NETDEV_TX_OK)
 						txq_trans_update(txq);
 				}
+			unlock_txq:
 				__netif_tx_unlock(txq);
 
 				if (status == NETDEV_TX_OK)


