Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935873Ab3DHJwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42965 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935795Ab3DHJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Erik Hugne <erik.hugne@ericsson.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 075/102] ipv6: don't accept multicast traffic with scope 0
Date: Mon,  8 Apr 2013 10:50:30 +0100
Message-Id: <1365414657-29191-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 20314092c1b41894d8c181bf9aa6f022be2416aa upstream.

v2:
a) moved before multicast source address check
b) changed comment to netdev style

Cc: Erik Hugne <erik.hugne@ericsson.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_input.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 61dfb1d..311eac7 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -111,6 +111,15 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
 	    ipv6_addr_loopback(&hdr->daddr))
 		goto err;
 
+	/* RFC4291 2.7
+	 * Nodes must not originate a packet to a multicast address whose scope
+	 * field contains the reserved value 0; if such a packet is received, it
+	 * must be silently dropped.
+	 */
+	if (ipv6_addr_is_multicast(&hdr->daddr) &&
+	    IPV6_ADDR_MC_SCOPE(&hdr->daddr) == 0)
+		goto err;
+
 	/*
 	 * RFC4291 2.7
 	 * Multicast addresses must not be used as source addresses in IPv6
-- 
1.8.1.2

