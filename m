Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3I3KM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3I3KMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Fabio Estevam <festevam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 053/104] ipv6: Don't depend on per socket memory for neighbour discovery messages
Date: Mon, 30 Sep 2013 11:10:30 +0100
Message-Id: <1380535881-9239-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

commit 25a6e6b84fba601eff7c28d30da8ad7cfbef0d43 upstream.

Allocating skbs when sending out neighbour discovery messages
currently uses sock_alloc_send_skb() based on a per net namespace
socket and thus share a socket wmem buffer space.

If a netdevice is temporarily unable to transmit due to carrier
loss or for other reasons, the queued up ndisc messages will cosnume
all of the wmem space and will thus prevent from any more skbs to
be allocated even for netdevices that are able to transmit packets.

The number of neighbour discovery messages sent is very limited,
use of alloc_skb() bypasses the socket wmem buffer size enforcement
while the manual call to skb_set_owner_w() maintains the socket
reference needed for the IPv6 output path.

This patch has orginally been posted by Eric Dumazet in a modified
form.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Fabio Estevam <festevam@gmail.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ndisc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 35bfebc..fbe0f9f 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -429,7 +429,6 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
 	int len;
-	int err;
 	u8 *opt;
 
 	if (!dev->addr_len)
@@ -439,13 +438,11 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 	if (llinfo)
 		len += ndisc_opt_addr_space(dev);
 
-	skb = sock_alloc_send_skb(sk,
-				  (MAX_HEADER + sizeof(struct ipv6hdr) +
-				   len + hlen + tlen),
-				  1, &err);
+	skb = alloc_skb((MAX_HEADER + sizeof(struct ipv6hdr) +
+			 len + hlen + tlen), GFP_ATOMIC);
 	if (!skb) {
-		ND_PRINTK(0, err, "ND: %s failed to allocate an skb, err=%d\n",
-			  __func__, err);
+		ND_PRINTK(0, err, "ND: %s failed to allocate an skb\n",
+			  __func__);
 		return NULL;
 	}
 
@@ -473,6 +470,11 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 					   csum_partial(hdr,
 							len, 0));
 
+	/* Manually assign socket ownership as we avoid calling
+	 * sock_alloc_send_pskb() to bypass wmem buffer limits
+	 */
+	skb_set_owner_w(skb, sk);
+
 	return skb;
 }
 
-- 
1.8.3.2

