Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152AbbA2ChI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965126AbbA2ChE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        Tom Herbert <therbert@google.com>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 001/139] gre: fix the inner mac header in nbma tunnel xmit path
Date: Wed, 28 Jan 2015 14:19:04 -0800
Message-Id: <1422483682-15393-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>

[ Upstream commit 8a0033a947403569caeca45fa5e6f7ba60d51974 ]

The NBMA GRE tunnels temporarily push GRE header that contain the
per-packet NBMA destination on the skb via header ops early in xmit
path. It is the later pulled before the real GRE header is constructed.

The inner mac was thus set differently in nbma case: the GRE header
has been pushed by neighbor layer, and mac header points to beginning
of the temporary gre header (set by dev_queue_xmit).

Now that the offloads expect mac header to point to the gre payload,
fix the xmit patch to:
 - pull first the temporary gre header away
 - and reset mac header to point to gre payload

This fixes tso to work again with nbma tunnels.

Fixes: 14051f0452a2 ("gre: Use inner mac length when computing tunnel length")
Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Cc: Tom Herbert <therbert@google.com>
Cc: Alexander Duyck <alexander.h.duyck@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_gre.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b3becd0..b22c309 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -250,10 +250,6 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 	const struct iphdr *tnl_params;
 
-	skb = gre_handle_offloads(skb, !!(tunnel->parms.o_flags&TUNNEL_CSUM));
-	if (IS_ERR(skb))
-		goto out;
-
 	if (dev->header_ops) {
 		/* Need space for new headers */
 		if (skb_cow_head(skb, dev->needed_headroom -
@@ -266,6 +262,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 		 * to gre header.
 		 */
 		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
+		skb_reset_mac_header(skb);
 	} else {
 		if (skb_cow_head(skb, dev->needed_headroom))
 			goto free_skb;
@@ -273,6 +270,10 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 		tnl_params = &tunnel->parms.iph;
 	}
 
+	skb = gre_handle_offloads(skb, !!(tunnel->parms.o_flags&TUNNEL_CSUM));
+	if (IS_ERR(skb))
+		goto out;
+
 	__gre_xmit(skb, dev, tnl_params, skb->protocol);
 
 	return NETDEV_TX_OK;
-- 
1.9.1

