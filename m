Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3EULw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:52:26 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:38847 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909Ab3EULwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:52:24 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 07:52:23 EDT
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <519B5E29.5010605@yandex-team.ru>
Date: Tue, 21 May 2013 15:44:41 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 072/102] ipv6: do not clear pinet6 field
References: <20130517213244.277411019@linuxfoundation.org> <20130517213251.913091371@linuxfoundation.org>
In-Reply-To: <20130517213251.913091371@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

I think, it's good, but not enough.

We still can't rely on the sk->sk_family field by dereferencing the 
inet_sk(sk)->pinet6 field, because we can set the sk_family field to
the PF_INET6 value before setting pinet6 to an appropriate value 
(assuming it is NULL just because it was not a PF_INET6 socket in a 
previous life).

net/ipv6/af_inet6.c:
static int inet6_create(struct net *net, struct socket *sock, int 
protocol, int kern)
{
	<...>
	err = -ENOBUFS;
	sk = sk_alloc(net, PF_INET6, GFP_KERNEL, answer_prot);
	if (sk == NULL)
		goto out;
	<...>
	sk->sk_destruct		= inet_sock_destruct;
	sk->sk_family		= PF_INET6;
	sk->sk_protocol		= protocol;

	sk->sk_backlog_rcv	= answer->prot->backlog_rcv;

	inet_sk(sk)->pinet6 = np = inet6_sk_generic(sk);
	<...>
}

net/core/sock.c:
struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
		      struct proto *prot)
{
	struct sock *sk;

