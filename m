Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaJ1Dku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:40:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaJ1Dkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:40:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.17 105/146] Bluetooth: 6lowpan: Route packets that are not meant to peer via correct device
Date: Tue, 28 Oct 2014 11:34:07 +0800
Message-Id: <20141028033348.007370648@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jukka Rissanen <jukka.rissanen@linux.intel.com>

commit 39e90c77637b3892a39f2908aea57539e961c50e upstream.

Packets that are supposed to be delivered via the peer device need to
be checked and sent to correct device. This requires that user has set
the routes properly so that the 6lowpan module can then figure out
the destination gateway and the correct Bluetooth device.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/6lowpan.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -39,6 +39,7 @@ static struct dentry *lowpan_control_deb
 
 struct skb_cb {
 	struct in6_addr addr;
+	struct in6_addr gw;
 	struct l2cap_chan *chan;
 	int status;
 };
@@ -158,6 +159,54 @@ static inline struct lowpan_peer *peer_l
 	return NULL;
 }
 
+static inline struct lowpan_peer *peer_lookup_dst(struct lowpan_dev *dev,
+						  struct in6_addr *daddr,
+						  struct sk_buff *skb)
+{
+	struct lowpan_peer *peer, *tmp;
+	struct in6_addr *nexthop;
+	struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
+	int count = atomic_read(&dev->peer_count);
+
+	BT_DBG("peers %d addr %pI6c rt %p", count, daddr, rt);
+
+	/* If we have multiple 6lowpan peers, then check where we should
+	 * send the packet. If only one peer exists, then we can send the
+	 * packet right away.
+	 */
+	if (count == 1)
+		return list_first_entry(&dev->peers, struct lowpan_peer,
+					list);
+
+	if (!rt) {
+		nexthop = &lowpan_cb(skb)->gw;
+
+		if (ipv6_addr_any(nexthop))
+			return NULL;
+	} else {
+		nexthop = rt6_nexthop(rt);
+
+		/* We need to remember the address because it is needed
+		 * by bt_xmit() when sending the packet. In bt_xmit(), the
+		 * destination routing info is not set.
+		 */
+		memcpy(&lowpan_cb(skb)->gw, nexthop, sizeof(struct in6_addr));
+	}
+
+	BT_DBG("gw %pI6c", nexthop);
+
+	list_for_each_entry_safe(peer, tmp, &dev->peers, list) {
+		BT_DBG("dst addr %pMR dst type %d ip %pI6c",
+		       &peer->chan->dst, peer->chan->dst_type,
+		       &peer->peer_addr);
+
+		if (!ipv6_addr_cmp(&peer->peer_addr, nexthop))
+			return peer;
+	}
+
+	return NULL;
+}
+
 static struct lowpan_peer *lookup_peer(struct l2cap_conn *conn)
 {
 	struct lowpan_dev *entry, *tmp;
@@ -415,8 +464,18 @@ static int header_create(struct sk_buff
 		read_unlock_irqrestore(&devices_lock, flags);
 
 		if (!peer) {
-			BT_DBG("no such peer %pMR found", &addr);
-			return -ENOENT;
+			/* The packet might be sent to 6lowpan interface
+			 * because of routing (either via default route
+			 * or user set route) so get peer according to
+			 * the destination address.
+			 */
+			read_lock_irqsave(&devices_lock, flags);
+			peer = peer_lookup_dst(dev, &hdr->daddr, skb);
+			read_unlock_irqrestore(&devices_lock, flags);
+			if (!peer) {
+				BT_DBG("no such peer %pMR found", &addr);
+				return -ENOENT;
+			}
 		}
 
 		daddr = peer->eui64_addr;
@@ -520,6 +579,8 @@ static netdev_tx_t bt_xmit(struct sk_buf
 
 		read_lock_irqsave(&devices_lock, flags);
 		peer = peer_lookup_ba(dev, &addr, addr_type);
+		if (!peer)
+			peer = peer_lookup_dst(dev, &lowpan_cb(skb)->addr, skb);
 		read_unlock_irqrestore(&devices_lock, flags);
 
 		BT_DBG("xmit %s to %pMR type %d IP %pI6c peer %p",


