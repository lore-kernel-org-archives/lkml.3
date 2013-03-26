Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3CZRpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:45:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3CZRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:22 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OjFBmAKG0McA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=LQSPsiOMeM4A:10 a=omOdbC7AAAAA:8 a=J1Y8HTJGAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=X9_5hhBclYR1zl04NXwA:9 a=E6k37eg1NvgA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173613.083335183@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Wei <lw@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 83/86] ipv4: fix error handling in icmp_protocol.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0083-ipv4-fix-error-handling-in-icmp_protocol.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit a426b816575c9701ddcb12a793693dbcbcee5c2b ]

Now we handle icmp errors in each transport protocol's err_handler,
for icmp protocols, that is ping_err. Since this handler only care
of those icmp errors triggered by echo request, errors triggered
by echo reply(which sent by kernel) are sliently ignored.

So wrap ping_err() with icmp_err() to deal with those icmp errors.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/icmp.h |    1 +
 net/ipv4/af_inet.c |    2 +-
 net/ipv4/icmp.c    |   23 +++++++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/icmp.h b/include/net/icmp.h
index 9ac2524..081439f 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -41,6 +41,7 @@ struct net;
 
 extern void	icmp_send(struct sk_buff *skb_in,  int type, int code, __be32 info);
 extern int	icmp_rcv(struct sk_buff *skb);
+extern void	icmp_err(struct sk_buff *, u32 info);
 extern int	icmp_init(void);
 extern void	icmp_out_count(struct net *net, unsigned char type);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 26222ed..dfeb658 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1561,7 +1561,7 @@ static const struct net_protocol udp_protocol = {
 
 static const struct net_protocol icmp_protocol = {
 	.handler =	icmp_rcv,
-	.err_handler =	ping_err,
+	.err_handler =	icmp_err,
 	.no_policy =	1,
 	.netns_ok =	1,
 };
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 17ff9fd..3ac5dff 100644
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
-- 
1.7.10.4


