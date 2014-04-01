Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaDAQs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:48:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaDAQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 18/86] ipv6: reuse ip6_frag_id from ip6_ufo_append_data
Date: Tue,  1 Apr 2014 09:07:31 -0700
Message-Id: <1396368519-12728-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 916e4cf46d0204806c062c8c6c4d1f633852c5b6 ]

Currently we generate a new fragmentation id on UFO segmentation. It
is pretty hairy to identify the correct net namespace and dst there.
Especially tunnels use IFF_XMIT_DST_RELEASE and thus have no skb_dst
available at all.

This causes unreliable or very predictable ipv6 fragmentation id
generation while segmentation.

Luckily we already have pregenerated the ip6_frag_id in
ip6_ufo_append_data and can use it here.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 0c8934a..38bfafd 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -97,7 +97,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 	fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 	fptr->nexthdr = nexthdr;
 	fptr->reserved = 0;
-	ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
+	fptr->identification = skb_shinfo(skb)->ip6_frag_id;
 
 	/* Fragment the skb. ipv6 header and the remaining fields of the
 	 * fragment header are updated in ipv6_gso_segment()
-- 
1.8.3.2

