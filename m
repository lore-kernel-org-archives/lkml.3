Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3ILSDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:03:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3ILR7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xi Wang <xii@google.com>, Eric Dumazet <edumazet@google.com>,
        Tom Herbert <therbert@google.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/46] net: revert 8728c544a9c ("net: dev_pick_tx() fix")
Date: Thu, 12 Sep 2013 10:58:46 -0700
Message-Id: <20130912175724.803604186@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 702821f4ea6f68db18aa1de7d8ed62c6ba586a64 ]

commit 8728c544a9cbdc ("net: dev_pick_tx() fix") and commit
b6fe83e9525a ("bonding: refine IFF_XMIT_DST_RELEASE capability")
are quite incompatible : Queue selection is disabled because skb
dst was dropped before entering bonding device.

This causes major performance regression, mainly because TCP packets
for a given flow can be sent to multiple queues.

This is particularly visible when using the new FQ packet scheduler
with MQ + FQ setup on the slaves.

We can safely revert the first commit now that 416186fbf8c5b
("net: Split core bits of netdev_pick_tx into __netdev_pick_tx")
properly caps the queue_index.

Reported-by: Xi Wang <xii@google.com>
Diagnosed-by: Xi Wang <xii@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -345,14 +345,9 @@ u16 __netdev_pick_tx(struct net_device *
 		if (new_index < 0)
 			new_index = skb_tx_hash(dev, skb);
 
-		if (queue_index != new_index && sk) {
-			struct dst_entry *dst =
-				    rcu_dereference_check(sk->sk_dst_cache, 1);
-
-			if (dst && skb_dst(skb) == dst)
-				sk_tx_queue_set(sk, queue_index);
-
-		}
+		if (queue_index != new_index && sk &&
+		    rcu_access_pointer(sk->sk_dst_cache))
+			sk_tx_queue_set(sk, queue_index);
 
 		queue_index = new_index;
 	}


