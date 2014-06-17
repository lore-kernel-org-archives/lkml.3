Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965198AbaFQQbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:31:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965325AbaFQQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:26:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 068/121] net: ipv4: ip_forward: fix inverted local_df test
Date: Tue, 17 Jun 2014 09:17:26 -0700
Message-Id: <1403021899-16708-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 98d7e53..bd1c5ba 100644
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
-- 
1.9.1

