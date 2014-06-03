Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaFCLuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:50:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaFCLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/138] net: ipv4: ip_forward: fix inverted local_df test
Date: Tue,  3 Jun 2014 12:39:24 +0100
Message-Id: <1401795584-22664-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit ca6c5d4ad216d5942ae544bbf02503041bd802aa upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 98d7e53d2afd..bd1c5baf69be 100644
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

