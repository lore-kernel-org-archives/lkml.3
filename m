Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaKLERv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:17:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaKLBVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:21:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vasily Averin <vvs@parallels.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 008/319] ipv4: dst_entry leak in ip_send_unicast_reply()
Date: Wed, 12 Nov 2014 10:12:26 +0900
Message-Id: <20141112010954.045300679@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

[ Upstream commit 4062090e3e5caaf55bed4523a69f26c3265cc1d2 ]

ip_setup_cork() called inside ip_append_data() steals dst entry from rt to cork
and in case errors in __ip_append_data() nobody frees stolen dst entry

Fixes: 2e77d89b2fa8 ("net: avoid a pair of dst_hold()/dst_release() in ip_append_data()")
Signed-off-by: Vasily Averin <vvs@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1533,6 +1533,7 @@ void ip_send_unicast_reply(struct net *n
 	struct sk_buff *nskb;
 	struct sock *sk;
 	struct inet_sock *inet;
+	int err;
 
 	if (ip_options_echo(&replyopts.opt.opt, skb))
 		return;
@@ -1572,8 +1573,13 @@ void ip_send_unicast_reply(struct net *n
 	sock_net_set(sk, net);
 	__skb_queue_head_init(&sk->sk_write_queue);
 	sk->sk_sndbuf = sysctl_wmem_default;
-	ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base, len, 0,
-		       &ipc, &rt, MSG_DONTWAIT);
+	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
+			     len, 0, &ipc, &rt, MSG_DONTWAIT);
+	if (unlikely(err)) {
+		ip_flush_pending_frames(sk);
+		goto out;
+	}
+
 	nskb = skb_peek(&sk->sk_write_queue);
 	if (nskb) {
 		if (arg->csumoffset >= 0)
@@ -1585,7 +1591,7 @@ void ip_send_unicast_reply(struct net *n
 		skb_set_queue_mapping(nskb, skb_get_queue_mapping(skb));
 		ip_push_pending_frames(sk, &fl4);
 	}
-
+out:
 	put_cpu_var(unicast_sock);
 
 	ip_rt_put(rt);


