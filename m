Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3AQFJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:09:53 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40463 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685Ab3AQFJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:09:49 -0500
X-Sasl-enc: 5o2ZXCvuSE+J0cvN59MfbAcva3KkMzxOU85hD4JaMBa+ 1358399388
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Cheneau <tony.cheneau@amnesiak.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 1/2] 6lowpan: Refactor packet delivery into a function
Date: Thu, 17 Jan 2013 00:09:47 -0500
Message-Id: <1358399388-30062-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1358399388-30062-1-git-send-email-alan@signal11.us>
References: <1358315037-10043-1-git-send-email-alan@signal11.us>
 <1358399388-30062-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the handing of the skb's to the individual lowpan devices into a
function.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/ieee802154/6lowpan.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index f651da6..1714cfa 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -594,10 +594,32 @@ static int lowpan_header_create(struct sk_buff *skb,
 	}
 }
 
+static int lowpan_give_skb_to_devices(struct sk_buff *skb)
+{
+	struct lowpan_dev_record *entry;
+	struct sk_buff *skb_cp;
+	int stat = NET_RX_SUCCESS;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(entry, &lowpan_devices, list)
+		if (lowpan_dev_info(entry->ldev)->real_dev == skb->dev) {
+			skb_cp = skb_copy(skb, GFP_ATOMIC);
+			if (!skb_cp) {
+				stat = -ENOMEM;
+				break;
+			}
+
+			skb_cp->dev = entry->ldev;
+			stat = netif_rx(skb_cp);
+		}
+	rcu_read_unlock();
+
+	return stat;
+}
+
 static int lowpan_skb_deliver(struct sk_buff *skb, struct ipv6hdr *hdr)
 {
 	struct sk_buff *new;
-	struct lowpan_dev_record *entry;
 	int stat = NET_RX_SUCCESS;
 
 	new = skb_copy_expand(skb, sizeof(struct ipv6hdr), skb_tailroom(skb),
@@ -614,19 +636,7 @@ static int lowpan_skb_deliver(struct sk_buff *skb, struct ipv6hdr *hdr)
 	new->protocol = htons(ETH_P_IPV6);
 	new->pkt_type = PACKET_HOST;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(entry, &lowpan_devices, list)
-		if (lowpan_dev_info(entry->ldev)->real_dev == new->dev) {
-			skb = skb_copy(new, GFP_ATOMIC);
-			if (!skb) {
-				stat = -ENOMEM;
-				break;
-			}
-
-			skb->dev = entry->ldev;
-			stat = netif_rx(skb);
-		}
-	rcu_read_unlock();
+	stat = lowpan_give_skb_to_devices(new);
 
 	kfree_skb(new);
 
-- 
1.7.11.2

