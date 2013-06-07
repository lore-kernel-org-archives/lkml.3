Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3FGGMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:12:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50293 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633Ab3FGGMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:12:13 -0400
Message-ID: <1370585517.4021.94.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 157/184] inet: add RCU protection to inet->opt
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 07 Jun 2013 07:11:57 +0100
In-Reply-To: <20130604172136.807153289@1wt.eu>
References: <20130604172136.807153289@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-clMxhFgyzB8bodF5to7V"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-clMxhFgyzB8bodF5to7V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:24 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Eric Dumazet <eric.dumazet@gmail.com>
>=20
> commit f6d8bd051c391c1c0458a30b2a7abcd939329259 upstream.
>=20
> We lack proper synchronization to manipulate inet->opt ip_options
>=20
> Problem is ip_make_skb() calls ip_setup_cork() and
> ip_setup_cork() possibly makes a copy of ipc->opt (struct ip_options),
> without any protection against another thread manipulating inet->opt.
>=20
> Another thread can change inet->opt pointer and free old one under us.
>=20
> Use RCU to protect inet->opt (changed to inet->inet_opt).
>=20
> Instead of handling atomic refcounts, just copy ip_options when
> necessary, to avoid cache line dirtying.
>=20
> We cant insert an rcu_head in struct ip_options since its included in
> skb->cb[], so this patch is large because I had to introduce a new
> ip_options_rcu structure.
>=20
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [dannf/bwh: backported to Debian's 2.6.32]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  include/net/inet_sock.h         |  14 +++--
>  include/net/ip.h                |  11 ++--
>  net/dccp/ipv4.c                 |  15 +++---
>  net/dccp/ipv6.c                 |   2 +-
>  net/ipv4/af_inet.c              |  16 ++++--
>  net/ipv4/cipso_ipv4.c           | 113 ++++++++++++++++++++++------------=
------
>  net/ipv4/icmp.c                 |  23 ++++----
>  net/ipv4/inet_connection_sock.c |   8 +--
>  net/ipv4/ip_options.c           |  38 +++++++-------
>  net/ipv4/ip_output.c            |  50 +++++++++---------
>  net/ipv4/ip_sockglue.c          |  33 ++++++++----
>  net/ipv4/raw.c                  |  19 +++++--
>  net/ipv4/syncookies.c           |   4 +-
>  net/ipv4/tcp_ipv4.c             |  33 +++++++-----
>  net/ipv4/udp.c                  |  21 ++++++--
>  net/ipv6/tcp_ipv6.c             |   2 +-
>  16 files changed, 235 insertions(+), 167 deletions(-)
>=20
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index 47004f3..cf65e77 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -56,7 +56,15 @@ struct ip_options {
>  	unsigned char	__data[0];
>  };
> =20
> -#define optlength(opt) (sizeof(struct ip_options) + opt->optlen)
> +struct ip_options_rcu {
> +	struct rcu_head rcu;
> +	struct ip_options opt;
> +};
> +
> +struct ip_options_data {
> +	struct ip_options_rcu	opt;
> +	char			data[40];
> +};
> =20
>  struct inet_request_sock {
>  	struct request_sock	req;
> @@ -77,7 +85,7 @@ struct inet_request_sock {
>  				acked	   : 1,
>  				no_srccheck: 1;
>  	kmemcheck_bitfield_end(flags);
> -	struct ip_options	*opt;
> +	struct ip_options_rcu	*opt;
>  };
> =20
>  static inline struct inet_request_sock *inet_rsk(const struct request_so=
ck *sk)
> @@ -122,7 +130,7 @@ struct inet_sock {
>  	__be32			saddr;
>  	__s16			uc_ttl;
>  	__u16			cmsg_flags;
> -	struct ip_options	*opt;
> +	struct ip_options_rcu	*inet_opt;
>  	__be16			sport;
>  	__u16			id;
>  	__u8			tos;
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 69db943..a7d4675 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -54,7 +54,7 @@ struct ipcm_cookie
>  {
>  	__be32			addr;
>  	int			oif;
> -	struct ip_options	*opt;
> +	struct ip_options_rcu	*opt;
>  	union skb_shared_tx	shtx;
>  };
> =20
> @@ -92,7 +92,7 @@ extern int		igmp_mc_proc_init(void);
> =20
>  extern int		ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
>  					      __be32 saddr, __be32 daddr,
> -					      struct ip_options *opt);
> +					      struct ip_options_rcu *opt);
>  extern int		ip_rcv(struct sk_buff *skb, struct net_device *dev,
>  			       struct packet_type *pt, struct net_device *orig_dev);
>  extern int		ip_local_deliver(struct sk_buff *skb);
> @@ -362,14 +362,15 @@ extern int ip_forward(struct sk_buff *skb);
>   *	Functions provided by ip_options.c
>   */
>  =20
> -extern void ip_options_build(struct sk_buff *skb, struct ip_options *opt=
, __be32 daddr, struct rtable *rt, int is_frag);
> +extern void ip_options_build(struct sk_buff *skb, struct ip_options *opt=
,
> +			     __be32 daddr, struct rtable *rt, int is_frag);
>  extern int ip_options_echo(struct ip_options *dopt, struct sk_buff *skb)=
;
>  extern void ip_options_fragment(struct sk_buff *skb);
>  extern int ip_options_compile(struct net *net,
>  			      struct ip_options *opt, struct sk_buff *skb);
> -extern int ip_options_get(struct net *net, struct ip_options **optp,
> +extern int ip_options_get(struct net *net, struct ip_options_rcu **optp,
>  			  unsigned char *data, int optlen);
> -extern int ip_options_get_from_user(struct net *net, struct ip_options *=
*optp,
> +extern int ip_options_get_from_user(struct net *net, struct ip_options_r=
cu **optp,
>  				    unsigned char __user *data, int optlen);
>  extern void ip_options_undo(struct ip_options * opt);
>  extern void ip_forward_options(struct sk_buff *skb);
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index d14c0a3..cef3656 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -47,6 +47,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *u=
addr, int addr_len)
>  	__be32 daddr, nexthop;
>  	int tmp;
>  	int err;
> +	struct ip_options_rcu *inet_opt;
> =20
>  	dp->dccps_role =3D DCCP_ROLE_CLIENT;
> =20
> @@ -57,10 +58,12 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr =
*uaddr, int addr_len)
>  		return -EAFNOSUPPORT;
> =20
>  	nexthop =3D daddr =3D usin->sin_addr.s_addr;
> -	if (inet->opt !=3D NULL && inet->opt->srr) {
> +
> +	inet_opt =3D inet->inet_opt;
> +	if (inet_opt !=3D NULL && inet_opt->opt.srr) {
>  		if (daddr =3D=3D 0)
>  			return -EINVAL;
> -		nexthop =3D inet->opt->faddr;
> +		nexthop =3D inet_opt->opt.faddr;
>  	}
> =20
>  	tmp =3D ip_route_connect(&rt, nexthop, inet->saddr,
> @@ -75,7 +78,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *u=
addr, int addr_len)
>  		return -ENETUNREACH;
>  	}
> =20
> -	if (inet->opt =3D=3D NULL || !inet->opt->srr)
> +	if (inet_opt =3D=3D NULL || !inet_opt->opt.srr)
>  		daddr =3D rt->rt_dst;
> =20
>  	if (inet->saddr =3D=3D 0)
> @@ -86,8 +89,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *u=
addr, int addr_len)
>  	inet->daddr =3D daddr;
> =20
>  	inet_csk(sk)->icsk_ext_hdr_len =3D 0;
> -	if (inet->opt !=3D NULL)
> -		inet_csk(sk)->icsk_ext_hdr_len =3D inet->opt->optlen;
> +	if (inet_opt)
> +		inet_csk(sk)->icsk_ext_hdr_len =3D inet_opt->opt.optlen;
>  	/*
>  	 * Socket identity is still unknown (sport may be zero).
>  	 * However we set state to DCCP_REQUESTING and not releasing socket
> @@ -397,7 +400,7 @@ struct sock *dccp_v4_request_recv_sock(struct sock *s=
k, struct sk_buff *skb,
>  	newinet->daddr	   =3D ireq->rmt_addr;
>  	newinet->rcv_saddr =3D ireq->loc_addr;
>  	newinet->saddr	   =3D ireq->loc_addr;
> -	newinet->opt	   =3D ireq->opt;
> +	newinet->inet_opt	=3D ireq->opt;
>  	ireq->opt	   =3D NULL;
>  	newinet->mc_index  =3D inet_iif(skb);
>  	newinet->mc_ttl	   =3D ip_hdr(skb)->ttl;
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index 9ed1962..2f11de7 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -600,7 +600,7 @@ static struct sock *dccp_v6_request_recv_sock(struct =
sock *sk,
> =20
>  	   First: no IPv4 options.
>  	 */
> -	newinet->opt =3D NULL;
> +	newinet->inet_opt =3D NULL;
> =20
>  	/* Clone RX bits */
>  	newnp->rxopt.all =3D np->rxopt.all;
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index a289878..d1992a4 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -152,7 +152,7 @@ void inet_sock_destruct(struct sock *sk)
>  	WARN_ON(sk->sk_wmem_queued);
>  	WARN_ON(sk->sk_forward_alloc);
> =20
> -	kfree(inet->opt);
> +	kfree(inet->inet_opt);
>  	dst_release(sk->sk_dst_cache);
>  	sk_refcnt_debug_dec(sk);
>  }
> @@ -1065,9 +1065,11 @@ static int inet_sk_reselect_saddr(struct sock *sk)
>  	__be32 old_saddr =3D inet->saddr;
>  	__be32 new_saddr;
>  	__be32 daddr =3D inet->daddr;
> +	struct ip_options_rcu *inet_opt;
> =20
> -	if (inet->opt && inet->opt->srr)
> -		daddr =3D inet->opt->faddr;
> +	inet_opt =3D inet->inet_opt;
> +	if (inet_opt && inet_opt->opt.srr)
> +		daddr =3D inet_opt->opt.faddr;
> =20
>  	/* Query new route. */
>  	err =3D ip_route_connect(&rt, daddr, 0,
> @@ -1109,6 +1111,7 @@ int inet_sk_rebuild_header(struct sock *sk)
>  	struct inet_sock *inet =3D inet_sk(sk);
>  	struct rtable *rt =3D (struct rtable *)__sk_dst_check(sk, 0);
>  	__be32 daddr;
> +	struct ip_options_rcu *inet_opt;
>  	int err;
> =20
>  	/* Route is OK, nothing to do. */
> @@ -1116,9 +1119,12 @@ int inet_sk_rebuild_header(struct sock *sk)
>  		return 0;
> =20
>  	/* Reroute. */
> +	rcu_read_lock();
> +	inet_opt =3D rcu_dereference(inet->inet_opt);
>  	daddr =3D inet->daddr;
> -	if (inet->opt && inet->opt->srr)
> -		daddr =3D inet->opt->faddr;
> +	if (inet_opt && inet_opt->opt.srr)
> +		daddr =3D inet_opt->opt.faddr;
> +	rcu_read_unlock();
>  {
>  	struct flowi fl =3D {
>  		.oif =3D sk->sk_bound_dev_if,
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index 10f8f8d..b6d06d6 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -1860,6 +1860,11 @@ static int cipso_v4_genopt(unsigned char *buf, u32=
 buf_len,
>  	return CIPSO_V4_HDR_LEN + ret_val;
>  }
> =20
> +static void opt_kfree_rcu(struct rcu_head *head)
> +{
> +	kfree(container_of(head, struct ip_options_rcu, rcu));
> +}
> +
>  /**
>   * cipso_v4_sock_setattr - Add a CIPSO option to a socket
>   * @sk: the socket
> @@ -1882,7 +1887,7 @@ int cipso_v4_sock_setattr(struct sock *sk,
>  	unsigned char *buf =3D NULL;
>  	u32 buf_len;
>  	u32 opt_len;
> -	struct ip_options *opt =3D NULL;
> +	struct ip_options_rcu *old, *opt =3D NULL;
>  	struct inet_sock *sk_inet;
>  	struct inet_connection_sock *sk_conn;
> =20
> @@ -1918,22 +1923,25 @@ int cipso_v4_sock_setattr(struct sock *sk,
>  		ret_val =3D -ENOMEM;
>  		goto socket_setattr_failure;
>  	}
> -	memcpy(opt->__data, buf, buf_len);
> -	opt->optlen =3D opt_len;
> -	opt->cipso =3D sizeof(struct iphdr);
> +	memcpy(opt->opt.__data, buf, buf_len);
> +	opt->opt.optlen =3D opt_len;
> +	opt->opt.cipso =3D sizeof(struct iphdr);
>  	kfree(buf);
>  	buf =3D NULL;
> =20
>  	sk_inet =3D inet_sk(sk);
> +
> +	old =3D sk_inet->inet_opt;
>  	if (sk_inet->is_icsk) {
>  		sk_conn =3D inet_csk(sk);
> -		if (sk_inet->opt)
> -			sk_conn->icsk_ext_hdr_len -=3D sk_inet->opt->optlen;
> -		sk_conn->icsk_ext_hdr_len +=3D opt->optlen;
> +		if (old)
> +			sk_conn->icsk_ext_hdr_len -=3D old->opt.optlen;
> +		sk_conn->icsk_ext_hdr_len +=3D opt->opt.optlen;
>  		sk_conn->icsk_sync_mss(sk, sk_conn->icsk_pmtu_cookie);
>  	}
> -	opt =3D xchg(&sk_inet->opt, opt);
> -	kfree(opt);
> +	rcu_assign_pointer(sk_inet->inet_opt, opt);
> +	if (old)
> +		call_rcu(&old->rcu, opt_kfree_rcu);
> =20
>  	return 0;
> =20
> @@ -1963,7 +1971,7 @@ int cipso_v4_req_setattr(struct request_sock *req,
>  	unsigned char *buf =3D NULL;
>  	u32 buf_len;
>  	u32 opt_len;
> -	struct ip_options *opt =3D NULL;
> +	struct ip_options_rcu *opt =3D NULL;
>  	struct inet_request_sock *req_inet;
> =20
>  	/* We allocate the maximum CIPSO option size here so we are probably
> @@ -1991,15 +1999,16 @@ int cipso_v4_req_setattr(struct request_sock *req=
,
>  		ret_val =3D -ENOMEM;
>  		goto req_setattr_failure;
>  	}
> -	memcpy(opt->__data, buf, buf_len);
> -	opt->optlen =3D opt_len;
> -	opt->cipso =3D sizeof(struct iphdr);
> +	memcpy(opt->opt.__data, buf, buf_len);
> +	opt->opt.optlen =3D opt_len;
> +	opt->opt.cipso =3D sizeof(struct iphdr);
>  	kfree(buf);
>  	buf =3D NULL;
> =20
>  	req_inet =3D inet_rsk(req);
>  	opt =3D xchg(&req_inet->opt, opt);
> -	kfree(opt);
> +	if (opt)
> +		call_rcu(&opt->rcu, opt_kfree_rcu);
> =20
>  	return 0;
> =20
> @@ -2019,34 +2028,34 @@ req_setattr_failure:
>   * values on failure.
>   *
>   */
> -int cipso_v4_delopt(struct ip_options **opt_ptr)
> +int cipso_v4_delopt(struct ip_options_rcu **opt_ptr)
>  {
>  	int hdr_delta =3D 0;
> -	struct ip_options *opt =3D *opt_ptr;
> +	struct ip_options_rcu *opt =3D *opt_ptr;
> =20
> -	if (opt->srr || opt->rr || opt->ts || opt->router_alert) {
> +	if (opt->opt.srr || opt->opt.rr || opt->opt.ts || opt->opt.router_alert=
) {
>  		u8 cipso_len;
>  		u8 cipso_off;
>  		unsigned char *cipso_ptr;
>  		int iter;
>  		int optlen_new;
> =20
> -		cipso_off =3D opt->cipso - sizeof(struct iphdr);
> -		cipso_ptr =3D &opt->__data[cipso_off];
> +		cipso_off =3D opt->opt.cipso - sizeof(struct iphdr);
> +		cipso_ptr =3D &opt->opt.__data[cipso_off];
>  		cipso_len =3D cipso_ptr[1];
> =20
> -		if (opt->srr > opt->cipso)
> -			opt->srr -=3D cipso_len;
> -		if (opt->rr > opt->cipso)
> -			opt->rr -=3D cipso_len;
> -		if (opt->ts > opt->cipso)
> -			opt->ts -=3D cipso_len;
> -		if (opt->router_alert > opt->cipso)
> -			opt->router_alert -=3D cipso_len;
> -		opt->cipso =3D 0;
> +		if (opt->opt.srr > opt->opt.cipso)
> +			opt->opt.srr -=3D cipso_len;
> +		if (opt->opt.rr > opt->opt.cipso)
> +			opt->opt.rr -=3D cipso_len;
> +		if (opt->opt.ts > opt->opt.cipso)
> +			opt->opt.ts -=3D cipso_len;
> +		if (opt->opt.router_alert > opt->opt.cipso)
> +			opt->opt.router_alert -=3D cipso_len;
> +		opt->opt.cipso =3D 0;
> =20
>  		memmove(cipso_ptr, cipso_ptr + cipso_len,
> -			opt->optlen - cipso_off - cipso_len);
> +			opt->opt.optlen - cipso_off - cipso_len);
> =20
>  		/* determining the new total option length is tricky because of
>  		 * the padding necessary, the only thing i can think to do at
> @@ -2055,21 +2064,21 @@ int cipso_v4_delopt(struct ip_options **opt_ptr)
>  		 * from there we can determine the new total option length */
>  		iter =3D 0;
>  		optlen_new =3D 0;
> -		while (iter < opt->optlen)
> -			if (opt->__data[iter] !=3D IPOPT_NOP) {
> -				iter +=3D opt->__data[iter + 1];
> +		while (iter < opt->opt.optlen)
> +			if (opt->opt.__data[iter] !=3D IPOPT_NOP) {
> +				iter +=3D opt->opt.__data[iter + 1];
>  				optlen_new =3D iter;
>  			} else
>  				iter++;
> -		hdr_delta =3D opt->optlen;
> -		opt->optlen =3D (optlen_new + 3) & ~3;
> -		hdr_delta -=3D opt->optlen;
> +		hdr_delta =3D opt->opt.optlen;
> +		opt->opt.optlen =3D (optlen_new + 3) & ~3;
> +		hdr_delta -=3D opt->opt.optlen;
>  	} else {
>  		/* only the cipso option was present on the socket so we can
>  		 * remove the entire option struct */
>  		*opt_ptr =3D NULL;
> -		hdr_delta =3D opt->optlen;
> -		kfree(opt);
> +		hdr_delta =3D opt->opt.optlen;
> +		call_rcu(&opt->rcu, opt_kfree_rcu);
>  	}
> =20
>  	return hdr_delta;
> @@ -2086,15 +2095,15 @@ int cipso_v4_delopt(struct ip_options **opt_ptr)
>  void cipso_v4_sock_delattr(struct sock *sk)
>  {
>  	int hdr_delta;
> -	struct ip_options *opt;
> +	struct ip_options_rcu *opt;
>  	struct inet_sock *sk_inet;
> =20
>  	sk_inet =3D inet_sk(sk);
> -	opt =3D sk_inet->opt;
> -	if (opt =3D=3D NULL || opt->cipso =3D=3D 0)
> +	opt =3D sk_inet->inet_opt;
> +	if (opt =3D=3D NULL || opt->opt.cipso =3D=3D 0)
>  		return;
> =20
> -	hdr_delta =3D cipso_v4_delopt(&sk_inet->opt);
> +	hdr_delta =3D cipso_v4_delopt(&sk_inet->inet_opt);
>  	if (sk_inet->is_icsk && hdr_delta > 0) {
>  		struct inet_connection_sock *sk_conn =3D inet_csk(sk);
>  		sk_conn->icsk_ext_hdr_len -=3D hdr_delta;
> @@ -2112,12 +2121,12 @@ void cipso_v4_sock_delattr(struct sock *sk)
>   */
>  void cipso_v4_req_delattr(struct request_sock *req)
>  {
> -	struct ip_options *opt;
> +	struct ip_options_rcu *opt;
>  	struct inet_request_sock *req_inet;
> =20
>  	req_inet =3D inet_rsk(req);
>  	opt =3D req_inet->opt;
> -	if (opt =3D=3D NULL || opt->cipso =3D=3D 0)
> +	if (opt =3D=3D NULL || opt->opt.cipso =3D=3D 0)
>  		return;
> =20
>  	cipso_v4_delopt(&req_inet->opt);
> @@ -2187,14 +2196,18 @@ getattr_return:
>   */
>  int cipso_v4_sock_getattr(struct sock *sk, struct netlbl_lsm_secattr *se=
cattr)
>  {
> -	struct ip_options *opt;
> +	struct ip_options_rcu *opt;
> +	int res =3D -ENOMSG;
> =20
> -	opt =3D inet_sk(sk)->opt;
> -	if (opt =3D=3D NULL || opt->cipso =3D=3D 0)
> -		return -ENOMSG;
> -
> -	return cipso_v4_getattr(opt->__data + opt->cipso - sizeof(struct iphdr)=
,
> -				secattr);
> +	rcu_read_lock();
> +	opt =3D rcu_dereference(inet_sk(sk)->inet_opt);
> +	if (opt && opt->opt.cipso)
> +		res =3D cipso_v4_getattr(opt->opt.__data +
> +						opt->opt.cipso -
> +						sizeof(struct iphdr),
> +				       secattr);
> +	rcu_read_unlock();
> +	return res;
>  }
> =20
>  /**
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 5bc13fe..859d781 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -107,8 +107,7 @@ struct icmp_bxm {
>  		__be32	       times[3];
>  	} data;
>  	int head_len;
> -	struct ip_options replyopts;
> -	unsigned char  optbuf[40];
> +	struct ip_options_data replyopts;
>  };
> =20
>  /* An array of errno for error messages from dest unreach. */
> @@ -362,7 +361,7 @@ static void icmp_reply(struct icmp_bxm *icmp_param, s=
truct sk_buff *skb)
>  	struct inet_sock *inet;
>  	__be32 daddr;
> =20
> -	if (ip_options_echo(&icmp_param->replyopts, skb))
> +	if (ip_options_echo(&icmp_param->replyopts.opt.opt, skb))
>  		return;
> =20
>  	sk =3D icmp_xmit_lock(net);
> @@ -376,10 +375,10 @@ static void icmp_reply(struct icmp_bxm *icmp_param,=
 struct sk_buff *skb)
>  	daddr =3D ipc.addr =3D rt->rt_src;
>  	ipc.opt =3D NULL;
>  	ipc.shtx.flags =3D 0;
> -	if (icmp_param->replyopts.optlen) {
> -		ipc.opt =3D &icmp_param->replyopts;
> -		if (ipc.opt->srr)
> -			daddr =3D icmp_param->replyopts.faddr;
> +	if (icmp_param->replyopts.opt.opt.optlen) {
> +		ipc.opt =3D &icmp_param->replyopts.opt;
> +		if (ipc.opt->opt.srr)
> +			daddr =3D icmp_param->replyopts.opt.opt.faddr;
>  	}
>  	{
>  		struct flowi fl =3D { .nl_u =3D { .ip4_u =3D
> @@ -516,7 +515,7 @@ void icmp_send(struct sk_buff *skb_in, int type, int =
code, __be32 info)
>  					   IPTOS_PREC_INTERNETCONTROL) :
>  					  iph->tos;
> =20
> -	if (ip_options_echo(&icmp_param.replyopts, skb_in))
> +	if (ip_options_echo(&icmp_param.replyopts.opt.opt, skb_in))
>  		goto out_unlock;
> =20
>=20
> @@ -532,15 +531,15 @@ void icmp_send(struct sk_buff *skb_in, int type, in=
t code, __be32 info)
>  	icmp_param.offset =3D skb_network_offset(skb_in);
>  	inet_sk(sk)->tos =3D tos;
>  	ipc.addr =3D iph->saddr;
> -	ipc.opt =3D &icmp_param.replyopts;
> +	ipc.opt =3D &icmp_param.replyopts.opt;
>  	ipc.shtx.flags =3D 0;
> =20
>  	{
>  		struct flowi fl =3D {
>  			.nl_u =3D {
>  				.ip4_u =3D {
> -					.daddr =3D icmp_param.replyopts.srr ?
> -						icmp_param.replyopts.faddr :
> +					.daddr =3D icmp_param.replyopts.opt.opt.srr ?
> +						icmp_param.replyopts.opt.opt.faddr :
>  						iph->saddr,
>  					.saddr =3D saddr,
>  					.tos =3D RT_TOS(tos)
> @@ -629,7 +628,7 @@ route_done:
>  	room =3D dst_mtu(&rt->u.dst);
>  	if (room > 576)
>  		room =3D 576;
> -	room -=3D sizeof(struct iphdr) + icmp_param.replyopts.optlen;
> +	room -=3D sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
>  	room -=3D sizeof(struct icmphdr);
> =20
>  	icmp_param.data_len =3D skb_in->len - icmp_param.offset;
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_s=
ock.c
> index 537731b..a3bf986 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -356,11 +356,11 @@ struct dst_entry *inet_csk_route_req(struct sock *s=
k,
>  {
>  	struct rtable *rt;
>  	const struct inet_request_sock *ireq =3D inet_rsk(req);
> -	struct ip_options *opt =3D inet_rsk(req)->opt;
> +	struct ip_options_rcu *opt =3D inet_rsk(req)->opt;
>  	struct flowi fl =3D { .oif =3D sk->sk_bound_dev_if,
>  			    .nl_u =3D { .ip4_u =3D
> -				      { .daddr =3D ((opt && opt->srr) ?
> -						  opt->faddr :
> +				      { .daddr =3D ((opt && opt->opt.srr) ?
> +						  opt->opt.faddr :
>  						  ireq->rmt_addr),
>  					.saddr =3D ireq->loc_addr,
>  					.tos =3D RT_CONN_FLAGS(sk) } },
> @@ -374,7 +374,7 @@ struct dst_entry *inet_csk_route_req(struct sock *sk,
>  	security_req_classify_flow(req, &fl);
>  	if (ip_route_output_flow(net, &rt, &fl, sk, 0))
>  		goto no_route;
> -	if (opt && opt->is_strictroute && rt->rt_dst !=3D rt->rt_gateway)
> +	if (opt && opt->opt.is_strictroute && rt->rt_dst !=3D rt->rt_gateway)
>  		goto route_err;
>  	return &rt->u.dst;
> =20
> diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
> index 94bf105..8a95972 100644
> --- a/net/ipv4/ip_options.c
> +++ b/net/ipv4/ip_options.c
> @@ -35,7 +35,7 @@
>   * saddr is address of outgoing interface.
>   */
> =20
> -void ip_options_build(struct sk_buff * skb, struct ip_options * opt,
> +void ip_options_build(struct sk_buff *skb, struct ip_options *opt,
>  			    __be32 daddr, struct rtable *rt, int is_frag)
>  {
>  	unsigned char *iph =3D skb_network_header(skb);
> @@ -82,9 +82,9 @@ void ip_options_build(struct sk_buff * skb, struct ip_o=
ptions * opt,
>   * NOTE: dopt cannot point to skb.
>   */
> =20
> -int ip_options_echo(struct ip_options * dopt, struct sk_buff * skb)
> +int ip_options_echo(struct ip_options *dopt, struct sk_buff *skb)
>  {
> -	struct ip_options *sopt;
> +	const struct ip_options *sopt;
>  	unsigned char *sptr, *dptr;
>  	int soffset, doffset;
>  	int	optlen;
> @@ -94,10 +94,8 @@ int ip_options_echo(struct ip_options * dopt, struct s=
k_buff * skb)
> =20
>  	sopt =3D &(IPCB(skb)->opt);
> =20
> -	if (sopt->optlen =3D=3D 0) {
> -		dopt->optlen =3D 0;
> +	if (sopt->optlen =3D=3D 0)
>  		return 0;
> -	}
> =20
>  	sptr =3D skb_network_header(skb);
>  	dptr =3D dopt->__data;
> @@ -156,7 +154,7 @@ int ip_options_echo(struct ip_options * dopt, struct =
sk_buff * skb)
>  		dopt->optlen +=3D optlen;
>  	}
>  	if (sopt->srr) {
> -		unsigned char * start =3D sptr+sopt->srr;
> +		unsigned char *start =3D sptr+sopt->srr;
>  		__be32 faddr;
> =20
>  		optlen  =3D start[1];
> @@ -499,19 +497,19 @@ void ip_options_undo(struct ip_options * opt)
>  	}
>  }
> =20
> -static struct ip_options *ip_options_get_alloc(const int optlen)
> +static struct ip_options_rcu *ip_options_get_alloc(const int optlen)
>  {
> -	return kzalloc(sizeof(struct ip_options) + ((optlen + 3) & ~3),
> +	return kzalloc(sizeof(struct ip_options_rcu) + ((optlen + 3) & ~3),
>  		       GFP_KERNEL);
>  }
> =20
> -static int ip_options_get_finish(struct net *net, struct ip_options **op=
tp,
> -				 struct ip_options *opt, int optlen)
> +static int ip_options_get_finish(struct net *net, struct ip_options_rcu =
**optp,
> +				 struct ip_options_rcu *opt, int optlen)
>  {
>  	while (optlen & 3)
> -		opt->__data[optlen++] =3D IPOPT_END;
> -	opt->optlen =3D optlen;
> -	if (optlen && ip_options_compile(net, opt, NULL)) {
> +		opt->opt.__data[optlen++] =3D IPOPT_END;
> +	opt->opt.optlen =3D optlen;
> +	if (optlen && ip_options_compile(net, &opt->opt, NULL)) {
>  		kfree(opt);
>  		return -EINVAL;
>  	}
> @@ -520,29 +518,29 @@ static int ip_options_get_finish(struct net *net, s=
truct ip_options **optp,
>  	return 0;
>  }
> =20
> -int ip_options_get_from_user(struct net *net, struct ip_options **optp,
> +int ip_options_get_from_user(struct net *net, struct ip_options_rcu **op=
tp,
>  			     unsigned char __user *data, int optlen)
>  {
> -	struct ip_options *opt =3D ip_options_get_alloc(optlen);
> +	struct ip_options_rcu *opt =3D ip_options_get_alloc(optlen);
> =20
>  	if (!opt)
>  		return -ENOMEM;
> -	if (optlen && copy_from_user(opt->__data, data, optlen)) {
> +	if (optlen && copy_from_user(opt->opt.__data, data, optlen)) {
>  		kfree(opt);
>  		return -EFAULT;
>  	}
>  	return ip_options_get_finish(net, optp, opt, optlen);
>  }
> =20
> -int ip_options_get(struct net *net, struct ip_options **optp,
> +int ip_options_get(struct net *net, struct ip_options_rcu **optp,
>  		   unsigned char *data, int optlen)
>  {
> -	struct ip_options *opt =3D ip_options_get_alloc(optlen);
> +	struct ip_options_rcu *opt =3D ip_options_get_alloc(optlen);
> =20
>  	if (!opt)
>  		return -ENOMEM;
>  	if (optlen)
> -		memcpy(opt->__data, data, optlen);
> +		memcpy(opt->opt.__data, data, optlen);
>  	return ip_options_get_finish(net, optp, opt, optlen);
>  }
> =20
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 44b7910..7dde039 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -137,14 +137,14 @@ static inline int ip_select_ttl(struct inet_sock *i=
net, struct dst_entry *dst)
>   *
>   */
>  int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
> -			  __be32 saddr, __be32 daddr, struct ip_options *opt)
> +			  __be32 saddr, __be32 daddr, struct ip_options_rcu *opt)
>  {
>  	struct inet_sock *inet =3D inet_sk(sk);
>  	struct rtable *rt =3D skb_rtable(skb);
>  	struct iphdr *iph;
> =20
>  	/* Build the IP header. */
> -	skb_push(skb, sizeof(struct iphdr) + (opt ? opt->optlen : 0));
> +	skb_push(skb, sizeof(struct iphdr) + (opt ? opt->opt.optlen : 0));
>  	skb_reset_network_header(skb);
>  	iph =3D ip_hdr(skb);
>  	iph->version  =3D 4;
> @@ -160,9 +160,9 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct=
 sock *sk,
>  	iph->protocol =3D sk->sk_protocol;
>  	ip_select_ident(iph, &rt->u.dst, sk);
> =20
> -	if (opt && opt->optlen) {
> -		iph->ihl +=3D opt->optlen>>2;
> -		ip_options_build(skb, opt, daddr, rt, 0);
> +	if (opt && opt->opt.optlen) {
> +		iph->ihl +=3D opt->opt.optlen>>2;
> +		ip_options_build(skb, &opt->opt, daddr, rt, 0);
>  	}
> =20
>  	skb->priority =3D sk->sk_priority;
> @@ -312,9 +312,10 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok)
>  {
>  	struct sock *sk =3D skb->sk;
>  	struct inet_sock *inet =3D inet_sk(sk);
> -	struct ip_options *opt =3D inet->opt;
> +	struct ip_options_rcu *inet_opt =3D NULL;
>  	struct rtable *rt;
>  	struct iphdr *iph;
> +	int res;
> =20
>  	/* Skip all of this if the packet is already routed,
>  	 * f.e. by something like SCTP.
> @@ -325,13 +326,15 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok=
)
> =20
>  	/* Make sure we can route this packet. */
>  	rt =3D (struct rtable *)__sk_dst_check(sk, 0);
> +	rcu_read_lock();
> +	inet_opt =3D rcu_dereference(inet->inet_opt);
>  	if (rt =3D=3D NULL) {
>  		__be32 daddr;
> =20
>  		/* Use correct destination address if we have options. */
>  		daddr =3D inet->daddr;
> -		if(opt && opt->srr)
> -			daddr =3D opt->faddr;
> +		if (inet_opt && inet_opt->opt.srr)
> +			daddr =3D inet_opt->opt.faddr;
> =20
>  		{
>  			struct flowi fl =3D { .oif =3D sk->sk_bound_dev_if,
> @@ -359,11 +362,11 @@ int ip_queue_xmit(struct sk_buff *skb, int ipfragok=
)
>  	skb_dst_set(skb, dst_clone(&rt->u.dst));
> =20
>  packet_routed:
> -	if (opt && opt->is_strictroute && rt->rt_dst !=3D rt->rt_gateway)
> +	if (inet_opt && inet_opt->opt.is_strictroute && rt->rt_dst !=3D rt->rt_=
gateway)
>  		goto no_route;
> =20
>  	/* OK, we know where to send it, allocate and build IP header. */
> -	skb_push(skb, sizeof(struct iphdr) + (opt ? opt->optlen : 0));
> +	skb_push(skb, sizeof(struct iphdr) + (inet_opt ? inet_opt->opt.optlen :=
 0));
>  	skb_reset_network_header(skb);
>  	iph =3D ip_hdr(skb);
>  	*((__be16 *)iph) =3D htons((4 << 12) | (5 << 8) | (inet->tos & 0xff));
> @@ -377,9 +380,9 @@ packet_routed:
>  	iph->daddr    =3D rt->rt_dst;
>  	/* Transport layer set skb->h.foo itself. */
> =20
> -	if (opt && opt->optlen) {
> -		iph->ihl +=3D opt->optlen >> 2;
> -		ip_options_build(skb, opt, inet->daddr, rt, 0);
> +	if (inet_opt && inet_opt->opt.optlen) {
> +		iph->ihl +=3D inet_opt->opt.optlen >> 2;
> +		ip_options_build(skb, &inet_opt->opt, inet->daddr, rt, 0);
>  	}
> =20
>  	ip_select_ident_more(iph, &rt->u.dst, sk,
> @@ -387,10 +390,12 @@ packet_routed:
> =20
>  	skb->priority =3D sk->sk_priority;
>  	skb->mark =3D sk->sk_mark;
> -
> -	return ip_local_out(skb);
> +	res =3D ip_local_out(skb);
> +	rcu_read_unlock();
> +	return res;
> =20
>  no_route:
> +	rcu_read_unlock();
>  	IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
>  	kfree_skb(skb);
>  	return -EHOSTUNREACH;
> @@ -809,7 +814,7 @@ int ip_append_data(struct sock *sk,
>  		/*
>  		 * setup for corking.
>  		 */
> -		opt =3D ipc->opt;
> +		opt =3D ipc->opt ? &ipc->opt->opt : NULL;
>  		if (opt) {
>  			if (inet->cork.opt =3D=3D NULL) {
>  				inet->cork.opt =3D kmalloc(sizeof(struct ip_options) + 40, sk->sk_al=
location);
> @@ -1367,26 +1372,23 @@ void ip_send_reply(struct sock *sk, struct sk_buf=
f *skb, struct ip_reply_arg *ar
>  		   unsigned int len)
>  {
>  	struct inet_sock *inet =3D inet_sk(sk);
> -	struct {
> -		struct ip_options	opt;
> -		char			data[40];
> -	} replyopts;
> +	struct ip_options_data replyopts;
>  	struct ipcm_cookie ipc;
>  	__be32 daddr;
>  	struct rtable *rt =3D skb_rtable(skb);
> =20
> -	if (ip_options_echo(&replyopts.opt, skb))
> +	if (ip_options_echo(&replyopts.opt.opt, skb))
>  		return;
> =20
>  	daddr =3D ipc.addr =3D rt->rt_src;
>  	ipc.opt =3D NULL;
>  	ipc.shtx.flags =3D 0;
> =20
> -	if (replyopts.opt.optlen) {
> +	if (replyopts.opt.opt.optlen) {
>  		ipc.opt =3D &replyopts.opt;
> =20
> -		if (ipc.opt->srr)
> -			daddr =3D replyopts.opt.faddr;
> +		if (replyopts.opt.opt.srr)
> +			daddr =3D replyopts.opt.opt.faddr;
>  	}
> =20
>  	{
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 184a7ad..099e6c3 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -434,6 +434,11 @@ out:
>  }
> =20
>=20
> +static void opt_kfree_rcu(struct rcu_head *head)
> +{
> +	kfree(container_of(head, struct ip_options_rcu, rcu));
> +}
> +
>  /*
>   *	Socket option code for IP. This is the end of the line after any
>   *	TCP,UDP etc options on an IP socket.
> @@ -479,13 +484,15 @@ static int do_ip_setsockopt(struct sock *sk, int le=
vel,
>  	switch (optname) {
>  	case IP_OPTIONS:
>  	{
> -		struct ip_options *opt =3D NULL;
> +		struct ip_options_rcu *old, *opt =3D NULL;
> +
>  		if (optlen > 40 || optlen < 0)
>  			goto e_inval;
>  		err =3D ip_options_get_from_user(sock_net(sk), &opt,
>  					       optval, optlen);
>  		if (err)
>  			break;
> +		old =3D inet->inet_opt;
>  		if (inet->is_icsk) {
>  			struct inet_connection_sock *icsk =3D inet_csk(sk);
>  #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> @@ -494,17 +501,18 @@ static int do_ip_setsockopt(struct sock *sk, int le=
vel,
>  			       (TCPF_LISTEN | TCPF_CLOSE)) &&
>  			     inet->daddr !=3D LOOPBACK4_IPV6)) {
>  #endif
> -				if (inet->opt)
> -					icsk->icsk_ext_hdr_len -=3D inet->opt->optlen;
> +				if (old)
> +					icsk->icsk_ext_hdr_len -=3D old->opt.optlen;
>  				if (opt)
> -					icsk->icsk_ext_hdr_len +=3D opt->optlen;
> +					icsk->icsk_ext_hdr_len +=3D opt->opt.optlen;
>  				icsk->icsk_sync_mss(sk, icsk->icsk_pmtu_cookie);
>  #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
>  			}
>  #endif
>  		}
> -		opt =3D xchg(&inet->opt, opt);
> -		kfree(opt);
> +		rcu_assign_pointer(inet->inet_opt, opt);
> +		if (old)
> +			call_rcu(&old->rcu, opt_kfree_rcu);
>  		break;
>  	}
>  	case IP_PKTINFO:
> @@ -1032,12 +1040,15 @@ static int do_ip_getsockopt(struct sock *sk, int =
level, int optname,
>  	case IP_OPTIONS:
>  	{
>  		unsigned char optbuf[sizeof(struct ip_options)+40];
> -		struct ip_options * opt =3D (struct ip_options *)optbuf;
> +		struct ip_options *opt =3D (struct ip_options *)optbuf;
> +		struct ip_options_rcu *inet_opt;
> +
> +		inet_opt =3D inet->inet_opt;
>  		opt->optlen =3D 0;
> -		if (inet->opt)
> -			memcpy(optbuf, inet->opt,
> -			       sizeof(struct ip_options)+
> -			       inet->opt->optlen);
> +		if (inet_opt)
> +			memcpy(optbuf, &inet_opt->opt,
> +			       sizeof(struct ip_options) +
> +			       inet_opt->opt.optlen);
>  		release_sock(sk);
> =20
>  		if (opt->optlen =3D=3D 0)
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index ab996f9..07ab583 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -459,6 +459,7 @@ static int raw_sendmsg(struct kiocb *iocb, struct soc=
k *sk, struct msghdr *msg,
>  	__be32 saddr;
>  	u8  tos;
>  	int err;
> +	struct ip_options_data opt_copy;
> =20
>  	err =3D -EMSGSIZE;
>  	if (len > 0xFFFF)
> @@ -519,8 +520,18 @@ static int raw_sendmsg(struct kiocb *iocb, struct so=
ck *sk, struct msghdr *msg,
>  	saddr =3D ipc.addr;
>  	ipc.addr =3D daddr;
> =20
> -	if (!ipc.opt)
> -		ipc.opt =3D inet->opt;
> +	if (!ipc.opt) {
> +		struct ip_options_rcu *inet_opt;
> +
> +		rcu_read_lock();
> +		inet_opt =3D rcu_dereference(inet->inet_opt);
> +		if (inet_opt) {
> +			memcpy(&opt_copy, inet_opt,
> +			       sizeof(*inet_opt) + inet_opt->opt.optlen);
> +			ipc.opt =3D &opt_copy.opt;
> +		}
> +		rcu_read_unlock();
> +	}
> =20
>  	if (ipc.opt) {
>  		err =3D -EINVAL;
> @@ -529,10 +540,10 @@ static int raw_sendmsg(struct kiocb *iocb, struct s=
ock *sk, struct msghdr *msg,
>  		 */
>  		if (inet->hdrincl)
>  			goto done;
> -		if (ipc.opt->srr) {
> +		if (ipc.opt->opt.srr) {
>  			if (!daddr)
>  				goto done;
> -			daddr =3D ipc.opt->faddr;
> +			daddr =3D ipc.opt->opt.faddr;
>  		}
>  	}
>  	tos =3D RT_CONN_FLAGS(sk);
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> index a6e0e07..0a94b64 100644
> --- a/net/ipv4/syncookies.c
> +++ b/net/ipv4/syncookies.c
> @@ -309,10 +309,10 @@ struct sock *cookie_v4_check(struct sock *sk, struc=
t sk_buff *skb,
>  	 * the ACK carries the same options again (see RFC1122 4.2.3.8)
>  	 */
>  	if (opt && opt->optlen) {
> -		int opt_size =3D sizeof(struct ip_options) + opt->optlen;
> +		int opt_size =3D sizeof(struct ip_options_rcu) + opt->optlen;
> =20
>  		ireq->opt =3D kmalloc(opt_size, GFP_ATOMIC);
> -		if (ireq->opt !=3D NULL && ip_options_echo(ireq->opt, skb)) {
> +		if (ireq->opt !=3D NULL && ip_options_echo(&ireq->opt->opt, skb)) {
>  			kfree(ireq->opt);
>  			ireq->opt =3D NULL;
>  		}
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 6a4e832..d746d3b3 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -152,6 +152,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *=
uaddr, int addr_len)
>  	__be32 daddr, nexthop;
>  	int tmp;
>  	int err;
> +	struct ip_options_rcu *inet_opt;
> =20
>  	if (addr_len < sizeof(struct sockaddr_in))
>  		return -EINVAL;
> @@ -160,10 +161,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr=
 *uaddr, int addr_len)
>  		return -EAFNOSUPPORT;
> =20
>  	nexthop =3D daddr =3D usin->sin_addr.s_addr;
> -	if (inet->opt && inet->opt->srr) {
> +	inet_opt =3D inet->inet_opt;
> +	if (inet_opt && inet_opt->opt.srr) {
>  		if (!daddr)
>  			return -EINVAL;
> -		nexthop =3D inet->opt->faddr;
> +		nexthop =3D inet_opt->opt.faddr;
>  	}
> =20
>  	tmp =3D ip_route_connect(&rt, nexthop, inet->saddr,
> @@ -181,7 +183,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *=
uaddr, int addr_len)
>  		return -ENETUNREACH;
>  	}
> =20
> -	if (!inet->opt || !inet->opt->srr)
> +	if (!inet_opt || !inet_opt->opt.srr)
>  		daddr =3D rt->rt_dst;
> =20
>  	if (!inet->saddr)
> @@ -215,8 +217,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *=
uaddr, int addr_len)
>  	inet->daddr =3D daddr;
> =20
>  	inet_csk(sk)->icsk_ext_hdr_len =3D 0;
> -	if (inet->opt)
> -		inet_csk(sk)->icsk_ext_hdr_len =3D inet->opt->optlen;
> +	if (inet_opt)
> +		inet_csk(sk)->icsk_ext_hdr_len =3D inet_opt->opt.optlen;
> =20
>  	tp->rx_opt.mss_clamp =3D 536;
> =20
> @@ -802,17 +804,18 @@ static void syn_flood_warning(struct sk_buff *skb)
>  /*
>   * Save and compile IPv4 options into the request_sock if needed.
>   */
> -static struct ip_options *tcp_v4_save_options(struct sock *sk,
> -					      struct sk_buff *skb)
> +static struct ip_options_rcu *tcp_v4_save_options(struct sock *sk,
> +						  struct sk_buff *skb)
>  {
> -	struct ip_options *opt =3D &(IPCB(skb)->opt);
> -	struct ip_options *dopt =3D NULL;
> +	const struct ip_options *opt =3D &(IPCB(skb)->opt);
> +	struct ip_options_rcu *dopt =3D NULL;
> =20
>  	if (opt && opt->optlen) {
> -		int opt_size =3D optlength(opt);
> +		int opt_size =3D sizeof(*dopt) + opt->optlen;
> +
>  		dopt =3D kmalloc(opt_size, GFP_ATOMIC);
>  		if (dopt) {
> -			if (ip_options_echo(dopt, skb)) {
> +			if (ip_options_echo(&dopt->opt, skb)) {
>  				kfree(dopt);
>  				dopt =3D NULL;
>  			}
> @@ -1362,6 +1365,7 @@ struct sock *tcp_v4_syn_recv_sock(struct sock *sk, =
struct sk_buff *skb,
>  #ifdef CONFIG_TCP_MD5SIG
>  	struct tcp_md5sig_key *key;
>  #endif
> +	struct ip_options_rcu *inet_opt;
> =20
>  	if (sk_acceptq_is_full(sk))
>  		goto exit_overflow;
> @@ -1382,13 +1386,14 @@ struct sock *tcp_v4_syn_recv_sock(struct sock *sk=
, struct sk_buff *skb,
>  	newinet->daddr	      =3D ireq->rmt_addr;
>  	newinet->rcv_saddr    =3D ireq->loc_addr;
>  	newinet->saddr	      =3D ireq->loc_addr;
> -	newinet->opt	      =3D ireq->opt;
> +	inet_opt	      =3D ireq->opt;
> +	rcu_assign_pointer(newinet->inet_opt, inet_opt);
>  	ireq->opt	      =3D NULL;
>  	newinet->mc_index     =3D inet_iif(skb);
>  	newinet->mc_ttl	      =3D ip_hdr(skb)->ttl;
>  	inet_csk(newsk)->icsk_ext_hdr_len =3D 0;
> -	if (newinet->opt)
> -		inet_csk(newsk)->icsk_ext_hdr_len =3D newinet->opt->optlen;
> +	if (inet_opt)
> +		inet_csk(newsk)->icsk_ext_hdr_len =3D inet_opt->opt.optlen;
>  	newinet->id =3D newtp->write_seq ^ jiffies;
> =20
>  	tcp_mtup_init(newsk);
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 8e28770..af559e0 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -592,6 +592,7 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, =
struct msghdr *msg,
>  	int err, is_udplite =3D IS_UDPLITE(sk);
>  	int corkreq =3D up->corkflag || msg->msg_flags&MSG_MORE;
>  	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
> +	struct ip_options_data opt_copy;
> =20
>  	if (len > 0xFFFF)
>  		return -EMSGSIZE;
> @@ -663,22 +664,32 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk=
, struct msghdr *msg,
>  			free =3D 1;
>  		connected =3D 0;
>  	}
> -	if (!ipc.opt)
> -		ipc.opt =3D inet->opt;
> +	if (!ipc.opt) {
> +		struct ip_options_rcu *inet_opt;
> +
> +		rcu_read_lock();
> +		inet_opt =3D rcu_dereference(inet->inet_opt);
> +		if (inet_opt) {
> +			memcpy(&opt_copy, inet_opt,
> +			       sizeof(*inet_opt) + inet_opt->opt.optlen);
> +			ipc.opt =3D &opt_copy.opt;
> +		}
> +		rcu_read_unlock();
> +	}
> =20
>  	saddr =3D ipc.addr;
>  	ipc.addr =3D faddr =3D daddr;
> =20
> -	if (ipc.opt && ipc.opt->srr) {
> +	if (ipc.opt && ipc.opt->opt.srr) {
>  		if (!daddr)
>  			return -EINVAL;
> -		faddr =3D ipc.opt->faddr;
> +		faddr =3D ipc.opt->opt.faddr;
>  		connected =3D 0;
>  	}
>  	tos =3D RT_TOS(inet->tos);
>  	if (sock_flag(sk, SOCK_LOCALROUTE) ||
>  	    (msg->msg_flags & MSG_DONTROUTE) ||
> -	    (ipc.opt && ipc.opt->is_strictroute)) {
> +	    (ipc.opt && ipc.opt->opt.is_strictroute)) {
>  		tos |=3D RTO_ONLINK;
>  		connected =3D 0;
>  	}
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index faae6df..1b25191 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1391,7 +1391,7 @@ static struct sock * tcp_v6_syn_recv_sock(struct so=
ck *sk, struct sk_buff *skb,
> =20
>  	   First: no IPv4 options.
>  	 */
> -	newinet->opt =3D NULL;
> +	newinet->inet_opt =3D NULL;
>  	newnp->ipv6_fl_list =3D NULL;
> =20
>  	/* Clone RX bits */

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-clMxhFgyzB8bodF5to7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF5ree/yOyVhhEJAQrzBhAAp07BSIAH6HKlInZN3eCx0xVDUIQ8R7Tl
AMnAwxe+6TuWQB/eN0XeMzilEhtnmmbEP6NF/TaEeCGLBUTlwQHmISXr+sq+R0An
gBNQuuGDVylpOwQq9DobW0G4AegJO7a8OrzxFtN/F2orb0G0w0x29w8oeM819GNf
AtZAsXC6Oe3k+YVb0uGVx7thYWccaRBiUfj1QZdhlfv3ofk8EKBeqsuouj8Fu4al
O1bg0OqI7w53XjcjTKw3uSBkFfdiTHbMgRmzb5FiaAh3t7HFE7sTcUuVw4DfzS6n
9P3Znfcz55VuJdSFrD4U77S5I8uIFPK2fwwrzFIkzVeBcP8gWRlm/pcfpwwnLqO+
BnSl5GXglwwYg/jNnBw6P148DOFu1JGCZdpzSJkUWdZNWbRSxtl6waovEmwMHPnQ
afUNiKVYj0u4fuKN5b2wICvgSVxS4sPEi2pFyPTMXgtkTLo79hJb/Wkqd6H48em/
sUb0lWrSIpDQ5UXPUASrHdnK+rt6KQvUJ9Peo6Eh3DrIjXZaM5oTcYQLfvZ7YeTN
62VlEAgRbi0jrT6t2BfrXD10EZN0dsy9Ums1BB8Uo8hvbdvKkw1Fwv+GEVMJN+6t
+dw+nFP4Eh7WlN7unvB4WOKxyFCNxhJR6ZPRojz4LtRLfr7c90oa3YkPDAjjVQks
/fh4pSjwtLc=
=vu9K
-----END PGP SIGNATURE-----

--=-clMxhFgyzB8bodF5to7V--
