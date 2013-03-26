Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3CZRmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:42:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3CZRga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:30 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4JHeR3tA3QcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6GrpG05Fc7EA:10 a=7ZN4cI0QAAAA:8 a=J1Y8HTJGAAAA:8 a=dcFJ2uQ09p7-OfnmQJ8A:9 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173610.895331779@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 69/86] ipv4: Add a socket release callback for datagram sockets
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0069-ipv4-Add-a-socket-release-callback-for-datagram-sock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 1c4fa590068ef4e257cb7b27643a3ee34cf9163b ]

This implements a socket release callback function to check
if the socket cached route got invalid during the time
we owned the socket. The function is used from udp, raw
and ping sockets.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/ip.h    |    2 ++
 net/ipv4/datagram.c |   25 +++++++++++++++++++++++++
 net/ipv4/ping.c     |    1 +
 net/ipv4/raw.c      |    1 +
 net/ipv4/udp.c      |    1 +
 5 files changed, 30 insertions(+)

diff --git a/include/net/ip.h b/include/net/ip.h
index 5a5d84d..2d03843 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -141,6 +141,8 @@ static inline struct sk_buff *ip_finish_skb(struct sock *sk, struct flowi4 *fl4)
 extern int		ip4_datagram_connect(struct sock *sk, 
 					     struct sockaddr *uaddr, int addr_len);
 
+extern void ip4_datagram_release_cb(struct sock *sk);
+
 struct ip_reply_arg {
 	struct kvec iov[1];   
 	int	    flags;
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 424fafb..b28e863 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -85,3 +85,28 @@ out:
 	return err;
 }
 EXPORT_SYMBOL(ip4_datagram_connect);
+
+void ip4_datagram_release_cb(struct sock *sk)
+{
+	const struct inet_sock *inet = inet_sk(sk);
+	const struct ip_options_rcu *inet_opt;
+	__be32 daddr = inet->inet_daddr;
+	struct flowi4 fl4;
+	struct rtable *rt;
+
+	if (! __sk_dst_get(sk) || __sk_dst_check(sk, 0))
+		return;
+
+	rcu_read_lock();
+	inet_opt = rcu_dereference(inet->inet_opt);
+	if (inet_opt && inet_opt->opt.srr)
+		daddr = inet_opt->opt.faddr;
+	rt = ip_route_output_ports(sock_net(sk), &fl4, sk, daddr,
+				   inet->inet_saddr, inet->inet_dport,
+				   inet->inet_sport, sk->sk_protocol,
+				   RT_CONN_FLAGS(sk), sk->sk_bound_dev_if);
+	if (!IS_ERR(rt))
+		__sk_dst_set(sk, &rt->dst);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(ip4_datagram_release_cb);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 920cb0b..af8739a 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -744,6 +744,7 @@ struct proto ping_prot = {
 	.recvmsg =	ping_recvmsg,
 	.bind =		ping_bind,
 	.backlog_rcv =	ping_queue_rcv_skb,
+	.release_cb =	ip4_datagram_release_cb,
 	.hash =		ping_v4_hash,
 	.unhash =	ping_v4_unhash,
 	.get_port =	ping_v4_get_port,
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index d23c657..f9c0d05 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -894,6 +894,7 @@ struct proto raw_prot = {
 	.recvmsg	   = raw_recvmsg,
 	.bind		   = raw_bind,
 	.backlog_rcv	   = raw_rcv_skb,
+	.release_cb	   = ip4_datagram_release_cb,
 	.hash		   = raw_hash_sk,
 	.unhash		   = raw_unhash_sk,
 	.obj_size	   = sizeof(struct raw_sock),
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2814f66..ee4b36a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1952,6 +1952,7 @@ struct proto udp_prot = {
 	.recvmsg	   = udp_recvmsg,
 	.sendpage	   = udp_sendpage,
 	.backlog_rcv	   = __udp_queue_rcv_skb,
+	.release_cb	   = ip4_datagram_release_cb,
 	.hash		   = udp_lib_hash,
 	.unhash		   = udp_lib_unhash,
 	.rehash		   = udp_v4_rehash,
-- 
1.7.10.4


