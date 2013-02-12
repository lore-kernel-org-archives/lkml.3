Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab3BLU7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:59:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab3BLUgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Duan Jiong <djduanjiong@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 45/61] ipv6: Add an error handler for icmp6
Date: Tue, 12 Feb 2013 12:35:05 -0800
Message-Id: <20130212203424.117892661@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 6f809da27c94425e07be4a64d5093e1df95188e9 ]

pmtu and redirect events are now handled in the protocols error handler,
so add an error handler for icmp6 to do this. It is needed in the case
when we have no socket context. Based on a patch by Duan Jiong.

Reported-by: Duan Jiong <djduanjiong@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/icmp.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -81,10 +81,22 @@ static inline struct sock *icmpv6_sk(str
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
 


