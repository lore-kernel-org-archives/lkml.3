Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbaCUADZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbaCUADS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 014/149] ipv6: reuse ip6_frag_id from ip6_ufo_append_data
Date: Thu, 20 Mar 2014 17:02:57 -0700
Message-Id: <20140321000437.439946091@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/udp_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -113,7 +113,7 @@ static struct sk_buff *udp6_ufo_fragment
 		fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 		fptr->nexthdr = nexthdr;
 		fptr->reserved = 0;
-		ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
+		fptr->identification = skb_shinfo(skb)->ip6_frag_id;
 
 		/* Fragment the skb. ipv6 header and the remaining fields of the
 		 * fragment header are updated in ipv6_gso_segment()


