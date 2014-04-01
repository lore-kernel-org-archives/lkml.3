Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaDAQJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaDAQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 16/86] net-tcp: fastopen: fix high order allocations
Date: Tue,  1 Apr 2014 09:07:29 -0700
Message-Id: <1396368519-12728-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f5ddcbbb40aa0ba7fbfe22355d287603dbeeaaac ]

This patch fixes two bugs in fastopen :

1) The tcp_sendmsg(...,  @size) argument was ignored.

   Code was relying on user not fooling the kernel with iovec mismatches

2) When MTU is about 64KB, tcp_send_syn_data() attempts order-5
allocations, which are likely to fail when memory gets fragmented.

Fixes: 783237e8daf13 ("net-tcp: Fast Open client - sending SYN-data")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Tested-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/tcp.h     | 3 ++-
 net/ipv4/tcp.c        | 8 +++++---
 net/ipv4/tcp_output.c | 7 ++++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 45f3368..941efe2 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1352,7 +1352,8 @@ struct tcp_fastopen_request {
 	/* Fast Open cookie. Size 0 means a cookie request */
 	struct tcp_fastopen_cookie	cookie;
 	struct msghdr			*data;  /* data in MSG_FASTOPEN */
-	u16				copied;	/* queued in tcp_connect() */
+	size_t				size;
+	int				copied;	/* queued in tcp_connect() */
 };
 void tcp_free_fastopen_req(struct tcp_sock *tp);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8cfdf2b..8b04e4f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1007,7 +1007,8 @@ void tcp_free_fastopen_req(struct tcp_sock *tp)
 	}
 }
 
-static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *size)
+static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
+				int *copied, size_t size)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int err, flags;
@@ -1022,11 +1023,12 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *size)
 	if (unlikely(tp->fastopen_req == NULL))
 		return -ENOBUFS;
 	tp->fastopen_req->data = msg;
+	tp->fastopen_req->size = size;
 
 	flags = (msg->msg_flags & MSG_DONTWAIT) ? O_NONBLOCK : 0;
 	err = __inet_stream_connect(sk->sk_socket, msg->msg_name,
 				    msg->msg_namelen, flags);
-	*size = tp->fastopen_req->copied;
+	*copied = tp->fastopen_req->copied;
 	tcp_free_fastopen_req(tp);
 	return err;
 }
@@ -1046,7 +1048,7 @@ int tcp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 
 	flags = msg->msg_flags;
 	if (flags & MSG_FASTOPEN) {
-		err = tcp_sendmsg_fastopen(sk, msg, &copied_syn);
+		err = tcp_sendmsg_fastopen(sk, msg, &copied_syn, size);
 		if (err == -EINPROGRESS && copied_syn > 0)
 			goto out;
 		else if (err)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index df953b3..0c5b79a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2968,7 +2968,12 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
 		MAX_TCP_OPTION_SPACE;
 
-	syn_data = skb_copy_expand(syn, skb_headroom(syn), space,
+	space = min_t(size_t, space, fo->size);
+
+	/* limit to order-0 allocations */
+	space = min_t(size_t, space, SKB_MAX_HEAD(MAX_TCP_HEADER));
+
+	syn_data = skb_copy_expand(syn, MAX_TCP_HEADER, space,
 				   sk->sk_allocation);
 	if (syn_data == NULL)
 		goto fallback;
-- 
1.8.3.2

