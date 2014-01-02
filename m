Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaABRbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:31:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaABRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:05:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 23/91] ip6_output: fragment outgoing reassembled skb properly
Date: Thu,  2 Jan 2014 09:03:58 -0800
Message-Id: <1388682306-30859-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 9037c3579a277f3a23ba476664629fda8c35f7c4 ]

If reassembled packet would fit into outdev MTU, it is not fragmented
according the original frag size and it is send as single big packet.

The second case is if skb is gso. In that case fragmentation does not happen
according to the original frag size.

This patch fixes these.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f477a89..ac9f072 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -137,7 +137,8 @@ static int ip6_finish_output2(struct sk_buff *skb)
 static int ip6_finish_output(struct sk_buff *skb)
 {
 	if ((skb->len > ip6_skb_dst_mtu(skb) && !skb_is_gso(skb)) ||
-	    dst_allfrag(skb_dst(skb)))
+	    dst_allfrag(skb_dst(skb)) ||
+	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size))
 		return ip6_fragment(skb, ip6_finish_output2);
 	else
 		return ip6_finish_output2(skb);
-- 
1.8.3.2

