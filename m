Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab3D2Tg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:36:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab3D2TCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetja Rediske <tetja@tetja.de>,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/42] ipv6/tcp: Stop processing ICMPv6 redirect messages
Date: Mon, 29 Apr 2013 12:02:10 -0700
Message-Id: <20130429184755.580448511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/tcp_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -386,6 +386,7 @@ static void tcp_v6_err(struct sk_buff *s
 
 		if (dst)
 			dst->ops->redirect(dst, sk, skb);
+		goto out;
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {


