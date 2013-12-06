Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646Ab3LFWPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:15:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759346Ab3LFVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 24/58] ip6_output: fragment outgoing reassembled skb properly
Date: Fri,  6 Dec 2013 13:51:55 -0800
Message-Id: <20131206214847.159175939@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -150,7 +150,8 @@ static int ip6_finish_output2(struct sk_
 static int ip6_finish_output(struct sk_buff *skb)
 {
 	if ((skb->len > ip6_skb_dst_mtu(skb) && !skb_is_gso(skb)) ||
-	    dst_allfrag(skb_dst(skb)))
+	    dst_allfrag(skb_dst(skb)) ||
+	    (IP6CB(skb)->frag_max_size && skb->len > IP6CB(skb)->frag_max_size))
 		return ip6_fragment(skb, ip6_finish_output2);
 	else
 		return ip6_finish_output2(skb);


