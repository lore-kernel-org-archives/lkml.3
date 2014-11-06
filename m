Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaKFXYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:24:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaKFWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neal Cardwell <ncardwell@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 006/162] tcp: fix tcp_release_cb() to dispatch via address family for mtu_reduced()
Date: Thu,  6 Nov 2014 14:34:30 -0800
Message-Id: <1415313426-9622-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 4fab9071950c2021d846e18351e0f46a1cffd67b ]

Make sure we use the correct address-family-specific function for
handling MTU reductions from within tcp_release_cb().

Previously AF_INET6 sockets were incorrectly always using the IPv6
code path when sometimes they were handling IPv4 traffic and thus had
an IPv4 dst.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Diagnosed-by: Willem de Bruijn <willemb@google.com>
Fixes: 563d34d057862 ("tcp: dont drop MTU reduction indications")
Reviewed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/inet_connection_sock.h | 1 +
 include/net/sock.h                 | 1 -
 include/net/tcp.h                  | 1 +
 net/ipv4/tcp_ipv4.c                | 5 +++--
 net/ipv4/tcp_output.c              | 2 +-
 net/ipv6/tcp_ipv6.c                | 3 ++-
 6 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c55aeed..cf92728 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -62,6 +62,7 @@ struct inet_connection_sock_af_ops {
 	void	    (*addr2sockaddr)(struct sock *sk, struct sockaddr *);
 	int	    (*bind_conflict)(const struct sock *sk,
 				     const struct inet_bind_bucket *tb, bool relax);
+	void	    (*mtu_reduced)(struct sock *sk);
 };
 
 /** inet_connection_sock - INET connection oriented sock
diff --git a/include/net/sock.h b/include/net/sock.h
index 749bad5..5db5b7f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -950,7 +950,6 @@ struct proto {
 						struct sk_buff *skb);
 
 	void		(*release_cb)(struct sock *sk);
-	void		(*mtu_reduced)(struct sock *sk);
 
 	/* Keeping track of sk's, looking them up, and port selection methods. */
 	void			(*hash)(struct sock *sk);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0a00e7c..a9b7191 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -450,6 +450,7 @@ const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
  */
 
 void tcp_v4_send_check(struct sock *sk, struct sk_buff *skb);
+void tcp_v4_mtu_reduced(struct sock *sk);
 int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb);
 struct sock *tcp_create_openreq_child(struct sock *sk,
 				      struct request_sock *req,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 77fe507..9b726c0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -268,7 +268,7 @@ EXPORT_SYMBOL(tcp_v4_connect);
  * It can be called through tcp_release_cb() if socket was owned by user
  * at the time tcp_v4_err() was called to handle ICMP message.
  */
-static void tcp_v4_mtu_reduced(struct sock *sk)
+void tcp_v4_mtu_reduced(struct sock *sk)
 {
 	struct dst_entry *dst;
 	struct inet_sock *inet = inet_sk(sk);
@@ -299,6 +299,7 @@ static void tcp_v4_mtu_reduced(struct sock *sk)
 		tcp_simple_retransmit(sk);
 	} /* else let the usual retransmit timer handle it */
 }
+EXPORT_SYMBOL(tcp_v4_mtu_reduced);
 
 static void do_redirect(struct sk_buff *skb, struct sock *sk)
 {
@@ -2107,6 +2108,7 @@ const struct inet_connection_sock_af_ops ipv4_specific = {
 	.compat_setsockopt = compat_ip_setsockopt,
 	.compat_getsockopt = compat_ip_getsockopt,
 #endif
+	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
 EXPORT_SYMBOL(ipv4_specific);
 
@@ -2721,7 +2723,6 @@ struct proto tcp_prot = {
 	.sendpage		= tcp_sendpage,
 	.backlog_rcv		= tcp_v4_do_rcv,
 	.release_cb		= tcp_release_cb,
-	.mtu_reduced		= tcp_v4_mtu_reduced,
 	.hash			= inet_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fa5b391..f587e1c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -785,7 +785,7 @@ void tcp_release_cb(struct sock *sk)
 		__sock_put(sk);
 	}
 	if (flags & (1UL << TCP_MTU_REDUCED_DEFERRED)) {
-		sk->sk_prot->mtu_reduced(sk);
+		inet_csk(sk)->icsk_af_ops->mtu_reduced(sk);
 		__sock_put(sk);
 	}
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 282874b..d83045c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1640,6 +1640,7 @@ static const struct inet_connection_sock_af_ops ipv6_specific = {
 	.compat_setsockopt = compat_ipv6_setsockopt,
 	.compat_getsockopt = compat_ipv6_getsockopt,
 #endif
+	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -1671,6 +1672,7 @@ static const struct inet_connection_sock_af_ops ipv6_mapped = {
 	.compat_setsockopt = compat_ipv6_setsockopt,
 	.compat_getsockopt = compat_ipv6_getsockopt,
 #endif
+	.mtu_reduced	   = tcp_v6_mtu_reduced,
 };
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -1907,7 +1909,6 @@ struct proto tcpv6_prot = {
 	.sendpage		= tcp_sendpage,
 	.backlog_rcv		= tcp_v6_do_rcv,
 	.release_cb		= tcp_release_cb,
-	.mtu_reduced		= tcp_v6_mtu_reduced,
 	.hash			= tcp_v6_hash,
 	.unhash			= inet_unhash,
 	.get_port		= inet_csk_get_port,
-- 
1.9.1

