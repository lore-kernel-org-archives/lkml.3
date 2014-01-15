Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaAOWgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:36:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaAOVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 165/166] netpoll: Fix missing TXQ unlock and and OOPS.
Date: Wed, 15 Jan 2014 13:52:59 -0800
Message-Id: <1389822780-4729-166-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit aca5f58f9ba803ec8c2e6bcf890db17589e8dfcc ]

The VLAN tag handling code in netpoll_send_skb_on_dev() has two problems.

1) It exits without unlocking the TXQ.

2) It then tries to queue a NULL skb to npinfo->txq.

Reported-by: Ahmed Tamrawi <atamrawi@iastate.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/netpoll.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 40c1496..0281162 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -338,8 +338,14 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 					if (vlan_tx_tag_present(skb) &&
 					    !(netif_skb_features(skb) & NETIF_F_HW_VLAN_TX)) {
 						skb = __vlan_put_tag(skb, vlan_tx_tag_get(skb));
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
 
@@ -347,6 +353,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 					if (status == NETDEV_TX_OK)
 						txq_trans_update(txq);
 				}
+			unlock_txq:
 				__netif_tx_unlock(txq);
 
 				if (status == NETDEV_TX_OK)
-- 
1.8.3.2

