Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab3EGEmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:42:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397Ab3EGEZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:40 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=es_H3TPfWpUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OsLbe8JIIzwA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=d9YRrWtWQv8A:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=xvxNnXW-FLBYY3KN:21 a=UfhJlHQTGZlnZo-h:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035900.335720552@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tetja Rediske <tetja@tetja.de>,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [116/126] ipv6/tcp: Stop processing ICMPv6 redirect messages
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0116-ipv6-tcp-Stop-processing-ICMPv6-redirect-messages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <christoph.paasch@uclouvain.be>

[ Upstream commit 50a75a8914539c5dcd441c5f54d237a666a426fd ]

Tetja Rediske found that if the host receives an ICMPv6 redirect message
after sending a SYN+ACK, the connection will be reset.

He bisected it down to 093d04d (ipv6: Change skb->data before using
icmpv6_notify() to propagate redirect), but the origin of the bug comes
from ec18d9a26 (ipv6: Add redirect support to all protocol icmp error
handlers.). The bug simply did not trigger prior to 093d04d, because
skb->data did not point to the inner IP header and thus icmpv6_notify
did not call the correct err_handler.

This patch adds the missing "goto out;" in tcp_v6_err. After receiving
an ICMPv6 Redirect, we should not continue processing the ICMP in
tcp_v6_err, as this may trigger the removal of request-socks or setting
sk_err(_soft).

Reported-by: Tetja Rediske <tetja@tetja.de>
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv6/tcp_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index fe48fc9..e3eec75 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -397,6 +397,7 @@ static void tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 		if (dst)
 			dst->ops->redirect(dst, sk, skb);
+		goto out;
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
-- 
1.7.10.4


