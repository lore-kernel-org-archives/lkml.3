Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaKRPV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:21:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaKROJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vasily Averin <vvs@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 014/206] ipv4: dst_entry leak in ip_send_unicast_reply()
Date: Tue, 18 Nov 2014 15:06:09 +0100
Message-Id: <d84c3df2a5f2e6847a15c5d7fbdfba86346e67ab.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Averin <vvs@parallels.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 4062090e3e5caaf55bed4523a69f26c3265cc1d2 ]

ip_setup_cork() called inside ip_append_data() steals dst entry from rt to cork
and in case errors in __ip_append_data() nobody frees stolen dst entry

Fixes: 2e77d89b2fa8 ("net: avoid a pair of dst_hold()/dst_release() in ip_append_data()")
Signed-off-by: Vasily Averin <vvs@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ip_output.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c1cb9475fadf..c2dcee28d071 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1478,6 +1478,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	struct sk_buff *nskb;
 	struct sock *sk;
 	struct inet_sock *inet;
+	int err;
 
 	if (ip_options_echo(&replyopts.opt.opt, skb))
 		return;
@@ -1514,8 +1515,13 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
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
@@ -1527,7 +1533,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		skb_set_queue_mapping(nskb, skb_get_queue_mapping(skb));
 		ip_push_pending_frames(sk, &fl4);
 	}
-
+out:
 	put_cpu_var(unicast_sock);
 
 	ip_rt_put(rt);
-- 
2.1.3

