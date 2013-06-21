Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713Ab3FULyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:54:23 -0400
Received: from mout.web.de ([212.227.15.4]:64554 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965513Ab3FULyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 07:54:21 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: bridge@lists.linux-foundation.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH] bridge: prevent flooding IPv6 packets that do not have a listener
Date: Fri, 21 Jun 2013 13:53:58 +0200
Message-Id: <1371815638-5618-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:mSHJ+uDUYdac4Wqhe1DLmcIdR+1PgucTUUbelXDANBDPNs6b+pd
 5tGDPeR07T/oIq0qb/chEoWg344PyeddMmJ/DAfA7VE63qP8p4oFI6k8qKSDnjXnCOB+dBF
 6QL4JVLWik8Yw6NOyRMpfbwjsqaZ0bsVPzw2yXzo9tFjTuTOlfhSylDvmT3kTg5w0PdUcTn
 kemzn78cN9rgfbk95i9FA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if there is no listener for a certain group then IPv6 packets
for that group are flooded on all ports, even though there might be no
host and router interested in it on a port.

With this commit they are only forwarded to ports with a multicast
router.

Just like commit bd4265fe36 ("bridge: Only flood unregistered groups
to routers") did for IPv4, let's do the same for IPv6 with the same
reasoning.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 81f2389..8bdfaf5 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1465,8 +1465,14 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 	 *  - MLD has always Router Alert hop-by-hop option
 	 *  - But we do not support jumbrograms.
 	 */
-	if (ip6h->version != 6 ||
-	    ip6h->nexthdr != IPPROTO_HOPOPTS ||
+	if (ip6h->version != 6)
+		return 0;
+
+	/* Prevent flooding this packet if there is no listener present */
+	if (ipv6_is_transient_multicast(&ip6h->daddr))
+		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
+
+	if (ip6h->nexthdr != IPPROTO_HOPOPTS ||
 	    ip6h->payload_len == 0)
 		return 0;
 
-- 
1.7.10.4

