Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaLOTum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:50:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40629 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaLOT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vasily Averin <vvs@parallels.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 10/96] ipv4: dst_entry leak in ip_send_unicast_reply()
Date: Mon, 15 Dec 2014 11:25:30 -0800
Message-Id: <1418671616-25482-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

[ Upstream commit 4062090e3e5caaf55bed4523a69f26c3265cc1d2 ]

ip_setup_cork() called inside ip_append_data() steals dst entry from rt to cork
and in case errors in __ip_append_data() nobody frees stolen dst entry

Fixes: 2e77d89b2fa8 ("net: avoid a pair of dst_hold()/dst_release() in ip_append_data()")
Signed-off-by: Vasily Averin <vvs@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_output.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 5352214..444d7f3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1488,6 +1488,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	struct sk_buff *nskb;
 	struct sock *sk;
 	struct inet_sock *inet;
+	int err;
 
 	if (ip_options_echo(&replyopts.opt.opt, skb))
 		return;
@@ -1526,8 +1527,13 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
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
@@ -1539,7 +1545,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		skb_set_queue_mapping(nskb, skb_get_queue_mapping(skb));
 		ip_push_pending_frames(sk, &fl4);
 	}
-
+out:
 	put_cpu_var(unicast_sock);
 
 	ip_rt_put(rt);
-- 
1.9.1

