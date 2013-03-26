Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3CZRl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:41:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3CZRgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:31 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=m1r3aOoq-_IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4Nw94-jX0_YA:10 a=7ZN4cI0QAAAA:8 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=r4uQczr2osyquxmZb48A:9 a=Vn2gH7L4UmAA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173610.583409316@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Duan Jiong <djduanjiong@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 67/86] ipv6: Add an error handler for icmp6
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0067-ipv6-Add-an-error-handler-for-icmp6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit cdd6baf1fd9159d9b333938f1717e7c4cba025cc ]

pmtu and redirect events are now handled in the protocols error handler,
so add an error handler for icmp6 to do this. It is needed in the case
when we have no socket context. Based on a patch by Duan Jiong.

Reported-by: Duan Jiong <djduanjiong@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv6/icmp.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 24d69db..4d844d7 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -81,10 +81,22 @@ static inline struct sock *icmpv6_sk(struct net *net)
 	return net->ipv6.icmp_sk[smp_processor_id()];
 }
 
+static void icmpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+		       u8 type, u8 code, int offset, __be32 info)
+{
+	struct net *net = dev_net(skb->dev);
+
+	if (type == ICMPV6_PKT_TOOBIG)
+		ip6_update_pmtu(skb, net, info, 0, 0);
+	else if (type == NDISC_REDIRECT)
+		ip6_redirect(skb, net, 0, 0);
+}
+
 static int icmpv6_rcv(struct sk_buff *skb);
 
 static const struct inet6_protocol icmpv6_protocol = {
 	.handler	=	icmpv6_rcv,
+	.err_handler	=	icmpv6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
 };
 
-- 
1.7.10.4


