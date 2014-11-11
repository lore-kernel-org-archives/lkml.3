Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaKKLtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:49:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbaKKLKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vasily Averin <vvs@parallels.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 073/170] ipv4: dst_entry leak in ip_send_unicast_reply()
Date: Tue, 11 Nov 2014 11:07:12 +0000
Message-Id: <1415704129-12709-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

commit 4062090e3e5caaf55bed4523a69f26c3265cc1d2 upstream.

ip_setup_cork() called inside ip_append_data() steals dst entry from rt to cork
and in case errors in __ip_append_data() nobody frees stolen dst entry

Fixes: 2e77d89b2fa8 ("net: avoid a pair of dst_hold()/dst_release() in ip_append_data()")
Signed-off-by: Vasily Averin <vvs@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_output.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 8d3b6b0e9857..a0ded0ba16ae 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1528,6 +1528,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	struct sk_buff *nskb;
 	struct sock *sk;
 	struct inet_sock *inet;
+	int err;
 
 	if (ip_options_echo(&replyopts.opt.opt, skb))
 		return;
@@ -1567,8 +1568,13 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
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
@@ -1580,7 +1586,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		skb_set_queue_mapping(nskb, skb_get_queue_mapping(skb));
 		ip_push_pending_frames(sk, &fl4);
 	}
-
+out:
 	put_cpu_var(unicast_sock);
 
 	ip_rt_put(rt);
-- 
2.1.0

