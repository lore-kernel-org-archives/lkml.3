Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3ILRsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:48:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3ILRpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>, Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Stephen Warren <swarren@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/23] ipv6: Dont depend on per socket memory for neighbour discovery messages
Date: Thu, 12 Sep 2013 10:45:09 -0700
Message-Id: <20130912174453.171524005@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ndisc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -441,7 +441,6 @@ struct sk_buff *ndisc_build_skb(struct n
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
 	int len;
-	int err;
 	u8 *opt;
 
 	if (!dev->addr_len)
@@ -451,14 +450,12 @@ struct sk_buff *ndisc_build_skb(struct n
 	if (llinfo)
 		len += ndisc_opt_addr_space(dev);
 
-	skb = sock_alloc_send_skb(sk,
-				  (MAX_HEADER + sizeof(struct ipv6hdr) +
-				   len + hlen + tlen),
-				  1, &err);
+	skb = alloc_skb((MAX_HEADER + sizeof(struct ipv6hdr) +
+			 len + hlen + tlen), GFP_ATOMIC);
 	if (!skb) {
 		ND_PRINTK0(KERN_ERR
-			   "ICMPv6 ND: %s() failed to allocate an skb, err=%d.\n",
-			   __func__, err);
+			   "ICMPv6 ND: %s() failed to allocate an skb.\n",
+			   __func__);
 		return NULL;
 	}
 
@@ -486,6 +483,11 @@ struct sk_buff *ndisc_build_skb(struct n
 					   csum_partial(hdr,
 							len, 0));
 
+	/* Manually assign socket ownership as we avoid calling
+	 * sock_alloc_send_pskb() to bypass wmem buffer limits
+	 */
+	skb_set_owner_w(skb, sk);
+
 	return skb;
 }
 


