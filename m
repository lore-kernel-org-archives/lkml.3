Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaANBIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:08:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaANA1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH 3.10 19/62] ipv6: fix illegal mac_header comparison on 32bit
Date: Mon, 13 Jan 2014 16:26:44 -0800
Message-Id: <20140114002711.010498709@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    5 +++++
 net/ipv6/udp_offload.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1741,6 +1741,11 @@ static inline void skb_set_mac_header(st
 }
 #endif /* NET_SKBUFF_DATA_USES_OFFSET */
 
+static inline void skb_pop_mac_header(struct sk_buff *skb)
+{
+	skb->mac_header = skb->network_header;
+}
+
 static inline void skb_probe_transport_header(struct sk_buff *skb,
 					      const int offset_hint)
 {
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -85,7 +85,7 @@ static struct sk_buff *udp6_ufo_fragment
 
 	/* Check if there is enough headroom to insert fragment header. */
 	tnl_hlen = skb_tnl_header_len(skb);
-	if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
+	if (skb_mac_header(skb) < skb->head + tnl_hlen + frag_hdr_sz) {
 		if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
 			goto out;
 	}


