Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab3B0AtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:49:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924Ab3BZX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Wei <lw@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 131/150] ipv4: fix error handling in icmp_protocol.
Date: Tue, 26 Feb 2013 15:56:28 -0800
Message-Id: <20130226235537.798080269@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit 5b0520425e5ea81ba95ec486dd6bbb59a09fff0e ]

Now we handle icmp errors in each transport protocol's err_handler,
for icmp protocols, that is ping_err. Since this handler only care
of those icmp errors triggered by echo request, errors triggered
by echo reply(which sent by kernel) are sliently ignored.

So wrap ping_err() with icmp_err() to deal with those icmp errors.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/icmp.h |    1 +
 net/ipv4/af_inet.c |    2 +-
 net/ipv4/icmp.c    |   23 +++++++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -41,6 +41,7 @@ struct net;
 
 extern void	icmp_send(struct sk_buff *skb_in,  int type, int code, __be32 info);
 extern int	icmp_rcv(struct sk_buff *skb);
+extern void	icmp_err(struct sk_buff *, u32 info);
 extern int	icmp_init(void);
 extern void	icmp_out_count(struct net *net, unsigned char type);
 
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1595,7 +1595,7 @@ static const struct net_offload udp_offl
 
 static const struct net_protocol icmp_protocol = {
 	.handler =	icmp_rcv,
-	.err_handler =	ping_err,
+	.err_handler =	icmp_err,
 	.no_policy =	1,
 	.netns_ok =	1,
 };
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -934,6 +934,29 @@ error:
 	goto drop;
 }
 
+void icmp_err(struct sk_buff *skb, u32 info)
+{
+	struct iphdr *iph = (struct iphdr *)skb->data;
+	struct icmphdr *icmph = (struct icmphdr *)(skb->data+(iph->ihl<<2));
+	int type = icmp_hdr(skb)->type;
+	int code = icmp_hdr(skb)->code;
+	struct net *net = dev_net(skb->dev);
+
+	/*
+	 * Use ping_err to handle all icmp errors except those
+	 * triggered by ICMP_ECHOREPLY which sent from kernel.
+	 */
+	if (icmph->type != ICMP_ECHOREPLY) {
+		ping_err(skb, info);
+		return;
+	}
+
+	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED)
+		ipv4_update_pmtu(skb, net, info, 0, 0, IPPROTO_ICMP, 0);
+	else if (type == ICMP_REDIRECT)
+		ipv4_redirect(skb, net, 0, 0, IPPROTO_ICMP, 0);
+}
+
 /*
  *	This table is the definition of how we handle ICMP.
  */