	sk = sk_prot_alloc(prot, priority | __GFP_ZERO, family);
	if (sk) {
		sk->sk_family = family;
	<...>
}


So, we need to care about setting sk_family to PF_INET6 _strictly_ after 
setting the pinet6 field to a valid value (using rcu_assign_pointer(), 
for instance).

Regards,
Roman

On 18.05.2013 01:36, Greg Kroah-Hartman wrote:
> 3.9-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
>
> From: Eric Dumazet <edumazet@google.com>
>
> [ Upstream commit f77d602124d865c38705df7fa25c03de9c284ad2 ]
>
> We have seen multiple NULL dereferences in __inet6_lookup_established()
>
> After analysis, I found that inet6_sk() could be NULL while the
> check for sk_family == AF_INET6 was true.
>
> Bug was added in linux-2.6.29 when RCU lookups were introduced in UDP
> and TCP stacks.
>
> Once an IPv6 socket, using SLAB_DESTROY_BY_RCU is inserted in a hash
> table, we no longer can clear pinet6 field.
>
> This patch extends logic used in commit fcbdf09d9652c891
> ("net: fix nulls list corruptions in sk_prot_alloc")
>
> TCP/UDP/UDPLite IPv6 protocols provide their own .clear_sk() method
> to make sure we do not clear pinet6 field.
>
> At socket clone phase, we do not really care, as cloning the parent (non
> NULL) pinet6 is not adding a fatal race.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   include/net/sock.h  |   12 ++++++++++++
>   net/core/sock.c     |   12 ------------
>   net/ipv6/tcp_ipv6.c |   12 ++++++++++++
>   net/ipv6/udp.c      |   13 ++++++++++++-
>   net/ipv6/udp_impl.h |    2 ++
>   net/ipv6/udplite.c  |    2 +-
>   6 files changed, 39 insertions(+), 14 deletions(-)
>
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -865,6 +865,18 @@ struct inet_hashinfo;
>   struct raw_hashinfo;
>   struct module;
>
> +/*
> + * caches using SLAB_DESTROY_BY_RCU should let .next pointer from nulls nodes
> + * un-modified. Special care is taken when initializing object to zero.
> + */
> +static inline void sk_prot_clear_nulls(struct sock *sk, int size)
> +{
> +	if (offsetof(struct sock, sk_node.next) != 0)
> +		memset(sk, 0, offsetof(struct sock, sk_node.next));
> +	memset(&sk->sk_node.pprev, 0,
> +	       size - offsetof(struct sock, sk_node.pprev));
> +}
> +
>   /* Networking protocol blocks we attach to sockets.
>    * socket layer -> transport layer interface
>    * transport -> network interface is defined by struct inet_proto
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1209,18 +1209,6 @@ static void sock_copy(struct sock *nsk,
>   #endif
>   }
>
> -/*
> - * caches using SLAB_DESTROY_BY_RCU should let .next pointer from nulls nodes
> - * un-modified. Special care is taken when initializing object to zero.
> - */
> -static inline void sk_prot_clear_nulls(struct sock *sk, int size)
> -{
> -	if (offsetof(struct sock, sk_node.next) != 0)
> -		memset(sk, 0, offsetof(struct sock, sk_node.next));
> -	memset(&sk->sk_node.pprev, 0,
> -	       size - offsetof(struct sock, sk_node.pprev));
> -}
> -
>   void sk_prot_clear_portaddr_nulls(struct sock *sk, int size)
>   {
>   	unsigned long nulls1, nulls2;
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1937,6 +1937,17 @@ void tcp6_proc_exit(struct net *net)
>   }
>   #endif
>
> +static void tcp_v6_clear_sk(struct sock *sk, int size)
> +{
> +	struct inet_sock *inet = inet_sk(sk);
> +
> +	/* we do not want to clear pinet6 field, because of RCU lookups */
> +	sk_prot_clear_nulls(sk, offsetof(struct inet_sock, pinet6));
> +
> +	size -= offsetof(struct inet_sock, pinet6) + sizeof(inet->pinet6);
> +	memset(&inet->pinet6 + 1, 0, size);
> +}
> +
>   struct proto tcpv6_prot = {
>   	.name			= "TCPv6",
>   	.owner			= THIS_MODULE,
> @@ -1980,6 +1991,7 @@ struct proto tcpv6_prot = {
>   #ifdef CONFIG_MEMCG_KMEM
>   	.proto_cgroup		= tcp_proto_cgroup,
>   #endif
> +	.clear_sk		= tcp_v6_clear_sk,
>   };
>
>   static const struct inet6_protocol tcpv6_protocol = {
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1422,6 +1422,17 @@ void udp6_proc_exit(struct net *net) {
>   }
>   #endif /* CONFIG_PROC_FS */
>
> +void udp_v6_clear_sk(struct sock *sk, int size)
> +{
> +	struct inet_sock *inet = inet_sk(sk);
> +
> +	/* we do not want to clear pinet6 field, because of RCU lookups */
> +	sk_prot_clear_portaddr_nulls(sk, offsetof(struct inet_sock, pinet6));
> +
> +	size -= offsetof(struct inet_sock, pinet6) + sizeof(inet->pinet6);
> +	memset(&inet->pinet6 + 1, 0, size);
> +}
> +
>   /* ------------------------------------------------------------------------ */
>
>   struct proto udpv6_prot = {
> @@ -1452,7 +1463,7 @@ struct proto udpv6_prot = {
>   	.compat_setsockopt = compat_udpv6_setsockopt,
>   	.compat_getsockopt = compat_udpv6_getsockopt,
>   #endif
> -	.clear_sk	   = sk_prot_clear_portaddr_nulls,
> +	.clear_sk	   = udp_v6_clear_sk,
>   };
>
>   static struct inet_protosw udpv6_protosw = {
> --- a/net/ipv6/udp_impl.h
> +++ b/net/ipv6/udp_impl.h
> @@ -31,6 +31,8 @@ extern int	udpv6_recvmsg(struct kiocb *i
>   extern int	udpv6_queue_rcv_skb(struct sock * sk, struct sk_buff *skb);
>   extern void	udpv6_destroy_sock(struct sock *sk);
>
> +extern void udp_v6_clear_sk(struct sock *sk, int size);
> +
>   #ifdef CONFIG_PROC_FS
>   extern int	udp6_seq_show(struct seq_file *seq, void *v);
>   #endif
> --- a/net/ipv6/udplite.c
> +++ b/net/ipv6/udplite.c
> @@ -56,7 +56,7 @@ struct proto udplitev6_prot = {
>   	.compat_setsockopt = compat_udpv6_setsockopt,
>   	.compat_getsockopt = compat_udpv6_getsockopt,
>   #endif
> -	.clear_sk	   = sk_prot_clear_portaddr_nulls,
> +	.clear_sk	   = udp_v6_clear_sk,
>   };
>
>   static struct inet_protosw udplite6_protosw = {
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

