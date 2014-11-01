Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaKAXDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:03:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60063 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.672686127@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 084/102] ipv6: reuse ip6_frag_id from ip6_ufo_append_data
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

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
---
 net/ipv6/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1362,7 +1362,7 @@ static struct sk_buff *udp6_ufo_fragment
 	fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
 	fptr->nexthdr = nexthdr;
 	fptr->reserved = 0;
-	ipv6_select_ident(fptr, (struct rt6_info *)skb_dst(skb));
+	fptr->identification = skb_shinfo(skb)->ip6_frag_id;
 
 	/* Fragment the skb. ipv6 header and the remaining fields of the
 	 * fragment header are updated in ipv6_gso_segment()

