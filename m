Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaFGB1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:27:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36165 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Florian Westphal" <fw@strlen.de>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.986180684@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 20/92] net: ipv4: ip_forward: fix inverted local_df test
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ca6c5d4ad216d5942ae544bbf02503041bd802aa ]

local_df means 'ignore DF bit if set', so if its set we're
allowed to perform ip fragmentation.

This wasn't noticed earlier because the output path also drops such skbs
(and emits needed icmp error) and because netfilter ip defrag did not
set local_df until couple of days ago.

Only difference is that DF-packets-larger-than MTU now discarded
earlier (f.e. we avoid pointless netfilter postrouting trip).

While at it, drop the repeated test ip_exceeds_mtu, checking it once
is enough...

Fixes: fe6cc55f3a9 ("net: ip, ipv6: handle gso skbs in forwarding path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ip_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index e0d9f02..7593f3a 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -42,12 +42,12 @@
 static bool ip_may_fragment(const struct sk_buff *skb)
 {
 	return unlikely((ip_hdr(skb)->frag_off & htons(IP_DF)) == 0) ||
-	       !skb->local_df;
+		skb->local_df;
 }
 
 static bool ip_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 {
-	if (skb->len <= mtu || skb->local_df)
+	if (skb->len <= mtu)
 		return false;
 
 	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)

