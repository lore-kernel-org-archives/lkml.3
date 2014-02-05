Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaBEVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:09:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:54319 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaBEUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 005/213] inet: add RCU protection to inet->opt
Date: Wed, 5 Feb 2014 14:59:20 -0500
Message-ID: <1391630568-49251-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f6d8bd051c391c1c0458a30b2a7abcd939329259 upstream.

We lack proper synchronization to manipulate inet->opt ip_options

Problem is ip_make_skb() calls ip_setup_cork() and
ip_setup_cork() possibly makes a copy of ipc->opt (struct ip_options),
without any protection against another thread manipulating inet->opt.

Another thread can change inet->opt pointer and free old one under us.

Use RCU to protect inet->opt (changed to inet->inet_opt).

Instead of handling atomic refcounts, just copy ip_options when
necessary, to avoid cache line dirtying.

We cant insert an rcu_head in struct ip_options since its included in
skb->cb[], so this patch is large because I had to introduce a new
ip_options_rcu structure.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
[dannf/bwh: backported to Debian's 2.6.32]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
[PG: use 2.6.32 patch, since it is closer to 2.6.34 than original
 baseline; drop net/l2tp/l2tp_ip.c chunk as we don't have that file]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/inet_sock.h         |  14 +++--
 include/net/ip.h                |  11 ++--
 net/dccp/ipv4.c                 |  15 +++---
 net/dccp/ipv6.c                 |   2 +-
 net/ipv4/af_inet.c              |  16 ++++--
 net/ipv4/cipso_ipv4.c           | 113 ++++++++++++++++++++++------------------
 net/ipv4/icmp.c                 |  23 ++++----
 net/ipv4/inet_connection_sock.c |   8 +--
 net/ipv4/ip_options.c           |  38 +++++++-------
 net/ipv4/ip_output.c            |  50 +++++++++---------
 net/ipv4/ip_sockglue.c          |  33 ++++++++----
 net/ipv4/raw.c                  |  19 +++++--
 net/ipv4/syncookies.c           |   4 +-
 net/ipv4/tcp_ipv4.c             |  33 +++++++-----
 net/ipv4/udp.c                  |  21 ++++++--
 net/ipv6/tcp_ipv6.c             |   2 +-
 16 files changed, 235 insertions(+), 167 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 83fd34437cf1..648000dd4b97 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -56,7 +56,15 @@ struct ip_options {
 	unsigned char	__data[0];
 };
 
-#define optlength(opt) (sizeof(struct ip_options) + opt->optlen)
+struct ip_options_rcu {
+	struct rcu_head rcu;
+	struct ip_options opt;
+};
+
+struct ip_options_data {
+	struct ip_options_rcu	opt;
+	char			data[40];
+};
 
 struct inet_request_sock {
 	struct request_sock	req;
@@ -77,7 +85,7 @@ struct inet_request_sock {
 				acked	   : 1,
 				no_srccheck: 1;
 	kmemcheck_bitfield_end(flags);
-	struct ip_options	*opt;
+	struct ip_options_rcu	*opt;
 };
 
 static inline struct inet_request_sock *inet_rsk(const struct request_sock *sk)
@@ -125,7 +133,7 @@ struct inet_sock {
 	__be16			inet_sport;
 	__u16			inet_id;
 
-	struct ip_options	*opt;
+	struct ip_options_rcu	*inet_opt;
 	__u8			tos;
 	__u8			min_ttl;
 	__u8			mc_ttl;
diff --git a/include/net/ip.h b/include/net/ip.h
index 503994a38ed1..ac9506e74c29 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -52,7 +52,7 @@ static inline unsigned int ip_hdrlen(const struct sk_buff *skb)
 struct ipcm_cookie {
 	__be32			addr;
 	int			oif;
-	struct ip_options	*opt;
+	struct ip_options_rcu	*opt;
 	union skb_shared_tx	shtx;
 };
 
@@ -89,7 +89,7 @@ extern int		igmp_mc_proc_init(void);
 
 extern int		ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
 					      __be32 saddr, __be32 daddr,
-					      struct ip_options *opt);
+					      struct ip_options_rcu *opt);
 extern int		ip_rcv(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt, struct net_device *orig_dev);
 extern int		ip_local_deliver(struct sk_buff *skb);
@@ -376,14 +376,15 @@ extern int ip_forward(struct sk_buff *skb);
  *	Functions provided by ip_options.c
  */
  
-extern void ip_options_build(struct sk_buff *skb, struct ip_options *opt, __be32 daddr, struct rtable *rt, int is_frag);
+extern void ip_options_build(struct sk_buff *skb, struct ip_options *opt,
+			     __be32 daddr, struct rtable *rt, int is_frag);
 extern int ip_options_echo(struct ip_options *dopt, struct sk_buff *skb);
 extern void ip_options_fragment(struct sk_buff *skb);
 extern int ip_options_compile(struct net *net,
 			      struct ip_options *opt, struct sk_buff *skb);
-extern int ip_options_get(struct net *net, struct ip_options **optp,
+extern int ip_options_get(struct net *net, struct ip_options_rcu **optp,
 			  unsigned char *data, int optlen);
-extern int ip_options_get_from_user(struct net *net, struct ip_options **optp,
+extern int ip_options_get_from_user(struct net *net, struct ip_options_rcu **optp,
 				    unsigned char __user *data, int optlen);
 extern void ip_options_undo(struct ip_options * opt);
 extern void ip_forward_options(struct sk_buff *skb);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index e072e018b068..d73f17ff95f6 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -48,6 +48,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	__be32 daddr, nexthop;
 	int tmp;
 	int err;
+	struct ip_options_rcu *inet_opt;
 
 	dp->dccps_role = DCCP_ROLE_CLIENT;
 
@@ -58,10 +59,12 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		return -EAFNOSUPPORT;
 
 	nexthop = daddr = usin->sin_addr.s_addr;
-	if (inet->opt != NULL && inet->opt->srr) {
+
+	inet_opt = inet->inet_opt;
+	if (inet_opt != NULL && inet_opt->opt.srr) {
 		if (daddr == 0)
 			return -EINVAL;
-		nexthop = inet->opt->faddr;
+		nexthop = inet_opt->opt.faddr;
 	}
 
 	tmp = ip_route_connect(&rt, nexthop, inet->inet_saddr,
@@ -76,7 +79,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		return -ENETUNREACH;
 	}
 
-	if (inet->opt == NULL || !inet->opt->srr)
+	if (inet_opt == NULL || !inet_opt->opt.srr)
 		daddr = rt->rt_dst;
 
 	if (inet->inet_saddr == 0)
@@ -87,8 +90,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	inet->inet_daddr = daddr;
 
 	inet_csk(sk)->icsk_ext_hdr_len = 0;
-	if (inet->opt != NULL)
-		inet_csk(sk)->icsk_ext_hdr_len = inet->opt->optlen;
+	if (inet_opt)
+		inet_csk(sk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
 	/*
 	 * Socket identity is still unknown (sport may be zero).
 	 * However we set state to DCCP_REQUESTING and not releasing socket
@@ -402,7 +405,7 @@ struct sock *dccp_v4_request_recv_sock(struct sock *sk, struct sk_buff *skb,
 	newinet->inet_daddr	= ireq->rmt_addr;
 	newinet->inet_rcv_saddr = ireq->loc_addr;
 	newinet->inet_saddr	= ireq->loc_addr;
-	newinet->opt	   = ireq->opt;
+	newinet->inet_opt	= ireq->opt;
 	ireq->opt	   = NULL;
 	newinet->mc_index  = inet_iif(skb);
 	newinet->mc_ttl	   = ip_hdr(skb)->ttl;
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fec7de6cfe6e..90f65e1dd4cf 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -600,7 +600,7 @@ static struct sock *dccp_v6_request_recv_sock(struct sock *sk,
 
 	   First: no IPv4 options.
 	 */
-	newinet->opt = NULL;
+	newinet->inet_opt = NULL;
 
 	/* Clone RX bits */
 	newnp->rxopt.all = np->rxopt.all;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8897b3c7d05a..4dd4aad58d93 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -153,7 +153,7 @@ void inet_sock_destruct(struct sock *sk)
 	WARN_ON(sk->sk_wmem_queued);
 	WARN_ON(sk->sk_forward_alloc);
 
-	kfree(inet->opt);
+	kfree(inet->inet_opt);
 	dst_release(sk->sk_dst_cache);
 	sk_refcnt_debug_dec(sk);
 }
@@ -1069,9 +1069,11 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	__be32 old_saddr = inet->inet_saddr;
 	__be32 new_saddr;
 	__be32 daddr = inet->inet_daddr;
+	struct ip_options_rcu *inet_opt;
 
-	if (inet->opt && inet->opt->srr)
-		daddr = inet->opt->faddr;
+	inet_opt = inet->inet_opt;
+	if (inet_opt && inet_opt->opt.srr)
+		daddr = inet_opt->opt.faddr;
 
 	/* Query new route. */
 	err = ip_route_connect(&rt, daddr, 0,
@@ -1113,6 +1115,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 	struct inet_sock *inet = inet_sk(sk);
 	struct rtable *rt = (struct rtable *)__sk_dst_check(sk, 0);
 	__be32 daddr;
+	struct ip_options_rcu *inet_opt;
 	int err;
 
 	/* Route is OK, nothing to do. */
@@ -1120,9 +1123,12 @@ int inet_sk_rebuild_header(struct sock *sk)
 		return 0;
 
 	/* Reroute. */
+	rcu_read_lock();
+	inet_opt = rcu_dereference(inet->inet_opt);
 	daddr = inet->inet_daddr;
-	if (inet->opt && inet->opt->srr)
-		daddr = inet->opt->faddr;
+	if (inet_opt && inet_opt->opt.srr)
+		daddr = inet_opt->opt.faddr;
+	rcu_read_unlock();
 {
 	struct flowi fl = {
 		.oif = sk->sk_bound_dev_if,
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index c97cd9ff697e..d5ef60963183 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1859,6 +1859,11 @@ static int cipso_v4_genopt(unsigned char *buf, u32 buf_len,
 	return CIPSO_V4_HDR_LEN + ret_val;
 }
 
+static void opt_kfree_rcu(struct rcu_head *head)
+{
+	kfree(container_of(head, struct ip_options_rcu, rcu));
+}
+
 /**
  * cipso_v4_sock_setattr - Add a CIPSO option to a socket
  * @sk: the socket
@@ -1881,7 +1886,7 @@ int cipso_v4_sock_setattr(struct sock *sk,
 	unsigned char *buf = NULL;
 	u32 buf_len;
 	u32 opt_len;
-	struct ip_options *opt = NULL;
+	struct ip_options_rcu *old, *opt = NULL;
 	struct inet_sock *sk_inet;
 	struct inet_connection_sock *sk_conn;
 
@@ -1917,22 +1922,25 @@ int cipso_v4_sock_setattr(struct sock *sk,
 		ret_val = -ENOMEM;
 		goto socket_setattr_failure;
 	}
-	memcpy(opt->__data, buf, buf_len);
-	opt->optlen = opt_len;
-	opt->cipso = sizeof(struct iphdr);
+	memcpy(opt->opt.__data, buf, buf_len);
+	opt->opt.optlen = opt_len;
+	opt->opt.cipso = sizeof(struct iphdr);
 	kfree(buf);
 	buf = NULL;
 
 	sk_inet = inet_sk(sk);
+
+	old = sk_inet->inet_opt;
 	if (sk_inet->is_icsk) {
 		sk_conn = inet_csk(sk);
-		if (sk_inet->opt)
-			sk_conn->icsk_ext_hdr_len -= sk_inet->opt->optlen;
-		sk_conn->icsk_ext_hdr_len += opt->optlen;
+		if (old)
+			sk_conn->icsk_ext_hdr_len -= old->opt.optlen;
+		sk_conn->icsk_ext_hdr_len += opt->opt.optlen;
 		sk_conn->icsk_sync_mss(sk, sk_conn->icsk_pmtu_cookie);
 	}
-	opt = xchg(&sk_inet->opt, opt);
-	kfree(opt);
+	rcu_assign_pointer(sk_inet->inet_opt, opt);
+	if (old)
+		call_rcu(&old->rcu, opt_kfree_rcu);
 
 	return 0;
 
@@ -1962,7 +1970,7 @@ int cipso_v4_req_setattr(struct request_sock *req,
 	unsigned char *buf = NULL;
 	u32 buf_len;
 	u32 opt_len;
-	struct ip_options *opt = NULL;
+	struct ip_options_rcu *opt = NULL;
 	struct inet_request_sock *req_inet;
 
 	/* We allocate the maximum CIPSO option size here so we are probably
@@ -1990,15 +1998,16 @@ int cipso_v4_req_setattr(struct request_sock *req,
 		ret_val = -ENOMEM;
 		goto req_setattr_failure;
 	}
-	memcpy(opt->__data, buf, buf_len);
-	opt->optlen = opt_len;
-	opt->cipso = sizeof(struct iphdr);
+	memcpy(opt->opt.__data, buf, buf_len);
+	opt->opt.optlen = opt_len;
+	opt->opt.cipso = sizeof(struct iphdr);
 	kfree(buf);
 	buf = NULL;
 
 	req_inet = inet_rsk(req);
 	opt = xchg(&req_inet->opt, opt);
-	kfree(opt);
+	if (opt)
+		call_rcu(&opt->rcu, opt_kfree_rcu);
 
 	return 0;
 
@@ -2018,34 +2027,34 @@ req_setattr_failure:
  * values on failure.
  *
  */
-static int cipso_v4_delopt(struct ip_options **opt_ptr)
+static int cipso_v4_delopt(struct ip_options_rcu **opt_ptr)
 {
 	int hdr_delta = 0;
-	struct ip_options *opt = *opt_ptr;
+	struct ip_options_rcu *opt = *opt_ptr;
 
-	if (opt->srr || opt->rr || opt->ts || opt->router_alert) {
+	if (opt->opt.srr || opt->opt.rr || opt->opt.ts || opt->opt.router_alert) {
 		u8 cipso_len;
 		u8 cipso_off;
 		unsigned char *cipso_ptr;
 		int iter;
 		int optlen_new;
 
-		cipso_off = opt->cipso - sizeof(struct iphdr);
-		cipso_ptr = &opt->__data[cipso_off];
+		cipso_off = opt->opt.cipso - sizeof(struct iphdr);
+		cipso_ptr = &opt->opt.__data[cipso_off];
 		cipso_len = cipso_ptr[1];
 
-		if (opt->srr > opt->cipso)
-			opt->srr -= cipso_len;
-		if (opt->rr > opt->cipso)
-			opt->rr -= cipso_len;
-		if (opt->ts > opt->cipso)
-			opt->ts -= cipso_len;
-		if (opt->router_alert > opt->cipso)
-			opt->router_alert -= cipso_len;
-		opt->cipso = 0;
+		if (opt->opt.srr > opt->opt.cipso)
+			opt->opt.srr -= cipso_len;
+		if (opt->opt.rr > opt->opt.cipso)
+			opt->opt.rr -= cipso_len;
+		if (opt->opt.ts > opt->opt.cipso)
+			opt->opt.ts -= cipso_len;
+		if (opt->opt.router_alert > opt->opt.cipso)
+			opt->opt.router_alert -= cipso_len;
+		opt->opt.cipso = 0;
 
 		memmove(cipso_ptr, cipso_ptr + cipso_len,
-			opt->optlen - cipso_off - cipso_len);
+			opt->opt.optlen - cipso_off - cipso_len);
 
 		/* determining the new total option length is tricky because of
 		 * the padding necessary, the only thing i can think to do at
@@ -2054,21 +2063,21 @@ static int cipso_v4_delopt(struct ip_options **opt_ptr)
 		 * from there we can determine the new total option length */
 		iter = 0;
 		optlen_new = 0;
-		while (iter < opt->optlen)
-			if (opt->__data[iter] != IPOPT_NOP) {
-				iter += opt->__data[iter + 1];
+		while (iter < opt->opt.optlen)
+			if (opt->opt.__data[iter] != IPOPT_NOP) {
+				iter += opt->opt.__data[iter + 1];
 				optlen_new = iter;
 			} else
 				iter++;
-		hdr_delta = opt->optlen;
-		opt->optlen = (optlen_new + 3) & ~3;
-		hdr_delta -= opt->optlen;
+		hdr_delta = opt->opt.optlen;
+		opt->opt.optlen = (optlen_new + 3) & ~3;
+		hdr_delta -= opt->opt.optlen;
 	} else {
 		/* only the cipso option was present on the socket so we can
 		 * remove the entire option struct */
 		*opt_ptr = NULL;
-		hdr_delta = opt->optlen;
-		kfree(opt);
+		hdr_delta = opt->opt.optlen;
+		call_rcu(&opt->rcu, opt_kfree_rcu);
 	}
 
 	return hdr_delta;
@@ -2085,15 +2094,15 @@ static int cipso_v4_delopt(struct ip_options **opt_ptr)
 void cipso_v4_sock_delattr(struct sock *sk)
 {
 	int hdr_delta;
-	struct ip_options *opt;
+	struct ip_options_rcu *opt;
 	struct inet_sock *sk_inet;
 
 	sk_inet = inet_sk(sk);
-	opt = sk_inet->opt;
-	if (opt == NULL || opt->cipso == 0)
+	opt = sk_inet->inet_opt;
+	if (opt == NULL || opt->opt.cipso == 0)
 		return;
 
-	hdr_delta = cipso_v4_delopt(&sk_inet->opt);
+	hdr_delta = cipso_v4_delopt(&sk_inet->inet_opt);
 	if (sk_inet->is_icsk && hdr_delta > 0) {
 		struct inet_connection_sock *sk_conn = inet_csk(sk);
 		sk_conn->icsk_ext_hdr_len -= hdr_delta;
@@ -2111,12 +2120,12 @@ void cipso_v4_sock_delattr(struct sock *sk)
  */
 void cipso_v4_req_delattr(struct request_sock *req)
 {
-	struct ip_options *opt;
+	struct ip_options_rcu *opt;
 	struct inet_request_sock *req_inet;
 
 	req_inet = inet_rsk(req);
 	opt = req_inet->opt;
-	if (opt == NULL || opt->cipso == 0)
+	if (opt == NULL || opt->opt.cipso == 0)
 		return;
 
 	cipso_v4_delopt(&req_inet->opt);
@@ -2186,14 +2195,18 @@ getattr_return:
  */
 int cipso_v4_sock_getattr(struct sock *sk, struct netlbl_lsm_secattr *secattr)
 {
-	struct ip_options *opt;
+	struct ip_options_rcu *opt;
+	int res = -ENOMSG;
 
-	opt = inet_sk(sk)->opt;
-	if (opt == NULL || opt->cipso == 0)
-		return -ENOMSG;
-
-	return cipso_v4_getattr(opt->__data + opt->cipso - sizeof(struct iphdr),
-				secattr);
+	rcu_read_lock();
+	opt = rcu_dereference(inet_sk(sk)->inet_opt);
+	if (opt && opt->opt.cipso)
+		res = cipso_v4_getattr(opt->opt.__data +
+						opt->opt.cipso -
+						sizeof(struct iphdr),
+				       secattr);
+	rcu_read_unlock();
+	return res;
 }
 
 /**
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index ac4dec132735..4a5137a9e24c 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -108,8 +108,7 @@ struct icmp_bxm {
 		__be32	       times[3];
 	} data;
 	int head_len;
-	struct ip_options replyopts;
-	unsigned char  optbuf[40];
+	struct ip_options_data replyopts;
 };
 
 /* An array of errno for error messages from dest unreach. */
@@ -363,7 +362,7 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 	struct inet_sock *inet;
 	__be32 daddr;
 
-	if (ip_options_echo(&icmp_param->replyopts, skb))
+	if (ip_options_echo(&icmp_param->replyopts.opt.opt, skb))
 		return;
 
 	sk = icmp_xmit_lock(net);
@@ -377,10 +376,10 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 	daddr = ipc.addr = rt->rt_src;
 	ipc.opt = NULL;
 	ipc.shtx.flags = 0;
-	if (icmp_param->replyopts.optlen) {
-		ipc.opt = &icmp_param->replyopts;
-		if (ipc.opt->srr)
-			daddr = icmp_param->replyopts.faddr;
+	if (icmp_param->replyopts.opt.opt.optlen) {
+		ipc.opt = &icmp_param->replyopts.opt;
+		if (ipc.opt->opt.srr)
+			daddr = icmp_param->replyopts.opt.opt.faddr;
 	}
 	{
 		struct flowi fl = { .nl_u = { .ip4_u =
@@ -518,7 +517,7 @@ void icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 					   IPTOS_PREC_INTERNETCONTROL) :
 					  iph->tos;
 
-	if (ip_options_echo(&icmp_param.replyopts, skb_in))
+	if (ip_options_echo(&icmp_param.replyopts.opt.opt, skb_in))
 		goto out_unlock;
 
 
@@ -534,15 +533,15 @@ void icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 	icmp_param.offset = skb_network_offset(skb_in);
 	inet_sk(sk)->tos = tos;
 	ipc.addr = iph->saddr;
-	ipc.opt = &icmp_param.replyopts;
+	ipc.opt = &icmp_param.replyopts.opt;
 	ipc.shtx.flags = 0;
 
 	{
 		struct flowi fl = {
 			.nl_u = {
 				.ip4_u = {
-					.daddr = icmp_param.replyopts.srr ?
-						icmp_param.replyopts.faddr :
+					.daddr = icmp_param.replyopts.opt.opt.srr ?
+						icmp_param.replyopts.opt.opt.faddr :
 						iph->saddr,
 					.saddr = saddr,
 					.tos = RT_TOS(tos)
@@ -631,7 +630,7 @@ route_done:
 	room = dst_mtu(&rt->u.dst);
 	if (room > 576)
 		room = 576;
-	room -= sizeof(struct iphdr) + icmp_param.replyopts.optlen;
+	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
 	room -= sizeof(struct icmphdr);
 
 	icmp_param.data_len = skb_in->len - icmp_param.offset;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 8da6429269dd..9f57d0f75631 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -356,12 +356,12 @@ struct dst_entry *inet_csk_route_req(struct sock *sk,
 {
 	struct rtable *rt;
 	const struct inet_request_sock *ireq = inet_rsk(req);
-	struct ip_options *opt = inet_rsk(req)->opt;
+	struct ip_options_rcu *opt = inet_rsk(req)->opt;
 	struct flowi fl = { .oif = sk->sk_bound_dev_if,
 			    .mark = sk->sk_mark,
 			    .nl_u = { .ip4_u =
-				      { .daddr = ((opt && opt->srr) ?
-						  opt->faddr :
+				      { .daddr = ((opt && opt->opt.srr) ?
+						  opt->opt.faddr :
 						  ireq->rmt_addr),
 					.saddr = ireq->loc_addr,
 					.tos = RT_CONN_FLAGS(sk) } },
@@ -375,7 +375,7 @@ struct dst_entry *inet_csk_route_req(struct sock *sk,
 	security_req_classify_flow(req, &fl);
 	if (ip_route_output_flow(net, &rt, &fl, sk, 0))
 		goto no_route;
-	if (opt && opt->is_strictroute && rt->rt_dst != rt->rt_gateway)
+	if (opt && opt->opt.is_strictroute && rt->rt_dst != rt->rt_gateway)
 		goto route_err;
 	return &rt->u.dst;
 
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 4c09a31fd140..f4281aad1df0 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -36,7 +36,7 @@
  * saddr is address of outgoing interface.
  */
 
-void ip_options_build(struct sk_buff * skb, struct ip_options * opt,
+void ip_options_build(struct sk_buff *skb, struct ip_options *opt,
 			    __be32 daddr, struct rtable *rt, int is_frag)
 {
 	unsigned char *iph = skb_network_header(skb);
@@ -83,9 +83,9 @@ void ip_options_build(struct sk_buff * skb, struct ip_options * opt,
  * NOTE: dopt cannot point to skb.
  */
 
-int ip_options_echo(struct ip_options * dopt, struct sk_buff * skb)
+int ip_options_echo(struct ip_options *dopt, struct sk_buff *skb)
 {
-	struct ip_options *sopt;
+	const struct ip_options *sopt;
 	unsigned char *sptr, *dptr;
 	int soffset, doffset;
 	int	optlen;
@@ -95,10 +95,8 @@ int ip_options_echo(struct ip_options * dopt, struct sk_buff * skb)
 
 	sopt = &(IPCB(skb)->opt);
 
-	if (sopt->optlen == 0) {
-		dopt->optlen = 0;
+	if (sopt->optlen == 0)
 		return 0;
-	}
 
 	sptr = skb_network_header(skb);
 	dptr = dopt->__data;
@@ -157,7 +155,7 @@ int ip_options_echo(struct ip_options * dopt, struct sk_buff * skb)
 		dopt->optlen += optlen;
 	}
 	if (sopt->srr) {
-		unsigned char * start = sptr+sopt->srr;
+		unsigned char *start = sptr+sopt->srr;
 		__be32 faddr;
 
 		optlen  = start[1];
@@ -500,19 +498,19 @@ void ip_options_undo(struct ip_options * opt)
 	}
 }
 
-static struct ip_options *ip_options_get_alloc(const int optlen)
+static struct ip_options_rcu *ip_options_get_alloc(const int optlen)
 {
-	return kzalloc(sizeof(struct ip_options) + ((optlen + 3) & ~3),
+	return kzalloc(sizeof(struct ip_options_rcu) + ((optlen + 3) & ~3),
 		       GFP_KERNEL);
 }
 
-static int ip_options_get_finish(struct net *net, struct ip_options **optp,
-				 struct ip_options *opt, int optlen)
+static int ip_options_get_finish(struct net *net, struct ip_options_rcu **optp,
+				 struct ip_options_rcu *opt, int optlen)
 {
 	while (optlen & 3)
-		opt->__data[optlen++] = IPOPT_END;
-	opt->optlen = optlen;
-	if (optlen && ip_options_compile(net, opt, NULL)) {
+		opt->opt.__data[optlen++] = IPOPT_END;
+	opt->opt.optlen = optlen;
+	if (optlen && ip_options_compile(net, &opt->opt, NULL)) {
 		kfree(opt);
 		return -EINVAL;
 	}
@@ -521,29 +519,29 @@ static int ip_options_get_finish(struct net *net, struct ip_options **optp,
 	return 0;
 }
 
-int ip_options_get_from_user(struct net *net, struct ip_options **optp,
+int ip_options_get_from_user(struct net *net, struct ip_options_rcu **optp,
 			     unsigned char __user *data, int optlen)
 {
-	struct ip_options *opt = ip_options_get_alloc(optlen);
+	struct ip_options_rcu *opt = ip_options_get_alloc(optlen);
 
 	if (!opt)
 		return -ENOMEM;
-	if (optlen && copy_from_user(opt->__data, data, optlen)) {
+	if (optlen && copy_from_user(opt->opt.__data, data, optlen)) {
 		kfree(opt);
 		return -EFAULT;
 	}
 	return ip_options_get_finish(net, optp, opt, optlen);
 }
 
-int ip_options_get(struct net *net, struct ip_options **optp,
+int ip_options_get(struct net *net, struct ip_options_rcu **optp,
 		   unsigned char *data, int optlen)
 {
-	struct ip_options *opt = ip_options_get_alloc(optlen);
+	struct ip_options_rcu *opt = ip_options_get_alloc(optlen);
 
 	if (!opt)
 		return -ENOMEM;
 	if (optlen)
-		memcpy(opt->__data, data, optlen);
+		memcpy(opt->opt.__data, data, optlen);
 	return ip_options_get_finish(net, optp, opt, optlen);
 }
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d52fe4bd573f..e669da63be31 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -138,14 +138,14 @@ static inline int ip_select_ttl(struct inet_sock *inet, struct dst_entry *dst)
  *
  */
 int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
-			  __be32 saddr, __be32 daddr, struct ip_options *opt)
+			  __be32 saddr, __be32 daddr, struct ip_options_rcu *opt)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct rtable *rt = skb_rtable(skb);
 	struct iphdr *iph;
 
 	/* Build the IP header. */
-	skb_push(skb, sizeof(struct iphdr) + (opt ? opt->optlen : 0));
+	skb_push(skb, sizeof(struct iphdr) + (opt ? opt->opt.optlen : 0));
 	skb_reset_network_header(skb);
 	iph = ip_hdr(skb);
 	iph->version  = 4;
@@ -161,9 +161,9 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
 	iph->protocol = sk->sk_protocol;
 	ip_select_ident(iph, &rt->u.dst, sk);
 
-	if (opt && opt->optlen) {
-		iph->ihl += opt->optlen>>2;
-		ip_options_build(skb, opt, daddr, rt, 0);
+	if (opt && opt->opt.optlen) {
+		iph->ihl += opt->opt.optlen>>2;
+		ip_options_build(skb, &opt->opt, daddr, rt, 0);
 	}
 
 	skb->priority = sk->sk_priority;
@@ -315,9 +315,10 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 {
 	struct sock *sk = skb->sk;
 	struct inet_sock *inet = inet_sk(sk);
-	struct ip_options *opt = inet->opt;
+	struct ip_options_rcu *inet_opt = NULL;
 	struct rtable *rt;
 	struct iphdr *iph;
+	int res;
 
 	/* Skip all of this if the packet is already routed,
 	 * f.e. by something like SCTP.
@@ -328,13 +329,15 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 
 	/* Make sure we can route this packet. */
 	rt = (struct rtable *)__sk_dst_check(sk, 0);
+	rcu_read_lock();
+	inet_opt = rcu_dereference(inet->inet_opt);
 	if (rt == NULL) {
 		__be32 daddr;
 
 		/* Use correct destination address if we have options. */
 		daddr = inet->inet_daddr;
-		if(opt && opt->srr)
-			daddr = opt->faddr;
+		if (inet_opt && inet_opt->opt.srr)
+			daddr = inet_opt->opt.faddr;
 
 		{
 			struct flowi fl = { .oif = sk->sk_bound_dev_if,
@@ -362,11 +365,11 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
 	skb_dst_set(skb, dst_clone(&rt->u.dst));
 
 packet_routed:
-	if (opt && opt->is_strictroute && rt->rt_dst != rt->rt_gateway)
+	if (inet_opt && inet_opt->opt.is_strictroute && rt->rt_dst != rt->rt_gateway)
 		goto no_route;
 
 	/* OK, we know where to send it, allocate and build IP header. */
-	skb_push(skb, sizeof(struct iphdr) + (opt ? opt->optlen : 0));
+	skb_push(skb, sizeof(struct iphdr) + (inet_opt ? inet_opt->opt.optlen : 0));
 	skb_reset_network_header(skb);
 	iph = ip_hdr(skb);
 	*((__be16 *)iph) = htons((4 << 12) | (5 << 8) | (inet->tos & 0xff));
@@ -380,9 +383,9 @@ packet_routed:
 	iph->daddr    = rt->rt_dst;
 	/* Transport layer set skb->h.foo itself. */
 
-	if (opt && opt->optlen) {
-		iph->ihl += opt->optlen >> 2;
-		ip_options_build(skb, opt, inet->inet_daddr, rt, 0);
+	if (inet_opt && inet_opt->opt.optlen) {
+		iph->ihl += inet_opt->opt.optlen >> 2;
+		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
 
 	ip_select_ident_more(iph, &rt->u.dst, sk,
@@ -390,10 +393,12 @@ packet_routed:
 
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
-
-	return ip_local_out(skb);
+	res = ip_local_out(skb);
+	rcu_read_unlock();
+	return res;
 
 no_route:
+	rcu_read_unlock();
 	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 	kfree_skb(skb);
 	return -EHOSTUNREACH;
@@ -812,7 +817,7 @@ int ip_append_data(struct sock *sk,
 		/*
 		 * setup for corking.
 		 */
-		opt = ipc->opt;
+		opt = ipc->opt ? &ipc->opt->opt : NULL;
 		if (opt) {
 			if (inet->cork.opt == NULL) {
 				inet->cork.opt = kmalloc(sizeof(struct ip_options) + 40, sk->sk_allocation);
@@ -1371,26 +1376,23 @@ void ip_send_reply(struct sock *sk, struct sk_buff *skb, struct ip_reply_arg *ar
 		   unsigned int len)
 {
 	struct inet_sock *inet = inet_sk(sk);
-	struct {
-		struct ip_options	opt;
-		char			data[40];
-	} replyopts;
+	struct ip_options_data replyopts;
 	struct ipcm_cookie ipc;
 	__be32 daddr;
 	struct rtable *rt = skb_rtable(skb);
 
-	if (ip_options_echo(&replyopts.opt, skb))
+	if (ip_options_echo(&replyopts.opt.opt, skb))
 		return;
 
 	daddr = ipc.addr = rt->rt_src;
 	ipc.opt = NULL;
 	ipc.shtx.flags = 0;
 
-	if (replyopts.opt.optlen) {
+	if (replyopts.opt.opt.optlen) {
 		ipc.opt = &replyopts.opt;
 
-		if (ipc.opt->srr)
-			daddr = replyopts.opt.faddr;
+		if (replyopts.opt.opt.srr)
+			daddr = replyopts.opt.opt.faddr;
 	}
 
 	{
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 1e64dabbd232..e4256fe59a30 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -435,6 +435,11 @@ out:
 }
 
 
+static void opt_kfree_rcu(struct rcu_head *head)
+{
+	kfree(container_of(head, struct ip_options_rcu, rcu));
+}
+
 /*
  *	Socket option code for IP. This is the end of the line after any
  *	TCP,UDP etc options on an IP socket.
@@ -481,13 +486,15 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	switch (optname) {
 	case IP_OPTIONS:
 	{
-		struct ip_options *opt = NULL;
+		struct ip_options_rcu *old, *opt = NULL;
+
 		if (optlen > 40)
 			goto e_inval;
 		err = ip_options_get_from_user(sock_net(sk), &opt,
 					       optval, optlen);
 		if (err)
 			break;
+		old = inet->inet_opt;
 		if (inet->is_icsk) {
 			struct inet_connection_sock *icsk = inet_csk(sk);
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
@@ -496,17 +503,18 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 			       (TCPF_LISTEN | TCPF_CLOSE)) &&
 			     inet->inet_daddr != LOOPBACK4_IPV6)) {
 #endif
-				if (inet->opt)
-					icsk->icsk_ext_hdr_len -= inet->opt->optlen;
+				if (old)
+					icsk->icsk_ext_hdr_len -= old->opt.optlen;
 				if (opt)
-					icsk->icsk_ext_hdr_len += opt->optlen;
+					icsk->icsk_ext_hdr_len += opt->opt.optlen;
 				icsk->icsk_sync_mss(sk, icsk->icsk_pmtu_cookie);
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 			}
 #endif
 		}
-		opt = xchg(&inet->opt, opt);
-		kfree(opt);
+		rcu_assign_pointer(inet->inet_opt, opt);
+		if (old)
+			call_rcu(&old->rcu, opt_kfree_rcu);
 		break;
 	}
 	case IP_PKTINFO:
@@ -1042,12 +1050,15 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_OPTIONS:
 	{
 		unsigned char optbuf[sizeof(struct ip_options)+40];
-		struct ip_options * opt = (struct ip_options *)optbuf;
+		struct ip_options *opt = (struct ip_options *)optbuf;
+		struct ip_options_rcu *inet_opt;
+
+		inet_opt = inet->inet_opt;
 		opt->optlen = 0;
-		if (inet->opt)
-			memcpy(optbuf, inet->opt,
-			       sizeof(struct ip_options)+
-			       inet->opt->optlen);
+		if (inet_opt)
+			memcpy(optbuf, &inet_opt->opt,
+			       sizeof(struct ip_options) +
+			       inet_opt->opt.optlen);
 		release_sock(sk);
 
 		if (opt->optlen == 0)
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index cc6f097fbd5f..d5f57acd6f4b 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -457,6 +457,7 @@ static int raw_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	__be32 saddr;
 	u8  tos;
 	int err;
+	struct ip_options_data opt_copy;
 
 	err = -EMSGSIZE;
 	if (len > 0xFFFF)
@@ -517,8 +518,18 @@ static int raw_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	saddr = ipc.addr;
 	ipc.addr = daddr;
 
-	if (!ipc.opt)
-		ipc.opt = inet->opt;
+	if (!ipc.opt) {
+		struct ip_options_rcu *inet_opt;
+
+		rcu_read_lock();
+		inet_opt = rcu_dereference(inet->inet_opt);
+		if (inet_opt) {
+			memcpy(&opt_copy, inet_opt,
+			       sizeof(*inet_opt) + inet_opt->opt.optlen);
+			ipc.opt = &opt_copy.opt;
+		}
+		rcu_read_unlock();
+	}
 
 	if (ipc.opt) {
 		err = -EINVAL;
@@ -527,10 +538,10 @@ static int raw_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		 */
 		if (inet->hdrincl)
 			goto done;
-		if (ipc.opt->srr) {
+		if (ipc.opt->opt.srr) {
 			if (!daddr)
 				goto done;
-			daddr = ipc.opt->faddr;
+			daddr = ipc.opt->opt.faddr;
 		}
 	}
 	tos = RT_CONN_FLAGS(sk);
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9f6b22206c52..95ac6d7e0f42 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -310,10 +310,10 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
 	 * the ACK carries the same options again (see RFC1122 4.2.3.8)
 	 */
 	if (opt && opt->optlen) {
-		int opt_size = sizeof(struct ip_options) + opt->optlen;
+		int opt_size = sizeof(struct ip_options_rcu) + opt->optlen;
 
 		ireq->opt = kmalloc(opt_size, GFP_ATOMIC);
-		if (ireq->opt != NULL && ip_options_echo(ireq->opt, skb)) {
+		if (ireq->opt != NULL && ip_options_echo(&ireq->opt->opt, skb)) {
 			kfree(ireq->opt);
 			ireq->opt = NULL;
 		}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ab7165565d23..8a0bff623731 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -153,6 +153,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	__be32 daddr, nexthop;
 	int tmp;
 	int err;
+	struct ip_options_rcu *inet_opt;
 
 	if (addr_len < sizeof(struct sockaddr_in))
 		return -EINVAL;
@@ -161,10 +162,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		return -EAFNOSUPPORT;
 
 	nexthop = daddr = usin->sin_addr.s_addr;
-	if (inet->opt && inet->opt->srr) {
+	inet_opt = inet->inet_opt;
+	if (inet_opt && inet_opt->opt.srr) {
 		if (!daddr)
 			return -EINVAL;
-		nexthop = inet->opt->faddr;
+		nexthop = inet_opt->opt.faddr;
 	}
 
 	tmp = ip_route_connect(&rt, nexthop, inet->inet_saddr,
@@ -182,7 +184,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		return -ENETUNREACH;
 	}
 
-	if (!inet->opt || !inet->opt->srr)
+	if (!inet_opt || !inet_opt->opt.srr)
 		daddr = rt->rt_dst;
 
 	if (!inet->inet_saddr)
@@ -216,8 +218,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	inet->inet_daddr = daddr;
 
 	inet_csk(sk)->icsk_ext_hdr_len = 0;
-	if (inet->opt)
-		inet_csk(sk)->icsk_ext_hdr_len = inet->opt->optlen;
+	if (inet_opt)
+		inet_csk(sk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
 
 	tp->rx_opt.mss_clamp = TCP_MSS_DEFAULT;
 
@@ -812,17 +814,18 @@ static void syn_flood_warning(struct sk_buff *skb)
 /*
  * Save and compile IPv4 options into the request_sock if needed.
  */
-static struct ip_options *tcp_v4_save_options(struct sock *sk,
-					      struct sk_buff *skb)
+static struct ip_options_rcu *tcp_v4_save_options(struct sock *sk,
+						  struct sk_buff *skb)
 {
-	struct ip_options *opt = &(IPCB(skb)->opt);
-	struct ip_options *dopt = NULL;
+	const struct ip_options *opt = &(IPCB(skb)->opt);
+	struct ip_options_rcu *dopt = NULL;
 
 	if (opt && opt->optlen) {
-		int opt_size = optlength(opt);
+		int opt_size = sizeof(*dopt) + opt->optlen;
+
 		dopt = kmalloc(opt_size, GFP_ATOMIC);
 		if (dopt) {
-			if (ip_options_echo(dopt, skb)) {
+			if (ip_options_echo(&dopt->opt, skb)) {
 				kfree(dopt);
 				dopt = NULL;
 			}
@@ -1412,6 +1415,7 @@ struct sock *tcp_v4_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key;
 #endif
+	struct ip_options_rcu *inet_opt;
 
 	if (sk_acceptq_is_full(sk))
 		goto exit_overflow;
@@ -1432,13 +1436,14 @@ struct sock *tcp_v4_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 	newinet->inet_daddr   = ireq->rmt_addr;
 	newinet->inet_rcv_saddr = ireq->loc_addr;
 	newinet->inet_saddr	      = ireq->loc_addr;
-	newinet->opt	      = ireq->opt;
+	inet_opt	      = ireq->opt;
+	rcu_assign_pointer(newinet->inet_opt, inet_opt);
 	ireq->opt	      = NULL;
 	newinet->mc_index     = inet_iif(skb);
 	newinet->mc_ttl	      = ip_hdr(skb)->ttl;
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
-	if (newinet->opt)
-		inet_csk(newsk)->icsk_ext_hdr_len = newinet->opt->optlen;
+	if (inet_opt)
+		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
 	newinet->inet_id = newtp->write_seq ^ jiffies;
 
 	tcp_mtup_init(newsk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7932dc68c669..7f0a1ae0544b 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -784,6 +784,7 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	int err, is_udplite = IS_UDPLITE(sk);
 	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
+	struct ip_options_data opt_copy;
 
 	if (len > 0xFFFF)
 		return -EMSGSIZE;
@@ -855,22 +856,32 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			free = 1;
 		connected = 0;
 	}
-	if (!ipc.opt)
-		ipc.opt = inet->opt;
+	if (!ipc.opt) {
+		struct ip_options_rcu *inet_opt;
+
+		rcu_read_lock();
+		inet_opt = rcu_dereference(inet->inet_opt);
+		if (inet_opt) {
+			memcpy(&opt_copy, inet_opt,
+			       sizeof(*inet_opt) + inet_opt->opt.optlen);
+			ipc.opt = &opt_copy.opt;
+		}
+		rcu_read_unlock();
+	}
 
 	saddr = ipc.addr;
 	ipc.addr = faddr = daddr;
 
-	if (ipc.opt && ipc.opt->srr) {
+	if (ipc.opt && ipc.opt->opt.srr) {
 		if (!daddr)
 			return -EINVAL;
-		faddr = ipc.opt->faddr;
+		faddr = ipc.opt->opt.faddr;
 		connected = 0;
 	}
 	tos = RT_TOS(inet->tos);
 	if (sock_flag(sk, SOCK_LOCALROUTE) ||
 	    (msg->msg_flags & MSG_DONTROUTE) ||
-	    (ipc.opt && ipc.opt->is_strictroute)) {
+	    (ipc.opt && ipc.opt->opt.is_strictroute)) {
 		tos |= RTO_ONLINK;
 		connected = 0;
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d854453b4daa..138a2db58bf8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1446,7 +1446,7 @@ static struct sock * tcp_v6_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 
 	   First: no IPv4 options.
 	 */
-	newinet->opt = NULL;
+	newinet->inet_opt = NULL;
 	newnp->ipv6_fl_list = NULL;
 
 	/* Clone RX bits */
-- 
1.8.5.2

