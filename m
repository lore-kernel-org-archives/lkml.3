Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaK0Iud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:50:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:42995 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224AbaK0Iu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:50:26 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 88/91] ipv6: reuse ip6_frag_id from ip6_ufo_append_data
Date: Thu, 27 Nov 2014 16:43:11 +0800
Message-Id: <1417077794-9299-88-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 916e4cf46d0204806c062c8c6c4d1f633852c5b6 upstream.

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
[bwh: Backported to 3.2: adjust filename, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 98fd738..ef9052f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1366,7 +1366,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 	fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 	fptr->nexthdr = nexthdr;
 	fptr->reserved = 0;
-	ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
+	fptr->identification = skb_shinfo(skb)->ip6_frag_id;
 
 	/* Fragment the skb. ipv6 header and the remaining fields of the
 	 * fragment header are updated in ipv6_gso_segment()
-- 
1.9.1

