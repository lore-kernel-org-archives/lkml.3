Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaAMQQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:16:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaAMQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 178/208] ipv6: fix illegal mac_header comparison on 32bit
Date: Mon, 13 Jan 2014 16:00:19 +0000
Message-Id: <1389628849-1614-179-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/skbuff.h | 5 +++++
 net/ipv6/udp_offload.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 37b4517..e27c8f6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1643,6 +1643,11 @@ static inline void skb_set_mac_header(struct sk_buff *skb, const int offset)
 	skb->mac_header += offset;
 }
 
+static inline void skb_pop_mac_header(struct sk_buff *skb)
+{
+	skb->mac_header = skb->network_header;
+}
+
 static inline void skb_probe_transport_header(struct sk_buff *skb,
 					      const int offset_hint)
 {
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 657914b..f21df3f 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -86,7 +86,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 
 	/* Check if there is enough headroom to insert fragment header. */
 	tnl_hlen = skb_tnl_header_len(skb);
-	if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
+	if (skb_mac_header(skb) < skb->head + tnl_hlen + frag_hdr_sz) {
 		if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
 			goto out;
 	}
-- 
1.8.3.2

