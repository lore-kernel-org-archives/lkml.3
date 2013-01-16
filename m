Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3APQGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab3APQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 146/222] ipv4: ip_check_defrag must not modify skb before unsharing
Date: Wed, 16 Jan 2013 13:55:46 -0200
Message-Id: <1358351822-7675-147-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 1bf3751ec90cc3174e01f0d701e8449ce163d113 upstream.

ip_check_defrag() might be called from af_packet within the
RX path where shared SKBs are used, so it must not modify
the input SKB before it has unshared it for defragmentation.
Use skb_copy_bits() to get the IP header and only pull in
everything later.

The same is true for the other caller in macvlan as it is
called from dev->rx_handler which can also get a shared SKB.

Reported-by: Eric Leblond <eric@regit.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/ip_fragment.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 9dbd3dd..3fdcdb8 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -698,28 +698,27 @@ EXPORT_SYMBOL(ip_defrag);
 
 struct sk_buff *ip_check_defrag(struct sk_buff *skb, u32 user)
 {
-	const struct iphdr *iph;
+	struct iphdr iph;
 	u32 len;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return skb;
 
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+	if (!skb_copy_bits(skb, 0, &iph, sizeof(iph)))
 		return skb;
 
-	iph = ip_hdr(skb);
-	if (iph->ihl < 5 || iph->version != 4)
+	if (iph.ihl < 5 || iph.version != 4)
 		return skb;
-	if (!pskb_may_pull(skb, iph->ihl*4))
-		return skb;
-	iph = ip_hdr(skb);
-	len = ntohs(iph->tot_len);
-	if (skb->len < len || len < (iph->ihl * 4))
+
+	len = ntohs(iph.tot_len);
+	if (skb->len < len || len < (iph.ihl * 4))
 		return skb;
 
-	if (ip_is_fragment(ip_hdr(skb))) {
+	if (ip_is_fragment(&iph)) {
 		skb = skb_share_check(skb, GFP_ATOMIC);
 		if (skb) {
+			if (!pskb_may_pull(skb, iph.ihl*4))
+				return skb;
 			if (pskb_trim_rcsum(skb, len))
 				return skb;
 			memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
-- 
1.7.9.5

