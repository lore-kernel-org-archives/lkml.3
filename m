Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3JUJci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:32:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39309 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab3JUIuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Stephen Warren" <swarren@nvidia.com>, "Thomas Graf" <tgraf@suug.ch>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "Fabio Estevam" <festevam@gmail.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.613078978@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 011/149] ipv6: Don't depend on per socket memory for
 neighbour  discovery messages
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

[ Upstream commit 25a6e6b84fba601eff7c28d30da8ad7cfbef0d43 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ndisc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 9ffc37f..bc55358 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -447,7 +447,6 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 	struct sk_buff *skb;
 	struct icmp6hdr *hdr;
 	int len;
-	int err;
 	u8 *opt;
 
 	if (!dev->addr_len)
@@ -457,14 +456,12 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 	if (llinfo)
 		len += ndisc_opt_addr_space(dev);
 
-	skb = sock_alloc_send_skb(sk,
-				  (MAX_HEADER + sizeof(struct ipv6hdr) +
-				   len + LL_ALLOCATED_SPACE(dev)),
-				  1, &err);
+	skb = alloc_skb((MAX_HEADER + sizeof(struct ipv6hdr) +
+			 len + LL_ALLOCATED_SPACE(dev)), GFP_ATOMIC);
 	if (!skb) {
 		ND_PRINTK0(KERN_ERR
-			   "ICMPv6 ND: %s() failed to allocate an skb, err=%d.\n",
-			   __func__, err);
+			   "ICMPv6 ND: %s() failed to allocate an skb.\n",
+			   __func__);
 		return NULL;
 	}
 
@@ -492,6 +489,11 @@ struct sk_buff *ndisc_build_skb(struct net_device *dev,
 					   csum_partial(hdr,
 							len, 0));
 
+	/* Manually assign socket ownership as we avoid calling
+	 * sock_alloc_send_pskb() to bypass wmem buffer limits
+	 */
+	skb_set_owner_w(skb, sk);
+
 	return skb;
 }
 

